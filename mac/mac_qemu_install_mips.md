# Install Debian MIPS on OSX with qeum

## Install QEUM
``
# brew install qemu
``

## Install Debian MIPS

### Download vmlinux and initrd
```
$ wget http://ftp.debian.org/debian/dists/stable/main/installer-mipsel/current/images/malta/netboot/initrd.gz
$ wget http://ftp.debian.org/debian/dists/stable/main/installer-mipsel/current/images/malta/netboot/vmlinux-4.19.0-5-4kc-malta
```

### Create the image
```
$ qemu-img create -f qcow2 disk.qcow2 10G 
```

### Install mips debian
```
qemu-system-mipsel -M malta -m 1G \
  -hda ./disk.qcow2 \
  -initrd ./initrd.gz \
  -kernel ./vmlinux-4.19.0-5-4kc-malta -append "nokaslr" \
  -nographic
```

### Run
```
qemu-system-mips -hda disk.qcow2 -kernel ./vmlinux-4.19.0-5-4kc-malta -append "root=/dev/sda1" -nographic
```
