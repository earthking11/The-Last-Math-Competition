#!/usr/bin/env python3
"""Reproduction script for the disproof of conjecture 00000008256.

Claim refuted: "the number of maximal Condorcet domains at n = 4 is exactly 7".

The script does two independent things (Python 3, standard library only):

  Part A: verify the eight explicit exhibit domains (Sen's never-condition
          test): each is a Condorcet domain, each is maximal (adding any
          outside order breaks the Condorcet property), and the eight are
          pairwise distinct.  8 != 7 -> the claim is false.

  Part B: full independent enumeration: every maximal Condorcet domain is a
          maximal-by-inclusion intersection of never-condition domains
          (9^4 = 6561 candidates).  This yields 495 maximal domains,
          cross-checked directly from the definition.

Exit code 0 iff all checks PASS.
"""
import itertools
import json
import os
import sys
import time

ALTS = (0, 1, 2, 3)
ORDERS = list(itertools.permutations(ALTS))          # 24 linear orders
O2I = {o: i for i, o in enumerate(ORDERS)}
TRIPLES = list(itertools.combinations(ALTS, 3))      # 4 triples
FULL = (1 << 24) - 1


def pos_in_triple(order, triple, alt):
    """0 = top, 1 = middle, 2 = bottom of `alt` within `triple` in `order`."""
    ranked = sorted(triple, key=lambda x: order.index(x))
    return ranked.index(alt)


def never_mask(triple, alt, pos):
    """Bitmask of orders where `alt` is NEVER at position `pos` in `triple`."""
    m = 0
    for o in ORDERS:
        if pos_in_triple(o, triple, alt) != pos:
            m |= 1 << O2I[o]
    return m


def is_condorcet(mask):
    """Sen (1966): every triple has >= 1 never-condition holding on mask."""
    for T in TRIPLES:
        ok = False
        for alt in T:
            for p in (0, 1, 2):
                if mask & ~never_mask(T, alt, p) == 0:
                    ok = True
                    break
            if ok:
                break
        if not ok:
            return False
    return True


def mask_of(strs):
    m = 0
    for s in strs:
        m |= 1 << O2I[tuple(int(c) for c in s)]
    return m


def main():
    t0 = time.time()
    here = os.path.dirname(os.path.abspath(__file__))

    # ---------------- Part A: the eight exhibits ----------------
    with open(os.path.join(here, "exhibits.json")) as f:
        exhibits = json.load(f)
    assert len(exhibits) == 8, f"expected 8 exhibits, got {len(exhibits)}"
    masks = []
    for i, ex in enumerate(exhibits):
        m = mask_of(ex["orders"])
        masks.append(m)
        if not is_condorcet(m):
            print(f"FAIL: exhibit D{i+1} is not a Condorcet domain")
            return 1
        for j in range(24):
            if not (m >> j & 1) and is_condorcet(m | (1 << j)):
                print(f"FAIL: exhibit D{i+1} not maximal (can add {ORDERS[j]})")
                return 1
    for i in range(8):
        for j in range(i + 1, 8):
            if masks[i] == masks[j]:
                print(f"FAIL: exhibits D{i+1} and D{j+1} identical")
                return 1
    print("PASS Part A: 8 explicit domains are Condorcet, maximal, pairwise "
          "distinct (8 != 7)")

    # ---------------- Part B: full enumeration ----------------
    per_triple = {T: [never_mask(T, alt, p) for alt in T for p in (0, 1, 2)]
                  for T in TRIPLES}
    seen = set()
    for choice in itertools.product(range(9), repeat=4):
        m = FULL
        for ti, T in enumerate(TRIPLES):
            m &= per_triple[T][choice[ti]]
        seen.add(m)
    lst = list(seen)
    maximals = [m for m in lst
                if not any(m != n and (m | n) == n for n in lst)]
    print(f"distinct never-condition intersections: {len(seen)}")
    print(f"maximal Condorcet domains at n=4: {len(maximals)}")
    if len(maximals) != 495:
        print(f"FAIL: expected 495 maximal domains, got {len(maximals)}")
        return 1
    for k, m in enumerate(maximals):
        if not is_condorcet(m):
            print(f"FAIL: enumerated domain {k} not Condorcet")
            return 1
        for j in range(24):
            if not (m >> j & 1) and is_condorcet(m | (1 << j)):
                print(f"FAIL: enumerated domain {k} not maximal")
                return 1
    print("PASS Part B: full enumeration gives 495 maximal Condorcet domains; "
          "all directly verified Condorcet and maximal")

    print(f"ALL CHECKS PASSED ({time.time()-t0:.1f}s): "
          f"495 maximal domains != 7 -> conjecture 00000008256 REFUTED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
