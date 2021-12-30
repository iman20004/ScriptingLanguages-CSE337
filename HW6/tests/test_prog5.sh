#! /bin/sh

testMissingArgs() {
 res=`./prog5.sh`
 assertEquals 'input file and  dictionary missing' "${res}"
}

testMissingDict() {
 res=`./prog5.sh sample.txt`
 assertEquals 'input file and  dictionary missing' "${res}"
}

testThirdArgMissing() {
 res=`./prog5.sh sample.txt dict.txt`
 assertEquals 'missing no. of characters' "${res}"
}

testInputsNotExist1() {
 res=`./prog5.sh sample.txt dicts.txt 4`
 assertEquals 'sample.txt not a file' "${res}"
}

testInputsNotExist2() {
 makeText1 
 res=`./prog5.sh sample.txt dict.txt 4`
 assertEquals 'dict.txt not a file' "${res}"
 rm -rf ./sample.txt
}

testThirdArgNan() {
 makeText1
 makeDict4
 res=`./prog5.sh sample.txt dict.txt four`
 assertEquals 'Third argument must be an integer greater than 0' "${res}"
 cleanup
}

testThirdZero() {
 makeText1
 makeDict4
 res=`./prog5.sh sample.txt dict.txt 0`
 assertEquals 'Third argument must be an integer greater than 0' "${res}"
 cleanup
}

testFourWordsMistakesCount() {
 makeDict4
 makeText2
 res=`./prog5.sh ./sample.txt ./dict.txt 4 | wc -l`
 assertEquals 'no. of mistakes do not match!' '3' "${res}"
 cleanup
}

testFourWordsMistakes() {
 makeDict4
 makeText2
 res=`./prog5.sh ./sample.txt ./dict.txt 4 | grep "nawy; word position=17"`
 assertEquals 'nawy; word position=17 not detected!' '0' "$?"
 res=`./prog5.sh ./sample.txt ./dict.txt 4 | grep "sear; word position=18"`
 assertEquals 'sear; word position=18 not detected!' '0' "$?"
 res=`./prog5.sh ./sample.txt ./dict.txt 4 | grep "thee; word position=22"`
 assertEquals 'thee; word position=22 not detected!' '0' "$?"
 cleanup
}

testFiveWordsMistakesCount() {
 makeDict5
 makeText2
 res=`./prog5.sh ./sample.txt ./dict.txt 5 | wc -l`
 assertEquals 'no. of mistakes do not match!' '3' "${res}"
 cleanup
}

testFiveWordsMistakes() {
 makeDict5
 makeText2
 res=`./prog5.sh ./sample.txt ./dict.txt 5 | grep "graci; word position=1"`
 assertEquals 'graci; word position=1 not detected!' '0' "$?"
 res=`./prog5.sh ./sample.txt ./dict.txt 5 | grep "fisst; word position=43"`
 assertEquals 'fisst; word position=43 not detected!' '0' "$?"
 res=`./prog5.sh ./sample.txt ./dict.txt 5 | grep "creat; word position=71"`
 assertEquals 'creat; word position=71 not detected!' '0' "$?"
}

testSixWordsMistakesCount() {
 makeDict6
 makeText2
 res=`./prog5.sh ./sample.txt ./dict.txt 6 | wc -l`
 assertEquals 'no. of mistakes do not match!' '2' "${res}"
 cleanup
}

testSixWordsMistakes() {
 makeDict6
 makeText2
 res=`./prog5.sh ./sample.txt ./dict.txt 6 | grep "topper; word position=4"`
 assertEquals 'topper; word position=4 not detected!' '0' "$?"
 res=`./prog5.sh ./sample.txt ./dict.txt 6 | grep "device; word position=50"`
 assertEquals 'device; word position=50 not detected!' '0' "$?"
}

testFourWordsNoMistakes() {
 makeDict4
 makeText1
 res=`./prog5.sh ./sample.txt ./dict.txt 4 | wc -l`
 assertEquals 'dict has all 4-letter words in text1' '0' "${res}"
 cleanup
}

testFiveWordsNoMistakes() {
 makeDict5
 makeText1
 res=`./prog5.sh ./sample.txt ./dict.txt 5 | wc -l`
 assertEquals 'dict has all 5-letter words in text1' '0' "${res}"
 cleanup
}

testSixWordsNoMistakes() {
 makeDict6
 makeText1
 res=`./prog5.sh ./sample.txt ./dict.txt 6 | wc -l`
 assertEquals 'dict has all 6-letter words in text1' '0' "${res}"
 cleanup
}


makeDict4() {
 echo "unix" > ./dict.txt
 echo "rear" >> ./dict.txt
 echo "this" >> ./dict.txt
 echo "flow" >> ./dict.txt
 echo "stem" >> ./dict.txt 
 echo "mark" >> ./dict.txt
 echo "navy" >> ./dict.txt
}

makeDict5() {
 echo "first" > ./dict.txt
 echo "early" >> ./dict.txt
 echo "grace" >> ./dict.txt
 echo "later" >> ./dict.txt
 echo "still" >> ./dict.txt
 echo "today" >> ./dict.txt
 echo "cobol" >> ./dict.txt
 echo "using" >> ./dict.txt
}

makeDict6() {
 echo "murray" > ./dict.txt
 echo "hopper" >> ./dict.txt
 echo "devise" >> ./dict.txt
 echo "theory" >> ./dict.txt
 echo "create" >> ./dict.txt
 echo "united" >> ./dict.txt
 echo "states" >> ./dict.txt
}

makeText1() {
 echo "Grace Brewster Murray Hopper (nee Murray December 9, 1906 – January 1, 1992) was an American computer scientist and United States Navy rear admiral.[1] One of the first programmers of the Harvard Mark I computer, she was a pioneer of computer programming who invented one of the first linkers. Hopper was the first to devise the theory of machine-independent programming languages, and the FLOW-MATIC programming language she created using this theory was later extended to create COBOL, an early high-level programming language still in use today." > ./sample.txt
}

makeText2() {
 echo "Graci Brewster Murray Topper (nee Murray December 9, 1906 – January 1, 1992) was an American computer scientist and United States Nawy sear admiral.[1] One of thee first programmers of the Harvard Mark I computer, she was a pioneer of computer programming who invented one of the fisst linkers. Hopper was the first to device the theory of machine-independent programming languages, and the FLOW-MATIC programming language she created using this theory was later extended to creat COBOL, an early high-level programming language still in use today." > ./sample.txt
}

cleanup() {
 rm -rf ./dict.txt
 rm -rf ./sample.txt
}

. ./tests/shunit2/shunit2
