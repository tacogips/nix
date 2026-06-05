{
  lib,
  rielflow-pkg ? null,
  ...
}:
let
  rielflowBinary = if rielflow-pkg != null then "${rielflow-pkg}/bin/rielflow" else "rielflow";

  devWorkflowPackages = [
    "codex-deepdesign"
    "codex-design-and-implement-review-loop"
    "codex-impl-plan-completion-loop"
    "codex-recent-change-quality-loop"
    "codex-refactoring-divide-and-conquer"
    "codex-refactoring-slice-review"
    "codex-simple-work-package"
    "codex-task-watchdog"
    "rielflow-package-installer-skill"
    "rielflow-temporary-workflow-skill"
    "rielflow-workflow-creator-skill"
    "rielflow-workflow-skill-creator-skill"
  ];
in
{
  home.packages = lib.optionals (rielflow-pkg != null) [
    # rielflow - workflow runtime/tooling shared across Linux and Darwin.
    rielflow-pkg
  ];

  home.activation.rielflowDevPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    find_rielflow() {
      if [ -x "${rielflowBinary}" ]; then
        printf '%s\n' "${rielflowBinary}"
        return 0
      fi

      if command -v rielflow >/dev/null 2>&1; then
        command -v rielflow
        return 0
      fi

      for candidate in /opt/homebrew/bin/rielflow /usr/local/bin/rielflow; do
        if [ -x "$candidate" ]; then
          printf '%s\n' "$candidate"
          return 0
        fi
      done

      return 1
    }

    if RIELFLOW_BIN="$(find_rielflow)"; then
      echo "Installing rielflow development workflow packages..."

      if ! "$RIELFLOW_BIN" package search codex --registry default --refresh >/dev/null 2>&1; then
        echo "Warning: failed to refresh rielflow default package registry; continuing activation"
      fi

      for package_id in ${lib.concatStringsSep " " devWorkflowPackages}; do
        if ! "$RIELFLOW_BIN" package install "$package_id" \
          --registry default \
          --user-scope \
          --pre-install-check \
          --overwrite \
          --yes \
          --output json >/dev/null; then
          echo "Warning: failed to install rielflow package '$package_id'; continuing activation"
        fi
      done
    else
      echo "Warning: rielflow command not found; skipping rielflow development workflow package install"
    fi
  '';
}
