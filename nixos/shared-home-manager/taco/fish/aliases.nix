{ pkgs, ... }:

{
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
  # Official docs currently point Codex CLI at the GPT-5.1-Codex family.
  codex = "codex --dangerously-bypass-approvals-and-sandbox --model gpt-5.1-codex-max";
  # fish alias expands to a function, so `codex-r*` should delegate to the
  # `codex` alias to avoid passing global flags twice.
  codex-rl = "codex resume --last";
  codex-r = "codex resume";

}
