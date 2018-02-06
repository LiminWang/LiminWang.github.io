# Centos7 安装python-pip

## 查找pip是否存在
```
yum search python-pip 
```

存在，直接安装yum install python-pip 
否则，执行命令 yum -y install epel-release
成功之后，执行yum install python-pip


## 升级pip

```
pip install --upgrade pip
```


