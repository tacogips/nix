[
  (final: prev: {
    # Work around a broken nixpkgs direnv derivation on Darwin.
    # The regression came from NixOS/nixpkgs#486452:
    # https://github.com/NixOS/nixpkgs/pull/486452
    # It disabled cgo while direnv still built with -linkmode=external on
    # Darwin, which fails with:
    # "-linkmode=external requires external (cgo) linking, but cgo is not
    # enabled".
    #
    # Upstream fix:
    # https://github.com/NixOS/nixpkgs/commit/a4fb16db2751d9c9e5f3512c697d2ac49d406789
    #
    # This overlay should become unnecessary after the next nixpkgs update
    # that includes that commit.
    direnv = prev.direnv.overrideAttrs (_: {
      allowGoReference = true;
      env = (prev.direnv.env or { }) // {
        CGO_ENABLED = "1";
      };
    });
  })
]
