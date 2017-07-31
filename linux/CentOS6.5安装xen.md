# CentOS6.5安装Xen4.2

## 更换163源
```sh
$ cd /etc/yum.repos.d/
$ mv CentOS-Base.repo CentOS-Base.repo.bk
$ wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
$ mv CentOS6-Base-163.repo Base.repo
$ yum clean all
$ yum makecache
```

## 基本条件
### 确认防火墙关闭
```
[root@localhost ~]# getenforce
Disabled
```
否则修改enable为diable
```
[root@localhost ~]# grep "SELINUX=" /etc/sysconfig/selinux
# SELINUX= can take one of these three values:
SELINUX=disabled
```

### 安装perl依赖 
```
[root@localhost ~]# yum install perl
```


## 安装步骤
### 安装Xen对象的软件包并修改grub配置文件
```
[root@localhost ~]# yum install centos-release-xen
[root@localhost ~]# yum install xen
[root@localhost ~]# yum update
```

### 加载了虚拟机管理程序软件
```
[root@localhost ~]# /usr/bin/grub-bootxen.sh 
[root@localhost ~]# more /boot/grub/grub.conf
[root@localhost ~]# reboot
[root@localhost ~]# uname -a
```

### 查看/boot/grub/grub.conf，default=1，则将default=0默认支持xen的内核启
动

## 网络配置
### 桥接方式

```
[root@localhost ~]# more /etc/sysconfig/network-scripts/ifcfg-eth0
[root@localhost ~]# ifconfig
[root@localhost ~]# brctl show 
[root@localhost ~]# brctl addbr xenbr0 
[root@localhost ~]# brctl show 
[root@localhost ~]# cd /etc/sysconfig/network-scripts
[root@localhost ~]# cp ifcfg-eth0 ifcfg-xenbr0
[root@localhost ~]# vi ifcfg-xenbr0
[root@localhost ~]# vi ifcfg-eth
[root@localhost ~]# brctl show 
[root@localhost ~]# ifconfig

```

## 建立首台虚拟机
### 安装虚拟机工具
virt-manager,      virt-install,       virsh,       xen-create-image

### 确定前面步骤已完成，查询一件安装xen内核
``` 
[root@localhost ~]# xl info
```

### 安裝libvirt
```
$ yum install libvirt python-virtinst libvirt-daemon-xen
$ yum reboot
```


## 参考
- [Centos XEN](https://wiki.centos.org/zh/HowTos/Xen)
- [Xen4 Libvirt](https://wiki.centos.org/zh-tw/HowTos/Xen/Xen4QuickStart/Xen4Libvirt)
- [Xen创建虚拟机](http://blog.csdn.net/cybertan/article/details/8365819)
- [Xen 的配置文件用法](https://www.xenproject.org)
- [CentOS7安装xen](http://www.jianshu.com/p/c7eacd56fd90)
