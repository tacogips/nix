{ pkgs, ... }:

{
  # Shared Helix configuration.
  # Only the subset of Zed's custom bindings with clear Helix equivalents is
  # ported here; panel-oriented and GUI-only bindings stay in Zed.
  # Language servers for Rust, Go, and TypeScript React are installed here so
  # Helix has the required binaries on both Linux and Darwin.
  home.packages = with pkgs; [
    gopls
    rust-analyzer
    nodePackages.typescript
    nodePackages.typescript-language-server
  ];

  programs.helix = {
    enable = true;

    settings = {
      keys = import ./keymap.nix;
    };

    languages = import ./languages.nix;
  };
}
