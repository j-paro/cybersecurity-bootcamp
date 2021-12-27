#!/usr/bin/env bash
#
# The following files must be in the directory this script is run:
# - The "date_time_losses" file
#   <File with the days and times of the losses>
#
#   This file's lines must have the following format:
#   ...
#   <MMDD><Space(s)><HH:MM:SS AM/PM>
#   ...
#
# - The "03<Name>" files:
#   <File with dealers for games during times>
#
#   Used files copied from the "<Any Directory/Lucky_Duck_Investigations/Roulette_Loss_Investigations/Dealer_Schedules_0310"
#   directory
#

losses_file=date_time_losses

echo "" > Dealers_working_during_losses

#
# Loop on all files in the current directory that start with "03"
#
for dealer_schedule in 03*
do
    #
    # Strip out the "MMDD" portion of the dealer schedule file.
    #
    schedule_day=${dealer_schedule:0:4}

    #
    # From the "date_time_losses" file, give me only the lines that have my day
    # that I found and stored in "schedule_day". Pipe that into awk and give me
    # the time with the AM/PM.
    #
    day_loss_times=$(grep "$schedule_day" "$losses_file" | awk '{print $2, $3}')

    #
    # This gives me the portion of the dealer schedule that's only Roulette.
    #
    roulette_sch=$(awk '{print $1, $2, $5, $6}' "$dealer_schedule")

    #
    # This looks into the new Roulette schedule I made above and tries to match
    # each date and time that's located in "day_loss_times" that I created
    # above.
    #
    echo "$roulette_sch" | grep -F "$day_loss_times" >> Dealers_working_during_losses
done
