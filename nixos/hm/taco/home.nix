{
  config,
  pkgs,
  inputs,
  xremap-flake,
  ...
}:

{

  imports = [
    ./alacritty
    ./bottom
    ./eza
    ./direnv
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
    xremap-flake.homeManagerModules.default
    ./xremap
    ./syncthing
    ./podman
    ./kanshi
    ./xdgdesktops
    ./langs
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [
      pkgs.fcitx5-mozc
      pkgs.fcitx5-gtk
      pkgs.fcitx5-configtool
    ];
  };

  home.username = "taco";
  home.homeDirectory = "/home/taco";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "${pkgs.zed-editor}/bin/zeditor";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus"; # IME support in kitty

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";

    # vulkan and nvidia
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    XDG_SESSION_TYPE = "wayland";
    #    GBM_BACKEND = "nvidia-drm";

    # enable these and zeditor wont start
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

  };

  home.packages = with pkgs; [
    go-task

    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    tokei
    dust
    jq

    nixfmt-rfc-style
    nixd # nix lsp

    qt6.qtwayland # needed for mozc to run  QT_QPA_PLATFORM, wayland

    slack
    obsidian

    grim # screenshot functionality
    slurp # screenshot functionality (select mouse region)
    wf-recorder # capture video
    feh

    # using zoom web client for now
    #zoom-us
    podman-compose
    podman-tui
    lazydocker

    gh
    gnumake
  ];

  #  home.file.".config/zoomus.conf" = {
  #    text = ''
  #      enableWaylandShare=true
  #      xwayland=true
  #    '';
  #  };

  fonts = {
    fontconfig.enable = true;
    #packages = with pkgs; [
    #  noto-fonts
    #  noto-fonts-cjk-sans
    #  noto-fonts-cjk-serif
    #  noto-fonts-emoji
    #  iosevka
    #  nerd-fonts.iosevka

    #];
  };

  programs.home-manager.enable = true;

  #wayland.windowManager.hyprland = {
  #  enable = true;

  #  extraConfig = ''
  #    ${builtins.readFile ./hyperland.conf}
  #  '';

  #};

}
