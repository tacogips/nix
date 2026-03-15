{ ... }:

[
  {
    label = "cargo check";
    command = "cargo";
    args = [ "check" ];
    tags = [ "rust-check" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
  {
    label = "cargo build";
    command = "cargo";
    args = [ "build" ];
    tags = [ "rust-build" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
  {
    label = "cargo test";
    command = "cargo";
    args = [ "test" ];
    tags = [ "rust-test" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
  {
    label = "go build";
    command = "go";
    args = [
      "build"
      "./..."
    ];
    tags = [ "go-build" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
  {
    label = "go test";
    command = "go";
    args = [
      "test"
      "./..."
    ];
    tags = [ "go-test" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
  {
    label = "nix flake check";
    command = "nix";
    args = [
      "flake"
      "check"
    ];
    tags = [ "nix-check" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
  {
    label = "nixos-rebuild switch";
    command = "sudo";
    args = [
      "nixos-rebuild"
      "switch"
      "--flake"
      ".#nix-dev-machine"
    ];
    cwd = "$ZED_WORKTREE_ROOT/linux";
    tags = [ "nix-rebuild" ];
    use_new_terminal = false;
    allow_concurrent_runs = false;
    reveal = "always";
  }
]
