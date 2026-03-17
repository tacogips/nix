{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.taco.yazi;
in
{
  options.taco.yazi.openCommand = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "${pkgs.xdg-utils}/bin/xdg-open";
    description = ''
      Absolute command Yazi should use when it opens files outside the terminal.
      Set this in a platform-specific Home Manager module so Linux and Darwin can
      use different launchers.
    '';
  };

  config = {
    assertions = [
      {
        assertion = cfg.openCommand != null;
        message = "Set taco.yazi.openCommand in a platform-specific Home Manager module.";
      }
    ];

    programs.yazi = {
      enable = true;
      enableFishIntegration = false;
      shellWrapperName = "y";
      extraPackages = with pkgs; [
        fd
        file
        fzf
        jq
        ripgrep
        zoxide
      ];

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
        };

        opener = {
          edit = [
            {
              run = ''${pkgs.helix}/bin/hx "$@"'';
              block = true;
              desc = "Helix";
            }
          ];

          open = [
            {
              run = ''${cfg.openCommand} "$@"'';
              orphan = true;
              desc = "Open";
            }
          ];
        };
      };
    };
  };
}
