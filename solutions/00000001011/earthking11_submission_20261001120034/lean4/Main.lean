import Std

/-- Points of the affine patch F_2^2 of PG(2,2), as pairs of Nat coordinates. -/
structure Pt where
  x : Nat
  y : Nat
deriving DecidableEq, Repr, BEq

/-- Squared distance in F_2: (x1-x2)^2 + (y1-y2)^2 mod 2.
    In F_2 subtraction equals addition, and a^2 = a for a in {0,1},
    so this is ((x1+x2) + (y1+y2)) mod 2. -/
def sqDist (p q : Pt) : Nat :=
  ((p.x + q.x) % 2 + (p.y + q.y) % 2) % 2

/-- Model A adjacency: distinct points are adjacent iff the squared distance
    is the (unique) nonzero quadratic residue of F_2, i.e. 1. -/
def adj (p q : Pt) : Bool :=
  (p != q) && (sqDist p q == 1)

/-- A list of points is a clique iff every two are adjacent. -/
def pairwiseAdj : List Pt → Bool
  | [] => true
  | p :: rest => rest.all (adj p) && pairwiseAdj rest

def p00 : Pt := ⟨0, 0⟩
def p01 : Pt := ⟨0, 1⟩
def p10 : Pt := ⟨1, 0⟩
def p11 : Pt := ⟨1, 1⟩

-- The four edges of the 4-cycle (0,0)-(0,1)-(1,1)-(1,0)-(0,0).
theorem edge1 : adj p00 p01 = true := by decide
theorem edge2 : adj p00 p10 = true := by decide
theorem edge3 : adj p01 p11 = true := by decide
theorem edge4 : adj p10 p11 = true := by decide

-- The two non-edges (the diagonals).
theorem nonedge1 : adj p00 p11 = false := by decide
theorem nonedge2 : adj p01 p10 = false := by decide

-- A 2-clique exists, so the clique number is at least 2.
theorem clique2 : pairwiseAdj [p00, p01] = true := by decide

-- None of the C(4,3) = 4 triples is a clique, so the clique number is < 3.
theorem notriple1 : pairwiseAdj [p00, p01, p10] = false := by decide
theorem notriple2 : pairwiseAdj [p00, p01, p11] = false := by decide
theorem notriple3 : pairwiseAdj [p00, p10, p11] = false := by decide
theorem notriple4 : pairwiseAdj [p01, p10, p11] = false := by decide
