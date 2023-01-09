#!/bin/sh

Dres1=$(date +%s.%N)
let dtD=0

if [ "$1" == "" ]
then
echo "Error: Please provide the name of Smart Contract under verification ."
exit
fi
contractFileName="${1}.sol"
rmvdCmntFile="${1}_wdoutcmnt.sol"
if [ ! -f ./uploadedFiles/$contractFileName ]
then
echo "Error: Given file doesn't exist ."
exit
fi
if [ ! -d "Results" ]
then
mkdir Results
fi

if [ ! -d ./Results/$1 ]
then
mkdir ./Results/$1
fi

if [ ! -d ./Results/$1/BMC ]
then
mkdir ./Results/$1/BMC
fi 
SainitizedContract="${1}_Sanitized.sol";
InterMediateFile="${1}_Intermediate.sol"
cp ./uploadedFiles/$contractFileName ./Results/$1/BMC/$contractFileName
cp ./uploadedFiles/$contractFileName $contractFileName
g++ Comment_Remover.cpp -o .cmntrmv
./.cmntrmv $1
rm $InterMediateFile
mv  $SainitizedContract ./Results/$1/BMC/$contractFileName
g++ assertionInjector.cpp -o .assertinserter
assertionInsertCount=`./.assertinserter ./Results/$1/BMC/$1`
modifiedFile="${1}_mod.sol"
resultFile="${1}_output.txt"
timeout 3600 solc ./Results/$1/BMC/$modifiedFile --model-checker-engine bmc --model-checker-timeout 360 --model-checker-targets assert &>./Results/$1/BMC/$resultFile
outputfile="${1}_Final_Output.txt";
g++ Result_Extractor.cpp -o .resultextractor
./.resultextractor ./Results/$1/BMC/$resultFile ./Results/$1/BMC/$outputfile BMC
grep "assert" ./Results/$1/BMC/$outputfile > ./Results/$1/BMC/.grep_result.txt
cut -d "|" -f 1 ./Results/$1/BMC/.grep_result.txt > ./Results/$1/BMC/.cut_result.txt
sort -n -u ./Results/$1/BMC/.cut_result.txt  > ./Results/$1/BMC/.sort_result.txt
sort -n  ./Results/$1/BMC/.grep_result.txt > ./Results/$1/BMC/Total_Assertions.txt
sort -n -u ./Results/$1/BMC/Total_Assertions.txt > ./Results/$1/BMC/Unique_Assertions.txt
grep "assert" ./Results/$1/BMC/$modifiedFile  >./Results/$1/BMC/Assertions_Insertesd.txt
dynamic=`wc -l < ./Results/$1/BMC/.cut_result.txt`
uniq=`wc -l < ./Results/$1/BMC/.sort_result.txt`
echo "assertion inserted : ${assertionInsertCount}"
echo "assertion violation detected (dynamic) : ${dynamic}"
echo "assertion violation detected (unique) : ${uniq}"
finalOutput="${1}_result.txt"
if [ -f ./Results/$1/BMC/$finalOutput ]
then
rm ./Results/$1/BMC/$finalOutput
fi
echo "assertion inserted : ${assertionInsertCount}" >> ./Results/$1/BMC/$finalOutput
echo "assertion violation detected (dynamic) : ${dynamic}" >> ./Results/$1/BMC/$finalOutput
echo "assertion violation detected (unique) : ${uniq}" >> ./Results/$1/BMC/$finalOutput

Dres2=$(date +%s.%N)
dtD=$(echo "$Dres2 - $Dres1" | bc)
ddD=$(echo "$dtD/86400" | bc)
dtD2=$(echo "$dtD-86400*$ddD" | bc)
dhD=$(echo "$dtD2/3600" | bc)
dtD3=$(echo "$dtD2-3600*$dhD" | bc)
dmD=$(echo "$dtD3/60" | bc)
dsD=$(echo "$dtD3-60*$dmD" | bc)
echo "****************Time Analysis Report - Start**************************" >> Time-$1.txt
echo "***Total runtime in seconds" $dtD >> Time-$1.txt
printf "Total runtime: %d:%02d:%02d:%02.4f\n" $ddD $dhD $dmD $dsD >> Time-$1.txt
echo "****************Time Analysis Report - End**************************" >> Time-$1.txt
cat Time-$1.txt
mv Time-$1.txt ./Results/$1/BMC/
