#!/usr/bin/env bash
#
# Arguments:
# $1 - date
# $2 - time
# $3 - game --> must be "BlackJack", "Roulette", or "Texas_Hold_EM"; if this
#      argument isn't passed in then use "Roulette" as the default
#
# Requirements:
# - For this script to find the roulette dealer, it must be run in a directory
#   that has "<MMDD>_Dealer_schedule" files.
#
# Returns:
# - if a format error wasn't encounter then a dealer name in "<First Name> <Last
#   Name>" format is returned
#
date="$1"
time="$2"
game="$3"

if [[ -z "$game" || "$game" == "Roulette" ]]; then
    echo 1
    ./roulette_dealer_finder_by_time.sh "$date" "$time"
elif [[ "$game" == "BlackJack" ]]; then
    echo 2
    ./find_dealers_for_date_and_time.sh "$date" "$time" | awk '{print $3, $4}'
elif [[ "$game" == "Texas_Hold_EM" ]]; then
    echo 3
    ./find_dealers_for_date_and_time.sh "$date" "$time" | awk '{print $7, $8}'
else
    echo "Invalid game! Pass in 'BlackJack, 'Texas_Hold_EM', or 'Roulette' (default)"
    exit 1
fi
