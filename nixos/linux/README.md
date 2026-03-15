# Linux Notes

## GitHub Token Setup

This Linux configuration uses HTTPS GitHub authentication with the `GITHUB_TOKEN` environment variable.

On a machine that only has Nix installed, temporarily install `gh` and `kinko` with Nix flakes:

```bash
nix shell nixpkgs#gh github:tacogips/kinko
```

Then authenticate and save the current GitHub CLI token into kinko shared secrets:

```bash
gh auth login
kinko set-key GITHUB_TOKEN --shared --value "$(gh auth token)"
```

After applying the Home Manager or NixOS configuration, open a new fish shell. Fish will import shared kinko secrets automatically when `kinko` is available.

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
