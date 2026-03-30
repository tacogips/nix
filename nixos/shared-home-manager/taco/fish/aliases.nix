{ lib, pkgs, ... }:

let
  agentCommands = import ./agent-commands.nix { };
  inherit (agentCommands)
    claudeBaseCommand
    codexBaseCommand
    codexReviewTodayFullPrompt
    codexCommand
    codexReviewTodayPrompt
    cursorBaseCommand
    cursorCommand
    cursorFastModel
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
    cl = "${claudeBaseCommand} --model sonnet";
    clo = "${claudeBaseCommand} --model opus";

    # `high` is not part of the model name; configure it via
    # `model_reasoning_effort = "high"` in `~/.codex/config.toml`.
    # Keep the shared flags in Nix so aliases and functions do not depend on
    # another fish alias being present.
    co = codexBaseCommand;
    "co-review-today" = "${codexBaseCommand} exec ${lib.escapeShellArg codexReviewTodayFullPrompt}";
    corl = "${codexBaseCommand} resume --last";
    cor = "${codexBaseCommand} resume";
    ca = "${cursorBaseCommand} --model ${cursorFastModel}";
    cu = cursorBaseCommand;
    curl = "${cursorBaseCommand} resume --last";
    cur = "${cursorBaseCommand} resume";
  };
}
