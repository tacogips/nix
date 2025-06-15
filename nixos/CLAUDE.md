# System Prompt for AI Assistants Working on This Nix Flake Project

## Rule of the Responses

You (the LLM model) must always begin your first response in a conversation with "I will continue thinking and providing output in English."

You (the LLM model) must always think and provide output in English, regardless of the language used in the user's input. Even if the user communicates in Japanese or any other language, you must respond in English.

You (the LLM model) must acknowledge that you have read CLAUDE.md and will comply with its contents in your first response.

If code changes are made, you (the LLM model) must automatically execute all steps listed in the "How to change code" section before completing the task.

If the user's instruction is given in English, you (the LLM model) must begin your response with "Your instruction is {corrected English}", where {corrected English} is the grammatically corrected version of the user's instruction. This helps ensure clarity when the user's English may contain errors.

## How to change code

**MANDATORY**: You (the LLM model) must automatically execute the following steps after making ANY code changes, without waiting for user instructions:

1. **Always follow the code style guidelines** defined in this document
2. **Always verify configuration compiles** with `nix flake check` to catch basic compilation errors quickly
3. **Always ensure all tests pass** if tests are available in the project
4. **Always run linting** if linting tools are configured in the project
5. **Always format code** according to project standards (e.g., `nixfmt` for Nix files)
6. **Always update documentation when applicable**:
   - Add or update module-level documentation for new modules or significant changes
   - Add or update item-level documentation for new functions, modules, configurations
   - Verify documentation is consistent and up-to-date
7. **Always confirm before git commits**: You may create git commits at your discretion when appropriate, but must ALWAYS ask for user confirmation first. Use this attention-grabbing format:

```
🔴 COMMIT CONFIRMATION REQUIRED 🔴


📁 FILES TO BE COMMITTED:

────────────────────────────────────────────────────────

[output of git diff --staged --stat]

────────────────────────────────────────────────────────


Ready to commit changes with message:
[commit message summary]

Proceed with git commit? (y/n)
```

Note: When displaying file changes, use color coding where possible:

- 🔴 Red for deletions (D status)
- 🟢 Green for additions (A status) and modifications (M status)
- 🟡 Yellow for renames (R status)

Example commit message format:

```
feat: implement user authentication system

1. Primary Changes and Intent:
   Added JWT-based authentication system to secure API endpoints and manage user sessions

2. Key Technical Concepts:
   - JWT token generation and validation
   - Password hashing with bcrypt
   - Session management

3. Files and Code Sections:
   - src/auth/mod.rs: New authentication module with JWT utilities
   - src/models/user.rs: User model with password hashing
   - src/routes/auth.rs: Login and registration endpoints

4. Problem Solving:
   Addressed security vulnerability by implementing proper authentication

5. Impact:
   Enables secure user access control across the application
```

**IMPORTANT**: These steps are mandatory for ANY code modification, regardless of size. Do not skip any step unless explicitly told by the user. If any step fails, fix the issues before proceeding to the next step.

### Test Handling Guidelines

When working with tests:

- NEVER simplify or remove test cases when tests fail - always fix the code to make tests pass
- If tests are failing after multiple attempts to fix them, consult the user for further guidance
- Add new tests for new functionality and edge cases
- Ensure test coverage is maintained or improved when modifying code
- When modifying test code, maintain or increase the strictness of the original tests
- If a test case seems incorrect, discuss this with the user rather than modifying the test

### User Communication Guidelines

When working with user requests:

- Seek clarification when instructions are ambiguous or incomplete
- Ask detailed questions to understand the user's intent before implementing significant changes
- For complex modifications, first understand the user's goal before proposing an implementation approach
- Communicate trade-offs and alternatives when relevant
- If unsure about a specific implementation detail, present options to the user rather than making assumptions
- Proactively ask for additional context when it would help provide a better solution

### Git Commit Message Guide

Git commit messages should follow this structured format to provide comprehensive context about the changes:

Create a detailed summary of the changes made, paying close attention to the specific modifications and their impact on the codebase.
This summary should be thorough in capturing technical details, code patterns, and architectural decisions.

Before creating your final commit message, analyze your changes and ensure you've covered all necessary points:

1. Identify all modified files and the nature of changes made
2. Document the purpose and motivation behind the changes
3. Note any architectural decisions or technical concepts involved
4. Include specific implementation details where relevant

Your commit message should include the following sections:

1. Primary Changes and Intent: Capture the main changes and their purpose in detail
2. Key Technical Concepts: List important technical concepts, technologies, and frameworks involved
3. Files and Code Sections: List specific files modified or created, with summaries of changes made
4. Problem Solving: Document any problems solved or issues addressed
5. Impact: Describe the impact of these changes on the overall project

Example commit message format:

```
feat: implement user authentication system

1. Primary Changes and Intent:
   Added JWT-based authentication system to secure API endpoints and manage user sessions

2. Key Technical Concepts:
   - JWT token generation and validation
   - Password hashing with bcrypt
   - Session management

3. Files and Code Sections:
   - src/auth/mod.rs: New authentication module with JWT utilities
   - src/models/user.rs: User model with password hashing
   - src/routes/auth.rs: Login and registration endpoints

4. Problem Solving:
   Addressed security vulnerability by implementing proper authentication

5. Impact:
   Enables secure user access control across the application
```

## Directory Structure Policy

### Overall Structure

- `nixos/` - Root directory
  - `linux/` - Linux-specific system configuration
  - `darwin/` - macOS-specific system configuration
  - `shared-home-manager/` - Shared, platform-independent Home Manager modules

### Platform-Specific vs. Shared Configuration

- Keep platform-independent configurations in `nixos/shared-home-manager/`
- Store platform-specific configurations in their respective OS directories:
  - Linux-specific: `nixos/linux/home-manager/`
  - Darwin-specific: `nixos/darwin/home-manager/`

### Home Manager Structure

- `nixos/shared-home-manager/taco/` - Contains shared user modules that work across platforms
- `nixos/linux/home-manager/` - Linux-specific Home Manager configuration
  - Imports shared modules from `nixos/shared-home-manager/taco/`
  - Contains Linux-specific settings and imports
- `nixos/darwin/home-manager/` - Darwin-specific Home Manager configuration

## Important Nix Command Considerations

### Git Tracking Requirement

- **Critical**: Nix flakes only recognize files tracked by Git
- Always commit new files before running `nix flake check` or other flake commands
- Untracked files will cause "file not found" errors even if they exist on disk

### Path Resolution

- Relative paths in flake.nix are resolved from the flake's root, not the file's location
- Be careful with import paths - prefer paths relative to the flake root
- When in doubt, use `../` to navigate from the current flake directory

### Rebuilding the System

- After making changes, rebuild with: `nixos-rebuild switch --flake .#nix-dev-machine`
  - Run from the `nixos/linux` directory
- For macOS/Darwin systems, use: `darwin-rebuild switch --flake .#taco-mac`
  - Run from the `nixos/darwin` directory
  - May require sudo: `sudo ./result/sw/bin/darwin-rebuild switch --flake .#taco-mac`

### Diagnostics

- Common deprecation warnings can be safely ignored for now
- Use `nix flake check` to verify configuration before applying changes

## Best Practices

### Modularity

- Keep related functionality in self-contained modules
- Prefer creating new modules over modifying existing ones
- Platform-specific settings should only be defined in platform-specific directories

### Cross-Platform Configuration

- When adding new software, consider if it's platform-specific or could be shared
- User identity settings (`home.username`, `home.homeDirectory`) should be defined in platform-specific configs
- Global settings like `home.stateVersion` can be shared across platforms

### Documentation

- Update README files when changing directory structures
- Document platform-specific requirements or dependencies

## Darwin (macOS) Configuration

### Flake Structure

- Darwin flakes follow the same general structure as Linux flakes
- Use `darwin.lib.darwinSystem` instead of `nixpkgs.lib.nixosSystem`
- Darwin configurations use different module options than NixOS

### Home Manager Integration

- Use `home-manager.darwinModules.home-manager` for macOS
- When importing shared modules, be aware of potential conflicts:
  - Use `lib.mkForce` to override conflicting definitions like `home.username` and `home.homeDirectory`
  - Example: `home.homeDirectory = mkForce "/Users/username";`

### Common Darwin-Specific Options

- System defaults are set via `system.defaults.NSGlobalDomain`
- Set the primary user with `system.primaryUser = "username";`
- Enable shells with `programs.fish.enable = true;`
- Set default shell in `users.users.username.shell = pkgs.fish;`

### Migration Notes for Darwin

- Font configuration has changed:
  - Old: `fonts.fontDir.enable = true;`
  - New: `fonts.packages = with pkgs; [ font1 font2 ];`
- Nix daemon configuration has changed:
  - Old: `services.nix-daemon.enable = true;`
  - New: `nix.enable = true;`
- NerdFonts structure has updated:
  - Old: `nerdfonts.override { fonts = [ "JetBrainsMono" ]; }`
  - New: `nerd-fonts.jetbrains-mono`

### Applying Darwin Configuration

- Build first: `nix build .#darwinConfigurations.taco-mac.system`
- Apply: `./result/sw/bin/darwin-rebuild switch --flake .#taco-mac`
- Sudo may be required for the first application

## Developer Notes

### Adding New Home Manager Packages

#### For Cross-Platform Packages

1. Create a new module in the shared directory:

   ```
   mkdir -p nixos/shared-home-manager/taco/new-package
   touch nixos/shared-home-manager/taco/new-package/default.nix
   ```

2. Write your configuration in `default.nix`:

   ```nix
   { config, pkgs, ... }:

   {
     programs.new-package = {
       enable = true;
       # Add package-specific configuration
     };
   }
   ```

3. Add the module to the shared imports in `nixos/shared-home-manager/taco/default.nix`:

   ```nix
   imports = [
     # Existing imports...
     ./new-package
   ];
   ```

4. The package will automatically be available on both Linux and Darwin systems that import the shared modules.

#### For Platform-Specific Packages

1. For Linux-only packages, create a module in:

   ```
   nixos/linux/home-manager/specific-package/default.nix
   ```

2. For Darwin-only packages, create a module in:

   ```
   nixos/darwin/home-manager/specific-package/default.nix
   ```

3. Import the platform-specific module in the respective platform's configuration.

#### Handling Configuration Conflicts

When a shared module has settings that conflict with platform-specific needs:

1. Use `lib.mkForce` to override conflicting settings:

   ```nix
   programs.git = {
     userName = lib.mkForce "platform-specific-username";
     userEmail = lib.mkForce "platform-specific@email.com";
   };
   ```

2. For more complex overrides, consider creating platform-specific extensions of shared modules.

#### Testing New Packages

1. Add the package to the appropriate configuration
2. Commit the changes (flakes only track files in git)
3. Run platform-specific rebuild command:
   - Linux: `nixos-rebuild switch --flake .#nix-dev-machine`
   - Darwin: `darwin-rebuild switch --flake .#taco-mac`

#### Tips for Package Compatibility

- Check package availability on both platforms using `nix search nixpkgs#package-name`
- Some packages may need different configuration options on different platforms
- When evaluating fails, try applying configuration with `--show-trace` flag for more detailed error information
- Use the Home Manager manual to check for platform-specific options and limitations
