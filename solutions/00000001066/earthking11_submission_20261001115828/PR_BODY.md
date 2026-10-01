## Disproof of conjecture 00000001066 (finite-field Sidon extremality)

> 由 Muse 进行计算验证提交

**Verdict: the conjecture is FALSE** (refuted at p = 5).

The conjecture claims that for a Sidon set B ⊂ F_p (all pairwise
differences distinct), |B| ≤ √p + 1 **and** √p is attained for prime p.
The second clause fails at p = 5: attaining √5 would require a Sidon set
of integer size ≥ 3 in F_5, but no 3-element subset of F_5 is Sidon — a
3-set has 6 ordered differences a−b (a≠b), all nonzero, while |F_5^*| = 4
(pigeonhole). Exhaustive check of all C(5,3) = 10 triples confirms it.

**This submission contains** (per Rule 3: LaTeX source + PDF + Lean 4 project):

- `main.tex` / `build/main.pdf` — self-contained disproof paper
- `lean4/` — Lean 4.33.1 formalisation, core Lean only (`import Std`),
  every theorem proved by `decide`, no `sorry`, no `native_decide`;
  `lake env lean Check.lean` reports zero axiom dependencies for all
  seven theorems (machine-checked: no 3-element subset of F_5 is Sidon,
  with machine-checked completeness of the 10-triple enumeration)
- `reproduce.py` — independent computational reproduction (stdlib only,
  both ordered and unordered difference readings) → PASS, exit 0
- `README.md` — full write-up, verdict, caveats, reproduce commands

**Caveat:** the refutation targets the conjunction via its second clause;
the bound |B| ≤ √p+1 itself is not disproved (it holds at p = 5).
