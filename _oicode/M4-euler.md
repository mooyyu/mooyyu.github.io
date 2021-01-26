---
title:  分解质因数-欧拉函数
brief:
author: mooyyu
tag:    m004euler

experimental: false
cppv:  c++11
group:  math
requires: unordered_map

codes:  [M4]
related:	[M4]

category:	[needs-review]
---

```cpp
template< class type >
inline int lowbit(const type x) { return -x & x; }

template< class type >
unordered_map< int, int >& pfactor(type x) {
	static int k;
	static type cur;
	static unordered_map< int, int > pfs;
	pfs.clear();
	k = lowbit(x), cur = x / k;
	while (k >>= 1u) ++pfs[2];
	for (int i = 3; i <= x / i; i += 2)
		while (cur % i == 0) ++pfs[i], cur /= i;
	if (cur > 1) ++pfs[cur];
	return pfs;
}

int phi(int x) {
	unordered_map< int, int > &ret = pfactor(x);
	for (const auto &i : ret) (x /= i.first) *= (i.first - 1);
	return x;
}
```