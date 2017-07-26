
## 启动、停止、重启、重载服务...
- CentOS6
```
service <SERVICE> {start|stop|restart|reload|status|condrestart}
```

- CentOS7
```
systemctl {start|stop|restart|reload|status|condrestart} <SERVICE>.service
```

## 启用、禁用服务 on startup
- CentOS6
```
chkconfig <SERVICE> {on|off}
chkconfig <SERVICE>  -- 查看状态
chkconfig <SERVICE> --add
```

- CentOS7
```
systemctl {enable|disable} <SERVICE>.service
systemctl is-enabled <SERVICE>.service
systemctl daemon-reload <SERVICE>.service
```

## 其它systemd命令
```
systemctl halt
systemctl poweroff
systemctl reboot
systemctl suspend
systemctl hibernate
```
