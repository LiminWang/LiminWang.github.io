# 阿里云

# 关闭阿里云系统内置监控服务
```
sudo systemctl stop aliyun.service
sudo /etc/init.d/aegis stop
sudo /etc/init.d/agentwatch stop
sudo chkconfig aegis off
sudo systemctl disable aliyun.service
sudo chkconfig agentwatch off
```
