#!/bin/bash
#备份至/root/dbxxxxx.tgz
#This is a ShellScript For Auto DB Backup
#Powered by aspbiz
#Setting
DBName=mysql
DBUser=root
DBPasswd=123456
BackupPath=/root/
LogFile=/root/db.log
DBPath=/var/lib/mysql/
#BackupMethod=mysqldump
#BackupMethod=mysqlhotcopy
#BackupMethod=tar
#Setting End


NewFile="$BackupPath"db$(date +%y%m%d).tgz
DumpFile="$BackupPath"db$(date +%y%m%d)
OldFile="$BackupPath"db$(date +%y%m%d --date='30 days ago').tgz

echo "-------------------------------------------" >> $LogFile
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile
echo "--------------------------" >> $LogFile
#Delete Old File
if [ -f $OldFile ]
then
   rm -f $OldFile >> $LogFile 2>&1
   echo "[$OldFile]Delete Old File Success!" >> $LogFile
else
   echo "[$OldFile]No Old Backup File!" >> $LogFile
fi

if [ -f $NewFile ]
then
   echo "[$NewFile]The Backup File is exists,Can't Backup!" >> $LogFile
else
   case $BackupMethod in
   mysqldump)
      if [ -z $DBPasswd ]
      then
         mysqldump -u $DBUser --opt $DBName > $DumpFileelse
         mysqldump -u $DBUser -p$DBPasswd --opt $DBName > $DumpFile
      fi
      tar czvf $NewFile $DumpFile >> $LogFile 2>&1
      echo "[$NewFile]Backup Success!" >> $LogFile
      rm -rf $DumpFile
      ;;
   mysqlhotcopy)
      rm -rf $DumpFile
      mkdir $DumpFile
      if [ -z $DBPasswd ]
      then
         mysqlhotcopy -u $DBUser $DBName $DumpFile >> $LogFile 2>&1
      else
         mysqlhotcopy -u $DBUser -p $DBPasswd $DBName $DumpFile >>$LogFile 2>&1
      fi
      tar czvf $NewFile $DumpFile >> $LogFile 2>&1
      echo "[$NewFile]Backup Success!" >> $LogFile
      rm -rf $DumpFile
      ;;
   *)
      /etc/init.d/mysqld stop >/dev/null 2>&1
      tar czvf $NewFile $DBPath$DBName >> $LogFile 2>&1
      /etc/init.d/mysqld start >/dev/null 2>&1
      echo "[$NewFile]Backup Success!" >> $LogFile
      ;;
   esac
fi
