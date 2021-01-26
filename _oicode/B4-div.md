---
title:  高精度除法
brief:
author: mooyyu
tag:    b004div

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
	integer& div(type x, integer &ret, type &val) {
		static int cnt;
		ret.ar.resize(ar.size());
		val = 0, cnt = 0;
		for (int i = (int)ar.size() - 1; i >= 0; --i) {
			(val *= 10) += ar[i];
			ret.ar[i] = val / x, val %= x;
		}
		for (int i = (int)ret.ar.size() - 1; i > 0 && !ret.ar[i]; --i) ++cnt;
		ret.ar.erase(ret.ar.end() - cnt, ret.ar.end());
		return ret;
	}
	void output() {
		for (int i = (int)ar.size() - 1; i >= 0; --i) printf("%d", ar[i]);
		putchar(10);
	}
};
```
