# Linux Notes

## GitHub Token Setup

This Linux configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable.

This repository is now public, so `GITHUB_TOKEN` is not required before the initial rebuild just to check out and apply this repository itself.

You still need to register `GITHUB_TOKEN` in `kinko` shared secrets if you want to clone or fetch other private GitHub repositories from the configured environment.

After you apply the Linux configuration, flake commands are enabled system-wide, so commands like this work directly:

```bash
nix shell nixpkgs#mdadm nixpkgs#util-linux -c bash
```

Then move to the Linux configuration directory:

```bash
cd ~/nix/nixos/linux
```

If you are bootstrapping a machine before the first rebuild and flakes are not enabled yet for the current user, run:

```bash
mise run enable-flakes-user
```

When you want to register the token, install the mise tools and run the setup task:

```bash
mise install
mise run setup-github-token
```

After applying the Home Manager or NixOS configuration, open a new fish shell. Fish will import shared kinko secrets automatically when `kinko` is available, and it will warn when the shell starts and whenever `cd` changes directories if `kinko` is installed but currently locked.

The shared Home Manager activation installs `ign` from `tacogips/tap/ign` when a Homebrew `brew` command is available. If Homebrew is not installed on Linux, activation skips that install with a warning.

If you only want to populate the current shell from GitHub CLI without updating kinko, use:

```bash
gh-token-export
```

If you are already inside the configured fish environment and want to both save the token to kinko and export it in the current shell, use:

```bash
gh-token-save-shared
```

Git reads the token through the Home Manager generated Git configuration, which installs the GitHub credential helper inline in `.gitconfig`.

If you want an explicit fish command that clones with GitHub credentials, use:

```bash
gh-clone git@github.com:owner/repo.git
gh-clone https://github.com/owner/repo.git
```

`gh-clone` rewrites GitHub SSH clone URLs to HTTPS, prefers the current shell's `GITHUB_TOKEN`, falls back to `kinko` if needed, and injects that token as the credential for the clone command.

## Agent Loops

The shared fish configuration provides these iterative agent helpers on both Linux and Darwin. `codex-step-loop` is a dedicated wrapper in `nixos/shared-home-manager/taco/fish/functions.nix` that mirrors the Codex loop flow and inserts a sleep between successful iterations. The other loop helpers use the shared `__agent-loop-run` implementation in the same file, and long-form prompt text lives in `nixos/shared-home-manager/taco/fish/agent-commands.nix`.

```bash
codex-loop 3 "prompt"
codex-step-loop 3 10 "prompt"
codex-loop-review-today 3
codex-cursor-loop 3 "prompt"
cursor-loop 3 "prompt"
cursor-loop-review-today 3
cat prompt.md | cursor-loop 3
cat prompt.md | codex-step-loop 3 10
```

The general-purpose loops (`codex-loop`, `codex-step-loop`, `cursor-loop`, and `codex-cursor-loop`) append only a short suffix asking the agent to also review and consider the current `git diff`. `codex-cursor-loop` prepends the Codex-to-Cursor delegation brief from `agent-commands.nix` before that same short suffix. `cursor-loop` uses the same Cursor model selection as the `cr` alias, which means `composer-2.5` runs with the shared `--yolo --approve-mcps` flags and non-interactive `--print` output in `stream-json` form with partial deltas (lines of JSON) so a run does not look stalled before the first model chunk.
`codex-step-loop` mirrors `codex-loop`, but sleeps for the specified number of minutes between successful iterations and skips the final post-run sleep.
The Codex-backed helpers (`codex-loop`, `codex-step-loop`, `codex-loop-review-today`, and `codex-cursor-loop`) pin their Codex runs to `gpt-5.6-sol` with `model_reasoning_effort="high"` via CLI config override.
`codex-loop-review-today` produces the same effective review request as `co-review-today`, including the architecture/design check and current-diff continuation review, but runs it through the iterative Codex loop for the number of times you pass as `n`.
`cursor-loop-review-today` does the same review loop through Cursor with the same fixed review request and the same short `git diff` suffix.

## Home Manager Backups

Linux enables Home Manager file backups with the `hmm_backup` suffix during activation and also allows replacing an older backup with the same name. That prevents rebuilds from failing when a managed file such as `~/.cursor/cli-config.json` has already been backed up once on a previous activation.
