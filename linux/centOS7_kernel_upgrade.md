# kernel upgrade for CentOS 7

## kernel upgrade
### Add ELRepo repository
```
$ sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
$ sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
$ uname -r
$ sudo yum --enablerepo=elrepo-kernel install kernel-lt
```

## Setting the default kernel
### update the Grub configuration
```
$ grub2-mkconfig -o /boot/grub2/grub.cfg

```

### list the installed kernel
```
$ awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
0 : CentOS Linux (4.4.162-1.el7.elrepo.x86_64) 7 (Core)
1 : CentOS Linux (3.10.0-327.el7.x86_64) 7 (Core)
2 : CentOS Linux (0-rescue-8991931bb03942ed91c1070a1e99c748) 7 (Core)
```

### set the default kernel
```
$ grub2-editenv list
saved_entry=0
$ grub2-set-default 0
or
$ grub2-set-default "CentOS Linux (4.4.162-1.el7.elrepo.x86_64) 7 (Core)"
```
