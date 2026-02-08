---
description: End-of-session reflection. Logs what worked, what didn't, corrections received, and patterns learned to .codex/reflections.md
allowed-tools: Read, Write, Bash(cat:*), Bash(date:*), Bash(wc:*)
---

## Session Reflection Protocol

You are performing an end-of-session reflection. This is how you learn across sessions.

### Step 1: Read your scratchpad

Read `.codex/reflections.md`. This is your persistent memory across sessions. If it doesn't exist, create it using the bootstrap structure below.

### Step 2: Review this session

Look back at the full conversation. Identify:

1. **Corrections received** — anything the user explicitly corrected, rejected, or asked you to redo. Be specific about what was wrong and what the fix was.
2. **What worked** — approaches, patterns, or decisions the user accepted without friction or praised.
3. **What didn't work** — things you tried that missed the mark, even if the user didn't explicitly call it out. Include false starts, wrong assumptions, wasted tool calls.
4. **Preferences revealed** — any implicit or explicit signals about how this user likes to work (communication style, code style, architecture preferences, review preferences, etc.)
5. **Patterns & anti-patterns** — recurring themes you notice across this session and prior entries in the scratchpad.
6. **Context for next session** — where things left off, what's in-flight, what the logical next step would be.

### Step 3: Update the scratchpad

Append a new dated entry to `.codex/reflections.md` under the `## Session Log` section.

Keep entries **concise and actionable** — future-you is reading this at the start of a fresh session with zero context. Write for that audience.

If you notice a pattern appearing 3+ times across entries, **promote it** to the `## Learned Patterns` section and remove redundancy from individual entries.

If a previously logged pattern turns out to be wrong or outdated, **move it** to `## Deprecated Patterns` with a note about why.

### Step 4: Summarize

After updating the file, give a brief spoken summary to the user:
- Number of corrections logged
- Any new patterns promoted
- Suggested starting point for next session

---

### Bootstrap structure for `.codex/reflections.md`

If the file doesn't exist, create it with this structure:

```markdown
# Session Reflections

> This file is my scratchpad for learning across sessions.
> I read it at the start of every session and update it at the end via `/reflect`.

## User Preferences

<!-- How this person likes to work. Communication style, code conventions, review preferences, etc. -->

## Learned Patterns

<!-- Patterns that have appeared 3+ times. These are my strongest signals. -->

## Deprecated Patterns

<!-- Things I used to think were true but learned were wrong or context-dependent. -->

## Session Log

<!-- Most recent entries first. Each entry is a dated block. -->
```

$ARGUMENTS
