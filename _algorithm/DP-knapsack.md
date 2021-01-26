---
title:			'动态规划: 背包问题 (一)'
description:	'summary of the most basic types of knapsack problems'

author: mooyyu
contrib:
category: [ algorithm, al-DP, needs-review ]
date: 2020-03-12
---

This article is the first in a knapsack problem series and the first in the entire dynamic programming series. Before starting the knapsack problem, let's introduce the general part of dynamic programming. For the analysis of dynamic programming problems, I use what I created and called "DRSOS".

>   DRSOS: definition - request - state trasition - optimization - solution

There are two general coding methods for dynamic programming problems: iteration and memorized search. I agree with myself this way: Use memorized search if possible, because it's intuitive; else (such as a scrolling array optimization) use iteration.

------

## 01 knapsack

$$
\begin{aligned}
definition&\\
&f(n, c)\text{ express the max weights of selecting some articles in first n to c capacity}\\
&v_i, w_i\text{ respectively express article i's volume and weights}\\
request&\\
&f(N, C)\\
state\ trasition&\\
&f(n, c) = max\{ f(n - 1, c - k\times v_n) + k\times w_n\mid k\in\{0, 1\}, k\times v_n\leqslant c \}\\
&state\ division:\quad\text{article n is selected(k = 1) or not(k = 0)}\\
optimization&\\
&\natural\quad scrolling\ array\ opt\\
solution&\\
&loop\quad n\text{ from 1 to N - 1}\\
&\hphantom{loop\quad}loop\quad c\text{ from C to 1}\\
&\hphantom{loop\quad loop\quad}if\quad v_n\leqslant c\\
&\hphantom{loop\quad loop\quad if\quad}f(c) = max\{f(c),f(c - v_n) + w_n\}\\
&if\quad v_N\leqslant C\\
&\hphantom{if\quad}f(C) = max\{f(C),f(C - v_N) + w_N\}\\
&return\quad f(C)
\end{aligned}
$$

```cpp
template< class type >
type dp(const int N, const int C) {
	for (int n = 1; n < N; n++)
		for (int c = C; c > 0; --c)
			if (ar[n].v <= c) ret[c] = max(ret[c], ret[c - ar[n].v] + ar[n].w);
	if (ar[N].v <= C) ret[C] = max(ret[C], ret[C - ar[N].v] + ar[N].w);
	return ret[C];
}
```

## complete knapsack

$$
\begin{aligned}
definition&\\
&f(n, c)\text{ express the max weights of selecting some kinds articles in first n kinds to c capacity}\\
&v_i, w_i\text{ respectively express the articles of kind i's volume and weights, quantity is infinity}\\
request&\\
&f(N, C)\\
state\ trasition&\\
&f(n, c) = max\{ f(n - 1, c - k\times v_n) + k\times w_n\mid k \geqslant 0, k\times v_n\leqslant c\}\\
&state\ division:\quad\text{the articles of kind n is selected k}\\
optimization&\\
&\natural\quad equivalent\ conversion\\
&\hphantom{\because\quad\ } when\ v_n\leqslant c\\
&\because\quad f(n, c - v_n) = max\{ f(n - 1, c - v_n - k\times v_n) + k\times w_n\mid k \geqslant 0, k\times v_n\leqslant c - v_n\}\\
&\hphantom{\because\quad f(n, c - v_n)\ } = max\{ f(n - 1, c - v_n - (k - 1)\times v_n) + (k - 1)\times w_n\mid (k - 1) \geqslant 0, (k - 1)\times v_n\leqslant c - v_n\}\\
&\hphantom{\because\quad f(n, c - v_n)\ } = max\{ f(n - 1, c - k\times v_n) + k\times w_n - w_n\mid k > 0, k\times v_n\leqslant c\}\\
&\hphantom{\because\quad f(n, c - v_n)\ } = max\{ f(n - 1, c - k\times v_n) + k\times w_n\mid k > 0, k\times v_n\leqslant c\} - w_n\\
&\therefore\quad f(n, c) = max\{ f(n - 1, c - k\times v_n) + k\times w_n\mid k \geqslant 0, k\times v_n\leqslant c\}\\
&\hphantom{\therefore\quad f(n, c)\ } = max\{ f(n - 1, c), \{ f(n - 1, c - k\times v_n) + k\times w_n\mid k > 0, k\times v_n\leqslant c\} \}\\
&\hphantom{\therefore\quad f(n, c)\ } = max\{ f(n - 1, c), f(n, c - v_n) + w_n \}\\
&\natural\quad scrolling\ array\ opt\\
solution&\\
&loop\quad n\text{ from 1 to N}\\
&\hphantom{loop\quad}loop\quad c\text{ from 1 to C}\\
&\hphantom{loop\quad loop\quad}if\quad v_n\leqslant c\\
&\hphantom{loop\quad loop\quad if\quad}f(c) = max\{ f(c), f(c - v_n) + w_n \}\\
&return\quad f(C)
\end{aligned}
$$

```cpp
template< class type >
type dp(const int N, const int C) {
	for (int n = 1; n <= N; n++)
		for (int c = 1; c <= C; c++)
			if (ar[n].v <= c) ret[c] = max(ret[c], ret[c - ar[n].v] + ar[n].w);
	return ret[C];
}
```

## multiple knapsack

$$
\begin{aligned}
definition&\\
&f(n, c)\text{ express the max weights of selecting some kinds articles in first n kinds to c capacity}\\
&v_i, w_i, q_i\text{ respectively express the articles of kind i's volume, weights and quantity}\\
request&\\
&f(N, C)\\
state\ trasition&\\
&f(n, c) = max\{ f(n - 1, c - s\times v_n) + s\times w_n\mid 0 \leqslant s\leqslant q_i, s\times v_n\leqslant c\}\\
&state\ division:\quad\text{the articles of kind n is selected s}\\
optimization&\\
&\natural\quad equivalent\ conversion\\
&\because\quad\{ s\mid 0\leqslant s\leqslant q_i \} = \{ \sum_{j = 0}^{k - 1} \alpha_j\times 2^j + \beta\times(q_i - 2^k + 1)\mid \alpha_j, \beta\in\{0, 1\}, 2^k - 1 < q_i < 2^{k + 1} \}\\
&\therefore\quad\begin{gather}
\overline{\underline{q_i\ articles(v_i, w_i)\ of\ kind\ i}}\\
equals\\
\underline{\overline{articles(v_i, w_i)\times 2^j\ and\ article(v_i, w_i)\times (q_i - 2^k + 1), 0\leqslant j\leqslant k}}
\end{gather}\\
&\natural\quad scrolling\ array\ opt\\
solution&\\
&construct\ 01\ knapsack\ first\\
&then\ reference\ the\ solution\ of\ 01\ bakcpack
\end{aligned}
$$

```cpp
int N, C;
cin >> N >> C;
ar.resize(1);
ar.reserve(maxn * ((int)log2(maxs) + 1) + 1);
for (int i = 1; i <= N; i++) {
    static int v, w, s, k, kv, kw;
    cin >> v >> w >> s;
    k = 1, kv = v, kw = w;
    while (k << 1u <= s) {
        ar.emplace_back(kv, kw);
        k<<= 1u, kv <<= 1u, kw <<= 1u;
    }
    ar.emplace_back(s * v - kv + v, s * w - kw + w);
}
printf("%d\n", dp< int >(ar.size() - 1, C));
```



## group knapsack

$$
\begin{aligned}
definition&\\
&f(n, c)\text{ express the max weights of selecting some articles in different first n kinds to c capacity}\\
&a_i\text{ express the amount of articles in group i}\\
&v_{ij}, w_{ij}\text{ respectively express the j-th article in group i's volume and weights}\\
request&\\
&f(N, C)\\
state\ trasition&\\
&f(n, c) = max\{ f(n - 1, c - k\times v_{nj}) + k\times w_{nj}\mid k\in\{0, 1\}, 0 < j\leqslant a_n, k\times v_{nj} \leqslant c \}\\
&state\ division:\quad\text{the articles in group n is unselected or selected j-th}\\
optimization&\\
&\natural\quad storage\ with\ chained\ forward\ star\\
solution&\\
&init\ ret[0][\forall c]\ with\ 0,\ and\ vised\ them\\
&load\ program\ f(n, c)\\
&if\quad !vis[n][c]\\
&\hphantom{if\quad}ret[n][c] = f(n - 1, c)\\
&\hphantom{if\quad}loop\quad j\text{ from 1 to }a_n\\
&\hphantom{if\quad loop\quad}if\quad v_{nj} \leqslant c\\
&\hphantom{if\quad loop\quad if\quad}ret[n][c] = max\{ ret[n][c], f(n - 1, c - v_{nj}) + w_{nj} \}\\
&\hphantom{if\quad}vis[n][c] = true\\
&return\quad ret[n][c]
\end{aligned}
$$



```cpp
template< class type >
type dp(const int n, const int c) {
	if (!vis[n][c]) {
		ret[n][c] = dp< type >(n - 1, c);
		for (int i = head[n]; i; i = ar[i].ptr)
			if (ar[i].v <= c)
				ret[n][c] = max(ret[n][c], dp< type >(n - 1, c - ar[i].v) + ar[i].w);
		vis[n][c] = true;
	}
	return ret[n][c];
}
```
