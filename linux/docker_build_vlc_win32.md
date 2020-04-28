
# Install debian10 x86_64 by virutal machine

# Install docker-ce
```
# https://docs.docker.com/engine/install/ubuntu/
$ sudo apt-get install docker-ce

$ sudo groupadd docker
$ sudo usermod -aG docker ${USER}
$ docker pull registry.videolan.org:5000/vlc-debian-win64
$ cd ~
$ mkdir win64
$ docker run -v ~/win64:/win64 -i -t registry.videolan.org:5000/vlc-debian-win64 /bin/bash
# updates the docker repositories
$ apt-get update
# installs python on the docker image. Needed to compile Qt stuff later)
$ apt-get install python
$ cd win64
$ git clone https://git.videolan.org/git/vlc
$ cd vlc

# build in one command
$ ./extras/package/win32/build.sh -a x86_64 -i r


Or run step by step
$ mkdir -p contrib/win32
$ cd contrib/win32
$ ../bootstrap --host=x86_64-w64-mingw32 --disable-protobuf
$ make
(... this will take some time so turn off screensaver and go out for lunch)
cd -
./bootstrap
mkdir win32
cd win32
../extras/package/win32/configure.sh --host=x86_64-w64-mingw32 --build=x86_64-pc-linux-gnu
make
make package-win32

```
