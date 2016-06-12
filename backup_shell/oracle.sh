#!/bin/sh
# @Author: dsmason
# @Date:   2016-06-12 23:58:21
# @Last Modified by:   anchen
# @Last Modified time: 2016-06-13 00:02:07
#!/bin/sh
export ORACLE_BASE=/data/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_SID=orcl
export ORACLE_TERM=xterm
export PATH=$ORACLE_HOME/bin:/usr/sbin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export LANG=C
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
#以上代码为Oracle数据库运行账号oracle的系统环境变量设置，必须添加，否则crontab任务计划不能执行。
# oracle用户的系统环境变量路径：/home/oracle/.bash_profile
date=date +%Y_%m_%d   #获取系统当前日期时间
days=7  #设置删除7天之前的备份文件
orsid=192.168.0.198:1521/orcl  #Oracle数据库服务器IP、端口、SID
orowner=OSYUNWEI  #备份此用户下面的数据
bakuser=OSYUNWEI  #用此用户来执行备份，必须要有备份操作的权限
bakpass=OSYUNWEI  #执行备注的用户密码
bakdir=/backup/oracledata  #备份文件路径，需要提前创建好
bakdata=$orowner"_"$date.dmp #备份数据库名称
baklog=$orowner"_"$date.log #备份执行时候生成的日志文件名称
ordatabak=$orowner"_"$date.tar.gz #最后保存的Oracle数据库备份文件
cd $bakdir #进入备份目录
mkdir -p $orowner #按需要备份的Oracle用户创建目录
cd $orowner #进入目录
exp $bakuser/$bakpass@$orsid grants=y owner=$orowner file=$bakdir/$orowner/$bakdata log=$bakdir/$orowner/$baklog #执行备份
tar -zcvf $ordatabak $bakdata  $baklog  #压缩备份文件和日志文件
find $bakdir/$orowner  -type f -name "*.log" -exec rm {} \; #删除备份文件
find $bakdir/$orowner  -type f -name "*.dmp" -exec rm {} \; #删除日志文件
find $bakdir/$orowner  -type f -name "*.tar.gz" -mtime +$days -exec rm -rf {} \;  #删除7天前的备份（注意：{} \中间有空格）
