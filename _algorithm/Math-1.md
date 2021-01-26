---
title:			算法竞赛简单数论知识(一)
description:	'从编程的角度简单了解数论原理并以代码实现系列一'

author: mooyyu
contrib:
category: [ algorithm, al-math ]
date: 2020-03-07
---

在算法竞赛中常常用到一些简单的数论知识，原理通常并不复杂，但若想要灵活运用，理解其原理，能够准确地使用代码实现则是基础中的基础。本文对一些原理做一些简单的证明，对算法给出核心实现的伪代码并使用c++示范代码实现细节的避错与优化。

------

## 本文的主要内容

- 算数基本定理
  - 分解质因数
- 约数
  - 试除法求一个数的所有约数
  - 最大公约数
    - 欧几里得算法
    - Stein算法
  - 约数个数
  - 约数之和
- 质数
  - 试除法判定质数
  - 质数计数函数
  - 质数筛
    - 埃氏质数筛
    - 欧拉质数筛
- 欧拉函数
  - 欧拉函数筛
- 欧拉定理与费马小定理
- 裴蜀/贝祖定理与扩展欧几里得算法
- 同余
  - 线性同余方程
  - 乘法逆元

## 算数基本定理

算数基本定理也叫正整数唯一分解定理。可以说是数论的一块基石，用处很广泛。

> 任何大于$$1$$的自然数$$n$$可以被唯一分解为质数幂次的乘积。
>
> 表示为$$n = \textstyle\prod_{i = 1}^s {p_i}^{k_i} \mid n > 1, n \in \mathbb{N}$$

这个等式即是对$$n$$的质因数分解，并且满足以下性质

- 该分解有序唯一，任意一个确定的$$n$$可以得到一个确定的质因数分解，任意一组分解得到质因数可以确定一个数
- $$n$$至多有一个大于$$\sqrt n$$的质因子，此性质可用于优化分解质因数的实现

### 分解质因数

分解质因数是对算数基本定理的直接运用。伪代码如下

$$
\begin{aligned}
&k_{p_i = 2} = log_2 lowbit(n)\newline
&cur = \textstyle\frac n{lowbit(n)}\newline
&for\quad p_i = 3; p_i \leqslant \lfloor \textstyle\frac{cur}{p_i}\rfloor; p_i = p_i + 2\newline
&\hphantom{for\quad}k_i = 0\newline
&\hphantom{for\quad}while\quad p_i\mid cur\newline
&\hphantom{for\quad while\quad}k_i = k_i + 1\newline
&\hphantom{for\quad while\quad}cur = \textstyle\frac{cur}{p_i}\newline
&if\quad cur > 1\newline
&\hphantom{if\quad}k_{p_i = cur} = 1
\end{aligned}
$$

使用的优化

- 对大于$$\sqrt n$$的那一个质因子做特判
- 使用动态的$$cur$$代替$$n$$，每次找到的质因子都是当前$$cur$$的最小质因子，因为任意一个$$cur$$的质因子集合可以分解为$$cur$$的最小值因子$$p_i^{k_i}$$加上$$\frac{cur}{p_i^{k_i}}$$的质因子集合，并且查找范围不断缩小
- 是偶数的质数只有$$2$$，可以使用$$lowbit$$[^lowbit]特判，然后在奇数中查找质因子

具体实现代码如下

```cpp
template< class type >
map< int, int >& pfactor(type x) {
	static int k;
	static type cur;
	static map< int, int > pfs;
	pfs.clear();
	k = lowbit(x), cur = x / k;
	while (k >>= 1u) ++pfs[2];
	for (int i = 3; i <= cur / i; i += 2)
		while (cur % i == 0) ++pfs[i], cur /= i;
	if (cur > 1) ++pfs[cur];
	return pfs;
}
```

## 约数

> 若$$d$$能整除$$x$$，则称$$d$$是$$x$$的一个约数

### 试除法求一个数的所有约数

$$
\begin{aligned}
&for\quad l = 1; r = \textstyle\frac xl, l < r; l = l + 1\newline
&\hphantom{for\quad}if\quad l \mid r\newline
&\hphantom{for\quad if\quad}get\ l, r\newline
&if\quad l \mid x \enspace\&\&\enspace l\ equal\ r\newline
&\hphantom{if\quad}get\ \sqrt x
\end{aligned}
$$

使用的优化

- 若$$d$$是$$x$$的约数，则$$\frac xd$$也一定是$$x$$的约数

```cpp
vector< int >& divs(const int x) {
	static vector< int > ret;
	static int l, r;
	ret.clear(), ret.reserve(maxn);
	for (l = 1; l < (r = x / l); l++)
		if (x % l == 0) {
			ret.push_back(l);
			ret.push_back(r);
		}
	if (x % l == 0 && l == r) ret.push_back(l);
	sort(ret.begin(), ret.end());
	return ret;
}
```

### 最大公约数

> $$gcd(a, b)$$b表示$$a, b$$的最大公约数

满足的性质如下

- $$gcd(ka, kb) = k \times gcd(a, b)$$，令$$k = 2$$可以解释两偶数的最大公约数仍是偶数
- 若$$k \nmid b$$，则$$gcd(ka, b) = gcd(a, b)$$

#### 欧几里得算法

欧几里得算法即我们熟知的辗转相除法
$$
gcd(a, b) = \begin{cases}
a,&b = 0\newline
gcd(b, a\ mod\ b),&b\not = 0
\end{cases}
$$

```cpp
template< class type >
type gcd(type a, type b) { return b ? gcd(b, a % b) : a; }
```

#### Stein算法

Stein算法即是以辗转相减法为基础，利用上文提到的两个性质进行优化，整个算法仅涉及到加减法和移位操作，该算法对于大素数很有优势

$$
gcd(a, b) = \begin{cases}
gcd(\frac a2, \frac b2)\times 2,&2\mid a,\ 2\mid b\newline
gcd(\frac a2, b),&2\mid a,\ 2\nmid b\newline
gcd(a, \frac b2),&2\nmid a,\ 2\mid b\newline
gcd(b, a),&2\nmid a,\ 2\nmid b,\ a < b\newline
gcd(\frac{a - b}2, b),&2\nmid a,\ 2\nmid b,\ a \geqslant b\newline
a,&b = 0
\end{cases}
$$

```cpp
template< class type >
type stein(type a, type b) {
	unsigned c = 0;
	while (~a & 1u && ~b & 1u) a >>= 1u, b >>= 1u, ++c;
	while (~b & 1u) b >>= 1u;
	do {
		while (~a & 1u) a >>= 1u;
		if (a < b) swap(a, b);
	} while ((a = a - b >> 1u));
	return b << c;
}
```

### 约数个数

> $$cnt = \textstyle\prod_{i = 1}^s(k_i + 1)$$，参数意义参考算数基本定理

证明如下

$$
\begin{aligned}
\because\quad&n = \textstyle\prod_{i = 1}^s{p_i}^{k_i}\newline
\therefore\quad&\forall x = \textstyle\prod_{i = 1}^s{p_i}^{\alpha_i}，其中x\mid n,\ 0\leqslant\alpha_i\leqslant k_i\newline
又\because\quad&任意一个正整数可以被唯一分解\newline
\therefore\quad&任意一个n分解式可以唯一确定n的一个约数x\newline
又\because\quad&分解式\textstyle\prod_{i = 1}^s(k_i + 1)中组合方式\newline
\therefore\quad&cnt= \textstyle\prod_{i = 1}^s{k_i + 1}
\end{aligned}
$$

利用对n分解质因数的结果来求解约数个数很容易

$$
\begin{aligned}
&get\ map<p_i,\ k_i>\ by\ pfactor\quad //\ unordered\ is\ ok\newline
&ret = 1\newline
&loop\quad k_i\ in\ map<p_i,\ k_i>\newline
&\hphantom{loop\quad}ret = ret\times(k_i + 1)\newline
&return\quad ret
\end{aligned}
$$

### 约数之和

> $$sum = \displaystyle\prod_{i = 1}^s\textstyle\sum_{\alpha_i = 0}^{k_i}{p_i}^{\alpha_i}$$

该等式的证明很简单，将其展开即得到了所有的约数

$$
sum = ({p_1}^0 + {p_1}^1 + \cdots + {p_1}^{k_1}) \times ({p_2}^0 + {p_2}^1 + \cdots + {p_2}^{k_2}) \times ({p_s}^0 + {p_s}^1 + \cdots + {p_s}^{k_s})
$$

伪代码如下

$$
\begin{aligned}
&get\ map<p_i,\ k_i>\ by\ pfactor\quad//\ unordered\ is\ ok\newline
&ret = 1\newline
&loop\quad <p_i,\ k_i>\ in\ map<p_i,\ k_i>\newline
&\hphantom{loop\quad}t = 1\newline
&\hphantom{loop\quad}loop\quad k_i\ times\newline
&\hphantom{loop\quad loop\quad}t = t \times p_i + 1\newline
&\hphantom{loop\quad}ret = ret\times t\newline
&return\quad ret
\end{aligned}
$$

很明显关键在于对$$\sum_{\alpha_i = 0}^{k_i}{p_i}^{\alpha_i}$$能够快速求解，在数值较小时可以使用上面的秦九韶算法，当数值极大时可以使用下面两种方法。

方法一：递归

-   当$$k_i$$为奇数时，共有$$k_i + 1$$(偶数)项

$$
\def\p{ {p_i} }
\def\lrk{\frac{k_i + 1}2}
\textstyle\begin{aligned}
f(p_i, k_i) = \sum_{\alpha_i = 0}^{k_i}\p^{\alpha_i} &= \p^0 + \p^1 + \cdots + \p^{k_i}\newline
&= (\p^0 + \p^1 + \cdots + \p^{\lrk - 1}) + (\p^{\lrk} + \p^{\lrk + 1} + \cdots + \p^{k_i})\newline
&= (\p^0 + \p^1 + \cdots + \p^{\lrk - 1}) + \p^{\lrk}\cdot (\p^0 + \p^1 + \cdots + \p^{\lrk - 1})\newline
&= (1 + \p^{\lrk}) \cdot (\p^0 + \p^1 + \cdots + \p^{\lrk - 1})\newline
&= (1 + \p^{\lrk}) \cdot f(p_i, \textstyle\lrk - 1)
\end{aligned}
$$

-   当$$k_i$$为偶数时

$$
\def\p{ {p_i} }
\begin{aligned}
f(p_i, k_i) &= \p^0 + \p \cdot (\p^0 + \p^1 + \cdots + \p^{k_i - 1})\newline
&= 1 + \p \cdot (1 + \p^{\frac{k_i}2}) \cdot f(\p, \textstyle\frac{k_i}2 - 1)
\end{aligned}
$$

方法二：公式

$$
\begin{aligned}
\sum_{\alpha_i = 0}^{k_i}{p_i}^{\alpha_i} &= \frac{ {p_i}^{k_i + 1} - 1}{p_i - 1}\newline
&= ({p_i}^{k_i + 1} - 1) \cdot (p_i - 1)^{-1}
\end{aligned}
$$

注意：*由于是对特别大的数进行操作，一定是需要取模的，所以需要将除法转化为乘法逆元（下文）的计算，配合快速幂进行求解。*

## 质数

> 对于大于$$2$$的自然数，若其因子只有$$1$$和自身，则该数为质数

### 试除法判定质数

$$
\begin{aligned}
&if\quad x\leqslant 2\newline
&\hphantom{if\quad}return\quad x\ equal\ 2\newline
&if\quad 2\mid x\newline
&\hphantom{if\quad}return\quad false\newline
&for\quad i = 3, mid = \sqrt x; i\leqslant mid; i = i + 2\newline
&\hphantom{for\quad}if\quad i\mid x\newline
&\hphantom{for\quad if\quad}return\quad false\newline
&return\quad true
\end{aligned}
$$

```cpp
template< class type >
bool prime(type x) {
	if (x <= 2) return x == 2;
	if (~x & 1u) return false;
	for (type i = 3, mid = sqrt(x); i <= mid; i += 2)
		if (x % i == 0) return false;
	return true;
}
```

### 质数计数函数

> $$\pi(x)$$表示不大于$$x$$的质数的个数

满足性质$$\displaystyle\lim_{x\rightarrow \inf}\pi(x) = \frac x{\ln x}$$
- 经验: $$\forall x,\ \pi(x)\leqslant\lfloor \frac x{\ln x} \times 1.2\rfloor$$

### 质数筛

这里先说一下**奇数筛[^odd_sieve]**的概念，这个名字以及做法是我自己思考得到的，不知道之前有没有人想到和使用过。由于除了$$2$$以外的所有质数都是奇数，所以可以先特判$$2$$，然后在奇数中筛选质数，下面两个质数筛使用了**奇数质数筛**来实现。后面的欧拉函数筛也运用了奇数筛，后文详细说明。

#### 埃氏质数筛

埃氏筛的思想简单易懂：可以用一个数筛掉所有能被该数整除的数。

$$
\begin{aligned}
&if\quad n < 2\newline
&\hphantom{if\quad}return\quad 0\newline
&ret = \lfloor \frac{n + 1}2 \rfloor\newline
&for\quad base = 3; base \leqslant \lfloor \frac n3\rfloor; base = base + 2\newline
&\hphantom{for\quad}if\quad !ar[\lfloor\frac{base}2\rfloor]\newline
&\hphantom{for\quad if\quad}for\quad k = base\times 3; k \leqslant n; k = k + base\times2\newline
&\hphantom{for\quad if\quad for\quad}if\quad !ar[\lfloor \frac k2\rfloor]\newline
&\hphantom{for\quad if\quad for\quad if\quad}ar[\lfloor \frac k2\rfloor] = true\newline
&\hphantom{for\quad if\quad for\quad if\quad}ret = ret - 1\newline
&return\quad ret
\end{aligned}
$$

```cpp
int eratos(const int n) {
	if (n < 2) return 0;
	int ret = (n + 1) >> 1u;
	for (int base = 3, des = n / 3; base <= des; base += 2)
		if (!ar[base >> 1u])
			for (int k = base * 3, step = base << 1u; k <= n; k += step)
				if (!ar[k >> 1u]) ar[k >> 1u] = true, --ret;
	return ret;
}
```

#### 欧拉质数筛

欧拉筛是线性的，因为其保证了每个合数仅被其最小质因子筛掉一次。

$$
\begin{aligned}
&vector\ prs\ reserve\ \lfloor \frac n{\ln n}\times 1.2 \rfloor\newline
&if\quad n < 2\newline
&\hphantom{if\quad}return\quad 0\newline
&for\quad i = 3; i\leqslant n; i = i + 2\newline
&\hphantom{for\quad}if\quad !ar[\lfloor \frac i2 \rfloor]\newline
&\hphantom{for\quad if\quad}prs\ push\ back\ i\newline
&\hphantom{for\quad}loop\quad p_j\ in\ prs\ when\ p_j\leqslant \lfloor\frac ni \rfloor\newline
&\hphantom{for\quad loop\quad}ar[\lfloor\frac{p_j\times i}2\rfloor] = true\newline
&\hphantom{for\quad loop\quad}if\quad p_j\mid i\newline
&\hphantom{for\quad loop\quad if\quad}break\newline
&return\quad 1 + the\ size\ of\ prs
\end{aligned}
$$

>   欧拉筛是如何保证每个合数仅被其最小质因子筛掉一次的呢？
>
>   关键在于筛合数过程的中断条件是$$p_j\mid i$$，因为满足该条件的$$p_j$$也一定满足$$p_j\mid (p_{j + k}\times i), k\in \mathbb{Z}^+$$。

```cpp
int euler(const int n) {
	prs.reserve(n / log(n) * 1.2);
	if (n < 2) return 0;
	for (int i = 3; i <= n; i += 2) {
		if (!ar[i >> 1u]) prs.push_back(i);
		for (int j = 0, des = n / i; prs[j] <= des; j++) {
			ar[prs[j] * i >> 1u] = true;
			if (i % prs[j] == 0) break;
		}
	}
	return prs.size() + 1;
}
```

## 欧拉函数

>   $$\varphi(n)$$表示不大于$$n$$且和$$n$$互质的正整数的个数

对于欧拉函数的值的表达不做严格的证明，而是用“自证明”以便于理解

$$
\begin{aligned}
\varphi(n)&= \varphi(\textstyle\prod_{i = 1}^s p_i^{k_i})\newline
&= \textstyle\prod_{i = 1}^s\varphi(p_i^{k_i})\newline
&= \textstyle\prod_{i = 1}^s(p_i^{k_i - 1}\times (p_i - 1))\newline
&= \textstyle\prod_{i = 1}^s(p_i^{k_i}\times \frac{p_i - 1}{p_i})\newline
&= n\times\textstyle\prod_{i = 1}^s\frac{p_i - 1}{p_i}
\end{aligned}
$$

>   这里用到了以下性质
>
>   -   $$s = 1$$，即$$n = p^k$$时，$$\varphi(n) = p^{k - 1}\times(p - 1) = p^k - p^{k - 1}$$
>   -   欧拉函数是积性函数，即若$$a\nmid b$$，则$$\varphi(a\times b) = \varphi(a)\times\varphi(b)$$

此外，欧拉函数还有其他重要的性质，其中显而易见的一个是

-   当$$n$$为质数时，$$\varphi(n) = n - 1$$

至此，利用这些性质和算数基本定理可以来求解欧拉函数的值了

$$
\begin{aligned}
&get\ map<p_i, k_i>\ by\ pfactor\quad\text{//unordered is ok}\newline
&ret = n\newline
&loop\quad p_i\ in\ map<p_i, k_i>\newline
&\hphantom{loop\quad}ret = \frac{ret\times(p_i - 1)}{p_i}\newline
&return\quad ret
\end{aligned}
$$

### 欧拉函数筛

原理如下

$$
\begin{aligned}
当n为质数&\newline
&\varphi(n) = n - 1\newline
当n为合数&\newline
&设p_{min}是n的最小质因子，则在欧拉筛中被p_{min}\times\frac n{p_{min}}筛掉\newline
&if\quad p_{min}\nmid \frac n{p_{min}}\newline
&\hphantom{if\quad}\because\quad 欧拉函数是积性函数\newline
&\hphantom{if\quad}\therefore\quad \varphi(n) = \varphi(p_{min})\times\varphi(\frac n{p_{min}})\newline
&\hphantom{if\quad\therefore\quad\varphi(n)} = (p_{min} - 1)\times\varphi(\frac n{p_{min}})\newline
&else\ (即p_{min}\mid \frac n{p_{min}})\newline
&\hphantom{if\quad}\because\quad \frac n{p_{min}}与n的质因子集合相同\newline
&\hphantom{if\quad}\therefore\quad\varphi(n) = n\times\prod_{i = 1}^s \frac{p_i - 1}{p_i}\newline
&\hphantom{if\quad\therefore\quad\varphi(n)}= p_{min}\times \frac n{p_{min}}\times\prod_{i = 1}^s\frac{p_i - 1}{p_i}\newline
&\hphantom{if\quad\therefore\quad\varphi(n)}= p_{min}\times\varphi(\frac n{p_{min}})
\end{aligned}
$$

在具体的实现上我依旧使用**奇数筛**，这是我根据无意中发现的欧拉函数的另一个性质经过思考得到的方法，目前没有发现网络上流传有类似做法。该性质表示为

$$\varphi(2n) = \begin{cases}\varphi(n),&2\nmid n\newline2\times\varphi(n),即\varphi(\frac n{lowbit(n)})\times\frac{lowbit(n)}2,&2\mid n\end{cases}$$

核心过程如下

$$
\begin{aligned}
&vector\ prs\ reserve\ \lfloor \frac n{\ln n}\times 1.2 \rfloor\newline
&phi[\lfloor\frac 12\rfloor] = 1\newline
&for\quad i = 3; i\leqslant n; i = i + 2\newline
&\hphantom{for\quad}if\quad !ar[\lfloor\frac i2\rfloor]\newline
&\hphantom{for\quad if\quad}prs\ push\ back\ i\newline
&\hphantom{for\quad if\quad}phi[\lfloor \frac i2\rfloor] = i - 1\newline
&\hphantom{for\quad}loop\quad p_j\ in\ prs\ when\ p_j\leqslant\lfloor\frac ni\rfloor\newline
&\hphantom{for\quad loop\quad}ar[\lfloor\frac{p_j\times i}2\rfloor] = true\newline
&\hphantom{for\quad loop\quad}if\quad p_j\mid i\newline
&\hphantom{for\quad loop\quad if\quad}phi[\lfloor\frac{p_j\times i}2\rfloor] = p_j\times phi[\lfloor\frac i2\rfloor]\newline
&\hphantom{for\quad loop\quad if\quad}break\newline
&\hphantom{for\quad loop\quad}else\newline
&\hphantom{for\quad loop\quad if\quad}phi[\lfloor\frac{p_j\times i}2\rfloor] = phi[\lfloor\frac{p_j}2\rfloor]\times phi[\lfloor\frac i2\rfloor]
\end{aligned}
$$

```cpp
void sieve(const int n) {
	prs.reserve(n / log(n) * 1.2);
	phi[1 >> 1u] = 1;
	for (int i = 3; i <= n; i += 2) {
		if (!ar[i >> 1u]) {
			prs.push_back(i);
			phi[i >> 1u] = i - 1;
		}
		for (int j = 0, des = n / i, k; prs[j] <= des; j++) {
			ar[k = (prs[j] * i >> 1u)] = true;
			if (i % prs[j] == 0) {
				phi[k] = prs[j] * phi[i >> 1u];
				break;
			} else phi[k] = phi[prs[j] >> 1u] * phi[i >> 1u];
		}
	}
}

int euler(const int n) {
	if (n & 1u) return phi[n >> 1u];
	else return phi[n / lowbit(n) >> 1u] * lowbit(n) >> 1u;
}
```

## 欧拉定理与费马小定理

### 欧拉定理

>   若$$a\nmid p$$，则$$a^{\varphi(p)}\equiv 1\pmod p$$

### 费马小定理

对于欧拉定理，当$$p$$为质数时，即特化为费马小定理

>   若$$a\nmid p$$且$$p$$为质数，则$$a^{p - 1}\equiv 1\pmod p$$，即 $$a^p\equiv a\pmod p$$

## 裴蜀/贝祖定理与扩展欧几里得算法

### 裴蜀/贝祖定理

>   对于$$\forall a, b \in \mathbb{Z^+}, \exists x, y \in \mathbb{Z}$$使得$$ax + by = gcd(a, b)$$

### 扩展欧几里得算法

扩展欧几里得算法就是用于求解形如裴蜀定理的问题，其核心思想如下

$$
\begin{aligned}
&load\ program\ exgcd(a, b, x, y)\newline
&if\quad b\ equal\ 0\newline
&\hphantom{if\quad}exist gcd(a, b) = a\newline
&\hphantom{if\quad}get\ ax + 0y = gcd(a, 0)\newline
&\hphantom{if\quad}obtain\quad x = 1\newline
&else\newline
&\hphantom{if\quad}gcd(a, b) = gcd(b, a\ mod\ b)\newline
&\hphantom{if\quad gcd(a, b)}= gcd(b, a - \lfloor \frac ab\rfloor\cdot b)\newline
&\hphantom{if\quad}get\ by + (a - \lfloor \frac ab\rfloor\cdot b)\cdot x = gcd(a, b)\newline
&\hphantom{if\quad}get\ ax + b\cdot (y - \lfloor \frac ab\rfloor\cdot x) = gcd(a, b)\newline
&\hphantom{if\quad}perform\ recursion\ exgcd(b, a\ mod\ b, y, x)\newline
&\hphantom{if\quad}obtain\quad x = x, y = y - \lfloor \frac ab\rfloor
\end{aligned}
$$

```cpp
template< class type >
void exgcd(type a, type b, type &x, type &y) {
	if (b) {
		exgcd(b, a % b, y, x);
		y -= a / b * x;
	} else x = 1, y = 0;	// 令y = 0防止多组数据溢出
}
```

>   Tips：若$$a$$为负数，则将问题转化为$$\mid a\mid\cdot(-x) + by = gcd(\mid a\mid, b)$$，$$b$$为负数同理

## 同余

### 线性同余方程

>   形如$$ax + by = c$$，即$$ax\equiv c \pmod b$$的一次方程为线性同余方程
>
>   若$$gcd(a, b)\mid c$$，则$$x$$有整数解

利用扩展欧几里得算法求解的原理如下

$$
\begin{gathered}
由扩展欧几里得算法求解翡蜀定理得到x'使得\newline
ax' \equiv gcd(a, b)\pmod b\newline
对于\quad ax\equiv c\pmod b\quad的整数解\newline
有充要条件\quad gcd(a, b)\mid c\newline
则得到一个解\quad x_0 = \frac{c\cdot x'}{gcd(a, b)}\newline
任意解\quad x = \frac{c\cdot x' + k\cdot b}{gcd(a, b)}, k\in\mathbb{Z}
\end{gathered}
$$

### 乘法逆元

>   对于线性同余方程$$ax\equiv c\pmod b$$，当$$c = 1$$时，$$x$$的解即为$$a\ mod\ b$$的乘法逆元，记做$$a^{-1}$$

乘法逆元有解的条件

$$
\begin{aligned}
\because\quad&线性同余方程有解的条件是\quad gcd(a, b)\mid c\newline
又\because\quad&特化为乘法逆元要求\quad c = 1\newline
\therefore\quad&gcd(a, b) = 1,\quad即\quad a\nmid b\quad 为乘法逆元有解的条件
\end{aligned}
$$

扩展欧几里得算法同样适用求解乘法逆元，特殊的，当$$p$$为质数时，可以使用快速幂求解，原理如下

$$
\begin{aligned}
\because\quad&乘法逆元满足&a\cdot a^{-1}&\equiv 1&\pmod p\newline
又\because\quad&费马小定理&a^{p - 1}&\equiv 1&\pmod p\newline
&即&a\cdot a^{-2}&\equiv 1&\pmod p\newline
\therefore\quad&&a^{-1}&\equiv a^{p - 2}&\pmod p
\end{aligned}
$$

[^lowbit]: 一个有关二进制的函数，返回$$-x \& x$$，也即$$(\sim x + 1) \& x$$，其返回值是$$2$$的“$$x$$在二进制表示下末尾$$0$$的个数”次方。
[^odd_sieve]: 对于一个数组，每一个奇数$$x$$可以唯一地映射到下标为$$\lfloor \frac x2\rfloor$$的元素。