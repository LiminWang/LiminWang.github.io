# ssh无密码登陆方式


##  基本要求
- 主机2台，分别为主机A和主机B
- 主机A可以ssh无密码登陆主机B
- 主机A可以为mac或Linux系统，主机B为Linux系统（实测）
- 主机A可以增加主机B的hostname(/etc/hosts)

## 操作流程
### 主机A上操作
1. ssh-keygen创建公钥
``` bash
$ ssh-keygen -t rsa
```

提示创建.ssh/id_rsa、id_rsa.pub的文件，其中第一个为密钥，第二个为公钥。过程中会要求输入密码，为了ssh访问过程无须密码，可以直接回车

2. 复制公钥到主机B.ssh目录下（需要确认目录存在）
``` bash
$ scp .ssh/id_rsa.pub hostb:/~/ssh
```

### 主机B上操作
1. 更新授权key
``` bash
$ cd ~/
$ cat id_dsa.pub >> ~/.ssh/authorized_keys 
```

2. 设置文件和目录权限
``` bash
$ chmod 600 .ssh/authorized_keys 
$ chmod 700 -R .ssh
```

### 主机A无密码访问主机B
``` bash
hosta$ ssh hostb
```










