# How to cross compile mips for FFmpeg

## Install the OS
Please use ubuntu 16.04.6 for the testing

## install mips cross software
```
sudo apt-get -y install emdebian-archive-keyring
sudo apt-get -y install linux-libc-dev-mips-cross
sudo apt-get -y install libc6-mips-cross libc6-dev-mips-cross
sudo apt-get -y install binutils-mips-linux-gnu gcc-mips-linux-gnu
sudo apt-get -y install gcc-mips-linux-gnu
sudo apt-get -y install g++-mips-linux-gnu

sudo apt-get -y install qemu
```


## How to check the result

```
mips-linux-gnu-gcc  -dumpmachine
```

successd if print below info:
mips-linux-gnu


## build ffmpeg
```
 ./configure --enable-gpl --enable-cross-compile --target-os=linux --cross-prefix=mips-linux-gnu- --arch=mips \
 --target-exec='qemu-mips -L /usr/mips-linux-gnu/ -cpu 74Kf' --extra-ldflags=-static \
 --disable-pthreads --disable-mipsdspr2 --disable-mipsfpu --disable-mips32r6 --disable-mips64r6 \
 --disable-asm --disable-optimizations \
 --disable-network --disable-hwaccels
 ```

## run it
```
./ffmpeg 
```

