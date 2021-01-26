---
title:			图论浅谈之最短路
description:	'传统算法中的最短路问题解读'

author: mooyyu
contrib:
category: [ algorithm, al-search, al-graph ]
date: 2020-03-15
---

最短路问题是传统算法竞赛中图论的最常考察的问题，也是内容相对多的部分。本文详细讨论最短路的各基础算法以及常用的最短路模型和拓展。本文偏向于应用与细节而非原理。

------

## 本文主要内容

-   本文中最短路用到的常用术语
-   全源全汇最短路与Floyd算法
-   单源最短路
    -   带权最短路下的基础算法
        -   带权最短路问题图的存储方法和注意事项
        -   适用稠密正权图的朴素的Dijkstra算法
        -   适用稀疏正权图的堆优化的Dijkstra算法
        -   SPFA算法
    -   各算法的全汇最短路与单汇最短路
    -   BFS适用的最短路问题
        -   BFS如何求解特定的最短路问题
        -   BFS适用的最短路模型
            -   最小步数模型
            -   最少转换模型
                -   使用双向BFS算法优化
                -   使用A\*算法优化
    -   单源最短路的各种拓展
        -   边数限制为k的最短路与Bellman-Ford算法
        -   多个可选源点最短路
        -   正权图上的次短路与Dijkstra算法
        -   k短路与A\*算法
        -   维护路径最短路
            -   最小字典序路径
            -   所有路径
-   其他
    -   SPFA算法与判断负环

## 本文中最短路用到的常用术语

|         术语 | 含义                                                         | 表示                                 |
| -----------: | ------------------------------------------------------------ | ------------------------------------ |
|   源点、汇点 | 对于一条最短路的起点、终点                                   | $$source、sink$$                       |
|     最短距离 | 点$$i$$到点$$j$$的最短距离、源点到点$$k$$的最短距离                | $$d(i, j)、dis(k)$$                    |
|   三角不等式 | 从点$$i$$ 到$$j$$ 的直接距离不会大于途经的任何其它点$$k$$的距离    | $$d(i, j)\leqslant d(i, k) + d(k, j)$$ |
|     松弛操作 | 利用三角不等式，使用中间点$$k$$更新点$$i$$到$$j$$的直接距离，一般$$i$$指源点 | $$relax(k, j)$$                        |
|       不连通 | 使用一个相对于图中数据大很多的值作为两点间距离表示不连通     | $$INF$$                                |
| 节点集、边集 | 构成图的所有节点的集合、边的集合                             | $$Vertex、Edge$$                       |
|   出点、入点 | 对于一条有向边的指出点、指向点                               | $$e、u$$                               |

## 全源全汇最短路与Floyd算法

Floyd算法是一个很优美的算法，可以求解任意起点至任意终点的最短路。运用了动态规划的思想。

$$
\begin{aligned}
definition&\\
&f(i, j)\text{ express the shortest length of the path from point i to point j}\\
&dis(i, j)\text{ express the length of the path from point i to point j}\\
request&\\
&\forall i, j\in Vertex, f(i, j)\\
state\ trasition&\\
&f(i, j) = \begin{cases}
f(i, j)\\
\{f(i, k) + f(k, j)\mid k\in Vertex\}
\end{cases}\\
&state\ division:\quad f(i, j)\text{ is unrelaxed or releaxed by point k}\\
optimization&\\
&none\\
solution&\\
&loop\quad k\ in\ Vertex\\
&\hphantom{loop\quad}loop\quad i\ in\ Vertex\\
&\hphantom{loop\quad loop\quad}loop\quad j\ in\ Vertex\\
&\hphantom{loop\quad loop\quad loop\quad}relax(k, j)\ about\ i\\
\end{aligned}
$$

Floyd算法求解全源全汇最短路的细节注意点

-   由于求解的是任意两点间的最短路，所以适合使用邻接矩阵存储图的结构
-   求解前构图的过程分为初始化与输入
    -   初始化时注意$$d(i, j)\begin{cases} INF,&i\not = j\\0,&i = j \end{cases}$$，为下面的输入去重做准备
    -   由于邻接矩阵结构中两点间仅能存储一个距离，所以输入要处理重边问题
-   由于在负权图中$$INF$$可以被负权边松弛成功，所以要提前判断$$d(i, k)$$和$$d(k, j)$$不是$$INF$$

```cpp
template< class type >
class FP {
	const int n;
public:
	const int INF = numeric_limits< type >::max() >> 1u;
	int ar[maxn + 1][maxn + 1] {};
	explicit FP(const int n): n(n) {
		for (int i = 1; i <= n; i++) {
			fill(ar[i] + 1, ar[i] + n + 1, INF);
			ar[i][i] = 0;
		}
	}
	void solve() {
		for (int k = 1; k <= n; k++)
			for (int i = 1; i <= n; i++)
				if (ar[i][k] != INF)
					for (int j = 1; j <= n; j++)
						if (ar[k][j] != INF)
							ar[i][j] = min(ar[i][k] + ar[k][j], ar[i][j]);
	}
};
```

## 单源最短路

单源最短路是最短路问题中内容最多，考察最多最杂的部分。可以分为带权单源最短路、BFS适用的最短路问题以及以他们为基础进行拓展的特殊问题。一般考察最多的是单源单汇最短路，但大部分算法可求单源全汇最短路问题，也有针对单汇进行优化的方法和只能求解单汇最短路问题的特殊算法。

### 带权最短路的基础算法

一般可以求解带权单源最短路问题的算法有Dijkstra算法及其堆优化的算法、Bellman-Ford算法以及基于其的SPFA算法。由于一般问题中Bellman-Ford算法不存在优越性，故这里省去，此算法将在后文的拓展最短路问题中讲到。

对于各最短路算法我的分析思路为：确定使用的数据结构(data structure)——求解初始化(initialization)——核心算法(core algorithm)，我称之为$$DIC$$分析法。在此之前，先说一说有关带权图存图的问题。

#### 带权最短路问题图的存储方法和注意事项

带权图的存储总的来说有三种结构：边集、邻接矩阵和邻接表。边集较为简单，使用结构体数组即可。邻接矩阵适用于稠密图，邻接表适用于稀疏图。其中邻接表有两种实现方式：向量$$vector$$和链式前向星[^link_astar]，由于内存分配的耗时是仅和分配次数成正比的，所以链式前向星具有绝对优势，在图论问题中都使用链式前向星实现连接表。

邻接矩阵存图存在如下需注意的事项

-   无法存储重边，只能在初始化和输入时处理此问题，其中初始化时$$d(i, j)\begin{cases} INF,&i\not = j\\0,&i = j \end{cases}$$
-   存储无向图时，要把每条无向边转为两条对应的有向边

链式前向星、边集存图存在如下需注意的事项

-   存储无向图时，不仅要转化边，存储空间也需要扩大一倍

各基础算法的存图结构如下：

|             算法名称              |  存图结构  |
| :-------------------------------: | :--------: |
|  适用稠密图的朴素版Dijkstra算法   |  邻接矩阵  |
| 适用稀疏图的堆优化版Dijkstra算法  | 链式前向星 |
|             SPFA算法              | 链式前向星 |
| 用于求解第k短路的Bellman-Ford算法 |    边集    |



#### 适用稠密正权图的朴素的Dijkstra算法

>   时间复杂度：$$O(n^2)$$
>
>   一句话核心思想：每次选取余下的结点中最近的一个尝试松弛其出边。

$$
\begin{aligned}
data\ structure&\\
&数组dis：源点到各点的最短路径\\
&集合vis：不满足状态「最短路确定，向后完成松弛操作」的结点的集合\\
initialization&\\
&dis(e) = \begin{cases}
INF,&e \not = source\\
0,&e = source
\end{cases}\\
&push\ \forall e\in Vertex\ into\ vis\\
core\ algorithm&\\
&loop\quad n - 1\ times\\
&\hphantom{loop\quad}find\ cur\in vis, \forall e\in vis,dis(cur)\leqslant dis(e)\\
&\hphantom{loop\quad}delete\ cur\ from\ vis\\
&\hphantom{loop\quad}relax(cur, u), u\in vis\\
\end{aligned}
$$

注意上述过程中$$cur$$仅对属于集合$$vis$$的结点进行松弛，并不违背核心思想，因为对不属于集合$$vis$$的结点尝试松弛没有意义（这些结点的最短路已确定）。

```cpp
template< class type >
class SPD_Dijkstra {
	const int n;
	unordered_set<int> vis;
public:
	type INF = numeric_limits<type>::max()>>1u;
	type dis[maxn+1] {};
	type ar[maxn+1][maxn+1] {};
	explicit SPD_Dijkstra(const int n): n(n) {
		for (int i = 1; i <= n; i++) fill(ar[i]+1, ar[i]+n+1, INF);
		for (int i = 1; i <= n; i++) ar[i][i]= 0;
	}
	void solve(const int source) {
		for (int i = 1; i <= n; i++) vis.insert(i);
		fill(dis+1, dis+n+1, INF);
		dis[source] = 0;
		for (int k = 1, cur; k < n; k++) {
			cur = *vis.begin();
			for (const auto i : vis) if (dis[i] < dis[cur]) cur = i;
			vis.erase(cur);
			for (const auto i : vis) dis[i] = min(dis[i], dis[cur] + ar[cur][i]);
		}
	}
};
```

#### 适用稀疏正权图的堆优化的Dijkstra算法

可以注意到朴素的Dijkstra算法有两个地方可以优化

-   「每次选取最近的结点」这一操作可以借助小根堆维护
-   只有当$$dis(cur)$$被松弛成功，$$relax(cur, u)$$才有意义

>   时间复杂度：$$o(m\cdot \log n)$$
>
>   核心思想和朴素版算法相同，只是实现上加了上述两个优化

$$
\begin{aligned}
data\ structure&\\
&数组dis：源点到各点的最短路径\\
&集合vis：不满足状态「最短路确定，向后完成松弛操作」的结点的集合\\
&小根堆srp：<dis(e), e>, e\in Vertex, compare\ by\ dis(e)\\
initialization&\\
&dis(e) = \begin{cases}
INF,&e \not = source\\
0,&e = source
\end{cases}\\
&push\ \forall e\in Vertex\ into\ vis\\
&push\ source\ into\ srp\\
core\ algorithm&\\
&loop\quad untill\ srp\ is\ empty\\
&\hphantom{loop\quad}pop\ cur\ from\ srp\\
&\hphantom{loop\quad}if\quad cur\not\in vis\\
&\hphantom{loop\quad if\quad}continue\ next\ loop\\
&\hphantom{loop\quad}delete\ cur\ from\ vis\\
&\hphantom{loop\quad}if\quad relax(cur, u), u\in vis\ is\ successful\\
&\hphantom{loop\quad if\quad}push\ u\ into\ srp
\end{aligned}
$$

```cpp
template< class type >
class SPS_Dijkstra {
	typedef pair< type, int > pti;
	const int n;
	bool vis[maxn + 1] {};
	priority_queue< pti, vector< pti >, greater< pti > > srp;
public:
	struct node {
		int to, ptr;
		type len;
	} ar[maxm + 1];
	int head[maxn + 1] {};
	const type INF = numeric_limits< type >::max() >> 1u;
	type dis[maxn + 1] {};
	explicit SPS_Dijkstra(const int n) : n(n) {}
	void solve(const int source) {
		fill(dis + 1, dis + n + 1, INF);
		fill(vis + 1, vis + n + 1, false);
		priority_queue< pti, vector< pti >, greater< pti > >().swap(srp);
		srp.emplace(dis[source] = 0, source);
		while (!srp.empty()) {
			static int cur;
			cur = srp.top().second, srp.pop();
			if (vis[cur]) continue;
			vis[cur] = true;
			for (int i = head[cur]; i; i = ar[i].ptr)
				if (!vis[ar[i].to]) {
					static type dist;
					if ((dist = dis[cur] + ar[i].len) < dis[ar[i].to])
						srp.emplace(dis[ar[i].to] = dist, ar[i].to);
				}
		}
	}
};
```

#### SPFA算法

SPFA是一种很优秀的算法，根据Bellman-Ford算法发展而来。SPFA有SLF(shortest label first)和LLL(large label last)两种优化方法，但此两种优化不具有普适性，仅对特殊的图起到作用，需具体分析，故这里不作讨论。

>   时间复杂度：平均$$O(m)$$，最坏$$O(n\cdot m)$$
>
>   一句话核心思想：每次在新的被松弛成功的节点中选取一个向后尝试松弛其出边。

$$
\begin{aligned}
data\ structure&\\
&数组dis：源点到各点的最短路径\\
&集合vis：满足状态「被松弛成功但尚未向后进行松弛操作」的结点的集合\\
&队列que：<e>, e\in Vertex\\
initialization&\\
&dis(e) = \begin{cases}
INF,&e \not = source\\
0,&e = source
\end{cases}\\
&push\ source\ into\ vis\\
&push\ source\ into\ que\\
core\ algorithm&\\
&loop\quad untill\ que\ is\ empty\\
&\hphantom{loop\quad}pop\ cur\ from\ que\\
&\hphantom{loop\quad}delete\ cur\ from\ vis\\
&\hphantom{loop\quad}if\quad relax(cur, u),u\in \{ cur's\ successors \}\ is\ successful\\
&\hphantom{loop\quad if\quad}if\quad u\not\in vis\\
&\hphantom{loop\quad if\quad if\quad}push\ u\ in\ vis\\
&\hphantom{loop\quad if\quad if\quad}push\ u\ in\ que
\end{aligned}
$$

```cpp
template< class type >
class SP {
	type dis[maxn + 1] {};
	bool vis[maxn + 1] {};
	const int n;
	queue< int > que;
public:
	const int INF = numeric_limits< type >::max() >> 1u;
	struct {
		int to, ptr;
		type len;
	} ar[maxm + 1] {};
	int head[maxn + 1] {};
	explicit SP(const int n): n(n) {}
	type solve(int source) {
		fill(vis + 1, vis + n + 1, false);
		fill(dis + 1, dis + n + 1, INF);
		queue< int >().swap(que);
		vis[source] = true, dis[source] = 0, que.push(source);
		while (!que.empty()) {
			static int cur;
			cur = que.front(), que.pop(), vis[cur] = false;
			for (int i = head[cur]; i; i = ar[i].ptr)
				if (dis[cur] + ar[i].len < dis[ar[i].to]) {
					dis[ar[i].to] = dis[cur] + ar[i].len;
					if (!vis[ar[i].to]) {
						que.push(ar[i].to);
						vis[ar[i].to] = true;
					}
				}
		}
	}
};
```

### 各算法的全汇最短路与单汇最短路

上述的三种算法给出的伪码和模板都是用于求解单源全汇最短路的，当然全汇都已经求解出来，对于给定的汇点也是得到了答案，但是了解各点的最短路究竟是在算法的那个步骤求解出来对于深入理解算法本身很有帮助，或者在某些情况下我们需要在得到给定汇点的最短路便及时退出。包括下文的BFS、A\*求解最短路，这里一起讨论一下。

|               具体算法 | 何时得到解                                                   |
| ---------------------: | ------------------------------------------------------------ |
|       Dijkstra系列算法 | 对于所有节点，“被弹出时”得到解，即被确定为当前未确定的结点中距离源点最近时 |
| Bellman-Ford、SPFA算法 | 对于所有节点，“算法结束时”得到解                             |
|      BFS求解最短路问题 | 对于所有结点，“被插入时”得到解，即被松弛成功、被探索到时     |
|                A\*算法 | 对于且仅对于给定汇点，“第k次弹出时”得到“第k短路”的解         |

### BFS适用的最短路问题

BFS是可以求解无权最短路和01权值最短路问题的。因为BFS是满足“最小性”的搜索，故可以求解。下面详细讨论。

#### BFS如何求解特定的最短路问题

首先BFS搜索的“最小性”是如何被满足的？BFS所维护的数据结构是队列，如果用$$x$$表示搜索过程中第$$x$$步探索到的结点，那么直观的，任意时刻队列都满足如下形式：
$$
\{ \underbrace{x, x, x,\cdots}_{cnt(x)\geqslant 0}, \underbrace{\cdots,x + 1, x + 1, x + 1}_{cnt(x + 1)\geqslant 0} \}
$$
可以称这种性质为“两段性”，前一段小于后一段，也即任意时刻队列是满足单调性的，故对于无权最短路当第一次搜索到汇点时，一定经历了最短的步数。

那么对于01权值最短路，我们只要想办法保证维护数据结构的单调性，就依旧可解。方法是使用双端队列代替普通队列，当探索权值为0的边时，将节点插入队首就可保证其两段性，进一步保证了单调性和正确性。

继续思考下去的话，如果是多权值还想要保证数据结构的单调性，就需要堆了，此时BFS就弱化为Dijkstra算法了。

|                  |  普通BFS   | 双端队列维护的BFS |   Dijkstra   |
| ---------------: | :--------: | :---------------: | :----------: |
|             边权 |     1      |       0、1        |     非负     |
|   最短路何时确定 | 被探索到时 |   被用于探索时    | 被用于探索时 |
|         数据结构 |  普通队列  |     双端队列      |    小根堆    |
| 各节点插入的次数 |  不大于1   |      不大于2      | 小于总结点数 |

#### BFS适用的最短路模型

##### 最小步数模型

此种模型较为简单，其特点是图的结构是给定的、不会变化的，一般为棋盘或迷宫之类，求解图上两点的最小步数，各节点能选择的分支很少，其构成的图一定是一张稀疏图。

##### 最少转换模型

此种模型一定是单源单汇问题，也一定构成了一张稠密图。一般给定源点和汇点的结点状态和转换规则，求解最少转换的次数。比较经典的比如8数码问题、15数码问题。一般BFS是求解此类问题的基础，但是需要优化。由于每个节点可拓展的分支数一般很多，在搜索过程中访问的结点程指数形式增长，需要优化。

###### 使用双向BFS算法优化

不难想象，使用BFS搜索，假设汇点在第$$k$$层，每个节点有$$x$$个分支，则需要搜索$$x^k$$这样一个级别的节点数。而使用双向BFS算法，从源点和汇点同时向中间状态搜索，则将在第$$\lfloor \frac k2\rfloor$$层相遇，搜索的节点数量级为$$2\times x^{\frac k2}$$。

>   重要的技巧：源点和汇点各维护一个队列，每次应选取队列中元素较少的那一方继续搜索，以保持两边搜索的结点数尽量接近，达到优化的目的。

###### 使用A\*算法优化

A\*算法可以完美求解$$k$$短路问题(下文说到)，我们令$$k = 1$$则可以用于优化最短路问题。但使用A\*算法优化最短路问题并非仅仅是令$$k = 1$$。A\*算法求解这两个问题的实际应用不尽相同。

|            |                 k短路问题                 |           优化单源单汇最短路问题            |
| ---------: | :---------------------------------------: | :-----------------------------------------: |
|     着重点 |          小根堆第k次弹出第k短路           |            估价函数优化搜索方案             |
|   拓展节点 | 拓展所有节点，因为只有重复拓展才会有k短路 | 若边权唯一，同BFS；若边权不唯一，同Dijkstra |
|   维护路径 |      基于上面拓展节点的方式，不可以       |        基于上面拓展节点的方式，可以         |
| 何时得到解 |           汇点第k次被用于探索时           | 若边权唯一，同BFS；若边权不唯一，同Dijkstra |

A\*算法的效率取决于估价函数$$g(e)$$（即预估节点$$e$$到汇点的距离）的准确性。一般可用于最少转换模型（使用该算法，转化操作可以带权）和求解第k短路。用于最少转化模型时如果存在网格结构，可以从曼哈顿距离[^m_dist]的方向思考一下估价函数。

### 单源最短路的各种拓展

#### 边数限制为k的最短路与Bellman-Ford算法

前文中说道Bellman-Ford算法在基础最短路问题中没有优势，但是其也有特殊性，即求解边数限制为$$k$$的最短路

>   时间复杂度： $$O(n\cdot m)$$
>
>   一句话核心思想：$$k$$次对所有边使用备份距离尝试松弛

$$
\begin{aligned}
data\ structure&\\
&数组dis：源点到各点的最短路径\\
&数组bak：数组dis的备份\\
initialization&\\
&dis(e) = \begin{cases}
INF,&e \not = source\\
0,&e = source
\end{cases}\\
core\ algorithm&\\
&loop\quad k\ times\\
&\hphantom{loop\quad}copy\ dis\ to\ bak\\
&\hphantom{loop\quad}dis(u) = min\{ dis(u), bak(e) + d(e, u) \}
\end{aligned}
$$

> 注意：由于在负权图中$$INF$$可以被负权边松弛成功，所以要提前判断$$bak(e)$$不是$$INF$$。

```cpp
template< class type >
class SP_Bellman_Ford {
	const int n, m;
public:
	struct node {
		int from, to;
		type len;
	} ar[maxm];
	type INF = numeric_limits<type>::max()>>1u;
	type dis[maxn+1], bak[maxn+1];
	explicit SP_Bellman_Ford(const int n, const int m) : n(n), m(m) {}
	void solve(const int source, const int k) {
		fill(dis + 1, dis + n + 1, INF);
		dis[source] = 0;
		for (int idx = 0; idx < k; idx++) {
			copy(dis+1, dis+n+1, bak+1);
			for (int i = 0; i < m; i++)
				if (bak[ar[i].from] != INF)
					dis[ar[i].to] = min(dis[ar[i].to], bak[ar[i].from] + ar[i].len);
		}
	}
};
```

#### 多个可选源点最短路

>   思考方式

通过增加一个虚拟源点，规定其到可选源点距离为$$0$$，到其他节点距离为$$INF$$，便转化为普通的单源最短路

>   编码方法

将本来作用于单个源点的初始化作用于所有可选源点即可

#### 正权图上的次短路与Dijkstra算法

将$$vis、dis$$维护两组即可，松弛的时候讨论当前的路小于最短路，或者大于最短路但小于次短路这两种情况，就能维护一个次短路了。

理论上任何第$$k$$（确定值）短路都可以用此方法求解，但并不实用。

#### k短路与A\*算法

A\*算法上文讨论过，这里给出使用A\*求解k短路问题的详细算法思想。

>   A\*算法保证正确性的前提：对于任意节点，估价函数不大于实际值。
>
>   使用A\*搜索时使用小根堆维护节点（对于节点$$e$$，维护信息为$$\{g(e) + dis(e), \{ dis(e), e \}\}$$，其中$$dis(e)$$不需要额外维护）。

$$
\begin{aligned}
DATA&\\
&估价函数ge: 各点到汇点的距离估价(不大于实际距离)\\
&小根堆srp:\ <g(e) + dis(e), <dis(e), e>>\\
INIT&\\
&根据曼哈顿距离或反向最短路构造估价函数ge\\
&push\ source\ to\ srp\\
CORE&\\
&cnt = 0\\
&\!\begin{aligned}
loop\quad&until\ srp\ is\ empty\\
&pop\ cur\ from\ srp\\
&\!\begin{aligned}
if\quad&cur == sink\mbox{ && }+\!\!+cnt == k\\
&return\quad dis(cur)
\end{aligned}\\
&\forall u\in\{ cur's\ successors \}\\
&\quad\quad push\ \{ g(u) + dis(cur) + d(cur, u), \{ dis(cur) + d(cur, u), u \} \}\ into\ srp
\end{aligned}
\end{aligned}
$$

#### 维护路径最短路

有时候我们需要维护找到的最短路的路径。也很简单，只要记录每个节点是如何被搜索到的（比如由哪个节点拓展而来、有哪个方向搜索得到等等），只要根据记录可以从汇点反推得到路径就OK。

> Tips: 可以直接在反向图上执行算法，那么就无需反推了——反向图的逆向路径即正向图的正向路径。

##### 最小字典序路径

既然要求解最小字典序的最短路径，就一定存在评判大小的标准，在执行算法时按照约定顺序拓展即可。

##### 所有路径

先使用最短路算法得到最短路径长度。然后使用dfs得到所有最短路，如果要求顺序，dfs的过程遵守约定顺序即可。

## 其他

### SPFA算法与判断负环

和最短路问题经常一同出现的对负权图的判断负环，Bellman-Ford算法和SPFA算法都可以求解，因为SPFA算法的时间复杂度优秀，故使用SPFA算法求解。

> 如何求解？

根据抽屉原理，对于一张有$$n$$个节点的图，若一条最短路上有$$n$$条边，即$$n + 1$$个节点，则至少有一个节点出现次数不小于2次，即出现了负环。

$$
\begin{aligned}
data\ structure&\\
&数组dis：源点到各点的最短路径(在判断负环时，此意义不重要)\\
&数组cnt：源点到各点的最短路径边数\\
&集合vis：满足状态「被松弛成功但尚未向后进行松弛操作」的结点的集合\\
&队列que：<e>, e\in Vertex\\
initialization&\\
&\forall e\in Vertex,cnt(e) = 0\\
&保证该图的所有联通子图至少有一个节点放入vis\\
&放入vis的结点同样需要放入que\\
core\ algorithm&\\
&loop\quad untill\ que\ is\ empty\\
&\hphantom{loop\quad}pop\ cur\ from\ que\\
&\hphantom{loop\quad}delete\ cur\ from\ vis\\
&\hphantom{loop\quad}if\quad relax(cur, u),u\in \{ u's\ successors \}\ is\ successful\\
&\hphantom{loop\quad if\quad}cnt(u) = cnt(e) + 1\\
&\hphantom{loop\quad if\quad}if\quad cnt(u)\ equals\ the\ size\ of\ Vertexs\\
&\hphantom{loop\quad if\quad if\quad}存在负环\\
&\hphantom{loop\quad if\quad}if\quad u\not\in vis\\
&\hphantom{loop\quad if\quad if\quad}push\ u\ in\ vis\\
&\hphantom{loop\quad if\quad if\quad}push\ u\ in\ que\\
&若算法执行结束未发现负环则不存在
\end{aligned}
$$

```cpp
template< class type >
class SP {
	const type INF = numeric_limits< type >::max() >> 1u;
	type dis[maxn + 1] {};
	bool vis[maxn + 1] {};
	int cnt[maxn + 1] {};
	const int n;
	queue< int > que;
public:
	struct {
		int to, ptr;
		type len;
	} ar[maxm + 1] {};
	int head[maxn + 1] {};
	explicit SP(const int n): n(n) {}
	bool solve() {
		fill(vis + 1, vis + n + 1, true);
		fill(cnt + 1, cnt + n + 1, 0);
		fill(dis + 1, dis + n + 1, INF);	// 初始化为INF有利于防止溢出
		queue< int >().swap(que);
		for (int i = 1; i <= n; i++) que.push(i);
		while (!que.empty()) {
			static int cur;
			cur = que.front(), que.pop(), vis[cur] = false;
			for (int i = head[cur]; i; i = ar[i].ptr)
				if (dis[cur] + ar[i].len < dis[ar[i].to]) {
					if ((cnt[ar[i].to] = cnt[cur] + 1) == n) return false;
					dis[ar[i].to] = dis[cur] + ar[i].len;
					if (!vis[ar[i].to]) {
						que.push(ar[i].to);
						vis[ar[i].to] = true;
					}
				}
		}
		return true;
	}
};
```

[^link_astar]: 一种使用数组模拟链表的结构，本博客会在后面数据结构的专题文章中进行详细说明。
[^m_dist]: 在欧几里得空间的固定直角坐标系上两点所形成的线段对轴产生的投影的距离总和.