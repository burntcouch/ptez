#!/usr/bin/ruby
#
# tank test 1

require './nukecook.rb'
include NukeCooker

e = NukeEnv.new('./data/nuclides.csv')
t = NukeTank.new(e, 10000)

dt = 1.0
ts = 1500
flux = {n: 50, H: 5, D: 2, He3: 1, He4: 2}

loop do
	newt = t.cook(ts, dt, flux)
	specnt = t.tank.inject(Hash.new(0)) {|h, n| h[n.name] += 1; h}
	speck = specnt.keys.sort do |a,b| 
		begin 
			(e.nukes[a][:n] + e.nukes[a][:p]) <=> (e.nukes[b][:n] + e.nukes[b][:p])
		rescue
			puts "#{a} vs. #{b}"
		end
	end
	speck.each do |k|
		v = specnt[k]
		print "#{k.to_s} - #{v.to_s}" 
		print " HALF: #{e.nukes[k][:half]}" unless e.nukes[k].nil?
		print "\n"
	end
	puts "-------------------------------------------------------------"
	puts "TOTAL TIME: #{t.stopt.round(6)} COUNT: #{t.tank.size}  ELECTRONS: #{t.elec}"
	puts "-------------------------------------------------------------"
	dummy = gets.chomp

	if dummy =~ /dump/
		puts "-----------------------------------------------------"
		t.tank.sort {|a,b| (a.p + a.n) <=> (b.p + b.n)}.each do |n|	
			puts n.to_s	
		end
		gets
	elsif dummy =~ /dt\s+(\d+(\.\d+)?)/
		dt = $1.to_f
		puts "New dt: #{dt}"
		gets
	elsif dummy =~ /ts\s+(\d+)/
		ts = $1.to_i
		puts "New steps: #{ts}"
		gets
	elsif dummy =~ /show\s*/
		print "steps: #{ts}  dt: #{dt}  Current flux: "
		flux.each do |k,v|
			print "#{k}:#{v} "
		end
		puts
		gets	
	elsif dummy =~ /flux nil/
		flux = {}
		puts "Flux is zero"
		gets
	elsif dummy =~ /flux((\s+(\w+:\d+))+)/
		y = $1.strip.split
		z = y.inject({}) do |h,yi| 
			zz = yi.split(':')
			h[zz[0].intern] = zz[1].to_i if e.nukes.keys.include?(zz[0].intern)
			h
		end
		print "New flux: "
		z.each do |k,v|
			print "#{k}:#{v} "
		end
		puts
		gets
		flux = z
	end

	break if dummy =~ /[qQ]/	

#	dt = dt * 2
# ts = ts + ts / 10
end
