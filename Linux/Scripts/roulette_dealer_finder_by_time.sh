#!/usr/bin/env bash
#
# Arguments:
# $1 - date
# $2 - time
#
# Requirements:
# - For this script to find the roulette dealer, it must be run in a directory
#   that has "<MMDD>_Dealer_schedule" files.
# - The "find_dealers_for_date_and_time" script must be in the folder this
#   script is run.
#
# Returns:
# - if a format error wasn't encountered then a dealer name in
#   "<First Name> <Last Name>" format is returned
#
date="$1"
time="$2"

./find_dealers_for_date_and_time.sh "$date" "$time" | awk '{print $5, $6}'
