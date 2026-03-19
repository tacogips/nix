{ pkgs, ... }:

let
  codexCommand = "codex";
  # Newer Codex CLI versions reject combining explicit approval policy with
  # the bypass flag, because bypass already disables approvals and sandboxing.
  codexGlobalFlags = "--dangerously-bypass-approvals-and-sandbox --model gpt-5.4";
  codexBaseCommand = "${codexCommand} ${codexGlobalFlags}";
  claudeBaseCommand = "env NODE_OPTIONS='--max-old-space-size=16384' CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --permission-mode bypassPermissions --dangerously-skip-permissions";
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

    kinu = "kinko unlock ";

    pyac = "source ./venv/bin/activate.fish";
    z = "zellij";
    cl = "${claudeBaseCommand} --model sonnet";
    clo = "${claudeBaseCommand} --model opus";

    # `high` is not part of the model name; configure it via
    # `model_reasoning_effort = "high"` in `~/.codex/config.toml`.
    # Keep the shared flags in Nix so aliases and functions do not depend on
    # another fish alias being present.
    co = codexBaseCommand;
    corl = "${codexBaseCommand} resume --last";
    cor = "${codexBaseCommand} resume";
  };
}
