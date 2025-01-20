{config, pkgs, ...}:{

  imports =
    [ 
      ./wm.nix
    ];

  home.username = "taco";
  home.homeDirectory = "/home/taco";
  home.stateVersion = "24.11"; 

  home.packages = with pkgs; [
    firefox
    alacritty
    neovim
    git
    bottom
    ripgrep
    just
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

  programs.alacritty = {
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




	#  -- let home manager manage itself
	home-manager.enable =true;
  };


}

