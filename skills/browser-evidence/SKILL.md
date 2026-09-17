---
name: browser-evidence
description: Drive a browser, capture shots and recordings, host and embed them so they render in a PR or an issue. Use when verifying a web UI change in the running app, or evidence goes into a PR or an issue. Not for the agent-browser command reference, nor for a bug hunt across the app, which bug-hunt owns.
---

# Browser evidence

Resolve `<skill-dir>` from this skill's loaded `SKILL.md` path. Substitute that absolute directory in script commands, even after changing working directories.

`agent-browser` is the browser.

```
server ──> session ──> auth ──> drive ──> capture ──> host ──> embed ──> close your session
```

The command catalog is not in this file. It ships with the CLI and it is version-matched:

```bash
agent-browser skills get core     # load this first
```

Everything below is the house layer on top of it.

## The server

Probe the port before you start anything.

```bash
lsof -nP -iTCP:<port> -sTCP:LISTEN
```

| The port | Do |
|---|---|
| has a listener | it is the user's. Drive it. Never kill it, never start a second one on another port |
| is free | start your own, to a log file, and stop it when you are done |

## One session per task

- Pass `--session <task>` on every command. `<task>` is a kebab-case slug for the work, one per worktree.
- Close your own session. `close --all` kills the browser of every parallel project.

## Auth

- State lives at `~/.agent-auth/<host>.json`. Outside the repo, so a worktree and a second project find it too.
- **Restore first.** The file exists, so pass `--state` and skip the login.
- No file: log in, then `state save ~/.agent-auth/<host>.json`.
- Passwords reach the CLI through the vault (`auth save` / `auth login`) or through `--password-stdin`. Shell history is a leak.
- A gated page, no state file and no credentials: stop and report `auth required`.

## Capture

The task names the claim. The claim picks the evidence.

| The claim | The evidence | The command |
|---|---|---|
| a state: a page, a dialog, an error shown | a screenshot | `screenshot <path>` |
| a layout detail: one component, one row | a crop of that element | `screenshot <selector> <path>` |
| a flow, motion, timing, or a state that a still cannot show | a recording, plus a screenshot of the end state | `record start <path>.webm` … `record stop` |
| a functional check | `console` and `errors`, every time. One error or one failed request is a **fail** | `console`, `errors` |

Nothing lands in the repo. Everything lands in `${TMPDIR:-/tmp}/vimulatus/<task>/`: screenshots, recordings, console dumps.

Name each file for the claim it supports: `login-shows-error.png`, not `screenshot-3.png`. A recording follows the same rule: `drag-reorders-the-list.webm`.

### A recording

The reader watches it once, at 1x, without you there to narrate. Record so that a stranger can follow it.

- Open the page and snapshot it before `record start`. Plan the refs first, then record only the actions.
- Pace it for a human: `wait 500` to `wait 1000` after each action, and `type` rather than `fill`, so the reader sees the input arrive.
- Wait for the end state to render, then hold it for a moment before `record stop`. Prove the end state with a screenshot and a `get text` or `is visible`, exactly like a still.
- One claim per recording, as short as its steps allow. A second claim is a second recording.

## Host

`gh` 2.99 or newer attaches a file straight to an issue, a PR, or a comment on either. There is no separate upload step and no URL to carry around by hand. Check once:

```bash
gh --version
```

Write the body first, against the local files, per Embed below. Then pass each file once, with `--attach`, to the command that creates or edits the issue, the PR, or the comment:

```bash
gh pr create --body-file <body.md> \
  --attach "${TMPDIR:-/tmp}/vimulatus/<task>/after.png" \
  --attach "${TMPDIR:-/tmp}/vimulatus/<task>/drag-reorders-the-list.webm"
```

`gh` uploads each file, finds its path in the body, and rewrites the reference to the uploaded URL. A file the body never mentions lands at the end, in its own paragraph. Write the absolute path in the body and pass the same path to `--attach`.

On an edit, pass `--body-file` with `--attach`. Without it, `gh pr edit` and `gh issue edit` keep the server body and append the file.

Limits: 50 files per command, an image up to 10 MB, a video up to 100 MB, or 10 MB on a free plan. Types: PNG, JPEG, GIF, WebP, SVG, MP4, MOV, WebM.

Anyone who holds the uploaded URL reads the file, and a PR body is as public as its repo. Crop to the claim: a full screen carries the tabs, the clock, and whatever else was open. Never a token, a key, or a real customer's data.

## Embed

The reader scrolls the PR or the issue once. A shot that renders as a link is a shot the reader never opens. This rule exists because past PR bodies wrote `[Before](<path>) · [After](<path>)` and the media went unseen.

| The file | Write | Never |
|---|---|---|
| a screenshot, a crop | `![<the claim>](<local path>)` alone in its own paragraph, a blank line above and below | `[text](<local path>)`, an empty `![](<local path>)`, or the reference inside a sentence |
| a recording, `.webm` or `.mp4` | the claim as the sentence above it, then `![<the claim>](<local path>)` alone in its own paragraph. GitHub plays the uploaded video inline, and the alt text does not survive the upload, so the sentence carries the claim | the reference inside a sentence, or a table cell |
| a before and after pair | one two-column table, `Before` and `After`, one screenshot per cell | a recording in the table: a table cell is not a paragraph on its own, so `--attach` degrades it to a link instead of a player |

The alt text is the claim, in the words of the PR: `after: the key path prompt refuses a bad key`. A reader who cannot load the image still reads what it showed.

```markdown
The prompt refuses a key with a slash.

![after: the prompt refuses a bad key](/tmp/vimulatus/24-key-path/after-refuses-bad-key.png)

The drag reorders the list and the order survives a reload.

![drag reorders the list, then a reload keeps the order](/tmp/vimulatus/24-key-path/drag-reorders-the-list.webm)
```

Check the body before you attach anything:

```bash
"<skill-dir>/scripts/check-embeds.sh" <body.md>
```

It passes a local path or an uploaded URL alone in its own paragraph, and a table row of image cells. It fails a link, an empty embed, or a reference inside a sentence, on either side of the attach.

## Proof

- A screenshot is not proof. Name the expected text or selector: `get text`, `is visible`, `wait --text`.
- Report the claim, the command that proved it, and the URL or the path of the file.

## Done

- [ ] Every claim names the text or the selector that proved it.
- [ ] Console and errors are captured, and they are clean.
- [ ] Every shot a reader needs is attached and embedded by the Embed table, and it renders on the page.
- [ ] Your session is closed. Every other session still runs. Your server, if you started one, is stopped.
