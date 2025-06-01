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
  claude = "claude --dangerously-skip-permissions";

}
