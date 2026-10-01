# Lean 4 formalisation — disproof of conjecture `00000004227`

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

The conjecture claims that the 2-tree count of a flag complex equals the
chromatic polynomial of the graph evaluated "at negative integers", with
conversion constant 1 and evaluation point the clique number minus 2. The phrase
"at negative integers" admits two natural readings, and the witness `G = K₄`
refutes both:

| Theorem | Statement | Role |
|:--------|:----------|:-----|
| `chromPoly_two` | `chromPoly 2 = 0` | reading A predicts 0 |
| `chromPoly_neg_two` | `chromPoly (-2) = 120` | reading B predicts 120 |
| `no_proper_2coloring` | no proper 2-coloring of K₄ exists | computational meaning of P(2) = 0 |
| `allTris_eq` | the flag complex of K₄ has exactly the 4 triangular faces | fixes the complex |
| `witness_covers` | every K₄ edge lies in a witness triangle | full 1-skeleton |
| `witness_three` | the witness has 3 triangles | C(4−1,2) = 3 faces |
| `bdy_read12/13/23` | boundary on edges 12/13/23 reads off a/b/d | `rfl` lemmas |
| `witness_acyclic` | every 2-cycle on the witness is trivial | **H₂ = 0** |
| `cands_eq` | the four candidate 3-face sets, explicitly | enumeration |
| `cands_length` | `cands.length = 4` | at most 4 candidates |
| `refutes_reading_A` | `P(2) = 0` yet a 2-tree exists | **main refutation, reading A** |
| `refutes_reading_B` | `P(−2) = 120` yet ≤ 4 candidates | **main refutation, reading B** |

## Representation and executability

- A 2-coloring of K₄ is a `structure Col` with four `Nat` fields (there is no
  `DecidableEq` for function types such as `Fin 4 → Fin 2` under `import Std`);
  `no_proper_2coloring` is checked by `decide` over all 2⁴ = 16 colorings.
- A triangle is a `structure Tri` with three `Nat` fields, deriving
  `DecidableEq, Repr, BEq`.
- The chromatic polynomial is evaluated on `Int` (`decide` reduces `Int`
  literals fine; it is `Rat` that `decide` cannot handle).
- A 2-chain on the witness is an `Int × Int × Int` triple of coefficients on
  triangles 012, 013, 023. The boundary map `bdy` is defined explicitly with the
  standard orientation ∂(ijk) = jk − ik + ij, so the three read-off equations
  `(bdy c).2.2.2.1 = c.1` etc. hold by `rfl`; from `bdy c = 0` we get
  `a = b = d = 0` and hence `c = 0`. This is the whole H₂ = 0 argument, in
  about ten handwritten lines, with no `sorry`.

## Axiom audit

`lake env lean Check.lean` reports, for every one of the fourteen theorems:

```
'…' does not depend on any axioms
```

In particular there is no `sorryAx` and no `Lean.ofReduceBool`; everything is
kernel-checked computation or `rfl`-based reasoning.

## Scope note

The Lean component proves the finite computational facts: the two polynomial
values, the absence of a proper 2-coloring, the witness's 1-skeleton coverage
and face count, H₂ = 0 for the witness, and the enumeration of the four
candidate face sets. The mathematical framing — that `P_{K₄}(λ)` really is the
chromatic polynomial (standard closed form for complete graphs), Kalai's
definition of a 2-tree (which is why exactly C(4−1,2) = 3 faces are needed and
why the four candidates exhaust all possibilities), and the conversion-constant
argument — is carried by the accompanying paper (`main.tex`).

## Environment

Lean 4.33.1, Lake 5.0.0-src, no Mathlib. `lake build` needs no cache download
(the manifest is created from scratch on first build).
