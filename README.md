# Build the first nix version.

```bash
cd fetus
bash ignite.sh
```

# build taco main dev machine

```bash
   sudo nixos-rebuild switch --flake ~/nix/nixos#taco-main
```

# update

nix flake lock --update-input cratedocs-mcp
nix flake update
