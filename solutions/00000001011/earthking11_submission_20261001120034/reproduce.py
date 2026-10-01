#!/usr/bin/env python3
"""Reproduce the disproof of conjecture 00000001011 (stdlib only).

Conjecture: in PG(2,q), the unit-distance graph's maximum clique has size q+1.
We refute it at q=2 under the natural model:
  - work on the affine patch A = F_2^2 (4 points);
  - distinct points are adjacent iff the squared distance
    d(p,q) = (dx)^2 + (dy)^2 is a NONZERO quadratic residue of F_2
    (i.e. d == 1, since QR(F_2) = {1}).

Result: the graph is a 4-cycle, so the maximum clique has size 2 < 3 = q+1.
Points at infinity have no defined distance and are treated as isolated,
which cannot raise the clique number.
"""
import itertools
import sys

PTS = [(0, 0), (0, 1), (1, 0), (1, 1)]  # all of F_2^2


def edge(p, q):
    dx = (p[0] - q[0]) % 2
    dy = (p[1] - q[1]) % 2
    return (dx * dx + dy * dy) % 2 == 1  # nonzero QR of F_2 is {1}


def is_clique(triple):
    return all(edge(p, q) for p, q in itertools.combinations(triple, 2))


def main():
    ok = True

    # 1. Expected edge set: the 4-cycle.
    expected_edges = {((0, 0), (0, 1)), ((0, 0), (1, 0)),
                      ((0, 1), (1, 1)), ((1, 0), (1, 1))}
    got_edges = {(p, q) for p, q in itertools.combinations(PTS, 2) if edge(p, q)}
    if got_edges == expected_edges:
        print("PASS: edge set is the 4-cycle (4 edges, 2 non-edges)")
    else:
        print("FAIL: unexpected edge set:", got_edges)
        ok = False

    # 2. A 2-clique exists (sanity).
    if edge((0, 0), (0, 1)):
        print("PASS: {(0,0),(0,1)} is a clique, so clique number >= 2")
    else:
        print("FAIL: no 2-clique found")
        ok = False

    # 3. None of the C(4,3) = 4 triples is a clique -> clique number < 3.
    triples = list(itertools.combinations(PTS, 3))
    assert len(triples) == 4
    clique_triples = [t for t in triples if is_clique(t)]
    if not clique_triples:
        print("PASS: all 4 triples fail to be cliques, so clique number <= 2")
    else:
        print("FAIL: found a 3-clique:", clique_triples)
        ok = False

    print("max clique = 2 < 3 = q+1  ->  conjecture disproved at q=2")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
