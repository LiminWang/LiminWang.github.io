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

$ mkdir -p /var/gogs/mysql
# Run the docker mysql image 
$ docker run --name mysql-server -t \ 
      -e MYSQL_DATABASE="gogs" \ 
      -e MYSQL_USER="gogs" \ 
      -e MYSQL_PASSWORD="gogs.mysql" \ 
      -e MYSQL_ROOT_PASSWORD="gogs.mysql" \ 
      -v /var/gogs/mysql:/var/lib/mysql \ 
      -v /etc/localtime:/etc/localtime:ro \ 
      -d mysql \
      --character-set-server=utf8 --collation-server=utf8_general_ci

$ docker logs mysql-server
$ docker inspect mysql-server
```

### gogs安装
$ docker pull gogs/gogs
$ mkdir -p /var/gogs/gogs
$ docker run -d --name=gogs -p 10022:22 -p 3000:3000 \
    --link mysql-server:mysql-server \
    -v /var/gogs/gogs:/data  \
    -v /etc/localtime:/etc/localtime:ro \ 
    gogs/gogs

>>>
# 将 gogs 容器 /data的目录，挂载到宿主机 /var/gogs/gogs目录，避免删除容器时数据丢失; 
# --link mysql-server:mysql-server  将 mysql-server 容器，链接到 gogs 容器，容器内部通过 mysql-server 主机名即可与之通信;
 -p 10022:22 -p 13000:3000 ，分别映射 宿主机10022与3000 端口，到 gogs容器的 22 与 3000 端口，用于对外ssh和http通信，下面配置gogs 也需要用到; 
 -v /etc/localtime:/etc/localtime:ro保存系统时间一致
$ docker start gogs
$ docker inspect gogs

# 检查时间是否一致
$ date
$ docker container  ls
$ docker exec -ti gogs bash
bash-4.4# date
# 恢复备份数据
bash-4.4# ./gogs restore your_backup_data_file_path


其中，端口10022用来git的ssh，3000端口用来http访问

### 配置
# 浏览器访问
>>>
http://localhost:3000/install 

数据库主机设置:
mysql-server:3306

# 设置开启自重庆
```
[root@localhost ~]# docker update --restart=always gogs
gogs
[root@localhost ~]# docker update --restart=always mysql-server
mysql-server
```
