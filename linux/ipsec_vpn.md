# 阿里云上安装VPN

## docker方式

# https://hub.docker.com/r/hwdsl2/ipsec-vpn-server/

$ cat vpn.env
#IPsec PSK: xxxxxxx
#Username: xxxxxxx
#Password: xxxxxxx

$ sudo docker run \
       --name ipsec-vpn-server \
       --env-file ./vpn.env \
       --restart=always \
       -p 500:500/udp \
       -p 4500:4500/udp \
       -d --privileged \
       hwdsl2/ipsec-vpn-server


## CentOS 关闭 AliYunDun
使用 chkconfig –list 查看开机启动里面这个软件的服务名是什么，然后 off 掉 aegis 执行就可以了。

# chkconfig --list
aegis           0:off   1:off   2:on    3:on    4:on    5:on    6:off
agentwatch      0:off   1:off   2:on    3:on    4:on    5:on    6:off
cloudmonitor    0:off   1:off   2:on    3:on    4:on    5:on    6:off
mysql           0:off   1:off   2:off   3:off   4:off   5:off   6:off
netconsole      0:off   1:off   2:off   3:off   4:off   5:off   6:off
network         0:off   1:off   2:on    3:on    4:on    5:on    6:off


## 老方式
- 购买阿里云ECS主机(香港主机), 不就是为了上google吗
- 镜像选用CentOS 7.2 64位版本，实测ok 
- 一键安装脚本

```sh
$ git clone git@github.com:LiminWang/setup-ipsec-vpn.git
$ cd setup-ipsec-vpn.git
$ sudo bash ./one-key-ikev2.sh
```

## iptables配置
### 阿里云配置安全策略
[iptables rules](images/aliyun_vpn_iptable_rules.jpg)

### 开放端口
```sh
$ iptables -A INPUT -p udp --dport 500 -j ACCEPT
$ iptables -A INPUT -p udp --dport 4500 -j ACCEPT
```
 
### 启用ip伪装
```sh
$ iptables -t nat -I POSTROUTING -s 10.1.0.0/16 -o eth0 -m policy --dir out --pol ipsec -j ACCEPT
$ iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE
```
  
### 添加转发
```sh
$ iptables -A FORWARD -s 10.1.0.0/16 -j ACCEPT
``` 

### 检查规则 

```sh
$ iptables -nvL; 
$ iptables -nvL -t nat
$ iptables --list
```

### 保存规则
```sh
$ service iptables save
```
    
### 重启服务
```sh
$ systemctl restart iptables
```

## 启动服务
```sh
$ systemctl start|stop|restart|status ipsec （CentOS7 下使用）
$ systemctl start|stop|restart xl2tpd （CentOS7 下使用）
```

## 错误检查
### 检查端口　
```sh
[root@iZj6c97garwn1o4y2zidq0Z ~]# netstat  -nap |grep 4500
udp        0      0 127.0.0.1:4500          0.0.0.0:*                           17600/pluto
udp        0      0 172.31.156.68:4500      0.0.0.0:*                           17600/pluto
```

### 检查 Libreswan (IPsec) 日志是否有错误：
```sh
grep pluto /var/log/secure
```

### 查看 IPsec VPN 服务器状态：
```sh
$ ipsec status
$ ipsec verify
```

## 显示当前已建立的 VPN 连接：
```sh
ipsec whack --trafficstatus
```

## mac client连接vpn后，无法连接内部网
* 路由加上内部网关
```
$ sudo route delete -net 192.168.1.0
$ sudo route add -net 192.168.1.0 -netmask 255.255.255.0 -gateway 192.168.3.1
```
