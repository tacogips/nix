{ lib, pkgs, ... }:

let
  agentCommands = import ./agent-commands.nix { };
  tmuxWindowNameUpdate = pkgs.writeShellApplication {
    name = "tmux-window-name-update";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.tmux
    ];
    text = ''
      set -euo pipefail

      usage() {
        printf 'Usage: tmux-window-name-update [--auto-all]\n' >&2
      }

      window_title_for_path() {
        local path repo_root title

        path="$1"
        repo_root="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null || true)"

        if [[ -n "$repo_root" ]]; then
          title="$(basename "$repo_root")"
        else
          title="$(basename "$path")"
        fi

        if [[ -z "$title" || "$title" == "/" ]]; then
          title="shell"
        fi

        printf '%s\n' "$title"
      }

      rename_window() {
        local target path title

        target="$1"
        path="$(tmux display-message -p -t "$target" '#{pane_current_path}' 2>/dev/null || true)"

        if [[ -z "$path" || ! -d "$path" ]]; then
          return 0
        fi

        title="$(window_title_for_path "$path")"
        tmux rename-window -t "$target" "$title"
      }

      case "''${1:-}" in
        "")
          if [[ -z "''${TMUX:-}" ]]; then
            printf 'tmux-window-name-update: not inside tmux\n' >&2
            exit 1
          fi
          rename_window "$(tmux display-message -p '#{window_id}')"
          ;;
        --auto-all)
          while IFS= read -r target; do
            rename_window "$target"
          done < <(tmux list-windows -a -F '#{window_id}')
          ;;
        -h|--help)
          usage
          ;;
        *)
          usage
          exit 2
          ;;
      esac
    '';
  };
  inherit (agentCommands)
    codexBaseCommand
    codexBaseCommandMedium
    codexBaseCommandTerraMedium
    codexBaseCommandLunaMedium
    codexCommand
    codexReviewTodayPrompt
    codexSakanaBaseCommand
    codexSakanaUltraBaseCommand
    cursorBaseCommand
    cursorCommand
    cursorModelClaudeOpus
    cursorModelComposer
    cursorModelGpt56Sol
    ;
in
{
  inherit
    codexBaseCommand
    codexCommand
    codexReviewTodayPrompt
    cursorBaseCommand
    cursorCommand
    tmuxWindowNameUpdate
    ;

  aliases = {
    ll = "ls -al";
    fa = "fd -H";

    gac = "git add .; git commit -am";

    dc = "docker compose";

    lg = "lazygit";
    ldc = "lazydocker";
    cat = "bat";
    gs = "git status";

    gps = "git push origin";
    gpl = "git pull origin";
    gch = "git checkout";
    ghb = "gh browse";
    htop = "btm";

    cc = "cargo check";
    cb = "cargo check";

    f = "${pkgs.fd}/bin/fd";

    da = "direnv allow";

    kin = "kinko unlock ";

    pyac = "source ./venv/bin/activate.fish";
    tm = if pkgs.stdenv.hostPlatform.isDarwin then "herdr" else "tmux";
    vim = "nvim";
    n = "nvim";
    # `high` is not part of the model name; set `co`'s reasoning effort
    # explicitly so it does not inherit a higher default from Codex config.
    # Keep the shared flags in Nix so aliases and functions do not depend on
    # another fish alias being present.
    co = codexBaseCommandMedium;
    cot = codexBaseCommandTerraMedium;
    col = codexBaseCommandLunaMedium;
    cof = codexSakanaBaseCommand;
    cofu = codexSakanaUltraBaseCommand;
    codex-fugu = codexSakanaBaseCommand;
    corl = "${codexBaseCommand} resume --last";
    cor = "${codexBaseCommand} resume";
    cr = "${cursorBaseCommand} --model ${cursorModelComposer}";
    cro = "${cursorBaseCommand} --model ${cursorModelGpt56Sol}";
    crc = "${cursorBaseCommand} --model ${cursorModelClaudeOpus}";
    # Codex uses `resume --last`; Cursor has no `--last` on `resume`. Use `ls` to
    # pick a session (`cor`) and the `resume` subcommand for the latest (`corl`).
    crr = "${cursorBaseCommand} ls";
    crrl = "${cursorBaseCommand} resume";
  }
  // lib.optionalAttrs (!pkgs.stdenv.hostPlatform.isDarwin) {
    wnu = "${tmuxWindowNameUpdate}/bin/tmux-window-name-update --auto-all";
  };
}
