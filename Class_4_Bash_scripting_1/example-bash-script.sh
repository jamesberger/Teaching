#!/bin/bash
# The first line tells it what interpreter to use

############
# Comments #
############

# This is a comment.
#
# Comments can be on their own line or after a command or statement.
#
# Multi-line comments really aren't a feature in bash scripting sadly.
# There's a few ways to implement them, but they abuse features that weren't
# designed to be used for comments, like the null character, ":" and may or may
# not be portable - e.g., if it works on this version of Linux, it might not
# on another version of Linux, UNIX, AIX, etc.
# So in general, multi-line comments are more trouble than they're worth.

# Pretty print:
# To pretty up our output, we're going to print out a pair of line breaks.
# To simplify it a little, we'll set our line breaks as variables. Right now
# this doesn't save much typing, but if we wanted to build a more fancy way
# to separate sections, it will be a lot easier to store it in a variable.

LINEBREAK="\n\n"
echo -e $LINEBREAK

###################
# Using variables #
###################

# Types of variables:
# 1. String
# 2. Integer
# 3. Constant
# 4. Array

# Case sensitivity:
# Variables are case sensitive in Bash. This is terrible and awful.
# By default, variables are upper case. You can use lower case if you like,
# but be consistent, if only for your own sanity.

# Numbers:
# Variables can contain digits, but not as the first character

# Incrementing the value of a variable
# There's a few different ways to do this, although ((VARIBLE++)) performs best.
#
# i=$((i+1))
# ((i=i+1))
# ((i+=1))
# ((i++))
# let "i=i+1"
# let "i+=1"
# let "i++"

# Decrementing the value of a variable:
# The same as above, just substitute a - for the +
# 
# Example:
# ((i--))


# This will print your user name on the command line by referencing the
# built in variable $USER. Variables are prefaced by the $ sign.
echo "Hi, $USER."


# But we didn't set the value for user in our script?
# Where is it pulling the value from?
# To find out, run the command "printenv | grep USER" (case sensitive).
# This displays the global variables for the current user, which are applied
# when a user logs in.

# This is how you set a variable:

UNIVERSITY="Udallas"
CLASS="Advanced Linux"

#This is how you use variables you’ve set:
echo "Hi $USER, I see you are in $CLASS at $UNIVERSITY."

# Scope for variables:

# Local variables can be displayed by running "set" with no other parameters.
# Local variables are only available to the current shell - for example, if you
# switch to zsh, you won't be able to use the previous set of local variables.

# Exporting variables:
# Variables created in a script will only be usable from inside that script.
# Unless you export the variable, that is.
# Like so:
export UNIVERSITY="Udallas"

# This is useful if you fork your process or use a subshell.


###############################################
# Printing text to the command line or a file #
###############################################
echo -e $LINEBREAK
# Should I use echo or printf?
# They both serve the same function, and echo does most of the things you'll want it to do.
# Use echo until you run into something it won't do properly, but printf will.

# Overwrites the contents of compile.log every time it runs. Usually not what you want.

echo "Writing status to compile.log..."

# *******************
# * Extra credit #1 *
# *******************
# Why don't you see the output of this on the command line as well as in the file?
# Any quick way to get it to show up in both of those places?
echo "Finished compiling successfully. Date is $(date)" > compile.log

# If you'd rather append it, use two >>
echo "Finished compiling successfully. Date is $(date)" >> compile.log

echo "Done writing status. Current date is $(date)"

# Hardcoding our file name every time we refer to it can be time consuming and
# error prone. Let's just set it in a variable instead:
LOGFILE="compile.log"

# *******************
# * Extra credit #2 *
# *******************
# Why does the first one print "\n\n\n", but the second one prints three line breaks?
echo "\n\n\n"
echo -e "\n\n\n"

####################
# Running commands #
####################

echo "Here are the contents of the log file:"
cat $LOGFILE

echo -e $LINEBREAK

echo "Taking a short five second nap..."
#sleep 5 #Pauses for five seconds before going onto the next statement

echo "Done taking a nap, resuming now."
echo -e $LINEBREAK

# This outputs the username and cuts out the first character.
FIRST_LETTER_OF_USERNAME="$(echo -e $USER | cut -c 1)"

echo -e "The first letter of your username is $FIRST_LETTER_OF_USERNAME"

##########################
# Escapinging characters #
##########################

# If you need to have a backslash or other reserved character in your text or
# elsewhere, you can escape it with \.
# So for example, if we want to echo some text with an dollar sign.

echo -e $LINEBREAK

echo "This steak is $40, I hope it's tasty!"
echo "This steak is \$40, I hope it's tasty!"

# The first one prints the value of the variable "4".
# The second one actually prints a dollar sign.

echo -e $LINEBREAK
##########################
# Conditional statements #
##########################

# Arithmetic operators:
# Set or change value to: =
# Plus: +
# Minus: -
# Multiplication: *
# Division: /
# Exponentiation: **
# Modulo or mod (returns remainder of division operation): %
# Chain two arithmetic operations together: ,

# Logical (aka Boolean) opperators [[used within double square brackets]]:
# OR: ||
# AND: &&
# NOT: !


# Logical opperators [used within single square brackets]:
# Logical OR: -o
# Logical AND: -a

# Integer comparison using [single square brackets]:
#
# Example:
# if [ "$a" -eq "$b" ]
#
# Is equal to: -eq
# Is not equal to: -ne
# Is greater than: -gt
# Is greater than or equal to: -ge
# Is less than: -lt
# Is less than or equal to: -le

# Integer comparison using ((double parentheses)):
#
# Example:
# (("$a" < "$b"))
#
# Is less than: <
# Is less than or equal to: <=
# Is greater than: >
# Is greater than or equal to: >=

# String comparison [always uses square brackets]:
#
# Example:
# if [ "$a" = "$b" ]
# (note, the above is white space sensitive around the =, funny stuff happens if you eliminate it)
#
# Is equal to: ==
# Is not equal to: !=
# Is less than, in ASCII alphabetical order: <
# Is more than, in ASCII alphabetical order: >

# String value:
#
# Example:
# if [ -z "$String" ]
#
# If string is null: -z
# If string is not null: -n

#################
# If statements #
#################

# If statement syntax on one line:
# if TEST-COMMAND; then CONSEQUENT-COMMANDS; fi

# Multi-line if statement syntax:
# if TEST-COMMAND
#   then
#     CONSEQUENT-COMMANDS
# fi

# Checking to see if a file exists:
if [ -f compile.log ]
  then
    echo "Compile.log exists"
  else
    echo "Compile.log does not exist in the current directory."
fi

echo -e $LINEBREAK

# Comparing a value
NUMBER_OF_SHOES_ON_FEET="2"

echo -e "I am wearing $NUMBER_OF_SHOES_ON_FEET shoes."

if [ "$NUMBER_OF_SHOES_ON_FEET" -gt "1" ]
  then
    echo "Do not put more shoes on your feet."
  else
    echo "You are wearing $NUMBER_OF_SHOES_ON_FEET shoes on your feet."
fi

echo -e $LINEBREAK

# A nested if statement that checks both upper and lower cases letters in the ranges A through M and N through Z.
if [[ $FIRST_LETTER_OF_USERNAME == [a-m] ]] || [[ $FIRST_LETTER_OF_USERNAME == [A-M] ]]
  then
    echo "The first letter of your username is a letter from A to M."
  else
    if [[ $FIRST_LETTER_OF_USERNAME == [n-z] ]] || [[ $FIRST_LETTER_OF_USERNAME == [N-Z] ]]
      then
        echo "The first letter of your username is a letter from N to Z."
      else
        echo "The first letter of your username appears to be something other than a letter from A to Z."
    fi
fi

echo -e $LINEBREAK

#########
# Loops #
#########

# There are three types of built-in loops in Bash:
# 1. for
# 2. while
# 3. until

# Here is an example for loop where we will increment a value:
MY_VALUE="0"
for (( i = 0; i < 10; i++ )); do
    echo -e "The current value of MY_VALUE is $MY_VALUE."
    ((MY_VALUE++))
done

echo -e $LINEBREAK

# Here is an example while loop:

# Note:
# These things can be dangerous, use carefully.
# For example, if you say "do this while this value is greater than 10." and the
# value never gets below 10, it will loop for all of eternity and you will sit
# there being terribly bored. Creating test cases is beyond the scope of this
# course, but this is a good example of where you'd want one.

ICE_CREAM_CONES=0

while [ $ICE_CREAM_CONES -lt 10 ]
  do
    echo -e "I have $ICE_CREAM_CONES ice cream cones."
    ((ICE_CREAM_CONES++))
done

echo -e $LINEBREAK

# Here is an example until loop:

# The until loop is fairly similar to the while loop, except it will run
# "until" the test command executes successfully.
# The loop will continue every time the test command fails.
#
# Example syntax, one line until loop:
# until TEST-COMMAND; do CONSEQUENT-COMMANDS; done

CARDS_IN_DECK=5

until [ $CARDS_IN_DECK -lt 1 ]
  do
   echo -e "Number of cards in the deck: $CARDS_IN_DECK"
   ((CARDS_IN_DECK--))
done

echo -e $LINEBREAK

echo "Now we'll exit."

echo -e $LINEBREAK

exit 0 #You generally do not want to set this manually.
# If the script runs successfully, it will automatically exit with a
# status code of 0 (successfull) or 1 (unsuccessful).
# If you manually set it to 0, you won't be able to tell if the script
# actually failed. So don't do this.
