# Linux下接收多播地址问题

# 问题
Linux发送多播流的源服务器IP地址变化后，发现多播流接收不到, 调查结论是Linux内核从
安全考虑，默认使用了反向过滤技术，将不合要求的包丢弃了, 避免伪装IP攻击。

# 解决方案

## 系统配置文件
1. /etc/sysctl.conf

```sh
[root@localhost ~]# sysctl -a |grep ".rp_filter"
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.enp2s0f0.rp_filter = 1
net.ipv4.conf.enp2s0f1.rp_filter = 1
net.ipv4.conf.lo.rp_filter = 0
```

把 net.ipv4.conf.all.rp_filter和 net.ipv4.conf.default.rp_filter设为0即可

```sh
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.all.rp_filter = 0
```

网口配置也需要单独设置一下才有效, enp2s0f*是具体的NIC

```
net.ipv4.conf.enp2s0f0.rp_filter = 0
net.ipv4.conf.enp2s0f1.rp_filter = 0
```

系统启动后，会自动加载这个配置文件，内核会使用这个变量

2. 命令行

```sh
$ sysctl net.ipv4.conf.all.rp_filter
$ sysctl -w net.ipv4.conf.all.rp_filter=0
```

但系统重启后，配置就失效了

3. /proc接口

```sh
$ cat /proc/sys/net/ipv4/conf/all/rp_filter
$ echo "0" >/proc/sys/net/ipv4/conf/all/rp_filter

$ cat /proc/sys/net/ipv4/conf/default/rp_filter
$ echo "0" >/proc/sys/net/ipv4/conf/default/rp_filter
```

3. 如何加入多播地址组
在使用tcpdump抓取多播流，会遇到需要先用别的工具收录一下这个多播流，tcpdump才能抓
到网络包，解决的办法：
3.1 使用netstat查看是否加入多播组
```
[lmwang@b67 catip]$ netstat -gn
IPv6/IPv4 Group Memberships
Interface       RefCnt Group
--------------- ------ ---------------------
lo              1      224.0.0.1
enp3s0          1      224.0.0.1
lo              1      ff02::1
lo              1      ff01::1
enp3s0          1      ff02::1
enp3s0          1      ff01::1
```
3.2 可以使用ip maddr加入多播组, 但只支持link layer address
```
$ ip maddr [ add | del ] MULTIADDR dev STRING 
$ ip maddr add 224.0.0.251 dev enp3s0
```

3.3 可以使用socat(netcat++), 支持L2, L3
```
$ yum install socat
$ socat STDIO  UDP4-DATAGRAM:239.101.1.68:8889,ip-add-membership=239.0.1.68:10.100.201.1
```

3.4 如果保存多播流
```
$ socat -u UDP4-RECV:<PORT>,ip-add-membership=<MULTICAST_IP>:<NIC_IP>,reuseaddr CREATE:dump_name-`date +'%F-%H.%M'`.ts
```



