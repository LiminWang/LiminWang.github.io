# curl常见用法总结

## 下载单个文件
- 输出到STDOUT
```
curl http://www.centos.org
```
- 重定向
```
curl http://www.centos.org > my_file
```
-
## 保存cURL输出到一个文件
* 选项
    -o：将文件保存为命令行中指定的文件名的文件中
    -O：使用URL中默认的文件名保存文件到本地

* 将文件下载到本地并命名为mygettext.html
```
$ curl -o mygettext.html http://www.gnu.org/software/gettext/manual/gettext.html
```

# 将文件保存到本地并命名为gettext.html
```
$ curl -O http://www.gnu.org/software/gettext/manual/gettext.html
```

## 一次下载多个文件
* 支持多个－O选项
```
$ curl -O URL1 -O URL2
```

## 断点续传
* 通过使用-C选项可对大文件使用断点续传功能
```
$ curl -C - -O http://www.gnu.org/software/gettext/manual/gettext.html
```

## 网络限速
* 通过--limit-rate选项对CURL的最大网络使用进行限制
```
$ curl --limit-rate 1000B -O http://www.gnu.org/software/gettext/manual/gettext.html
```

## CURL授权
* 在访问需要授权的页面时，可通过-u选项提供用户名和密码进行授权
```
$ curl -u username:password URL
```


## 从FTP服务器下载文件
* 列出public_html下的所有文件夹和文件
```
$ curl -u ftpuser:ftppass -O ftp://ftp_server/public_html/
```
*  下载xss.php文件
```
$ curl -u ftpuser:ftppass -O ftp://ftp_server/public_html/xss.php
```

## 上传文件到FTP服务器
* 将myfile.txt文件上传到服务器
```
$ curl -u ftpuser:ftppass -T myfile.txt ftp://ftp.testserver.com
```

* 同时上传多个文件
```
curl -u ftpuser:ftppass -T "{file1,file2}" ftp://ftp.testserver.com
```

* 从标准输入获取内容保存到服务器指定的文件中
```
curl -u ftpuser:ftppass -T - ftp://ftp.testserver.com/myfile_1.txt
```

## POST 
* 自动转义特殊字符
```
$ curl --data-urlencode "value 1" http://hostname.com
```
* 通过 -X 选项指定其它协议
```
$ curl -I -X DELETE https://api.github.cim
```


##  参考
* [Using curl to automate HTTP jobs](https://curl.haxx.se/docs/httpscripting.html)
