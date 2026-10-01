# Lean 4 formalisation — disproof of conjecture `00000001066`

Core Lean only (`import Std`), no Mathlib, no `sorry`, no `native_decide`. The
project pins `lean-toolchain` to `leanprover/lean4:v4.33.1` and defines the
library `Main` in `lakefile.toml`.

## Build and audit

```sh
cd lean4
lake build
lake env lean Check.lean
```

`lake build` exits `0`. `Check.lean` prints `#print axioms` for every theorem so
a reviewer can confirm that nothing depends on any axioms at all — in
particular there is no `sorryAx` and no `Lean.ofReduceBool` (the
`native_decide` marker).

## What is formalised

The conjecture claims, among other things, that for prime `p` the bound
`√p` on Sidon sets in `F_p` is *attained*. At `p = 5`, attaining `√5` would
require a Sidon set `B ⊂ F_5` with `|B| ≥ √5`; since `|B|` is a natural
number and `√5 > 2` (because `2² = 4 < 5`), this forces `|B| ≥ 3`. The Lean
development rules out every 3-element subset of `F_5`:

```lean
/-- Subtraction in F_5, represented with `Nat`: (a − b) mod 5. -/
def fsub (a b : Nat) : Nat := (a + 5 - b) % 5

/-- Sidon test (ordered-differences reading): every ordered difference
    is nonzero and all of them are pairwise distinct. -/
def isSidon (B : List Nat) : Bool := ...
```

| Theorem | Statement | Role |
|:--------|:----------|:-----|
| `sidon_pair_true` | `isSidon [0,1] = true` | non-vacuity: the test accepts a genuine Sidon pair |
| `sidon_triple_false` | `isSidon [0,1,2] = false` | non-vacuity: the test rejects a non-Sidon triple (0−1 = 1−2 = 4) |
| `fsub_sample` | `fsub 1 3 = 3` | the difference map is correct (1−3 = −2 = 3 mod 5) |
| `genTriples_complete` | `genTriples = triples10` | **completeness**: the hand-written list of 10 triples is exactly the exhaustive computational enumeration of increasing triples from {0,…,4} |
| `no_sidon_triple` | `triples10.all (fun B => !isSidon B) = true` | **no 3-element subset of F_5 is Sidon** |
| `pigeonhole_count` | `(3*2 : Nat) > 4` | the pigeonhole arithmetic: 6 ordered differences vs 4 nonzero field elements |
| `conjecture_00000001066_false` | `genTriples.all (fun B => !isSidon B) = true` | **main refutation** |

## Representation and executability

Elements of `F_5` are plain `Nat`s reduced with `% 5`; this is deliberate:

- `ZMod`, `Finset` and `Fintype` are **not** available in `import Std`;
- `decide` cannot reduce `Rat`, so the `√5` comparison is kept out of Lean —
  the integer bridge "`|B| ≥ √5` forces `|B| ≥ 3`" is argued in the paper
  (`2² = 4 < 5`), and Lean rules out every 3-element subset;
- bounded `∀ … ∈ …` quantification would pull in `propext` via
  `List.decidableBAll`, so the refutation is phrased with `List.all` (pure
  `Bool` computation) instead: the audit reports zero axioms.

## Axiom audit

`lake env lean Check.lean` reports, for every one of the seven theorems:

```text
'…' does not depend on any axioms
```

## Scope note

The Lean component proves that no 3-element subset of `F_5` is Sidon (under
the standard ordered-differences reading). Combined with the integer
argument in the paper, this refutes the clause "√p is attained for prime p"
at `p = 5`, and hence the conjectured conjunction. The first clause
(`|B| ≤ √p + 1`) is *not* refuted at `p = 5` (the maximum Sidon size 2
satisfies `2 ≤ √5 + 1`); the disproof targets the conjunction via its
second clause. The unordered-differences reading is also refuted (a 3-set
would need 3 sign classes, but `F_5^*/{±1}` has only 2) — see `reproduce.py`
and the paper.

## Environment

Lean 4.33.1, Lake 5.0.0-src, no Mathlib. `lake build` needs no cache download
(the manifest is created from scratch on first build).
