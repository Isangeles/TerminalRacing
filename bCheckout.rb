#  bCheckout.rb
#  
#  Copyright 2017 Darek Sikora <darek@darek-PC-LinuxMint18>
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

#!/usr/bin/env ruby

#
#
#Class for bets checkout
#
class Checkout
	#
	#Checkout constructor
	#
	def initialize(raceResults)
		@results = raceResults
	end
	#
	#Checks specified bet
	#
	def check(fullBet)
		betType = fullBet.split(':')[0]
		bet = fullBet.split(':')[1]
		
		if(betType == "winner")
			winner = @results[0]
			if(bet == winner[winner.size-2])
				return "Win"
			else
				return "Lose"
			end
		end
		if(betType == "versus")
			versusBet = bet.split('-')
			posA, posB = 0, 0
			for i in 0..@results.size
				if(@results[i] =~ /.[#{versusBet[0]}]/)
					posA = i
				end
				if(@results[i] =~ /.[#{versusBet[0]}]/)
					posB = i
				end
			end
			if(posA > posB)
				return "Bet:win"
			else
				return "Bet:lose"
			end
		end
	end
end



