{ config, pkgs, ... }:
{

  imports = [
    #./wm.nix
    ./waybar.nix
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

  home.file.".config/zellij/config.kdl".source = ./zellij-config.kdl;


  home.packages = with pkgs; [
    firefox
    ripgrep
    just
    iosevka
    nixfmt

  ];

  fonts.fontconfig.enable = true;
  programs = {
    foot = {
      enable = true;
    };

    bottom = {
      enable = true;
    };
    
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    eza = {
      enable = true;
      #enableAliases = true;
      git = true;
      icons = true;
    };

    skim = {
      enable = true;
      enableFishIntegration = false;
    };

    fish = {
      enable = true;
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
    };


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
    git = {
      enable = true;
      userName = "tacogips";
      userEmail = "me@tacogips.me";
      extraConfig = {
        core.editor = "nvim";
        init.defaultBranch = "main";
      };

    };

    mako = {
      enable = true;
      defaultTimeout = 5000;
    };

    #  -- let home manager manage itself
    home-manager.enable = true;

  };

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      ${builtins.readFile ./hyperland.conf}
    '';

  };

}
