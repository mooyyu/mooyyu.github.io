---
title:  EX欧几里得-翡蜀定理
brief:
author: mooyyu
tag:    m002ft

experimental: false
cppv:  c++11
group:  math
requires: 

codes:  [M2]
related: [M2]
---

```cpp
template< class type >
void exgcd(type a, type b, type &x, type &y) {
	if (b) {
		exgcd(b, a % b, y, x);
		y -= a / b * x;
	} else x = 1, y = 0;	// 令y = 0防止多组数据溢出
}
```