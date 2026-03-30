{ }:

let
  codexCommand = "codex";
  cursorCommand = "cursor-agent";
  cursorFastModel = "composer-2-fast";
  cursorGlobalFlags = "--yolo --approve-mcps";
  # Newer Codex CLI versions reject combining explicit approval policy with
  # the bypass flag, because bypass already disables approvals and sandboxing.
  codexGlobalFlags = "--dangerously-bypass-approvals-and-sandbox --model gpt-5.4";
  codexBaseCommand = "${codexCommand} ${codexGlobalFlags}";
  cursorBaseCommand = "${cursorCommand} ${cursorGlobalFlags}";
  claudeBaseCommand = "env NODE_OPTIONS='--max-old-space-size=16384' CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 claude --permission-mode bypassPermissions --dangerously-skip-permissions";
  reviewTodayPrompt = "Review the code changes made today and improve low-quality code. The review and fixes should cover code that is generally considered low quality, unused code, deprecated code that still remains, unnecessary hardcoding, places that can be made DRY, places that are not aligned with SOLID principles without a clear reason, inappropriate variable names, cases not covered by tests, overlooked considerations, and bugs.";
  reviewContinuationPrompt = "Check whether the current architecture/design matches this intended purpose. If it does not, update the design, create an implementation plan, and implement it. This work will be carried out over multiple iterations. If there is a git diff, review it and check whether there is any continuation of the previous task, any bugs, any overlooked considerations, or any areas that can be further improved, and fix them if necessary.";
in
{
  inherit
    claudeBaseCommand
    codexBaseCommand
    codexCommand
    cursorBaseCommand
    cursorCommand
    cursorFastModel
    ;

  codexReviewTodayPrompt = reviewTodayPrompt;
  agentLoopSuffix = reviewContinuationPrompt;
  codexReviewTodayFullPrompt = ''
    ${reviewTodayPrompt}

    ${reviewContinuationPrompt}
  '';
  cursorPrintCommand = "${cursorBaseCommand} --model ${cursorFastModel} --print --output-format text --trust";
}
