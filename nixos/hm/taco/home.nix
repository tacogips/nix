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
      ${builtins.readFile ./hyperland.conf}
    '';



    };


}

