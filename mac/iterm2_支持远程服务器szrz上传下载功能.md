
# sz和rz轻松上传和下载

在Windows下面使用xshell或SecureCRT时，经常使用sz命令进行文件的上传下载非常方便。Mac下也可以配置实现

## mac安装lrzsz
```bash
$ brew install lrzsz
```

## 配置iterm2
### 获取工具
```
$ git clone  https://github.com/mmastrac/iterm2-zmodem
$ cp iterm2-zmodem/*.sh /usr/local/bin
```
### 设置  
Set up Triggers(profiles/advance/triggers) in iTerm 2 like so:
```bash
     Regular expression: rz waiting to receive.\*\*B0100
     Action: Run Silent Coprocess
     Parameters: /usr/local/bin/iterm2-send-zmodem.sh
     Instant: checked

     Regular expression: \*\*B00000000000000
     Action: Run Silent Coprocess
     Parameters: /usr/local/bin/iterm2-recv-zmodem.sh
     Instant: checked
```

## 远端服务器安装lrzsz
``` bash
$ yum -y install lrzsz
```

## 发送文件到远方服务器
1. 远程服务器敲rz命令
2. 弹出窗口选择本地要发送到文件
3. 等待完成

## 从远端服务器接收文件
1. 远程服务器敲sz file1 file2 file3...
2. 弹出窗口选择本地要接收文件到目录 
3. 等待完成
