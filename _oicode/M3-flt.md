---
title:  费马小定理-乘法逆元
brief:
author: mooyyu
tag:    m003flt

experimental: false
cppv:  c++11
group:  math
requires: 

codes:  [M3]
related:  [M1]
---

```cpp
template< class type >
type inverse(type a, type p) {
  return (type)qpow(a, p - 2, p);
}
```