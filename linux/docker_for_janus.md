% Janus WebRTC编译安装

# Docker下安装ubuntu镜像

## 安装ubuntu
```
docker search ubuntu
docker pull ubuntu
```

## 安装 aptitude
```
docker run -ti ubuntu /bin/bash
apt-get update
apt-get install aptitude
```

## 安装依赖库
```
aptitude install libmicrohttpd-dev libjansson-dev \
         libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
         libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
         libconfig-dev pkg-config gengetopt libtool automake
```

# 安装WebSocket
## 安装git, cmake, gcc, g++
```
apt-get install git gcc g++ net-tools vim
```

## 安装websocket
```
git clone https://github.com/warmcat/libwebsockets.git
cd libwebsockets
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" ..
make && make install
```

# 安装http server
```
apt-get install nodejs
npm -g install http-server
```

# 安装libsrtp
```
wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz
tar xfv v2.2.0.tar.gz
cd libsrtp-2.2.0
./configure --prefix=/usr --enable-openssl
make  shared_library && make install
```

# 安装Janus
```
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=/opt/janus
make
make install
make configs
```

# 创建docker image
```
docker ps -a
docker commit 6b216a84d92e  ubuntu_janus
```

# docker常用命令
## 查看本机Docker中存在哪些镜像
docker images

## 列出当前所有正在运行的容器
docker ps

## 进入容器ID为ffffffff的容器
docker attach ffffffff 

## 查询网络情况
docker inspect ffffffff

## 进入正在执行的容器ID为ffffffff的容器
docker exec -it ffffffff  /bin/bash

## 启动容器
docker start ffffffff

## 停止正在运行的容器
docker stop ffffffff

## 重启容器
docker restart ffffffff

## 删除容器
docker rm ffffffff

## 删除镜像
docker rmi ffffffff

## 清除停止容器
docker container prune

## 备份镜像
docker save -o ~/ubuntu.tar ubuntu

## 加载备份镜像
docker load -i ~/ubuntu.tar

# 运行Janus
```
/opt/janus/bin/janus --debug-level=7 --log-file=$HOME/janus-log &
cd janus-gateway/html/
http-server
netstat -ap
```





