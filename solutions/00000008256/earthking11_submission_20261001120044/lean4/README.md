# Lean 4 formalization: disproof of conjecture 00000008256

## What is proved (`Main.lean`)

Sen's (1966) never-condition test for Condorcet domains, encoded as a
decidable Boolean function over `List Nat` orders:

- `isCondorcet D`: for every triple of alternatives, some never-condition
  (an alternative never at position 0/1/2 within the triple) holds throughout
  the domain `D`.
- `isMaximal D`: every one of the 24 linear orders of {0,1,2,3} not in `D`
  destroys the Condorcet property when added.

Eight explicit maximal Condorcet domains `D1..D8` (six of size 4, two of size
8) are hardcoded, and proved by `decide`:

| theorem | statement |
|---|---|
| `condorcet_D1..D8` | `isCondorcet D_i = true` |
| `maximal_D1..D8` | `isMaximal D_i = true` |
| `distinct_domains` | the eight domains are pairwise distinct |
| `refutation_00000008256` | all of the above jointly: 8 distinct maximal Condorcet domains at n = 4 |

## Representation

- A linear order is a 4-element `List Nat`; a domain is a `List (List Nat)`.
- Only core Lean is used (`import Std`); every theorem is proved by `decide`;
  no `sorry`, no `native_decide`.

## Axiom audit

Run `lake env lean Check.lean`. Every theorem reports
"does not depend on any axioms" — in particular no `sorryAx` and no
`Lean.ofReduceBool`.

## Scope note

The formalization refutes only the "exactly 7 maximal Condorcet domains at
n = 4" sub-claim (already enough to falsify the conjunctive conjecture); the
Fishburn bound formula and other sub-claims are not formalized here.

## Environment

- `lean-toolchain`: `leanprover/lean4:v4.33.1`
- `lakefile.toml`: project `tlmc8256`, library `Main`, no dependencies
