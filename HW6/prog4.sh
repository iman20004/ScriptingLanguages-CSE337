#!/bin/sh

### ENTER FULL NAME  ###
### ENTER SBU ID  ###
### ENTER NET ID  ###

MISSING_ARGS_MSG="Score directory missing"
ERR_MSG="not a directory"

### Write your code below ###

# Check if required file arg given
if [ $# -ne 1 ]
then 
    echo $MISSING_ARGS_MSG
    exit
fi

# Check input file exists
if ! test -d $1
then
	echo "$1 $ERR_MSG"
    exit 0
fi

for file in "$1"/prob4-score[0-9]*.txt 
do
    awk '
    BEGIN{FS=","}
    NR>1 {for(i=2;i<=NF;i++) sum+=$i} 
    END{
    per=(sum/50)*100 
    if(per >= 93){letter="A";}
    else if(per >= 80){ letter="B";}
    else if(per >= 65){ letter="C";}
    else {letter="D"};
    print $1,":",letter
    }
    ' $file    
    
done