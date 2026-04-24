---
name: code-with-cursor
description: Use this skill only when the user explicitly asks you to use $code-with-cursor, explicitly asks you to delegate implementation to Cursor Agent, or explicitly asks for composer-2/composer2 to implement code. This skill packages the concrete task and optional impl-plan, then runs local Cursor Agent headlessly with model composer-2.
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
argument-hint: [implementation task or impl-plan path]
user-invocable: true
---

# Code With Cursor

Use this skill only for explicit Cursor delegation requests. Do not use it implicitly for normal Claude implementation work.

## What To Collect First

Before invoking Cursor Agent, gather the minimum concrete context it needs:

- workspace path
- exact implementation task
- acceptance criteria or expected behavior
- relevant file paths or directories
- verification commands if known
- optional `impl-plan` path if one already exists

If an `impl-plan` file already exists, prefer passing the path and telling Cursor to read it first instead of restating the entire plan inline.

## Preferred Execution Path

Use direct local CLI execution with `cursor-agent`:

```bash
cursor-agent --print --trust --workspace /abs/workspace/path \
  --model composer-2 "First read /abs/impl-plan.md, then implement the task.
Run the requested verification commands. At the end, summarize files changed
and verification results."
```

If there is no `impl-plan`, put the concrete implementation instruction directly in the prompt.

## Prompt Contract

The delegated prompt should contain:

1. The implementation request in imperative form.
2. The workspace path and target scope.
3. The exact files or directories to edit when known.
4. The verification commands to run when known.
5. The path to any existing `impl-plan`, with an instruction to read it first.
6. A requirement to summarize files changed and verification results at the end.

Keep the prompt concrete. Do not paste large repository overviews unless they are required.

## Execution Rules

- Default model: `composer-2`
- Default runner: direct `cursor-agent`
- Default mode: normal implementation mode, not `plan`
- Use `--resume <chat-id>` only when continuing an existing Cursor session is clearly better than starting fresh.
- Keep the command simple unless there is a clear need for resume or wrapper behavior.

## Runner Selection

Read `references/execution-surfaces.md` when you need to decide between direct `cursor-agent`, the `cursor-cli-agent` wrapper, and non-options such as agents that cannot execute the local `cursor-agent` binary.
