---
name: to-tickets
description: File one issue, or a parent with a sub-issue per discipline and blocking edges. Use when a bug, a finding, a plan or a spec is ready to file. Not for building it.
---

# To tickets

Resolve `<skill-dir>` from this skill's loaded `SKILL.md` path. Substitute that absolute directory in script commands, even after changing working directories.

You file. Someone else builds.

```
one issue      a bug, a chore, a finding        -> §1, §2, §5
a parent       a plan or a spec with tickets    -> §1 to §6

parent #12  Feedback capture
  |-- #13  design    the feedback form          no blockers
  |-- #14  backend   POST /feedback             no blockers
  \-- #15  frontend  the feedback form          blocked by #13, #14
```

The team has a designer, a frontend developer and a backend developer. A **ticket** is one sub-issue: one discipline's part of a slice, owned by one person, landing as one PR or one design handoff. Every ticket is `design`, `frontend` or `backend`.

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

`wayfinder` cut the slice: one vertical path a user can use. Cut the slice by discipline, never again by feature.

- One ticket per discipline the slice touches. A discipline the slice does not touch gets no ticket: a slice with no screen has no `design` ticket, a visual change with no new data has no `backend` ticket.
- A ticket is done when its owner can hand it over: a green PR, or frames the frontend developer can build from.
- The **seam** between two tickets goes into both bodies, so neither owner waits for a conversation: the API shape between `backend` and `frontend`, the screens and states between `design` and `frontend`.
- The prefactor goes first.

The edges follow from the seams:

| Ticket | Blocked by | Because |
|---|---|---|
| `design` | nothing | it starts from the job and the map |
| `backend` | nothing | it sets the contract |
| `frontend` | `design`, `backend` | it builds the frames against the contract |

A `design` ticket must close before `frontend` starts: a person owns it, and no PR carries it. A `backend` ticket is a code dependency: `frontend` can stack on its open PR once the contract is usable. `issue-queue` owns readiness and branch selection. A ticket that needs a ticket from an earlier slice names it too. A ticket with no blockers can start now.

**A wide refactor is the exception.** One mechanical change whose blast radius fans across the codebase, so no ticket lands green alone. Sequence it as **expand-contract**:

| Step | The ticket | Blocked by |
|---|---|---|
| Expand | Add the new form beside the old. Nothing breaks. | none |
| Migrate | Move the call sites in batches: per package, per directory. One ticket per batch. | Expand |
| Contract | Delete the old form once no caller remains. | every Migrate batch |

## 4 — One round

Show the tickets as a numbered list: discipline, title, what it delivers, what blocks it. Under it, the calls you made and would take a correction on: the granularity, a seam, an edge, a merge or a split. One round, recommended answers, the user answers by exception. `grilling` owns the form.

Record reversible planning assumptions in the parent. If a load-bearing decision is unanswered, mark affected tickets blocked for execution and name the decision; continue filing independent work. Do not seek another confirmation for decisions already settled.

## 5 — File

Every ticket carries exactly one discipline label: `design`, `frontend` or `backend`. So does a lone issue; a bug that spans two disciplines is two issues. The parent and the map carry no discipline label. Create a label the project lacks.

```bash
gh label list --limit 60 --json name --jq '.[].name'
gh label create design --description "Owned by the designer"
```

A project that also labels by area or by kind gets those labels too. No convention, no second label.

The parent first, so each ticket can name it. Then the tickets, blockers first.

```bash
p=$(gh issue create --title "<title>" --body-file <parent.md>); p=${p##*/}
c=$(gh issue create --title "<title>" --label <discipline> --body-file <ticket.md>); c=${c##*/}

"<skill-dir>/scripts/link.sh" sub   "$p" "$c"    # $c is a sub-issue of $p
"<skill-dir>/scripts/link.sh" block "$c" "$b"    # $c is blocked by $b
```

When every ticket is filed, list them in the parent with `gh issue edit $p --body-file <parent.md>`.

A parent closes when its last ticket closes. GitHub does not do that. The `pr` skill does, at merge.

## 6 — A finding, mid-flight

| Does someone have to build something? | Where it goes |
|---|---|
| Yes | a new sub-issue of the parent, in its discipline, with its blocking edges. File it by §5, then add it to the parent's list. |
| No | a comment on the parent. |

A decision, a constraint, a dead end: comment. A behaviour someone must change: sub-issue.

Never edit a ticket someone is already building. Never close the parent early.

## Bodies

Plain words for a reader who was not in the room. A subtle behaviour gets a worked example with real values. Evidence only from an investigation that already happened: the snippet and the file path.

A `frontend` or `backend` body reads current behaviour, then expected behaviour. A `design` body reads the user's job, then the screens and states: the designer reads it, not the code.

A screenshot or a recording in a body follows the Embed table in `browser-evidence`: `![the claim](<local path>)` alone in its paragraph, then `--attach <path>` on the `gh issue create` or `gh issue edit` that files it, so it renders inline instead of as a link.

<parent-template>

## Current behaviour

What happens today, in the fewest clear lines.

## Expected behaviour

What should happen instead, from the user's perspective.

## Tickets

- #13 design — <title>
- #14 backend — <title>
- #15 frontend — <title>

</parent-template>

<ticket-template>

**Parent:** #<parent>

**Blocked by:** #<n>, #<n> - or "None. Can start now."

## Current behaviour

What happens today. Include short evidence from an investigation already completed when it explains the issue.

## Expected behaviour

The behaviour this ticket makes work, from the user's perspective.

## Seam

What this ticket hands over or takes from the other disciplines: the API shape by route and field, the screens by design ticket. Omit when the ticket has no seam.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

</ticket-template>

<design-ticket-template>

**Parent:** #<parent>

**Blocked by:** #<n> - or "None. Can start now."

## The job

Who the user is, and what they come to this screen to do. One or two lines, from the map's destination.

## Today

What the user sees now, and where it fails them. A screenshot when the screen exists.

## Screens and states

One line per screen. Under it, the states the frames must cover: discovery, action, waiting, completion, failure and recovery. Name the state a screen does not have.

## Constraints

- the design system: `DESIGN.md`, or the existing screens this one sits beside
- the data the `backend` ticket exposes, by field name
- the widths: 375 and 1280

## Acceptance criteria

- [ ] every screen and state above has a frame
- [ ] the frames use the design system's tokens and components
- [ ] the frontend developer has read the frames and can build from them
- [ ] a comment on this issue links the frames

</design-ticket-template>

Use short snippets and file paths as evidence of observed current behaviour, not as a prescribed implementation plan. A prototype-derived state machine, schema or type may carry a decision better than prose; inline only that shape and name its source.
