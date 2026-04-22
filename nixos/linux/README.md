# Linux Notes

## GitHub Token Setup

This Linux configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable.

This repository is now public, so `GITHUB_TOKEN` is not required before the initial rebuild just to check out and apply this repository itself.

You still need to register `GITHUB_TOKEN` in `kinko` shared secrets if you want to clone or fetch other private GitHub repositories from the configured environment.

Before any `nix shell nixpkgs#...` command here, enable flakes once for your user:

```bash
mkdir -p ~/.config/nix
printf 'experimental-features = nix-command flakes\n' >> ~/.config/nix/nix.conf
```

Then move to the Linux configuration directory:

```bash
cd ~/nix/nixos/linux
```

If you want a task that keeps the same setting in place after flakes already work, run:

```bash
nix shell nixpkgs#go-task --command task enable-flakes-user
```

When you want to register the token, temporarily install `gh`, `kinko`, and `go-task` with Nix flakes and run the Taskfile target:

```bash
nix shell nixpkgs#gh nixpkgs#go-task github:tacogips/kinko --command task setup-github-token
```

After applying the Home Manager or NixOS configuration, open a new fish shell. Fish will import shared kinko secrets automatically when `kinko` is available, and it will warn when the shell starts and whenever `cd` changes directories if `kinko` is installed but currently locked.

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

The shared fish configuration provides these iterative agent helpers on both Linux and Darwin:

```bash
codex-loop 3 "prompt"
codex-loop-review-today 3
cursor-loop 3 "prompt"
cursor-loop-review-today 3
cat prompt.md | cursor-loop 3
```

Both commands append the same architecture and git-diff review suffix on each iteration. `cursor-loop` uses the same Cursor model selection as the `cuf` alias, which means `composer-2-fast` runs with the shared `--yolo --approve-mcps` flags and non-interactive `--print` output.
`codex-loop-review-today` produces the same effective review request as `co-review-today`, including the architecture/design check and current-diff continuation review, but runs it through the iterative Codex loop for the number of times you pass as `n`.
`cursor-loop-review-today` does the same review loop through Cursor with the same fixed review request and continuation suffix.
