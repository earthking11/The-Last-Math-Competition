# Lean 4 formalisation — disproof of conjecture `00000001068`

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
a reviewer can confirm that nothing depends on `sorryAx`, on `Lean.ofReduceBool`
(the `native_decide` marker), or on Mathlib.

## What is formalised

The conjecture claims that the maximal sum-free subsets of `F_p` are exactly the
intervals `((p+1)/3, 2(p−1)/3)`, uniquely up to dilation. At `p = 11` the
interval is `(4, 20/3) = {5, 6}` (2 elements), but `S = {1, 3, 8, 10}` is a
4-element sum-free set that is maximal by inclusion — and every dilation of the
interval keeps 2 elements, so `S` cannot be a dilation of it.

```lean
/-- Executable sum-freeness test: no a, b, c ∈ S with (a + b) % p = c. -/
def isSumFree (S : List Nat) (p : Nat) : Bool := ...

/-- The conjecture's interval at p = 11: {x ∈ [0,11) : 4 < x < 20/3}. -/
def I11 : List Nat := ...
```

| Theorem | Statement | Role |
|:--------|:----------|:-----|
| `I11_eq` | `I11 = [5, 6]` | the interval is exactly {5, 6} |
| `I11_length` | `I11.length = 2` | … hence 2 elements |
| `sanity_not_sumfree` | `isSumFree [1,2] 11 = false` | non-vacuity: the test rejects a genuinely non-sum-free set |
| `S11_sumfree` | `isSumFree S11 11 = true` | **S = {1,3,8,10} is sum-free** |
| `S11_length` | `S11.length = 4` | S has 4 elements |
| `four_gt_two` | `(4 : Nat) > 2` | the arithmetic fact |
| `S11_maximal` | `∀ x ∈ outsideS, isSumFree (x :: S11) 11 = false` | **S is maximal by inclusion** |
| `dilations_keep_two` | every nonzero dilation of `I11` has length 2 | S cannot be a dilation of the interval |
| `interval_five_empty` | the p = 5 interval is `[]` | side note: empty interval … |
| `sumfree_five_14` | `isSumFree [1,4] 5 = true` | … while {1,4} is sum-free in F_5 |
| `conjecture_00000001068_false` | `∃ S, isSumFree S 11 = true ∧ S.length = 4 ∧ I11.length = 2 ∧ (∀ x ∈ outsideS, …)` | **main refutation** |

## Representation and executability

Elements of `F_p` are plain `Nat`s with arithmetic reduced by `% p` (`ZMod` is
not available in `import Std`). The strict rational inequality `x < 20/3` is
encoded as `3 * x < 20` because `decide` cannot reduce `Rat`; only `Nat`
arithmetic is used. `decide` turns the `Prop`s `4 < x` into `Bool`s for the
list filter.

## Axiom audit

`lake env lean Check.lean` reports, for every one of the eleven theorems:

```
'…' does not depend on any axioms
```

In particular there is no `sorryAx` and no `Lean.ofReduceBool`; the whole file
is kernel-checked definitional computation.

## Scope note

The Lean component proves that a 4-element maximal-by-inclusion sum-free set
exists in `F_11` while the conjecture's interval has 2 elements and dilations
preserve cardinality. This refutes the conjecture at `p = 11` under either
reading of "maximal" (maximum-cardinality or maximal-by-inclusion). The claim
that the true maximal sum-free sets of `F_p` are the Diananda–Yap intervals
with correct endpoints is classical and is not re-proved here.

## Environment

Lean 4.33.1, Lake 5.0.0-src, no Mathlib. `lake build` needs no cache download
(the manifest is created from scratch on first build).
