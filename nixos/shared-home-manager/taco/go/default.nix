{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Go compiler and toolchain
    go

    # Go language server for editor integration
    gopls

    # Go tools
    gotools # Additional Go tools (goimports, guru, etc.)
    go-tools # Static analysis tools (staticcheck, etc.)

    # Delve debugger for Go
    delve

    # golangci-lint for comprehensive linting
    golangci-lint

    # gomodifytags for struct tag manipulation
    gomodifytags

    # impl for generating method stubs
    impl

    # gotests for generating table-driven tests
    gotests

    # gore for Go REPL
    gore
  ];
}
