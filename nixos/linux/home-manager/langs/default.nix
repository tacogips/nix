{
  config,
  pkgs,
  lib,
  fenix,
  ...
}:

{
  # We'll receive the fenix input directly, so no need for a separate overlay here

  home.packages = with pkgs; [
    (fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-analyzer"
    ])

    # Python with common packages
    (python3.withPackages (
      ps: with ps; [
        pip
        black
        flake8
        uv
      ]
    ))

    ## Go and useful tools
    #go
    #gopls
    #golangci-lint
    #delve # Go debugger

    # Zig compiler
    zig
    ruff

    package-version-server # used in zed

  ];

  # Configure environment variables for these tools
  home.sessionVariables = {
    # Rust
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";

    ## Go
    #GOPATH = "${config.home.homeDirectory}/go";
    #GOBIN = "${config.home.homeDirectory}/go/bin";

    # Add the bins to PATH
    PATH = "${config.home.homeDirectory}/go/bin:${config.home.homeDirectory}/.cargo/bin:$PATH";
  };
}
