# Centos7 安装gcc 5.4.0

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
```



