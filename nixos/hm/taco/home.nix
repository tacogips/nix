{ config, pkgs, ... }:
{

  #imports =
  #  [
  #    ./wm.nix
  #  ];

  home.username = "taco";
  home.homeDirectory = "/home/taco";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    firefox
    ripgrep
    just
    iosevka
    nixfmt

    #    waybar
    #    wofi

  ];

  fonts.fontconfig.enable = true;
  programs = {
    ghostty = {
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

    exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    skim = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
    };

    home.file.".config/zellij/config.kdl".source = ./zellij-config.kdl;

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

    # 関連するサービスの設定
    # status bar
    waybar = {
      enable = true;
      settings = {
        # waybarの設定をここに記述
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
