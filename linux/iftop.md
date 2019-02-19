# iftop获取网络带宽

## 获取多播／单播网络流量
```
$ iftop -f "host 192.168.1.167 and port 8800" -t -s 4 -n -N 2>/dev/null | grep
'Total receive rate: ' | awk '{print $4}'
4.08Mb
```
