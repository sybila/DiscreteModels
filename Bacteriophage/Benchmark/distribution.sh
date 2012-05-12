#Run distribution benchmark

a=1
while [ "$a" -lt 9 ]
do
	b=1
	while [ "$b" -lt "$a" ]
	do
		../../../Parsybone/GCCProject/Parsybone -st < model.dbm -D "$b" "$a" >> output.out
		b=`expr $b + 1`
	done
	a=`expr $a + 1`
done 