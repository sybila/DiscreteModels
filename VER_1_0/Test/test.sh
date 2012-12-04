#must have executable as a first parameter
PARSYBONE=$1
ERROR_COUNT=0

#tests that are supposed to raise exception
echo "Conducting control of errornous specification detection."
for i in error*.dbm
do
	$PARSYBONE $i 2>/dev/null 1>/dev/null
	if [[ $? != 1 && $? != 2 ]]
	then
		echo "$i"
		echo "	did not returned error value."
		((ERROR_COUNT++))
	fi
done

#tests that are supposed to work out
echo "Conducting test of correct specifications."
for i in test*.dbm
do
	$PARSYBONE $i 2>/dev/null 1>/dev/null
	if [ $? != 0 ]
	then
		echo "$i"
		echo "	returned error value."
		((ERROR_COUNT++))
	fi
done

#test distribution
echo "Conducting test of distributed computation."
$PARSYBONE check_distribution.dbm -d 1 1 -f all.testout
VAR1=`wc -l all.testout`
set -- $VAR1
VAR1=$1
VAR2=0
for i in {1..10}
do
	$PARSYBONE check_distribution.dbm -d $i 10 -f $i.testout
	TEMP=`wc -l $i.testout`
	set -- $TEMP
	TEMP=$1
	VAR2=$(($VAR2 + $TEMP))
done
if [ $VAR1 != $VAR2 ]
then
	echo "	distribution failed"
	echo "	value "$VAR1" is not equal sum" $VAR2 
	((ERROR_COUNT++))
fi
rm *.testout

#test correctnes

#output restults
echo "-"
if [[ $ERROR_COUNT == 0 ]]
then
	echo "Tests completed. No error found."
else
	echo "There were "$ERROR_COUNT" errors in the test session."
fi
