{ pkgs, ... }:

{
  ll = "ls -al";
  nix-swhich-nix-dev-machine = "sudo nixos-rebuild switch --flake ~/nix/nixos/linux#nix-dev-machine";
  ppp = "pwd | wl-copy";
  cdp = "cd (wl-paste -n)";
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

}
