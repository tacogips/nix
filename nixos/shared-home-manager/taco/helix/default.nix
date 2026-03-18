{
  lib,
  pkgs,
  ...
}:

{
  # Shared Helix configuration.
  # Language servers for Rust, Go, and TypeScript React are installed here so
  # Helix has the required binaries on both Linux and Darwin.
  home.packages =
    with pkgs;
    [
      basedpyright
      gopls
      nodePackages.typescript
      nodePackages.typescript-language-server
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      rust-analyzer
    ];

  programs.helix = {
    enable = true;

    settings = {
      theme = "hex_toxic";

      keys = import ./keymap.nix;
    };

    languages = import ./languages.nix;
  };
}
