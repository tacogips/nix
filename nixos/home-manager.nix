{config, pkgs, ...}:{
  home.username = "taco";
  home.homeDirectory = "/home/taco";
  home.stateVersion = "24.11"; 

  home.packages = with pkgs; [
    firefox
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


	#  -- let home manager manage itself
	home-manager.enable =true;
  };


}

