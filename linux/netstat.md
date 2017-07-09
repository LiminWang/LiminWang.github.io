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
- netstat –alupt 
    查看队列里现存的包数，如果过多说明有问题。
- netstat -tnl
    只列出监听中的连接
- netstat -nlpt 
    获取进程名、进程号以及用户 ID
- netstat -rn
     显示内核路由信息
