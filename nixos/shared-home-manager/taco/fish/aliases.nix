{ pkgs, ... }:

let
  agentCommands = import ./agent-commands.nix { };
  inherit (agentCommands)
    claudeBaseCommand
    codexBaseCommand
    codexBaseCommand54
    codexCommand
    codexReviewTodayPrompt
    cursorBaseCommand
    cursorCommand
    cursorModelClaudeOpus
    cursorModelComposer
    cursorModelGpt55Medium
    ;
in
{
  inherit
    codexBaseCommand
    codexCommand
    codexReviewTodayPrompt
    cursorBaseCommand
    cursorCommand
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
    tm = "tmux";
    vim = "nvim";
    n = "nvim";
    cl = "env CLAUDE_CODE_EFFORT_LEVEL=high ${claudeBaseCommand} --model sonnet";
    clo = "env CLAUDE_CODE_EFFORT_LEVEL=high ${claudeBaseCommand} --model opus";

    # `high` is not part of the model name; configure it via
    # `model_reasoning_effort = "high"` in `~/.codex/config.toml`.
    # Keep the shared flags in Nix so aliases and functions do not depend on
    # another fish alias being present.
    co = codexBaseCommand;
    coo = codexBaseCommand54;
    corl = "${codexBaseCommand} resume --last";
    cor = "${codexBaseCommand} resume";
    cr = "${cursorBaseCommand} --model ${cursorModelComposer}";
    cro = "${cursorBaseCommand} --model ${cursorModelGpt55Medium}";
    crc = "${cursorBaseCommand} --model ${cursorModelClaudeOpus}";
    # Codex uses `resume --last`; Cursor has no `--last` on `resume`. Use `ls` to
    # pick a session (`cor`) and the `resume` subcommand for the latest (`corl`).
    crr = "${cursorBaseCommand} ls";
    crrl = "${cursorBaseCommand} resume";
  };
}
