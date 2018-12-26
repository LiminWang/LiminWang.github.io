

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

### 安装最新版本，没有对应的汉化版本
$ curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
$ sudo yum install -y gitlab-ce

### 安装固定版本
$ wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ee/yum/el7/gitlab-ee-11.5.4-ee.0.el7.x86_64.rpm
$ rpm -i gitlab-ee-11.5.4-ee.0.el7.x86_64.rpm

Please configure a URL for your GitLab instance by setting `external_url`
configuration in /etc/gitlab/gitlab.rb file.
Then, you can start your GitLab instance by running the following command:
  sudo gitlab-ctl reconfigure

### 汉化

$ sudo cat /opt/gitlab/embedded/service/gitlab-rails/VERSION
$ git clone https://gitlab.com/larryli/gitlab.git
$ git diff v11.5.4 v11.5.4-zh > /root/11.5.4.diff
$ cd /opt/gitlab/embedded/service/gitlab-rails
$ git apply /root/11.5.4.diff
$ sudo gitlab-ctl reconfigure
