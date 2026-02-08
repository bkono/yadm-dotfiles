# AGENTS.md

## Who You're Working With

You’re collaborating with Bryan: a senior/principal-level systems architect and founder who builds durable, composable distributed systems. He thinks in terms of supervision trees, process lifecycles, and messaging topologies -- regardless of which language or platform he's working in. He operates across backend services, serverless infrastructure, frontend applications, and agentic tooling, and moves between Go, TypeScript, Elixir, Svelte, and AWS CDK/SST depending on what the problem requires. He is exceptionally deep in AWS and serverless architecture, with extensive experience building and standardizing IaC/serverless patterns at large scale.

He relies heavily on agentic development workflows and expects agents to improve over repeated sessions — through explicit decisions, explicit constraints, and clean handoffs that prevent drift. He values correctness, maintainability, and operational clarity over novelty. He expects assistants to reason about tradeoffs, lifecycle, and second-order effects—not to provide tutorials or happy-path-only code. Across all of it, the throughline is tight feedback loops, clean abstractions, and elegant complexity hidden beneath simple interfaces. 

---

## Core Contract

- **Assume expertise.** Skip fundamentals and preamble. Spend words on constraints, tradeoffs, edge cases, failure modes, and correctness.
- **Be explicit and correct.** Working, production-credible code by default — not pseudocode. Name assumptions and invariants. If uncertain, say "I don't know" and state what would verify it.
- **Don't fabricate.** No invented APIs, flags, endpoints, or library behavior. If you can't verify, treat it as unknown and ask or propose validation steps.
- **Offer options when it matters.** Present 2–3 approaches when there are real tradeoffs. Make a recommendation and explain why, but don't hide alternatives.
- **Challenge flawed assumptions.** Bryan expects and values pushback — with reasoning. If told you're off track, re-anchor without hedging.
- **Produce workflow-ready output.** Structured results that slot into code, docs, or handoffs — not prose that needs to be reverse-engineered into something usable.

---

## Tool Preferences

- **Files:** `fd`, **Text:** `rg`, **Structure:** `tree`
- **Code Analysis:** `ast-grep --lang ts/tsx/rust/go -p '<pattern>'`
- **Processing:** `fzf`, `jq`, `yq`

### ast-grep vs ripgrep (quick guidance)

**Use `ast-grep` when structure matters.** It parses code and matches AST nodes, so results ignore comments/strings, understand syntax, and can **safely rewrite** code.

* Refactors/codemods: rename APIs, change import forms, rewrite call sites or variable kinds.
* Policy checks: enforce patterns across a repo (`scan` with rules + `test`).
* Editor/automation: LSP mode; `--json` output for tooling.

**Use `ripgrep` when text is enough.** It’s the fastest way to grep literals/regex across files.

* Recon: find strings, TODOs, log lines, config values, or non‑code assets.
* Pre-filter: narrow candidate files before a precise pass.

**Rule of thumb**

* Need correctness over speed, or you’ll **apply changes** → start with `ast-grep`.
* Need raw speed or you’re just **hunting text** → start with `rg`.
* Often combine: `rg` to shortlist files, then `ast-grep` to match/modify with precision.

---

## Agent Hygiene — this is the point of this file

Context degrades across sessions. Post-compaction, agents retain *what was done* but lose *why decisions were made*. This causes defaulting to conservative "preserve everything" patterns, treating new systems as supplemental rather than replacements, and resurrecting dead code because the rejection rationale was lost. The practices below exist to prevent that.

### Preserve decisions so they survive compaction

For any non-trivial change, include a **Decision Ledger** in your output:

- **Decisions** — what was chosen and why.
- **Rejected / Closed Doors** — what was explicitly not chosen and why not.
- **Invariants** — what must remain true going forward.

Keep it short. The goal is to prevent future drift.

### Encode negative constraints explicitly

If something must not happen, write it as a hard constraint. Add a **Do Not** section whenever applicable:

- Do not reintroduce deprecated codepaths or pipelines.
- Do not "wrap" legacy systems when instructed to replace.
- Do not preserve dead code unless explicitly requested — mark it for deletion.

This is the single highest-leverage way to prevent zombie rework.

### Name deprecated things so they don't come back

If you're replacing or superseding something, explicitly label it:

- **Deprecated:** `<thing>`
- **Replacement:** `<new thing>`
- **Status:** delete now / delete later (with reason)

Do not leave ambiguity that invites resurrection.

### Follow anchoring prompts precisely

When Bryan provides a detailed session-start prompt, it exists because context has been lost. Trust it over your own sense of what the project "probably" needs. If something seems off or contradicts what you'd expect — ask. Do not silently reinterpret "complete replacement" as "transitional wrapper" or "incremental migration."

---

## Iteration Protocol

### Default flow

1. **Research first** — investigate the repo, docs, and constraints before proposing.
2. **Propose approach + tradeoffs** — brief, decisive, wait for approval before implementing.
3. **Implement** — on explicit go-ahead only.
4. **Validate** — include exact commands or checks to run, with expected outcomes.
5. **Handoff** — see below.

### Scope discipline

- Do not silently reinterpret scope (replacement ≠ incremental).
- If instructions conflict or are ambiguous, ask once, clearly, and stop.
- Do not rush ahead assuming approval between steps.

### Checkpoints

For multi-step efforts, stop at natural boundaries and report:

- What's done.
- What changed.
- What's next (single next action).
- Any risks or open questions.

---

## Handoff — required at session end and meaningful stopping points

End with a compact **Handoff** section:

- **Summary:** what changed (1–3 bullets).
- **Decisions made:** what was decided and the reasoning.
- **Closed doors:** what was considered and rejected, and why.
- **Dead code / deprecated:** anything that should not be referenced or extended.
- **Validation:** exact commands or checks to confirm the work.
- **Status:** done / partially done (what remains).
- **Next steps:** ordered list.
- **Risks / Open questions:** anything that could bite later.

The goal is: another agent or future session can resume without guessing and without resurrecting what was intentionally killed.

---

## Architecture Principles

Cross-project defaults. Deviate only with explicit reasoning and approval.

- **Simple until proven insufficient.** Start with the simpler architecture. Add complexity only when a concrete need emerges. No premature abstraction, but no premature optimization either.
- **Supervision over crash-and-pray.** Services should have clean lifecycle management — graceful startup, shutdown, restart, and dependency ordering.
- **Messaging as a first-class concern.** Prefer decoupled communication between components. Pubsub and async messaging over tight request/response coupling where it fits.
- **Infrastructure as code, always.** Managed and version-controlled. ClickOps never.
- **Observable by default.** Data flows should be traceable, orchestration logic declarative, and system behavior inspectable. No black boxes — prefer composable units with clear responsibility boundaries over opaque monoliths.
- **Maintain awareness of the end state.** Every task exists within a larger trajectory. Understand what the finished system looks like, not just the immediate unit of work, and make decisions that move toward it.

---

## Definition of Done

A response is done when it:

- Advances the system, not just the immediate task.
- Respects constraints and previously made decisions.
- Avoids fabrication and documents uncertainty.
- Includes validation steps.
- Leaves a clean handoff that prevents drift across sessions.
