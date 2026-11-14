---
allowed-tools: WebFetch(*), Task(claude-code-guide:*)
description: Read and understand Claude models documentation
argument-hint: [model_name]
---

## Your task

Read and understand the Claude models documentation from https://platform.claude.com/docs/en/about-claude/models/overview

### Instructions

1. **Determine the scope**:
   - If $ARGUMENTS is provided, use it as the specific model name or topic to focus on
   - If no arguments, read the general models overview documentation

2. **Fetch the documentation**:
   - Use WebFetch to retrieve content from https://platform.claude.com/docs/en/about-claude/models/overview
   - If a specific model is requested, focus on that model's details

3. **Analyze and summarize**:
   - Read and understand the models documentation content
   - If a specific model was requested, focus on that model's capabilities and specifications
   - Provide a clear, concise summary of the key information

4. **Present the information**:
   - Show available Claude models and their features
   - Include model specifications (context window, capabilities, etc.)
   - Highlight use cases and best practices for each model
   - Include pricing information if relevant

### Example Usage

```
/read-claude-model-docs
```
Reads the general Claude models overview documentation.

```
/read-claude-model-docs sonnet
```
Focuses on information about Claude Sonnet models.

```
/read-claude-model-docs opus
```
Focuses on information about Claude Opus models.
