# Disproof of conjecture 00000008256

> **由 Muse 进行计算验证提交** — 本次提交的反例搜索、计算验证与形式化包装均由 Muse 自动完成。

## Verdict

**REFUTED.** The conjecture's "four-alternative seven-domain law" — the claim that
the number of maximal Condorcet domains at n = 4 is exactly 7 — is false.
Independent enumeration finds **495** maximal Condorcet domains (31 isomorphism
classes under the S4 relabelling action), and eight of them are exhibited
explicitly below.

## The conjecture (verbatim)

**English.** "Definition: The maximal subdomains of the Condorcet domain for
voting paradoxes: the maximal preference domains cond_max admitting Condorcet
winners. Conjecture: The size of cond_max (a maximal Condorcet domain) is at
most the Fishburn type explicit bound 2^{n-1} (n!)/2^{n(n-1)/2} (a Fishburn
bound formula); the tightness of the bound (domains attaining it) is given by
white-list domains (a white-list tight domain law); the count of maximal
domains (the number of maximal domains at n = 4) is exactly 7 (a
four-alternative seven-domain law); and the permutation-symmetric maximization
structure of maximal domains is characterized by the lattice of separable
preferences (a separable lattice characterization law). (Condorcet Fishburn
bound seven maximal domains)"

**中文。** "定义：投票悖论的 Condorcet 域的极大子域：允许 Condorcet 赢家的极大
偏好域 cond_max。猜想：cond_max（极大 Condorcet 域的规模）≤ 2^{n-1}·(n!)/2^{n(n-1)/2}
的 Fishburn 型显式上界（Fishburn 上界公式）；且上界的紧性（达到上界的域）
为白名单域（white list 紧域律）；极大域的计数（n=4 的极大域的个数）恰为 7
（四选择七域律）；域的排列对称的极大化的结构由可分偏好（separable）的格刻画
（可分格刻画律）。"

## How it was disproved

1. **Method (Sen 1966).** A domain of linear orders on {0,1,2,3} is a Condorcet
   domain iff every triple of alternatives admits a never-condition
   (some alternative never top / never middle / never bottom within the triple)
   holding throughout the domain.
2. **Enumeration.** Every maximal Condorcet domain is a maximal-by-inclusion
   intersection of never-condition domains: 9^4 = 6561 candidates → 3604
   distinct intersections → 495 maximal domains. Each of the 495 is re-verified
   directly from the definition (Condorcet + true maximality: adding any
   outside order destroys the Condorcet property).
3. **Sanity checks.** The same program recovers the known count of 9 maximal
   domains at n = 3, and correctly classifies a Condorcet cycle triple as
   non-Condorcet and a single-peaked domain as Condorcet.
4. **Eight explicit exhibits** (orders written as strings, e.g. `0312` means
   0 ≻ 3 ≻ 1 ≻ 2; see `exhibits.json`):
   - six domains of size 4: `0312,1023,2130,3201`; `0231,1320,2103,3012`;
     `0213,1032,2301,3120`; `0321,1230,2013,3102`; `0132,1203,2310,3021`;
     `0123,1302,2031,3210`
   - two domains of size 8: `2103,2130,2301,2310,3102,3120,3201,3210`;
     `0132,0231,0312,0321,2031,3012,3021,3102`

## Caveats / scope

- Only the "exactly 7" count sub-claim is refuted; the Fishburn bound formula,
  white-list tightness law, and separable-lattice characterization are not
  attacked here. (In passing: the stated Fishburn formula evaluates to 3 at
  n = 4, while the ordinary single-peaked domain already has 8 orders — see the
  paper for this remark, not a refutation claim.)
- Literature counts (e.g. 18) match neither our total (495) nor our S4-orbit
  count (31); they presumably count a subclass or use a coarser equivalence.
  Under any of 495 / 31 / 18, "exactly 7" is false.

## Files

| File | Description |
|---|---|
| `main.tex` | LaTeX source of the disproof paper |
| `build/main.pdf` | Compiled PDF |
| `reproduce.py` | Independent re-verification (stdlib only), exit 0 on success |
| `exhibits.json` | The eight explicit exhibit domains, machine-readable |
| `lean4/` | Lean 4 project (core Lean, `import Std`, all `decide`, axiom-free) |
| `lean4/Main.lean` | Formalization: Sen's test + eight exhibits + maximality + distinctness |
| `lean4/Check.lean` | `#print axioms` audit of every theorem |

## Reproduce

```bash
python3 reproduce.py            # ~30 s, prints PASS/FAIL, exit 0 on success
cd lean4
lake build                      # builds Main
lake env lean Check.lean        # axiom audit: every theorem axiom-free
cd ..
pdflatex -output-directory=build main.tex   # rebuild the PDF (twice for refs)
```

## Status against the submission rules

Per `README.md` Rule 3 of The-Last-Math-Competition:
- [x] Submitted as a PR placed in the folder with the corresponding number
      (`./solutions/00000008256/earthking11_submission_20261001120044`)
- [x] Includes the LaTeX source code (`main.tex`)
- [x] Includes a PDF document (`build/main.pdf`)
- [x] Includes a Lean 4 project (`lean4/`, toolchain pinned to
      `leanprover/lean4:v4.33.1`)
