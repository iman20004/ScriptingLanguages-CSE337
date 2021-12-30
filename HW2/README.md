# Homework Assignment 2

## Learning Outcomes

After completion of this assignment, you should be able to:

- work with regular expressions.

- automate basic file management tasks.

- analyze and clean data in documents such as spreadsheets.

## Getting Started

To complete this homework assignment, you will need Python3.8 and above and the testing framework Pytest. If you still do not have them configured (highly unlikely), then do homework 0 and come back here. You can use any test editor or IDE (e.g., Pycharm) to write your python code.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.

The first thing you need to do is download or clone this repository to your local system. Use the following command:

`$ git clone <ssh-link>`

After you clone, you will see a directory of the form *cise337-hw2-python-application-\<username\>*, where *username* is your GitHub username.

In this directory, you will find the following files:
- *pwd_strength_detect.py*.
- *rename_files.py*.
- *excel_file_mgr.py*.

Each file corresponds to a part described below. You will write your code in these file. At the top of each file you will find hints to fill your full name, NetID, and SBU ID. Please fill them accurately. This information will be used to collect your scores from GitHub. If you do not provide this information, your submission may not be graded. The *tests/* directory has three test files, each testing the corresponding source code file. You should use the test cases as specifications to guide your code. Your goal should be to pass all the tests. If you do so, then you are almost guaranteed to get full credit. **The test files should not be modified. If you do, you will receive no credit for the homework.**

## How to read the test cases

Each test file in the *tests* directory contains test methods. Each test case is a method prefixed with *test_*. In each of these methods, you will find assert statements that need to be true for the test to pass. These asserts compare the expected result with the result obtained by invoking certain methods or referencing certain attributes in your implementation. If a test fails, the name of the failing test will be reported with an error message. You can use the error message from the failing test to diagnose and fix your errors.

*Reminder: Do not change the test files. If you do then you won't receive any credit for this homework assignment*.

## Problem Specification

In this assignment, we will write three scripts to detect the strength of a password, manage files in a directory, and process an excel file. The following sections describe requirements for each of the scripts.

### Password Strength Detector

Write a function *is_pwd_strong(password)*, in the file *pwd_strength_detect.py*, that takes a password string as an argument and returns an instance of *re.Match* if the password is strong, and *None* if the password is weak. A password is strong if it:

1. has at least eight characters,
2. contains both upper and lower case letters (in the English alphabet), and
3. has at least one digit.

A password that does not match the above conditions is considered weak.

### Filling Gaps

Consider a directory with thousands of files and directories. Many of the files in the directory have names with the prefix *spam* followed by exactly three digits and with an extension '.txt'. However, while inspecting the file names with the aforementioned pattern, we find that there are gaps. For example, the directory has *spam001.txt* and *spam003.txt* but no *spam002.txt*.

Write a function *rename(path)*, in the file *rename_files.py*, that takes the path to a directory and renames all the *spam* files in the directory such that there are no gaps in the numbering of the *spam* files. For example, if the directory (passed as argument) has *spam001.txt*, *spam002.txt*, *spam004.txt*, and *spam005.txt*, then *spam001.txt* and *spam002.txt* should remain unchanged. However, *spam004.txt* should be renamed to *spam003.txt* and *spam005.txt* to *spam004.txt*. Note the directory could have other files and folders that do not have the *spam* pattern in their names. The names of such files and directories should be preserved.   

### Analyze Excel Files

In this part, we will write a short library to automatically read and write excel files. These files record the test scores of students for each course they are enrolled in. Each file has multiple sheets. Each sheet corresponds to a course. A row in such a sheet has the name of the student in the first column followed by the scores the student received in a test for that course. The table below demonstrates how a sheet should look like in an excel workbook.

| 'CourseA'  | <!-- --> |  <!-- --> | <!-- --> |
| --- | ----------- | -----------| -----------|
| Sunny | 78.6 | 94 | 89 |
| Jonny | 57 | 77 | 82.5 |
| Kennny | 57 | 71 |  |

In this table, the name of the sheet is *'CourseA'*. Ignore the first row as this will not be present in the actual excel file. The following three rows indicate test scores of each student in the course. *Empty cells should be ignored*.

Similar to the above table, an excel workbook can have other sheets for other courses. Student names can occur in multiple sheets as a student can take multiple courses.

Our goal is to compute the mean of means for a student across all courses taken by the student. For example, if student X takes 3 courses, they will occur in 3 sheets. Each of the sheets will have a mean or average score for student X. A mean of means for student X will result in a mean or average of all mean scores of X in each sheet. Consider the sheets shown below:


| 'CourseA'  | <!-- --> |  <!-- --> | <!-- --> |
| --- | ----------- | ----------- | ----------- |
| Sunny | 20 | 20 | 20 |


| 'CourseB'  | <!-- --> |  <!-- --> | <!-- --> |
| --- | ----------- | ----------- | ----------- |
| Sunny | 15 | 10 | 20 |


Sunny's mean in *CourseA* is 20, in *CourseB* it's 15. The mean of means for Sunny is (20+15)/2 = 17.5. If a cell is empty then it should not be considered in the mean calculation. For example, consider the sheets shown below:


| 'CourseA'  | <!-- -->  |  <!-- -->  | <!-- -->  |
| --- | ----------- | ----------- | ----------- |
| Sunny | 20 | 10 | |


| 'CourseB'  | <!-- -->  | <!-- -->   | <!-- -->  |
| --- | ----------- | ----------- | ----------- |
| Sunny | 15 | 10 | 20 |

In this example, the mean of means for Sunnny will be 15.


To this end, we will define a class *ExcelFileManager* in the file *excel_file_mgr.py*. The class will have the following methods:

- **\__init\__(filename)** sets the filename in an instance variable *filename*. raises a *ValueError* if the *filename* passed as argument is a directory.

- **write_sheet(data, sheetname, workbook, save)** writes *data* in a sheet named *sheetname* in an excel file *workbook*. The workbook should be created only if the *save* argument is set to *True*. The arguments *workbook* and *save* are optional and are *None* and *False* by default. The argument *data* is a list of tuples. The first element of the tuple is the name of the student and the second element is their test score. The test score can be an integer, float, or string (e.g., '94.5'). A name can occur more than once in the list. The method should return 0 if the write succeeds and -1 if the write fails. Use the test cases in *tests/excel_file_mgr_test.py* to understand when -1 and 0 should be returned.

- **write_sheets(data)** writes *data* in different sheets of a workbook and saves the workbook. The argument *data* is a list of tuples, where the first element is a student's name, second element is a test score, and the third element is a sheet name. The method should write a student's name and test score in an appropriate cell in the appropriate sheet. The method should return -1 if the write fails and 0 if the write succeeds. Look at the test cases to guide the implementation of this method.

- **get_sheet_ave(sheetname)** returns a list of tuples. A tuple in the list should have the student's name in the first element and the mean of the student's test scores as recorded in sheet *sheetname*. An empty list should be returned if any errors occur while computing the means. Look at the test cases to see what errors could be raised.

- **get_workbook_ave(pattern)** takes an optional regular expression and matches it with the sheetnames in the workbook. The method computes a mean of means for each student across all matched sheets. If a regular expression is not provided, then the mean of means for each student is computed across all sheets in the workbook. A list of tuples, with student name in the first element and the student's mean of means in the second element. The method should return an empty list if an error occurs. See test cases for a list of errors that may occur.

## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you try to submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cise337-hw2-python-application-<username>` (skip if you are already in this directory)

`$ git add pwd_strength_detect.py`

`$ git add rename_files.py`

`$ git add excel_file_mgr.py`

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`

Every time you push code to the GitHub remote repository, the test cases in the *tests* directory will run and you will see either a green tick or a red cross in your repository just like you saw with homework0. Green tick indicates all tests passed. Red cross indicates some tests failed. Click on the red cross and open up the report to view which tests failed. Diagnose and fix the failed tests and push to the remote repository again. Repeat till all tests pass or you run out of time!

## Running Test Cases Locally

It may be convenient to run the test cases locally before pushing to the remote repository. To run a test locally use the following command:

`$ pytest tests/<name-of-test-file>`

To run all tests use the following command:

`$ pytest tests`


This command assumes that you are in the local repository directory and pytest is installed. If you do not have the right setup it is most likely because you did not do homework 0 correctly. So, do homework 0 first and then come back here!
