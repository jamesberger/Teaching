#!/bin/bash

# Apollo Template Builder


# Let's make sure we exit if there's any sort of error or an error in a command
set -e
set -o pipefail

# Let's set the value of some of our initial variables
#
# Here's the files we'll point to that contain some of the data we need:
AMI_FILE="AMI-list.txt"
SSH_KEY_PAIR_FILE=""
SOFTWARE_VERSION_FILE=""
SOFTWARE_PACKAGES_FILE=""

# Here are the global values we want to set for new blank templates.
# Where appropriate, we've pre-populated the values.
CUSTOMER_NAME="Not set"
BUILD_TICKET_NUMBER="Not set"
TEMPLATE_CREATION_DATE="Not set"
TEMPLATE_LAST_MODIFIED_DATE="Not set"
TEMPLATE_VERSION="Not set"
AWS_REGION="Not set"
AMI="ami-4e8af226 - prod-blue"
SSH_KEY_PAIR="prod"
SOFTWARE_VERSION="prod-blue-v1-05"
SOFTWARE_PACKAGES="prod-blue, apollo-prod-blue,bash,bind9-host,ntp,openssh-server,python,util-linux,vim"
TERMINATION_PROTECTION_VALUE="Not set"
ROOT_EBS_VOLUME_SIZE="Not set"
AWS_INSTANCE_TYPE="Not set"


# Begin functions section

# The initial menu is a function because if the user selects an option that
# isn't valid, we have to write the entire menu to the screen again. To quote a
# wise programmer "Wherever there is repetitive code, when a task repeats with
# only slight variations in procedure, then consider using a function."

INITIAL_MENU ()
{
  # The first thing we do is tidy up the screen. Not having any other output
  # aside from what our script is generating makes it look far more professional
  clear
  echo -e "Welcome to the Apollo Template Builder - Initial menu:\n"
  echo -e "\nWould you like to create a new template or open an existing template?\n"

  echo -e "1. Create new template"
  echo -e "2. Open existing template"
  echo -e "E. Exit\n"
  # We're using read with the -p option so we can have the user write their
  # input on the same line as the prompt.
  read -p "Please enter a value from the options above> " INITIAL_MENU_CHOICE

  # For handling an array of menu items, a case statement tends to be a far
  # better choice than infinitely nested if/then statements.
  # The * will match anything that is not one of the above items.
  case "$INITIAL_MENU_CHOICE" in
        1) echo "New template selected"
           NEW_TEMPLATE_MENU;;
        2) echo "Open existing template selected."
           EXISTING_TEMPLATE_MENU;;
        # We don't want to berate the user over case sensitivity, so we'll exit
        # on either upper case E or lower case e.
       [E]|[e]  ) echo "Exiting"
                  exit ;;
        *) echo "ERROR:"
           echo -e "\nThat was something other than one or two, e or E."
           echo -e "\nAfter this screen, please select 1, 2, e or E.\n"
           read -p "Press enter to continue. To exit, press Ctrl+C"
           # We'll call the initial menu function if they choose something other
           # than one or two.
           INITIAL_MENU;;
  esac
}

NEW_TEMPLATE_MENU ()
{
  clear
  echo -e "Welcome to the Apollo Template Builder - Create new template:\n"
  echo -e "1. Customer name: $CUSTOMER_NAME" | grep -v "^$"
  echo -e "2. Build ticket number: $BUILD_TICKET_NUMBER" | grep -v "^$"
  echo -e "3. Template created on: $TEMPLATE_CREATION_DATE" | grep -v "^$"
  echo -e "4. Template last modified on $TEMPLATE_LAST_MODIFIED_DATE" | grep -v "^$"
  echo -e "5. Template version: $TEMPLATE_VERSION" | grep -v "^$"
  echo -e "6. AWS region: $AWS_REGION" | grep -v "^$"
  echo -e "7. AMI (Amazon Machine Image): $AMI" | grep -v "^$"
  echo -e "8. SSH key pair: $SSH_KEY_PAIR" | grep -v "^$"
  echo -e "9. Software version: $SOFTWARE_VERSION" | grep -v "^$"
  echo -e "10. Software packages: $SOFTWARE_PACKAGES" | grep -v "^$"
  echo -e "11. Termination protection enabled: $TERMINATION_PROTECTION_VALUE" | grep -v "^$"
  echo -e "12. Root EBS volume size: $ROOT_EBS_VOLUME_SIZE" | grep -v "^$"
  echo -e "13. AWS instance type: $AWS_INSTANCE_TYPE" | grep -v "^$"
  echo -e "S. Save values to template file."
  echo -e "E. Exit to main menu."
  echo -e "\n"
  read -p "Which value would you like to change? " NEW_TEMPLATE_MENU_CHOICE

  case "$NEW_TEMPLATE_MENU_CHOICE" in
        1) # 5a
           #
           # This allows the user to edit the customer name.
           # We use the read statement with a prompt (-p) so their input is on
           # the same line as the prompt. The input given to read is used to
           # populate the variable "CUSTOMER_NAME"
           #
           # Not yet implemented - converting all letters to lower case and
           # replacing spaces with dashes via a regex
           echo "Edit customer name:"
           read -p "Enter a value for the customer name: " CUSTOMER_NAME
           NEW_TEMPLATE_MENU;;
        2) # 5b
           #
           # This allows the user to edit the build ticket number.
           # We use the read statement with a prompt (-p) so their input is on
           # the same line as the prompt. The input given to read is used to
           # populate the variable "BUILD_TICKET_NUMBER"
           #
           # Not yet implemented - using a regex to only allow entering numeric
           # values into this variable.
           echo "Edit build ticket number:"
           read -p "Enter a value for the build ticket (numbers only): " BUILD_TICKET_NUMBER
           NEW_TEMPLATE_MENU;;
        7) # Reading in the AMI list and letting the user select an item from it
           # is a little more content than we want to stick in a menu item, so
           # we'll call a function to handle this for us.
           AMI_MENU;;

    [s]|[S]) # Saving exsting values to a template file
             read -p "What would you like to name your template? " TEMPLATE_FILE
             echo -e "Saving data to $TEMPLATE_FILE"
             echo $CUSTOMER_NAME >> $TEMPLATE_FILE
             echo $BUILD_TICKET_NUMBER >> $TEMPLATE_FILE
             echo $TEMPLATE_CREATION_DATE >> $TEMPLATE_FILE
             echo $TEMPLATE_LAST_MODIFIED_DATE >> $TEMPLATE_FILE
             echo $TEMPLATE_VERSION >> $TEMPLATE_FILE
             echo $AWS_REGION >> $TEMPLATE_FILE
             echo $AMI | grep -v "^$" >> $TEMPLATE_FILE
             echo $SSH_KEY_PAIR >> $TEMPLATE_FILE
             echo $SOFTWARE_VERSION >> $TEMPLATE_FILE
             echo $SOFTWARE_PACKAGES >> $TEMPLATE_FILE
             echo $TERMINATION_PROTECTION_VALUE >> $TEMPLATE_FILE
             echo $ROOT_EBS_VOLUME_SIZE >> $TEMPLATE_FILE
             echo $AWS_INSTANCE_TYPE >> $TEMPLATE_FILE
             sleep 1
             NEW_TEMPLATE_MENU;;
    [E]|[e]  ) echo "Exiting to main menu."
           INITIAL_MENU;;
        *) echo "ERROR:"
           # We'll comment this out until we actually implement all of our items
           #echo -e "\nThat was something other than a number 1 through 12."
           #echo -e "\nAfter this screen, please select a number from 1 to 12.\n"
           echo -e "\nThat value is either invalid, or has not been implemented yet."
           read -p "Press enter to continue. To exit, press Ctrl+C"
           # We'll call the new template menu function if they choose something other
           # than a menu choice we've implemented.
           NEW_TEMPLATE_MENU;;
  esac
}

EXISTING_TEMPLATE_MENU ()
{
 clear
 echo -e "Welcome to the Apollo Template Builder - Open existing template:\n"
 echo -e "Here is a list of the files in the current directory this script is running in:" | ls -1
 read -p "Which file would you like to open? " TEMPLATE_FILE_CHOICE
 readarray IMPORTED_TEMPLATE_ARRAY < $TEMPLATE_FILE_CHOICE

  echo -e "\n\n"
  echo -e "Here are the values in the template file you selected: "

  #TEMPLATE_FILE_POSITION=0
  #until [ $TEMPLATE_FILE_POSITION == ${#IMPORTED_TEMPLATE_ARRAY[@]} ]
  #  do
  #    echo -e "$TEMPLATE_FILE_POSITION) ${IMPORTED_TEMPLATE_ARRAY[$TEMPLATE_FILE_POSITION]}" | grep -v "^$"
  #    TEMPLATE_FILE_POSITION=$((TEMPLATE_FILE_POSITION+1))
  #done

  echo -e "1. Customer name: ${IMPORTED_TEMPLATE_ARRAY[0]}" | grep -v "^$"
  echo -e "2. Build ticket number: ${IMPORTED_TEMPLATE_ARRAY[1]}" | grep -v "^$"
  echo -e "3. Template created on: ${IMPORTED_TEMPLATE_ARRAY[2]}" | grep -v "^$"
  echo -e "4. Template last modified on ${IMPORTED_TEMPLATE_ARRAY[3]}" | grep -v "^$"
  echo -e "5. Template version: ${IMPORTED_TEMPLATE_ARRAY[4]}" | grep -v "^$"
  echo -e "6. AWS region: ${IMPORTED_TEMPLATE_ARRAY[5]}" | grep -v "^$"
  echo -e "7. AMI (Amazon Machine Image): ${IMPORTED_TEMPLATE_ARRAY[6]}" | grep -v "^$"
  echo -e "8. SSH key pair: ${IMPORTED_TEMPLATE_ARRAY[7]}" | grep -v "^$"
  echo -e "9. Software version: ${IMPORTED_TEMPLATE_ARRAY[8]}" | grep -v "^$"
  echo -e "10. Software packages: ${IMPORTED_TEMPLATE_ARRAY[9]}" | grep -v "^$"
  echo -e "11. Termination protection enabled: ${IMPORTED_TEMPLATE_ARRAY[10]}" | grep -v "^$"
  echo -e "12. Root EBS volume size: ${IMPORTED_TEMPLATE_ARRAY[11]}" | grep -v "^$"
  echo -e "13. AWS instance type: ${IMPORTED_TEMPLATE_ARRAY[12]}" | grep -v "^$"

  CUSTOMER_NAME=${IMPORTED_TEMPLATE_ARRAY[0]}
  BUILD_TICKET_NUMBER=${IMPORTED_TEMPLATE_ARRAY[1]}
  TEMPLATE_CREATION_DATE=${IMPORTED_TEMPLATE_ARRAY[2]}
  TEMPLATE_LAST_MODIFIED_DATE=${IMPORTED_TEMPLATE_ARRAY[3]}
  TEMPLATE_VERSION=${IMPORTED_TEMPLATE_ARRAY[4]}
  AWS_REGION=${IMPORTED_TEMPLATE_ARRAY[5]}
  AMI=${IMPORTED_TEMPLATE_ARRAY[6]}
  SSH_KEY_PAIR=${IMPORTED_TEMPLATE_ARRAY[7]}
  SOFTWARE_VERSION=${IMPORTED_TEMPLATE_ARRAY[8]}
  SOFTWARE_PACKAGES=${IMPORTED_TEMPLATE_ARRAY[9]}
  TERMINATION_PROTECTION_VALUE=${IMPORTED_TEMPLATE_ARRAY[10]}
  ROOT_EBS_VOLUME_SIZE=${IMPORTED_TEMPLATE_ARRAY[11]}
  AWS_INSTANCE_TYPE=${IMPORTED_TEMPLATE_ARRAY[12]}

  echo -e "\n"
  read -p "Press enter to continue"



NEW_TEMPLATE_MENU
}

AMI_MENU ()
{
  # 5g
  #
  # This allows the user to select an AMI from $AMI_FILE by passing the contents
  # of $AMI_FILE to the Bash built in readarray feature. From there, it prints
  # out each array element, one per line.
  #
  # The readarray feature was introduced in Bash 4, and while this will break in
  # servers that use versions of Bash older than v4, we'll run with this for now
  # as it is much more elegant than a complex for statement.
  #
  # Finally, it calls the NEW_TEMPLATE_MENU function to take them back to the
  #new template menu.


  clear
  echo -e "Welcome to the Apollo Template Builder - Select AMI:\n"

  # Here we pass in the contents of $AMI_FILE and turn each line in the file
  # into an array element.
  readarray AMI_ARRAY < $AMI_FILE

  # Next, we set a menu position to an initial value of zero
  AMI_MENU_POSITION=0

  # Then we go through each element in the array until the menu position is
  # equal to the total number of elements in the array (given by putting a
  # pound sign or # in front of the array name).
  # For each element in the array, we echo out the menu position, then the
  # contents of the array element for the element number that is the same as
  # the menu position value. As printing our the array results in blank lines,
  # we trim those with grep.
  # Then we increment the value of the menu position by one.
  # Once the menu position is equal to the length of the array, we exit the loop.
  until [ $AMI_MENU_POSITION == ${#AMI_ARRAY[@]} ]
    do
      echo -e "$AMI_MENU_POSITION) ${AMI_ARRAY[$AMI_MENU_POSITION]}" | grep -v "^$"
      AMI_MENU_POSITION=$((AMI_MENU_POSITION+1))
  done

 # Old silly way of handling this:
 # echo -e "0. ${AMI_ARRAY[0]}"
 # echo -e "1. ${AMI_ARRAY[1]}"
 # echo -e "2. ${AMI_ARRAY[2]}"
 # echo -e "3. ${AMI_ARRAY[3]}"
 # echo -e "4. ${AMI_ARRAY[4]}"
 # echo -e "5. ${AMI_ARRAY[5]}"
 # echo -e "6. ${AMI_ARRAY[6]}"
 # echo -e "7. ${AMI_ARRAY[7]}"
 # echo -e "8. ${AMI_ARRAY[8]}"
 # echo -e "9. ${AMI_ARRAY[9]}"
 # echo -e "10. ${AMI_ARRAY[10]}"
 # echo -e "11. ${AMI_ARRAY[11]}"
 # echo -e "12. ${AMI_ARRAY[12]}"
 # echo -e "13. ${AMI_ARRAY[13]}"
 # echo -e "14. ${AMI_ARRAY[14]}"
 # echo -e "15. ${AMI_ARRAY[15]}"
 # echo -e "16. ${AMI_ARRAY[16]}"
 # echo -e "17. ${AMI_ARRAY[17]}"
 # echo -e "E. Exit to new build template menu."

  # Then we allow the user to enter a value
  # We then set the value for the AMI equal to the array
  # element at that value.
  # Note - this sets the value to empty if the user enters a
  # number that is not equal to the position of an existing array element
  # The user can also exit by entering nothing and hitting enter.
  echo -e "\n"
  read -p "Which AMI would you like to select? " AMI_MENU_CHOICE
  AMI=${AMI_ARRAY[$AMI_MENU_CHOICE]}
  NEW_TEMPLATE_MENU

# Old silly way of handling this:
#case "$AMI_MENU_CHOICE" in
  #  0) AMI=${AMI_ARRAY[0]}
  #     NEW_TEMPLATE_MENU;;
  #  1) AMI=${AMI_ARRAY[1]}
  #     NEW_TEMPLATE_MENU;;
  #  2) AMI=${AMI_ARRAY[2]}
  #     NEW_TEMPLATE_MENU;;
  #  3) AMI=${AMI_ARRAY[3]}
  #     NEW_TEMPLATE_MENU;;
  #  4) AMI=${AMI_ARRAY[4]}
  #     NEW_TEMPLATE_MENU;;
  #  5) AMI=${AMI_ARRAY[5]}
  #     NEW_TEMPLATE_MENU;;
  #  6) AMI=${AMI_ARRAY[6]}
  #     NEW_TEMPLATE_MENU;;
  #  7) AMI=${AMI_ARRAY[7]}
  #     NEW_TEMPLATE_MENU;;
  #  8) AMI=${AMI_ARRAY[8]}
  #     NEW_TEMPLATE_MENU;;
  #  9) AMI=${AMI_ARRAY[9]}
  #     NEW_TEMPLATE_MENU;;
  #  10) AMI=${AMI_ARRAY[10]}
  #      NEW_TEMPLATE_MENU;;
  #  11) AMI=${AMI_ARRAY[11]}
  #      NEW_TEMPLATE_MENU;;
  #  12) AMI=${AMI_ARRAY[12]}
  #      NEW_TEMPLATE_MENU;;
  #  13) AMI=${AMI_ARRAY[13]}
  #      NEW_TEMPLATE_MENU;;
  #  14) AMI=${AMI_ARRAY[14]}
  #      NEW_TEMPLATE_MENU;;
  #  15) AMI=${AMI_ARRAY[15]}
  #      NEW_TEMPLATE_MENU;;
  #  16) AMI=${AMI_ARRAY[16]}
  #      NEW_TEMPLATE_MENU;;
  #  17) AMI=${AMI_ARRAY[17]}
  #      NEW_TEMPLATE_MENU;;
    # We don't want to berate the user over case sensitivity, so we'll exit
    # on either upper case E or lower case e.
  #  [E]|[e]) echo "Returning to new template menu"
  #         NEW_TEMPLATE_MENU ;;
  #  *) clear
  #     echo "ERROR:"
  #     echo -e "\nThat was something other than a number from 0 to 17, e or E."
  #     echo -e "\nAfter this screen, please select a number from 0 to 17, e or E.\n"
  #     read -p "Press enter to continue. To exit, press Ctrl+C"
       # We'll call the AMI menu function if they choose something other than
       # one or two.
  #     AMI_MENU;;
  #esac
}

# Begin main portion of the script
# Clear our screen to make things nice and readable
clear

echo -e "Welcome to the Apollo Template Builder"

# We call the initial menu function here.
# The body of the script looks somewhat sparse at the moment, as the initial
# menu function calls the new template menu funtion directly.
INITIAL_MENU

# We exit normally after this line
