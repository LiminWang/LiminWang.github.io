% caffed 安装方法

# 关于caffe
caffe是深度学习在图像领域广泛使用的框架，其model zoo有大量的预训练好的模型提供使用。大部分图像相关的应用部分将用到caffe。

# 测试系统
CentOS 7.2

# 安装依赖包
## 换国内sohu或者163的源 
```sh
$ sudo rpm -Uvh http://mirrors.sohu.com/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
$ sudo yum repolist
```

##  安装基本依赖
```sh
$ sudo yum install git gcc g++ autoconf automake libtool perl help2man libstdc++-devel gcc-c++  \
atlas-devel boost-devel protobuf-devel opencv-devel snappy-devel cmake protobuf-c-compiler protobuf-compiler

##  安装科学计算和python所需的部分库
$ sudo yum install openblas-devel.x86_64 gcc-c++.x86_64 numpy.x86_64 scipy.x86_64 python-matplotlib.x86_64 \
lapack-devel.x86_64 python-pillow.x86_64 libjpeg-turbo-devel.x86_64 freetype-devel.x86_64 libpng-devel.x86_64 openblas-devel.x86_64

```

##  需要编译的包
### automake(需要>1.4版本)

```sh
$ wget http://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz
$ tar -xvf automake-1.14.tar.gz && cd automake-1.14 && ./configure && make && sudo make install
```

### 安装 gflags

```sh
$ git clone https://github.com/gflags/gflags
$ cd gflags && mkdir build && cd build
$ export CXXFLAGS="-fPIC" && cmake ..
$ make VERBOSE=1 && sudo make install
```

### 安装 glog

```sh
$ git clone https://github.com/google/glog
$ cd glog
$ ./autogen.sh && ./configure && make && automake --add-missing && sudo make install
```

### 安装 lmdb

```sh
$ git clone https://github.com/LMDB/lmdb
$ cd lmdb/libraries/liblmdb
$ make
$ sudo make install
```

### 安装 hdf5

```sh
$ wget https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.19.tar.gz
$ tar -xvf hdf5-1.8.19.tar.gz 
$ cd hdf5-1.8.19 && ./configure --prefix=/usr/local && make && sudo make install
```

### OpenBLAS

```
$ git clone https://github.com/xianyi/OpenBLAS
$ cd OpenBLAS && make && sudo make PREFIX=/usr/local install
```

### 安装 leveldb
leveldb 已经被caffe推荐不使用了，可以在Makefile.config中将USE_LEVELDB := 0 注释掉，就不用安装了


## python 安装easy_install和pip
### 安装easy_install
下载地址:https://pypi.python.org/pypi/ez_setup

```sh
$ wget https://pypi.python.org/packages/ba/2c/743df41bd6b3298706dfe91b0c7ecdc47f2dc1a3104abeb6e9aa4a45fa5d/ez_setup-0.9.tar.gz
$ $ tar zxvf ez_setup-0.9.tar.gz && cd ez_setup-0.9 && sudo python ez_setup.py 
```
### 安装pip
下载地址: https://pypi.python.org/pypi/pip
$ wget https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz
$ tar zxvf pip-9.0.1.tar.gz  && cd pip-9.0.1 && sudo python setup.py install 


# 安装caffe
## 安装python依赖

```sh
$ cd caffe/python
$ for req in $(cat requirements.txt); do sudo pip install $req; done
```

## 编译安装
```
$ git clone https://github.com/BVLC/caffe
$ cd caffe
$ cp Makefile.config.example Makefile.config
$ vim Makefile.config
$ diff -u Makefile.config.example Makefile.config
-- Makefile.config.example  2017-09-15 15:03:51.505056949 +0800
+++ Makefile.config 2017-09-15 15:48:06.454564902 +0800
@@ -5,11 +5,11 @@
 # USE_CUDNN := 1

 # CPU-only switch (uncomment to build without GPU support).
-# CPU_ONLY := 1
+ CPU_ONLY := 1

 # uncomment to disable IO dependencies and corresponding data layers
 # USE_OPENCV := 0
-# USE_LEVELDB := 0
+ USE_LEVELDB := 0
 # USE_LMDB := 0

 # uncomment to allow MDB_NOLOCK when reading LMDB files (only if necessary)
@@ -47,7 +47,7 @@
 # atlas for ATLAS (default)
 # mkl for MKL
 # open for OpenBlas
-BLAS := atlas
+BLAS := open
 # Custom (MKL/ATLAS/OpenBLAS) include and lib directories.
 # Leave commented to accept the defaults for your choice of BLAS
 # (which should work)!
@@ -57,6 +57,7 @@
 # Homebrew puts openblas in a directory that is not on the standard search path
 # BLAS_INCLUDE := $(shell brew --prefix openblas)/include
 # BLAS_LIB := $(shell brew --prefix openblas)/lib
+BLAS_INCLUDE := /usr/include/openblas

 # This is required only if you will compile the matlab interface.
 # MATLAB directory should contain the mex binary in /bin.
$ make -j4

$ make test
$ sudo ldconfig /usr/local/lib
$ make runtest
```

# 编译pycaffe

```sh
make pycaffe -j4
```




