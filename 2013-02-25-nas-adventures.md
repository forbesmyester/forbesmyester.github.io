# NAS Adventures...



## The Product

I currently am an owner of a Thecus N3200pro NAS. I bought it because it has three disk bays, so can do RAID5 and was similarly priced to a very cheap PC. I was happy with it at first...

## The Problem

Later on I wanted to try out git-annex and noticed that it was not doing NFS locking correctly so I tried to updated to the new firmware. Unfortunately this new firmware added frilly Flash based graphics and completely broke NFS. As I spend most of my time in Linux compared to Windows this is a real problem.

## Attempt 1 - Customer Support

I contacted support which responded in 5 days, telling me that I had to make the shares public (yeh great), which I had already read about, had done and included in my support request! I responded and waited 25 days to be told that my query had been forwarded onto head office. This was in September 2012 and I have not heard anything since so I would not recommend Thecus.

## Attempt 2 - Install my own Linux on it!

### The Installation

I came across [this link](http://forum.thecus.com/viewtopic.php?f=14&t=2954) on Thecus's own forums. and decided to give it a go. I did not quite want to do it that way as I wanted to go for an Ubuntu server based system.

The biggest problem I found was that Ubuntu Server now requires PAE extensions for installation. PAE allows non 64 bit CPU's to access memory above 4GB, the Thecus device definitely does not need this feature and the AMD Geode processor inside the N3200Pro does not have it.

Google saved me by pointing me to an [article](http://www.webupd8.org/2012/05/how-to-install-ubuntu-1204-on-non-pae.html) linking to a mini.iso which could work without PAE. I was set!

### Bad RAID

The Thecus firmware storage device, which looks like a primary hard disk to the BIOS, but is probably flash (there is no physical disk) seem to have two RAID devices /dev/md50 and /dev/md10. I'll leave that to your imagination what the point is of having raid on a single flash drive is...

Unfortunately one of those seems to be degraded and because of this Ubuntu refuses to boot without keyboard interaction. This is also silly because it's meant to be a server OS and as such might well be running headless in a remote location.

Anyway to fix this I changed one line in `/etc/default/grub` from

```
GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"
```

to

```
GRUB_CMDLINE_LINUX_DEFAULT="splash quiet bootdegraded=true"
```

I still cared somewhat about keeping the original firmware working, but not enough to worry about the raid being degraded.

The Ubuntu bug is [here](https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/872220)

### Will not boot after error

For some reason the Ubuntu people seem to feel that if a system errors, the best course of action is to make a user select which kernel to use, as that could be the source of the problem... Again the server requires manual intervention to make it boot...

The Ubuntu bug is [here](https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/669481)

Thankfully the [fix](https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/669481/comments/13) was easy to find in the bug report itself.

### Booting off Thecus Flash instead of my USB

After having done all this and configured NFS / ACL / Git / Mercurial I was ready to move the server into it's final home so I unplugged it, moved it and plugged it into it's new location. On next boot, it booted the Thecus firmware!

I took it back to where I could get a keyboard/monitor to it and found that it had lost the boot sequence I had put into the BIOS. It does not seem capable of keeping the boot status across power disconnections.

Now being completely ticked off with this box I decided to use the 128Mb flash disk Thecus put in it and use it as my /boot partition.

First I booted an XUbuntu Live CD, mounted my RAID disk and backed up the Thecus firmware (the drive is only 128MB).

```
mkdir /tmp/raid
mount /dev/md0 /tmp/raid
dd if=/dev/sdb /tmp/raid/thecus_firmware.bin
```

Later on I bzip2'd this and put it somewhere safe.

Referencing [this help.ubuntu.com article](https://help.ubuntu.com/community/CreateBootPartitionAfterInstall) and other articles I followed these steps:

1. Used `cfdisk` to repartition the flash into one partition.
2. Mounted the USB drive that I was using as my root partition along with the newly created flash partition using `mkdir /tmp/my_root /tmp/boot; mount /dev/sdf /tmp/my_root; mount /dev/sdb /tmp/boot/`.
3. Copied the data from my old /boot to the flash with `cp /tmp/my_root/boot /tmp/boot`.
4. Used `umount /tmp/boot; mount /dev/sdb /tmp/my_root/boot` to remount the flash into it's proper location.
5. Used `blkid` to identify the UUID's of the partitions for the new /boot partition and added it to the `/etc/fstab` file.
6. Ran `grub-install --root-directory=/mnt/my_root /dev/sdb` to put grub onto the internal flash drive also... Take that Thecus!

After all this I did consider the whole thing to be done, but I woke up the day after thinking that if the kernel gets upgraded, the grub configuration file might be rewrote to point to my USB thumb drive I am booted from, not the Thecus flash drive. Remembering that it asks you about where to install Grub on Ubuntu installation I figured that reconfiguring the package would probably update any configuration file references.

```
# dpkg-reconfigure grub-pc
```

Followed it through, ticked the Thecus flash drive and I'm done.

The only other thing I need to watch out for is that now my `/boot` partition is pretty small, so when the kernel is being updated I want to make sure that there are not too many old copies lying around, because they all take space and I think running out of space on `/boot` might be bad. I have successfully followed [these](http://tombuntu.com/index.php/2007/10/17/remove-ubuntu-kernels-you-dont-need/) instructions on how to remove old kernels.

