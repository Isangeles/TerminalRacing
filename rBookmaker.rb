#  rBookmaker.rb
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
#Class for race bookmaker
#
class Bookmaker
	#
	#Bookmaker constructor
	#
	def initialize(horses)
		@horses = horses
	end
	#
	#Makes bet from specified types
	#
	def makeBet(types)
		bet = ""
		if(types =~ /.-./)
			boxes = types.split('-')
			boxA = boxes[0].to_i
			boxB = boxes[1].to_i
			
			if(boxA > 0 && boxA <= @horses.size+1 && boxB > 0 && boxB <= @horses.size+1)
				bet = "versus:#{types}"
			else
				bet = "wrong types"
			end
		else
			box = types.to_i
			
			if(box > 0 && box <= @horses.size+1)
				bet = "winner:#{types}"
			else
				bet = "wrong type"
			end
		end
		return bet
	end
end

input = STDIN.read
args = ""
for arg in ARGV
	args << " #{arg}"
end
horsesArg = args
horses = []
for horse in args.split(',')
	horses << horse
end

book = Bookmaker.new(horses)
bet = book.makeBet(input)
$stdout.puts bet
