# netstat常用总结

- netstat -nap | grep port 
    将会显示使用该端口的应用程序的进程id
- netstat -a or netstat –all 
    将会显示包括TCP和UDP的所有连接
- netstat --tcp or netstat –t 
    将会显示TCP连接
- netstat --udp or netstat –u 
    会显示UDP连接
- netstat -g 
    将会显示该主机订阅的所有多播网络。
- netstat -su 
    查看udp丢包
```sh
[root@localhost ~]# netstat -su
IcmpMsg:
    InType0: 2
    InType3: 23274
    OutType3: 118
    OutType8: 2
Udp:
    2697 packets received
    14 packets to unknown port received.
    0 packet receive errors
    560207422 packets sent
    0 receive buffer errors
    22964 send buffer errors
UdpLite:
IpExt:
    InNoRoutes: 3
    InTruncatedPkts: 230
    InMcastPkts: 1603209577
    OutMcastPkts: 560228477
    InBcastPkts: 1514549
    InOctets: 5701276510324
    OutOctets: 1209674069478
    InMcastOctets: 2154713671488
    OutMcastOctets: 752947026144
    InBcastOctets: 174586387
    InCsumErrors: 377
```
- netstat –alupt 
    查看队列里现存的包数，如果过多说明有问题。
- netstat -tnl
    只列出监听中的连接
- netstat -nlpt 
    获取进程名、进程号以及用户 ID
- netstat -rn
    显示内核路由信息
- netstat –tpn |grep ESTABLISHED
    检查已建立的连接信息
- netstat –s
    显示网络接口统计信息
- netstat -i  
    查看丢包，网络是否繁忙，错误包是否严重
