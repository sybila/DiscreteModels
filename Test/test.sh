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
echo "Conducting the basic general check."
$PARSYBONE check_basic.dbm -Wr -f check.out
if [[ `cat check.out` != "0:(0,0,2,1,1,2,1,0):7:0.25:{(0,0;0)>(0,1;1),(0,1;1)>(1,1;1),(1,1;1)>(2,1;2),(1,1;1)>(1,2;2),(2,1;2)>(2,2;2),(2,1;3)>(1,1;3),(1,2;2)>(2,2;2),(1,2;3)>(1,1;3),(2,2;2)>(2,1;3),(2,2;2)>(1,2;3)}" ]]
then
	echo "	output differs."
	((ERROR_COUNT++))
fi
echo "Conducting test of parametrization specification."
$PARSYBONE check_parametrized.dbm -wr -f check.out
if [[ `head -1 check.out` != "0:(1,2,2,0,2,2,2,2,1,0,0,1,0,0,1,0,3,0,2,0,1,0,0,0):9:0.09722222222222221:{0>13,0>25,0>97,13>37,13>109,25>37,25>121,34>10,37>133,97>101,97>109,97>121,101>113,101>125,106>10,109>113,109>133,113>137,121>133,125>137,129>34,129>106,133>137,137>141,141>129}" ]]
then
	echo "	output differs."
	((ERROR_COUNT++))
fi
rm check.out
echo "Conducting check of the edge labels logic."
$PARSYBONE check_labels.dbm -W -f check.out
if [[ `head -1 check.out` != "0:(1,0,1,1,0,1,1,0):5::{(0,0;0)>(1,0;1),(1,0;1)>(1,1;1),(1,0;2)>(0,0;2),(1,1;1)>(1,0;2)}" ]]
then
	echo "	output differs."
	((ERROR_COUNT++))
fi
rm check.out

#output restults
echo "-"
if [[ $ERROR_COUNT == 0 ]]
then
	echo "Tests completed. No error found."
else
	echo "There were "$ERROR_COUNT" errors in the test session."
fi
