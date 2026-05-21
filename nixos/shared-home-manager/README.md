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
The shared fish aliases pin `co` to Codex `gpt-5.5` and `coo` to Codex `gpt-5.4`. The shared fish functions also include `co-review-today`, which runs Codex with a fixed English review prompt for the code changes made today and asks it to both review and improve low-quality code, unused code, deprecated leftovers, unnecessary hardcoding, missed DRY opportunities, unjustified SOLID violations, poor variable names, missing test coverage, overlooked considerations, and bugs, while also checking whether the current architecture/design still matches the intended purpose and whether the current git diff suggests any unfinished follow-up work. The shared Codex exec-based functions pin their Codex runs to `gpt-5.5` with `model_reasoning_effort="high"` through the command line, instead of relying on external user config.
The shared fish functions also provide iterative agent loops on both Linux and Darwin: `codex-loop`, `codex-step-loop`, `codex-loop-review-today`, `codex-cursor-loop`, `cursor-loop`, and `cursor-loop-review-today`. `codex-step-loop` is a dedicated wrapper in `fish/functions.nix` that mirrors the Codex loop flow and inserts a sleep between successful iterations. The other loop helpers use the shared `__agent-loop-run` implementation in the same file, with prompt text centralized in `fish/agent-commands.nix`. The Codex-backed loop helpers (`codex-loop`, `codex-step-loop`, `codex-loop-review-today`, and `codex-cursor-loop`) use that same `gpt-5.5` plus `high` reasoning configuration. The general-purpose loops append only a short suffix asking the agent to also review and consider the current `git diff`. `codex-cursor-loop` prepends the Codex-to-Cursor delegation brief from `fish/agent-commands.nix` before that same short suffix. `codex-step-loop` waits the requested number of minutes between successful iterations and does not sleep after the last one. The fixed `*-review-today` variants reuse the same review prompt as `co-review-today` and append the same short `git diff` suffix, and `codex-cursor-loop` specifically tells Codex to delegate implementation through the `code-with-cursor` skill, pass the user's request to Cursor under an explicit `Original prompt:` label, wait for a single delegated Cursor pass, and then review the result locally without starting another delegated cycle unless the user explicitly asks for one.
The shared agent configuration now installs the `secure-github-action`, `envrc-generate`, `code-with-cursor`, and `git-precommit-safety-check` user skills for both Codex and Claude on Linux and Darwin. The Codex copies are materialized as real files under `~/.agents/skills/`, which Codex loads as user-scope skills, and activation removes the old managed copies from `~/.codex/skills/`. That keeps workflow hardening guidance, standard `.envrc` generation, explicit Cursor delegation through Composer 2, and non-gitleaks commit-target checks for credential material, private URLs, and machine-local paths available in both agents. The `code-with-cursor` skill now narrows generic impl-plan requests into one concrete executable plan/task slice before delegating, and it ships a `scripts/cursor-agent-monitor.sh` dispatcher plus explicit `scripts/cursor-agent-monitor-linux.sh` and `scripts/cursor-agent-monitor-darwin.sh` backends so parent Codex or Claude runs can launch Cursor in the background and poll NDJSON progress instead of appearing hung behind one blocking shell command. The Linux backend prefers transient `systemd-run --user` units, while the macOS backend prefers a temporary `launchctl` LaunchAgent in the caller's GUI domain before falling back to plain background execution.
The shared Home Manager module installs the Nix-managed `divedra` package when a platform passes `divedra-pkg`. Linux keeps using `github:tacogips/divedra` through Home Manager; Darwin installs `divedra` from the `tacogips/tap` Homebrew formula so the CLI comes from the same release path as other Darwin brew-managed tools.
On Darwin, Home Manager installs Divedra development workflows into the user-scope catalog at `~/.divedra/workflows`, and installs related Divedra workflow operation skills into `~/.agents/skills`. It also installs Divedra's `git-new-branch` skill for branch creation through managed worktrees, plus `ts-coding-standards` and `ts-review` so user-scope reviews can apply the non-gitleaks security checklist for machine-local paths, credential material, and private URLs.

Rust editor integrations keep `cargo check` artifacts under `target/ra` and place rust-analyzer's own target data under `target/rust-analyzer` so background analysis does not contend with the save-time diagnostics output.
The shared Neovim configuration now uses Telescope's `smart-open.nvim` extension on `<Space>,`, so the primary file picker ranks current-project files, open buffers, and recent history from a SQLite-backed index instead of relying on `oldfiles` alone.

The shared tmux workflow now exposes predefined layouts directly inside tmux. `Alt-t` opens a new window and immediately shows a layout menu, while `Alt-i` still opens a plain new window rooted at the current pane's directory. `prefix + I` shows the same menu for the current window and rebuilds the window from the active pane before applying the selected layout. `Alt-z` enters a temporary resize mode where `h/j/k/l` resize the active pane until you press `Esc` or `Enter`. The `Shell 2 Pane` and `Shell 3 Pane` layouts open plain terminal panes, while the `ide-3pane` layout starts Yazi on the left, opens Neovim in the center pane, and retargets directory selections to the right pane's current working directory.
The tmux footer now renders on each pane border and shows each pane's current path for both active and inactive panes. The main tmux status line remains at the bottom.

The shared Cursor CLI configuration now writes `~/.cursor/cli-config.json` with `editor.vimMode = true` and installs `cursor-cli` from nixpkgs on both Linux and Darwin. On Linux, the shared Cursor module also wraps `cursor-agent` so normal agent invocations auto-enable `--yolo --approve-mcps` and pre-create the workspace trust marker for the current repo before launch. That removes the usual shell-command, MCP, and workspace-trust prompts in normal `cursor-agent` / `cur` / `cuf` / `curr` / `currl` usage. Cursor can still require explicit confirmation for some hard-coded security checks, such as particularly sensitive config changes.
