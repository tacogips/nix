{ ... }:
let
  secureGithubActionRoot = ../skills/secure-github-action;
  envrcGenerateRoot = ../skills/envrc-generate;
  codeWithCursorRoot = ../skills/code-with-cursor;
in
{
  home.file.".codex/skills/secure-github-action/SKILL.md".source =
    "${secureGithubActionRoot}/codex-SKILL.md";
  home.file.".codex/skills/secure-github-action/agents/openai.yaml".source =
    "${secureGithubActionRoot}/agents/openai.yaml";
  home.file.".codex/skills/secure-github-action/references/security-rules.md".source =
    "${secureGithubActionRoot}/references/security-rules.md";

  home.file.".codex/skills/envrc-generate/SKILL.md".source = "${envrcGenerateRoot}/codex-SKILL.md";
  home.file.".codex/skills/envrc-generate/agents/openai.yaml".source =
    "${envrcGenerateRoot}/agents/openai.yaml";

  home.file.".codex/skills/code-with-cursor/SKILL.md".source = "${codeWithCursorRoot}/codex-SKILL.md";
  home.file.".codex/skills/code-with-cursor/agents/openai.yaml".source =
    "${codeWithCursorRoot}/agents/openai.yaml";
  home.file.".codex/skills/code-with-cursor/references/execution-surfaces.md".source =
    "${codeWithCursorRoot}/references/execution-surfaces.md";
}
