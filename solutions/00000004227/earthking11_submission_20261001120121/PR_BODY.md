## Disproof of conjecture 00000004227 (flag complex 2-trees vs chromatic polynomial)

由 Muse 进行计算验证提交。

Conjecture 00000004227 claims the 2-tree count of a flag complex equals
evaluations of the graph's chromatic polynomial "at negative integers", with
conversion constant 1 and evaluation point the clique number minus 2.

**Refutation (witness: $G = K_4$).** The phrase "at negative integers" admits
two natural readings, and the conjecture is false under both:

- Reading A ($P_G(\omega(G)-2)$): predicts $P_{K_4}(2) = 0$, but the flag
  complex of $K_4$ has an explicit 2-tree $\{(0,1,2),(0,1,3),(0,2,3)\}$
  (full 1-skeleton, 3 faces, $H_2 = 0$), so the count is $\ge 1 \ne 0$.
- Reading B ($P_G(-(\omega(G)-2))$): predicts $P_{K_4}(-2) = 120$, but there
  are only $\binom{4}{3} = 4$ candidate face sets, so the count is $\le 4 < 120$
  (exactly 4 by enumeration).

**Contents** (per project Rule 3: LaTeX source + PDF + Lean 4 project):

- `main.tex` / `build/main.pdf` — full disproof paper
- `reproduce.py` — independent re-verification (stdlib only, exit 0)
- `lean4/` — Lean 4.33.1, `import Std` only, 14 theorems (all `decide` /
  `rfl`-based, no `sorry`), `Check.lean` axiom audit clean
