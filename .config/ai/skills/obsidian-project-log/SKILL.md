---
name: obsidian-project-log
description: Record meaningful development activity from the current Git repository in a repository-specific daily log inside the local Obsidian Vault. Use after substantive implementation, debugging, refactoring, environment setup, investigation, or architecture work in personal or business repositories, and when the user asks to preserve a development journal or project worklog. Do not use for merely opening a repository, trivial reads, greetings, or general questions without repository work.
---

# Obsidian Project Log

Keep development history inside the repository-specific project folder. Treat its dated log as the Daily note for that project.

## 1. Decide whether to record

- Record work that changes code, configuration, architecture, project state, or a reusable understanding of the repository.
- Record failed attempts, constraints, and decisions when they help reproduce the outcome.
- Skip trivial inspection, unchanged results, low-level command traces, and work the user told you not to save.
- Write at meaningful checkpoints instead of waiting until the end of a long task.

## 2. Resolve the project

Run `scripts/repo_identity.sh` from the current working directory.

- Use its `project` value as the Obsidian project folder name.
- Store logs under `02_Projects/<project>/logs/`.
- Use one file per project per day: `YYYY-MM-DD.md`.
- Treat files beside `logs/`, such as `spec.md`, as optional and outside this Skill's responsibility.
- If the derived name is sensitive, misleading, or collides with another project, ask for a safe alias before the first write. Reuse the established folder afterward.
- If the directory is not inside a Git repository, do not create a project log; use the normal Daily workflow when appropriate.

## 3. Protect business and private information

- Apply the same workflow to personal and business repositories.
- Never store remote URLs, organization or account names, absolute local paths, secrets, credentials, customer data, personal data, internal hostnames, proprietary source code, or raw logs.
- Summarize only the minimum technical context needed to reconstruct the work.
- Replace sensitive identifiers with safe generic descriptions. If a useful summary cannot be written safely, skip the project log.

## 4. Create or update the daily project log

Use the Obsidian CLI with `vault="Obsidian Vault"` explicitly.

Before creating a file, search for and read the target path. If it does not exist, create it without an H1:

```md
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags:
  - development-log
project: project-name
---
```

Append each checkpoint in this form:

```md
## HH:mm Short description of the work

- Purpose or relevant constraint
- Observation, attempted approach, and result
- Decision or next step when useful
```

- Keep the heading specific enough to distinguish entries and support direct section links.
- Include only the bullets needed to reconstruct the work; do not force every category into every entry.
- Update the `updated` property when appending on a later date.

## 5. Connect related notes

- Use Obsidian wikilinks for concrete relationships to project documents, specifications, decisions, reusable knowledge, thinking logs, and relevant past log entries.
- Put a wikilink directly in the sentence when it reads naturally. Otherwise add a bullet such as `- 関連: [[Note]]`.
- Link to a heading when a specific decision or log entry is the relevant target: `[[Note#Heading|Display text]]`.
- Link a previous or next dated log only when the work actually continues across those entries. Do not build a mechanical chronological chain.
- Use tags for stable cross-note classification, not as a replacement for relationships between notes.
- Do not create `spec.md`, placeholder notes, or empty link targets solely to add a link.

## 6. Verify

- Read the updated project log through the Obsidian CLI.
- Confirm its internal links resolve and `obsidian unresolved total` has not increased.
- If a project-log Base exists, confirm the new note matches it and does not appear in the project overview Base.
- Report the updated project-log path to the user.
