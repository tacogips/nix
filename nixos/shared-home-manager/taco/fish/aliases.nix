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

  z = "zeditor";
  f = "${pkgs.fd}/bin/fd";

  da = "direnv allow";

  pyac = "source ./venv/bin/activate.fish";
  claude = "${pkgs.claude-code}/bin/claude --model claude-sonnet-4-20250514 --dangerously-skip-permissions";
  claude-o = "${pkgs.claude-code}/bin/claude --model claude-opus-4-20250514 --dangerously-skip-permissions";

  setup-claude-mcps = ''
    ${pkgs.claude-code}/bin/claude mcp add -s user bravesearch-mcp bravesearch-mcp stdio && \
    ${pkgs.claude-code}/bin/claude mcp add -s user gitcodes-mcp gitcodes-mcp stdio && \
    ${pkgs.claude-code}/bin/claude mcp add -s user cratedocs-mcp cratedocs-mcp stdio
  '';

}
