

# CPU

## 如何看每个CPU的使用率
```sh
$ top -d 1     \\运行后按数字1
top - 09:03:02 up 1 day, 15:54,  2 users,  load average: 17.68, 16.17, 15.89
Tasks: 195 total,   2 running, 193 sleeping,   0 stopped,   0 zombie
%Cpu0  : 88.2 us,  4.9 sy,  0.0 ni,  3.9 id,  0.0 wa,  0.0 hi,  2.9 si,  0.0 st
%Cpu1  : 89.9 us,  5.1 sy,  0.0 ni,  5.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu2  : 69.7 us, 26.3 sy,  0.0 ni,  4.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu3  : 83.5 us,  7.8 sy,  0.0 ni,  8.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu4  : 68.7 us, 26.3 sy,  0.0 ni,  4.0 id,  0.0 wa,  0.0 hi,  1.0 si,  0.0 st
%Cpu5  : 63.3 us, 25.5 sy,  0.0 ni, 10.2 id,  0.0 wa,  0.0 hi,  1.0 si,  0.0 st
%Cpu6  : 56.2 us, 25.0 sy,  0.0 ni, 18.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu7  : 58.2 us, 28.6 sy,  0.0 ni, 12.2 id,  0.0 wa,  0.0 hi,  1.0 si,  0.0 st
KiB Mem : 16175384 total,  6004788 free,  1262948 used,  8907648 buff/cache
KiB Swap:  4095996 total,  4095996 free,        0 used. 14354280 avail Mem
```

## 如何查看所有cpu的使用率
* vmstat
```
[root@localhost ~]# vmstat  2 1000
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 13  0      0 5974500   1688 8929772    0    0     1    11   26   17 52 13 35  0  0
 19  0      0 5973588   1688 8929868    0    0     0     0 592777 1096074 71 16 13  0  0
 15  0      0 5967072   1688 8929884    0    0     0   474 513374 916184 77 16  6  0  0
 10  0      0 5973540   1688 8929904    0    0     0     0 550527 1006480 74 17  9  0  0
 10  0      0 5977512   1688 8929976    0    0     0   258 651507 1237560 73 18  8  0  0
 19  0      0 5971984   1688 8930236    0    0     0     0 635708 1197416 74 18  8  0  0
 17  0      0 5935748   1688 8930444    0    0     0     0 600856 1112236 74 17  8  0  0
 13  0      0 5972440   1688 8930384    0    0     0     0 606772 1130949 73 18  9  0  0
 19  0      0 5973096   1688 8930656    0    0     0     0 657634 1251064 73 18  9  0  0
```

* mpstat
```sh
mpstat [-P {|ALL}] [internal [count]]
* -P {|ALL}：表示监控哪个CPU，在[0,cpu个数-1]中取值；
* internal：相邻的两次采样的间隔时间；
* count：采样的次数，count只能和delay一起使用；

 [root@localhost ~]# mpstat -P ALL 5
 平均时间:  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
 平均时间:  all   80.14    0.00   14.25    0.00    0.00    0.67    0.00    0.00    0.00    4.94
 平均时间:    0   73.12    0.00   19.80    0.00    0.00    2.46    0.00    0.00    0.00    4.62
 平均时间:    1   93.71    0.00    5.72    0.00    0.00    0.14    0.00    0.00    0.00    0.43
 平均时间:    2   71.12    0.00   20.46    0.00    0.00    0.58    0.00    0.00    0.00    7.84
 平均时间:    3   75.40    0.00   20.29    0.00    0.00    0.29    0.00    0.00    0.00    4.03
 平均时间:    4   68.71    0.00   19.59    0.00    0.00    0.44    0.00    0.00    0.00   11.26
 平均时间:    5   94.86    0.00    3.86    0.00    0.00    0.57    0.00    0.00    0.00    0.71
 平均时间:    6   71.43    0.00   19.10    0.00    0.00    0.44    0.00    0.00    0.00    9.04
 平均时间:    7   91.85    0.00    5.44    0.00    0.00    0.72    0.00    0.00    0.00    2.00
 ```

```
[root@localhost ~]# mpstat -P 0 1 100000
Linux 3.10.0-327.13.1.el7.x86_64 (localhost.localdomain)    2017年08月10日
_x86_64_    (8 CPU)
16时28分22秒  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal
%guest  %gnice   %idle
16时28分23秒    0   38.61    0.00    2.97    0.00    0.00    0.00    0.00
0.00    0.00   58.42
16时28分24秒    0   49.48    0.00    2.06    0.00    0.00    0.00    0.00
0.00    0.00   48.45
16时28分25秒    0   51.49    0.00    3.96    0.00    0.00    0.00    0.00
0.00    0.00   44.55
```

* iostat
```
[root@localhost ~]# iostat
Linux 3.10.0-327.13.1.el7.x86_64 (localhost.localdomain)    2017年07月22日  _x86_64_    (8 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          52.68    0.00   12.95    0.00    0.00   34.37

          Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
          sda               1.19         6.79        84.88    1009030   12616915
          dm-0              0.96         6.54        84.60     971705   12574524
          dm-1              0.00         0.01         0.00       1368          0
```

* sar
```
#sar -u 2 10
10时29分16秒     CPU     %user     %nice   %system   %iowait    %steal     %idle
10时29分18秒     all     77.73      0.00     17.98      0.00      0.00      4.29
10时29分20秒     all     77.42      0.00     16.95      0.00      0.00      5.63
10时29分22秒     all     78.74      0.00     16.66      0.00      0.00      4.61
10时29分24秒     all     77.90      0.00     16.86      0.00      0.00      5.24
```


## 查看每个进程的cpu
```sh
[root@localhost ~]# ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' |sort -rnk4 
```

* 查看每个线程的cpu  
```sh
[root@localhost ~]# ps -e -L -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | sort -rnk4 
```

* 查看每个线程的cpu绑定  
```
[root@localhost ~]# ps -e -L -o 'pid,psr,comm,args,pcpu,rsz,vsz,stime,user,uid' | sort -rnk5
 4952   6 myprog     /opt/hack/bin/myprog  95.5 1390068 2590392 17:45 root      0
 3181   2 myprog     /opt/hack/bin/myprog  93.5 1612284 2780164 17:45 root      0
 6987   7 sleep           sleep 60                     0.0   616 107892 17:49 root         0
 4952   1 myprog     /opt/hack/bin/myprog  42.8 1390068 2590392 17:45 root      0
 4952   0 myprog     /opt/hack/bin/myprog  10.3 1389804 2590392 17:45 root      0
```




