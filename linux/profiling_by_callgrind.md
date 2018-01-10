# Performance profiling by callgrind


## Code profiling

A code profiler is a tool to analyze a program and report on its resource usage
(where "resource" is memory, CPU cycles, network bandwidth, and so on). The
first step in program optimization is to gather factual, quantitative data from
representative program execution using a profiler. The profiling data will give
insights into the patterns and peaks of resource consumption so you can
determine if there is a concern at all, and if so, where the problem is
concentrated, allowing you to focus your efforts on the passages that most need
attention. You can also measure and re-measure with the profiler to verify your
efforts are bearing fruit.

Most code profilers operate via a dynamic analysis--- which is to say that they
observe an executing program and take live measurements---as opposed to static
analysis which examines the source and predicts behavior. Dynamic profiler
operate in a variety of ways: some by interjecting counting code into the
program, other take samples of its activity at a high-frequency, and others run
the program in a simulated environment with built-in monitoring.

The standard C/unix tool for profiling is gprof, the gnu profiler. This
no-frills tool is a statistical sampler that tracks time spent at the
function-level. It take regular snapshots of a running program and traces the
function call stack (just like you did in crash reporter!) to observe activity.
You can check out the online gprof manual if you are curious about its features
and use.

The Valgrind profiling tools are cachegrind and callgrind. The cachegrind tool
simulates the L1/L2 caches and counts cache misses/hits. The callgrind tool
counts function calls and the CPU instructions executed within each call and
builds a function callgraph. The callgrind tool includes a cache simulation
feature adopted from cachegrind, so you can actually use callgrind for both CPU
and cache profiling. The callgrind tool works by instrumenting your program
with extra instructions that record activity and keep counters.

## Running callgrind and callgrind_annotate

To profile, you run your program under Valgrind and explicitly request the
callgrind tool (if unspecified, the tool defaults to memcheck).

```sh
$ valgrind --tool=callgrind program-to-run program-arguments
```

The above command starts up valgrind and runs the program inside of it. The
program will run normally, albeit a bit more slowly, due to Valgrinds
instrumentation. When finished, it briefly summarizes the total number of
collected events:

```
==22417== Events    : Ir
==22417== Collected : 7247606
==22417==
==22417== I   refs:      7,247,606
```

Valgrind will have written the information about the above 7 million collected
events to an output file named callgrind.out.pid. (pid is the process id. In
the above example, the process id was 22417). This is an ordinary text file,
but not intended for you to read directly. Instead, you run the annotator
callgrind_annotate on this output file to display the information in an useful
way:

```sh
$ callgrind_annotate --auto=yes callgrind.out.pid
```

The output from the annotator will be given in Ir counts which are "instruction
read" events. The output shows total number of events occurring within each
function (i.e. number of instructions executed) and displays the list of
functions sorted in order of decreasing count. Your high-traffic functions will
be listed at the top. The option --auto=yes further breaks down the results by
reporting counts for each C statement (without the auto option, you get counts
summarized at the function level, which is often too coarse to be useful).

In order to additionally monitor cache hits/misses, invoke valgrind callgrind
with the simulate-cache option like this:

```sh
$ valgrind --tool=callgrind --simulate-cache=yes program-to-run program-arguments
```

The brief summary printed at the end will now include events collected about
access to the L1 and L2 caches, as shown below:

```
==16409== Events    : Ir Dr Dw I1mr D1mr D1mw I2mr D2mr D2mw
==16409== Collected : 7163066 4062243 537262 591 610 182 16 103 94
==16409==
==16409== I   refs:      7,163,066
==16409== I1  misses:          591
==16409== L2i misses:           16
==16409== I1  miss rate:       0.0%
==16409== L2i miss rate:       0.0%
==16409==
==16409== D   refs:      4,599,505  (4,062,243 rd + 537,262 wr)
==16409== D1  misses:          792  (      610 rd +     182 wr)
==16409== L2d misses:          197  (      103 rd +      94 wr)
==16409== D1  miss rate:       0.0% (      0.0%   +     0.0%  )
==16409== L2d miss rate:       0.0% (      0.0%   +     0.0%  )
==16409==
==16409== L2 refs:           1,383  (    1,201 rd +     182 wr)
==16409== L2 misses:           213  (      119 rd +      94 wr)
==16409== L2 miss rate:        0.0% (      0.0%   +     0.0%  )
```

When you run callgrind_annotate on this output file, the annotations will now include the cache activity as well as instruction counts.

## Interpreting the results

Understanding the Ir counts. The Ir counts are basically the count of assembly instructions executed. A single C statement can translate to 1, 2, or several assembly instructions. Consider the passage below that has been annotated by callgrind_annotate. The profiled program sorted a 1000-member array using selection sort. A single call to the swap function requires 15 instructions: 3 for the prologue, 3 for assign to tmp, 4 for copy from * b to * a, 3 for assign from tmp and 2 more for the epilogue. (Note that the cost of the prologue and epilogue is annotated on the opening and closing braces.) There were 1,000 calls to swap, accounting for a total of 15,000 instructions.
