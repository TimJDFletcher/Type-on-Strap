I recently ran a workshop on digital forensics at the FLOSSUK spring conference in York. I noticed that during the workshop a number of the participants struggled with the size of the files I gave them. I handed out a 32GB memory stick, which contained a 32GB compressed Windows XP disk image as well as a 16GB iPhone image. These disk images are mostly zeros and so compress very well meaning that they are only 2-3GB size.

I have been working with large disk images for quite a few years, mainly virtual machine disk images but also forensic disk images. This post has a few tricks I've picked up for working with disk images and large files in general that I hope saves you time, bandwidth and disk space.
Reading and Writing to Files

Most technical people I assume know about cat and dd, on the surface they do similar things however as this stackexchange post details dd has some useful options especially for binary files and raw devices.

dd - I use dd for times when I want to control how data is read or written to pipes and files. An example I use regularly is:

dd if=/path/to/imagefile of=/dev/sdY bs=1M oflag=direct

The options in the command are:
if - input file, in this case a disk image
of - output file, in this case a block device
bs - block size, read and write in 1 megabyte blocks, much more efficient for modern storage
oflag - output flags, in this example direct which means use O_DIRECT and write directly to the storage device. O_DIRECT skips the VFS layer which is a big win if you are just writing a disk image because it prevents flooding your ram cache  and pushing out usefully cached files.

You can use the same idea with dd as part of a pipe to write files efficiently to storage eg:

command | dd of=outputfile bs=1M iflag=fullblock

Here I am using dd to read in the output of another command and reblock it in RAM before to 1M chunks before writing it to storage.
Sparse Files

UNIX has a concept called sparse files, the basic idea is to not store blocks of zeros and instead just store metadata thus saving space. Other systems use the same idea but with different names, for example VMware uses sparse files for thin provisioning. In the storage world I know that both HP 3Par and NetApp ONTAP have "zero block detection" built in to the platform.

Disk images often contain large amounts of empty space filed with zeros, being able to remove these blocks of zeros can save a lot of space. Note in the forensics world empty space is not always empty and you should never change a disk image you are working on.

The best tool for making an existing file sparse from the command line is simple cp

cp --sparse=always /dev/stdin /dev/stdout

You can do this as part of a pipeline using /dev/stdin and /dev/stdout

cp --sparse=always /dev/stdin /dev/stdout

When you write a sparse disk image to a block device most of the time you are just writing zeros to the block device which is a huge waste of time. There is a very useful tool I recently came across called bmap-tool, this will examine a sparse file and find all the data in the file. It then builds a block map and checksum list for those blocks and when you use it to write out the file only writes the blocks with data in. I used this to speed up the imaging process for the company I work so that instead of taking an hour to image a system it takes ~1 minute.

Install bmap-tool

apt-get install bmap-tools

Generate a bmap

bmaptool create imagefile.gz -o imagefile.bmap

Write out a bmap'ed file

bmaptool copy imagefile.gz /dev/sdX

Moving files between systems

netcat
rsync
--inplace
--no-whole-file


pigz - parrell gzip, uses all the cores on modern CPUs
apt-get install pigz


The key message of this post is that in UNIX everything is a file and that you can manipulate the data as it flows in pipelines between different files.
