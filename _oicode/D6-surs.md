---
title:  树状数组-单点更新区间求和
brief:
author: mooyyu
tag:    d006surs

experimental: false
cppv:  c++11
group:  DS
requires: 

codes:  [D6]
related:
---

```cpp
class BIT {
	const int n;
	int ar[maxn + 1] {};
	inline int lowbit(int x) { return x&-x; }
	inline int prefix(int x) {
		static int ret;
		ret = 0;
		while (x) {
			ret += ar[x];
			x -= lowbit(x);
		}
		return ret;
	}
public:
	explicit BIT(const int n): n(n) {}
	void modify(int x, int c) {
		while (x <= n) {
			ar[x] += c;
			x += lowbit(x);
		}
	}
	int query(int l, int r) { return prefix(r) - prefix(l-1); }
};
```