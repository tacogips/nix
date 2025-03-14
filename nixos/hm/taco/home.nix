{ config, pkgs, ... }:

{

  imports = [
    ./alacritty
    ./bottom
    ./eza
    ./fd
    ./foot
    ./fuzzel
    ./fzf
    ./git
    ./hyprland
    ./lazygit
    ./mako
    ./ripgrep
    ./fish
    ./ssh
    ./waybar
    ./yazi
    ./zed
    ./zoxide
    ./bat
    ./brave
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

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
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
    go-task
    nixfmt-rfc-style

    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    iosevka
    nerd-fonts.iosevka
    tokei
    dust
  ];

  programs.home-manager.enable = true;

  #wayland.windowManager.hyprland = {
  #  enable = true;

  #  extraConfig = ''
  #    ${builtins.readFile ./hyperland.conf}
  #  '';

  #};

}
