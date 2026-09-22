# L3 — dispatch

Every slice has its tickets. Hand the map to the queue.

```
issue-queue --map <map#>
```

`issue-queue` runs the tickets in slice order, through `orchestrate` and `dev`, and babysits the PRs. That is the long run the user lets loose. It is not this skill's.

Hand off with the open decisions still open. They live in the tickets, with the people assigned to them: the Grilling ticket, the Design ticket, and any ticket's `## Open decisions`. The queue skips a ticket until its decisions have answers, and takes it when they do.

An external fact is yours, not a person's: `research`, in the background, and its answer in a comment on the ticket that needs it.

When an answer overturns a later slice's tickets, rewrite those tickets before the queue reaches them.
