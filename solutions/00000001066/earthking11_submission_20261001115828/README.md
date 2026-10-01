# Disproof of conjecture `00000001066` (finite-field Sidon extremality)

> **由 Muse 进行计算验证提交** — 本提交的反例搜索、计算验证与 Lean 4 形式化由 Muse 完成并复核。

## Verdict

**Conjecture 00000001066 is FALSE.** Refuted at `p = 5`.

## The conjecture (verbatim)

**English.** Definition: A Sidon set B ⊂ F_p (all pairwise differences distinct).
Conjecture: |B| ≤ p^{1/2} + 1, and p^{1/2} is attained for prime p
(finite-field Sidon extremality).

**中文。** 定义：Sidon 集 B ⊂ F_p（差分两两不同）。猜想：|B| ≤ p^{1/2} + 1
且素 p 达到 p^{1/2}（有限域 Sidon 极值）。

## The disproof (one paragraph)

The conjecture is a conjunction; its second clause — "√p is attained for
prime p" — is false at p = 5. Attaining √5 would require a Sidon set
B ⊂ F_5 with |B| ≥ √5; since |B| ∈ ℕ and √5 > 2 (2² = 4 < 5), this forces
|B| ≥ 3. But no 3-element subset of F_5 is Sidon: a 3-set has 3·2 = 6
ordered differences a−b (a≠b), all nonzero, while |F_5^*| = 4 < 6, so two
must coincide (pigeonhole). An exhaustive check of all C(5,3) = 10 triples
confirms it; a brute-force enumeration of all 32 subsets finds maximum
Sidon size 2. The unordered-differences reading is refuted too (a 3-set
would need 3 sign classes, but F_5^*/{±1} has 2). Note the first clause
(|B| ≤ √p+1) is *not* refuted at p = 5 (2 ≤ √5+1); the conjunction falls
via its second clause.

## How it was verified

1. **Computation** (`reproduce.py`, standard library only): enumerates all
   32 subsets of F_5, tests Sidon-ness under both the ordered and the
   unordered readings, confirms max size 2, and re-derives the pigeonhole
   counts numerically. Run `python3 reproduce.py` → `PASS`, exit 0.
2. **Lean 4 formalisation** (`lean4/`): F_5 as `Nat` mod 5, executable
   `isSidon` test, machine-checked completeness of the 10-triple
   enumeration, and `decide` proofs that no triple is Sidon. Core Lean
   only (`import Std`), no Mathlib, no `sorry`, no `native_decide`;
   `lake env lean Check.lean` reports zero axiom dependencies for all
   seven theorems.
3. **Paper** (`main.tex` → `build/main.pdf`): self-contained write-up of
   the argument above.

## Files

```
earthking11_submission_20261001115828/
├── README.md        # this file
├── main.tex         # LaTeX source of the disproof paper
├── build/
│   └── main.pdf     # compiled paper (pdflatex, 2 pages)
├── reproduce.py     # independent computational reproduction (stdlib only)
├── PR_BODY.md       # draft PR description (for the GitHub PR)
└── lean4/
    ├── lean-toolchain   # leanprover/lean4:v4.33.1
    ├── lakefile.toml
    ├── Main.lean         # the formalisation
    ├── Check.lean        # #print axioms audit
    └── README.md         # theorem table, representation notes, audit results
```

## Reproduce

```sh
python3 reproduce.py          # expect PASS, exit 0
cd lean4 && lake build       # expect "Build completed successfully"
lake env lean Check.lean     # expect "does not depend on any axioms" × 7
cd .. && pdflatex -output-directory=build main.tex   # rebuilds build/main.pdf
```

## Status against the submission rules

Per `README.md` Rule 3 of The-Last-Math-Competition, each submission must
include the LaTeX source code, a PDF document, and a Lean 4 project —
this submission includes all three (`main.tex`, `build/main.pdf`,
`lean4/`), plus `reproduce.py` and this README as supporting material.

## Caveats

- The refutation targets the *conjunction* via its second clause; the bound
  |B| ≤ √p+1 itself is not disproved (and holds at p = 5).
- "Attained" is read in the standard sharpness sense (a Sidon set of size
  ≥ √p exists); under a literal reading (|B| = √5 exactly) the clause is
  unsatisfiable for trivial integrality reasons, which only strengthens
  the refutation.
