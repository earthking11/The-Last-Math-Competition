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

-- the eight exhibits are Condorcet domains
#print axioms condorcet_D1
#print axioms condorcet_D2
#print axioms condorcet_D3
#print axioms condorcet_D4
#print axioms condorcet_D5
#print axioms condorcet_D6
#print axioms condorcet_D7
#print axioms condorcet_D8

-- each is maximal
#print axioms maximal_D1
#print axioms maximal_D2
#print axioms maximal_D3
#print axioms maximal_D4
#print axioms maximal_D5
#print axioms maximal_D6
#print axioms maximal_D7
#print axioms maximal_D8

-- pairwise distinct
#print axioms distinct_domains

-- MAIN refutation
#print axioms refutation_00000008256
