#! /bin/sh

### Iman Ali  ###
### 112204305  ###
### imaali  ###

WRONG_ARGS_MSG="data file or output file missing"
FILE_NOT_FOUND_MSG="file not found"

### WRITE CODE AFTER THIS POINT ###

# Check if less than two inputs provided
if [ $# -ne 2 ]
then 
    echo $WRONG_ARGS_MSG
    exit 0
fi

# Check input file exists
if ! test -f $1
then
	echo "$1 $FILE_NOT_FOUND_MSG"
    exit
fi

# Count all columns and store in array
cat $1 | awk 'BEGIN{FS= ":|;|,"} {for(i=1;i<=NF;i++) array[i]+=$i} END{for(c=1;c in array;c++) print "Col", c, ":", array[c]}' > $2


