#!/usr/bin/env python3
"""Reproduce the disproof of conjecture 00000001066 (finite-field Sidon extremality).

Conjecture (verbatim): "Definition: A Sidon set B subset F_p (all pairwise
differences distinct). Conjecture: |B| <= p^{1/2} + 1, and p^{1/2} is
attained for prime p."

This script independently re-derives, from scratch, that the clause
"sqrt(p) is attained for prime p" is false at p = 5:

  * enumerates all 2^5 = 32 subsets of F_5,
  * tests the Sidon property under BOTH readings
    (ordered differences distinct / unordered differences distinct up to sign),
  * confirms the maximum Sidon size is 2 < 3, while attaining sqrt(5)
    would require a Sidon set of size >= 3 (integer size >= sqrt(5) ~= 2.236).

Standard library only. Prints PASS/FAIL and exits nonzero on failure.

Run: python3 reproduce.py
"""

import itertools
import math
import sys

P = 5


def ordered_diffs(B):
    return [(a - b) % P for a in B for b in B if a != b]


def is_sidon_ordered(B):
    ds = ordered_diffs(B)
    return all(d != 0 for d in ds) and len(set(ds)) == len(ds)


def is_sidon_unordered(B):
    # differences identified up to sign: class representative min(d, P - d)
    ds = ordered_diffs(B)
    classes = {min(d, P - d) for d in ds}
    return all(d != 0 for d in ds) and len(classes) == len(ds) // 2


def main():
    subsets = [
        set(c)
        for r in range(P + 1)
        for c in itertools.combinations(range(P), r)
    ]
    assert len(subsets) == 2 ** P == 32

    sidon_o = [B for B in subsets if is_sidon_ordered(B)]
    sidon_u = [B for B in subsets if is_sidon_unordered(B)]
    max_o = max(len(B) for B in sidon_o)
    max_u = max(len(B) for B in sidon_u)

    print(f"p = {P}; subsets checked: {len(subsets)}")
    print(f"[ordered]   Sidon sets: {len(sidon_o)}, max size = {max_o}")
    print(f"[unordered] Sidon sets: {len(sidon_u)}, max size = {max_u}")
    print(f"sqrt({P}) = {math.sqrt(P):.6f}")

    # Pigeonhole argument, recomputed numerically:
    # a 3-set needs 6 distinct nonzero ordered diffs, but |F_5^*| = 4.
    need_ordered = 3 * 2
    have_nonzero = P - 1
    print(f"Pigeonhole: 3-set needs {need_ordered} distinct nonzero ordered "
          f"diffs; |F_5^*| = {have_nonzero}. {need_ordered} > {have_nonzero} -> impossible.")
    # unordered: a 3-set needs 3 sign classes, F_5^*/{+-1} has (P-1)/2 = 2.
    need_classes = 3
    have_classes = (P - 1) // 2
    print(f"Unordered: 3-set needs {need_classes} sign classes; "
          f"F_5^*/{{+-1}} has {have_classes} -> impossible.")

    ok = True
    # Attaining sqrt(5) needs an integer-sized Sidon set of size >= 3.
    need_size = math.floor(math.sqrt(P)) + 1  # smallest integer >= sqrt(5) is 3
    assert need_size == 3
    if max_o >= need_size:
        print(f"FAIL: ordered reading has a Sidon set of size {max_o} >= {need_size}")
        ok = False
    if max_u >= need_size:
        print(f"FAIL: unordered reading has a Sidon set of size {max_u} >= {need_size}")
        ok = False

    if ok:
        print(f"PASS: no Sidon set of size >= {need_size} in F_5 under either reading; "
              f"the clause 'sqrt(p) is attained' is false at p = 5, "
              f"so conjecture 00000001066 is false.")
        return 0
    print("FAIL: counterexample did not reproduce.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
