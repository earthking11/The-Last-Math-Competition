# Lean 4 formalization — disproof of conjecture 00000001011

## What is formalized

The $q=2$ instance of the disproof (Model A from the paper).

- `Pt`: points of the affine patch $\mathbb{F}_2^2$, as pairs of `Nat` coordinates.
- `sqDist p q`: squared distance $(\Delta x)^2+(\Delta y)^2 \bmod 2$
  (in $\mathbb{F}_2$, subtraction = addition and $a^2=a$).
- `adj p q`: `p ≠ q` and `sqDist p q = 1`, i.e. the squared distance is the
  unique nonzero quadratic residue of $\mathbb{F}_2$.
- `pairwiseAdj`: every two points of a list are adjacent (a clique).

## Theorem list

| Theorem | Statement |
|---|---|
| `edge1`–`edge4` | the four edges of the 4-cycle are edges |
| `nonedge1`, `nonedge2` | the two diagonals are non-edges |
| `clique2` | `{(0,0),(0,1)}` is a clique (clique number ≥ 2) |
| `notriple1`–`notriple4` | none of the C(4,3) = 4 triples is a clique (clique number < 3) |

Together: the graph is exactly the 4-cycle, maximum clique size = 2 < 3 = q+1.

## Proof style

Core Lean only (`import Std`), no Mathlib, no `sorry`, no `native_decide`.
Every theorem is proved by `decide`.

## Axiom audit

`Check.lean` runs `#print axioms` on every theorem. Result:

```
'edge1' does not depend on any axioms
... (all 11 theorems: no axioms)
```

No `sorryAx`, no `Lean.ofReduceBool`, no classical reasoning.

## Scope note

Only the $q=2$ instance is formalized; it suffices as a disproof.
The values for $q=3,4,5,7,8,9$ (maximum clique $=q$ under Model A) are
computational observations reported in the paper, not formalized here.

## Environment

- Lean 4.33.1 (`lean-toolchain` pins `leanprover/lean4:v4.33.1`), Lake 5.0.0
- Build: `lake build Main` (completed successfully)
- Audit: `lake env lean Check.lean`
