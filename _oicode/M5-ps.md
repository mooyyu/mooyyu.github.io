---
title:  欧拉筛-质数筛
brief:
author: mooyyu
tag:    m005ps

experimental: false
cppv:  c++11
group:  math
requires: vector,math

codes:  [M5]
related:
---

```cpp
bool ar[maxn >> 1u];
vector< int > prs;

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

### Notes

- `1～n`内素数的个数不大余`n/ln(n)*1.2` (待证明)