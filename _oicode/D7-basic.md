---
title:  线段树-基础
brief:
author: mooyyu
tag:    d007basic

experimental: false
cppv:  c++11
group:  DS
requires: limits

codes:  [D7]
related:

category: [needs-review]
---

```cpp
template< class type >
class SegTree {
	struct node {int l, r; type v; } tr[maxn << 2u];
	void pushup(int u) { tr[u].v = max(tr[u << 1u].v, tr[u << 1u | 1u].v); }
	void build(int u, int l, int r) {
		tr[u] = {l, r};
		if (l == r - 1) {
			// init tr[u].v with ar[l]'s attribute
			return ;
		}
		build(u << 1u, l, (l + r) >> 1u);
		build(u << 1u | 1u, (l + r) >> 1u, r);
		pushup(u);
	}
	type query(int u, int l, int r) {
		if (tr[u].l >= l && tr[u].r <= r) return tr[u].v;
		if (tr[u].l >= r || tr[u].r <= l) return 0;
		return max(query(u << 1u, l, r), query(u << 1u | 1u, l, r));
	}
	void modify(int u, int id, int x) {
		if (tr[u].l == id && tr[u].r - 1 == id) tr[u].v = x;
		else {
			int mid = (tr[u].l + tr[u].r) >> 1u;
			if (id < mid) modify(u << 1u, id, x);
			else modify(u << 1u | 1u, id, x);
			pushup(u);
		}
	}
public:
	void init(const int n) { build(1, 1, n + 1); }
	type solve(int l, int r) { return query(1, l, r + 1); }
	void update(int id, int x) { modify(1, id, x); }
};
SegTree< int > st;
```