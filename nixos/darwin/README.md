# Darwin configuration

This flake defines nix-darwin hosts for macOS.

## App modules

Reusable app installation modules live in `modules/apps/`. Each app exposes a
host-level option under `taco.darwin.apps.<app>.enable`, so non-`taco-mac`
Darwin hosts can opt into only the apps they need.

Example server-oriented host module:

```nix
{
  imports = [
    ./modules/apps
  ];

  taco.darwin.apps = {
    container-tools.enable = true;
    ghostty.enable = true;
    rielflow.enable = true;
  };
}
```

The `profiles/taco-apps.nix` profile enables the full app set currently used by
`taco-mac`.
