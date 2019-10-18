# Install Debian MIPS on OSX with qeum

## Install QEUM
``
# brew install qemu
``

## Install Debian MIPS

### Download vmlinux and initrd

If name is changed , please check it by:
http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/

```
$ wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/initrd.gz
$ wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/vmlinux-4.19.0-6-4kc-malta

```

### Create the image
```
$ qemu-img create -f qcow2 hda.img 10G
```

### Install mips debian
```
$ qemu-system-mips -M malta \
  -cdrom ./debian-10.1.0-mips-DVD-1.iso \
  -m 512 -hda hda.img \
  -kernel vmlinux-4.19.0-6-4kc-malta \
  -initrd initrd.gz \
  -append "console=ttyS0 nokaslr" \
  -nographic
```

### Install SSH server
software selection, choose SSH server

### Copy over Kernel initrd.img file

During the installation stage you’ll see this screen warning us that no bootloader has been installed.

Before you can use the freshly installed MIPS image you first need to extract the Kernel initrd.img-[version] file found in the /boot partition of the image. We must manually copy it by mounting the image and executing a few commands.

Mount the boot partition of the image file:
sudo modprobe nbd max_part=63
sudo qemu-nbd -c /dev/nbd0 hda.img
sudo mount /dev/nbd0p1 /mnt
Copy a single file or the entire folder to the current directory:
cp -r /mnt/boot/initrd.img-4.19.0-6-4kc-malta .  # copy only initrd.img file
cp -r /mnt/boot .                               # copy the entire boot folder
Unmount the image:
sudo umount /mnt
sudo qemu-nbd -d /dev/nbd0


### Network
* host
```
lmwang@debian10:~$ sudo apt-get install vde2 uml-utilities dnsmasq
```

sudo modprobe tun
sudo addgroup lmwang vde2-net
sudo ifup mytap
sudo /etc/init.d/dnsmasq restart
sudo newgrp vde2-net


### Run
```
$ qemu-system-mips -M malta \
  -cdrom ./debian-10.1.0-mips-DVD-1.iso \
  -m 512 -hda hda.img \
  -kernel vmlinux-4.19.0-6-4kc-malta \
  -initrd initrd.img-4.19.0-6-4kc-malta \
  -append "root=/dev/sda1 console=ttyS0 nokaslr" \
  -nographic \
  -device e1000-82545em,netdev=user.0 \
  -netdev user,id=user.0,hostfwd=tcp::5555-:22
```
The last option enables port forwarding on host machine port 5555 to the guest machine on port 22 for ssh communication.

The last option enables port forwarding on host machine port 5555 to the guest machine on port 22 for ssh communication.

To access the guest machine from Host machine to upload a file:

$ scp -P 5555 file.txt root@localhost:/tmp
Or to connect via ssh:

$ ssh root@localhost -p 5555

### Exit qemu
If you want to exit qemu under nographic:
press ctrl+a, then c (no ctrl), type quit, hit enter.

