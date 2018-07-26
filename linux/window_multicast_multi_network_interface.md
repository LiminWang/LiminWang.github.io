# 多网卡PC上如何接收多播地址?

## window平台
* 使用管理员打开cmd (right click run as administrator)
* 删除默认路由

> route print
> route delete 233.0.0.0 mask 255.0.0.0

* 增加路由

> route add 233.0.0.0 mask 255.0.0.0 <IP of NIC>

* 播放器VLC打开多播流，按理应该可以播放
