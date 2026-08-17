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
  improveRoot = ../skills/improve;
  productHuntReleaseRoot = ../skills/product-hunt-release;
  rielaRoot = ../skills/riela;
  # Upstream: https://github.com/cathrynlavery/diagram-design
  diagramDesignRoot =
    (pkgs.fetchFromGitHub {
      owner = "cathrynlavery";
      repo = "diagram-design";
      rev = "a157f7616473d966d6f433cf0b4d4f1880603504";
      hash = "sha256-tJVDM9Ujeu4mXLB6SHk62zxIJ0m+VqJu6xX7fJ8IwAo=";
    })
    + "/skills/diagram-design";
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
      "${improveRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/improve/SKILL.md"
    install_skill_file \
      "${improveRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/improve/agents/openai.yaml"

    install_skill_file \
      "${productHuntReleaseRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/product-hunt-release/SKILL.md"
    install_skill_file \
      "${productHuntReleaseRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/product-hunt-release/agents/openai.yaml"

    install_skill_file \
      "${rielaRoot}/codex-SKILL.md" \
      "$AGENTS_SKILLS_DIR/riela/SKILL.md"
    install_skill_file \
      "${rielaRoot}/agents/openai.yaml" \
      "$AGENTS_SKILLS_DIR/riela/agents/openai.yaml"

    rm -rf "$AGENTS_SKILLS_DIR/diagram-design"
    cp -R "${diagramDesignRoot}" "$AGENTS_SKILLS_DIR/diagram-design"
    chmod -R u+w "$AGENTS_SKILLS_DIR/diagram-design"

    rm -rf "$AGENTS_SKILLS_DIR/code-with-composer"
    rm -rf "$OLD_CODEX_SKILLS_DIR/secure-github-action"
    rm -rf "$OLD_CODEX_SKILLS_DIR/envrc-generate"
    rm -rf "$OLD_CODEX_SKILLS_DIR/code-with-cursor"
    rm -rf "$OLD_CODEX_SKILLS_DIR/code-with-composer"
    rm -rf "$OLD_CODEX_SKILLS_DIR/brave-browser-computer-use"
    rm -rf "$OLD_CODEX_SKILLS_DIR/diagram-design"
  '';
}
