#! /bin/sh

### Iman Ali  ###
### 112204305  ###
### imaali  ###

MISSING_ARGS_MSG="src and dest missing"
MORE_ARGS_MSG="Exactly 2 arguments required"

### WRITE CODE AFTER THIS POINT  ###

# Check if args provided
if [ $# -eq 0 ]
then 
    echo $MISSING_ARGS_MSG
    exit 0
fi

# Check if less than two inputs provided
if [ $# -gt 2 ]
then 
    echo $MORE_ARGS_MSG
    exit 0
fi

# Check input file exists
if ! test -d $1
then
	echo "src not found"
    exit
fi

# Create or recreate dest dir
if test -d $2 ; then
  rm -rf $2
fi
mkdir $2


for f in $(find "$1" -type f -name '*.c'); 
do 
    if ! test -f $f 
    then
        continue
    fi
    
    parent_dir="$(dirname "${f}")"
    num_files=`find "$parent_dir" -maxdepth 1 -type f -name '*.c'| wc -l`
    
    files=`find "$parent_dir" -maxdepth 1 -type f -name '*.c' -print`
    if [ "$num_files" -gt 3 ]
    then
        echo "Do you want to move these files\?"
        echo "$files"
	    read a
	    case $a in
	    [yY])   mkdir -p "$2/$parent_dir"
                /bin/cp "$parent_dir"/*.c "$2/$parent_dir" 
                rm -rf "$parent_dir"/*.c
 	    esac
    else 
        mkdir -p "$2/$parent_dir"
        /bin/mv $f "$2/$parent_dir"  
    fi

    #remove all empty dirs pls
    find "$1" -empty -type d -delete
done


