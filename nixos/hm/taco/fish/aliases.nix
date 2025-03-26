{ pkgs, ... }:

{
  ll = "ls -al";
  update-taco-main = "sudo nixos-rebuild switch --flake ~/nix/nixos#taco-main";
  ppp = "pwd | wl-copy";
  cdp = "cd (wl-paste -n)";
  fa = "fd -H";

  gac = "git add .; git commit -am";

  lg = "lazygit";
  ldc = "lazydocker";
  cat = "bat";
  gs = "git status";

  gps = "git push origin ";
  gpl = "git pull origin ";
  htop = "btm";

  cc = "cargo check";
  cb = "cargo check";

  z = "zeditor";
  f = "${pkgs.fd}/bin/fd";

  mozc_config = "${pkgs.mozc}/lib/mozc/mozc_tool --mode=config_dialog";

}
