#!/bin/sh

testMissingArgs() {
 res=`./prog3.sh`
 assertEquals 'Missing data file' "${res}"
}

testFileDoesNotExist() {
 res=`./prog3.sh foo.txt`
 assertEquals 'Missing data file' "${res}"
}

testDirArg() {
 mkdir foo
 res=`./prog3.sh foo`
 assertEquals 'Missing data file' "${res}"
 rm -rf foo
}

testClassAve1() {
 makeInp
 res=`./prog3.sh inp.txt`
 assertEquals 'Class Average does not match!' '14' "${res}"
 cleanup
}

testClassAve2() {
 makeInp
 echo "4 16 16 18 8 20 12" >> ./inp.txt  
 res=`./prog3.sh inp.txt`
 assertEquals 'Class Average does not match!' '14' "${res}"
 cleanup
}

testEqualWtAve() {
 makeInp
 echo "4 16 16 18 8 20 12" >> ./inp.txt
 res=`./prog3.sh inp.txt 5 5 5 5 5 5`
 assertEquals 'Weighted Average does not match!' '14' "${res}"
 cleanup
}

testClassWtAve() {
 makeInp
 res=`./prog3.sh inp.txt 1 2 3 4 5 6`
 assertEquals 'Weighted Average does not match!' '13' "${res}"
 cleanup
}

testDefaultWtAve() {
 makeInp
 res=`./prog3.sh inp.txt 4 5 6`
 assertEquals 'Weighted Average does not match!' '14' "${res}"
 cleanup
}

testIgnoreExtraArgs() {
 makeInp
 res=`./prog3.sh inp.txt 1 2 3 4 5 6 8 9 10 11`
 assertEquals 'Weighted Average does not match!' '13' "${res}"
 cleanup
}


makeInp() {
 echo "ID Q1 Q2 Q3 Q4 Q5 Q6" > ./inp.txt
 echo "1 12 18 20 15 16 10" >> ./inp.txt
 echo "2 10 5 6 8 12 9" >> ./inp.txt
 echo "3 20 20 18 20 19 16" >> ./inp.txt
}

cleanup() {
 rm -rf ./inp.txt
}

. ./tests/shunit2/shunit2
