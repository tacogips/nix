{

  description = "nixos system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      xremap-flake,
      ...
    }:
    let
      system = "x86_64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        system = "${system}";
        config = {
          allowUnfree = true;
        };
      };

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

              nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
              };
              nix.settings.auto-optimise-store = true;
              # not needed for rootless
              #nix.settings.trusted-users = [ "taco" ];

              virtualisation.podman = {
                enable = true;
                dockerCompat = true;
                defaultNetwork.settings.dns_enabled = true;
              };
              security.unprivilegedUsernsClone = true; # ユーザー名前空間を有効化

              environment.systemPackages = with pkgs; [
                vim
                git
                curl
                grim # screenshot functionality
                slurp # screenshot functionality
                mako # notification system developed by swaywm maintainer
                fish
                bash
              ];

              fonts = {
                fontDir.enable = true;

                packages = with pkgs; [
                  noto-fonts
                  noto-fonts-cjk-sans
                  noto-fonts-cjk-serif
                  noto-fonts-emoji
                  iosevka
                  helvetica-neue-lt-std
                  nerd-fonts.iosevka
                ];
                fontconfig = {
                  defaultFonts = {
                    serif = [
                      "Noto Serif CJK JP"
                      "Noto Color Emoji"
                    ];
                    sansSerif = [
                      "Noto Sans CJK JP"
                      "Noto Color Emoji"
                    ];
                    monospace = [
                      "Iosevka Nerd Fon"
                      "Noto Color Emoji"
                    ];
                    emoji = [ "Noto Color Emoji" ];
                  };
                };

              };

              services.openssh = {
                enable = true;
                permitRootLogin = "no";
                passwordAuthentication = false;
              };

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

              # for xremap
              boot.kernelModules = [
                "uinput"
              ];
              # for xremap
              services.udev.extraRules = ''
                KERNEL=="uinput",GROUP="input", TAG+="uaccess"
              '';
              users.users.taco = {
                shell = pkgs.fish;

                extraGroups = [
                  "wheel"
                  "networkmanager"
                  "input"
                  "podman"
                ];
                openssh.authorizedKeys.keyFiles = [
                  ./ssh/authorized-keys-dev-machine
                ];
              };

              # enable screen sharing
              xdg.portal = {
                enable = true;
                extraPortals = [
                  pkgs.xdg-desktop-portal-hyprland
                  pkgs.xdg-desktop-portal-gtk
                ];
                config.hyprland = {
                  "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
                };
              };

            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              #home-manager.sharedModules = [
              #  (
              #    { config, ... }:
              #    {
              #    }
              #  )
              #];
              home-manager.extraSpecialArgs = {
                inherit xremap-flake;
              }; # inputs を渡す
              home-manager.users.taco =
                { ... }:
                {
                  imports = [
                    ./hm/taco/home.nix
                  ];
                };
            }
          ];
        };
      };
    };

}
