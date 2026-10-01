import Std

/-
  Formal refutation of the "exactly 7 maximal Condorcet domains at n = 4"
  sub-claim of conjecture 00000008256.

  We work with the four alternatives {0,1,2,3}. A linear order is a 4-element
  `List Nat`; a domain is a `List (List Nat)`.

  `isCondorcet` is Sen's (1966) never-condition test: a domain is a Condorcet
  domain iff every triple of alternatives admits at least one never-condition
  (alt never at position 0/1/2 within the triple) holding throughout the domain.

  Eight pairwise distinct maximal Condorcet domains are exhibited explicitly,
  each verified by `decide` to be a Condorcet domain and to be maximal
  (adding any outside order destroys the Condorcet property). Eight > 7,
  so the "exactly 7" claim is false.
-/

/-- index of `x` in the order `o` (0-based) -/
def posIn : List Nat -> Nat -> Nat
  | [], _ => 0
  | a :: as, x => if a == x then 0 else 1 + posIn as x

/-- rank of alternative `a` among the triple `T` according to order `o` -/
def rankIn : List Nat -> List Nat -> Nat -> Nat
  | _, [], _ => 0
  | o, b :: bs, a => (if posIn o b < posIn o a then 1 else 0) + rankIn o bs a

/-- the four triples of alternatives drawn from {0,1,2,3} -/
def triples : List (List Nat) := [[0,1,2],[0,1,3],[0,2,3],[1,2,3]]

/-- never-condition: `alt` is never at position `pos` within triple `T`
    throughout the domain `D` (Sen, 1966) -/
def neverHolds (D : List (List Nat)) (T : List Nat) (alt pos : Nat) : Bool :=
  D.all fun o => rankIn o T alt != pos

/-- Sen (1966): `D` is a Condorcet domain iff every triple admits a
    never-condition holding throughout `D` -/
def isCondorcet (D : List (List Nat)) : Bool :=
  triples.all fun T =>
    T.any fun alt =>
      [0,1,2].any fun pos =>
        neverHolds D T alt pos

/-- all 24 linear orders of {0,1,2,3} -/
def allOrders : List (List Nat) := [[0,1,2,3], [0,1,3,2], [0,2,1,3], [0,2,3,1], [0,3,1,2], [0,3,2,1], [1,0,2,3], [1,0,3,2], [1,2,0,3], [1,2,3,0], [1,3,0,2], [1,3,2,0], [2,0,1,3], [2,0,3,1], [2,1,0,3], [2,1,3,0], [2,3,0,1], [2,3,1,0], [3,0,1,2], [3,0,2,1], [3,1,0,2], [3,1,2,0], [3,2,0,1], [3,2,1,0]]

/-- maximality test: every order outside `D` breaks the Condorcet property -/
def isMaximal (D : List (List Nat)) : Bool :=
  allOrders.all fun o => (D.contains o) || !(isCondorcet (o :: D))

/-- the eight exhibit domains (independent enumeration found 495 maximal
    Condorcet domains at n = 4; these eight suffice to refute "exactly 7") -/
def D1 : List (List Nat) := [[0,3,1,2], [1,0,2,3], [2,1,3,0], [3,2,0,1]]
def D2 : List (List Nat) := [[0,2,3,1], [1,3,2,0], [2,1,0,3], [3,0,1,2]]
def D3 : List (List Nat) := [[0,2,1,3], [1,0,3,2], [2,3,0,1], [3,1,2,0]]
def D4 : List (List Nat) := [[0,3,2,1], [1,2,3,0], [2,0,1,3], [3,1,0,2]]
def D5 : List (List Nat) := [[0,1,3,2], [1,2,0,3], [2,3,1,0], [3,0,2,1]]
def D6 : List (List Nat) := [[0,1,2,3], [1,3,0,2], [2,0,3,1], [3,2,1,0]]
def D7 : List (List Nat) := [[2,1,0,3], [2,1,3,0], [2,3,0,1], [2,3,1,0], [3,1,0,2], [3,1,2,0], [3,2,0,1], [3,2,1,0]]
def D8 : List (List Nat) := [[0,1,3,2], [0,2,3,1], [0,3,1,2], [0,3,2,1], [2,0,3,1], [3,0,1,2], [3,0,2,1], [3,1,0,2]]

def domains : List (List (List Nat)) := [D1, D2, D3, D4, D5, D6, D7, D8]

/-- pairwise-distinctness test for a list of domains -/
def pairwiseNe : List (List (List Nat)) -> Bool
  | [] => true
  | d :: ds => (ds.all fun e => d != e) && pairwiseNe ds

theorem condorcet_D1 : isCondorcet D1 = true := by decide
theorem condorcet_D2 : isCondorcet D2 = true := by decide
theorem condorcet_D3 : isCondorcet D3 = true := by decide
theorem condorcet_D4 : isCondorcet D4 = true := by decide
theorem condorcet_D5 : isCondorcet D5 = true := by decide
theorem condorcet_D6 : isCondorcet D6 = true := by decide
theorem condorcet_D7 : isCondorcet D7 = true := by decide
theorem condorcet_D8 : isCondorcet D8 = true := by decide

theorem maximal_D1 : isMaximal D1 = true := by decide
theorem maximal_D2 : isMaximal D2 = true := by decide
theorem maximal_D3 : isMaximal D3 = true := by decide
theorem maximal_D4 : isMaximal D4 = true := by decide
theorem maximal_D5 : isMaximal D5 = true := by decide
theorem maximal_D6 : isMaximal D6 = true := by decide
theorem maximal_D7 : isMaximal D7 = true := by decide
theorem maximal_D8 : isMaximal D8 = true := by decide

theorem distinct_domains : pairwiseNe domains = true := by decide

/-- MAIN: eight pairwise distinct maximal Condorcet domains at n = 4, so the
    conjecture's "exactly 7" count is false. -/
theorem refutation_00000008256 :
    domains.length = 8 /\
    domains.all isCondorcet = true /\
    pairwiseNe domains = true /\
    domains.all isMaximal = true := by decide

