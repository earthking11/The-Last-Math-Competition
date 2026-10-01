## Disproof of conjecture 00000008256 (maximal Condorcet domains at n=4)

**由 Muse 进行计算验证提交** — 本次提交的反例搜索、计算验证与形式化包装均由 Muse 自动完成。

### Claim refuted

The conjecture's "four-alternative seven-domain law": *the number of maximal
Condorcet domains at n = 4 is exactly 7*.

### Result

Independent enumeration (Sen's 1966 never-condition characterization,
9⁴ = 6561 never-condition intersections → 3604 distinct → 495 maximal domains,
each re-verified directly from the definition) finds **495** maximal Condorcet
domains at n = 4 (31 isomorphism classes under the S₄ relabelling action).
Eight of them are exhibited explicitly in the paper and in `exhibits.json`.

495 ≠ 7 (and neither do the literature counts 31 / 18): the "exactly 7"
sub-claim — and hence the conjunctive conjecture — is false.

### What's in this submission

- `main.tex` / `build/main.pdf` — the disproof paper
- `reproduce.py` — independent re-verification (stdlib only, ~30 s, exit 0);
  also re-runs the full 495-domain enumeration
- `exhibits.json` — the eight explicit exhibit domains, machine-readable
- `lean4/` — Lean 4.33.1 project (core Lean, `import Std`): Sen's test as a
  decidable predicate; the eight exhibits proved Condorcet, maximal, and
  pairwise distinct, all by `decide`; `Check.lean` axiom audit clean
  (no `sorryAx`, no `Lean.ofReduceBool`)

### Scope note

Only the "exactly 7" count sub-claim is refuted here; the Fishburn bound
formula, white-list tightness law, and separable-lattice characterization are
left untouched.
