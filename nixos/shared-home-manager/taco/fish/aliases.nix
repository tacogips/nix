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
  claude = "env NODE_OPTIONS='--max-old-space-size=16384' ${pkgs.claude-code}/bin/claude --model claude-sonnet-4-5-20250929 --dangerously-skip-permissions";
  claude-o = "env NODE_OPTIONS='--max-old-space-size=16384' ${pkgs.claude-code}/bin/claude --model claude-opus-4-6 --dangerously-skip-permissions";

}
