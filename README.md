# meta-clusterbone

This was built under Ubuntu 14.04 64 bits. Make sure these packages ara available in your system:

```
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath libsdl1.2-dev xterm
```

Create the working directory and get the needed repos (one of those it's this one, yay!):

```
$ mkdir -p ~/clusterbone/yocto
$ cd ~/clusterbone/yocto
$ git clone -b jethro http://git.yoctoproject.org/git/poky
$ cd poky
$ git clone -b jethro git://git.openembedded.org/meta-openembedded oe-core
$ git clone https://github.com/simium/meta-clusterbone.git
```

Source the build environment variables:

```
$ source oe-init-build-env
```

Edit bblayers.conf and make sure you add the missing meta layers:

```
~/clusterbone/yocto/poky/oe-core/meta-networking \
~/clusterbone/yocto/poky/oe-core/meta-oe \
~/clusterbone/yocto/poky/oe-core/meta-python \
~/clusterbone/yocto/poky/meta-clusterbone \
```

Edit local.conf and add at least the MACHINE line. The other lines make the build process more comfortable for me:
```
MACHINE = "beaglebone"
PARALLEL_MAKE = "-j2"
BB_NUMBER_THREADS = "2"
INHERIT += " rm_work "
```

Now build the console image (based on the amazing work made by [jumpnowtek and their meta-bbb](https://github.com/jumpnow/meta-bbb))
```
bitbake console-image
```

After the build is complete you may load the SD card with the produced Linux image:
```
cd ~/clusterbone/yocto/poky/meta-clusterbone/scripts
sudo ./mkcard.sh /dev/mmcblk0
sudo ./populatecard.sh /dev/mmcblk0
```
