{
  config,
  pkgs,
  inputs,
  xremap-flake,
  cratedocs-mcp-pkg,
  bravesearch-mcp-pkg,
  hn-mcp-pkg,
  gitcode-mcp-pkg,
  ...
}:

{

  imports = [
    # Moved Linux-specific modules from shared to linux/home-manager
    ./fuzzel
    ./hyprland
    ./mako
    ./waybar
    ./brave
    xremap-flake.homeManagerModules.default
    ./xremap
    ./syncthing
    ./kanshi
    ./xdgdesktops
    ./langs
    ./node
    #./podman
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [
      pkgs.fcitx5-mozc
      pkgs.fcitx5-gtk
      pkgs.qt6Packages.fcitx5-configtool
    ];
  };

  # User settings moved to default.nix

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
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;

    # vulkan and nvidia
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    XDG_SESSION_TYPE = "wayland";
    #    GBM_BACKEND = "nvidia-drm";

    # enable these and zeditor wont start
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

  };

  home.packages =
    with pkgs;
    [
      # firefox - Removed (now managed by home-manager firefox module)
      go-task
      kubectl

      networkmanagerapplet # nm-connection-editor

      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      tokei
      dust
      jq
      claude-code
      codex

      nixfmt-rfc-style
      nixd # nix lsp

      qt6.qtwayland # needed for mozc to run  QT_QPA_PLATFORM, wayland

      # Override Slack to fix Wayland rendering issues (jagged/pixelated display)
      # Why this works:
      # 1. Slack 4.46.96+ has a bug where --ozone-platform-hint=auto is ignored (GitHub issue #445220)
      # 2. Environment variables like ELECTRON_FLAGS don't apply to individual Electron apps
      #    because each app has its own launch wrapper
      # 3. By overriding at package level with makeWrapper, we ensure flags are passed directly to Slack
      # 4. --ozone-platform=wayland forces native Wayland mode instead of falling back to XWayland
      # 5. --disable-gpu-sandbox works around Nvidia-specific GPU rendering issues
      # 6. UseOzonePlatform enables Electron's Ozone platform backend for proper Wayland support
      # 7. WebRTCPipeWireCapturer enables screen sharing via PipeWire on Wayland
      (slack.overrideAttrs (oldAttrs: {
        installPhase = oldAttrs.installPhase + ''
          rm $out/bin/slack

          makeWrapper $out/lib/slack/slack $out/bin/slack \
            --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xdg-utils ]} \
            --add-flags "--ozone-platform=wayland" \
            --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
            --add-flags "--disable-gpu-sandbox"
        '';
      }))
      obsidian
      chromium

      grim # screenshot functionality
      slurp # screenshot functionality (select mouse region)
      wf-recorder # capture video
      feh

      # using zoom web client for now
      #zoom-us
      #podman-compose
      #podman-tui
      docker-compose
      lazydocker

      gh
      gnumake
      mpv # movie player
      # gui file manager.see xdgdesktops also
      nemo-with-extensions

      # Ensure coreutils is available for the nix_diff function
      coreutils

    ]
    ++ [

      # ---- mcps -------------------------------
      cratedocs-mcp-pkg
      bravesearch-mcp-pkg
      hn-mcp-pkg
      gitcode-mcp-pkg
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
