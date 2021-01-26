---
title:  EX欧几里得-线性同余方程
brief:
author: mooyyu
tag:    m002lce

experimental: false
cppv:  c++11
group:  math
requires: 

codes:  [M2]
related: [M2]
---

```cpp
typedef long long llong;

template< class type >
type exgcd(type a, type b, type &x, type &y) {
	static type d;
	if (b) {
		d = exgcd(b, a % b, y, x);
		y -= a / b * x;
		return d;
	} else {
		x = 1, y = 0;
		return a;
	}
}
```