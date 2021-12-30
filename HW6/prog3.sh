#! /bin/sh

### Iman Ali  ###
### 112204305  ###
### imaali  ###

MISSING_ARGS_MSG="Missing data file"

### WRITE CODE AFTER THIS POINT ###

# Check if required file arg given
if [ $# -lt 1 ]
then 
    echo $MISSING_ARGS_MSG
    exit
fi

# Check input file exists
if ! test -f $1
then
	echo $MISSING_ARGS_MSG
    exit 0
fi

# Get num words in first row and subtract by 1 for num parts
first_row=`head -n 1 $1 | wc -w`
parts=$(($first_row - 1))

# Fill the weights array with the appropriate weights given in argument
filename=$1
shift 
j=0
weights=''
for i 
do
    if [ "$j" -lt "$parts" ]
    then
        if [ "$j" -ne 0 ]
        then
            weights="${weights} $i"
        else
            weights="${weights}$i"
        fi
    fi

    j=$(($j + 1))
done

while [ "$j" -lt "$parts" ]
do
    weights="${weights} 1"
    j=$((j+1))
done


# get weighted avg
awk -v w="$weights" '
BEGIN{
split(w,weights," ")
t=0
for(i=1; i in weights; i++) t+=weights[i]
} 
{sum=0
for(i=2;i<=NF;i++) sum+=$i*weights[i-1]
weighted_sum = sum/t
avg_students+=weighted_sum
}
END{print int(avg_students/(NR-1))}
' $filename
 
