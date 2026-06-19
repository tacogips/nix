{
  lib,
  riela-pkg ? null,
  ...
}:
let
  rielaBinary = if riela-pkg != null then "${riela-pkg}/bin/riela" else "riela";

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
    "riela-package-manager-skill"
    "riela-package-release-skill"
    "riela-temporary-workflow-skill"
    "riela-workflow-creator-skill"
    "riela-workflow-skill-creator-skill"
  ];
in
{
  home.packages = lib.optionals (riela-pkg != null) [
    # riela - workflow runtime/tooling shared across Linux and Darwin.
    riela-pkg
  ];

  home.activation.rielaDevPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    find_riela() {
      if [ -x "${rielaBinary}" ]; then
        printf '%s\n' "${rielaBinary}"
        return 0
      fi

      if command -v riela >/dev/null 2>&1; then
        command -v riela
        return 0
      fi

      for candidate in /opt/homebrew/bin/riela /usr/local/bin/riela; do
        if [ -x "$candidate" ]; then
          printf '%s\n' "$candidate"
          return 0
        fi
      done

      return 1
    }

    cleanup_riela_skill_artifacts() {
      AGENTS_SKILLS_DIR="$HOME/.agents/skills"
      CURSOR_RULES_DIR="$HOME/.cursor/rules"
      CURSOR_SKILLS_DIR="$HOME/.cursor/skills"
      NIX_REPO_DIR="$HOME/nix"
      RIELA_PACKAGES_DIR="$HOME/gits/tacogips/riela-packages/packages"
      LEGACY_RIEL_PREFIX="ri""el-"
      LEGACY_RIEL_CAP_PREFIX="Ri""el-"
      LEGACY_FLOW_PREFIX="ri""elflow"
      LEGACY_FLOW_CAP_PREFIX="Ri""elflow"
      LEGACY_FLOW_UPPER_PREFIX="RIEL""FLOW"
      LEGACY_CONTENT_PATTERN="(^|[^[:alnum:]_])$LEGACY_RIEL_PREFIX|$LEGACY_FLOW_PREFIX|$LEGACY_FLOW_CAP_PREFIX|$LEGACY_FLOW_UPPER_PREFIX"

      rm -rf \
        "$HOME/.claude/skills/$LEGACY_FLOW_PREFIX-package-installer" \
        "$HOME/.codex/skills/$LEGACY_FLOW_PREFIX-package-installer"

      for local_artifact_root in "$HOME/.skill" "$HOME/.skills" "$HOME/.riela"; do
        if [ -d "$local_artifact_root" ]; then
          find "$local_artifact_root" -mindepth 1 \
            \( -name "$LEGACY_RIEL_PREFIX*" -o -name "$LEGACY_RIEL_CAP_PREFIX*" -o -iname "*$LEGACY_FLOW_PREFIX*" -o -iname "*$LEGACY_FLOW_UPPER_PREFIX*" \) \
            -exec rm -rf {} + 2>/dev/null || true
        fi
      done

      if [ -d "$NIX_REPO_DIR" ]; then
        for project_skill_dir in \
          "$NIX_REPO_DIR/.agents/skills" \
          "$NIX_REPO_DIR/.claude/skills" \
          "$NIX_REPO_DIR/.codex/skills" \
          "$NIX_REPO_DIR/.cursor/skills"; do
          if [ -d "$project_skill_dir" ]; then
            find "$project_skill_dir" -mindepth 1 -maxdepth 1 \
              \( -name "$LEGACY_RIEL_PREFIX*" -o -name "$LEGACY_RIEL_CAP_PREFIX*" -o -name "$LEGACY_FLOW_PREFIX*" -o -name "$LEGACY_FLOW_CAP_PREFIX*" \) \
              -exec rm -rf {} + 2>/dev/null || true
          fi
        done
      fi

      for skill_dir in "$AGENTS_SKILLS_DIR" "$HOME/.claude/skills" "$HOME/.codex/skills"; do
        if [ -d "$skill_dir" ]; then
          find "$skill_dir" -mindepth 1 -maxdepth 1 \
            \( -name "$LEGACY_RIEL_PREFIX*" -o -name "$LEGACY_RIEL_CAP_PREFIX*" -o -name "$LEGACY_FLOW_PREFIX*" -o -name "$LEGACY_FLOW_CAP_PREFIX*" \) \
            -exec rm -rf {} + 2>/dev/null || true

          find "$skill_dir" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md' \
            -exec grep -IlE "$LEGACY_CONTENT_PATTERN" {} + 2>/dev/null \
            | while IFS= read -r stale_skill_file; do
              rm -rf "$(dirname "$stale_skill_file")"
            done || true
        fi
      done

      if [ -d "$CURSOR_RULES_DIR" ]; then
        find "$CURSOR_RULES_DIR" -mindepth 1 -maxdepth 1 -type f \
          \( -name "$LEGACY_RIEL_CAP_PREFIX*.mdc" -o -name "$LEGACY_FLOW_CAP_PREFIX*.mdc" -o -name "$LEGACY_RIEL_PREFIX*.mdc" -o -name "$LEGACY_FLOW_PREFIX*.mdc" \) \
          -exec rm -f {} + 2>/dev/null || true
        find "$CURSOR_RULES_DIR" -mindepth 1 -maxdepth 1 -type f \
          -exec grep -IlE "$LEGACY_CONTENT_PATTERN" {} + 2>/dev/null \
          | while IFS= read -r stale_rule_file; do
            rm -f "$stale_rule_file"
          done || true
      fi

      mkdir -p "$CURSOR_SKILLS_DIR"
      find "$CURSOR_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d \
        \( -name "$LEGACY_RIEL_CAP_PREFIX*" -o -name "$LEGACY_FLOW_CAP_PREFIX*" -o -name "$LEGACY_RIEL_PREFIX*" -o -name "$LEGACY_FLOW_PREFIX*" \) \
        -exec rm -rf {} + 2>/dev/null || true
      find "$CURSOR_SKILLS_DIR" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md' \
        -exec grep -IlE "$LEGACY_CONTENT_PATTERN" {} + 2>/dev/null \
        | while IFS= read -r stale_cursor_skill_file; do
          rm -rf "$(dirname "$stale_cursor_skill_file")"
        done || true
      find "$CURSOR_SKILLS_DIR" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md.tmp.*' \
        -exec rm -f {} + 2>/dev/null || true
    }

    if RIELA_BIN="$(find_riela)"; then
      echo "Installing riela development workflow packages..."

      cleanup_riela_skill_artifacts

      for package_id in ${lib.concatStringsSep " " devWorkflowPackages}; do
        package_source="$RIELA_PACKAGES_DIR/$package_id"

        if [ ! -d "$package_source" ]; then
          echo "Warning: riela package source '$package_source' not found; skipping '$package_id'"
          continue
        fi

        if ! "$RIELA_BIN" package install "$package_id" \
          --source "$package_source" \
          --scope user \
          --overwrite \
          --yes \
          --output json >/dev/null; then
          echo "Warning: failed to install riela package '$package_id'; continuing activation"
        fi
      done

      cleanup_riela_skill_artifacts
    else
      echo "Warning: riela command not found; skipping riela development workflow package install"
    fi
  '';
}
