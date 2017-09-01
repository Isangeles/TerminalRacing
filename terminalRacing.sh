#  horseRacing.sh
#  
#  Copyright 2017 Dariusz Sikora <darek@darek-PC-LinuxMint18>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
# 

#!/bin/bash

trackSize="$1"
trackLenght="$2"

if [ "$trackSize" = "" ] 
then
	trackSize=6
fi

if [ "$trackLenght" = "" ]
then
	trackLenght=80
fi

organizerOut=$(ruby ./rOrganizer.rb $trackSize $trackLenght)

echo $organizerOut | cut -d';' -f1
echo $organizerOut | cut -d';' -f2

horses=$(echo $organizerOut | cut -d';' -f3)
horses=$(echo $horses | cut -d':' -f2)
for (( i=1; i <= $trackSize; ++i ))
do
	horseName=$(echo $horses | cut -d',' -f$i)
	echo -e "\nBox[$i]:$horseName"
done

bet=""
while(true)
do
read -n1 -r -p "[r] - start [b] - make bet  [e] - exit" key
echo -e "\n"
if [ "$key" = 'r' ]
then
	echo $organizerOut | ruby ./hRace.rb $bet
	exit 0
fi
if [ "$key" = 'b' ]
then
	bet=""
	types=""
	echo "Enter bet ([box ID] for winner, [better box ID]-[worse box ID] for versus)"
	read -r types 
	bet=$(echo $types | ruby ./rBookmaker.rb $horses)
	echo "$bet"
fi
if [ "$key" = 'e' ]
then
	exit 0
fi
done
