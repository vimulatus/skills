# Skills

Agent skills for Claude Code and Codex. Each directory under `skills/` is one skill, and its `SKILL.md` says when it fires.

## Install

```sh
npx skills add vimulatus/skills@<skill> -g -y
```

Omit `-g` for a project install. Or copy `skills/<skill>` into `.claude/skills/` for Claude Code, or `.agents/skills/` for Codex.

## Skills

### 1. Planning

1.1. **Grilling** - Follows the rubber-duck principle, and interviews me to clarify my doubts. I have optimised it a lot, so that it asks only load bearing questions.

1.2. **Wayfinder** - Helps me plan out work by breaking it into vertical slices I can release one at a time, then files a ticket for every slice.

1.3. **SLC** - Shapes a release as simple, lovable and complete, after Jason Cohen's essay. It picks the destination of a release and judges every cut against it.

1.4. **Research** - Answers from primary sources: docs, source, specs. One fact comes back inline with the source next to it. A topic comes back as a report.

1.5. **Product context** - Writes the Product and Ship sections of a project's rule file: who it is for, the stage, what not to build, and how to run, gate and ship it.

1.6. **To tickets** - Files one issue, or a parent with a sub-issue per ticket and the blocking edges between them. It files, it never builds.

### 2. Orchestration

2.1. **Orchestrate** - Runs workers in parallel, sized to the machine's load. One subagent, one task, one return.

2.2. **Issue queue** - Works the open GitHub issues to PRs with a dev worker, and watches for new ones while I am away.

2.3. **Status** - Tells me where a project stands when I come back: what landed, what is open, the next ticket.

2.4. **Handoff** - Writes the session down so a fresh session picks it up: where the work stands, what I decided, what comes next.

### 3. Building

3.1. **Coding** - How I want code written: solve the class not the case, deep modules behind small interfaces, a provider boundary around every vendor, and what it must not touch.

3.2. **Red-green** - Establishes a check that fails before the change and passes after it. For a refactor, a baseline that must not move.

3.3. **Unslop** - Cuts the tells of machine-written code: narrating comments, unearned abstraction, defensive scaffolding.

3.4. **Architecture** - Finds the friction worth fixing, and hands me a recommendation to judge before anyone designs the refactor.

3.5. **Context engineering** - Picks the home for an instruction, be it a project rule, a skill, a script, a hook or a subagent, and writes the lines. Also the fix when a skill does not fire.

### 4. Shipping

4.1. **PR** - Lands a change as a PR, then babysits it to ready: watches the checks, answers the threads. I merge.

4.2. **Review** - Reviews PRs other people opened, smallest first, one reviewer per PR in parallel, and merges on my word.

4.3. **Ship** - Takes a merged change to users: the tag, the workflow, the deploy. Then checks live that users got it.

4.4. **Blacksmith** - Moves GitHub Actions CI onto Blacksmith runners and sticky-disk caching when CI is slow.

### 5. Design

5.1. **Taste** - Decides how UI looks and behaves, from the reader's task and the project's design system.

5.2. **Copy** - Writes the strings a user reads: labels, empty states, errors, guides. The what, without the how.

5.3. **Prototype** - Builds a single HTML file so I can see a flow, a state machine or a screen before it is built.

### 6. Evidence

6.1. **Browser evidence** - Drives a browser, captures shots and recordings, and hosts them so they render in a PR or an issue.

6.2. **Bug hunt** - Uses a running app the way its user would, and reports every bug with a repro, shots and a recording.

### 7. Explaining

7.1. **Handout** - Answers with one HTML page when the answer is too long for chat: a report, an explainer.

7.2. **ELI5** - Explains a topic to someone who knows nothing about it, as a handout page.

7.3. **Teach** - Teaches me a topic I am blank on, without touching the code. One idea per turn, and something for me to try at the end of each.

## Source

These files are promoted from [vimulatus/agentic](https://github.com/vimulatus/agentic). Each promote overwrites the copy here, so send changes there.
