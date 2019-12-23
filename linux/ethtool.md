# ethtool常用用法
ethtool允许你查看和更改网卡的许多设置（不包括Wi-Fi网卡）。你可以管理许多高级设置，包括tx/rx、校验及网络唤醒功能。下面是一些你可能感兴趣的基本命令： 显示一个特定网卡的驱动信息，检查软件兼容性时尤其有用。

## 查询驱动信息
```sh
[root@localhost ~]# ethtool -i eno1
driver: igb
version: 5.2.13-k
firmware-version: 1.63, 0x80000a05
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no
```

## 查询卡统计信息
```sh
[root@localhost ~]# ethtool -S eno1
NIC statistics:
     rx_packets: 196858406
     tx_packets: 439274646
     rx_bytes: 266755741262
     tx_bytes: 598378726905
     rx_broadcast: 243564
     tx_broadcast: 3731
     rx_multicast: 195370065
     tx_multicast: 435687165
     multicast: 195370065
     collisions: 0
     rx_crc_errors: 0
     rx_no_buffer_count: 0
......

或者用下面的命令查询
$ ip -s link
[root@localhost ~]# ip -s link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast
    71234975716 17430158 0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    71234975716 17430158 0       0       0       0
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
    link/ether 0c:c4:7a:db:24:5a brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    193597830344 143531353 0       641     0       197194825
    TX: bytes  packets  errors  dropped carrier collsns
    601783268122 443074577 0       0       0       0
3: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
    link/ether 0c:c4:7a:db:24:5b brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    5845371632 4545767  0       78      0       4296233
    TX: bytes  packets  errors  dropped carrier collsns
    268877303770 197995115 0       0       0       0
```

### 查询buffer参数信息(rx,tx)

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

### 修改buffer参数
 
```sh
[root@localhost ~]# ethtool -G eno1 rx 4096 tx 4096
```

### How to keep the change after reboot

In RHEL 7, you can set the ring buffer size to come up at boot time by setting the 
```
ETHTOOL_OPTS value in:
/etc/sysconfig/network-scripts/ifcfg-eth0 to 
(for example) 
ETHTOOL_OPTS="-G ${DEVICE} rx 4096 tx 4096"
```

