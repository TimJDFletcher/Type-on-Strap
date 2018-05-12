There is a feature in mdadm (check version + kernel) that allows online
replacment of a working drive in a raid array. The old method was to fal
the drive out and then allow the raid to rebuild, this was a risk
window.

My RAID setup is a 5 disk RAID5, split over partition 2 and 3 for
hisotric reasons, in thei case I'm replacing sda with sdd.

In partaration I have run a 4 pass badblock on the new drive, to avoid
any nasty early life falures. The server has an external eSATA dock so
the drive was tested in that and once it had passed I shut the server
down swatched the disk from the drive cage to the esata and put the new
drive in the drve cage.

new=sdd
old=sda

sgdisk -R /dev/$new /dev/sdX
sgdisk -G /dev/$new

mdadm --manage /dev/md1 --add /dev/${new}2
mdadm --manage /dev/md2 --add /dev/${new}3

mdadm --manage /dev/md1 --replace /dev/${old}2 --with /dev/${new}2
sleep 300m
mdadm --manage /dev/md2 --replace /dev/${old}3 --with /dev/${new}3

mdadm --manage /dev/md1 --remove failed
mdadm --manage /dev/md2 --remove failed

/usr/share/mdadm/mkconf  | tee /etc/mdadm/mdadm.conf
update-initramfs -k all -u

update-grub
for dev in sd{a,b,c,d,e,f} ; do grub-install /dev/$dev ; done

badblocks -b 4096 -c 1024 -s -w -v /dev/${old}
