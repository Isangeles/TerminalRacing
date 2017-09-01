#  hRace.rb
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

require "./bCheckout.rb"

#
#
#Class for racing horse
#
class Horse
	#
	#Horse constructor
	#
	def initialize(name)
		@name = name
		@position = 0
	end
	#
	#Moves horse forward
	#
	def run
		@position += (1 + rand(5))
	end
	
	def to_s 
		"Racing horse: #{@name}" 
	end
	
	attr_reader:position
	attr_reader:name
end
#
#
#Class for horse racing track 
#
class Track
	#
	#Track constructor
	#
	def initialize(trackSize, trackLenght)
		@trackSize, @trackLenght = trackSize, trackLenght
		@boxes = []
		@race = false
		
		@fance = getTrackFance
		@paths = Array.new(@trackSize-1)
		for i in 0..@paths.size
			path = getPathLine(boxNum = i+1)
			@paths[i] = path
		end
	end
	#
	#Adds specified horse to first empty box
	#
	def addHorse(horse)
		if(@boxes.size >= @trackSize)
			return
		else
			@boxes << horse
		end
	end
	#
	#Adds specified horses to empty boxes
	#
	def addHorses(*horses)
		for horse in horses
			addHorse(horse)
		end
	end
	#
	#Adds specified horses to empty boxes
	#
	def addHorses(horses)
		for horse in horses
			addHorse(horse)
		end
	end
	#
	#Starts race
	#
	def startRace
		@race = true
		@classification = []
	end
	#
	#Updates track
	#
	def update
		if(@race)
			boxId = 0
			for horse in @boxes
				if(@classification.include?(horse))
					boxId += 1
					next
				end
				
				horse.run
				if(horse.position >= @trackLenght)
					@paths[boxId] = getPathLine(boxNum = boxId+1)
					@paths[boxId] += "*"
					finish(horse)
				else
					@paths[boxId] = getPathLine(boxNum = boxId+1)
					@paths[boxId][horse.position] = "*" 
				end
				boxId += 1
			end
		end
	end
	#
	#Prints track
	#
	def print
		puts @fance
		puts @paths
		puts @fance
	end
	
	def to_s
		info = "Track size: #{@trackSize}, track lenght: #{@trackLenght}"
		info += "\nHorses on track: #{@boxes.size}"
		
		boxIndex = 1;
		for horse in @boxes
			info += "\nBox #{boxIndex}: #{horse.name}"
			boxIndex += 1
		end
		
		info += "\nLast winner: #{@classification[0]}"
		
		return info
	end
	#
	#Returns last race results
	#
	def getResults
		standings = []
		for runner in @classification
			standings << "#{runner.name}[#{getBoxId(runner).to_s}]"
		end
		return standings
	end
	
	attr_reader:race
	attr_reader:classification
	
	private def getPathLine(index)
		pathLine = "#{index.to_s}|"
		for i in 0..@trackLenght
			pathLine << "-"
		end 
		return pathLine
	end
	
	private def getTrackFance
		fance = ""
		for i in 0..@trackLenght
			fance << "="
		end
		return fance
	end
	#
	#Places specified horse in race classification
	#
	private def finish(runner)
		if(@race && !@classification.include?(runner))
			@classification << runner
			if(@classification.size >= @boxes.size)
				@race = false
			end
		end
	end
	#
	#Returns ID of box for specified horse
	#
	private def getBoxId(horse)
		for i in 0..@boxes.size
			if(horse == @boxes[i])
				return i+1
			end
			i += 1
		end
		return 0
	end
end

input = STDIN.read.split(';')

trackSize = input[0].split(':')[1].to_i
trackLenght = input[1].split(':')[1].to_i

horsesNames = input[2].split(':')[1].split(',')
horses = []
for name in horsesNames
	horses << Horse.new(name)
end

if(trackSize.nil? || trackSize == 0)
	trackSize = 6
end
if(trackLenght.nil? || trackLenght == 0)
	trackLenght = 80
end
track = Track.new(trackSize, trackLenght)

bet = ARGV[0]

track.addHorses(horses)

track.startRace
while(track.race)
	track.update
	system "clear"
	track.print
	sleep 0.4
end

puts track
results = track.getResults
betCheck = Checkout.new(results)
$stdout.puts results
if(!bet.nil?)
	betCheck.check(bet)
end
