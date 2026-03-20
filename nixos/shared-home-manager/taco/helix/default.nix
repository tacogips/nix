{
  lib,
  pkgs,
  ...
}:

{
  # Shared Helix configuration.
  # Language servers for Rust, Go, TypeScript React, and Zig are installed
  # here so Helix has the required binaries on both Linux and Darwin.
  home.packages =
    with pkgs;
    [
      basedpyright
      gopls
      nodePackages.typescript
      nodePackages.typescript-language-server
      zls
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      rust-analyzer
    ];

  programs.helix = {
    enable = true;

    settings = {
      theme = "taco_catppuccin_mocha";

      keys = import ./keymap.nix;
    };

    languages = import ./languages.nix;

    themes.taco_catppuccin_mocha = {
      inherits = "catppuccin_mocha";

      # Soften a few noisy syntax groups that stand out too much in Rust.
      comment = {
        fg = "overlay1";
        modifiers = [ ];
      };
      keyword = {
        fg = "lavender";
        modifiers = [ ];
      };
      string = {
        fg = "teal";
        modifiers = [ ];
      };
    };
  };
}
