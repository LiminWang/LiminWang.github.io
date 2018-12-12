# 使用Docker安装设置Gogs

## Docker安装

```
$ yum install -y epel-release
$ yum install docker-io # 安装docker
 
 # 配置文件 /etc/sysconfig/docker
 
# Centos 7以上
$ chkconfig docker on  # 加入开机启动
$ service docker start # 启动docker服务
 
# 切换国内镜像
$ echo "OPTIONS='--registry-mirror=https://mirror.ccs.tencentyun.com'" >> /etc/sysconfig/docker
$ systemctl daemon-reload
$ service docker restart

 # 基本信息查看
$ docker version # 查看docker的版本号，包括客户端、服务端、依赖的Go等
$ docker info # 查看系统(docker)层面信息，包括管理的images, containers数等
```

## Gogs Docker安装

### mysql安装
```
# pulls down the mysql image 
$ docker pull mysql

# Run the docker mysql image 
$ docker run --name vchari-mysql -e MYSQL_ROOT_PASSWORD=vchari -d mysql:latest
$ docker logs vchari-mysql
$ docker inspect vchari-mysql
$ docker run -it --link vchari-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

mysql > create database gogs;
mysql > show databases;
```

### gogs安装
$ docker pull gogs/gogs
$ mkdir -p /var/gogs
$ docker run -d --name=gogs -p 10022:22 -p 3000:3000 -v /var/gogs:/data gogs/gogs
$ docker start gogs
$ docker inspect gogs


其中，端口10022用来git的ssh，3000端口用来http访问

### 配置
# 浏览器访问
>>>
http://localhost:10080/install 
