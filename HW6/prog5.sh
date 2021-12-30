#!/bin/sh

### Iman Ali  ###
### 112204305  ###
### imaali  ###

MISSING_ARGS_MSG="input file and  dictionary missing"
BAD_ARG_MSG_1="missing no. of characters"
BAD_ARG_MSG_2="Third argument must be an integer greater than 0"
FILE_NOT_FOUND_MSG="not a file"

### Write your code below ###

# Check first 2 args given
if [ $# -lt 2 ]
then 
    echo "$MISSING_ARGS_MSG"
    exit 0
fi

# Check first 3rd arg given
if [ -z "$3" ]
then 
    echo $BAD_ARG_MSG_1
    exit 0
fi

# Check input file exists
if ! test -f $1
then
	echo "$1 $FILE_NOT_FOUND_MSG"
    exit
fi

# Check dict exists
if ! test -f $2
then
	echo "$2 $FILE_NOT_FOUND_MSG"
    exit
fi

if echo "$3" | grep -q -v '^[1-9]$'; then
    echo $BAD_ARG_MSG_2
    exit 0
fi

# get all words
words=$(grep -E -wo '[-[:alpha:]-]+' $1)

k=0
for word in $words
do
    k=$(($k + 1))
    # Skip words not appropraite length
    if [ ${#word} -ne $3 ]
    then
        continue   
    fi

    if ! grep -qi $word "$2"; then
        misspelled=$(echo $word | tr '[A-Z]' '[a-z]')
        echo "$misspelled; word position=$k"
    fi
done 
