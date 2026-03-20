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
      theme = "taco_gruvbox_dark";

      keys = import ./keymap.nix;
    };

    languages = import ./languages.nix;

    themes.taco_gruvbox_dark = {
      inherits = "gruvbox";

      # Soften a few noisy syntax groups that stand out too much in Rust.
      comment = {
        fg = "#928374";
        modifiers = [ ];
      };
      keyword = {
        fg = "#d79921";
        modifiers = [ ];
      };
      string = {
        fg = "#689d6a";
        modifiers = [ ];
      };
    };
  };
}
