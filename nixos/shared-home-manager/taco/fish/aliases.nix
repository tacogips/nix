{ pkgs, ... }:

let
  codexCommand = "codex";
  codexGlobalFlags = "--dangerously-bypass-approvals-and-sandbox --model gpt-5.4";
  codexBaseCommand = "${codexCommand} ${codexGlobalFlags}";
in
{
  codexCommand = codexCommand;
  codexBaseCommand = codexBaseCommand;

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

    pyac = "source ./venv/bin/activate.fish";
    claude = "env NODE_OPTIONS='--max-old-space-size=16384' CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --model sonnet --dangerously-skip-permissions";
    claude-o = "env NODE_OPTIONS='--max-old-space-size=16384' CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --model opus --dangerously-skip-permissions";

    # `high` is not part of the model name; configure it via
    # `model_reasoning_effort = "high"` in `~/.codex/config.toml`.
    # Keep the shared flags in Nix so aliases and functions do not depend on
    # another fish alias being present.
    cx = codexBaseCommand;
    cxrl = "${codexBaseCommand} resume --last";
    cxr = "${codexBaseCommand} resume";
  };
}
