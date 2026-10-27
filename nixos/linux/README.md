# Linux Notes

## GitHub Token Setup

This Linux configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable.

This repository is now public, so `GITHUB_TOKEN` is not required before the initial rebuild just to check out and apply this repository itself.

Authenticate with GitHub CLI when you need to clone or fetch private GitHub repositories from the configured environment.

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

Authenticate with GitHub CLI:

```bash
gh auth login
```

After applying the Home Manager or NixOS configuration, export the GitHub CLI token into the current fish shell:

```bash
gh-token-export
```

Git reads the token through the Home Manager generated Git configuration, which installs the GitHub credential helper inline in `.gitconfig`.

If you want an explicit fish command that clones with GitHub credentials, use:

```bash
gh-clone git@github.com:owner/repo.git
gh-clone https://github.com/owner/repo.git
```

`gh-clone` rewrites GitHub SSH clone URLs to HTTPS and injects the current shell's `GITHUB_TOKEN` as the credential for the clone command.

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

## Security input update (2026-10-27)

The flake pins the reviewed `tacogips/nixpkgs-security` revision
`51712f4618983456364dc94f66736f6a9f942f6c`, including patched Node.js,
shared Brotli, Bun and the NSS 3.131.1 trust store. Home Manager follows
the matching 26.05 release and transitive inputs share the patched package set.

Evaluate the public configuration with the supplied example (no rebuild or activation):

```bash
NIXOS_PRIVATE_CONFIG="$PWD/device/nix-dev-machine/private.nix.example" \
  nix flake check --impure --no-build --all-systems
```

The example provides placeholder filesystem UUIDs and filesystem types matching
`device/nix-dev-machine/scripts/generate-private-nix.sh`. It is for evaluation
only; never rebuild or activate a host with its placeholder values. Shared theme
colors are read directly from the pinned upstream palette JSON, avoiding a
target-platform theme build during configuration evaluation.

Full host evaluation before a real rebuild requires the machine's private configuration:

```bash
NIXOS_PRIVATE_CONFIG=/absolute/path/to/private.nix nix flake check --impure --no-build
```

The public-example Linux flake check and the Darwin flake check passed on the
audit host. The actual machine-specific private configuration was unavailable,
so its filesystem identifiers and optional private modules remain unverified.
No host rebuild or activation was run.
