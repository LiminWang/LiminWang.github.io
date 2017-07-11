# 性能调优相关

## Adapter RX and TX Buffer Tuning

网络适配器接受和发送buf默认大小值一般都会比最大值设置要小, 一般建议尽量设置大
一些，避免丢包。具体的配置命令如下:

### 查询

```sh
[root@localhost ~]# ethtool -g eno1
Ring parameters for eno1:
Pre-set maximums:
RX:4096
RX Mini:0
RX Jumbo:0
TX:4096
Current hardware settings:
RX:256
RX Mini:0
RX Jumbo:0
TX:256
```

### 修改
 
```sh
[root@localhost ~]# ethtool -G eno1 rx 4096 tx 4096
```

### 系统启动修改
如centos系统应该是在/sbin/ifup-local下写一个脚本


## 适配器transmit队列长度

一般来说来说， qlen=1000对10g的网络都足够用，但如果发现transmit错误变多，就需
要考虑double这个值， 可以用`ip -s link` ### 查询，`qlen`对应的值
```sh
[root@localhost ~]# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
    link/ether 0c:c4:7a:db:24:5a brd ff:ff:ff:ff:ff:ff
3: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
    link/ether 0c:c4:7a:db:24:5b brd ff:ff:ff:ff:ff:ff
```

### 设置

```sh
[root@localhost ~]# ip link set dev eno1 txqueuelen 2000
```

### 查询errors and drops
```sh
[root@localhost ~]# ip -s link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast
    70046368559 17149497 0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    70046368559 17149497 0       0       0       0
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
    link/ether 0c:c4:7a:db:24:5a brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    189936990605 140826096 0       621     0       193557178
    TX: bytes  packets  errors  dropped carrier collsns
    591492539680 435498653 0       0       0       0
3: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
    link/ether 0c:c4:7a:db:24:5b brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    5845110291 4541509  0       78      0       4296178
    TX: bytes  packets  errors  dropped carrier collsns
    263938441100 194358250 0       0       0       0
```


