{ ... }:
let
  secureGithubActionRoot = ../skills/secure-github-action;
in
{
  # Copy ope-handover.md to ~/.claude/commands/ for Claude slash commands
  # output to .private.handover/{datetime::format(yyyymmdd_hhmmss)}.md
  home.file.".claude/commands/user-ope-handover.md".source = ./ope-handover.md;
  # reads from .private.handover/{datetime::format(yyyymmdd_hhmmss)}.md
  home.file.".claude/commands/user-ope-cont-handover.md".source = ./ope-cont-handover.md;
  # output to .private.design/{datetime::format(yyyymmdd_hhmmss)}.md
  home.file.".claude/commands/user-ope-output-design.md".source = ./ope-output-design.md;
  # executes git diff and commits following git commit policy
  home.file.".claude/commands/user-git-commit-diff.md".source = ./git-commit-diff.md;
  # shows recent commit logs with changed files (default 3 commits)
  home.file.".claude/commands/user-git-read-commit-logs.md".source = ./git-read-commit-logs.md;
  # shows github url for current repository
  home.file.".claude/commands/user-git-show-github-url.md".source = ./git-show-github-url.md;
  home.file.".claude/commands/user-ope-reload.md".source = ./ope-reload.md;
  home.file.".claude/commands/user-ope-add-local-command.md".source = ./ope-add-local-command.md;
  home.file.".claude/commands/user-ope-add-local-subagent.md".source = ./ope-add-local-subagent.md;
  home.file.".claude/commands/user-util-to-eng.md".source = ./util-to-eng.md;
  # creates a new sub-branch from current branch with format {current_branch}_{sub_name}
  home.file.".claude/commands/user-git-create-sub-branch.md".source = ./git-create-sub-branch.md;
  # finds the parent branch of current branch based on naming convention
  home.file.".claude/commands/user-git-find-parent-branch.md".source = ./git-find-parent-branch.md;
  # creates a pull request using gh command with auto-detected base branch
  home.file.".claude/commands/user-git-create-pr.md".source = ./git-create-pr.md;
  # reads and understands Claude Code documentation
  home.file.".claude/commands/user-read-claude-doc.md".source = ./read-claude-doc.md;
  # reads and understands Claude Code skills documentation
  home.file.".claude/commands/user-read-claude-skills.md".source = ./read-claude-skills.md;
  # reads and understands Claude Code sub-agents documentation
  home.file.".claude/commands/user-read-claude-subagents.md".source = ./read-claude-subagents.md;
  # reads and understands Claude Code plugins documentation
  home.file.".claude/commands/user-read-claude-plugins.md".source = ./read-claude-plugins.md;
  # reads and understands Claude Code plugins reference documentation
  home.file.".claude/commands/user-read-claude-plugins-reference.md".source =
    ./read-claude-plugins-reference.md;
  # reads and understands Claude Code hooks documentation
  home.file.".claude/commands/user-read-claude-hooks.md".source = ./read-claude-hooks.md;
  # reads and understands Claude Code slash commands documentation
  home.file.".claude/commands/user-read-claude-slash-commands.md".source =
    ./read-claude-slash-commands.md;

  home.file.".claude/skills/secure-github-action/SKILL.md".source =
    "${secureGithubActionRoot}/claude-SKILL.md";
  home.file.".claude/skills/secure-github-action/references/security-rules.md".source =
    "${secureGithubActionRoot}/references/security-rules.md";
}
