---
description: Uses the plan-review subagent to iteratively review and refine a plan/proposal through multiple passes
---

# Plan Review Workflow

You are orchestrating an iterative plan review cycle using the **plan-review** subagent. The goal is to produce a thoroughly vetted, pragmatic, and implementation-ready plan.

## Workflow Overview

You will run **at least 3 and up to 5 review passes**. Each pass:
1. Invokes the plan-review subagent
2. Assesses the review for validity and actionability
3. Presents recommendations to the user with tactical questions (if needed)
4. Incorporates accepted changes (or notes ignored items)
5. Proceeds to the next pass with an increasingly broader lens

**Exit early** if the plan-review subagent returns a verdict of **APPROVE** or indicates the plan is "about as good as we can make it."

---

## Pass Structure

### Pass 1: Baseline Review
- Focus: Direct correctness and implementability of the plan as written
- Lens: Does this plan actually solve the stated problem? Are the steps complete and ordered correctly?
- Invoke plan-review with the current plan document

### Pass 2: Fresh Eyes Review
- Focus: A second thorough review, actively looking for things Pass 1 missed
- Lens: What did the first pass overlook? Are there obvious issues hiding in plain sight? Second-order effects of any changes made?
- Don't just validate fixes—hunt for new problems with fresh perspective

### Pass 3: Goal Alignment
- Focus: Step back and re-evaluate against the original goals
- Lens: Now that we've made tactical fixes, does the plan still serve the user's actual needs? Have we drifted?
- Include the original goal statement prominently

### Pass 4: Implementation & Integration
- Focus: Broader implementation concerns
- Lens: How will this integrate with the existing codebase? Are there patterns we're violating or opportunities we're missing? Dependencies, ordering, rollout?

### Pass 5: Architecture & Future-Proofing
- Focus: Widest lens—architecture and sustainability
- Lens: Does this fit the system's architecture? Will this cause problems at scale or over time? Are we building the right thing?
- Only reach this pass if prior passes still found meaningful issues

---

## Execution Protocol

For each pass:

### 1. Invoke the plan-review subagent
Provide:
- The current plan document
- The user's original goal statement
- Any relevant repo context (AGENTS.md, architecture notes, discovered constraints)
- **Pass context**: Which pass this is and what lens to apply
- **History**: Summary of changes made in prior passes

### 2. Assess the review
Before presenting to the user, evaluate:
- Are the issues raised **valid** given the codebase and constraints?
- Are they **actionable** with specific fixes?
- Do any issues conflict with each other or with prior accepted changes?
- Separate high-severity issues from nits

### 3. Present to user with recommendations
Use **AskUserTool** to:
- Summarize the review verdict and key findings
- Present each issue with your recommendation (accept/reject/modify) and reasoning
- Ask tactical questions that need user input:
  - Clarifications about requirements or constraints
  - Tradeoff decisions (e.g., "Do you prefer simplicity or extensibility here?")
  - Priority calls on optional improvements
- Format as clear, answerable questions (prefer yes/no or choice questions)

### 4. Incorporate changes
- Update the plan document with accepted changes
- Note any rejected suggestions with brief reasoning (for context in future passes)
- Track what was changed for the next pass's context

### 5. Evaluate continuation
- If verdict is **APPROVE**: Present final plan to user and exit
- If plan-review indicates convergence ("about as good as we can make it"): Exit with summary
- If **NEEDS CHANGES** or **APPROVE WITH NITS** with substantive issues: Proceed to next pass
- If **BLOCKED (MISSING INFO)**: Gather required info via AskUserTool before proceeding

---

## Key Principles

- **Pragmatic over perfect**: The goal is a working, correct plan—not an ideal one
- **Simple as appropriate**: Resist complexity unless the problem demands it
- **Validity before presentation**: Don't burden the user with invalid or already-resolved concerns
- **Cumulative context**: Each pass builds on prior passes; don't re-litigate settled issues
- **User agency**: The user decides what to accept; you recommend and explain

---

## Begin

Start by identifying the plan document to review. If it's not immediately clear which document to review, ask the user to specify. Then proceed with Pass 1.

Announce each pass clearly so the user understands where they are in the process:
> "Starting **Pass N of 5**: [Focus area]. This pass examines [lens description]."

After all passes complete (or early exit), provide a final summary:
- Total passes completed
- Key improvements made
- Final verdict from the last review
- Any remaining caveats or areas for future attention
