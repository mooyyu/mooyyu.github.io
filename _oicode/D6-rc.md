---
title:  树状数组-限定区间计数
brief:
author: mooyyu
tag:    d006rc

experimental: false
cppv:  c++11
group:  DS
requires: 

codes:  [D6]
related:

category: [needs-review]
---

```cpp
int ar[maxn];
int sum[maxn];

class BIT {
	static inline int lowbit(int x) { return x & -x; }
	inline int prefix(int x) {
		static int ret;
		ret = 0;
		while (x) {
			ret += cnt[x];
			x -= lowbit(x);
		}
		return ret;
	}
public:
	int cnt[maxh + 1];
	void modify(int x, int c) {
		while (x <= maxh) {
			cnt[x] += c;
			x += lowbit(x);
		}
	}
	int solve(int l, int r) { return prefix(r) - prefix(l - 1); }
} bit;
```

### Usage

```cpp
// typedef unsigned long long ullong;

int n;
cin >> n;
for (int i = 0; i < n; i++) {
  cin >> ar[i];
  ++ar[i];
}
for (int i = 0; i < n; i++) {
  sum[i] = bit.solve(ar[i] + 1, maxh);
  bit.modify(ar[i], 1);
}
fill(bit.cnt + 1, bit.cnt + maxh + 1, 0);
for (int i = n - 1; i >= 0; --i) {
  sum[i] += bit.solve(1, ar[i] - 1);
  bit.modify(ar[i], 1);
}
ullong ret = 0;
for (int i = 0; i < n; i++)
  ret += ((ullong)(1 + sum[i]) * sum[i]) >> 1u;
printf("%llu\n", ret);
```