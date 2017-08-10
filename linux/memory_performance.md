

# 查看系统默认的页面大小

```
[root@localhost ~]# /usr/bin/time -v date
...
    Page size (bytes): 4096
...
```


# linux 内存管理——内核的shmall 和shmmax 参数

内核的 shmall 和 shmmax 参数
SHMMAX= 配置了最大的内存segment的大小 ------>这个设置的比SGA_MAX_SIZE大比较好。

SHMMIN= 最小的内存segment的大小 
SHMMNI= 整个系统的内存segment的总个数 
SHMSEG= 每个进程可以使用的内存segment的最大个数

配置信号灯（ semphore ）的参数：
SEMMSL= 每个semphore set里面的semphore数量 -----> 这个设置大于你的process的个数吧，否则你不得不分多个semphore set，好像有process+n之说，我忘了n是几了。
SEMMNI= 整个系统的semphore set总数
SEMMNS=整个系统的semphore总数

shmall 是全部允许使用的共享内存大小，shmmax 是单个段允许使用的大小。这两个可以设置为内存的 90%。例如 16G 内存，16*1024*1024*1024*90% = 15461882265，shmall 的大小为 15461882265/4k(getconf PAGESIZE可得到) = 3774873。

* 修改 /etc/sysctl.conf
```
 kernel.shmmax=15461882265
 kernel.shmall=3774873
 kernel.msgmax=65535
 kernel.msgmnb=65535
 执行 sudo sysctl -p
```

可以使用 ipcs -l 看结果。ipcs -u 可以看到实际使用的情况


