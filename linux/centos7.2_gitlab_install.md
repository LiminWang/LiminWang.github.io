# gitlab install

## 安装基本依赖包
$ sudo yum install -y curl policycoreutils-python openssh-server
$ sudo systemctl enable sshd
$ sudo systemctl start sshd
$ sudo firewall-cmd --add-service=ssh --permanent


## 安装邮件服务器
$ sudo yum install -y postfix
$ sudo systemctl enable postfix
$ sudo systemctl start postfix
$ sudo firewall-cmd --add-service=http --permanent
$ sudo firewall-cmd --reload

## 安装gitlab
### 安装固定版本
$ wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ee/yum/el7/gitlab-ee-11.6.0-ee.0.el7.x86_64.rpm
$ rpm -i gitlab-ee-11.6.0-ee.0.el7.x86_64.rpm

Please configure a URL for your GitLab instance by setting `external_url`
configuration in /etc/gitlab/gitlab.rb file.
Then, you can start your GitLab instance by running the following command:
  sudo gitlab-ctl reconfigure

### 修改git仓库路径
```
$ vi /etc/gitlab/gitlab.rb
 git_data_dirs({ "default" => { "path" => "/home/gitlab/git-data",
 'gitaly_address' => 'unix:/var/opt/gitlab/gitaly/gitaly.socket' } })
```

### 配置外部smtp
```
```
$ vi /etc/gitlab/gitlab.rb

 gitlab_rails['smtp_enable'] = true
 gitlab_rails['smtp_address'] = "smtp.qiye.163.com"
 gitlab_rails['smtp_port'] = 25
 gitlab_rails['smtp_user_name'] = "github@bravovcloud.com"
 gitlab_rails['smtp_password'] = "your_passwd"
 gitlab_rails['smtp_domain'] = "bravovcloud.com"
 gitlab_rails['smtp_authentication'] = "login"
 gitlab_rails['smtp_enable_starttls_auto'] = true
 gitlab_rails['smtp_tls'] = false

###! **Can be: 'none', 'peer', 'client_once', 'fail_if_no_peer_cert'**
###! Docs: http://api.rubyonrails.org/classes/ActionMailer/Base.html
 gitlab_rails['smtp_openssl_verify_mode'] = 'none'

### Email Settings
 gitlab_rails['gitlab_email_enabled'] = true
 gitlab_rails['gitlab_email_from'] = 'github@bravovcloud.com'
 gitlab_rails['gitlab_email_display_name'] = 'github'
 gitlab_rails['gitlab_email_reply_to'] = 'noreply@bravovcloud.com'
 gitlab_rails['gitlab_email_subject_suffix'] = ''
```



