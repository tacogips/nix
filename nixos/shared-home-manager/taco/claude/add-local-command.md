---
description: Add a local claude command
---

Create a markdown file under .claude/commands with the content passed in the Variable below as an LLM prompt.
The Variable is provided in the format: {file_name_without_file_extension}:{prompt_summary}.
Make the prompt summary sufficiently strict as an instruction for the LLM. If there are any unclear points, confirm with the user. Write everything in English.
If the variable is not provided in this format, report it as an error to the user.

### Variable

$ARGUMENTS
