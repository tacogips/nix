---
name: riela
description: Use when the user invokes `/riela "{instruction}"` or explicitly asks Claude Code to handle an instruction through Riela, Rielflow, Riela-related skills, or Riela workflows. This skill routes the instruction to the most appropriate installed Riela/Rielflow skill or workflow instead of treating it as ordinary local work.
argument-hint: "{instruction}"
user-invocable: true
---

# Riela

Use this skill as a dispatcher for `/riela "{instruction}"`.

## Contract

1. Extract the quoted instruction exactly. If the user provided no instruction,
   ask for one concise clarification.
2. Choose the narrowest relevant installed Riela/Rielflow skill or Riela
   workflow for that instruction.
3. Use that selected skill or workflow according to its own instructions.
4. Preserve the user's instruction as the task input when invoking another
   skill or workflow.
5. Report which Riela/Rielflow path was selected and the outcome.

Do not satisfy a `/riela` request as normal local Claude Code work unless no
relevant Riela/Rielflow skill, workflow, or `riela` CLI path is available. If
fallback is needed, state that explicitly.

## Routing

Prefer an installed skill when one clearly matches:

- package search/install/update/remove/list: use `rielflow-package`
- workflow run/status/resume/rerun/inspect/validate: use
  `rielflow-workflow-run`
- failed, paused, stalled, or surprising workflow sessions: use
  `rielflow-troubleshooting`
- workflow authoring or modification: use `rielflow-workflow`
- temporary inline or JSON workflow execution: use `rielflow-temporary-workflow`
- workflow tests, mock scenarios, or expected results: use
  `rielflow-workflow-test`
- packaged workflow skill creation or updates: use
  `rielflow-workflow-use-skill`
- source security checks: use `claude-code-source-security-check-loop`
- implementation work with design/review loop: use
  `claude-code-design-and-implement-review-loop`
- small scoped code or documentation changes: use
  `claude-code-simple-work-package`
- deep design/implementation/security work: use a Riela/Claude workflow package
  that matches the instruction, such as `claude-code-deepdesign` followed by an
  implementation workflow when appropriate
- generic goal-driven work: use `claude-code-goal`

If multiple routes seem plausible, prefer the most specific Riela/Rielflow
skill over a generic goal workflow. For implementation requests, prefer a
Riela/Claude implementation workflow over direct local edits.

## CLI Fallback

If no matching skill is available but the `riela` CLI is available, inspect the
CLI help for the relevant command and run the smallest safe command needed.
Avoid destructive package or workflow changes unless the instruction explicitly
requires them.
