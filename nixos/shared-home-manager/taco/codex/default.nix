{
  lib,
  pkgs,
  ...
}:
let
  secureGithubActionRoot = ../skills/secure-github-action;
  envrcGenerateRoot = ../skills/envrc-generate;
  codeWithCursorRoot = ../skills/code-with-cursor;
  braveBrowserComputerUseRoot = ../skills/brave-browser-computer-use;
  gitPrecommitSafetyCheckRoot = ../skills/git-precommit-safety-check;
  improveRoot = ../skills/improve;
in
{
  home.activation.codexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    AGENTS_SKILLS_DIR="$HOME/.agents/skills"
    OLD_CODEX_SKILLS_DIR="$HOME/.codex/skills"

    mkdir -p "$AGENTS_SKILLS_DIR"

    install_skill_file() {
      local source_path="$1"
      local target_path="$2"
      local target_dir

      target_dir="$(dirname "$target_path")"
      mkdir -p "$target_dir"

      if [ -L "$target_path" ] || [ -e "$target_path" ]; then
        rm -f "$target_path"
      fi

      cp "$source_path" "$target_path"
    }

    install_skill_file \
      "${secureGithubActionRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/secure-github-action/SKILL.md"
    install_skill_file \
      "${secureGithubActionRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/secure-github-action/agents/openai.yaml"
    install_skill_file \
      "${secureGithubActionRoot}/references/security-rules.md" \
      "$AGENTS_SKILLS_DIR/secure-github-action/references/security-rules.md"

    install_skill_file \
      "${envrcGenerateRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/envrc-generate/SKILL.md"
    install_skill_file \
      "${envrcGenerateRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/envrc-generate/agents/openai.yaml"

    install_skill_file \
      "${codeWithCursorRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/code-with-cursor/SKILL.md"
    install_skill_file \
      "${codeWithCursorRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/code-with-cursor/agents/openai.yaml"
    install_skill_file \
      "${codeWithCursorRoot}/references/execution-surfaces.md" \
      "$AGENTS_SKILLS_DIR/code-with-cursor/references/execution-surfaces.md"
    install_skill_file \
      "${codeWithCursorRoot}/scripts/cursor-agent-monitor.sh" \
      "$AGENTS_SKILLS_DIR/code-with-cursor/scripts/cursor-agent-monitor.sh"
    install_skill_file \
      "${codeWithCursorRoot}/scripts/cursor-agent-monitor-linux.sh" \
      "$AGENTS_SKILLS_DIR/code-with-cursor/scripts/cursor-agent-monitor-linux.sh"
    install_skill_file \
      "${codeWithCursorRoot}/scripts/cursor-agent-monitor-darwin.sh" \
      "$AGENTS_SKILLS_DIR/code-with-cursor/scripts/cursor-agent-monitor-darwin.sh"
    chmod +x "$AGENTS_SKILLS_DIR/code-with-cursor/scripts/cursor-agent-monitor.sh"
    chmod +x "$AGENTS_SKILLS_DIR/code-with-cursor/scripts/cursor-agent-monitor-linux.sh"
    chmod +x "$AGENTS_SKILLS_DIR/code-with-cursor/scripts/cursor-agent-monitor-darwin.sh"

    install_skill_file \
      "${braveBrowserComputerUseRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/brave-browser-computer-use/SKILL.md"
    install_skill_file \
      "${braveBrowserComputerUseRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/brave-browser-computer-use/agents/openai.yaml"

    install_skill_file \
      "${gitPrecommitSafetyCheckRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/git-precommit-safety-check/SKILL.md"
    install_skill_file \
      "${gitPrecommitSafetyCheckRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/git-precommit-safety-check/agents/openai.yaml"
    install_skill_file \
      "${gitPrecommitSafetyCheckRoot}/references/security.md" \
      "$AGENTS_SKILLS_DIR/git-precommit-safety-check/references/security.md"

    install_skill_file \
      "${improveRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/improve/SKILL.md"
    install_skill_file \
      "${improveRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/improve/agents/openai.yaml"

    rm -rf "$AGENTS_SKILLS_DIR/code-with-composer"
    rm -rf "$OLD_CODEX_SKILLS_DIR/secure-github-action"
    rm -rf "$OLD_CODEX_SKILLS_DIR/envrc-generate"
    rm -rf "$OLD_CODEX_SKILLS_DIR/code-with-cursor"
    rm -rf "$OLD_CODEX_SKILLS_DIR/code-with-composer"
    rm -rf "$OLD_CODEX_SKILLS_DIR/brave-browser-computer-use"
  '';
}
