#!/bin/bash 
# change these per each homework
#	link to tests:
makefileurl="https://webcourse.cs.technion.ac.il/fc159753hw_236360_202202/hw/WCFiles/X2363602022021-Makefile-hw2"
#	number of tests: 
numtests=34
#	command to execute test: 
command="./hw2 < ../compi_hw2_tests_improved/in/t\$i.in >& t\$i_ours.out"
hostname="cscomp"
tmpdir="selfcheck_tmp"
if [ $( hostname ) != "$hostname" ]
	then 
	echo "This script is only intended to run on "$hostname"!" 
	exit 
fi 

if [ -z "$1" ]
	then 
	echo "Usage: $0 submission_file"
	exit 
fi

if [ ! -f "$1" ] 
	then
	echo "Submission zip file not found!" 
	exit 
fi 

rm -rf "$tmpdir" &> /dev/null 

if [ -d "$tmpdir" ] 
	then 
	echo "Cannot clear tmp directory. Please delete '"$tmpdir"' manually and try again" 
	exit 
fi 

mkdir "$tmpdir" &> /dev/null 
unzip "$1" -d "$tmpdir" &> /dev/null 

if [[ $? != 0 ]] 
	then 
	echo "Unable to unzip submission file!" 
	exit
fi

cd "$tmpdir"

if [ ! -f scanner.lex ] 
	then
	echo "File scanner.lex not found!"
	exit
fi

if [ ! -f parser.ypp ] 
	then
	echo "File parser.ypp not found!"
	exit
fi

if [ ! -f output.cpp ] 
	then
	echo "File output.cpp not found!"
	exit
fi

if [ ! -f output.hpp ] 
	then
	echo "File output.hpp not found!"
	exit
fi

wget --no-check-certificate "$makefileurl" -O Makefile-hw2 &> /dev/null
if [ ! -f Makefile-hw2 ]
	then
		echo "Unable to download makefile!"
		exit
fi

make -f Makefile-hw2

if [ ! -f hw2 ] 
	then 
	echo "Cannot build submission!" 
	exit 
fi 

i="1" 

while [ $i -le $numtests ] 
	do 
	eval $command 
	diff t$i_ours.out ../compi_hw2_tests_improved/expected/t$i.out &> /dev/null 
	if [[ $? != 0 ]] 
		then
		echo "Failed test #"$i"!" 
		exit 
	fi
    echo "Passed test #"$i"!" 
	i=$[$i+1] 
done 

cd - &> /dev/null 
rm -rf "$tmpdir" 
echo "Ok to submit :)" 
exit
