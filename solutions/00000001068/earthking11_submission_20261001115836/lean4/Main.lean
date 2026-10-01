/-
  Disproof of conjecture 00000001068 (maximal sum-free subsets of F_p).

  Conjecture (verbatim): "The maximal sum-free subsets of F_p are exactly the
  intervals ((p+1)/3, 2(p−1)/3), uniquely up to dilation (the complete
  Diananda–Yap characterization over finite fields)."

  This file formalises the refutation at p = 11.  The conjecture's interval is
      ((11+1)/3, 2(11−1)/3) = (4, 20/3),
  i.e. the 2-element set {5, 6} (integer representatives 1..10, strict
  inequalities).  But S = {1, 3, 8, 10} is a 4-element sum-free subset of
  F_11, and it is maximal by inclusion: every x ∉ S destroys sum-freeness.
  Since dilation x ↦ c·x (c ≠ 0) is a bijection of F_11, every dilation of the
  interval still has 2 elements, so S cannot be a dilation of it.  Hence the
  conjecture is false at p = 11 — under either reading of "maximal"
  (maximum-cardinality or maximal-by-inclusion), because S is maximal by
  inclusion and strictly larger than the interval.

  As a side note (also formalised), at p = 5 the conjecture's interval is
  empty while {1, 4} is a nonempty sum-free set.

  Core Lean only: `import Std`, no Mathlib, no `sorry`, no `native_decide`.
  Every theorem below is proved by `decide` and is axiom-free.

  Representation notes (following the 00000001003 submission pattern):
  * Elements of F_p are `Nat`s, arithmetic done with `% p` (`ZMod` is not in
    `import Std`).
  * The strict rational inequality x < 20/3 is encoded as `3 * x < 20`
    (`decide` cannot reduce `Rat`, so only `Nat` arithmetic is used).
  * `4 < x` is a `Prop`; `decide` turns it into a `Bool` for the filter.
-/

import Std

/-- Executable sum-freeness test: no a, b, c ∈ S with (a + b) % p = c. -/
def isSumFree (S : List Nat) (p : Nat) : Bool :=
  !(S.any fun a => S.any fun b => S.any fun c => ((a + b) % p == c))

/-- The conjecture's interval at p = 11: {x ∈ [0,11) : 4 < x < 20/3}. -/
def I11 : List Nat :=
  (List.range 11).filter (fun x => decide (4 < x) && decide (3 * x < 20))

/-- The explicit 4-element sum-free set in F_11. -/
def S11 : List Nat := [1, 3, 8, 10]

/-- The complement F_11 ∖ S, i.e. the candidates that could extend S. -/
def outsideS : List Nat := [0, 2, 4, 5, 6, 7, 9]

/-! ### The conjecture's interval at p = 11 -/

/-- The interval is exactly {5, 6}. -/
theorem I11_eq : I11 = [5, 6] := by decide

/-- … hence it has 2 elements. -/
theorem I11_length : I11.length = 2 := by decide

/-! ### Non-vacuity sanity check for `isSumFree` -/

/-- `[1,2]` is NOT sum-free in F_11 (1 + 1 = 2): the test fires. -/
theorem sanity_not_sumfree : isSumFree [1, 2] 11 = false := by decide

/-! ### The 4-element sum-free set -/

/-- S = {1,3,8,10} is sum-free in F_11: all 16 ordered pairs checked. -/
theorem S11_sumfree : isSumFree S11 11 = true := by decide

/-- S has 4 elements. -/
theorem S11_length : S11.length = 4 := by decide

/-- 4 > 2: the arithmetic content of the refutation. -/
theorem four_gt_two : (4 : Nat) > 2 := by decide

/-! ### Maximality by inclusion -/

/-- S is maximal by inclusion: adjoining any of the 7 outside points
    destroys sum-freeness. -/
theorem S11_maximal :
    ∀ x ∈ outsideS, isSumFree (x :: S11) 11 = false := by decide

/-! ### Dilations preserve cardinality -/

/-- Every nonzero dilation of the interval still has 2 elements, so the
    4-element set S cannot be a dilation of it. -/
theorem dilations_keep_two :
    ∀ c ∈ ([1,2,3,4,5,6,7,8,9,10] : List Nat),
      (I11.map (fun x => (c * x) % 11)).length = 2 := by decide

/-! ### Side note at p = 5 -/

/-- At p = 5 the conjecture's interval (2, 8/3) is empty … -/
theorem interval_five_empty :
    (List.range 5).filter (fun x => decide (2 < x) && decide (3 * x < 8)) = [] := by
  decide

/-- … while {1, 4} is a nonempty sum-free set in F_5. -/
theorem sumfree_five_14 : isSumFree [1, 4] 5 = true := by decide

/-! ### The refutation -/

/-- REFUTATION.  There is a maximal-by-inclusion sum-free set S in F_11 with
    |S| = 4, while the conjecture's interval has only 2 elements and every
    dilation of it keeps 2 elements.  Hence S is not, up to dilation, one of
    the conjecture's intervals, and the conjecture is false at p = 11. -/
theorem conjecture_00000001068_false :
    ∃ S : List Nat, isSumFree S 11 = true ∧ S.length = 4 ∧
      I11.length = 2 ∧
      (∀ x ∈ outsideS, isSumFree (x :: S) 11 = false) :=
  ⟨S11, by decide, by decide, by decide, by decide⟩
