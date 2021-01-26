---
title:			线段树之扫描线浅谈
description:	线段树的常见应用之一

author: mooyyu
contrib:
category: [ algorithm, al-DS, needs-review ]
---

-   线段树
-   离散化

## 平行矩阵群覆盖区域的面积

![扫描线](/assets/images/algorithm/Graph-segment_tree_scan/scanline.svg)

-   离散化x轴坐标生成a+1个坐标
-   在离散化的x轴的a个坐标间隔上建立线段树
    -   区间修改覆盖计数+1-1
    -   区间查询的意义：覆盖计数大于0的间隔长度和
-   将n个矩阵化为2n个4元组(l, r, y, flag)并排序
-   扫描线在排好序的2n个元组上前进
    -   根据当前元组的flag确定区间(l, r)修改的加减
    -   覆盖面积增加：query * 扫描线前进距离

-   对线段树操作的特殊性：查询操作仅进行全区间查询

![线段树](/assets/images/algorithm/Graph-segment_tree_scan/segment_tree.svg)

```cpp
#include <iostream>
#include <cstdio>
#include <set>
#include <unordered_map>
#include <vector>
#include <algorithm>

using namespace std;

const int maxn = 1e4;
set< int > si;
vector< int > vi;
unordered_map< int, int > uti;
struct node {
	int l, r, y, flag;
	friend bool operator<(const node &a, const node &b) {
		return a.y < b.y;
	}
} sline[maxn << 1u];

inline void discrete() {
	vi.resize(si.size() + 1);
	int i = 0;
	for (const auto &x : si) {
		uti[x] = ++i;
		vi[i] = x;
	}
}

class SegTree {
	struct node {
		int l, r;
		int v, cnt;
	} tr[maxn << 1u << 2u];
	void pushup(int u) { tr[u].v = tr[u << 1u].v + tr[u << 1u | 1u].v; }
	void build(int u, int l, int r) {
		tr[u] = {l, r};
		if (l == r - 1) return;
		build(u << 1u, l, (l + r) >> 1u);
		build(u << 1u | 1u, (l + r) >> 1u, r);
	}
	void modify(int u, int l, int r, int flag) {
		if (tr[u].l >= r || tr[u].r <= l) return;
		if (tr[u].l >= l && tr[u].r <= r) {
			tr[u].cnt += flag;
			if (tr[u].cnt) tr[u].v = vi[tr[u].r] - vi[tr[u].l];
			else pushup(u);
		} else {
			modify(u << 1u, l, r, flag);
			modify(u << 1u | 1u, l, r, flag);
			if (!tr[u].cnt) pushup(u);
		}
	}
public:
	void init(const int n) { build(1, 1, n + 1); }
	int solve(int l, int r, int flag) {
		modify(1, l, r, flag);
		return tr[1].v;
	}
} st;

int main() {
	ios::sync_with_stdio(false);

	int n {};
	cin >> n;
	for (int i = 0; i < n; i++) {
		static int l, r, u, d;
		cin >> l >> u >> r >> d;
		si.insert(l), si.insert(r);
		sline[i << 1u] = {l, r, u, 1};
		sline[i << 1u | 1u] = {l, r, d, -1};
	}
	discrete();
	sort(sline, sline + (n << 1u));
	st.init(si.size() - 1);
	int ret = 0;
	for (int i = 0, len = (n << 1u) - 1; i < len; i++) {
		ret += st.solve(uti[sline[i].l], uti[sline[i].r], sline[i].flag)
			   * (sline[i + 1].y - sline[i].y);
	}
	printf("%d\n", ret);

	return 0;
}
```

### 此模型的简单拓展

-   求各矩阵与其他矩阵重合面积之和

    各矩阵面积之和减去覆盖区域面积即可

-   求至少被两个矩阵覆盖的区域面积、（或其他类似条件）

    这种条件的改变直接对应到对cnt的值的判断即可

## 平行矩阵群覆盖区域的周长