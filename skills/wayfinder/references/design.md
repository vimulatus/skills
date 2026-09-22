# Design direction

A person picks how a new screen looks and moves, from a prototype, never from a question: ten Frontend tickets built on ten private guesses cost a full redesign.

The Design ticket asks its assignee for the prototype: 3 to 5 variants, each a canvas of every screen the slice needs, and the pick. It closes with the picked variant and its URL. You file it; you do not build it.

Every Frontend ticket of the slice is blocked by it; the edge does the holding. The first Frontend ticket to land creates `DESIGN.md` from the pick, so later slices and `dev` inherit the direction. A later slice needs a Design ticket only for a screen `DESIGN.md` does not cover.
