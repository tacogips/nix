{ ... }:
{
  # Copy handover.md to ~/.claude/commands/ for Claude slash commands
  # output to .private.handover/{datetime::format(yyyymmdd_hhmmss)}.md
  home.file.".claude/commands/handover.md".source = ./handover.md;
  # reads from .private.handover/{datetime::format(yyyymmdd_hhmmss)}.md
  home.file.".claude/commands/cont-handover.md".source = ./cont-handover.md;
  # output to .private.design/{datetime::format(yyyymmdd_hhmmss)}.md
  home.file.".claude/commands/output-design.md".source = ./output-design.md;
  # executes git diff and commits following git commit policy
  home.file.".claude/commands/commit-diff.md".source = ./commit-diff.md;
  # shows recent commit logs with changed files (default 3 commits)
  home.file.".claude/commands/read-commit-logs.md".source = ./read-commit-logs.md;
  # shows github url for current repository
  home.file.".claude/commands/show-github-url.md".source = ./show-github-url.md;
  home.file.".claude/commands/reload.md".source = ./reload.md;
  home.file.".claude/commands/add-local-command.md".source = ./add-local-command.md;
  home.file.".claude/commands/add-local-subagent.md".source = ./add-local-subagent.md;
  home.file.".claude/commands/cc.md".source = ./cc.md;
  home.file.".claude/commands/eng.md".source = ./eng.md;
}
