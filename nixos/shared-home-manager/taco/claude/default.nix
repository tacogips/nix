{ ... }:
{
  # Copy handover.md to ~/.claude/commands/ for Claude slash commands
  home.file.".claude/commands/handover.md".source = ./handover.md;
  home.file.".claude/commands/cont-handover.md".source = ./cont-handover.md;
  home.file.".claude/commands/output-design.md".source = ./output-design.md;
}
