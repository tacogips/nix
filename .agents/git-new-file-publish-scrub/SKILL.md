---
name: git-new-file-publish-scrub
description: Validate files that would be newly added to Git before commit or push, and detect content that should not be published such as secrets, private keys, local-only artifacts, machine-specific paths, private repository URLs, internal data, and generated junk. Use when a user asks whether new files are safe to commit or push.
---

# Git New File Publish Scrub

Use this skill when the task is to check whether files that are new to Git are safe to publish.

This skill is narrower than a full code review. Focus on files that are newly introduced to Git:

- before the next commit
- before the next push
- or both, if the user does not specify

If the task is specifically about npm package contents, also use `$supply-chain-secure-publish`.

## Scope

Treat these as separate audit scopes:

- `commit scope`: files that would become newly tracked in the next commit
- `push scope`: files added by local commits that are not yet on the upstream branch

If the user says "before commit", prioritize `commit scope`.
If the user says "before push", prioritize `push scope`.
If the user is ambiguous, inspect both and label the results clearly.

## Workflow

### 1. Identify candidate files

Start from the repository root:

```bash
repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"
```

Collect candidate files:

```bash
# Untracked files that may get added next
git ls-files --others --exclude-standard

# Newly added files already staged for the next commit
git diff --cached --name-only --diff-filter=A

# Newly added files in the working tree relative to HEAD
git diff --name-only --diff-filter=A
```

For push scope, if an upstream exists:

```bash
git rev-parse --abbrev-ref --symbolic-full-name @{upstream}
git diff --name-only --diff-filter=A @{upstream}..HEAD
```

If there is no upstream, say that push scope cannot be computed reliably from upstream state.

Deduplicate the file list before inspecting contents.

## 2. Check filenames for obvious publication risks

Flag suspicious filenames before opening contents. Common blockers:

- `.env`, `.env.*`, `.npmrc`, `.pypirc`, `.netrc`
- `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.crt`, `*.cer`
- `id_rsa`, `id_ed25519`, `known_hosts`, `authorized_keys`
- `*.sqlite`, `*.db`, `*.sql`, `*.dump`, `*.bak`
- `*.log`, `*.har`, `*.pcap`
- screenshots, recordings, exported reports, browser/session dumps, copied API responses
- local scratch directories or generated junk that should stay ignored

These are not always automatic failures, but they require strict review.

## 3. Scan contents for sensitive material

Use `rg` on the candidate files. Start with broad patterns, then inspect exact matches.

Secrets and credential indicators:

```bash
rg -nI -S \
  'BEGIN [A-Z ]*PRIVATE KEY|api[_-]?key|secret|token|password|authorization:|bearer |cookie:|session|x-api-key|aws_access_key_id|aws_secret_access_key|ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}' \
  -- <files...>
```

Machine-specific path leaks:

```bash
rg -nI -S \
  '/home/[^/]+/|/Users/[^/]+/|[A-Za-z]:\\\\Users\\\\' \
  -- <files...>
```

Private or internal repository references:

```bash
rg -nI -S \
  'github\\.com[:/][^/]+/[^/[:space:]]+' \
  -- <files...>
```

Additional red flags:

- real credentials embedded in example files
- copied production data, customer data, or internal logs
- source maps or generated files that expose local paths
- certs, tokens, cookies, signed URLs, webhook secrets
- obfuscated blobs or suspicious encoded payloads without justification

## 4. Review matches for false positives

Do not stop at regex hits. Check intent:

- placeholders like `${GITHUB_TOKEN}` are usually fine
- documentation examples are fine only if values are fake and clearly sanitized
- public repository URLs are fine; private repository URLs should be treated as sensitive unless explicitly intended
- generic system paths may be acceptable, but user-identifying host paths usually are not

## 5. Decide whether to block commit or push

Block the operation if you find:

- real secrets or tokens
- private keys or certificate private material
- machine-identifying absolute paths that should not be published
- internal-only logs, dumps, screenshots, or copied responses
- local scratch or generated artifacts that should not enter Git

Recommended fixes:

- remove the file from the index
- redact the content
- replace real values with placeholders
- move secrets to environment variables or secret storage
- add the file pattern to `.gitignore`

Do not rewrite history or delete files unless the user asks.

## Report Format

Prefer a compact result with:

- audited scope: `commit`, `push`, or `both`
- candidate files
- blockers with exact file and line references for text matches
- warnings that need manual judgment
- clean files
- limitations, such as missing upstream

## Constraints

- Focus on files newly added to Git, not all modified files
- Prefer repository evidence over guesswork
- Report exact file paths for all findings
- For text files, include exact line numbers
- For binary files, report filename-level risk and explain why
