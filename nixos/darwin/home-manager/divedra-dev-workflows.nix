{ lib, ... }:

let
  divedraDevAssets = ./divedra-dev-assets;
  divedraDevWorkflowsRoot = "${divedraDevAssets}/workflows";
  divedraDevSkillsRoot = "${divedraDevAssets}/skills";
  # Codex-agent workflows (executionBackend: codex-agent). Future Cursor-agent
  # workflows will use a separate cursor-* naming prefix.
  divedraDevWorkflowNames = [
    "codex-design-and-implement-review-loop"
    "codex-design-and-implement-review-loop-feature-plan"
    "codex-impl-plan-completion-loop"
    "codex-recent-change-quality-loop"
    "codex-refactoring-divide-and-conquer"
    "codex-refactoring-slice-review"
  ];
  divedraDevSkillNames = [
    "divedra-codex-impl-workflow"
    "divedra-codex-refactoring-workflow"
    "divedra-workflow"
    "divedra-workflow-checkout"
    "divedra-workflow-organizer"
    "divedra-workflow-reference"
    "divedra-workflow-run"
    "divedra-workflow-test"
    "git-new-branch"
  ];
  obsoleteDivedraDevWorkflowNames = [
    "design-and-implement-review-loop"
    "design-and-implement-review-loop-feature-plan"
    "impl-plan-completion-loop"
    "recent-change-quality-loop"
    "refactoring-divide-and-conquer"
    "refactoring-slice-review"
  ];
  # Legacy names only: remove old managed copies from ~/.agents/skills on activation.
  # ts-coding-standards and ts-review are not installed as user skills.
  obsoleteDivedraDevSkillNames = [
    "divedra-impl-workflow"
    "divedra-refactoring-workflow"
    "divedra-auto-improve"
    "divedra-event-sources"
    "divedra-fix"
    "divedra-manager-control"
    "divedra-node-addons"
    "divedra-release"
    "divedra-troubleshooting"
    "divedra-tui-operator"
    "ts-coding-standards"
    "ts-review"
  ];
  workflowList = lib.concatStringsSep " " divedraDevWorkflowNames;
  obsoleteWorkflowList = lib.concatStringsSep " " obsoleteDivedraDevWorkflowNames;
  skillList = lib.concatStringsSep " " divedraDevSkillNames;
  obsoleteSkillList = lib.concatStringsSep " " obsoleteDivedraDevSkillNames;
in
{
  home.activation.divedraDevWorkflows = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SOURCE_WORKFLOWS_DIR="${divedraDevWorkflowsRoot}"
    TARGET_WORKFLOWS_DIR="$HOME/.divedra/workflows"

    mkdir -p "$TARGET_WORKFLOWS_DIR"

    make_managed_tree_writable() {
      local target_path="$1"
      local marker_file="$2"

      if [ -e "$target_path" ] && [ -f "$target_path/$marker_file" ]; then
        chmod -R u+rwX "$target_path"
      fi
    }

    for workflow_name in ${obsoleteWorkflowList}; do
      target_path="$TARGET_WORKFLOWS_DIR/$workflow_name"

      if [ -e "$target_path/.nix-managed-divedra-dev-workflow" ]; then
        make_managed_tree_writable "$target_path" ".nix-managed-divedra-dev-workflow"
        rm -rf "$target_path"
      fi
    done

    for workflow_name in ${workflowList}; do
      source_path="$SOURCE_WORKFLOWS_DIR/$workflow_name"
      target_path="$TARGET_WORKFLOWS_DIR/$workflow_name"

      if [ ! -f "$source_path/workflow.json" ]; then
        echo "warning: skipping divedra workflow without workflow.json: $source_path" >&2
        continue
      fi

      if [ -L "$target_path" ]; then
        rm "$target_path"
      elif [ -e "$target_path" ] && [ -f "$target_path/.nix-managed-divedra-dev-workflow" ]; then
        make_managed_tree_writable "$target_path" ".nix-managed-divedra-dev-workflow"
        rm -rf "$target_path"
      elif [ -e "$target_path" ]; then
        echo "warning: not replacing existing non-symlink divedra workflow: $target_path" >&2
        continue
      fi

      mkdir -p "$target_path"
      cp -R "$source_path/." "$target_path/"
      chmod -R u+rwX "$target_path"
      touch "$target_path/.nix-managed-divedra-dev-workflow"
    done
  '';

  home.activation.divedraDevWorkflowSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SOURCE_SKILLS_DIR="${divedraDevSkillsRoot}"
    TARGET_SKILLS_DIR="$HOME/.agents/skills"

    mkdir -p "$TARGET_SKILLS_DIR"

    make_managed_tree_writable() {
      local target_path="$1"
      local marker_file="$2"

      if [ -e "$target_path" ] && [ -f "$target_path/$marker_file" ]; then
        chmod -R u+rwX "$target_path"
      fi
    }

    for skill_name in ${obsoleteSkillList}; do
      target_path="$TARGET_SKILLS_DIR/$skill_name"

      if [ -e "$target_path/.nix-managed-divedra-dev-skill" ]; then
        make_managed_tree_writable "$target_path" ".nix-managed-divedra-dev-skill"
        rm -rf "$target_path"
      fi
    done

    for skill_name in ${skillList}; do
      source_path="$SOURCE_SKILLS_DIR/$skill_name"
      target_path="$TARGET_SKILLS_DIR/$skill_name"

      if [ ! -f "$source_path/SKILL.md" ]; then
        echo "warning: skipping divedra skill without SKILL.md: $source_path" >&2
        continue
      fi

      if [ -L "$target_path" ]; then
        rm "$target_path"
      elif [ -e "$target_path" ] && [ -f "$target_path/.nix-managed-divedra-dev-skill" ]; then
        make_managed_tree_writable "$target_path" ".nix-managed-divedra-dev-skill"
        rm -rf "$target_path"
      elif [ -e "$target_path" ]; then
        echo "warning: not replacing existing non-symlink divedra skill: $target_path" >&2
        continue
      fi

      mkdir -p "$target_path"
      cp -R "$source_path/." "$target_path/"
      chmod -R u+rwX "$target_path"
      touch "$target_path/.nix-managed-divedra-dev-skill"
    done
  '';
}
