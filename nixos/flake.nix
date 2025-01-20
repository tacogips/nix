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

              environment.systemPackages = with pkgs; [
                neovim
                git
                curl
		pciutils
              ];

              ## SSHの設定
              #services.openssh = {
              #  enable = true;
              #  permitRootLogin = "no";
              #  passwordAuthentication = false;
              #};

	      #hardware ={
	      #  opengl = {
	      #    enable = true;
	      #    driSupport =true;
	      #    driSupport32Bit = true;
	      #  };

	      #  nvidia = {
	      #  	modesetting.enable = true;
	      #  	powerManagerment.enable =true;
	      #  	open = false;
	      #  	nvidiaSettings = true;
	      #  	package = config.boot.kernelPackages.nvidiaPackages.stable;

	      #  };
	      #};
	      #services.xserver.videoDrivers = ["nvidia"];


            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.taco = import ./home-manager.nix;
            }
          ];
        };
      };
    };

}
