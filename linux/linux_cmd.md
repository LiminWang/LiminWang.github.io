# 日常使用命令总结

## sort
###  按列排序
-  -r: 以相反的顺序来排序
-  -u: 忽略相同行
-  -n: 以数字顺序来排序
-  -k: 是指定需要排序列数
-  -t: 指定栏位分隔符

```sh
查询线程cpu最高的情况
[root@localhost ~]# ps aux  -L |grep 3239  | sort -r -n -k4 |head -n5
root      3239  3481 39.0   74  0.8 1807468 134448 ?      Sl   23:41   0:21 /opt/bin/xxx
root      3239  3355 22.7   74  0.8 1807468 134448 ?      Sl   23:41   0:12 /opt/bin/xxx
root      3239  3488 17.2   74  0.8 1807468 134448 ?      Sl   23:41   0:09 /opt/bin/xxx
root      3239  3476  4.9   74  0.8 1807468 134448 ?      Sl   23:41   0:02 /opt/bin/xxx
root      3239  3425  3.9   74  0.8 1807468 134448 ?      Sl   23:41   0:02 /opt/bin/xxx

复杂一点ps写法
[root@localhost ~]# ps -e -L -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | grep xxx |sort -rnk4 |head -n15
30684 xxx     /opt/bravo/bin/xxx  55.3 167404 1823588 10:58 root       0
30683 xxx     /opt/bravo/bin/xxx  55.3 169492 1812640 10:58 root       0
30690 xxx     /opt/bravo/bin/xxx  54.5 167432 1806476 10:58 root       0
30689 xxx     /opt/bravo/bin/xxx  54.5 175544 1806456 10:58 root       0
30690 xxx     /opt/bravo/bin/xxx  34.6 167432 1806476 10:58 root       0
30689 xxx     /opt/bravo/bin/xxx  33.8 175544 1806456 10:58 root       0
30684 xxx     /opt/bravo/bin/xxx  33.4 167404 1823588 10:58 root       0
30689 xxx     /opt/bravo/bin/xxx  32.9 175544 1806456 10:58 root       0
30683 xxx     /opt/bravo/bin/xxx  32.4 169492 1812640 10:58 root       0
```



