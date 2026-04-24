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
  codexCursorLoopPrompt = ''
    Use \$code-with-cursor for implementation work in this run.

    Within this Codex run, do the following:
    1. Always preserve the user's request verbatim and pass it to Cursor Agent in a section labeled exactly `Original prompt:`.
    2. If there is no impl-plan, synthesize a concrete initial implementation brief yourself and send it to Cursor Agent together with the `Original prompt:` section.
    3. If there is an impl-plan, tell Cursor Agent to read it first, but still include the `Original prompt:` section in the Cursor-facing instruction so the original intent is not lost.
    4. Delegate implementation through \$code-with-cursor for a single pass only.
    5. Wait for the first concrete Cursor result. If Cursor reports a blocker, failing command, or failing test, summarize that result and stop instead of starting another delegated cycle.
    6. Review the resulting code yourself with a code-review mindset focused on bugs, regressions, missing tests, architectural drift, and weak reasoning, but keep that review in this Codex run.
    7. Do not send follow-up instructions back to Cursor Agent, do not ask it for status again, and do not resume the delegated run unless the user explicitly asks for another pass.
    8. Prefer concrete file- and command-level guidance over general advice.
    9. At the end, summarize Cursor's implementation status, your review findings, remaining risks, and what still needs follow-up.

    Original prompt:
  '';
in
{
  inherit
    claudeBaseCommand
    codexBaseCommand
    codexCommand
    codexCursorLoopPrompt
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
  # stream-json + partial deltas: first line (session init) appears immediately so
  # long tool/model steps do not look like a stall vs --output-format text.
  cursorPrintCommand = "${cursorBaseCommand} --model ${cursorFastModel} --print --output-format stream-json --stream-partial-output --trust";
}
