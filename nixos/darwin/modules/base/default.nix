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

  fonts.packages = import ../../packages/fonts.nix { inherit pkgs; };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = import ../../packages/base.nix { inherit pkgs; };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.${user} = {
    shell = pkgs.fish;
  };

  system.activationScripts.postActivation.text =
    let
      primaryUser = config.system.primaryUser;
    in
    ''
      # Set fish shell for current user.
      echo "Setting fish as default shell for user ${primaryUser}..."
      sudo chsh -s ${pkgs.fish}/bin/fish ${primaryUser}
    '';
}
