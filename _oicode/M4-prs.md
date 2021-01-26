---
title:  分解质因数-多数乘积约数求和
brief:
author: mooyyu
tag:    m004prs

experimental: false
cppv:  c++11
group:  math
requires: unordered_map

codes:  [M4]
related:
---

```cpp
typedef long long llong;

static unordered_map< int, int > pfs;
const int mod = 1e9 + 7;

template< class type >
inline int lowbit(const type x) { return -x & x; }

template< class type >
void pfactor(type x) {
	static int k;
	static type cur;
	k = lowbit(x), cur = x / k;
	while (k >>= 1u) ++pfs[2];
	for (int i = 3; i <= x / i; i += 2)
		while (cur % i == 0) ++pfs[i], cur /= i;
	if (cur > 1) ++pfs[cur];
}

llong sumdivs(const int x) {
	llong ret = 1;
	for (const auto &pf : pfs) {
		static llong t;
		t = 1;
		for (int i = 0; i < pf.second; i++) t = (t * pf.first + 1) % mod;
		(ret *= t) %= mod;
	}
	return ret;
}
```