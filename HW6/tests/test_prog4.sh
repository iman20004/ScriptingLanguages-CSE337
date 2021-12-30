#! /bin/sh

testScores1() {
 makeScoreFiles
 res=`./prog4.sh ./scores | grep -w "111 : B" | wc -l`
 assertEquals "111 : B not found" '1' "${res}" 
 res=`./prog4.sh ./scores | grep -w "222 : C" | wc -l`
 assertEquals "222 : C not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "333 : C" | wc -l`
 assertEquals "333 : C not found" '1' "${res}"
 cleanup
}

testScores2() {
 makeScoreFiles
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/prob4-score10.txt
 echo "444,1,1,1,1,1" >> ./scores/prob4-score10.txt
 res=`./prog4.sh ./scores | grep -w "444 : D" | wc -l`
 assertEquals "444 : D not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "111 : B" | wc -l`
 assertEquals "111 : B not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "222 : C" | wc -l`
 assertEquals "222 : C not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "333 : C" | wc -l`
 assertEquals "333 : C not found" '1' "${res}"
 cleanup
}

testScore3() {
 makeScoreFiles
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/prob4-score10.txt
 echo "444,10,8,10,9,10" >> ./scores/prob4-score10.txt
 res=`./prog4.sh ./scores | grep -w "444 : A" | wc -l`
 assertEquals "444 : A not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "111 : B" | wc -l`
 assertEquals "111 : B not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "222 : C" | wc -l`
 assertEquals "222 : C not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "333 : C" | wc -l`
 assertEquals "333 : C not found" '1' "${res}"
 cleanup
}

testTotalCount() {
 makeScoreFiles
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/prob4-score10.txt
 echo "444,10,8,10,9,10" >> ./scores/prob4-score10.txt
 res=`./prog4.sh ./scores | wc -l`
 assertEquals "Total Count does not match!" '4' "${res}"
 cleanup
}

testIgnoreExtraFiles() {
 makeScoreFiles
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/score10.txt
 echo "444,10,8,10,9,10" >> ./scores/score10.txt
 res=`./prog4.sh ./scores | wc -l`
 assertEquals "Total Count does not match!" '3' "${res}"
 cleanup
}

testHeaderMissing() {
 makeScoreFiles
 echo "444,10,8,10,9,10" > ./scores/prob4-score10.txt
 res=`./prog4.sh ./scores | grep -w "444 : A" | wc -l`
 assertEquals "444 : A found when it should not have been!" '0' "${res}"
 res=`./prog4.sh ./scores | grep -w "111 : B" | wc -l`
 assertEquals "111 : B not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "222 : C" | wc -l`
 assertEquals "222 : C not found" '1' "${res}"
 res=`./prog4.sh ./scores | grep -w "333 : C" | wc -l`
 assertEquals "333 : C not found" '1' "${res}"
 cleanup
}

testMissingArgs() {
 res=`./prog4.sh`
 assertEquals 'Score directory missing' "${res}"
}

testDirNotExists() {
 res=`./prog4.sh scores`
 assertEquals 'scores not a directory' "${res}"
}

testValidDir() {
 echo 'This is a file' > score
 res=`./prog4.sh score`
 assertEquals 'score not a directory' "${res}"
 rm -rf score
}

testExtraArgs() {
 makeScoreFiles
 res=`./prog4.sh scores 1 2 3`
 assertEquals 'Score directory missing' "${res}"
 cleanup
}

makeScoreFiles() {
 mkdir ./scores
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/prob4-score1.txt
 echo "111,9,8,10,10,9" >> ./scores/prob4-score1.txt
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/prob4-score2.txt
 echo "222,0,8,10,10,9" >> ./scores/prob4-score2.txt
 echo "ID,Q1,Q2,Q3,Q4,Q5" > ./scores/prob4-score3.txt
 echo "333,10,8,10,4,2" >> ./scores/prob4-score3.txt
}

cleanup() {
 rm -rf ./scores
}

. ./tests/shunit2/shunit2
