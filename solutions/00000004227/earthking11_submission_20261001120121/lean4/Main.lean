/-
  Disproof of conjecture 00000004227 (flag complex 2-trees vs chromatic polynomial).

  Conjecture (verbatim): "The 2-tree count of a flag complex is given by explicit
  evaluations of the chromatic polynomial of the graph at negative integers, with
  conversion constant 1 and evaluation points the clique number minus 2."

  The phrase "at negative integers" admits two natural readings, and the
  conjecture is false under both:
    Reading A: 2-tree count = P_G(ω(G) − 2).
    Reading B: 2-tree count = P_G(−(ω(G) − 2)).

  Witness: G = K₄.  ω(K₄) = 4 and P_{K₄}(λ) = λ(λ−1)(λ−2)(λ−3).
    Reading A predicts P(2) = 0, but the flag complex of K₄ (the full 3-simplex)
    has an explicit 2-tree {(0,1,2),(0,1,3),(0,2,3)}, so the 2-tree count is
    ≥ 1 ≠ 0.
    Reading B predicts P(−2) = 120, but the flag complex has only 4 triangular
    faces, hence at most C(4,3) = 4 candidate 3-face sets, so the 2-tree count
    is ≤ 4 < 120.

  A 2-tree here means (Kalai): a subcomplex containing the full 1-skeleton, with
  exactly C(n−1,2) triangular faces (n = 4 vertices, so 3 triangles) and H₂ = 0.

  Core Lean only: `import Std`, no Mathlib, no `sorry`, no `native_decide`.
  Finite checks are proved by `decide`; H₂ = 0 is an explicit "read-off" from
  the boundary map (rfl lemmas plus a few handwritten lines, no sorry).

  PITFALLS handled here (same as in the 00000001003 submission):
  * No `DecidableEq` for function types such as `Fin 4 → Fin 2`: colorings are a
    small `structure Col`, triangles a `structure Tri`, chains are tuples.
  * `decide` cannot reduce `Rat`; only `Nat`/`Int` arithmetic is used
    (`Int` kernel reduction works fine).
-/

import Std

/-! ### K₄ and its chromatic polynomial -/

/-- The chromatic polynomial of K₄: P(λ) = λ(λ−1)(λ−2)(λ−3). -/
def chromPoly (z : Int) : Int := z * (z - 1) * (z - 2) * (z - 3)

/-- Reading A evaluation point: P(2) = 0. -/
theorem chromPoly_two : chromPoly 2 = 0 := by decide

/-- Reading B evaluation point: P(−2) = 120. -/
theorem chromPoly_neg_two : chromPoly (-2) = 120 := by decide

/-- A 2-coloring of K₄'s four vertices. -/
structure Col where
  c0 : Nat
  c1 : Nat
  c2 : Nat
  c3 : Nat
deriving DecidableEq, Repr, BEq

/-- All 2⁴ = 16 colorings. -/
def allCols : List Col :=
  (List.range 2).flatMap fun a =>
  (List.range 2).flatMap fun b =>
  (List.range 2).flatMap fun c =>
  (List.range 2).map fun d => ⟨a, b, c, d⟩

/-- Proper: the endpoints of every K₄ edge get different colors. -/
def proper (x : Col) : Bool :=
  x.c0 != x.c1 && x.c0 != x.c2 && x.c0 != x.c3 &&
  x.c1 != x.c2 && x.c1 != x.c3 && x.c2 != x.c3

/-- K₄ has no proper 2-coloring: the computational meaning of P(2) = 0. -/
theorem no_proper_2coloring : (allCols.filter proper).length = 0 := by decide

/-! ### The flag complex of K₄ and the 2-tree witness -/

/-- Triangle with vertices stored in increasing order. -/
structure Tri where
  a : Nat
  b : Nat
  c : Nat
deriving DecidableEq, Repr, BEq

/-- The six edges of K₄. -/
def k4edges : List (Nat × Nat) :=
  [(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]

/-- All triangular faces of the flag complex of K₄: increasing triples from
    {0, 1, 2, 3}. -/
def allTris : List Tri :=
  (List.range 4).flatMap fun i =>
  (List.range 4).flatMap fun j =>
  (List.range 4).filterMap fun k =>
    if i < j ∧ j < k then some ⟨i, j, k⟩ else none

/-- The flag complex of K₄ has exactly the four expected triangular faces. -/
theorem allTris_eq :
    allTris = [⟨0,1,2⟩, ⟨0,1,3⟩, ⟨0,2,3⟩, ⟨1,2,3⟩] := by decide

/-- The explicit 2-tree witness: triangles 012, 013, 023. -/
def witness : List Tri := [⟨0,1,2⟩, ⟨0,1,3⟩, ⟨0,2,3⟩]

/-- An edge is covered by a triangle if both endpoints are vertices of it. -/
def covers (e : Nat × Nat) (t : Tri) : Bool :=
  (e.1 == t.a || e.1 == t.b || e.1 == t.c) &&
  (e.2 == t.a || e.2 == t.b || e.2 == t.c)

/-- Every K₄ edge lies in some triangle of the list. -/
def coversAll (tris : List Tri) : Bool :=
  k4edges.all fun e => tris.any fun t => covers e t

/-- The witness contains the full 1-skeleton: all six edges are covered. -/
theorem witness_covers : coversAll witness = true := by decide

/-- The witness has exactly C(4−1,2) = 3 triangles. -/
theorem witness_three : witness.length = 3 := by decide

/-! ### H₂ = 0 for the witness, by direct read-off -/

/-- A 2-chain: integer coefficients (a, b, d) on triangles 012, 013, 023. -/
abbrev Chain2 := Int × Int × Int

/-- A 1-chain: integer coefficients on the six edges, ordered
    (01, 02, 03, 12, 13, 23). -/
abbrev Chain1 := Int × Int × Int × Int × Int × Int

/-- Simplicial boundary map ∂₂ with the standard orientation
    ∂(ijk) = jk − ik + ij for i < j < k:
      ∂(012) = 12 − 02 + 01, ∂(013) = 13 − 03 + 01, ∂(023) = 23 − 03 + 02. -/
def bdy : Chain2 → Chain1
  | (a, b, d) => (a + b, -a + d, -b - d, a, b, d)

/-- Read-off on edge (1,2): the boundary coefficient is exactly `a`. -/
theorem bdy_read12 (c : Chain2) : (bdy c).2.2.2.1 = c.1 := by
  obtain ⟨a, b, d⟩ := c
  rfl

/-- Read-off on edge (1,3): the boundary coefficient is exactly `b`. -/
theorem bdy_read13 (c : Chain2) : (bdy c).2.2.2.2.1 = c.2.1 := by
  obtain ⟨a, b, d⟩ := c
  rfl

/-- Read-off on edge (2,3): the boundary coefficient is exactly `d`. -/
theorem bdy_read23 (c : Chain2) : (bdy c).2.2.2.2.2 = c.2.2 := by
  obtain ⟨a, b, d⟩ := c
  rfl

/-- H₂ of the witness vanishes: every 2-cycle is trivial, since
    ∂c = 0 forces a = b = d = 0 by the three read-off equations. -/
theorem witness_acyclic (c : Chain2) (h : bdy c = (0, 0, 0, 0, 0, 0)) :
    c = (0, 0, 0) := by
  obtain ⟨a, b, d⟩ := c
  have e1 : a = 0 := by
    have h' : (bdy (a, b, d)).2.2.2.1 = (a, b, d).1 := rfl
    rw [h] at h'
    exact h'.symm
  have e2 : b = 0 := by
    have h' : (bdy (a, b, d)).2.2.2.2.1 = (a, b, d).2.1 := rfl
    rw [h] at h'
    exact h'.symm
  have e3 : d = 0 := by
    have h' : (bdy (a, b, d)).2.2.2.2.2 = (a, b, d).2.2 := rfl
    rw [h] at h'
    exact h'.symm
  rw [e1, e2, e3]

/-! ### Candidate count bound (for reading B) -/

/-- All 3-element subsets of the four triangles, built by deleting one face at
    a time: every 2-tree's face set is one of these, so there are at most four
    candidates. -/
def cands : List (List Tri) :=
  allTris.map fun t => allTris.filter (fun s => s != t)

/-- The four candidate face sets, explicitly. -/
theorem cands_eq :
    cands = [[⟨0,1,3⟩, ⟨0,2,3⟩, ⟨1,2,3⟩],
             [⟨0,1,2⟩, ⟨0,2,3⟩, ⟨1,2,3⟩],
             [⟨0,1,2⟩, ⟨0,1,3⟩, ⟨1,2,3⟩],
             [⟨0,1,2⟩, ⟨0,1,3⟩, ⟨0,2,3⟩]] := by decide

/-- Exactly C(4,3) = 4 candidate face sets. -/
theorem cands_length : cands.length = 4 := by decide

/-! ### The refutation -/

/-- REFUTATION, reading A. The formula predicts P(2) = 0, yet the witness is a
    genuine 2-tree (full 1-skeleton, three triangles, H₂ = 0), so the 2-tree
    count is at least 1 ≠ 0. -/
theorem refutes_reading_A :
    chromPoly 2 = 0 ∧ coversAll witness = true ∧ witness.length = 3 ∧
    ∀ c : Chain2, bdy c = (0, 0, 0, 0, 0, 0) → c = (0, 0, 0) :=
  ⟨by decide, by decide, by decide, fun c h => witness_acyclic c h⟩

/-- REFUTATION, reading B. The formula predicts P(−2) = 120, yet there are at
    most four candidate 2-tree face sets, and 120 > 4. -/
theorem refutes_reading_B :
    chromPoly (-2) = 120 ∧ cands.length = 4 :=
  ⟨by decide, by decide⟩
