{ lib, pkgs, ... }:

let
  divedraDevWorkflowNames = [
    "design-and-implement-review-loop"
    "design-and-implement-review-loop-feature-plan"
    "impl-plan-completion-loop"
    "recent-change-quality-loop"
    "refactoring-divide-and-conquer"
    "refactoring-slice-review"
  ];
  divedraDevSkillNames = [
    "divedra-auto-improve"
    "divedra-impl-workflow"
    "divedra-refactoring-workflow"
    "divedra-workflow-checkout"
    "divedra-workflow-reference"
    "divedra-workflow-run"
    "divedra-workflow-test"
    "ts-coding-standards"
    "ts-review"
  ];
  workflowList = lib.concatStringsSep " " divedraDevWorkflowNames;
  skillList = lib.concatStringsSep " " divedraDevSkillNames;
  tsSecurityReference = pkgs.writeText "divedra-ts-security-reference.md" ''
    # Security Guidelines

    Use the user-scope commit safety reference for credential, private URL, and
    machine-local path checks:

    - `~/.agents/skills/git-precommit-safety-check/references/security.md`

    For commit, amend, or push preparation, use the `git-precommit-safety-check`
    skill. It checks the actual commit target without relying on gitleaks.
  '';
in
{
  home.activation.divedraDevWorkflows = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SOURCE_WORKFLOWS_DIR="$HOME/gits/tacogips/divedra/.divedra/workflows"
    TARGET_WORKFLOWS_DIR="$HOME/.divedra/workflows"

    if [ ! -d "$SOURCE_WORKFLOWS_DIR" ]; then
      echo "warning: divedra development workflow source not found: $SOURCE_WORKFLOWS_DIR" >&2
      exit 0
    fi

    mkdir -p "$TARGET_WORKFLOWS_DIR"

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
        rm -rf "$target_path"
      elif [ -e "$target_path" ]; then
        echo "warning: not replacing existing non-symlink divedra workflow: $target_path" >&2
        continue
      fi

      mkdir -p "$target_path"
      cp -R "$source_path/." "$target_path/"
      touch "$target_path/.nix-managed-divedra-dev-workflow"
    done
  '';

  home.activation.divedraDevWorkflowSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SOURCE_SKILLS_DIR="$HOME/gits/tacogips/divedra/.agents/skills"
    TARGET_SKILLS_DIR="$HOME/.agents/skills"

    if [ ! -d "$SOURCE_SKILLS_DIR" ]; then
      echo "warning: divedra development skill source not found: $SOURCE_SKILLS_DIR" >&2
      exit 0
    fi

    mkdir -p "$TARGET_SKILLS_DIR"

    for skill_name in ${skillList}; do
      source_path="$SOURCE_SKILLS_DIR/$skill_name"
      target_path="$TARGET_SKILLS_DIR/$skill_name"

      if [ ! -f "$source_path/SKILL.md" ]; then
        echo "warning: skipping divedra skill without SKILL.md: $source_path" >&2
        continue
      fi

      if [ -L "$target_path" ]; then
        rm "$target_path"
      elif [ -e "$target_path" ]; then
        rm -rf "$target_path"
      fi

      mkdir -p "$target_path"
      cp -R "$source_path/." "$target_path/"
      touch "$target_path/.nix-managed-divedra-dev-skill"
    done

    patch_skill() {
      local skill_path="$1"

      if [ -f "$skill_path" ]; then
        sed -i.bak \
          -e 's#project-local divedra workflow `\.divedra/workflows/#user-scope divedra workflow `~/.divedra/workflows/#g' \
          -e 's#project-local divedra divide-and-conquer refactoring workflow#user-scope divedra divide-and-conquer refactoring workflow#g' \
          -e 's#project-local workflow bundle#user-scope workflow bundle#g' \
          -e 's#Catalog path: `\.divedra/workflows/#Catalog path: `~/.divedra/workflows/#g' \
          -e 's#\.divedra/workflows/refactoring-divide-and-conquer#~/.divedra/workflows/refactoring-divide-and-conquer#g' \
          -e 's#\.divedra/workflows/refactoring-slice-review#~/.divedra/workflows/refactoring-slice-review#g' \
          -e 's#task divedra-design-implement -- --output json#divedra workflow run design-and-implement-review-loop --scope user --output json#g' \
          -e 's|nix run \.\#divedra -- workflow run design-and-implement-review-loop --output json|divedra workflow run design-and-implement-review-loop --scope user --output json|g' \
          -e 's#bun run src/main.ts workflow run refactoring-divide-and-conquer \\\\#divedra workflow run refactoring-divide-and-conquer --scope user \\\\#g' \
          -e 's#  --workflow-definition-dir \.divedra/workflows \\\\##g' \
          -e 's#bun run src/main.ts session #divedra session #g' \
          -e 's#bun run src/main.ts workflow validate refactoring-divide-and-conquer --workflow-definition-dir \.divedra/workflows#divedra workflow validate refactoring-divide-and-conquer --scope user#g' \
          -e 's#bun run src/main.ts workflow validate refactoring-slice-review --workflow-definition-dir \.divedra/workflows#divedra workflow validate refactoring-slice-review --scope user#g' \
          "$skill_path"
        rm -f "$skill_path.bak"
      fi
    }

    patch_skill "$TARGET_SKILLS_DIR/divedra-impl-workflow/SKILL.md"
    patch_skill "$TARGET_SKILLS_DIR/divedra-refactoring-workflow/SKILL.md"

    mkdir -p "$TARGET_SKILLS_DIR/ts-coding-standards"
    cp ${tsSecurityReference} "$TARGET_SKILLS_DIR/ts-coding-standards/security.md"
  '';
}
