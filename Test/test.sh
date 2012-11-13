#must have executable as a first parameter
PARSYBONE=$1
#tests that are supposed to raise exception
for i in Error*.dbm
do
	echo "$i"
	$PARSYBONE $i 2>/dev/null 1>/dev/null
	if [ $? == 0 ]
	then
		echo "	did not returned error value."
	fi
done
#tests that are supposed to work out
for i in Test*.dbm
do
	echo "$i"
	$PARSYBONE $i 2>/dev/null 1>/dev/null
	if [ $? != 0 ]
	then
		echo "	returned error value."
	fi
done
#test distribution
echo "Checking correctness of distribution."
$PARSYBONE Check_distribution.dbm -d 1 1 -f all.testout
VAR1=`wc -l all.testout`
set -- $VAR1
VAR1=$1
VAR2=0
for i in {1..10}
do
	$PARSYBONE Check_distribution.dbm -d $i 10 -f $i.testout
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
#test correctnes
echo "Checking correctness of results1."
$PARSYBONE Check_results.dbm -Wr -f check.out
if [[ `cat check.out` != "0:(0,0,2,1,1,2,1,0):7:0.25:{(0,0;0)>(0,1;1),(0,1;1)>(1,1;1),(1,1;1)>(2,1;2),(1,1;1)>(1,2;2),(2,1;2)>(2,2;2),(2,1;3)>(1,1;3),(1,2;2)>(2,2;2),(1,2;3)>(1,1;3),(2,2;2)>(2,1;3),(2,2;2)>(1,2;3)}" ]]
then
	echo "	results differ."
fi
echo "Checking correctness of results2."
$PARSYBONE Check_results2.dbm -wr -f check.out
if [[ `head -1 check.out` != "0:(1,2,2,0,2,2,2,2,1,0,0,1,0,0,1,0,3,0,2,0,1,0,0,0):9:0.09722222222222221:{0>13,0>25,0>97,13>37,13>109,25>37,25>121,34>10,37>133,97>101,97>109,97>121,101>113,101>125,106>10,109>113,109>133,113>137,121>133,125>137,129>34,129>106,133>137,137>141,141>129}" ]]
then
	echo "	results differ."
fi
rm check.out
