{ ... }:
let
  secureGithubActionRoot = ../skills/secure-github-action;
  envrcGenerateRoot = ../skills/envrc-generate;
  codeWithComposerRoot = ../skills/code-with-composer;
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

  home.file.".codex/skills/code-with-composer/SKILL.md".source =
    "${codeWithComposerRoot}/codex-SKILL.md";
  home.file.".codex/skills/code-with-composer/agents/openai.yaml".source =
    "${codeWithComposerRoot}/agents/openai.yaml";
  home.file.".codex/skills/code-with-composer/references/execution-surfaces.md".source =
    "${codeWithComposerRoot}/references/execution-surfaces.md";
}
