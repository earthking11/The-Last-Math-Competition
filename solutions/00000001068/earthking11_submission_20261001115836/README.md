# Disproof of conjecture `00000001068`

> **由 Muse 进行计算验证提交。**（本提交的反例搜索、计算验证与 Lean 4 形式化均由 Muse 完成。）

## Verdict

**Disproved.** Conjecture `00000001068` is false at $p = 11$ (and the $p = 5$
case is degenerate: the conjectured interval is empty).

## The conjecture (verbatim)

> **English.** Definition: A sum-free set ($A + A$ disjoint from $A$).
> Conjecture: The maximal sum-free subsets of $\mathbb{F}_p$ are exactly the
> intervals $((p+1)/3,\, 2(p-1)/3)$, uniquely up to dilation (the complete
> Diananda–Yap characterization over finite fields).
>
> **中文。** 定义：sum-free 集（$A + A$ 与 $A$ 不交）。猜想：$\mathbb{F}_p$
> 的最大 sum-free 为区间 $((p+1)/3,\, 2(p-1)/3)$ 型且唯一（Diananda–Yap 有限域完全刻画）。

Source: `conjectures/00000001068.md`.

## The disproof (one paragraph)

At $p = 11$ the conjectured interval is $(4, 20/3) = \{5, 6\}$ (2 elements),
but $S = \{1, 3, 8, 10\} \subseteq \mathbb{F}_{11}$ is sum-free
($S+S = \{0,2,4,5,6,7,9\}$, disjoint from $S$), has $4 > 2$ elements, and is
maximal by inclusion (each of the 7 points outside $S$ destroys sum-freeness).
Since dilation $x \mapsto cx$ ($c \ne 0$) is a bijection of $\mathbb{F}_{11}$,
every dilation of the interval keeps 2 elements, so $S$ cannot be a dilation
of it. The AI-generated conjecture misstates the interval endpoints of the
classical Diananda–Yap characterization. (At $p = 5$ the interval is even
empty while $\{1, 4\}$ is sum-free.)

## Verification

Three independent layers, all green:

1. **`reproduce.py`** (Python 3, standard library only): recomputes the
   interval, the sum-freeness of $S$, the cardinality comparison, maximality,
   dilation invariance, and the $p = 5$ note. Run `python3 reproduce.py`
   (exit 0, all PASS).
2. **`lean4/`**: Lean 4.33.1, core Lean only (`import Std`), every theorem
   proved by `decide`. `lake build` succeeds; `lake env lean Check.lean`
   confirms no axioms (`sorryAx`-free, no `Lean.ofReduceBool`, no Mathlib).
3. **`main.tex` / `build/main.pdf`**: full write-up with the complete
   $16$-entry addition table.

## Files

| File | Contents |
|:-----|:---------|
| `main.tex` | LaTeX source of the disproof paper |
| `build/main.pdf` | compiled PDF |
| `reproduce.py` | independent computational reproduction (stdlib only) |
| `lean4/` | Lean 4 project: `Main.lean` (formalized finite checks), `Check.lean` (axiom audit), `lakefile.toml`, `lean-toolchain` (v4.33.1), `README.md` |
| `README.md` | this file |

## Status against the submission rules

Per `README.md` Rule 3 of the competition, each submission must include the
LaTeX source code, a PDF document, and a Lean 4 project — all three are
present above. The submission disproves (rather than proves) the conjecture,
which Rule 3 explicitly allows ("submissions that prove or disprove the
conjecture will be merged").
