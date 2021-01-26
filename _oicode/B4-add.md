---
title:  高精度加法
brief:
author: mooyyu
tag:    b004add

experimental: false
cppv:  c++11
group:  basic
requires: vector

codes:  [B4]
related:
---

```cpp
class integer {
	vector<char> ar;
	void carry(char &x, int &flag) {
		if (x < 10) flag = 0;
		else x -= 10, flag = 1;
	}
public:
	explicit integer(const string &s) {
		ar.resize(s.length());
		for (int i = 0, j = (int)s.length() - 1; i < ar.size(); ++i, --j) ar[i] = s[j] - '0';
	}
	integer& add(integer &tar, integer &ret) {
		static int flag;
		if (ar.size() < tar.ar.size()) return tar.add(*this, ret);
		ret.ar.resize(ar.size());
		flag = 0;
		for (int i = 0; i < tar.ar.size(); i++) {
			ret.ar[i] = ar[i] + tar.ar[i] + flag;
			carry(ret.ar[i], flag);
		}
		for (int i = tar.ar.size(); i < ar.size(); i++) {
			ret.ar[i] = ar[i] + flag;
			carry(ret.ar[i], flag);
		}
		if (flag) ret.ar.push_back(1);
		return ret;
	}
	void output() {
		for (int i = (int)ar.size() - 1; i >= 0; --i) printf("%d", ar[i]);
		putchar(10);
	}
};
```