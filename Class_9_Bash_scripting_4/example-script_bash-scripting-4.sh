#!/bin/bash

# Objectives for next class:

# Use the example script to write your own script that implements the following:
#
# 1. Creates an array and populates it, then echoes individual elements out to
# the command line
# Extra points if you can allow the user to put items in the array,
# rather than hard-coding the elements of the array in the script.
#
# 2. Takes the command line arguments and uses them to read in a user specified
# file and change the file (could be as simple as appending the current date and
# time to the last line of the file).
#
# 3. Runs a function in a subshell that has variables of the same name as the
# parent shell, but with different values.
# For example, if my_name=Rumpelstiltskin in the parent shell, you should be
# able to echo a different value for my_name from the subshell without affecting
# the value of the variable in the parent shell.


# clear our screen to make things easier to read
clear

# This is how we write a simple function
function party_time {
  echo -e "It is $(date), time to party!\n"
}

echo -e "\n\nHi, this is the beginning of our script!\n"

# This is how we call a function in our script
party_time

echo -e "This is printed after calling our function.\n"

echo -e "All About Arrays:"

# This is the painful way to make an Array
painful_array[0]='Ouch. '
painful_array[1]='Why'
painful_array[2]='initialize'
painful_array[3]='your'
painful_array[4]='values'
painful_array[5]='one'
painful_array[6]='at'
painful_array[7]='a'
painful_array[8]='time?'

# This is the way to echo out the contents of an entire array
echo ${painful_array[*]}

# This is the way to echo out individual elements of the array,
# or the same element multiple times, as in this case:
echo ${painful_array[0]}${painful_array[0]}${painful_array[0]}

# Let's make our lives easier
declare -a easy_array=(Now we initialize each element at the same time and its so easy)

echo -e "Here's the 11th and 12th elements of our easy array: "
echo ${easy_array[11]} ${easy_array[12]}

# If your array elements have white space in them, you will need to put single quotes around the elements
declare -a array_with_whitespaced_elements=('These elements' 'have a bit of' 'white space in' 'each element')
echo -e "Here is an array with elements that have white space in them:\n ${array_with_whitespaced_elements[*]}"

# Getting your array length:
echo -e "The length of the easy_array is: ${#easy_array[@]}"

# Getting your element length:
echo -e "The length of the  3rd element in the easy_array is: ${#easy_array[2]}"

# Printing out specific elements from an array -
# the first value is what element to start at, and the next value is
# how many elements to print out:
echo -e "The contents of the three elements after the second element in the easy_array are: ${easy_array[@]:2:3}"

# Adding elements to an array:
# Initialize the array:
favorite_UNIX_variants=('RHEL' 'CentOS' 'Amazon Linux')
favorite_UNIX_variants=("${favorite_UNIX_variants[@]}" "Ubuntu" "Debian")

echo -e "The 5th element of the array favorite_UNIX_variants is ${favorite_UNIX_variants[4]}"

echo -e "\nI Love Lists But Bash Does Not:"
# Bash really does not believe in lists and tends to use arrays instead
# The for loop works on a list, although it does not implement the full linked
# list data structure that you may have come to expect from other OO languages.

# Here, we'll make a list of the items in the current directory we're in and
# then we'll print them out, one by one:
echo -e "Here is a list of the items in this directory: "
for item in $( ls )
  do
    echo item: $item
done

echo -e  "\nPassing in command line arguments:"

# Positional parameters
# This is the most simple method of passing in command line arguments
# In a script, $0 through $9 are reserved variables that point at the first ten
# parameters when calling a scriptm with $0 being the name the script is being
# called by
# For example, myscript.sh -f bob.txt

echo -e "This is the name of the script: $0"
echo -e "And this is the second parameter after that: $1"
echo -e "And this is the third: $2"

# We could do some hack-ish while loops to detect the contents of our positional
# parameters and do things based on that - for example, if $1 equals -f, then
# pass in $2 as the name of the file to check for. But that's no fun.

# Let's do things the right way with getopts!

echo -e "\nUsing GetOpts: "

# NOTE: There is a Bash built in called "getopts" and a Bash built in called
# "getopt". They each have slightly different features sets and despite the
# very similar names, are best not confused. Which one you would want to use in
# a given scenario is beyond the scope of this class, but it may be something
# you would wish to google if you have extensive need for either.

# Example code below is from http://tuxtweaks.com/2014/05/bash-getopts/

#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

#Help function
function HELP {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT file.ext${NORM}"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "${REV}-a${NORM}  --Sets the value for option ${BOLD}a${NORM}. Default is ${BOLD}A${NORM}."
  echo "${REV}-b${NORM}  --Sets the value for option ${BOLD}b${NORM}. Default is ${BOLD}B${NORM}."
  echo "${REV}-c${NORM}  --Sets the value for option ${BOLD}c${NORM}. Default is ${BOLD}C${NORM}."
  echo "${REV}-d${NORM}  --Sets the value for option ${BOLD}d${NORM}. Default is ${BOLD}D${NORM}."
  echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD}$SCRIPT -a foo -b man -c chu -d bar file.ext${NORM}"\\n
  exit 1
}

#Initialize variables to default values.
OPT_A=A
OPT_B=B
OPT_C=C
OPT_D=D

#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  HELP
fi

### Start getopts code ###

#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.


while getopts :a:b:c:d:h FLAG; do
  case $FLAG in
    a)  #set option "a"
      OPT_A=$OPTARG
      echo "-a used: $OPTARG"
      echo "OPT_A = $OPT_A"
      ;;
    b)  #set option "b"
      OPT_B=$OPTARG
      echo "-b used: $OPTARG"
      echo "OPT_B = $OPT_B"
      ;;
    c)  #set option "c"
      OPT_C=$OPTARG
      echo "-c used: $OPTARG"
      echo "OPT_C = $OPT_C"
      ;;
    d)  #set option "d"
      OPT_D=$OPTARG
      echo "-d used: $OPTARG"
      echo "OPT_D = $OPT_D"
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      #echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      #exit 2
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### End getopts code ###


echo -e "Forks, subshells and background processes, oh my!"

# Any external command run from a bash script will run as a fork under the parent
# process of the bash script:
echo -e "Here is a child process that lists all the files in this directory: "
ls

# Let's set a variable in our current shell:
best_animated_movie="The Lion King"

# This command runs in a subshell:
(
best_animated_movie="Aladin"
echo -e "This is from the subshell - the best animated movie is $best_animated_movie"
)

# So let's see what this prints out:
echo -e "This is from the shell - the best animated movie is $best_animated_movie"

# This command runs in the background
sleep 5 &

# Uncomment the command below to see what happens when you don't run it in the background:
#sleep 5
echo -e "This should run less than five seconds after printing out the best animated movie."
