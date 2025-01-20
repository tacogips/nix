{
  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        "taco-main" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./taco-main/configuration.nix
            ./taco-main/driver.nix
	    ./ssh.nix

            # 基本的なシステム設定
            {
              ## ブートローダー
              #boot.loader.systemd-boot.enable = true;
              #boot.loader.efi.canTouchEfiVariables = true;

              ## ネットワーク設定
              #networking = {
              #  hostName = "hostname";
              #  networkmanager.enable = true;
              #};

              #users.users.taco = {
              #  isNormalUser = true;
              #  extraGroups = [ "wheel" "networkmanager" ];
              #};

	      # https://wiki.nixos.org/wiki/Sway#Using_Home_Manager 
	      security.polkit.enable = true;

              environment.systemPackages = with pkgs; [
                neovim
                git
                curl
		grim # screenshot functionality
    		slurp # screenshot functionality
    		wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    		mako # notification system developed by swaywm maintainer
              ];

              ## SSHの設定
              #services.openssh = {
              #  enable = true;
              #  permitRootLogin = "no";
              #  passwordAuthentication = false;
              #};

	  	programs.sway = {
    		enable = true;
    		wrapperFeatures.gtk = true;
  		};	

            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.taco = import ./hm/taco/home.nix;
            }
          ];
        };
      };
    };

}
