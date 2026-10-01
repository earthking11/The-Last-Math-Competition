# Disproof of conjecture 00000001011

> 由 Muse 进行计算验证提交。

## Verdict

**Disproved.** The conjecture claims that in PG(2,q), the unit-distance
graph has maximum clique size q+1. At q=2 the maximum clique has size
2 < 3, under the most natural model of the (ambiguous) distance definition.

## The conjecture (quoted from `conjectures/00000001011.md`)

- English: "Conjecture: In PG(2,q), the maximum clique of the unit-distance graph (distance √d for d a quadratic residue of F_q) has size q + 1 (finite unit-distance cliques)."
- 中文："猜想：PG(2,q) 中单位距图（距离 √d 恰 d ∈ F_q 二次剩余）的最大团为 q + 1（有限单位距团）。"

## Disproof sketch

Work on the affine patch A = F₂² of PG(2,2) with the standard quadratic form
d(p,q) = (Δx)² + (Δy)². Distinct points are adjacent iff d(p,q) is a nonzero
quadratic residue of F₂ (i.e. d = 1). Points at infinity have no defined
distance and are treated as isolated vertices, which cannot raise the clique
number. (The paper documents this modeling decision; the parenthetical
definition in the conjecture is ambiguous, and a literal "distance = 1"
reading fails as well — see the paper's Remarks.)

The 4 points of F₂² give the graph

    (0,0) — (0,1) — (1,1) — (1,0) — (0,0),

a 4-cycle: 4 edges, the two diagonals non-edges. None of the C(4,3) = 4
triples is a clique, so the maximum clique has size exactly 2 < 3 = q+1.

Observed pattern (computational, not formalized): under this model the
maximum clique is exactly q for q = 2,3,4,5,7,8,9 — the conjecture likely
confuses an affine line (q points) with a projective line (q+1 points).

## Multiple verification

1. Independent Python re-check of the edge set, the 4-cycle structure, and
   the triple enumeration (`reproduce.py`, stdlib only) — all PASS.
2. The original verification script enumerated exact clique numbers for
   q = 2,3,4,5,7,8,9 (Bron–Kerbosch) plus a second distance model as a
   robustness check.
3. Lean 4 formalization of the q=2 instance, all theorems by `decide`,
   axiom audit clean (see `lean4/Check.lean`).

## Caveats

- The conjecture's distance definition is ambiguous; we formalize the most
  natural reading and note the alternative reading also fails (paper §4).
- Only the q=2 instance is needed and formalized; larger-q values are
  computational observations, not theorems.

## Files

| File | Description |
|---|---|
| `main.tex` | LaTeX source of the disproof paper |
| `build/main.pdf` | compiled PDF |
| `reproduce.py` | standalone reproduction (stdlib only): `python3 reproduce.py` |
| `lean4/` | Lean 4 project: `Main.lean`, `Check.lean`, `lakefile.toml`, `lean-toolchain`, `README.md` |
| `PR_BODY.md` | draft PR description (internal, not part of the submission) |

## Reproduce

```bash
python3 reproduce.py                      # expect all PASS, exit 0
cd lean4 && lake build Main               # Lean build
cd lean4 && lake env lean Check.lean      # axiom audit: no axioms
```

## Status against the submission rules

Per Rule 3 of the repository README, each submission must include the
LaTeX source code, a PDF document, and a Lean 4 project — all three are
present (`main.tex`, `build/main.pdf`, `lean4/`).
