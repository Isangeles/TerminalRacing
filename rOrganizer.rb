#  rOrganizer.rb
#  
#  Copyright 2017 Dariusz Sikora <darek@dellins-solus>
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
#Class for race organizer, produces input for race script
#
class RaceOrganizer
	def initialize(trackSize, trackLenght)
		@trackSize, @trackLenght = trackSize, trackLenght	
	end
	
	def selectHorses(fileName)
		@horses = []
		horseCount = 0
		File.open(fileName).each do |horseName|
			if(horseCount >= @trackSize)
				return
			end
			@horses << horseName
			horseCount += 1
		end
	end
	
	def getOut
		out = "size:#{@trackSize};lenght:#{@trackLenght};horses:"
		for i in 0..@horses.size-1
			if(i > 0)
				out << ','
			end
			out << "#{@horses[i].to_s.delete("\n")}"
		end
		return out
	end
end

size = ARGV[0].to_i
puts size.to_s
lenght = ARGV[1].to_i

if(size.nil? || size == 0)
	size = 6
end
if(lenght.nil? || lenght == 0)
	lenght = 80
end

organizer = RaceOrganizer.new(size, lenght)
organizer.selectHorses("stable")

$stdout.puts organizer.getOut
