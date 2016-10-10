#!/bin/bash

# Let's make sure our script fails if anything throws an error
set -e

# Let's also make sure our script fails if any command that has pipes throws an error
# For example, if ls /var/home | grep my | sort runs and /var/home doesn't exist,
# but sort runs without error (even though it isn't sorting anything useful), the
# command as a whole will return true, as the last command succeeded.
set -o pipefail

# Let's make sure our screen is cleaned up a bit to make our output easier to screen
clear


# Let's tell the user what kind of input we're expecting.
#
# Ideally we should sanitize the inputs to keep them from entering anything other
# than what we're expecting (makes hacking your application much more difficult),
# but this is just a simple example, so we'll omit that.
#
# And we're using the -n option for echo so it keeps our prompt and the user's
# typing on the same line for clarity.
echo -n "Type a number or something else, press enter and I will tell you which is is> "

read USER_INPUT


# We'll use the new(er) bash built-in regular expression support, rather than
# going through Sed or Grep.
#
# The bash regular expression matching operator is =~ and it goes in a set of
# double brackets like this:
if [[ $USER_INPUT =~ ^[0-9]+$ ]]
  then
    echo "That was a number."
  else
    echo "That was something other than a number"
fi

echo "Regular expressions overview: (see comments)"
#
# A regular expression will have one or more of the following things in it:
#
# Character set - matching on a single character or range of characters
# Anchor - this tells the regex engine where to search for the pattern
# Modifier - this expands or narrows the range of things that can be matched
#
echo "Character matching:"
# [abc] will match a, b or c. For example, "the [abc]ar" would match both
# "the car" and "the bar"
#
# If we want to match a range, we can express that with a dash like so:
# [h-p] would match any letter from h to p.
#
# If we want to match any single lower case letter or digit, we'd use [a-z0-9]
#
# If we want to exclude something, [^g-m] will match any character NOT in the
# range g through m. With regular expresions, you can view ^ as similar to ! in
# a mathematical expression.
#
# We can add sets of brackets together to match multiple things.
# For example, if we want to match an IP address like 54.10.23.45,
# we could use an expression like this:
# [0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]
# This catches any set of four octects separated by periods.
#
echo "Special characters:"
#
# If you wanted to search for the character $, normally it is used to specify the
# beginning of a line in a regular expression. So much like escaping characters
# in bash, we use the backslash "\"
#
echo "List of reserved characters in regular expressions that must be escaped before searching for them:"
# [ - left square bracket
# \ - backslash
# ^ - caret
# $ - dollar sign
# . - period
# | - pipe
# ? - question mark
# * - star
# + - plus sign
# ( - left curved bracket
# ) - right curved bracket
#
# If you're inside a character class, these must also be escaped:
# "-" - dash
# ] - right square bracket
#
echo "Note:" 
# This is for PCRE - "Perl compatible regular expressions". There's also
# POSIX basic regular expressions (BRE) and a few others which are slightly
# different, so this is not an absolute guide, but it will get you most of the
# way there.
