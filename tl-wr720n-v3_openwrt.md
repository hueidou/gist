# TP-Link WR720N安装Openwrt

## macOS格式化ext4

```
# 安装工具
brew install e2fsprogs

# 找到分区位置
diskutil list

# 卸载
diskutil unmountdisk /dev/disk2s1

# 格式化
sudo $(brew --prefix e2fsprogs)/sbin/mkfs.ext4 /dev/disk2s1
```

## 构建含有usb模块、ext4模块的镜像

```
# 0、参考：https://openwrt.org/docs/guide-developer/quickstart-build-images

# 1、安装依赖（以ubuntu18.04为例），参考https://openwrt.org/docs/guide-developer/quickstart-build-images
# 实际情况不需要这么多，我的环境（AWS Ubuntu 18.04）实际需安装的只有：
# libncurses5-dev zlib1g-dev build-essential libncursesw5-dev python unzip
sudo apt install subversion g++ zlib1g-dev build-essential git python python3
sudo apt install libncurses5-dev gawk gettext unzip file libssl-dev wget
sudo apt install libelf-dev ecj fastjar java-propose-classpath
sudo apt install build-essential libncursesw5-dev python unzip

# 2、下载源码
git clone https://github.com/openwrt/openwrt.git

# 如果仅是编译这么一次，建议只下载源码包，要小很多
# 下载openwrt源码v17.01.5
wget https://github.com/openwrt/openwrt/archive/v17.01.5.zip

# 3、选择、编译
cd openwrt-17.01.5

make menuconfig

# 选择
# Target System：ar71xx
# Target Profile：tl-wr720n-v3
# Kernel modules：kmod-fs-ext4 kmod-usb-storage kmod-usb-ohci kmod-usb-uhci

# 编译
make

# 目录
ls ./bin/targets/ar71xx/generic
lede-ar71xx-generic-tl-wr720n-v3-squashfs-factory.bin
lede-ar71xx-generic-tl-wr720n-v3-squashfs-sysupgrade.bin
```

## 修改源

```
src/gz reboot_core http://mirrors.ustc.edu.cn/lede/releases/17.01.5/targets/ar71xx/generic/packages
src/gz reboot_base http://mirrors.ustc.edu.cn/lede/releases/17.01.5/packages/mips_24kc/base
src/gz reboot_luci http://mirrors.ustc.edu.cn/lede/releases/17.01.5/packages/mips_24kc/luci
src/gz reboot_packages http://mirrors.ustc.edu.cn/lede/releases/17.01.5/packages/mips_24kc/packages
src/gz reboot_routing http://mirrors.ustc.edu.cn/lede/releases/17.01.5/packages/mips_24kc/routing
src/gz reboot_telephony http://mirrors.ustc.edu.cn/lede/releases/17.01.5/packages/mips_24kc/telephony
```

## 参考

* [Extroot configuration 扩展Root存储](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration)
* [Using storage devices](https://openwrt.org/docs/guide-user/storage/usb-drives)
* [Quick Start for Adding a USB drive](https://openwrt.org/docs/guide-user/storage/usb-drives-quickstart)
* [Installing and troubleshooting USB Drivers](https://openwrt.org/docs/guide-user/storage/usb-installing)
* [Using the Image Builder](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)
* [Quick Image Building Guide](https://openwrt.org/docs/guide-developer/quickstart-build-images)
* [Beginners guide to building your own firmware](https://openwrt.org/docs/guide-user/additional-software/beginners-build-guide)

## 其他

```
https://github.com/pepe2k/u-boot_mod

https://openwrt.org/docs/guide-user/storage/usb-drives


opkg update
opkg install kmod-usb-core
opkg install kmod-usb2                #安装usb2.0
opkg install kmod-usb-ohci            #安装usb ohci控制器驱动
opkg install kmod-usb-storage         #安装usb存储设备驱动
opkg install kmod-fs-ext4             #安装ext4分区格式支持组件 还是ext4格式的U盘读取快
opkg install kmod-fs-vfat             #挂载FAT
opkg install ntfs-3g                  #挂载NTFS
opkg install mount-utils              #挂载卸载工具
opkg install block-mount

opkg install fdisk
fdisk -l  查看挂载的信息，可能是sda
用winscp在/mnt/下建立一个sda1的目录并修改权限
启动项添加一个命令 mount -o rw /dev/sda /mnt/sda1  


https://blog.csdn.net/c5113620/article/details/84368644
https://openwrt.org/zh-cn/doc/howto/build

export LD_LIBRARY_PATH=/tmp/usr/lib

/etc/opkg.conf
option overlay_root /tmp

export PATH=/usr/bin:/usr/sbin:/bin:/sbin:/mnt/sda1/usr/bin:/mnt/sda1/usr/sbin:/mnt/sda1/usr/lib
export LD_LIBRARY_PATH="/mnt/sda1/usr/lib:/mnt/sda1/lib"
```
