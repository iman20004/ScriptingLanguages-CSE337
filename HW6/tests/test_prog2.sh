#! /bin/sh

testMissingReqArgs() {
 out=`./prog2.sh`
 assertEquals 'Unexpected message:' 'data file or output file missing' "${out}"
}

testMissing2ndReqArgs() {
 out=`./prog2.sh ./inp.txt`
 assertEquals 'Unexpected message:' 'data file or output file missing' "${out}"
}

testExtraArgs() {
 out=`./prog2.sh ./inp.txt ./out.txt tmp/`
 assertEquals 'Unexpected message:' 'data file or output file missing' "${out}"
}

testInputDoesNotExists() {
 out=`./prog2.sh inp.txt out.txt`
 assertEquals 'File not found message error:' 'inp.txt file not found' "${out}"
}

testColonDelimitedInput() {
 echo "21269:17444:13490:27486:6889:18503" > inp.txt
 echo "10792:4748:13758:28041:9475:16751:25674" >> inp.txt
 echo "14885:24698:15837:977:10765:18495:20563:10084" >> inp.txt
 echo "13682:27152:11100:2265:13329:25885:23995:3470:10564" >> inp.txt
 ./prog2.sh inp.txt out.txt
 check_file_exists "testColonDelimitedInput"
 linecount=`wc -l out.txt | cut -d' ' -f1`
 assertEquals 'output missing required columns' '9' "${linecount}"
 check_line_exists "Col 1 : 60628"
 check_line_exists "Col 2 : 74042"
 check_line_exists "Col 3 : 54185"
 check_line_exists "Col 4 : 58769"
 check_line_exists "Col 5 : 40458"
 check_line_exists "Col 6 : 79634"
 check_line_exists "Col 7 : 70232"
 check_line_exists "Col 8 : 13554"
 check_line_exists "Col 9 : 10564"
 cleanup
}

testSemiColonDelimitedInput() {
 echo "21269;17444;13490;27486;6889;18503" > inp.txt
 echo "10792;4748;13758;28041;9475;16751;25674" >> inp.txt
 echo "14885;24698;15837;977;10765;18495;20563;10084" >> inp.txt
 echo "13682;27152;11100;2265;13329;25885;23995;3470;10564" >> inp.txt
 ./prog2.sh inp.txt out.txt
 check_file_exists "testSemiColonDelimitedInput"
 linecount=`wc -l out.txt | cut -d' ' -f1`
 assertEquals 'output missing required columns' '9' "${linecount}"
 check_line_exists "Col 1 : 60628"
 check_line_exists "Col 2 : 74042"
 check_line_exists "Col 3 : 54185"
 check_line_exists "Col 4 : 58769"
 check_line_exists "Col 5 : 40458"
 check_line_exists "Col 6 : 79634"
 check_line_exists "Col 7 : 70232"
 check_line_exists "Col 8 : 13554"
 check_line_exists "Col 9 : 10564"
 cleanup
}

testCommaDelimitedInput() {
 echo "21269,17444,13490,27486,6889,18503" > inp.txt
 echo "10792,4748,13758,28041,9475,16751,25674" >> inp.txt
 echo "14885,24698,15837,977,10765,18495,20563;10084" >> inp.txt
 echo "13682,27152,11100,2265,13329,25885,23995,3470,10564" >> inp.txt
 ./prog2.sh inp.txt out.txt
 check_file_exists "testCommaDelimitedInput"
 linecount=`wc -l out.txt | cut -d' ' -f1`
 assertEquals 'output missing required columns' '9' "${linecount}"
 check_line_exists "Col 1 : 60628"
 check_line_exists "Col 2 : 74042"
 check_line_exists "Col 3 : 54185"
 check_line_exists "Col 4 : 58769"
 check_line_exists "Col 5 : 40458"
 check_line_exists "Col 6 : 79634"
 check_line_exists "Col 7 : 70232"
 check_line_exists "Col 8 : 13554"
 check_line_exists "Col 9 : 10564"
 cleanup
}

testMixedDelimitedInput() {
 echo "21269,17444,13490:27486,6889;18503" > inp.txt
 echo "10792,4748:13758,28041:9475,16751,25674" >> inp.txt
 echo "14885;24698;15837;977;10765,18495,20563;10084" >> inp.txt
 echo "13682,27152,11100,2265,13329;25885;23995:3470:10564" >> inp.txt
 ./prog2.sh inp.txt out.txt
 check_file_exists "testCommaDelimitedInput"
 linecount=`wc -l out.txt | cut -d' ' -f1`
 assertEquals 'output missing required columns' '9' "${linecount}"
 check_line_exists "Col 1 : 60628"
 check_line_exists "Col 2 : 74042"
 check_line_exists "Col 3 : 54185"
 check_line_exists "Col 4 : 58769"
 check_line_exists "Col 5 : 40458"
 check_line_exists "Col 6 : 79634"
 check_line_exists "Col 7 : 70232"
 check_line_exists "Col 8 : 13554"
 check_line_exists "Col 9 : 10564"
 cleanup
}

check_file_exists() {
 test_case=$1
 assertTrue "${test_case} : out file not created!" "[ -f './out.txt' ]"
}

check_line_exists() {
 line=$1
 contains=`grep -w --count "${line}" out.txt`
 assertEquals "Missing ${line}" '1' "${contains}"
}

cleanup() {
 rm -rf ./inp.txt
 rm -rf ./out.txt
}

. ./tests/shunit2/shunit2
