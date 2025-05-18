{ pkgs, ... }:

{
  ll = "ls -al";
  update-taco-main = "sudo nixos-rebuild switch --flake ~/nix/nixos/linux#taco-main";
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

  mozc_config = "${pkgs.mozc}/lib/mozc/mozc_tool --mode=config_dialog";

  pyac = "source ./venv/bin/activate.fish";

}
