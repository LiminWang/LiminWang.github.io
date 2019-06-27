# mutt收发邮件

## 安装包
```
$sudo yum install mutt cyrus-sasl-plain 
```

## .muttrc配置
```
$ mkdir -p ~/.mutt/cache/headers
$ mkdir ~/.mutt/cache/bodies
$ touch ~/.mutt/certificates
$ touch ~/.mutt/muttrc
$ vim ~/.mutt/muttrc
mailboxes +INBOX +archive +sent +drafts +spam +trash
set ssl_starttls=yes
set ssl_force_tls=yes
set imap_user = 'your.name@gmail.com'
set imap_pass = 'your_password'
set from='your.name@gmail.com'
set realname='your real name'
set folder = imaps://imap.gmail.com/
set spoolfile = imaps://imap.gmail.com/INBOX
set postponed="imaps://imap.gmail.com/[Gmail]/Drafts"
set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"
set certificate_file = "~/.mutt/certificates"
set smtp_url = "smtp://your_name@gmail.com:your_password@smtp.gmail.com:587/"
set move = no
set sort = threads
set imap_keepalive = 900

# activate TLS if available on the server
set ssl_starttls=yes
set ssl_force_tls = yes

bind index G imap-fetch-mail
set editor = "vim"
set charset = "utf-8"
set record = ''
```

## 测试邮件发送
```
mutt -s "Test from mutt" send_name@mail.server
```
