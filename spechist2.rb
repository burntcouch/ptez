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
	specs.each do |sk, sv|
		ea = eatoms(env, sk)
		ea.each do |ek, ev|
			ebins[ek] = {afrac: 0.0, wfrac: 0.0} if ebins[ek].nil?
			atf = ev * sv
			wtf = atf * env.elem[ek][:AMU]
			ebins[ek][:afrac] += atf
			ebins[ek][:wfrac] += wtf
			wtot += wtf
			atot += atf
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

e = PGenEnv.new  # use generic 12-element universe
sploopn = 10000
specsm = Hash.new(0.0)

ef = {H: -3.0}
mdist = {VOL: 0.15, LITHO: 0.75, CHALCO: 0.02, SIDERO: 0.08}

spabd = mdist.keys.inject({}) {|h, x| h[x] = species(e, :ABD, [x], nil,  ef); h}

loop do
	sploopn.times do |spi|
		mdk = wtpick(mdist)
		s = e.mat[specpick_c(e, spabd[mdk])].formula
		specsm[s] += 1.0
	end
	
	bins = elemsum(e, specsm)
	
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
