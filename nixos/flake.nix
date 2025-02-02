{

  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        "taco-main" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./base/taco-main/configuration.nix
            ./base/taco-main/driver.nix
            ./ssh/ssh.nix

            {
              ## ブートローダー
              #boot.loader.systemd-boot.enable = true;
              #boot.loader.efi.canTouchEfiVariables = true;

              ## ネットワーク設定
              #networking = {
              #  hostName = "hostname";
              #  networkmanager.enable = true;
              #};

              # https://wiki.nixos.org/wiki/Sway#Using_Home_Manager
              #security.polkit.enable = true;

              environment.systemPackages = with pkgs; [
                neovim
                git
                curl
                grim # screenshot functionality
                slurp # screenshot functionality
                mako # notification system developed by swaywm maintainer
                fish
                bash
              ];

              fonts.fontDir.enable = true;

              ## SSHの設定
              #services.openssh = {
              #  enable = true;
              #  permitRootLogin = "no";
              #  passwordAuthentication = false;
              #};

              services.gnome.gnome-keyring.enable = true;

	      # login manager
              services.greetd = {
                enable = true;
                #settings = {
                #  default_session = {
                #    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyperland";
                #    user = "taco";
                #  };
                #};
                settings = {
                  initial_session = {
                    command = "${pkgs.hyprland}/bin/Hyprland";
                    user = "taco";
                  };
                  default_session = {
                    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${pkgs.hyprland}/bin/Hyprland";
                    user = "greeter";
                  };

                };
              };

              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };

              programs.fish.enable = true;

              #users.users.taco = {
              #  isNormalUser = true;
              #  extraGroups = [ "wheel" "networkmanager" ];
              #};

              users.users.taco = {
                shell = pkgs.fish;
		openssh.authorizedKeys.keyFiles = [

./ssh/authorized_keys_dev_machine
		];
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
