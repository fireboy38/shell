#!/bin/bash
date=$(date +%y%m%d)
echo $date >> /root/bak/logfile
find /root/bak/ -name '*' -type f -mtime +5 -exec rm -f {} \;
tar -zvcf /root/bak/etc_$date.tar.gz /etc >> /root/bak/logfile
echo "over" >> /root/bak/logfile