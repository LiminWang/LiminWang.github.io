# tensorflow C++静态编译

# Ubuntu 16.04
```
$ sudo apt-get install autoconf automake libtool curl make g++ unzip zlib1g-dev git python
$ git clone https://github.com/tensorflow/tensorflow
$ cd tensorflow
$ git checkout r1.4
$ ./tensorflow/contrib/makefile/download_dependencies.sh
$ ./tensorflow/contrib/makefile/build_all_linux.sh
```

# Centos 7.2

```
$ sudo yum install autoconf automake libtool curl make g++ unzip zlib1g-dev git python
$ git clone https://github.com/tensorflow/tensorflow
$ cd tensorflow
$ git checkout r1.4
$ ./tensorflow/contrib/makefile/download_dependencies.sh
$ ./tensorflow/contrib/makefile/build_all_linux.sh
```


