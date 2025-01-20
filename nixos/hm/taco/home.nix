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

  alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
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
	home-manager.enable =true;

  };

                                                       

  # 環境変数の設定
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "river";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };





}

