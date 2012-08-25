for i in Error*
do
	echo "$i"
	./Parsybone.exe $i 2>/dev/null 1>/dev/null
	if [ $? == 0 ]
	then
		echo "	did not returned error value."
	fi
done
for i in Test*
do
	echo "$i"
	./Parsybone.exe $i 2>/dev/null 1>/dev/null
	if [ $? != 0 ]
	then
		echo "	returned error value."
	fi
done