

CentOS 7.2系统已经不包含MySQL软件包，需要手工自己安装RPM包

# 准备
## 下载mysql的repo源
```
$ wget http://dev.MySQL.com/get/MySQL-community-release-el7-5.noarch.rpm
```

## 安装repo源文件
- 直接安装
```
$ rpm -Uvh http://dev.MySQL.com/get/MySQL-community-release-el7-5.noarch.rpm

```
- 本地安装
```
sudo rpm -Uvh mysql-community-release-el7-5.noarch.rpm
```

## 安装mysql client and server
- 离线下载 
```sh
$ sudo yum --downloadonly --downloaddir=7.2 install mysql-community-server mysql-community-client
```

- 离线安装
```sh
[lmwang@b72]$ cd 7.2 
[lmwang@b72]$ sudo rpm -Uvh *.rpm
警告：mysql-community-client-5.6.37-2.el7.x86_64.rpm: 头V3 DSA/SHA1 Signature, 密钥 ID 5072e1f5: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:mysql-community-common-5.6.37-2.e################################# [  8%]
   2:mysql-community-libs-5.6.37-2.el7################################# [ 15%]
   3:mysql-community-client-5.6.37-2.e################################# [ 23%]
   4:perl-Net-Daemon-0.48-5.el7       ################################# [ 31%]
   5:perl-Compress-Raw-Zlib-1:2.061-4.################################# [ 38%]
   6:perl-Compress-Raw-Bzip2-2.061-3.e################################# [ 46%]
   7:perl-IO-Compress-2.061-2.el7     ################################# [ 54%]
   8:perl-PlRPC-0.2020-14.el7         ################################# [ 62%]
   9:perl-DBI-1.627-4.el7             ################################# [ 69%]
  10:mysql-community-server-5.6.37-2.e################################# [ 77%]
  11:mysql-community-devel-5.6.37-2.el################################# [ 85%]
正在清理/删除...
  12:mariadb-devel-1:5.5.52-1.el7     ################################# [ 92%]
  13:mariadb-libs-1:5.5.52-1.el7      ################################# [100%]
```

## 安装完成后的配置
- 加入开机启动
```sh
[lmwang@b72 mysql]$ sudo systemctl enable mysqld
```

- 启动mysqld进程 
```sh
[lmwang@b72 mysql]$ sudo systemctl start mysqld

```

- 重置密码
```sh
[lmwang@b72 mysql]$ sudo mysql_secure_installation
```
执行几个设置：
1. 为root用户设置密码, 直接回车, 设置密码
2. 删除匿名账号, y
3. 取消root用户远程登录, n
4. 删除test库和对test库的访问权限, y
5. 刷新授权表使修改生效, y

```sh
$ mysql -sfu root < ./mysql_install_default.sql
$ cat ./mysql_install_default.sql
UPDATE mysql.user SET Password=PASSWORD('your_password') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
```






