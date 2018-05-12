This started off as part of a post about working with disk images I am writing but it didn't feel like quite the right place for it.

ddrescue is a data recovery focused version of dd that will retry reads in various ways to try and read data off damaged disks. It keeps track of the sectors that have been read successfully so you can keep retrying the copying process without rereading the entire device. I have used this to recover nearly all data from broken harddisks and memory sticks.

Install ddrescue

apt-get install gddrescue

First copy as much data as possible quickly, without retrying or splitting sectors.

ddrescue --no-split /dev/source imagefile logfile

Now retry sectors previously showing errors 3 times, using uncached reads

ddrescue --direct --max-retries=3 /dev/source imagefile logfile

If that fails try again but retrimmed, meaning ddrescue tries to read a larger section of disk and pick out just the small piece needed.

ddrescue --direct --retrim --max-retries=3 /dev/source imagefile logfile
