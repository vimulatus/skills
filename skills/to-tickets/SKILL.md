---
name: to-tickets
description: File one issue, or a parent with a sub-issue per ticket and blocking edges. Use when a bug, a finding, a plan or a spec is ready to file. Not for building it.
---

# To tickets

Resolve `<skill-dir>` from this skill's loaded `SKILL.md` path. Substitute that absolute directory in script commands, even after changing working directories.

You file. Someone else builds.

```
one issue      a bug, a chore, a finding        -> §1, §2, §5
a parent       a plan or a spec with tickets    -> §1 to §6

parent #12  Feedback capture
  |-- #13  Grilling  the feedback data model       no blockers
  |-- #14  Design    prototype the feedback form   no blockers
  |-- #15  Backend   POST /feedback                blocked by #13
  \-- #16  Frontend  wire the feedback form        blocked by #14, #15
```

A slice runs from the backend to the screen, design included. No one person owns a slice. A **ticket** is one sub-issue of one kind - Backend, Frontend, Design or Grilling - so one person can take it: verifiable on its own and sized for one context window. The decisions a person must make live in the tickets, not in a session.

## Before you start

`git remote -v`. No remote means no tracker. Say so and stop.

## 1 — Search first

```bash
gh issue list --search "<two or three words from the title>" --state all --limit 20
```

An open issue that already names the behaviour: comment on it, do not file.

## 2 — Read the code

Read the code the work touches, and the project's own words for it. Every title and body uses those words.

For a plan, look for the **prefactor**: the change that makes the change easy. It goes first.

## 3 — Cut the tickets

Every ticket is one kind. A ticket that spans two kinds is two tickets.

| Kind | It delivers | Verified by |
|---|---|---|
| Backend | everything below the screen: schema, API, jobs, CI, and the tests that prove them | its tests, and a call against the endpoint |
| Frontend | the screen, wired to the API it consumes | the screen working in the running app |
| Design | a prototype of the screen: 3 to 5 variants, layout and states, and the pick | the picked variant and its URL, in the closing comment |
| Grilling | the slice's load-bearing decisions, one per slice, each with a recommended answer | an answer per decision in the comments; closes on the last |

- Each ticket is complete within its kind.
- Each ticket fits one fresh context window.
- The prefactor goes first.

Give each ticket its **blocking edges**: the work it depends on. The kinds carry the default edges: Grilling blocks every ticket that needs one of its answers, Design blocks Frontend, and Backend blocks Frontend. Design and Backend have no edge between them. Drop an edge the work does not need: a Frontend ticket against a settled design and a live endpoint starts now. Code dependencies can support stacked development once their open PRs are usable; `issue-queue` owns readiness and branch selection. Other prerequisites must be satisfied before execution. A ticket with no blockers can start now.

**A wide refactor is the exception.** One mechanical change whose blast radius fans across the codebase, so no ticket lands green alone. Sequence it as **expand-contract**:

| Step | The ticket | Blocked by |
|---|---|---|
| Expand | Add the new form beside the old. Nothing breaks. | none |
| Migrate | Move the call sites in batches: per package, per directory. One ticket per batch. | Expand |
| Contract | Delete the old form once no caller remains. | every Migrate batch |

## 4 — Decisions

Apply the load-bearing filter from `grilling`: what a person must decide goes into a ticket, the rest you settle. There is no round in the session. The assignee answers in the ticket, by exception, so every open decision carries your recommended answer.

| The decision | Home |
|---|---|
| shapes more than one ticket: the data model, the contract, a one-way door | the slice's Grilling ticket, filed first |
| shapes one ticket | that ticket's `## Open decisions` section |
| how a new screen looks and moves | the Design ticket; its blocking edge holds each Frontend ticket |

A ticket files now even when a decision it needs is open. Its blocking edge and its open decisions hold it, on GitHub, where the team can see it. A held ticket hides work.

Record reversible planning assumptions in the parent: the granularity, an edge, a merge or a split. A reader corrects them on the parent. Do not reopen a decision the map already answers.

## 5 — File

Read the project's labels first. A project that labels by area or by kind gets its labels: a project carrying `backend`, `frontend` or `design` labels gets the ticket's kind. No convention, no label.

```bash
gh label list --limit 60 --json name --jq '.[].name'
```

The parent first, so each ticket can name it. Then the tickets, blockers first. Assign a ticket, or a whole slice through its parent, when the user names who takes it: `--assignee <login>`. Otherwise leave it unassigned.

```bash
p=$(gh issue create --title "<title>" --body-file <parent.md>); p=${p##*/}
c=$(gh issue create --title "<title>" --body-file <ticket.md>); c=${c##*/}

"<skill-dir>/scripts/link.sh" sub   "$p" "$c"    # $c is a sub-issue of $p
"<skill-dir>/scripts/link.sh" block "$c" "$b"    # $c is blocked by $b
```

When every ticket is filed, list them in the parent with `gh issue edit $p --body-file <parent.md>`.

A parent closes when its last ticket closes. GitHub does not do that. The `pr` skill does, at merge.

## 6 — A finding, mid-flight

| Does someone have to build something? | Where it goes |
|---|---|
| Yes | a new sub-issue of the parent, with its kind and its blocking edges. File it by §5, then add it to the parent's list. |
| No | a comment on the parent. |

A decision, a constraint, a dead end: comment. A behaviour someone must change: sub-issue.

Never edit a ticket someone is already building. Never close the parent early.

## Bodies

Current behaviour, then expected behaviour. Plain words for a reader who was not in the room. A subtle behaviour gets a worked example with real values. Evidence only from an investigation that already happened: the snippet and the file path.

A screenshot or a recording in a body follows the Embed table in `browser-evidence`: hosted, and `![the claim](<url>)` alone in its paragraph, so it renders inline instead of as a link.

<parent-template>

## Current behaviour

What happens today, in the fewest clear lines.

## Expected behaviour

What should happen instead, from the user's perspective.

## Tickets

- #13 <title>
- #14 <title>

</parent-template>

<ticket-template>

**Parent:** #<parent>

**Kind:** Backend | Frontend | Design | Grilling

**Blocked by:** #<n>, #<n> - or "None. Can start now."

## Current behaviour

What happens today. Include short evidence from an investigation already completed when it explains the issue.

## Expected behaviour

What this ticket makes work, in the terms its kind is verified by: the user's perspective for Frontend, the contract it exposes for Backend, the variants and the pick for Design, the answers for Grilling.

## Open decisions

- <question> — recommended: <answer>

Or "None." The assignee answers each one in a comment before building. A Grilling ticket is this section alone, without the sections around it.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

</ticket-template>

Use short snippets and file paths as evidence of observed current behaviour, not as a prescribed implementation plan. A prototype-derived state machine, schema or type may carry a decision better than prose; inline only that shape and name its source.
