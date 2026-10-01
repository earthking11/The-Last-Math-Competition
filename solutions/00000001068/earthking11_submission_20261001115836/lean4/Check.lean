/-
  Axiom audit for the formalisation in `Main.lean`.

  Run with:
      lake env lean Check.lean

  Every theorem should report no axioms at all (the whole file is decided
  computation over `Nat`); in particular none may report `sorryAx`, and none
  may report `Lean.ofReduceBool` (which would indicate `native_decide`).
-/

import Main

-- The conjecture's interval at p = 11
#print axioms I11_eq
#print axioms I11_length

-- Non-vacuity check on the sum-freeness test
#print axioms sanity_not_sumfree

-- The 4-element sum-free set
#print axioms S11_sumfree
#print axioms S11_length
#print axioms four_gt_two

-- Maximality by inclusion
#print axioms S11_maximal

-- Dilations preserve cardinality
#print axioms dilations_keep_two

-- Side note at p = 5
#print axioms interval_five_empty
#print axioms sumfree_five_14

-- MAIN: the refutation
#print axioms conjecture_00000001068_false
