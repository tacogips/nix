{
  config,
  lib,
  pkgs,
  chilla-pkg ? null,
  ...
}:

let
  cfg = config.taco.yazi;
  chillaCommand =
    if chilla-pkg != null then
      "${chilla-pkg}/bin/chilla"
    else if pkgs.stdenv.isDarwin then
      "chilla"
    else
      cfg.openCommand;
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
  gitDiffTreePlugin = ''
    --- @sync get_cwd
    local get_cwd = ya.sync(function()
      return cx.active.current.cwd
    end)

    local function notify(level, content)
      ya.notify({
        title = "Git Diff Tree",
        content = content,
        timeout = 5,
        level = level,
      })
    end

    local function add_entry(entries, url)
      local cha = fs.cha(url, true)

      if cha then
        entries[tostring(url)] = File({ url = url, cha = cha })
      end
    end

    local function add_parent_dirs(entries, cwd, relative_path)
      local parts = {}

      for part in relative_path:gmatch("[^/]+") do
        parts[#parts + 1] = part
      end

      for i = 1, #parts - 1 do
        add_entry(entries, cwd:join(table.concat(parts, "/", 1, i)))
      end
    end

    local function sorted_entries(entries)
      local items = {}

      for _, file in pairs(entries) do
        items[#items + 1] = file
      end

      table.sort(items, function(a, b)
        local a_dir = a.cha.is_dir and 0 or 1
        local b_dir = b.cha.is_dir and 0 or 1

        if a_dir ~= b_dir then
          return a_dir < b_dir
        end

        return tostring(a.url) < tostring(b.url)
      end)

      return items
    end

    local function entry()
      local cwd = get_cwd()
      local output, err = Command("git")
        :cwd(tostring(cwd))
        :arg({ "diff", "--name-only", "HEAD" })
        :output()

      if err then
        return notify("error", "Failed to run `git diff`: " .. err)
      elseif not output.status.success then
        return notify("error", "Failed to run `git diff`: " .. output.stderr)
      end

      local entries = {}

      for line in output.stdout:gmatch("[^\r\n]+") do
        add_parent_dirs(entries, cwd, line)
        add_entry(entries, cwd:join(line))
      end

      local files = sorted_entries(entries)
      if #files == 0 then
        return notify("info", "No files or directories match `git diff`")
      end

      local id = ya.id("ft")
      local search_cwd = cwd:into_search("Git diff tree")

      ya.emit("cd", { Url(search_cwd) })
      ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(search_cwd), files = {} }) })
      ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(search_cwd), files = files }) })
      ya.emit(
        "update_files",
        { op = fs.op("done", { id = id, url = search_cwd, cha = Cha({ mode = tonumber("100644", 8) }) }) }
      )
    end

    return { entry = entry }
  '';
  gitPluginInit = ''
    require("git"):setup {
      order = 1500,
    }
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
    xdg.configFile."yazi/plugins/git-diff-tree.yazi/main.lua".text = gitDiffTreePlugin;

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
        git
        jq
        ripgrep
        zoxide
      ];

      initLua = gitPluginInit;
      plugins = {
        inherit (pkgs.yaziPlugins) git;
      };

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

        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];

        open.prepend_rules = [
          {
            mime = "inode/directory";
            use = "open-terminal";
          }
          {
            url = "*.md";
            use = "open-chilla";
          }
          {
            url = "*.markdown";
            use = "open-chilla";
          }
          {
            mime = "text/markdown";
            use = "open-chilla";
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
