{
  config,
  lib,
  pkgs,
  chilla-pkg ? null,
  ...
}:

let
  cfg = config.taco.yazi;
  chillaCommand = if chilla-pkg == null then cfg.openCommand else "${chilla-pkg}/bin/chilla";
  enterDirectoryPlugin = ''
    --- @sync entry
    local function entry()
      local hovered = cx.active.current.hovered

      if hovered and hovered.cha.is_dir then
        ya.emit("cd", { hovered.url })
        ya.emit("quit", {})
        return
      end

      ya.emit("open", { hovered = true })
    end

    return { entry = entry }
  '';
  gruvboxDarkFlavorSource = pkgs.fetchFromGitHub {
    owner = "bennyyip";
    repo = "gruvbox-dark.yazi";
    rev = "619fdc5844db0c04f6115a62cf218e707de2821e";
    hash = "sha256-Y/i+eS04T2+Sg/Z7/CGbuQHo5jxewXIgORTQm25uQb4=";
  };
  gruvboxBaseFlavor = pkgs.runCommandLocal "gruvboxbase.yazi" { } ''
    mkdir -p "$out"
    cp -r ${gruvboxDarkFlavorSource}/. "$out/"
  '';
  nvimPaneOpener = pkgs.writeShellApplication {
    name = "nvim-pane-open";
    text = ''
      set -euo pipefail

      file_path="''${1:-}"

      if [[ -z "$file_path" ]]; then
        exit 0
      fi

      editor_escape() {
        local escaped

        escaped="$1"
        escaped="''${escaped//\\/\\\\}"
        escaped="''${escaped//\"/\\\"}"
        printf '%s' "$escaped"
      }

      shell_escape() {
        printf '%q' "$1"
      }

      parent_dir() {
        local target

        target="$1"
        ${pkgs.coreutils}/bin/dirname -- "$target"
      }

      open_with_nvim() {
        local target_file target_dir

        target_file="$1"
        target_dir="$(parent_dir "$target_file")"
        cd -- "$target_dir"
        exec nvim -- "$target_file"
      }

      tmux_pane_is_nvim() {
        [[ "$1" == "nvim" ]]
      }

      reset_tmux_pane_to_shell() {
        local target_pane target_dir shell_path

        target_pane="$1"
        target_dir="$2"
        shell_path="''${SHELL:-${pkgs.fish}/bin/fish}"

        ${pkgs.tmux}/bin/tmux respawn-pane -k -t "$target_pane" -c "$target_dir" "$shell_path -l"
      }

      open_in_tmux_directory() {
        local target_dir target_pane pane_command

        target_dir="$1"
        target_pane="$2"
        pane_command="$3"

        if tmux_pane_is_nvim "$pane_command"; then
          reset_tmux_pane_to_shell "$target_pane" "$target_dir"
          return
        fi

        ${pkgs.tmux}/bin/tmux send-keys -t "$target_pane" C-c
        ${pkgs.tmux}/bin/tmux send-keys -t "$target_pane" "cd -- $(shell_escape "$target_dir")"
        ${pkgs.tmux}/bin/tmux send-keys -t "$target_pane" Enter
      }

      open_in_tmux_file() {
        local target_file target_dir pane_command

        target_file="$1"
        target_dir="$(parent_dir "$target_file")"
        pane_command="$2"

        if tmux_pane_is_nvim "$pane_command"; then
          reset_tmux_pane_to_shell "$TACO_TMUX_EDITOR_PANE" "$target_dir"
        fi

        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" C-c
        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" "cd -- $(shell_escape "$target_dir")"
        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" Enter
        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" "nvim -- $(shell_escape "$target_file")"
        ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_EDITOR_PANE" Enter
      }

      mime_info="$(${pkgs.file}/bin/file -bL --mime -- "$file_path" 2>/dev/null || true)"

      if [[ "$mime_info" == *"charset=binary"* ]]; then
        exec ${cfg.openCommand} "$file_path"
      fi

      if [[ "''${TACO_IDE_LAYOUT:-0}" != "1" ]]; then
        open_with_nvim "$file_path"
      fi

      if [[ -n "''${ZELLIJ:-}" ]]; then
        escaped_path="$(editor_escape "$file_path")"
        escaped_dir="$(editor_escape "$(parent_dir "$file_path")")"

        if ! ${pkgs.zellij}/bin/zellij action move-focus right >/dev/null 2>&1; then
          open_with_nvim "$file_path"
        fi

        ${pkgs.zellij}/bin/zellij action write 27
        ${pkgs.zellij}/bin/zellij action write-chars ":cd \"$escaped_dir\""
        ${pkgs.zellij}/bin/zellij action write 13
        ${pkgs.zellij}/bin/zellij action write-chars ":open \"$escaped_path\""
        ${pkgs.zellij}/bin/zellij action write 13
        ${pkgs.zellij}/bin/zellij action move-focus left >/dev/null 2>&1 || true
        exit 0
      fi

      if [[ -n "''${TMUX:-}" && -n "''${TACO_TMUX_EDITOR_PANE:-}" ]]; then
        pane_command="$(${pkgs.tmux}/bin/tmux display-message -p -t "$TACO_TMUX_EDITOR_PANE" '#{pane_current_command}' 2>/dev/null || true)"

        if [[ -z "$pane_command" ]]; then
          open_with_nvim "$file_path"
        fi

        if [[ -d "$file_path" ]]; then
          target_pane="''${TACO_TMUX_DIRECTORY_PANE:-$TACO_TMUX_EDITOR_PANE}"
          target_pane_command="$(${pkgs.tmux}/bin/tmux display-message -p -t "$target_pane" '#{pane_current_command}' 2>/dev/null || true)"

          if [[ -z "$target_pane_command" ]]; then
            target_pane="$TACO_TMUX_EDITOR_PANE"
            target_pane_command="$pane_command"
          fi

          open_in_tmux_directory "$file_path" "$target_pane" "$target_pane_command"
          exit 0
        fi

        open_in_tmux_file "$file_path" "$pane_command"
        exit 0
      fi

      open_with_nvim "$file_path"
    '';
  };
  directoryTerminalOpener = pkgs.writeShellApplication {
    name = "yazi-open-terminal";
    text =
      if pkgs.stdenv.hostPlatform.isDarwin then
        ''
          set -euo pipefail

          for target_path in "$@"; do
            if [[ -d "$target_path" ]]; then
              if [[ -n "''${TMUX:-}" && -n "''${TACO_TMUX_DIRECTORY_PANE:-}" ]]; then
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" C-c
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" "cd -- $(printf '%q' "$target_path")"
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" Enter
                continue
              fi

              /usr/bin/open -na Ghostty.app --args --working-directory="$target_path"
            fi
          done
        ''
      else
        ''
          set -euo pipefail

          for target_path in "$@"; do
            if [[ -d "$target_path" ]]; then
              if [[ -n "''${TMUX:-}" && -n "''${TACO_TMUX_DIRECTORY_PANE:-}" ]]; then
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" C-c
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" "cd -- $(printf '%q' "$target_path")"
                ${pkgs.tmux}/bin/tmux send-keys -t "$TACO_TMUX_DIRECTORY_PANE" Enter
                continue
              fi

              ${pkgs.ghostty}/bin/ghostty --working-directory="$target_path" >/dev/null 2>&1 &
            fi
          done
        '';
  };
  chillaOpener = pkgs.writeShellApplication {
    name = "yazi-open-chilla";
    text = ''
      set -euo pipefail

      for target_path in "$@"; do
        if [[ -n "$target_path" ]]; then
          ${chillaCommand} "$target_path" >/dev/null 2>&1 &
        fi
      done
    '';
  };
  keymap = import ./keymap.nix;
in
{
  options.taco.yazi.openCommand = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "${pkgs.xdg-utils}/bin/xdg-open";
    description = ''
      Absolute command Yazi should use when it opens files outside the terminal.
      Set this in a platform-specific Home Manager module so Linux and Darwin can
      use different launchers.
    '';
  };

  config = {
    assertions = [
      {
        assertion = cfg.openCommand != null;
        message = "Set taco.yazi.openCommand in a platform-specific Home Manager module.";
      }
    ];

    xdg.configFile."yazi/plugins/enter-directory.yazi/main.lua".text = enterDirectoryPlugin;

    programs.yazi = {
      enable = true;
      enableFishIntegration = false;
      shellWrapperName = "y";
      flavors = {
        "gruvboxbase" = gruvboxBaseFlavor;
      };
      extraPackages = with pkgs; [
        fd
        file
        fzf
        jq
        ripgrep
        zoxide
      ];

      inherit keymap;

      theme = {
        flavor = {
          dark = "gruvboxbase";
        };
      };

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "mtime";
          sort_dir_first = true;
          sort_reverse = true;
        };

        open.prepend_rules = [
          {
            mime = "inode/directory";
            use = "open-terminal";
          }
          {
            mime = "application/pdf";
            use = "open-chilla";
          }
          {
            mime = "image/*";
            use = "open-chilla";
          }
          {
            mime = "video/*";
            use = "open-chilla";
          }
        ];

        opener = {
          edit = [
            {
              run = ''${nvimPaneOpener}/bin/nvim-pane-open "$@"'';
              block = true;
              desc = "Neovim";
            }
          ];

          open = [
            {
              run = ''${cfg.openCommand} "$@"'';
              orphan = true;
              desc = "Open";
            }
          ];

          open-chilla = [
            {
              run = ''${chillaOpener}/bin/yazi-open-chilla "$@"'';
              orphan = true;
              desc = "Open in Chilla";
            }
          ];

          open-terminal = [
            {
              run = ''${directoryTerminalOpener}/bin/yazi-open-terminal "$@"'';
              orphan = true;
              desc = "Open terminal here";
            }
          ];
        };
      };
    };
  };
}
