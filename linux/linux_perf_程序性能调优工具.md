# Linux下的系统性能调优工具

## 什么是perf?
linux性能调优工具，软件性能分析。几乎能够处理所有与性能相关的事件。
性能调优工具如perf，Oprofile等的基本原理都是对被监测对象进行采样，最简单的情形是根据tick中断进行采样，即在
tick中断内触发采样点，在采样点里判断程序当时的上下文。假如一个程序90%的时间都花费在函数foo上,
那么90%的采样点都应该落在函数foo的上下文中。运气不可捉摸，但我想只要采样频率足够高，采样时间足够长，那么以上
推论就比较可靠。因此，通过tick触发采样，我们便可以了解程序中哪些地方最耗时间，从而重点分析。

### 准备工作

CentOS7.2
```
$ yum install perf
```
 
## 什么是性能事件？
指在处理器或者操作系统中发生，可能影响到程序性能的硬件事件或者软件事情。
 
## 主要关注点在哪里？
算法优化（空间复杂度、时间复杂度）、代码优化（提到执行速度、减少内存占用）
评估程序对硬件资源的使用情况，例如各级cache的访问次数，各级cache的丢失次数、流水线停顿周期、前端总线访问次数等。
评估程序对操作系统资源的使用情况，系统调用次数、上下文切换次数、任务迁移次数。
 
## 基本原理？
硬件的话采用PMC（performance monitoring unit）CPU的部件，在特定的条件下探测的性能事件是否发生以及发生的次数。
软件性能测试，内置于kernel，分布在各个功能模块中，统计和操作系统相关性能事件。


## 常用的命令？
### perf list, 列出所有能够触发perf采样点的事件
总体分为三类hardware（硬件产生）、software（内核软件产生）、tradepoint（内核中静态tracepoint触发事件）。

### perf stat, 分析程序的整体性能
建议最先使用的一个工具。它通过概括精简的方式提供被调试程序运行的整体情况和汇总数据。

```
$perf stat ./your_app
```

### perf top, 实时显示系统/进程的性能统计信息

用于实时显示当前系统的性能统计信息。该命令主要用来观察整个系统当前的状态，比如可以通过查看该命令的输出来查看
当前系统最耗时的内核函数或某个用户进程。
```
$ perf top
Samples: 2M of event 'cycles', Event count (approx.): 64923335904
Overhead  Shared Object                           Symbol
  52.99%  libc-2.17.so                            [.] __memcpy_ssse3_back
  19.66%  [kernel]                                [k] clear_page_c_e
   1.32%  live-engine                             [.] xavs_put_filt8_hv_egpr_sse2
   0.90%  live-engine                             [.] xavs_idct8_1d_16_k_sse2
   0.83%  live-engine                             [.] xavs_put_filt8_v_h_sse2
   0.75%  live-engine                             [.] xavs_chroma_mc4_put_sse2
   0.75%  live-engine                             [.] ff_hscale8to15_4_ssse3.loop
   0.73%  live-engine                             [.] xavs_chroma_mc8_put_sse2
   0.63%  live-engine                             [.] postProcess_SSE2
   0.61%  live-engine                             [.] xavs_emulated_edge_mc
   0.61%  [kernel]                                [k] free_pages_prepare
   0.61%  [kernel]                                [k] get_page_from_freelist
   0.60%  live-engine                             [.] yuv2nv12cX_c
   0.59%  live-engine                             [.] xavs_idct8_1d_16_i_sse2
   0.57%  live-engine                             [.] xavs_put_filt8_v_dn_sse2
   0.55%  live-engine                             [.] xavs_put_filt8_hv_ik_sse2
   0.51%  live-engine                             [.] xavs_add_pixels_clamped_zero_sse2_i
   0.49%  [kernel]                                [k] copy_page_rep
```

### perf record/report, 记录一段时间内系统/进程的性能事件

```
$ perf record – e cpu-clock – g ./your_app
$ perf report
```

默认在当前目录下生成数据文件：perf.data
report读取生成的perf.data文件，-i参数指定路径




