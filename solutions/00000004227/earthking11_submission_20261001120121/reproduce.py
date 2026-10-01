#!/usr/bin/env python3
"""Reproduce the disproof of conjecture 00000004227 (flag complex 2-trees).

Conjecture (verbatim): "The 2-tree count of a flag complex is given by explicit
evaluations of the chromatic polynomial of the graph at negative integers, with
conversion constant 1 and evaluation points the clique number minus 2."

Witness graph: G = K4.
  omega(K4) = 4, so the evaluation point is omega - 2 = 2 (reading A),
  resp. -(omega - 2) = -2 (reading B, "at negative integers").
  P_{K4}(2) = 0, P_{K4}(-2) = 120, but the 2-tree count of the flag complex
  of K4 is 4.  0 != 4 and 120 != 4, so the conjecture is false under both
  natural readings.  Conversion constant is 1, so no rescaling can fix it.

Pure standard library (fractions for exact rank computation).
Exit 0 with "ALL CHECKS PASSED" iff every claim below holds; nonzero otherwise.
"""
import itertools
from fractions import Fraction

FAILURES = []


def check(name, cond):
    print(("PASS" if cond else "FAIL"), "-", name)
    if not cond:
        FAILURES.append(name)


print("=== 1. K4 basics ===")
verts = [0, 1, 2, 3]
edges = [(i, j) for i in range(4) for j in range(i + 1, 4)]
edge_index = {e: i for i, e in enumerate(edges)}
# clique number of K4 (brute force over subsets)
omega = max(len(s) for r in range(5) for s in itertools.combinations(verts, r)
            if all((min(a, b), max(a, b)) in edge_index
                   for a, b in itertools.combinations(s, 2)))
print("omega(K4) =", omega)
check("omega(K4) == 4", omega == 4)
check("K4 has 6 edges", len(edges) == 6)

print("\n=== 2. Chromatic polynomial of K4 at 2 and -2 ===")
proper2 = [c for c in itertools.product(range(2), repeat=4)
           if all(c[i] != c[j] for i, j in edges)]
print("proper 2-colorings of K4 (brute force over 2^4):", len(proper2))
check("no proper 2-coloring of K4", len(proper2) == 0)


def P_K4(lam):
    # closed form P(K_n, lam) = lam(lam-1)...(lam-n+1) at n = 4
    return lam * (lam - 1) * (lam - 2) * (lam - 3)


print("P(4) =", P_K4(4), "(expect 24 = 4!)")
check("P(4) == 24", P_K4(4) == 24)
print("P(2) =", P_K4(2), " P(-2) =", P_K4(-2))
check("P(2) == 0  [reading A predicts 0]", P_K4(2) == 0)
check("P(-2) == 120  [reading B predicts 120]", P_K4(-2) == 120)

print("\n=== 3. 2-trees of the flag complex of K4 ===")
tris = list(itertools.combinations(range(4), 3))
print("triangles of the 2-skeleton:", tris)
check("flag complex of K4 has exactly 4 triangular faces", len(tris) == 4)


def rank(mat):
    """Exact rank of an integer matrix via Fraction Gaussian elimination."""
    m = [[Fraction(x) for x in row] for row in mat]
    r = 0
    for c in range(len(m[0])):
        piv = next((i for i in range(r, len(m)) if m[i][c] != 0), None)
        if piv is None:
            continue
        m[r], m[piv] = m[piv], m[r]
        piv_val = m[r][c]
        m[r] = [x / piv_val for x in m[r]]
        for i in range(len(m)):
            if i != r and m[i][c] != 0:
                f = m[i][c]
                m[i] = [x - f * y for x, y in zip(m[i], m[r])]
        r += 1
    return r


def boundary_matrix(tri_list):
    """6 x m integer matrix of C_2 -> C_1. Oriented: d(ijk) = jk - ik + ij."""
    cols = []
    for (i, j, k) in tri_list:
        col = [0] * 6
        col[edge_index[(j, k)]] += 1
        col[edge_index[(i, k)]] -= 1
        col[edge_index[(i, j)]] += 1
        cols.append(col)
    return [list(row) for row in zip(*cols)]


def is_two_tree(tri_list):
    """Kalai 2-tree: full 1-skeleton, exactly C(4-1,2) = 3 triangles, H_2 = 0."""
    if len(tri_list) != 3:
        return False
    covered = set()
    for (i, j, k) in tri_list:
        covered.update([(i, j), (i, k), (j, k)])
    if len(covered) != 6:
        return False
    return rank(boundary_matrix(tri_list)) == 3


two_trees = [c for c in itertools.combinations(tris, 3) if is_two_tree(c)]
print("2-tree count (brute force over C(4,3) = 4 candidates):", len(two_trees))
check("2-tree count == 4", len(two_trees) == 4)

print("\n=== 4. Explicit 2-tree witness ===")
W = [(0, 1, 2), (0, 1, 3), (0, 2, 3)]
check("witness {(0,1,2),(0,1,3),(0,2,3)} is a 2-tree", is_two_tree(W))
B = boundary_matrix(W)
# read-off: boundary on edges 12 / 13 / 23 is exactly a / b / c
check("d(a*012+b*013+c*023)|_12 = a",
      [B[edge_index[(1, 2)]][j] for j in range(3)] == [1, 0, 0])
check("d(a*012+b*013+c*023)|_13 = b",
      [B[edge_index[(1, 3)]][j] for j in range(3)] == [0, 1, 0])
check("d(a*012+b*013+c*023)|_23 = c",
      [B[edge_index[(2, 3)]][j] for j in range(3)] == [0, 0, 1])

print("\n=== 5. Refutation ===")
print("2-tree count = 4,  P_K4(2) = 0,  P_K4(-2) = 120")
check("reading A: 0 != 4", P_K4(2) != len(two_trees))
check("reading B: 120 != 4", P_K4(-2) != len(two_trees))
check("reading B impossible under any definition (120 > 16 >= count)",
      P_K4(-2) > 2 ** len(tris) >= len(two_trees))

print()
if FAILURES:
    print("FAILURES:", FAILURES)
    raise SystemExit(1)
print("ALL CHECKS PASSED: conjecture 00000004227 is false (witness: K4).")
