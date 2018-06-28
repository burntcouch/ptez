#!/usr/bin/ruby
#
# tank test 1

require './nukecook.rb'
include NukeCooker

e = NukeEnv.new('./data/nuclides.csv')
t = NukeTank.new(e, 100)

dt = 1.0
ts = 100

loop do
	newt = t.cook(ts, dt, {n: 10, T: 1})
	specnt = t.tank.inject(Hash.new(0)) {|h, n| h[n.name] += 1; h}
	specnt.each do |k, v|
		print "#{k.to_s} - #{v.to_s}" 
		print " HALF: #{e.nukes[k][:half]}" unless e.nukes[k].nil?
		print "\n"
	end
	puts "-----------------------------------------------------"
	puts "TIME: #{t.stopt.round(6)} COUNT: #{t.tank.size}  ELECTRONS: #{t.elec}"
	puts "-----------------------------------------------------"
	dummy = gets.chomp

	if dummy =~ /dump/
		puts "-----------------------------------------------------"
		t.tank.each do |n|	
			puts n.to_s	
		end
		gets
	end

	break if dummy =~ /[qQ]/	

#	dt = dt * 2
# ts = ts + ts / 10
end
