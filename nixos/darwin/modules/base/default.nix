{
  config,
  darwinStateVersion,
  pkgs,
  user ? "taco",
  ...
}:

{
  # Set primary user for system defaults.
  system.primaryUser = user;

  system.defaults.NSGlobalDomain = {
    AppleKeyboardUIMode = 3;
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 20;
    KeyRepeat = 1;
  };

  # System settings.
  system.stateVersion = darwinStateVersion;

  # Set nixbld group ID to match actual value.
  ids.gids.nixbld = 350;

  # Disable nix-darwin management of Nix installation.
  nix.enable = false;

  # Nix settings are still applied even with nix.enable = false.
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "@admin" ];
  };

  # Nix is installed outside nix-darwin, so invoke its stable profile path.
  launchd.daemons.nix-garbage-collector = {
    serviceConfig = {
      Label = "org.nixos.nix-garbage-collector";
      ProgramArguments = [
        "/nix/var/nix/profiles/default/bin/nix-collect-garbage"
      ];
      StartCalendarInterval = {
        Weekday = 0;
        Hour = 3;
        Minute = 15;
      };
      ProcessType = "Background";
      LowPriorityIO = true;
      StandardOutPath = "/var/log/nix-garbage-collector.log";
      StandardErrorPath = "/var/log/nix-garbage-collector.log";
    };
  };

  # Migrated to tacogips/mise-darwin (Brewfile.common).
  # fonts.packages = import ../../packages/fonts.nix { inherit pkgs; };

  nixpkgs.config.allowUnfree = true;

  # Migrated to tacogips/mise-darwin ([bootstrap.packages]). Keep Darwin's
  # active package surface Homebrew/Cask-only during the Nix removal period.
  # environment.systemPackages = import ../../packages/base.nix { inherit pkgs; };

  # Shell binaries and activation now come from mise-darwin/Homebrew.
  # programs.zsh.enable = true;
  # programs.fish.enable = true;

  # mise bootstrap owns /etc/shells and the login shell.
  # users.users.${user} = {
  #   shell = pkgs.fish;
  # };

  # mise bootstrap owns /etc/shells and selects /opt/homebrew/bin/fish.
  # system.activationScripts.postActivation.text =
  #   let
  #     primaryUser = config.system.primaryUser;
  #   in
  #   ''
  #     echo "Setting fish as default shell for user ${primaryUser}..."
  #     sudo chsh -s ${pkgs.fish}/bin/fish ${primaryUser}
  #   '';
}
