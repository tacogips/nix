# Workflow legacy compatibility removal (tail cleanup)

## Intended purpose

Shared Fish agent-loop helpers (`__agent-loop-run`, prompts in `agent-commands.nix`) should provide **one implementation path** for repeated Codex/Cursor runs. Historically, `codex-cursor-loop` duplicated parsing, iteration, and prompt assembly next to `__agent-loop-run`, which invited drift and made behavior harder to reason about.

**Target architecture**

- **Canonical loop:** `__agent-loop-run <name> <runner> <prompt_mode> …` owns iteration, exit status, stderr progress lines, and prompt finalization.
- **Thin wrappers:** `codex-loop`, `cursor-loop`, `codex-loop-review-today`, `cursor-loop-review-today`, `codex-cursor-loop` only forward arguments with fixed names and modes.
- **Prompt text:** `agent-commands.nix` remains the single source for long-form prompts (`codexCursorLoopPrompt`, `agentLoopSuffix`, review prompts).

## Architecture status

The tree under `shared-home-manager/taco/fish/functions.nix` matches the **target architecture**: one `for`/`seq` loop in `__agent-loop-run`, public commands are one-line forwards, long-form strings live in `agent-commands.nix`. No further split implementation of `codex-cursor-loop` remains. **Seventeenth pass (2026-04-29):** Same alignment; unrelated `nvf/lsp.nix` edits were reverted to `HEAD` so the pending diff stays scoped to Fish agent-loop + README (per eighth-/eleventh-pass scope). Verification and diff review are in **Seventeenth-pass review** below.

## Git diff review (latest iteration)

- **Continuation:** `codex-cursor-loop` forwards to `__agent-loop-run` with `codex_delegate_input`; prompt assembly and stderr progress live in one finalization `switch` alongside `input` / `fixed`. README files document the canonical loop.
- **Scope:** No unrelated Neovim/LSP churn in the agent-loop stack; `nvf/lsp.nix` matches `HEAD`.
- **Bugs:** None spotted: `n` validation, argv shifting for `fixed` vs other modes, stdin/argv prompt rules for `codex_delegate_input`, and runner `switch` behave consistently with the former standalone `codex-cursor-loop`.
- **Hardening:** `__agent-loop-print-usage` includes a defensive `case '*'` so an unknown internal `prompt_mode` does not fail silently. The prompt-collection `case '*'` uses the same internal-error wording pattern as usage and finalization (`unknown prompt_mode for …`).

### Second-pass review (2026-04-29)

- **Architecture:** Still matches the target: no second `for`/`seq` agent loop outside `__agent-loop-run`; `agent-commands.nix` remains the source for `codexCursorLoopPrompt`, `agentLoopSuffix`, and review prompts.
- **Consistency:** The prompt-collection `switch` rejects unknown `prompt_mode` before finalization; `__agent-loop-print-usage` and the finalization `switch` use explicit modes plus `case '*'` defensively. No drift between the old inline `codex-cursor-loop` and the unified path.
- **Verification:** `nix eval --impure` of `../shared-home-manager/taco/fish/functions.nix` from `nixos/linux` succeeds. Full `nix flake check` still requires `NIXOS_PRIVATE_CONFIG` and `--impure` on this flake (documented below).
- **Further tail cleanup:** None required in `functions.nix` for this scope; optional future work is only the “new loop variant” extension procedure in Follow-ups.

### Third-pass review (2026-04-29)

- **Git diff:** `codex-cursor-loop` is a one-line forward; `__agent-loop-run` adds `codex_delegate_input` alongside `input`/`fixed` in usage text, prompt collection, and finalization (`progress_note` + Codex delegation prompt + suffix). No leftover duplicate loop body.
- **Repo sweep:** No other `seq`/agent iteration under `nixos/` for these helpers; Darwin does not duplicate them. `aliases.nix` `co-review-today` correctly uses `codexReviewTodayFullPrompt` for the one-shot path (separate from the iterative `fixed` + suffix composition in `__agent-loop-run`).
- **Verification:** Re-ran the documented `nix eval --impure` import of `functions.nix` from `nixos/linux` (success). `nix flake check` without private config still fails with the expected “Missing private config” error from this flake’s check.
- **Further tail cleanup:** None for this scope; next iteration is only new `prompt_mode` variants per Follow-ups.

### Fourth-pass review (2026-04-29)

- **Git diff / continuation:** The deduplication work is complete: no remaining standalone `codex-cursor-loop` body. This pass adds an explicit `return 1` after the internal-error branch in `__agent-loop-print-usage` so an unknown `prompt_mode` does not exit with status 0 if that helper is ever invoked alone, and documents the centralized `__agent-loop-run` design in `shared-home-manager/README.md`.
- **Architecture:** Unchanged and aligned with the target: canonical `__agent-loop-run`, `prompt_mode` values `input` | `fixed` | `codex_delegate_input`, prompts from `agent-commands.nix`.
- **Bugs:** None found in the loop logic; the `return 1` hardens the defensive `case '*'` in usage printing.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` still fails with the expected missing private config error.
- **Further tail cleanup:** None for this scope; follow the Follow-ups section when adding new loop variants.

### Fifth-pass review (2026-04-29)

- **Architecture:** Confirmed again: single `for`/`seq` in `__agent-loop-run`; Linux and Darwin both consume `shared-home-manager/taco/fish/functions.nix` (Darwin adds only platform-specific functions in `darwin/home-manager/fish/functions.nix`).
- **Tail cleanup:** Aligned defensive `case '*'` messages: `unknown prompt_mode for usage`, `unknown prompt_mode for prompt collection`, and `unknown prompt_mode for finalization` so logs grep consistently and clearly indicate a wiring bug, not user misuse.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds after the message tweak.
- **Further tail cleanup:** None for this scope unless a new `prompt_mode` is added (see Follow-ups).

### Sixth-pass review (2026-04-29)

- **Git diff / continuation:** Prior iterations completed deduplication; this pass only tightens consistency: the runner `switch` in `__agent-loop-run` now reports `internal error: unknown runner for iteration: $runner` (same family as `unknown prompt_mode for …`), so a bad wrapper wiring `runner` is obvious in logs.
- **Architecture:** Unchanged and aligned: canonical `__agent-loop-run`, thin public wrappers, `prompt_mode` values `input` | `fixed` | `codex_delegate_input`, prompts from `agent-commands.nix`.
- **Bugs:** None found; no duplicate agent loops.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds after the runner message tweak.
- **Further tail cleanup:** None for this scope. When adding a new **runner** (not only `prompt_mode`), extend the runner `switch` in `__agent-loop-run` and keep the `internal error: unknown runner for iteration` pattern for the default case.

### Seventh-pass review (2026-04-29)

- **Git diff / continuation:** The pending changes finish the legacy removal: `codex-cursor-loop` delegates entirely to `__agent-loop-run codex-cursor-loop codex codex_delegate_input`; `__agent-loop-print-usage`, prompt collection, prompt finalization (`codex_delegate_input` vs `input`/`fixed`), stderr `progress_note`, and runner `switch` stay in one place. README documents the single canonical loop.
- **Architecture:** Matches the target: no second agent `for`/`seq` outside `__agent-loop-run`; `aliases.nix` `co-review-today` remains the one-shot full prompt path distinct from iterative `fixed` + suffix.
- **Repo sweep:** Only `functions.nix` contains `seq $n` for these loops; Darwin adds only platform helpers in `darwin/home-manager/fish/functions.nix`.
- **Bugs:** None identified in argv shifting, stdin handling for `codex_delegate_input`, or iteration exit status.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected missing private config error.
- **Further tail cleanup:** None for this scope; follow Follow-ups when adding new `prompt_mode` or `runner` values.

### Eighth-pass review (2026-04-29)

- **Git diff / continuation:** Confirms prior iterations: `codex-cursor-loop` is a one-line `__agent-loop-run` wrapper; no duplicate `for`/`seq` body. README describes canonical `__agent-loop-run` + `agent-commands.nix`.
- **Unrelated change:** The working tree had removed `denols.root_markers` from `nvf/lsp.nix`; that line was restored so this effort stays scoped to Fish agent-loop deduplication (Deno LSP root markers are unrelated).
- **Architecture:** Matches target: single loop in `__agent-loop-run`, `prompt_mode` `input` \| `fixed` \| `codex_delegate_input`, prompts from `agent-commands.nix`.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds after restoring `denols.root_markers`.
- **Further tail cleanup:** None for agent-loop scope.

### Ninth-pass review (2026-04-29)

- **Git diff / continuation:** Uncommitted changes remain the canonical deduplication: `codex-cursor-loop` is a single `__agent-loop-run codex-cursor-loop codex codex_delegate_input $argv` forward; `__agent-loop-print-usage` covers `input` and `codex_delegate_input` together with a defensive `case '*'`; prompt collection, finalization (`codex_delegate_input` vs `input`/`fixed`), stderr `progress_note`, and runner `switch` live only in `__agent-loop-run`. README states thin wrappers and `agent-commands.nix` as the prompt source.
- **Architecture:** Matches the intended target: one `for`/`seq` agent loop; no second implementation path for `codex-cursor-loop`.
- **Bugs / drift:** None identified relative to the former standalone loop: argv/stdin rules for `codex_delegate_input` match `input`; `n` validation and exit status on failure are unchanged in behavior.
- **Aliases / one-shot:** `co-review-today` still uses `codexReviewTodayFullPrompt` (review body + continuation in one `exec` argument). Iterative `*-review-today` functions use `fixed` with `codexReviewTodayPrompt` plus `agentLoopSuffix` (same continuation text) each iteration — equivalent substance, distinct wiring by design.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected missing private config error.
- **Further tail cleanup:** None for this scope. Commit the `functions.nix` + `README.md` changes when ready; add `impl-plans/` to Git if these plans should ride along in the repo (flakes do not need them).

### Tenth-pass review (2026-04-29)

- **Git diff / continuation:** The pending diff is still the canonical deduplication only: `functions.nix` removes the standalone `codex-cursor-loop` body and routes it through `__agent-loop-run` with `codex_delegate_input`; `shared-home-manager/README.md` documents thin wrappers and `agent-commands.nix`. No unrelated edits in the diff.
- **Architecture:** Still matches the target: one `for`/`seq` in `__agent-loop-run`; `prompt_mode` values `input` | `fixed` | `codex_delegate_input`; Darwin does not reimplement these loops (`darwin/home-manager/fish` has no `agent-loop` / duplicate `seq`).
- **README consistency:** `nixos/linux/README.md` Agent Loops examples previously omitted `codex-cursor-loop` and did not mention the shared canonical loop; this pass adds both so Linux-facing docs stay aligned with `shared-home-manager/README.md`.
- **Bugs:** None found in argv shifting, `fixed` vs `input`/`codex_delegate_input` handling, or runner dispatch.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected missing private config error.
- **Further tail cleanup:** None for agent-loop scope; follow Follow-ups when adding new `prompt_mode` or `runner` values.

### Eleventh-pass review (2026-04-29)

- **Git diff / continuation:** Fish agent-loop deduplication remains complete (`codex-cursor-loop` → `__agent-loop-run` with `codex_delegate_input`). An unrelated working-tree edit to `nvf/lsp.nix` (commenting `denols.root_markers`, extending `ts_ls.root_markers` for Deno) was reverted to match `HEAD` so this effort stays scoped to the shared Fish loop per the eighth-pass note—Deno/LSP layout is a separate concern.
- **Architecture:** Unchanged: canonical `__agent-loop-run`, prompts from `agent-commands.nix`, no second `seq` loop for these helpers.
- **Bugs:** None in the loop path; unrelated `lsp.nix` drift removed from the pending diff.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` still fails with the expected missing private config error.
- **Further tail cleanup:** None for agent-loop scope.

### Twelfth-pass review (2026-04-29)

- **Git diff / continuation:** Same scoped stack as prior passes: `functions.nix` removes the standalone `codex-cursor-loop` body and uses `__agent-loop-run codex-cursor-loop codex codex_delegate_input $argv`; `__agent-loop-print-usage`, prompt collection, finalization (`codex_delegate_input` vs `input`/`fixed`), stderr `progress_note`, and runner `switch` remain unified; `nixos/linux/README.md` and `shared-home-manager/README.md` describe the canonical loop and `codex-cursor-loop` in line with the tenth-pass alignment.
- **Architecture:** Matches the intended target: one iteration loop in `__agent-loop-run`; no duplicate agent `for`/`seq` elsewhere under `nixos/shared-home-manager/taco/fish` or Darwin’s additive `darwin/home-manager/fish/functions.nix`.
- **Repo sweep:** Grep confirms only `functions.nix` carries `seq $n` for these helpers; `codexCursorLoopPrompt` and `agentLoopSuffix` stay centralized in `agent-commands.nix`.
- **Bugs / drift:** None identified: `fixed` argv shifting, `input`/`codex_delegate_input` stdin and argv rules, and failure exit codes match the pre-dedup behavior.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected “Missing private config” error from this flake’s check.
- **Further tail cleanup:** None for this scope; use **Follow-ups** when adding a new `prompt_mode` or `runner`.

### Thirteenth-pass review (2026-04-29)

- **Continuation:** Working-tree changes remain scoped to Fish agent-loop deduplication and docs: `codex-cursor-loop` is a one-line `__agent-loop-run codex-cursor-loop codex codex_delegate_input $argv`; `nixos/linux/README.md` and `shared-home-manager/README.md` describe canonical `__agent-loop-run` and `codex-cursor-loop`. No unrelated files in the diff (no `nvf`/`lsp.nix` drift).
- **Architecture:** Matches the intended target: single iteration loop in `__agent-loop-run`; `agent-commands.nix` supplies `codexCursorLoopPrompt`, `agentLoopSuffix`, `codexReviewTodayPrompt`; `aliases.nix` `co-review-today` uses `codexReviewTodayFullPrompt` for the one-shot path.
- **Repo sweep:** Only `functions.nix` contains `seq $n` for these agent helpers; no second loop body for `codex-cursor-loop`.
- **Bugs:** None identified in argv shifting (`fixed` vs `input`/`codex_delegate_input`), stdin handling, or runner dispatch.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected “Missing private config” error from this flake’s check.
- **Further tail cleanup:** None for this scope; use **Follow-ups** when adding a new `prompt_mode` or `runner`.

### Fourteenth-pass review (2026-04-29)

- **Git diff / continuation:** Same scoped stack as prior passes: deduplicated `codex-cursor-loop`, unified `__agent-loop-run` with `codex_delegate_input`, README updates on Linux and shared home-manager. No further standalone loop body to remove; no additional legacy duplication found under `nixos/` for these helpers.
- **Architecture:** Still matches **Intended purpose**: one `for`/`seq` in `__agent-loop-run`; public functions are one-line forwards; Darwin `fish/functions.nix` adds only Colima/screenshot/Finder helpers.
- **Docs:** `shared-home-manager/README.md` agent-loop paragraph now states explicitly that `codex-cursor-loop` prepends the delegation brief from `fish/agent-commands.nix` before the shared suffix, matching `nixos/linux/README.md` and avoiding a misread that only `input`/`fixed` loops get the suffix.
- **Bugs:** None in the Fish loop path on review.
- **Verification:** `nix eval --impure` import of `functions.nix` from `nixos/linux` succeeds after the shared README delegation/suffix clarification; `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` still fails with the expected missing private config error.
- **Further tail cleanup:** None for agent-loop scope; optional repo hygiene is staging `impl-plans/` if you want the plan tracked in Git (flakes do not require it).

### Fifteenth-pass review (2026-04-29)

- **Git diff / continuation:** The pending diff remains the scoped Fish agent-loop stack: `codex-cursor-loop` is a single `__agent-loop-run codex-cursor-loop codex codex_delegate_input $argv` forward; `__agent-loop-run` centralizes usage, prompt collection, finalization (`codex_delegate_input` vs `input`/`fixed`), stderr `progress_note`, and runner dispatch; README updates on Linux and shared home-manager describe the canonical loop and delegation behavior. No remaining standalone `codex-cursor-loop` body and no unrelated file churn in the diff.
- **Architecture:** Still matches **Intended purpose**: one iteration loop in `__agent-loop-run`; thin public wrappers; prompts from `agent-commands.nix`; Darwin `home-manager/fish` has no duplicate agent loops (grep: no `seq` / `codex-loop` / `agent-loop` there).
- **Bugs / drift:** None identified on code review: `fixed` strips exactly one embedded prompt argument before `n`; `input` and `codex_delegate_input` share argv/stdin rules; internal-error branches cover unknown `prompt_mode` and unknown `runner`.
- **Verification:** `nix eval --impure` import of `../shared-home-manager/taco/fish/functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected “Missing private config” error from this flake’s check.
- **Further tail cleanup:** None for this scope; use **Follow-ups** when adding a new `prompt_mode` or `runner`. Optional: `git add nixos/linux/impl-plans/` if you want this plan file version-controlled.

### Sixteenth-pass review (2026-04-29)

- **Git diff / continuation:** The pending diff is still only the completed Fish agent-loop work: `functions.nix` deduplicates `codex-cursor-loop` into `__agent-loop-run codex-cursor-loop codex codex_delegate_input $argv`; `nixos/linux/README.md` and `shared-home-manager/README.md` document the canonical loop and `codex-cursor-loop`. No unrelated files; no leftover duplicate `for`/`seq` body.
- **Architecture:** Matches **Intended purpose**: one iteration loop in `__agent-loop-run`; thin wrappers; `codexCursorLoopPrompt`, `agentLoopSuffix`, and review prompts from `agent-commands.nix`.
- **Bugs / drift:** None found: argv shifting for `fixed`, stdin/argv for `input` and `codex_delegate_input`, `progress_note` text, and runner dispatch are consistent with the pre-dedup behavior.
- **Verification:** `nix eval --impure` import of `../shared-home-manager/taco/fish/functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected “Missing private config” error from this flake’s check.
- **Further tail cleanup:** None for this scope; next changes are new `prompt_mode` / `runner` variants per **Follow-ups**.

### Seventeenth-pass review (2026-04-29)

- **Git diff / continuation:** The Fish agent-loop deduplication is complete; no further legacy duplicate loop to remove. This pass **reverts `shared-home-manager/taco/nvf/lsp.nix` to `HEAD`**: Deno/ts root-marker experiments do not belong in the agent-loop tail-cleanup diff (same scoping rule as eighth-/eleventh-pass notes).
- **Architecture:** Unchanged and aligned with **Intended purpose**: canonical `__agent-loop-run`, thin public wrappers, prompts from `agent-commands.nix`. Darwin `home-manager/fish` still has no duplicate `seq` agent loops (grep: no matches).
- **Bugs:** None in the Fish loop path; removing unrelated `lsp.nix` drift avoids accidental coupling of Neovim config to this workflow task.
- **Verification:** `nix eval --impure` import of `../shared-home-manager/taco/fish/functions.nix` from `nixos/linux` succeeds. `nix flake check` without `NIXOS_PRIVATE_CONFIG` and `--impure` fails with the expected “Missing private config” error from this flake’s check.
- **Further tail cleanup:** None for agent-loop scope; use **Follow-ups** when adding a new `prompt_mode` or `runner`.

## Progress (completed)

- Prompt mode `codex_delegate_input`: same argv/stdin rules as `input`; final prompt is Codex delegation brief + user text + `agentLoopSuffix`; iteration stderr uses the Codex-specific progress line.
- `codex-cursor-loop` is a thin wrapper calling `__agent-loop-run codex-cursor-loop codex codex_delegate_input $argv`.
- All loop entrypoints are thin `__agent-loop-run` wrappers; no duplicate agent `for` loops outside `__agent-loop-run`.
- Final prompt assembly and stderr progress share one finalization `switch`, with explicit `case codex_delegate_input`, `case input fixed`, and a defensive `case '*'` for unknown modes (internal error).
- `__agent-loop-print-usage` uses the same defensive `case '*'` for unknown modes and returns 1 after the internal-error message.
- Short comment above the finalization block documents `prompt_mode` values for future edits.
- Unknown internal `prompt_mode` paths use a consistent `unknown prompt_mode for …` wording (usage vs collection vs finalization) so logs read clearly if a new mode is wired incompletely.
- The runner `switch` default branch uses `internal error: unknown runner for iteration` so an invalid `runner` argument matches the same internal-error pattern as unknown `prompt_mode` values.

### Follow-ups (later iterations)

- If new loop variants appear, extend `__agent-loop-run` with another **prompt_mode** (or a dedicated helper called only from `__agent-loop-run`) instead of copying the `for` loop again. Add the mode to **all three** places: argv/usage handling (`__agent-loop-print-usage` if usage text differs), the prompt-collection `switch`, and the finalization `switch` (plus a thin public wrapper if needed).
- If a new **runner** is added (alongside `codex` and `cursor`), extend only the runner `switch` inside the iteration loop in `__agent-loop-run`; keep the default branch as `internal error: unknown runner for iteration`.

## Verification

After changing Fish/Nix under `shared-home-manager/taco/fish/`, run `nix flake check` from the Linux flake root (`nixos/linux`).

On hosts where the flake’s NixOS check imports private configuration, `nix flake check` may require `NIXOS_PRIVATE_CONFIG` and `--impure`. If that applies, at least evaluate the changed module, for example:

`cd nixos/linux && nix eval --impure --expr 'let f = builtins.getFlake (toString ./.); pkgs = import f.inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; }; in import ../shared-home-manager/taco/fish/functions.nix { inherit pkgs; }'`
