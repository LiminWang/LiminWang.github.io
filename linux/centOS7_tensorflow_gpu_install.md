# tensorflow GPU版本的安装(CentOS7.2)

## 安装依赖
```
$ sudo yum install git gcc gcc-c++ autoconf automake libtool curl make g++ zip unzip
zlib1g-dev python python-devel numpy
```


## 安装Bazel
安装Bazel是为了把Tensorflow源码编译成可以用pip安装的whl文件，官方的whl安装包是基
于更高Glibc版本，而我们需要的是适用本机版本的whl安装包。

在安装Bazel之前需要安装JDK8：

```
$ yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel 

# 粘贴到/etc/profile
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
```
$ source /etc/profile

```
$ mkdir bazel
$ cd bazel
$ wget https://github.com/bazelbuild/bazel/releases/download/0.9.0/bazel-0.9.0-dist.zip
$ unzip bazel-0.9.0-dist.zip
$ ./compile.sh
$ ./bazel-0.9.0-installer-linux-x86_64.sh
# 会把bazel工具装到默认目录/usr/local下
```

* 推荐直接yum安装
[root@bogon ~]# wget
https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo
[root@bogon ~]# mv vbatts-bazel-epel-7.repo  /etc/yum.repos.d
[root@bogon ~]# yum install bazel


## 安装CUDA and CudNN

* install CUDA 
```
$ lspci | grep -i nvidia
$ sudo yum install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
$ sudo rpm --install cuda-repo-<distro>-<version>.<architecture>.rpm
$ sudo yum clean expire-cache
$ sudo yum install cuda
# 
$ nvidia-smi -a -q -d utilization
```

* Disabling Nouveau
```
$ lsmod | grep nouveau
```

Create a file at /etc/modprobe.d/blacklist-nouveau.conf with the following
contents:

blacklist nouveau
options nouveau modeset=0

Regenerate the kernel initramfs:
```
$ sudo dracut --force
```

* Install cuDNN
```
$ wget http://developer.download.nvidia.com/compute/redist/cudnn/v7.1.1/cudnn-8.0-linux-x64-v7.1.tgz
$ tar -xzvf cudnn-8.0-linux-x64-v7.1.tgz
$ sudo cp cuda/include/cudnn.h /usr/local/cuda/include
$ sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
$ sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```

* 设置环境变量
$ echo "export CUDA_HOME=/usr/local/cuda-8.0" >> ~/.bashrc
$ echo "export PATH=\"\$CUDA_HOME/bin:\$PATH\"" >> ~/.bashrc
$ echo "export LD_LIBRARY_PATH=\"/\$CUDA_HOME/lib64:\$LD_LIBRARY_PATH\"" >> ~/.bashrc
$ source ~/.bashrc


# 安装gcc 5.4.0

##  安装开发依赖包
```
$ yum groupinstall "Development Tools"
$ yum install glibc-static libstdc++-static
$ yum install libmpc-devel mpfr-devel gmp-devel
$ yum install zlib-devel*
```

## 编译安装gcc

```
$ wget https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.gz
$ ./configure --with-system-zlib --disable-multilib --enable-languages=c,c++
$ make -j 8
$ make install
$ strings /lib64/libstdc++.so.6 | grep GLIBC
$ cp /usr/local/lib64/libstdc++.so.6.0.21 /usr/lib64/
$ cd /usr/lib64
$ rm -rf libstdc++.so.6
$ ln -s libstdc++.so.6.0.21 libstdc++.so.6
```

# Install protobuf

```
$ wget https://github.com/google/protobuf/archive/v3.5.1.tar.gz
$ cd protobuf-3.5.1/
$ ./autogen.sh 
$ ./configure --prefix=/usr
$  make && sudo make install && ldconfig
```

# 编译tensorflow 
```
git clone --recurse-submodules  https://github.com/tensorflow/tensorflow
cd tensorflow
git checkout r1.5
./configure # Option choose

GPU option
Do you wish to build TensorFlow with CUDA support? [y/N]: y
CUDA support will be enabled for TensorFlow.

Please specify the CUDA SDK version you want to use, e.g. 7.0. [Leave empty to
default to CUDA 9.0]: 8.0


Please specify the location where CUDA 8.0 toolkit is installed. Refer to
README.md for more details. [Default is /usr/local/cuda]:

Please specify the cuDNN version you want to use. [Leave empty to default to
cuDNN 7.0]:


Please specify the location where cuDNN 7 library is installed. Refer to
README.md for more details. [Default is /usr/local/cuda]:


Please specify a list of comma-separated Cuda compute capabilities you want to
build with.
You can find the compute capability of your device at:
https://developer.nvidia.com/cuda-gpus.
Please note that each additional compute capability significantly increases your
build time and binary size. [Default is: 5.2]


Do you want to use clang as CUDA compiler? [y/N]:
nvcc will be used as CUDA compiler.

Please specify which gcc should be used by nvcc as the host compiler. [Default
is /usr/local/bin/gcc]:


Do you wish to build TensorFlow with MPI support? [y/N]: n
No MPI support will be enabled for TensorFlow.


$ bazel build --config=opt --config=cuda --local_resources 2048,.5,1.0 //tensorflow:libtensorflow_cc.so
```

# 参考链接
* [nvidia CUDA Installation guide](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
* [cuDNN Installation Guide](http://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html)
* [How to install Tensorflow GPU with CUDA and cuDNN](http://www.python36.com/install-tensorflow141-gpu/) 
* [Compiling Bazel from Source](https://docs.bazel.build/versions/master/install-compile-source.html)
* [bazel install](https://docs.bazel.build/versions/master/install-redhat.html)
