{
  lib,
  ign-pkg ? null,
  ...
}:

{
  home.packages = lib.optionals (ign-pkg != null) [
    # ign - Template-based code generation CLI tool
    ign-pkg
  ];

  home.activation.ignHomebrewPackage = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.optionalString (ign-pkg == null) ''
      find_brew() {
        if command -v brew >/dev/null 2>&1; then
          command -v brew
          return 0
        fi

        for candidate in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew /usr/local/bin/brew; do
          if [ -x "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
          fi
        done

        return 1
      }

      if command -v ign >/dev/null 2>&1; then
        :
      elif BREW_BIN="$(find_brew)"; then
        echo "Installing ign with Homebrew..."
        "$BREW_BIN" tap tacogips/tap >/dev/null
        "$BREW_BIN" install tacogips/tap/ign
      else
        echo "Warning: Homebrew command not found; skipping ign Homebrew install"
      fi
    ''
  );
}
