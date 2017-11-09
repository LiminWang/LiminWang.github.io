# 在两台机器上：
yum install -y nfs-utils


# 在NFS服务器上：
vim /etc/exports
/data/ 192.168.137.201(insecure,rw,sync,no_root_squash)     #要共享的目录

# 先为rpcbind和nfs做开机启动：
systemctl enable rpcbind.service
systemctl enable nfs-server.service          

# 然后分别启动rpcbind和nfs服务：
```
systemctl restart rpcbind.service
systemctl restart nfs-server.service

systemctl stop rpcbind.service
systemctl stop nfs-server.service
```

# 确认NFS服务器启动成功：
```
rpcinfo -p
```

# 在从服务器上使用 mount 挂载服务器端的目录/data到客户端某个目录下：

mount 124.207.119.91:/finish/ /finish/

# 在从服务器上/etc/rc.local/开机启动里面添加：
mount 192.168.137.200:/nfs/ /nfs/

# 挂载不上重启服务！！
```
service rpcbind restart
service nfs restart
```

# 如遇到一下报错，可能是因为rpcbind 没有启动
```
Starting NFS quotas: Cannot register service: RPC: Unable to receive; errno = Connection refused
rpc.rquotad: unable to register (RQUOTAPROG, RQUOTAVERS, udp).
                                                           [FAILED]
Starting NFS mountd:                                       [FAILED]
Starting NFS daemon: rpc.nfsd: writing fd to kernel failed: errno 111 (Connection refused)
rpc.nfsd: unable to set any sockets for nfsd
                                                           [FAILED]
/etc/init.d/rpcbind start
```

# 碰到如下报错事因为打开了一个大于1024的非法端口，需要在配置文件中加入 insecure
mount.nfs: access denied by server while mounting 192.168.1.180:/data

# nfs的缺点就在这里
你必须客户端先umount了，才可以停止服务。
你现在只能先把服务重新启动，然后客户端正常以后，再umount。

//secure 选项要求mount客户端请求源端口小于1024（然而在使用 NAT 网络地址转换时端口一般总是大于1024的），默认情况下是开启这个选项的，如果要禁止这个选项，则使用 insecure 标识

修改配置文件/etc/exports，加入 insecure 选项

/home/test/rootfs  *(insecure,rw,async,no_root_squash)
