#!/usr/bin/env bash
#
# Arguments:
# $1 - date --> MMDD format
# $2 - time --> HH:MM:SS AM/PM format (the argument must be quoted)
#
# Requirements:
# - For this script to find the roulette dealer, it must be run in a directory
#   that has "<MMDD>_Dealer_schedule" files.
#
# Returns:
# - if a format error wasn't encountered then timeslot with dealers is returned
#
date="$1"
time="$2"

get_dealers () {
    find . -type f -name "$1*" | xargs -d'\n' grep "$2"
}

if [[ "$date" =~ ^(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])$ ]]; then
   if [[ "$time" =~ ^(0[1-9]|1[0-2]):([0-5][0-9]):([0-5][0-9])[[:space:]]([AaPp][Mm])$ ]]; then
      get_dealers "$date" "$time"
   else
      echo "Invalid time! Use <HH:MM:SS AM/PM> format!"
      exit 1
   fi
else
   echo "Invalid date! Use <MMDD> format!"
   exit 1
fi
