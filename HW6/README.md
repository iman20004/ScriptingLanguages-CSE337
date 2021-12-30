# Homework Assignment 6

## Learning Outcomes

After completion of this assignment, you should be able to:

- Design and implement scripts in Shell.

- Work efficiently with command-line tools in UNIX.


## Getting Started

To complete this homework assignment, you will need a UNIX shell. At the beginning of each shell script you will see a line `#!/bin/sh`. This indicates that we will be using the `/bin/sh` interpreter. You should ssh to the compute3/compute4 servers using the credentials that were emailed to you at the beginning of the course. You should clone this repository in the server. There are two ways to do this. Clone the repo to your local machine and use scp to transfer the directory to the server. Instructions on how to login and transfer files have been posted on Piazza. An alternative way is to login to the server and configure your GitHub username to use SSH on the server. This is similar to what you did in HW0. You will have to add the public key in `~/.ssh` to your GitHub account. Follow the instructions in HW0 to configure the server to recognize your GitHub account. Once you have done this, you can work directly on the server.

If you have trouble connecting to the server, you can use your local machine for this homework. If you are on Linux or Mac, you can use the terminal. If you are on Windows, you will have to install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) (WSL). However, it is advisable to test your scripts on the server before submission.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.


**At the top of each prog*.sh, you will find hints to fill your full name, NetID, and SBU ID. Please fill them accurately**. This information will be used to collect your scores from GitHub. If you do not provide this information, your submission may not be graded. You should write the implementation and the tests needed to verify the correctness of your implementation.


## Testing

The *tests* directory containts the test files. Each test file contains methods to verify the expected behavior of each problem outlined in the subsequent sections. You can run these tests using the command `./tests/test_prog[1-5].sh` from the repository directory. Remember to add the executable permission using *chmod* before executing the tests. Your goal should be pass all the tests. If you do, you will get full credit for this homework.

## Problem Specification

In this homework assignment, we will implement 5 shell scripts as defined below.

### Problem 1

Imagine that we have written numerous C files (.c files) in a directory D and compiled then to object files (.o files). Now, we want to ship directory D to a  client who wants to run the source code. However, we cannot release our source code to protect intellectual property. Hence, we will have to move our source files to another directory and keep the object files in the same directory. However, we need to ensure the following when we are moving source files.

1. While moving files to the destination directory, the directory structure should be maintained. For example, consider that we are moving all C files from directory *project* to a directory *project_src_bkup*. Let us say that the directory project has C source files in *project/*, *project/subProj1*, *project/subProj1/subsubProj1*, and *project/subProj2*. The destination directory *project_src_bkup* should have the corresponding source files in the same directory structure, that is, *project/*, *project/subProj1*, *project/subProj1/subsubProj1*, and *project/subProj2*.

2. Some directories may contain more than 3 C files. Moving files from such directories should be done in an interactive manner. Since we don’t want to lose a large number of files, all files being moved should be first displayed to the user. If the user confirms by typing ‘y’ or ‘Y’, then the files should be moved; otherwise, the files should be skipped.

3. If the destination directory does not exist, then it should be created. If the destination directory exists, then it should be emptied and then recreated.

Write a script **prog1.sh** to automate the process described above. Your script should take 2 inputs from the command line -- path/to/srcDir and path/to/destDir. Any temporary files created during script execution should be deleted after the script finishes execution. If no arguments are provided to the script then exit with status 0 and display the message 'src and dest missing'. If more than 2 arguments are provided to the script, then exit with status 0 and display the message 'Exactly 2 arguments required'. If a valid src directory is not provided as argument then exit with status 0 and display the message 'src not found'.

Use the test cases to further guide your implementation.

### Problem 2

Imagine that we are given a data file, where each line is a sequence of integers. The integers in each line are separated by either 1 of the 3 characters – comma(,), semicolon(;) or colon(:). Further, there is no limit to the number of integers in each line. Here is an example of a sample data file:

```
1;2;3;4;5
11:4:23:12
18,4,17,13,21,19,25
```

As can be seen from the example, a data file may be arranged in rows and columns where the columns are separated by either comma, semicolon, or colon. the no. of columns in each row may differ. You can assume 0 for a cell with no integers in them.

Write a script **prog2.sh** that will take a data file (as described above) and an output file as input arguments. The script will compute the sum of each column in the data file. The sum of each column should be written to an output file which will also be provided as input to the script. All inputs to the script will be provided from the command line. The output file should be written in the format *Col <n> : sum*, that is, each line in the output file should have the column and its corresponding sum. For example, based on the data file shown above, the output file should look like the following:

```
Col 1 : 30
Col 2 : 10
Col 3 : 43
Col 4 : 29
Col 5 : 26
Col 6 : 19
Col 7 : 25
```

If exactly two input arguments are not provided to the script, then exit with status 0 and display the message 'data file or output file missing'. If a non-existent data file is provided as input to the script, then the script should display “<filename> file not found”. If the output file provided as input does not exist, then it should be created. If an output file provided as input exists, then it should be over-written with the new output of the script. You can assume that a data file will always have the format specified above.

Use the test cases to further guide your implementation.

### Problem 3

Imagine an exam with N parts. The final score of the exam takes into account all N parts. Each part has a weight W<sub>N</sub> associated with it. If Q<sub>N</sub> is the score a student receives in part N, then the weighted average of the exam for that student will be the `S/T`, where S is the sum of Q<sub>i</sub>*W<sub>i</sub> for `i = 1 to N` and T is the sum of the weights. Assuming that we have recorded the ID of each student who took the exam along with the score that student got for each part in a file. A sample file might look as follows:

```
ID,Q1,Q2,Q3,Q4,Q5
101,8,6,9,4,4
102,9,9,9,10,4
103,5,6,2,4,4
104,1,2,2,1,4
105,10,10,10,9,4
106,10,10,10,10,4
107,7,7,8,9,4
108,5,6,5,6,5
109,10,9,9,4,4

```
A weighted average for the sample file (shown above) will be 5, assuming that the weights 1,2,3,4, and 5 were assigned to Q1,Q2,Q3,Q4, and Q5. You can assume that that all scores will be integers and the final result should be rounded off to the nearest integer towards 0 (e.g., 5.6 should be rounded off to 5).

Write a script **prog3.sh** that takes a data file as the first argument followed by optional arguments for weights. If the argument provided is not a file then exit with status 0 and display the message 'Missing data file'. The 1st weight argument should be considered as the weight for the first part of the exam, the 2nd weight argument as the weight of the 2nd part, and so on and so forth up to N. If the no. of weight arguments provided is less than N, then assume that the remaining parts of the exam have weight 1. If the no. of weight arguments provided is more than N, then ignore the additional weight arguments. The first N weight arguments should be considered the weight for the N parts of the exam.

Use the test cases for further guidance.

### Problem 4

Imagine a scenario where we have the scores of each student in an exam and you are supposed to assign an appropriate letter grade based on the score. Further, assume that you have collected the scores of each student in a file. Each such file will contain the student ID and a breakdown of the scores for each question in the exam. Here is an example of a sample file for a student:
```
ID,Q1,Q2,Q3,Q4,Q5
102,9,9,9,10,10
```

Each student will have a corresponding file in the format shown above. You can assume that an exam will always have 5 questions worth 10 points each.

Write a script **prog4.sh** that will take a directory of score files as input, compute the score received by a student as a percentage, and *display* the student ID and her corresponding letter-grade in the format *ID:<letter-grade>*. The percentage range and the corresponding letter grade is as follows:

```
93-100 : A
80-92 : B
65 - 79 : C
< 65 : D
```

If the scores directory is not provided as an argument then exit with status 0 and display the message 'Score directory missing'.

Use test cases for further guidance.

### Problem 5

Write a script *prog5.sh* that takes a text file, a text dictionary file, and an integer N as input arguments and finds all N-letter words that have been spelt incorrectly in the text file. Assume that the dictionary file is a newline separated list of all possible N letter words. The script should display all such N-letter words on a newline in the format "fisst; word position=K" where K is the Kth word in the text file. A word is a collection of letters in the English alphabet.

If the first two arguments are not provided then exit with status 0 and display the message 'input file and  dictionary missing'. If the third argument is missing then exit with status 0 and display 'missing no. of characters'. If the text file does not exist then exit and display '<filename> not a file'. If the dictionary does not exist then exit and display '<dictionary-name> not a file'. If the third argument is not an integer greater than 0 then exit and display the message 'Third argument must be an integer greater than 0'.

See the test cases for example of expected behavior.



## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you try to submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cise337-hw6-shell-scripting-<username>` (skip if you are already in this directory)

```
$ git add prog[1-5].sh
```

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`
