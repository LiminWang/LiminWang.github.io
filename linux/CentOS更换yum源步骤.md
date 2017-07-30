# CentOS更换yum源

```sh
$ cd /etc/yum.repos.d/
$ mv CentOS-Base.repo CentOS-Base.repo.bk
$ wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
$ mv CentOS6-Base-163.repo Base.repo
$ yum clean all
$ yum makecache
```
