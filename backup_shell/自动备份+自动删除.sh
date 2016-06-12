#!/bin/bash
#backup.sh
#备份至/root/bak/
BackupPath=/root/bak/
LogFile=/root/bak/back.log
DBPath=/usr/local/app/   #需要备份的目录
NewFile="$BackupPath"app_back$(date +%y%m%d).tgz
DumpFile="$BackupPath"app_back$(date +%y%m%d)
OldFile="$BackupPath"app_back$(date +%y%m%d --date='7 days ago').tgz
echo "-------------------------------------------" >> $LogFile
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile
echo "--------------------------" >> $LogFile
Delete Old File
if [  -f $OldFile ]
then
   rm -f $OldFile >> $LogFile 2>&1
   echo "[$OldFile]Delete Old File Success!" >> $LogFile
else
   tar cpzvf $NewFile $DBPath >> $LogFile 2>&1
   echo "[$OldFile]No Old Backup File!" >> $LogFile
fi

if [  -f $NewFile ]
then
echo "[$NewFile]The Backup File is exists,Can't Backup!" >> $LogFile

#      tar pczvf $NewFile $DBPath >> $LogFile 2>&1
      echo "[$NewFile]Backup Success!" >> $LogFile
else
   tar cpzvf $NewFile $DBPath >> $LogFile 2>&1
fi
