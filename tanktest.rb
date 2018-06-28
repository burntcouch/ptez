#!/usr/bin/ruby
#
# tank test 1

require './nukecook.rb'
include NukeCooker

e = NukeEnv.new('./data/nuclides.csv')
t = NukeTank.new(e, 1000)

dt = 1.0
ts = 150

loop do
	newt = t.cook(ts, dt, {n: 12, T: 2, He4: 1})
	specnt = t.tank.inject(Hash.new(0)) {|h, n| h[n.name] += 1; h}
	speck = specnt.keys.sort {|a,b| (e.nukes[a][:n] + e.nukes[a][:p]) <=> (e.nukes[b][:n] + e.nukes[b][:p]) }
	speck.each do |k|
		v = specnt[k]
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
		t.tank.sort {|a,b| (a.p + a.n) <=> (b.p + b.n)}.each do |n|	
			puts n.to_s	
		end
		gets
	end

	break if dummy =~ /[qQ]/	

#	dt = dt * 2
# ts = ts + ts / 10
end
