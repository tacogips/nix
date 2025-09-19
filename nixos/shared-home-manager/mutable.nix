{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.home;
in {
  options.home.file = mkOption {
    type = with types; attrsOf (submodule ({ name, config, ... }: {
      options = {
        mutable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If true, the file will be copied instead of symlinked.
            This allows the file to be mutable after deployment.
          '';
        };
        force = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to force the creation of the file.
            Required when using mutable = true.
          '';
        };
      };
    }));
  };

  config = {
    home.activation = lib.mkMerge (
      lib.mapAttrsToList (name: file:
        lib.mkIf (file.mutable && file.force) {
          "copy-${name}" = lib.hm.dag.entryAfter ["writeBoundary"] ''
            target="$HOME/${file.target or name}"
            if [[ -h "$target" ]]; then
              $DRY_RUN_CMD rm "$target"
            fi
            $DRY_RUN_CMD mkdir -p "$(dirname "$target")"
            if [[ -n "${file.text or ""}" ]]; then
              $DRY_RUN_CMD cat > "$target" << 'EOF'
${file.text}
EOF
            elif [[ -n "${file.source or ""}" ]]; then
              $DRY_RUN_CMD cp -r "${file.source}" "$target"
            fi
            $DRY_RUN_CMD chmod ${if file.executable then "755" else "644"} "$target"
          '';
        }
      ) cfg.file
    );
  };
}