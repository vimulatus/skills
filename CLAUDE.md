# Skills

## Product

Agent skills for Claude Code and Codex, shared across the projects of Vasu's team.

**Stage:** Forked from `vimulatus/agentic` on 2026-09-19 for team use. In active use; evolve quickly, with care for changes that reach every project loading a skill.

- **Users** — Vasu's team: a designer, a frontend developer and a backend developer, and the agents working with them. Vasu's personal workflow stays in `vimulatus/agentic`.
- **Works when** — the right skill fires from an ordinary request, and the tickets it files land with the right person: `design`, `frontend` or `backend`.
- **Non-goals** — a promote from `agentic`; it would overwrite the team rules. A general-purpose framework for a wider audience.

## Ship

- **Run** — no app server. Install one skill with `npx skills add vimulatus/skills@<skill> -g -y`, then start a new client session to load it.
- **Gate** — `git diff --check`, and exercise a changed skill in a fresh session with an ordinary request.
- **Ship** — `sh scripts/release.sh` from a clean `main`; consumers install from `main`. `-n` previews.
