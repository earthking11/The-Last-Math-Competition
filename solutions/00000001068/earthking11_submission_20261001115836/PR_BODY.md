# PR title

Disproof of conjecture 00000001068 (maximal sum-free subsets of F_p)

# PR body

Disproof of conjecture `00000001068`.

> 由 Muse 进行计算验证提交。

**Claim refuted:** "The maximal sum-free subsets of F_p are exactly the
intervals ((p+1)/3, 2(p−1)/3), uniquely up to dilation."

**Counterexample (p = 11):** the conjectured interval is {5, 6} (2 elements),
but S = {1, 3, 8, 10} ⊆ F_11 is sum-free (S+S = {0,2,4,5,6,7,9}, disjoint from
S), has 4 > 2 elements, and is maximal by inclusion — so it cannot be a
dilation of the interval. (At p = 5 the interval is even empty while {1,4} is
sum-free.) The AI-generated conjecture misstates the interval endpoints of
the classical Diananda–Yap characterization.

**Contents** (`solutions/00000001068/earthking11_submission_20261001115836/`):
- `main.tex` + `build/main.pdf` — full write-up with the complete addition table
- `reproduce.py` — independent reproduction, stdlib only (`python3 reproduce.py`, all PASS)
- `lean4/` — Lean 4.33.1, core Lean only (`import Std`), all theorems by `decide`;
  `lake build` succeeds and `Check.lean` axiom audit is clean (no `sorryAx`,
  no `Lean.ofReduceBool`, no Mathlib)
- `README.md` — verdict, verification layers, and Rule-3 compliance checklist
