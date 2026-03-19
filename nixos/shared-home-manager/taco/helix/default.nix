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
      theme = "catppuccin_mocha";

      keys = import ./keymap.nix;
    };

    languages = import ./languages.nix;
  };
}
