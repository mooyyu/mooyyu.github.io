---
title:  高精度乘法
brief:
author: mooyyu
tag:    b004multi

experimental: false
cppv:  c++11
group:  basic
requires: vector,numeric

codes:  [B4]
related:
---

```cpp
class integer {
	vector<char> ar;
public:
	explicit integer(const string &s) {
		ar.resize(s.length());
		for (int i = 0, j = (int)s.length() - 1; i < ar.size(); ++i, --j) ar[i] = s[j] - '0';
	}
	template< class type >
	integer& multi(type x, integer &ret) {
		static type val;
		ret.ar.resize(ar.size());
		val = 0;
		for (int i = 0; i < ar.size(); i++) {
			val += ar[i] * x;
			ret.ar[i] = val % 10, val /= 10;
		}
		while (val) ret.ar.push_back(val % 10), val /= 10;
		return ret;
	}
	void output() {
		for (int i = (int)ar.size() - 1; i >= 0; --i) printf("%d", ar[i]);
		putchar(10);
	}
};
```