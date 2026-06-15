{
  lib,
  rielflow-pkg ? null,
  ...
}:
let
  rielflowBinary = if rielflow-pkg != null then "${rielflow-pkg}/bin/rielflow" else "rielflow";

  devWorkflowPackages = [
    "claude-code-adversarial-implementation-review-loop"
    "claude-code-deepdesign"
    "claude-code-design-and-implement-review-loop"
    "claude-code-goal"
    "claude-code-impl-plan-completion-loop"
    "claude-code-recent-change-quality-loop"
    "claude-code-refactoring-divide-and-conquer"
    "claude-code-refactoring-slice-review"
    "claude-code-simple-work-package"
    "claude-code-source-security-check-loop"
    "claude-code-task-watchdog"
    "claude-code-website-builder"
    "codex-adversarial-implementation-review-loop"
    "codex-deep-creation"
    "codex-deepdesign"
    "codex-design-and-implement-review-loop"
    "codex-goal"
    "codex-impl-plan-completion-loop"
    "codex-impl-plan-completion-review-loop"
    "codex-recent-change-quality-loop"
    "codex-refactoring-divide-and-conquer"
    "codex-refactoring-slice-review"
    "codex-simple-work-package"
    "codex-source-security-check-loop"
    "codex-task-watchdog"
    "codex-website-builder"
    "cursor-cli-hydra-claude-design-and-implement-review-loop"
    "cursor-cli-hydra-codex-design-and-implement-review-loop"
    "cursor-cli-goal"
    "cursor-cli-developer-workflows"
    "rielflow-package-manager-skill"
    "rielflow-package-release-skill"
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

    cleanup_rielflow_skill_artifacts() {
      AGENTS_SKILLS_DIR="$HOME/.agents/skills"
      CURSOR_RULES_DIR="$HOME/.cursor/rules"
      CURSOR_SKILLS_DIR="$HOME/.cursor/skills"
      NIX_REPO_DIR="$HOME/nix"

      rm -rf \
        "$HOME/.claude/skills/rielflow-package-installer" \
        "$HOME/.codex/skills/rielflow-package-installer"

      if [ -d "$NIX_REPO_DIR" ]; then
        for project_skill_dir in \
          "$NIX_REPO_DIR/.agents/skills" \
          "$NIX_REPO_DIR/.claude/skills" \
          "$NIX_REPO_DIR/.codex/skills" \
          "$NIX_REPO_DIR/.cursor/skills"; do
          if [ -d "$project_skill_dir" ]; then
            find "$project_skill_dir" -mindepth 1 -maxdepth 1 \
              \( -name 'riel-*' -o -name 'rielflow-*' -o -name 'cursor-cli-*' -o -name 'Riel*' -o -name 'Rielflow*' \) \
              -exec rm -rf {} + 2>/dev/null || true
          fi
        done
      fi

      if [ -d "$AGENTS_SKILLS_DIR" ]; then
        find "$AGENTS_SKILLS_DIR" -mindepth 1 -maxdepth 1 \
          \( -name 'riel-*' -o -name 'rielflow-*' \) \
          -exec rm -rf {} + 2>/dev/null || true
      fi

      if [ -d "$CURSOR_RULES_DIR" ]; then
        find "$CURSOR_RULES_DIR" -mindepth 1 -maxdepth 1 -type f \
          \( -name 'Riel*.mdc' -o -name 'Rielflow*.mdc' -o -name 'riel-*.mdc' -o -name 'rielflow-*.mdc' -o -name 'cursor-cli-*.mdc' \) \
          -exec rm -f {} + 2>/dev/null || true
      fi

      mkdir -p "$CURSOR_SKILLS_DIR"
      find "$CURSOR_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d \
        \( -name 'Riel*' -o -name 'Rielflow*' -o -name 'riel-*' -o -name 'rielflow-*' -o -name 'cursor-cli-*' \) \
        -exec rm -rf {} + 2>/dev/null || true
      find "$CURSOR_SKILLS_DIR" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md.tmp.*' \
        -exec rm -f {} + 2>/dev/null || true
    }

    if RIELFLOW_BIN="$(find_rielflow)"; then
      echo "Installing rielflow development workflow packages..."

      if ! "$RIELFLOW_BIN" package search codex --registry default --refresh >/dev/null 2>&1; then
        echo "Warning: failed to refresh rielflow default package registry; continuing activation"
      fi

      cleanup_rielflow_skill_artifacts

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
