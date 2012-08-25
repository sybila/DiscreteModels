#tests that are supposed to raise exception
for i in Error*
do
	echo "$i"
	./Parsybone.exe $i 2>/dev/null 1>/dev/null
	if [ $? == 0 ]
	then
		echo "	did not returned error value."
	fi
done
#tests that are supposed to work out
for i in Test*
do
	echo "$i"
	./Parsybone.exe $i 2>/dev/null 1>/dev/null
	if [ $? != 0 ]
	then
		echo "	returned error value."
	fi
done
#test distribution
echo "Test distribution."
./Parsybone.exe Test_distribute.dbm -d 1 1 -f all.testout
VAR1=`wc -l all.testout`
set -- $VAR1
VAR1=$1
VAR2=0
for i in {1..10}
do
	./Parsybone.exe Test_distribute.dbm -d $i 10 -f $i.testout
	TEMP=`wc -l $i.testout`
	set -- $TEMP
	TEMP=$1
	VAR2=$(($VAR2 + $TEMP))
done
if [ $VAR1 != $VAR2 ]
then
	echo "	distribution failed"
	echo "	value "$VAR1" is not equal sum" $VAR2 
fi
rm *.testout