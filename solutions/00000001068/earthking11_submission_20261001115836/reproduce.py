#!/usr/bin/env python3
"""Reproduce the disproof of conjecture 00000001068.

Independently recomputes, from scratch and with the standard library only:
  1. the conjecture's interval at p = 11 (exact rational comparison),
  2. that S = {1,3,8,10} is sum-free in F_11,
  3. that |S| = 4 > 2 = |interval|,
  4. that S is maximal by inclusion,
  5. that every nonzero dilation of the interval keeps 2 elements,
  6. the p = 5 side note (empty interval, {1,4} sum-free).

Prints PASS/FAIL per check; exits nonzero on any failure.
"""

from fractions import Fraction

PASS = True


def check(name, cond):
    global PASS
    print(("PASS" if cond else "FAIL"), "-", name)
    if not cond:
        PASS = False


def interval(p):
    """Integer representatives 1..p-1 strictly inside ((p+1)/3, 2(p-1)/3)."""
    lo = Fraction(p + 1, 3)
    hi = Fraction(2 * (p - 1), 3)
    return [x for x in range(1, p) if lo < x < hi]


def is_sum_free(S, p):
    S = set(S)
    return not any((a + b) % p in S for a in S for b in S)


def main():
    # 1. interval at p = 11
    I = interval(11)
    print("interval(11) =", I)
    check("interval at p=11 is exactly {5,6}", I == [5, 6])

    # 2. S sum-free in F_11
    S = [1, 3, 8, 10]
    sums = sorted({(a + b) % 11 for a in S for b in S})
    print("S+S mod 11 =", sums)
    check("S = {1,3,8,10} sum-free in F_11", is_sum_free(S, 11))

    # 3. cardinality
    check("|S| = 4 > 2 = |interval|", len(S) == 4 and len(I) == 2 and len(S) > len(I))

    # 4. maximal by inclusion
    outside = [x for x in range(11) if x not in S]
    maximal = all(not is_sum_free([x] + S, 11) for x in outside)
    check("S maximal by inclusion (7 extensions all fail)", maximal)

    # 5. dilations of the interval keep 2 elements
    dil_ok = all(len({(c * x) % 11 for x in I}) == 2 for c in range(1, 11))
    check("every nonzero dilation of interval has 2 elements", dil_ok)

    # 6. p = 5 side note
    I5 = interval(5)
    print("interval(5) =", I5)
    check("interval at p=5 is empty", I5 == [])
    check("{1,4} sum-free in F_5", is_sum_free([1, 4], 5))

    # sanity: the tester is not vacuous
    check("sanity: [1,2] not sum-free in F_11", not is_sum_free([1, 2], 11))

    print()
    print("ALL CHECKS PASSED" if PASS else "SOME CHECKS FAILED")
    raise SystemExit(0 if PASS else 1)


if __name__ == "__main__":
    main()
