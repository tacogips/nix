{ ... }:
let
  secureGithubActionRoot = ../skills/secure-github-action;
in
{
  home.file.".codex/skills/secure-github-action/SKILL.md".source =
    "${secureGithubActionRoot}/codex-SKILL.md";
  home.file.".codex/skills/secure-github-action/agents/openai.yaml".source =
    "${secureGithubActionRoot}/agents/openai.yaml";
  home.file.".codex/skills/secure-github-action/references/security-rules.md".source =
    "${secureGithubActionRoot}/references/security-rules.md";
}
