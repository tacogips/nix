{config, pkgs, ...}:{

  #imports =
  #  [ 
  #    ./wm.nix
  #  ];

  home.username = "taco";
  home.homeDirectory = "/home/taco";
  home.stateVersion = "24.11"; 

  home.packages = with pkgs; [
    firefox
    bottom
    ripgrep
    just
    alacritty
    foot

#    waybar
#    wofi

  ];
  programs = {
  	# --- 
	ssh ={
		enable =true;
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
		core.editor ="nvim";
		init.defaultBranch = "main";
	};

	};

  #alacritty = {
  #  enable = true;
  #  settings = {
  #    window = {
  #      padding = {
  #        x = 10;
  #        y = 10;
  #      };
  #    };
  #  };
  #};

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
	home-manager.enable =true;

  };

    wayland.windowManager.hyprland = {
    enable =true;

    extraConfig = ''
      # モニター設定
      #monitor=,preferred,auto,1

      # 基本的な設定
      input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
          natural_scroll = true
        }
      }

      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee)
        col.inactive_border = rgba(595959aa)
        layout = dwindle
      }

      #decoration {
      #  rounding = 10
      #  blur = true
      #  blur_size = 3
      #  blur_passes = 1
      #}

      animations {
        enabled = false
      }

      # キーバインド
      bind = SUPER, Return, exec, foot
      bind = SUPER, Q, killactive,
      #bind = SUPER, M, exit,
      bind = SUPER, E, exec, dolphin
      bind = SUPER, V, togglefloating,
      bind = SUPER, R, exec, wofi --show drun
      bind = SUPER, P, pseudo,
      bind = SUPER, J, togglesplit,

      # ワークスペース切り替え
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5

      # ウィンドウをワークスペースに移動
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5

      # 自動起動
      exec-once = waybar
      #exec-once = hyprpaper
    '';



    };


  wayland.windowManager.river = {
    enable = true;


    settings = {
  #    # デフォルトのアプリケーション
      terminal = "${pkgs.foot}/bin/foot";

  #    ## キーバインド
  #    #bindings = {
  #    #  "Super+Return" = "spawn ${pkgs.foot}/bin/foot";

  #    #  # ワークスペース
  #    #  "Super+1" = "workspace 1";
  #    #  "Super+2" = "workspace 2";
  #    #  "Super+3" = "workspace 3";
  #    #  "Super+4" = "workspace 4";
  #    #};

  #    ## 外観設定
  #    #background-color = "0x000000";
  #    #border-width = 2;
  #    #border-color-focused = "0x93a1a1";
  #    #border-color-unfocused = "0x586e75";
    };


  };

  #wayland.windowManager.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
  #  config = rec {
  #    #modifier = "Mod4";
  #    # Use kitty as default terminal
  #    terminal = "foot"; 
  #    startup = [
  #      # Launch Firefox on start
  #      {command = "firefox";}
  #    ];
  #  };
  #};

                                                       

  # 環境変数の設定
  #home.sessionVariables = {
  #  XDG_CURRENT_DESKTOP = "river";
  #  XDG_SESSION_TYPE = "wayland";
  #  MOZ_ENABLE_WAYLAND = "1";
  #};





}

