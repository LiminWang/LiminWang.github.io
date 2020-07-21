
## 安装scl源

```
$ yum install centos-release-scl scl-utils-build
```

## 列出scl有哪些源可以用
```
$ yum list all --enablerepo='centos-sclo-rh' |grep devtoolset
```

## 安装devtoolset-9 
```
$ sudo yum install devtoolset-9
```

## 切换gcc版本
```
$ gcc --version
$ sudo scl enable devtoolset-9 bash
$ gcc --version
```

也可通过在 bashrc 中输入命令永久切换为新版本
source scl_source enable devtoolset-9

## 退出当前gcc版本

```
$ exit
```




