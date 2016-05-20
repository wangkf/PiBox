#!/bin/sh
dir=`dirname ${0}`
dir2="${PWD}/${dir}"
cd ${dir2}

echo '+---+   +    + +---+ +-+-+ +--+'
echo '|   |   |    | |   | | | | |   '
echo '|   | + |    | |   | | | | +--+'
echo '+---+   +----+ |   | | | | |   '
echo '|     + |    | |   | | | | |   '
echo '|     | +    + +---+ + + + +--+'
echo '|     |                        '
echo '+     +            你好，物联网'

ret=`netstat -an |grep 8000`
if [ "$ret" ];then
   echo '一个程序已使用 8000 端口'
   exit
fi
ret=`netstat -an |grep 8001`
if [ "$ret" ];then
   echo '一个程序已使用 8001 端口'
   exit
fi
ret=`netstat -an |grep 3333`
if [ "$ret" ];then
   echo '一个程序已使用 3333 端口'
   exit
fi

echo "注意 : 如果你在浏览器中不能看到任何信息，请检查位于 log/pihome.log 的日志文件"

ip=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`

echo "http://$ip:8000  或其他"

nohup ./CppClient/pihome > ./log/cpp.log 2>&1 &  
nohup python ./PiHome/WebShell/webshell.py --ssl-disable 0 > ./log/pihome-webshell.log 2>&1 & 
nohup python ./PiHome/manage.py runserver 0.0.0.0:8000 > ./log/pihome.log 2>&1 & 
