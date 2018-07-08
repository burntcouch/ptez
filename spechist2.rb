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
	topa = ekeys.inject(0) {|i,ek| i = (i < ebins[ek][:afrac] ? ebins[ek][:afrac] : i)}
	topw = ekeys.inject(0) {|i,ek| i = (i < ebins[ek][:wfrac] ? ebins[ek][:wfrac] : i)}
	w = width - 11
	wscalea = w.to_f / topa
	wscalew = w.to_f / topw
	ekeys.each do |ek|
		printf("%-2s %5.2f |", ek.to_s, ebins[ek][:afrac] * 100.0)
		print "x" * ((wscalea *  ebins[ek][:afrac]).to_i + 1) if ebins[ek][:afrac] > 0.0
		print "\n"
	end
	puts "-" * width
	ekeys.each do |ek|
		printf("%-2s %6.3f |", ek.to_s, ebins[ek][:wfrac] * 100.0)
		print "x" * ((wscalew *  ebins[ek][:wfrac]).to_i + 1) if ebins[ek][:afrac] > 0.0
		print "\n"
	end	
	puts "-" * width
end

SIDERITE = {VOL: 0.001, LIGHT: 0.019, HEAVY: 0.06, SIDERO: 0.93}
VESTA = {VOL: 0.01, LIGHT: 0.1, HEAVY: 0.3, SIDERO: 0.59}
MERCURY = {VOL: 0.01, LIGHT: 0.2, HEAVY: 0.35, SIDERO: 0.44}
EARTH = {VOL: 0.05, LIGHT: 0.3, HEAVY: 0.3, SIDERO: 0.35}
METEORITE = {VOL: 0.5, LIGHT: 0.2, HEAVY: 0.2, SIDERO: 0.1}
COMET = {VOL: 0.93, LIGHT: 0.06, HEAVY: 0.006, SIDERO: 0.004}

e = PGenEnv.new  # use generic 12-element universe
sploopn = 10000
specsm = Hash.new(0.0)

ef = {H: -3.0}
mdist = METEORITE
spabd = mdist.keys.inject({}) {|h, x| h[x] = species(e, :ABD, [x], nil,  ef); h}
mtot = 0.0
atot = 0.0

loop do
	sploopn.times do |spi|
		mdk = wtpick(mdist)
		sk = specpick_c(e, spabd[mdk])
		s = e.mat[sk].formula
		specsm[s] += 1.0
		atot += 1.0
		mtot += e.mat[sk].delta
	end
	bins = elemsum(e, specsm)
	elemhhist(e, bins)
	puts sprintf("DELTA: %7.1f\n", mtot / atot)
	print "Continue?"
	dummy = gets.chomp
	puts
	if dummy =~ /[qQ]/
		break
	end
end
