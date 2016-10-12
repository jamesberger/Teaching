#!/bin/bash
set -e
set -o pipefail

# Set a few variables right away:
STUDENT_FILE="example-student.txt"
TIME_NOW="$(date)"

# Rather than writing this every time we need to visually separate output, let's
# store it as a variable
DASHED_LINE="--------------------------------------------------------"

# Let's keep track of when our results are being written to our file
echo -e "This student was added on $TIME_NOW" >> $STUDENT_FILE

# clear our screen so it looks nicer
clear

# Let's tell our user what this is
echo "Welcome to the new student database"
echo $DASHED_LINE
echo -e "\n\n"

# using the -n option so the user writes the answer on the same line as the prompt
echo -n "Type in the first name of the new student> "
read STUDENT_FIRST_NAME

# verifying that the student name contains only letters
# Note: this fails to sanitize the input if the first try doesn't register correctly.
# Can you fix this by turning it into a while loop that only breaks when the student's first name matches the regex?
if [[ $STUDENT_FIRST_NAME =~ ^[[:alpha:]]+$ ]]
  then
    echo -e "Thanks! I have this down as $STUDENT_FIRST_NAME and it is being written to the record file.\n"
    echo -e "First name: $STUDENT_FIRST_NAME" >> $STUDENT_FILE
  else
    echo -e "The student's first name contains something other than letters from A to Z."
    echo -n "Type in the first name of the new student> "
    read STUDENT_FIRST_NAME
    echo -e "First name: $STUDENT_FIRST_NAME" >> $STUDENT_FILE
fi

echo -n "Type in the last name of the new student> "
read STUDENT_LAST_NAME

# verifying that the student last name contains only letters
# Note: this fails to sanitize the input if the first try doesn't register correctly.
# Can you fix this by turning it into a while loop that only breaks when the student's last name matches the regex?
if [[ $STUDENT_LAST_NAME =~ ^[[:alpha:]]+$ ]]
  then
    echo -e "Thanks! I have this down as $STUDENT_LAST_NAME and it is being written to the record file.\n"
    echo -e "First name: $STUDENT_LAST_NAME" >> $STUDENT_FILE
  else
    echo -e  "The student's last name contains something other than letters from A to Z."
    echo -n "Type in the last name of the new student> "
    read STUDENT_FIRST_NAME
    echo -e "First name: $STUDENT_LAST_NAME" >> $STUDENT_FILE
fi


echo -n "Type in the five digit ZIP code of the new student> "
read STUDENT_ZIP

# verifying that the student ZIP code contains only 5 digits, not 9 or any other content
# Note: this fails to sanitize the input if the first try doesn't register correctly.
# Can you fix this by turning it into a while loop that only breaks when the student's ZIP code matches the regex?
if [[ $STUDENT_ZIP =~ ^[[0-9][0-9][0-9][0-9][0-9]+$ ]]
  then
    echo -e "Thanks! I have this down as $STUDENT_ZIP and it is being written to the record file.\n"
    echo -e "ZIP code: $STUDENT_ZIP" >> $STUDENT_FILE
  else
    echo -e "The student's ZIP code contains something other than five digits in the format 12345."
    echo -n "Type in the ZIP code of the new student> "
    read STUDENT_ZIP
    echo -e "ZIP code: $STUDENT_ZIP" >> $STUDENT_FILE
fi


# We'll let the user review the data they entered
# If we were really nice, we'd also offer them the ability to correct it,
# although that would require rewriting all the bits of the script that write to
# the output file
echo -e "\n\n"
echo -e "Please verify that the student data that has been written to $STUDENT_FILE is correct:\n"
echo $DASHED_LINE
echo -e "First name: $STUDENT_FIRST_NAME"
echo -e "First name: $STUDENT_LAST_NAME"
echo -e "ZIP code: $STUDENT_ZIP"
echo $DASHED_LINE

# We need to make it visually clear where one record begins and ends in our
# output file as well, so let's do that.
echo $DASHED_LINE >> $STUDENT_FILE

# To help the user verify that the script exited successfully, we'll put this
# at the end.
echo -e "\nAll done, goodbye!\n\n"
