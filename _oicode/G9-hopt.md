---
title:  ShortestPath-Dijkstra Heap OPT
brief:
author: mooyyu
tag:    g009hopt

experimental: false
cppv:  c++11
group:  graph
requires: algorithm,limits,queue,vector

codes:  [G9]
related:

category: [needs-review]
---

```cpp
template< class type >
class SPS_Dijkstra {
	typedef pair< type, int > pti;
	const int n;
	bool vis[maxn + 1] {};    // 表示源点到该点的距离还没有(被更新且已经松弛了其出边)的状态.最后被动确定的点不被标记
	priority_queue< pti, vector< pti >, greater< pti > > srp;    // 距离-节点地址
public:
	struct node {
		int to, ptr;
		type len;
	} ar[maxm + 1];    // 链式前向星存图, ar[0]不存, ptr==0视为ptr==null
	int head[maxn + 1] {};
	const type INF = numeric_limits< type >::max() >> 1u;
	type dis[maxn + 1] {};    // 表示源点到该点的最短距离
	explicit SPS_Dijkstra(const int n) : n(n) {}    // single point shortest path for sparse graph (Dijkstra)
	void solve(const int source) {
		fill(dis + 1, dis + n + 1, INF);
		fill(vis + 1, vis + n + 1, false);
		priority_queue< pti, vector< pti >, greater< pti > >().swap(srp);
		srp.emplace(dis[source] = 0, source);    // 确定源点到源点的最短路,但没有更新其出边,不能在vis中标记源点
		while (!srp.empty()) {    // 确定源点到vis中最短距离的点->更新其出边->从vis中删除该点,最后一个点被动确定
			static int cur;
			cur = srp.top().second, srp.pop();
			if (vis[cur]) continue;    // 在vis中寻找距离源点最近的点
			vis[cur] = true;
			for (int i = head[cur]; i; i = ar[i].ptr)
				if (!vis[ar[i].to]) {    // 尝试松弛其出边, 将松弛成功的边的入点放入优先队列(小根堆)
					static type dist;
					if ((dist = dis[cur] + ar[i].len) < dis[ar[i].to])
						srp.emplace(dis[ar[i].to] = dist, ar[i].to);
				}
		}
	}
};
```
