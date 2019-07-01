
# nvidia-smi工具

## 安装
通常安装好nvidia驱动程序后会自动安装好nvidia-smi


## 使用
### 简单方式
```
$ nvidia-smi
...
```

### 查询卡数
```
[root@bogon ~]# nvidia-smi -L

GPU 0: Quadro P5000 (UUID: GPU-25049053-61b4-ad49-1f96-3ae7df7afbd3)
GPU 1: Quadro P2000 (UUID: GPU-1029c3f5-cd59-692d-f38f-902ac67a351d)
```

### 按进程查询
```
[root@bogon ~]# nvidia-smi pmon -i 0 -c 1
# gpu     pid  type    sm   mem   enc   dec   command
# Idx       #   C/G     %     %     %     %   name
0   30891     C     5    13    45    87   ffmpeg

[root@bogon ~]# nvidia-smi pmon help
Option "help" is not recognized.

    Usage: nvidia-smi pmon [options]

    Options include:
    [-i | --id]:          Comma separated Enumeration index, PCI bus ID or UUID
    [-d | --delay]:       Collection delay/interval in seconds [default=1sec, max=10secs]
    [-c | --count]:       Collect specified number of samples and exit
    [-s | --select]:      One or more metrics [default=u]
                          Can be any of the following:
                              u - Utilization
                              m - FB memory usage
    [-o | --options]:     One or more from the following:
                              D - Include Date (YYYYMMDD) in scrolling output
                              T - Include Time (HH:MM:SS) in scrolling output
    [-f | --filename]:    Log to a specified file, rather than to stdout
    [-h | --help]:        Display help information
```

### 占用率和内存查询
```
$ nvidia-smi -a -q -d utilization
```

### 按卡查询

```
[root@bogon ~]# nvidia-smi dmon -i 1 -s pucvmet  -c 1
# gpu   pwr  temp    sm   mem   enc   dec  mclk  pclk pviol tviol    fb  bar1 sbecc dbecc   pci rxpci txpci
# Idx     W     C     %     %     %     %   MHz   MHz     %  bool    MB    MB  errs  errs  errs  MB/s  MB/s
    1    25    43    10     4    40     0  3499  1721     0     0   442     2     -     -     0   577    95

[root@bogon ~]# nvidia-smi dmon help

```

### 更多信息查询

```
$ nvidia-smi --help-query-gpu
[root@bogon ~]# nvidia-smi --query-gpu=pci.bus,temperature.gpu --format=csv,noheader
0x02, 43
0x83, 45

```

