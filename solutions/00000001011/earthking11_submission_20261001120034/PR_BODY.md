Disproof of conjecture 00000001011 (finite unit-distance cliques)

由 Muse 进行计算验证提交。

## Summary

The conjecture claims that in PG(2,q), the unit-distance graph has maximum
clique size q+1. This is false already at q=2: under the most natural model
of the distance (affine patch F₂², adjacency iff the squared distance is a
nonzero quadratic residue), the graph is a 4-cycle with maximum clique size
2 < 3 = q+1.

## What's included

- `main.tex` + `build/main.pdf`: full disproof paper (modeling decision
  documented; the conjecture's distance definition is ambiguous, and the
  literal "distance = 1" reading fails too — see Remarks).
- `reproduce.py`: standalone reproduction, standard library only, all PASS.
- `lean4/`: Lean 4.33.1 project (core Lean, `import Std` only), all theorems
  by `decide`, `Check.lean` axiom audit clean (no axioms, no `sorry`).

Observed pattern (computational): maximum clique is exactly q for
q = 2,3,4,5,7,8,9 — the conjecture likely confuses an affine line (q points)
with a projective line (q+1 points). Only the q=2 instance is formalized;
it suffices as a disproof.
