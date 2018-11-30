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
## 常用选项
-i：指定网络接口（如eth0，eth1。网络接口使用ifconfig命令查看）
-n：不对IP地址进行DNS反解析
-nn：不对IP地址进行DNS反解析，并且不将端口转换为字符
-vv：详细输出数据包信息
-w：将捕获的结果存入指定文件，-w后接自定义文件名
-r：将存入文件的结果读取出来以便分析

## 录制

```sh
$ sudo tcpdump -w dump.pcap -i eth0
$ tcpdump -i enp59s0f1 -t -s0 -C 300M -Z root host 230.0.0.1 and port 7001 -w test.dump
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

```
$ tshark -r ~/Downloads/100141.pcap
```

```sh
$ tshark -r test.pcap -T fields -e frame.number -e eth.src -e eth.dst -e ip.src -e ip.dst -e frame.len > test1.csv
$ tshark -r test.pcap -T fields -e frame.number -e eth.src -e eth.dst -e ip.src -e ip.dst -e frame.len -E header=y -E separator=, > test2.csv
$ tshark -r test.pcap -R "frame.number>40" -T fields -e frame.number -e frame.time -e frame.time_delta -e frame.time_delta_displayed -e frame.time_relative -E header=y > test3.csv
$ tshark -r test.pcap -R "wlan.fc.type_subtype == 0x08" -T fields -e frame.number -e wlan.sa -e wlan.bssid > test4.csv
$ tshark -r test.pcap -R "ip.addr==192.168.1.6 && tcp.port==1696 && ip.addr==67.212.143.22 && tcp.port==80" -T fields -e frame.number -e tcp.analysis.ack_rtt -E header=y > test5.csv
$ tshark -r test.pcap -T fields -e frame.number -e tcp.analysis.ack_rtt -E header=y > test6.csv
```


## 获取多播列表
```sh
sudo tcpdump -i eno1 -c 100000 multicast | perl -n -e 'chomp; m/> (\d+.\d+.\d+.\d+).(\d+)/; print "udp://$1:$2\n"' | sort | uniq
```

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


