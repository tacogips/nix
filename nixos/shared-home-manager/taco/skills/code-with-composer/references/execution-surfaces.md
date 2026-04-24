# Execution Surfaces

## Preferred: Direct `cursor-agent`

Use direct local `cursor-agent` when the goal is to have Cursor implement code
from the current parent session.

Why this is the default:

- it is installed in this environment
- it supports `--print`, `--workspace`, and `--model composer-2`
- it is the shortest path from Codex to Cursor execution

Typical command shape:

```bash
cursor-agent --print --trust --output-format stream-json \
  --stream-partial-output --workspace /repo --model composer-2 "..."
```

## Optional: `cursor-cli-agent`

Use the wrapper only when session indexing, transcript inspection, or explicit
resume/watch behavior is valuable. It is not the default path for this skill.

Current local status:

- repository exists at `/g/gits/tacogips/cursor-cli-agent`
- direct PATH install is not present in this environment
- wrapper execution is currently via `bun run src/main.ts ...`

That means it is viable as an advanced path, but not the default.

## Not An Execution Surface: Codex `web`

Codex `web` can fetch documentation, web pages, and current references. It
cannot execute the local `cursor-agent` binary.

Use `web` only to gather external context that should then be passed into the
Cursor prompt, for example:

- a current API document
- a linked issue or PR page
- hosted implementation notes

Do not describe `web` as the mechanism that runs Cursor Agent. It is only a
supporting context source.

## Parent Session Handoff Guidance

When delegating from the parent session, pass only the information Cursor needs
to act:

- exact task
- target workspace
- allowed or preferred files
- verification expectations
- existing `impl-plan` path when available

If an `impl-plan` already captures the work, tell Cursor to read that file
first and then implement it. Keep the prompt short and concrete.
