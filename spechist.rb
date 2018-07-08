#!/usr/bin/ruby
#
# species generator - element distribution histogram
#

require './ptez.rb'
include Ptez

def elemsum(env, specs)
	ebins = {}
	wtot = 0.0
	atot = 0.0
	specs.each do |si|
		ea = eatoms(env, si)
		ea.each do |ek, ev|
			ebins[ek] = {afrac: 0.0, wfrac: 0.0} if ebins[ek].nil?
			ebins[ek][:afrac] += ev
			ebins[ek][:wfrac] += ev.to_f * env.elem[ek][:AMU]
			wtot += ev.to_f * env.elem[ek][:AMU]
			atot += ev.to_f
		end
	end
	ebins.keys.each do |ek|
		ebins[ek][:wfrac] = ebins[ek][:wfrac] / wtot
		ebins[ek][:afrac] = ebins[ek][:afrac] / atot
	end
	return ebins
end

def elemhhist(env, ebins, width=77)
	ekeys = ebins.keys.sort {|a,b| env.elem[a][:AMU] <=> env.elem[b][:AMU]}
	tope = ekeys.inject(0) {|i,ek| i = (i < ebins[ek][:afrac] ? ebins[ek][:afrac] : i)}
	w = width - 10
	wscale = w.to_f / tope
	ekeys.each do |ek|
		printf("%-2s %5.2f |", ek.to_s, ebins[ek][:afrac] * 100.0)
		print "x" * ((wscale *  ebins[ek][:afrac]).to_i + 1) if ebins[ek][:afrac] > 0.0
		print "\n"
	end
	puts "-" * width
	ekeys.each do |ek|
		printf("%-2s %5.2f |", ek.to_s, ebins[ek][:wfrac] * 100.0)
		print "x" * ((wscale *  ebins[ek][:wfrac]).to_i + 1) if ebins[ek][:afrac] > 0.0
		print "\n"
	end	
	puts "-" * width
end

def elemvhist(env, ebins, rows=30, width=77)
	ekeys = ebins.keys.sort {|a,b| env.elem[a][:AMU] <=> env.elem[b][:AMU]}
	w = width / ekeys.count - 1
	tope = ekeys.inject(0) {|i,ek| i = (i < ebins[ek][:afrac] ? ebins[ek][:afrac] : i)}
	rscale = rows.to_f / tope
	rows.downto(0) do |ri|
		ekeys.each do |ek|
			bar = "x" * w
			if ebins[ek][:afrac] > 0.0 && rscale * ebins[ek][:afrac] >= ri
				print " #{bar}"
			else
				print " " * (w + 1)
			end
		end
		print "\n"
	end
	puts "-" * width

		# print element symbol
	ekeys.each do |ek|
		bar = ek.to_s.center(w + 1)
		print bar
	end
	print "\n"
		# and pct of total mass
	ekeys.each do |ek|
		bar = sprintf("%4.2f", ebins[ek][:wfrac] * 100.0).to_s.center(w + 1)
		print bar
	end
	print "\n"
		# and pct of atoms
	ekeys.each do |ek|
		bar = sprintf("%4.2f", ebins[ek][:afrac] * 100.0).to_s.center(w + 1)
		print bar
	end
	print "\n"	
	puts "-" * width
end

e = PGenEnv.new  # use generic 12-element universe
sploopn = 1000
specs = []

ef = {H: -3.0}
mdist = {VOL: 0.9, LITHO: 0.085, CHALCO: 0.02, SIDERO: 0.013}

loop do
	sploopn.times do |spi|
		mdist.each do |mdk, mdv|
			specs << e.mat[specpick(e, {types: [mdk], efilter: ef})].formula if rand < mdist[mdk]
		end
	end
	
	bins = elemsum(e, specs)
	
	# debug
#	bins.each {|k,v| puts "#{k}:#{v[:cnt]} #{v[:wfrac]}"}
	#
	elemhhist(e, bins)
	print "Continue?"
	dummy = gets.chomp
	puts
	if dummy =~ /[qQ]/
		break
	end
end
