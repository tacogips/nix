# Home Manager Configuration

This directory contains only shared, platform-independent Home Manager configurations that can be used by both Linux and macOS/Darwin.

## Directory Structure

- `/home-manager/taco/`: Contains shared, platform-independent configuration modules for the user "taco"
- `/home-manager/default.nix`: Root entry point (doesn't directly import anything)

The platform-specific configurations are located in their respective OS directories:
- `/linux/home-manager/`: Linux-specific Home Manager configuration
- `/darwin/home-manager/`: Darwin-specific Home Manager configuration

## Usage

### For Linux

In your Linux NixOS configuration, import the Linux-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ./home-manager
  ];
};
```

### For Darwin

In your Darwin configuration, import the Darwin-specific Home Manager configuration:

```nix
home-manager.users.taco = { ... }: {
  imports = [
    ./home-manager
  ];
};
```

## Configuration Organization

- **Platform-Independent Configs**: Add to `home-manager/taco/` directory modules
  - Examples: git, jj (jujutsu), lazyjj, fish, bat, ssh, ghostty, and yazi configurations that work on any platform
- **Platform-Specific Configs**: Add to the respective OS directories
  - Linux-specific configs: `linux/home-manager/`
  - Darwin-specific configs: `darwin/home-manager/`

This separation makes it easy to maintain consistent configurations across platforms while allowing for platform-specific customizations in their appropriate locations.

The shared editor environment uses the shared Yazi integration together with platform-specific `taco.yazi.openCommand` values so files can be handed off to the correct GUI opener on Linux and Darwin. Yazi routes PDF, image, and video files to `chilla`, keeps directories opening in a terminal, and sends other files through Yazi's editor opener so Markdown, text files, and source code open in `$EDITOR` (currently `nvim`) while true binary files still fall back to the platform GUI opener. In the shared Yazi config, pressing `Enter` on a directory exits Yazi into that directory in the current terminal instead of handing it to the GUI file opener. Yazi also shows Git status markers directly in the file list via `git.yazi`, and `, g` opens a synthetic view that contains only files with `git diff` changes plus the directories that contain them. When Yazi is launched from fish as `yazi` or `y`, exiting Yazi updates the current shell to the last directory you visited.

The shared fish prompt keeps the existing vi-mode indicator and shows Git context only when the current directory is inside a Git repository. In that case, the prompt appends the current branch together with informative repository state markers such as staged, dirty, untracked, and upstream status. On interactive startup, fish also attempts to import shared `kinko` secrets when `kinko` is installed and shows a warning if the vault is currently locked, including after later `cd` directory changes.
The shared fish aliases also include `co-review-today`, which runs Codex with a fixed English review prompt for the code changes made today and asks it to both review and improve low-quality code, unused code, deprecated leftovers, unnecessary hardcoding, missed DRY opportunities, unjustified SOLID violations, poor variable names, missing test coverage, overlooked considerations, and bugs, while also checking whether the current architecture/design still matches the intended purpose and whether the current git diff suggests any unfinished follow-up work.
The shared fish functions also provide iterative agent loops on both Linux and Darwin: `codex-loop`, `codex-loop-review-today`, `codex-cursor-loop`, `cursor-loop`, and `cursor-loop-review-today`. These helpers append the same architecture and git-diff review suffix on each iteration, the fixed `*-review-today` variants reuse the same review prompt as `co-review-today`, and `codex-cursor-loop` specifically tells Codex to delegate implementation through the `code-with-cursor` skill, pass the user's request to Cursor under an explicit `Original prompt:` label, review the result itself, and send concrete follow-up back to Cursor even when no impl-plan exists.
The shared agent configuration now installs the `secure-github-action`, `envrc-generate`, and `code-with-cursor` user skills for Codex on Linux and Darwin. That keeps `~/.codex/skills/` in sync from repository-managed sources, so workflow hardening guidance, standard `.envrc` generation, and explicit Cursor delegation through Composer 2 are available in Codex. Claude still receives the repository-managed `secure-github-action` and `envrc-generate` skills under `~/.claude/skills/`.
The shared toolchain also installs `divedra` from `github:tacogips/divedra` on both Linux and Darwin through Home Manager, so the same Nix-managed CLI is available on each machine.

Rust editor integrations keep `cargo check` artifacts under `target/ra` and place rust-analyzer's own target data under `target/rust-analyzer` so background analysis does not contend with the save-time diagnostics output.
The shared Neovim configuration now uses Telescope's `smart-open.nvim` extension on `<Space>,`, so the primary file picker ranks current-project files, open buffers, and recent history from a SQLite-backed index instead of relying on `oldfiles` alone.

The shared tmux workflow now exposes predefined layouts directly inside tmux. `Alt-t` opens a new window and immediately shows a layout menu, while `Alt-i` still opens a plain new window rooted at the current pane's directory. `prefix + I` shows the same menu for the current window and rebuilds the window from the active pane before applying the selected layout. `Alt-z` enters a temporary resize mode where `h/j/k/l` resize the active pane until you press `Esc` or `Enter`. The `Shell 2 Pane` and `Shell 3 Pane` layouts open plain terminal panes, while the `ide-3pane` layout starts Yazi on the left, opens Neovim in the center pane, and retargets directory selections to the right pane's current working directory.
The tmux footer now renders on each pane border and shows each pane's current path for both active and inactive panes. The main tmux status line remains at the bottom.

The shared Cursor CLI configuration now writes `~/.cursor/cli-config.json` with `editor.vimMode = true` and installs `cursor-cli` from nixpkgs on both Linux and Darwin. On Linux, the shared Cursor module also wraps `cursor-agent` so normal agent invocations auto-enable `--yolo --approve-mcps` and pre-create the workspace trust marker for the current repo before launch. That removes the usual shell-command, MCP, and workspace-trust prompts in normal `cursor-agent` / `cur` / `cuf` / `curr` / `currl` usage. Cursor can still require explicit confirmation for some hard-coded security checks, such as particularly sensitive config changes.
