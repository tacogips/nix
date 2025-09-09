---
description: Add a Claude Code subagent
---

Create a specialized subagent by creating a markdown file under .claude/agents with the content passed in the Variable below as a system prompt.
The Variable is provided in the format: {subagent_name}:{description_and_purpose}.

Subagents are specialized AI assistants with:
- Separate context window from main conversation
- Customizable system prompts for focused expertise
- Configurable tool access
- Ability to handle specific types of problems proactively

The system prompt should be sufficiently detailed and specific as instructions for the subagent. Include:
- Clear purpose and scope
- Specific capabilities and limitations  
- Tool usage guidelines
- Expected behavior patterns

If there are any unclear points, confirm with the user. Write everything in English.
If the variable is not provided in the correct format, report it as an error to the user.

### Variable

$ARGUMENTS
