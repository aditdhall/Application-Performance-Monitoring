#!/bin/bash

start_program()
{
	./APM1 192.168.122.1 &
	./APM2 192.168.122.1 &
	./APM3 192.168.122.1 &
	./APM4 192.168.122.1 &
	./APM5 192.168.122.1 &
	./APM6 192.168.122.1 &
}

kill_program()
{
	k=$( ps -aux | grep APM1 | head -1 | awk '{print $2}' ) 
	kill $k  
	l=$( ps -aux | grep APM2 | head -1 | awk '{print $2}' ) 
	kill $l 
	m=$( ps -aux | grep APM3 | head -1 | awk '{print $2}' ) 
	kill $m 
	n=$( ps -aux | grep APM4 | head -1 | awk '{print $2}' ) 
	kill $n 
	o=$( ps -aux | grep APM5 | head -1 | awk '{print $2}' ) 
	kill $o 
	p=$( ps -aux | grep APM6 | head -1 | awk '{print $2}' ) 
	kill $p 
}

process_level()
{
		
	i=0
	while [ $i -le 900 ]
	do	
		echo pl $i
		ps -aux | grep APM1 | head -1 | awk '{print '$i' "," $3 "," $4}' >> apm1_metrics.csv
	 	ps -aux | grep APM2 | head -1 | awk '{print '$i' "," $3 "," $4}' >> apm2_metrics.csv
		ps -aux | grep APM3 | head -1 | awk '{print '$i' "," $3 "," $4}' >> apm3_metrics.csv
		ps -aux | grep APM4 | head -1 | awk '{print '$i' "," $3 "," $4}' >> apm4_metrics.csv
		ps -aux | grep APM5 | head -1 | awk '{print '$i' "," $3 "," $4}' >> apm5_metrics.csv
		ps -aux | grep APM6 | head -1 | awk '{print '$i' "," $3 "," $4}' >> apm6_metrics.csv
		
		sleep 5s
		i=$(($i+5))		
	done	

}

system_metrics()
{
	
	a=0
	while [ $a -le 900 ]
	do 
		echo ms $a
		echo $a > time.txt
		ifstat | grep ens | awk '{print "," $6 "," $8 ","}' > sm1.txt 
		iostat |grep sda | awk '{print $3 ","}' > sm2.txt
		df -m | grep /dev/mapper/centos-root | awk '{print $4}' > sm3.txt
		paste -d "" time.txt sm1.txt sm2.txt sm3.txt >> system_metrics.csv
		
		sleep 1s
		a=$(($a+1))
		
	done
}

start_program

process_level & system_metrics

kill_program

echo finish


