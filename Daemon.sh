

echo "hello shell"
ps |grep lewei|grep -v grep
if [ $? -ne 0 ]
then 
echo "process is not exist"
python lewei_tcp2serial.py&
else
echo "process is on"
fi
