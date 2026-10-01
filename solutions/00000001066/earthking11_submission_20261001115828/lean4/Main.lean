/-
  Disproof of conjecture 00000001066 (finite-field Sidon extremality).

  Conjecture (verbatim): "Definition: A Sidon set B ⊂ F_p (all pairwise
  differences distinct). Conjecture: |B| ≤ p^{1/2} + 1, and p^{1/2} is
  attained for prime p."

  Refutation at p = 5.  The conjecture is a conjunction; its second clause
  "√p is attained for prime p" is false at p = 5.  "Attained" would require
  a Sidon set B ⊂ F_5 with |B| ≥ √5.  Since |B| is a natural number and
  √5 > 2 (because 2² = 4 < 5), this forces |B| ≥ 3.  But no 3-element
  subset of F_5 is Sidon, by a pigeonhole argument: a 3-set has 3·2 = 6
  ordered differences a − b (a ≠ b), all nonzero, while |F_5^*| = 4 < 6,
  so two of them must coincide.  This file machine-checks that none of
  the C(5,3) = 10 increasing triples is Sidon.

  Core Lean only: `import Std`, no Mathlib, no `sorry`, no `native_decide`.
  Every theorem below is proved by `decide` and is axiom-free.

  PITFALLS handled here:
  * `ZMod`, `Finset`, `Fintype` are NOT in `import Std`; arithmetic in F_5
    is done with `Nat` and `% 5`.
  * `decide` cannot reduce `Rat`, so the √5 comparison is kept out of Lean:
    the integer bridge "|B| ≥ √5 forces |B| ≥ 3" is argued in the paper
    (2² = 4 < 5), and Lean rules out every 3-element subset.
  * Bounded `∀ ... ∈ ...` quantification pulls in `propext` via
    `List.decidableBAll`, so the refutation is phrased with `List.all`
    (pure `Bool` computation) instead: zero axioms.
-/

import Std

/-- Subtraction in F_5, represented with `Nat`: (a − b) mod 5. -/
def fsub (a b : Nat) : Nat := (a + 5 - b) % 5

/-- All ordered differences a − b (a ≠ b) of a list, computed in F_5. -/
def orderedDiffs (B : List Nat) : List Nat :=
  B.flatMap (fun a => B.filterMap (fun b => if a == b then none else some (fsub a b)))

/-- Sidon test (ordered-differences reading, the standard one): every
    ordered difference is nonzero and all of them are pairwise distinct. -/
def isSidon (B : List Nat) : Bool :=
  let ds := orderedDiffs B
  ds.all (fun d => d != 0) && ds.Nodup

/-! ### Non-vacuity sanity checks for `isSidon` -/

/-- `{0,1}` is genuinely Sidon: its ordered differences are 1 and 4. -/
theorem sidon_pair_true : isSidon [0, 1] = true := by decide

/-- `{0,1,2}` is genuinely not Sidon: 0−1 = 1−2 = 4 in F_5. -/
theorem sidon_triple_false : isSidon [0, 1, 2] = false := by decide

/-- The difference map is correct on a sample: 1−3 = −2 = 3 in F_5. -/
theorem fsub_sample : fsub 1 3 = 3 := by decide

/-! ### The refutation: no 3-element subset of F_5 is Sidon -/

/-- Exhaustive computational enumeration of the increasing triples
    i<j<k drawn from {0,…,4}. -/
def genTriples : List (List Nat) :=
  (List.range 5).flatMap fun i =>
    (List.range 5).flatMap fun j =>
      (List.range 5).filterMap fun k =>
        if i < j ∧ j < k then some [i, j, k] else none

/-- The C(5,3) = 10 increasing triples, written out explicitly. -/
def triples10 : List (List Nat) :=
  [[0,1,2],[0,1,3],[0,1,4],[0,2,3],[0,2,4],
   [0,3,4],[1,2,3],[1,2,4],[1,3,4],[2,3,4]]

/-- Machine-checked completeness: the hand-written list is exactly the
    exhaustive enumeration.  Any 3-element subset of F_5 is, after ordering
    its elements, one of these triples. -/
theorem genTriples_complete : genTriples = triples10 := by decide

/-- None of the 10 triples is Sidon. -/
theorem no_sidon_triple : triples10.all (fun B => !isSidon B) = true := by decide

/-- Pigeonhole arithmetic behind the refutation: a 3-set produces 3·2 = 6
    ordered differences, but F_5^* has only 4 nonzero elements. -/
theorem pigeonhole_count : (3 * 2 : Nat) > 4 := by decide

/-- REFUTATION.  "√5 is attained" would require a Sidon set B ⊂ F_5 with
    |B| ≥ √5; since |B| ∈ ℕ and √5 > 2 (2² = 4 < 5), this needs |B| ≥ 3.
    But `no_sidon_triple` (with machine-checked completeness
    `genTriples_complete`) shows no 3-element subset of F_5 is Sidon.
    Hence the second clause of the conjecture is false at p = 5, and the
    conjunction as a whole is false. -/
theorem conjecture_00000001066_false :
    genTriples.all (fun B => !isSidon B) = true := by decide
