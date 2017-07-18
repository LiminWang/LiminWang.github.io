# how to capture and replay network traffic on Linux
# Linux系统下如何录制和重播网络流

# 概述
日常工作中，有时会涉及客户现场出现故障和问题，如果能录制到现场的网络包和对录制的包重新播放，对研发解决问题会非常有帮助，Linux下其实就有现成对工具，tcpdump和tcpreplay来满足需要，下面简单接受一下用法

# 安装
## CentOS发行版

```sh
$ sudo yum install tcpdump
$ sudo yum install tcpreplay
```

## Debian发行版 

```sh
$ sudo apt-get install tcpdump
$ sudo apt-get install tcpreplay
```

# 用法
## 录制

```sh
$ sudo tcpdump -w dump.pcap -i eth0
```
## 简单分析
```sh
$ sudo tcpdump -ttttnnr dump.pcap
00:00:25.572722 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.572889 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.573066 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.573238 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.573405 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.573585 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.573754 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
00:00:25.597073 IP 10.45.100.9.1000 > 239.169.161.15.3015: UDP, length 1316
```
## 

## 修改录制的网络文件信息
### 改写目标ip地址和mac地址
```sh
$ tcprewrite --infile=dump.pcap --outfile=temp1.pcap --dstipmap=0.0.0.0/0:192.168.1.20 --enet-dmac=E0:DB:55:CC:13:F1
```

### 改写源ip地址和mac地址

```sh
$ tcprewrite --infile=temp1.pcap --outfile=temp2.pcap --srcipmap=0.0.0.0/0:192.168.1.10 --enet-smac=84:A5:C8:BB:58:1A
```

### 更新checksum
```sh
$ tcprewrite --infile=temp2.pcap --outfile=final.pcap --fixcsum
```

### 重写播放录制网络包

```sh
简单播放
$ sudo tcpreplay --intf1=eth0 final.pcap

重播放100次，并使用cache的方式
$ sudo tcpreplay --loop=100 --enable-file-cache --intf1=eth0 final.pcap

按10M码率播放
$ sudo tcpreplay --multiplier=5.0 --intf1=eth0 final.pcap

一直循环播放，直到Ctrl->C退出

$ sudo tcpreplay --loop=0 --intf1=eth0 final.pcap
```


