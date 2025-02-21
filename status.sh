#!/bin/bash

# elevate to root before doing anything so the sudo prompt doesn't disrupt the script 
sudo echo 0 > /dev/null

dir=$(dirname "$(realpath "$0")")
source "$dir/config.sh"

if [[ "$show_screenfetch" = true ]]; then
	screenfetch
	printf "\n"
fi

printf "CPU Load / Temperature:\n"
"$dir/scripts/cpuinfo.sh" | sed 's/^/\t/'

apcstats=$("$dir/scripts/apcstats.sh")
if [ -n "$apcstats" ]; then
	printf "\nUPS Stats:\n"
	sed 's/^/\t/' <<< "$apcstats"
fi

printf "\nHard Drive Temperatures:\n"
"$dir/scripts/disktemp.sh" harddisks | sed 's/^/\t/'

ssdtemp=$("$dir/scripts/disktemp.sh" ssds)
if [ -n "$ssdtemp" ]; then
	printf "\nSSD Temperatures:\n"
	sed 's/^/\t/' <<< "$ssdtemp"
fi

optanetemp=$("$dir/scripts/optanetemp.sh")
if [ -n "$optanetemp" ]; then
	printf "\nIntel Optane SLOG Temperatures:\n"
	sed 's/^/\t/' <<< "$optanetemp"
fi

printf "\nZFS Adaptive Read Cache Stats:\n"
"$dir/scripts/arcstats.sh" | sed 's/^/\t/'

