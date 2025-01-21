{ config, pkgs, ... }:
{

  imports = [
    ./bottom
    ./eza
    ./fish
    ./foot
    ./fzf
    ./git
    ./hyprland
    ./neovim
    ./ssh
    ./waybar
    ./zellij
  ];

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
    pkgs.fcitx5-mozc
    pkgs.fcitx5-gtk
    pkgs.fcitx5-configtool
  ];

  home.username = "taco";
  home.homeDirectory = "/home/taco";
  home.stateVersion = "24.11";
  home.sessionVariables = {
    GTK_IM_MDOULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus"; # IME support in kitty
  };

  #fonts.packages = with pkgs; [
  #  noto-fonts
  #  noto-fonts-cjk-sans
  #  noto-fonts-emoji
  #  #liberation_ttf
  #  fira-code
  #  fira-code-symbols
  #  #mplus-outline-fonts.githubRelease
  #  #dina-font
  #  #proggyfonts
  #  iosevka
  #];
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    firefox
    ripgrep
    just
    nixfmt-rfc-style

    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    iosevka
    nerd-fonts.iosevka
  ];

  programs.home-manager.enable = true;

  programs = {

    # ---
    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_github";
        };
      };
    };

    # ---
    mako = {
      enable = true;
      defaultTimeout = 5000;
    };
    #  -- let home manager manage itself
    home-manager.enable = true;

  };

  #wayland.windowManager.hyprland = {
  #  enable = true;

  #  extraConfig = ''
  #    ${builtins.readFile ./hyperland.conf}
  #  '';

  #};

}
