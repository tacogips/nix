{
  ll = "ls -al";
  update-taco-main = "sudo nixos-rebuild switch --flake ~/nix/nixos#taco-main";
  ppp = "pwd | wl-copy";
  cdp = "cd (wl-paste -n)";
  fa = "fd -H";

  gac = "git add .; git commit -am";

  vim = "nvim";

}
