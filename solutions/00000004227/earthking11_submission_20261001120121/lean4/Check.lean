/-
  Axiom audit for the formalisation in `Main.lean`.

  Run with:
      lake env lean Check.lean

  Every theorem should report no axioms at all; in particular none may report
  `sorryAx`, and none may report `Lean.ofReduceBool` (which would indicate
  `native_decide`).
-/

import Main

-- Chromatic polynomial values
#print axioms chromPoly_two
#print axioms chromPoly_neg_two
#print axioms no_proper_2coloring

-- The flag complex and the witness
#print axioms allTris_eq
#print axioms witness_covers
#print axioms witness_three

-- H₂ = 0 read-off lemmas
#print axioms bdy_read12
#print axioms bdy_read13
#print axioms bdy_read23
#print axioms witness_acyclic

-- Candidate count bound
#print axioms cands_eq
#print axioms cands_length

-- MAIN: the refutation, both readings
#print axioms refutes_reading_A
#print axioms refutes_reading_B
