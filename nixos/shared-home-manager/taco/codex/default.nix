{
  lib,
  pkgs,
  ...
}:
let
  secureGithubActionRoot = ../skills/secure-github-action;
  envrcGenerateRoot = ../skills/envrc-generate;
  codeWithCursorRoot = ../skills/code-with-cursor;
in
{
  home.activation.codexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CODEX_SKILLS_DIR="$HOME/.codex/skills"

    mkdir -p "$CODEX_SKILLS_DIR"

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
      "$CODEX_SKILLS_DIR/secure-github-action/SKILL.md"
    install_skill_file \
      "${secureGithubActionRoot}/agents/openai.yaml" \
      "$CODEX_SKILLS_DIR/secure-github-action/agents/openai.yaml"
    install_skill_file \
      "${secureGithubActionRoot}/references/security-rules.md" \
      "$CODEX_SKILLS_DIR/secure-github-action/references/security-rules.md"

    install_skill_file \
      "${envrcGenerateRoot}/codex-SKILL.md" \
      "$CODEX_SKILLS_DIR/envrc-generate/SKILL.md"
    install_skill_file \
      "${envrcGenerateRoot}/agents/openai.yaml" \
      "$CODEX_SKILLS_DIR/envrc-generate/agents/openai.yaml"

    install_skill_file \
      "${codeWithCursorRoot}/codex-SKILL.md" \
      "$CODEX_SKILLS_DIR/code-with-cursor/SKILL.md"
    install_skill_file \
      "${codeWithCursorRoot}/agents/openai.yaml" \
      "$CODEX_SKILLS_DIR/code-with-cursor/agents/openai.yaml"
    install_skill_file \
      "${codeWithCursorRoot}/references/execution-surfaces.md" \
      "$CODEX_SKILLS_DIR/code-with-cursor/references/execution-surfaces.md"

    rm -rf "$CODEX_SKILLS_DIR/code-with-composer"
  '';
}
