/-
  Axiom audit for the formalisation in `Main.lean`.

  Run with:
      lake env lean Check.lean

  Every theorem should report no axioms at all (the whole file is decided
  computation over `Nat`/`Bool`/`List`); in particular none may report
  `sorryAx`, and none may report `Lean.ofReduceBool` (which would indicate
  `native_decide`).
-/

import Main

-- Non-vacuity checks on the executable Sidon test
#print axioms sidon_pair_true
#print axioms sidon_triple_false
#print axioms fsub_sample

-- Completeness of the hand-written triple list
#print axioms genTriples_complete

-- The refutation: no 3-element subset of F_5 is Sidon
#print axioms no_sidon_triple
#print axioms pigeonhole_count

-- MAIN: the refutation, phrased as the falsity of the conjecture
#print axioms conjecture_00000001066_false
