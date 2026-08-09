{
  config,
  pkgs,
  lib,
  homeStateVersion ? "24.11",
  ...
}:

{
  # Darwin-specific Home Manager configurations

  imports = [
    # All Darwin Home Manager tools and dotfiles have moved to
    # tacogips/mise-darwin. Leave these commented during the transition so a
    # darwin-rebuild removes the old profile links without changing Linux.
    # ./home.nix
    # ./karabiner.nix
    # ../../shared-home-manager/taco
  ];

  # Darwin-specific user settings
  home.username = lib.mkForce "taco";
  home.homeDirectory = lib.mkForce "/Users/taco";
  home.stateVersion = lib.mkForce homeStateVersion;
  manual.manpages.enable = false;
  programs.man.enable = false;
  # taco.yazi.openCommand = "/usr/bin/open";
  # programs.eza.extraOptions = [ "--all" ];

  # Override any shared settings that need customization for macOS
  # programs.git = {
  #   settings.user = {
  #     name = lib.mkForce "tacogips";
  #     email = lib.mkForce "me@tacogips.me";
  #   };
  # };
}
