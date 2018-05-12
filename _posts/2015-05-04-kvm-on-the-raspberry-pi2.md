---
id: 510
title: KVM on the Raspberry Pi2
date: 2015-05-04T01:14:12+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=510
permalink: /2015/05/kvm-on-the-raspberry-pi2/
categories:
  - Debian
  - Hardware
  - Linux
  - Raspberry Pi
  - Ubuntu
  - Uncategorized
---
In my [last post](https://blog.night-shade.org.uk/2015/05/booting-a-raspberry-pi2-with-u-boot-and-hyp-enabled/) I wrote about to getting my Pi2 to boot with HYP enabled on all 4 CPUs. The next stage is to get a kernel with KVM enabled and get a VM up and running. Once again most of this method is taken from a [blog post](http://blog.flexvdi.es/2015/03/17/enabling-kvm-virtualization-on-the-raspberry-pi-2/) by [<s>@</s>sergiolpascual](https://twitter.com/sergiolpascual){.twitter-atreply.pretty-link} I have tidied it up and refined the method of using a single CPU core without patching QEMU.

## Building a KVM enabled kernel for the Pi

First of all you need to get a KVM enabled kernel for the Pi2 host. These commands checkout the current 3.18 version of the Raspberry Pi foundation&#8217;s kernel tree and apply a [pull request](https://github.com/raspberrypi/linux/pull/902) on top of it to enable GIC emulation.

<pre>git clone https://github.com/raspberrypi/linux
cd linux
git checkout rpi-3.18.y
git fetch origin pull/902/head:VGIC-emu
git checkout VGIC-emu</pre>

I started off with the same base config as the kernel on my Pi 2. There is a file /proc/config.gz that stores the config the running kernel was built with. Copy this file to your build host, uncompress it and rename it to /working/rpi2/.config that way you will only need to make a few minor changes to the config.

<pre>scp user@pi:/proc/config.gz /tmp/config.gz
mkdir -p /working/rpi2
zcat /tmp/config.gz &gt; /working/rpi2/.config</pre>

Now we need to setup a cross compile environment again and start the kernel config system.

<pre>export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make O=/working/rpi2 menuconfig
</pre>

I&#8217;ve listed the options that need to be changed to enable KVM support in the kernel, these notes are copied from [<s>@</s>sergiolpascual](https://twitter.com/sergiolpascual){.twitter-atreply.pretty-link}&#8216;s post. I have uploaded my [KVM enabled config](https://blog.night-shade.org.uk/wp-content/uploads/2015/05/config.gz) with these options set already.

Note the O= option this sets the directory where compiled parts of the kernel are put, it means that your source tree stay clean.

  * `Patch physical to virtual translations at runtime`
  * `General setup -> Control Group support`
  * `System Type -> Support for Large Physical Address Extension`
  * `Boot options -> Use appended device tree blob to zImage (EXPERIMENTAL)`
  * `Boot options -> Supplement the appended DTB with traditional ATAG information`
  * `Virtualization -> Kernel-based Virtual Machine (KVM) support (NEW)` 
      * **DISABLE** `Virtualization -> KVM support for Virtual GIC`
      * **ENABLE** `Virtualization -> KVM support for Emulated GIC`

Now you just need to build the kernel and install the modules

<pre>make O=/working/rpi2 all -j 4
export INSTALL_MOD_PATH=/tmp/rpi-kernel
make O=/working/rpi2 modules_install</pre>

To build the Pi2 boot image, glue the kernel and DTB file together thus

<pre>cat /working/rpi2/arch/arm/boot/zImage /working/rpi2/arch/arm/boot/dts/bcm2709-rpi-2-b.dtb &gt; /tmp/rpi-kernel/kernel7.img</pre>

Copy the directory /tmp/rpi-kernel to the Pi2, replace /boot/firmware/kernel7.img (take a backup first) with our new kernel and move the new 3.18.x modules directory to /lib/modules/.

You will need to adjust the Pi&#8217;s kernel command line to add &#8220;isolcpus=3&#8221; to work round a bug. To do this via u-boot run these commands from the u-boot command line:

<pre>setenv "${bootargs} isolcpus=3"
saveenv</pre>

A final reboot and you should get this in dmesg

<pre>dmesg | grep kvm
kvm [1]: timer IRQ99
kvm [1]: Hyp mode initialized successfully</pre>

## Booting your first Virtual Machine

So long as you are running Debian / Raspbian Jessie then you can just run

<pre>apt-get install qemu-system</pre>

Adding the boot option isolcpus=3 works round an oddity of the Raspberry Pi&#8217;s CPU, discussed in more detail in the [original blog post](http://blog.flexvdi.es/2015/03/17/enabling-kvm-virtualization-on-the-raspberry-pi-2/). We need to ensure that QEMU only runs on this isolated CPU. In the original post this was done by patching QEMU but there is a much easier way, taskset. Taskset allows us to restrict QEMU to only CPU 3 with the &#8220;-c 3-3&#8221; option.

This is my basic run script to boot an ARM VM on the Raspberry Pi2. I used the Linaro prebuilt ARM kernels and root images to test with and have included the URLs in the script.

<pre>#!/bin/sh

# Disable the QEMU sound driver
export QEMU_AUDIO_DRV=none

# Basic system setup an ARM vexpress with 1 CPU, 256M of RAM
smp=1
cpu=host
ram=256
machine=vexpress-a15
# Where are the kernel and root images stored
dir=/root/linaro

# Source: <a href="https://snapshots.linaro.org/ubuntu/images/kvm/latest/zImage-armv7">https://snapshots.linaro.org/ubuntu/images/kvm/latest/zImage-armv7</a> 
kernel=$dir/zImage-armv7
# Source: <a href="https://snapshots.linaro.org/ubuntu/images/kvm/latest/vexpress-v2p-ca15-tc1.dtb">https://snapshots.linaro.org/ubuntu/images/kvm/latest/vexpress-v2p-ca15-tc1.dtb</a> 
dtb=$dir/vexpress-v2p-ca15-tc1.dtb
# Source: <a href="http://snapshots.linaro.org/ubuntu/images/kvm-guest/36/armhf/kvm-armhf.qcow2.xz">http://snapshots.linaro.org/ubuntu/images/kvm-guest/36/armhf/kvm-armhf.qcow2.xz</a>
rootfs=$dir/kvm-armhf.qcow2
# Virtual machine Linux command line
cmdline="root=/dev/vda2 rw mem=${ram}M console=ttyAMA0 rootwait rootfstype=ext4"

# Use taskset to ensure that QEMU only runs on cpu 3
taskset -c 3-3 qemu-system-arm -enable-kvm -smp $smp -m $ram -M $machine -cpu host -kernel $kernel -dtb $dtb -append "$cmdline" -drive if=none,id=rootfs,file=$rootfs -device virtio-blk-device,drive=rootfs -netdev user,id=user0 -device virtio-net-device,netdev=user0 -nographic</pre>

&nbsp;