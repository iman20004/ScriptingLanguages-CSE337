#! /bin/sh

testSrcDestMissing() {
 out=`./prog1.sh`
 assertEquals 'src and dest missing' "${out}"
}

testMoreThanTwoArgs() {
 out=`./prog1.sh src dest 1`
 assertEquals 'Exactly 2 arguments required' "${out}"
}

testSrcMissing() {
 out=`./prog1.sh src dest`
 assertEquals 'src not found' "${out}"
 assertFalse 'src dir created but not expected!' "[ -d './src' ]"
}

testDestCreated() {
 if test -d ./src ; then
  rm -rf ./src
 fi
 mkdir ./src
 ./prog1.sh src dest
 rm -rf ./src
 check_dest_exists "testDestCreated"
 rm -rf ./dest
}

testDestExistsAndCreated() {
 if test -d ./src ; then
  rm -rf ./src
 fi
 mkdir ./src
 if test -d ./dest ; then
  rm -rf ./dest
 fi
 mkdir ./dest
 ./prog1.sh src dest
 rm -rf ./src
 check_dest_exists "testDestExistsCreated"
 rm -rf ./dest
}

testDestNotEmptyAndCreated() {
 if test -d ./src ; then
  rm -rf ./src
 fi
 mkdir ./src
 if test -d ./dest ; then
  rm -rf ./dest
 fi
 mkdir ./dest
 touch ./dest/1.c
 ./prog1.sh src dest
 rm -rf ./src
 check_dest_exists "testDestNotEmptyAndCreated"
 assertTrue 'dest not empty' "[ -z "$(ls -A ./dest)" ]"
 rm -rf ./dest
}

testMoveFiles_1() {
 if test -d ./src ; then
  rm -rf ./src
 fi
 mkdir -p ./src/sub1/subsub1/
 mkdir ./src/sub1/subsub1/subsub2/
 mkdir -p ./src/sub2/subsub1/
 touch ./src/1.c
 touch ./src/2.c
 touch ./src/1.o
 touch ./src/sub1/1.c
 touch ./src/sub1/subsub1/1.c
 touch ./src/sub1/subsub1/2.c
 touch ./src/sub1/subsub1/3.c
 touch ./src/sub1/subsub1/subsub2/1.c
 touch ./src/sub2/1.o
 touch ./src/sub2/1.c
 touch ./src/sub2/subsub1/1.o
 touch ./src/sub2/subsub1/2.o
 ./prog1.sh src dest
 check_dest_exists "testMoveFiles_1"
 dest_file_count=`find ./dest -name *.c | wc -l`
 assertEquals '.c dest file count does not match' '8' "${dest_file_count}"
 dest_src_file_count=`ls -1 ./dest/src/*.c | wc -l`
 assertEquals '.c dest file count does not match' '2' "${dest_src_file_count}"
 dest_src_sub1_file_count=`ls -1 ./dest/src/sub1/*.c | wc -l`
 assertEquals '.c dest file count does not match' '1' "${dest_src_sub1_file_count}"
 dest_src_sub1_subsub1_file_count=`ls -1 ./dest/src/sub1/subsub1/*.c | wc -l`
 assertEquals '.c dest file count does not match' '3' "${dest_src_sub1_subsub1_file_count}"
 dest_src_sub1_subsub1_subsub2_file_count=`ls -1 ./dest/src/sub1/subsub1/subsub2/*.c | wc -l`
 assertEquals '.c dest file count does not match' '1' "${dest_src_sub1_subsub1_subsub2_file_count}"
 dest_src_sub2_file_count=`ls -1 ./dest/src/sub2/*.c | wc -l`
 assertEquals '.c dest file count does not match' '1' "${dest_src_sub2_file_count}"
 src_file_o_count=`find ./src -name *.o | wc -l`
 assertEquals '.o files in src do not match' '4' "${src_file_o_count}"
 dest_file_o_count=`find ./dest -name *.o | wc -l`
 assertEquals '.o files in dest do not match' '0' "${dest_file_o_count}"
 cleanup
}

testMoveFiles_Y() {
 if test -d ./src ; then
  rm -rf ./src
 fi
 mkdir -p ./src/sub1/subsub1/
 mkdir ./src/sub1/subsub1/subsub2/
 mkdir -p ./src/sub2/subsub1/
 touch ./src/1.c
 touch ./src/2.c
 touch ./src/1.o
 touch ./src/sub1/1.c
 touch ./src/sub1/subsub1/1.c
 touch ./src/sub1/subsub1/2.c
 touch ./src/sub1/subsub1/3.c
 touch ./src/sub1/subsub1/4.c
 touch ./src/sub1/subsub1/subsub2/1.c
 touch ./src/sub2/1.o
 touch ./src/sub2/1.c
 touch ./src/sub2/subsub1/1.o
 touch ./src/sub2/subsub1/2.o
 echo "y" | ./prog1.sh src dest
 check_dest_exists "testMoveFiles_Y"
 dest_file_count=`find ./dest -name *.c | wc -l`
 assertEquals 'testMoveFiles_Y: .c dest file count does not match' '9' "${dest_file_count}"
 dest_src_file_count=`ls -1 ./dest/src/*.c | wc -l`
 assertEquals 'testMoveFiles_Y: .c dest file count does not match' '2' "${dest_src_file_count}"
 dest_src_sub1_file_count=`ls -1 ./dest/src/sub1/*.c | wc -l`
 assertEquals 'testMoveFiles_Y: .c dest file count does not match' '1' "${dest_src_sub1_file_count}"
 dest_src_sub1_subsub1_file_count=`ls -1 ./dest/src/sub1/subsub1/*.c | wc -l`
 assertEquals 'testMoveFiles_Y: .c dest file count does not match' '4' "${dest_src_sub1_subsub1_file_count}"
 dest_src_sub1_subsub1_subsub2_file_count=`ls -1 ./dest/src/sub1/subsub1/subsub2/*.c | wc -l`
 assertEquals 'testMoveFiles_Y: .c dest file count does not match' '1' "${dest_src_sub1_subsub1_subsub2_file_count}"
 dest_src_sub2_file_count=`ls -1 ./dest/src/sub2/*.c | wc -l`
 assertEquals 'testMoveFiles_Y: .c dest file count does not match' '1' "${dest_src_sub2_file_count}"
 src_file_o_count=`find ./src -name *.o | wc -l`
 assertEquals 'testMoveFiles_Y: .o files in src do not match' '4' "${src_file_o_count}"
 dest_file_o_count=`find ./dest -name *.o | wc -l`
 assertEquals 'testMoveFiles_Y: .o files in dest do not match' '0' "${dest_file_o_count}"
 cleanup
}

testMoveFiles_N() {
 if test -d ./src ; then
  rm -rf ./src
 fi
 mkdir -p ./src/sub1/subsub1/
 mkdir ./src/sub1/subsub1/subsub2/
 mkdir -p ./src/sub2/subsub1/
 touch ./src/1.c
 touch ./src/2.c
 touch ./src/1.o
 touch ./src/sub1/1.c
 touch ./src/sub1/subsub1/1.c
 touch ./src/sub1/subsub1/2.c
 touch ./src/sub1/subsub1/3.c
 touch ./src/sub1/subsub1/4.c
 touch ./src/sub1/subsub1/subsub2/1.c
 touch ./src/sub2/1.o
 touch ./src/sub2/1.c
 touch ./src/sub2/subsub1/1.o
 touch ./src/sub2/subsub1/2.o
 echo "n" | ./prog1.sh src dest
 check_dest_exists "testMoveFiles_N"
 dest_file_count=`find ./dest -name *.c | wc -l`
 assertEquals 'testMoveFiles_N: .c dest file count does not match' '5' "${dest_file_count}"
 dest_src_file_count=`ls -1 ./dest/src/*.c | wc -l`
 assertEquals 'testMoveFiles_N: .c dest file count does not match' '2' "${dest_src_file_count}"
 dest_src_sub1_file_count=`ls -1 ./dest/src/sub1/*.c | wc -l`
 assertEquals 'testMoveFiles_N: .c dest file count does not match' '1' "${dest_src_sub1_file_count}"
 dest_src_sub1_subsub1_subsub2_file_count=`ls -1 ./dest/src/sub1/subsub1/subsub2/*.c | wc -l`
 assertEquals 'testMoveFiles_N: .c dest file count does not match' '1' "${dest_src_sub1_subsub1_subsub2_file_count}"
 dest_src_sub2_file_count=`ls -1 ./dest/src/sub2/*.c | wc -l`
 assertEquals 'testMoveFiles_N: .c dest file count does not match' '1' "${dest_src_sub2_file_count}"
 src_file_o_count=`find ./src -name *.o | wc -l`
 assertEquals 'testMoveFiles_N: .o files in src do not match' '4' "${src_file_o_count}"
 dest_file_o_count=`find ./dest -name *.o | wc -l`
 assertEquals 'testMoveFiles_N: .o files in dest do not match' '0' "${dest_file_o_count}"
 cleanup
}


check_dest_exists() {
 test_case=$1
 assertTrue "${test_case} : dest dir not created!" "[ -d './dest' ]"
}

cleanup() {
 rm -rf ./src
 rm -rf ./dest
}

. ./tests/shunit2/shunit2
