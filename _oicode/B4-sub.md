---
title:  高精度减法
brief:
author: mooyyu
tag:    b004sub

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
	void borrow(char &x, int &flag) {
		if (x >= 0) flag = 0;
		else x += 10, flag = 1;
	}
public:
	explicit integer(const string &s) {
		ar.resize(s.length());
		for (int i = 0, j = (int)s.length() - 1; i < ar.size(); ++i, --j) ar[i] = s[j] - '0';
	}
	int cmp(integer &tar) {
		if (ar.size() == tar.ar.size()) {
			for (int i = (int)ar.size(); i >= 0; --i) {
				if (ar[i] < tar.ar[i]) return -1;
				else if (ar[i] > tar.ar[i]) return 1;
			}
			return 0;
		} else return ar.size() < tar.ar.size() ? -1 : 1;
	}
	integer& minus(integer &tar, integer &ret) {
		static int flag, cnt;
		ret.ar.resize(ar.size());
		flag = 0, cnt = 0;
		for (int i = 0; i < tar.ar.size(); i++) {
			ret.ar[i] = ar[i] - tar.ar[i] - flag;
			borrow(ret.ar[i], flag);
		}
		for (int i = tar.ar.size(); i < ar.size(); i++) {
			ret.ar[i] = ar[i] - flag;
			borrow(ret.ar[i], flag);
		}
		for (int i = (int)ret.ar.size() - 1; !ret.ar[i]; --i) ++cnt;
		ret.ar.erase(ret.ar.end() - cnt, ret.ar.end());
		return ret;
	}
	void output() {
		for (int i = (int)ar.size() - 1; i >= 0; --i) printf("%d", ar[i]);
		putchar(10);
	}
};
```