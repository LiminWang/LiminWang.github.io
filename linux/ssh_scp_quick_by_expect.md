# 使用expect脚本快速ssh, scp访问

## 安装expect
- CentOS
```
[root@localhost ~]# yum install expect
```
- Debian/Ubuntu
```
[root@localhost ~]# apt-get install expect
```

## 编写expect脚本

```
[lmwang@localhost ~]$ vi qssh
#!/usr/bin/expect
spawn ssh root@192.168.1.[lrange $argv 0 0]
expect "password: "
send "your ssh server ssh password\r"
interact

[lmwang@localhost ~]$ vi qscp
#!/usr/bin/expect
set timeout 300
spawn scp -r [lrange $argv 1 1] root@192.168.1.[lrange $argv 0 0]:
expect "password: "
send "chnvideo2012\r"

expect eof

[lmwang@localhost ~]$ chmod +x qssh qscp
[lmwang@localhost ~]$ cp qssh qscp /usr/bin
```

## 关闭ssh host key检查
```
[lmwang@localhost ~]$ sudo vi /etc/ssh/ssh_config
StrictHostKeyChecking no
```





