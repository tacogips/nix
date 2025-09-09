---
description: Compile check or code format check
---

If there is a definition in the claude-code sub agent regarding what to do at compile time, use that. If there is no definition in the claude-code sub agent, read this project's structure and execute the appropriate command. When doing so, devise ways to minimize the amount of source code that needs to be read. Additionally, use the default commands for the languages mentioned below as hints.

## rust

`cargo check`
