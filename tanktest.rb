#!/usr/bin/ruby
#
# tank test 1

require './nukecook.rb'
include NukeCooker

e = NukeEnv.new('./data/nuclides.csv', './data/cross_sect.csv')
t = NukeTank.new(e, 1000)

dt = 100.0
ts = 150
flux = {n: 0.01}
frate = 10.0

fcnt = 0

loop do
	newt = t.cook(ts, dt, flux, frate)
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
	puts "TOTAL TIME: #{t.stopt.round(6)} COUNT: #{t.tank.size}  P/N/E: #{t.pcnt}/#{t.ncnt}/#{t.elec}"
	puts "CHARGE: #{t.charge}  MASS: #{t.mass}  TEMP:#{t.temp.round(3)}"
	puts "-------------------------------------------------------------"
	if fcnt <= 0
		dummy = gets.chomp
		fcnt = 0
	else
		dummy = ""
		puts "Free run: #{fcnt}"
		fcnt -= 1
	end

	if dummy =~ /dump/
		puts "-----------------------------------------------------"
		t.tank.sort {|a,b| (a.p + a.n) <=> (b.p + b.n)}.each do |n|	
			puts n.to_s	
		end
		gets
	elsif dummy =~ /free\s+(\d+)/
		fcnt = $1.to_i
		puts "Free run mode, #{fcnt} rounds.."
	elsif dummy =~ /dt\s+(\d+(\.\d+)?)/
		dt = $1.to_f
		puts "New dt: #{dt}"
		gets
	elsif dummy =~ /ts\s+(\d+)/
		ts = $1.to_i
		puts "New steps: #{ts}"
		gets
	elsif dummy =~ /show\s*/
		print "steps: #{ts}  dt: #{dt}  fuserate: #{frate}   Current flux: "
		flux.each do |k,v|
			print "#{k}:#{v} "
		end
		puts
		gets
	elsif dummy =~ /fuse\s+(\d+(\.\d+)?)/	
		frate = $1.to_f
		puts "New dt: #{frate}"
		gets
	elsif dummy =~ /flux nil/
		flux = {}
		puts "Flux is zero"
		gets
	elsif dummy =~ /hist/
		prott = 0
		prots = t.tank.inject(Hash.new(0)) {|h, n| h[n.p] += 1; prott = h[n.p] if prott < h[n.p]; h}
		40.downto(1) do |li|
			1.upto(77) do |pn|
				p = 40.0 * prots[pn] / prott.to_f
				p = 1.0 if (p < 1.0 and prots[pn] > 0)
				print (p.to_i >= li ? "X" : " ")
			end
			print "\n"
		end
		puts "-" * 77
		1.upto(77) {|pn| print (pn % 10).to_s}
		puts
		puts "-" * 77
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
