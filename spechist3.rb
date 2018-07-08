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

SIDERITE = {ICE: 0.001, WET: 0.001, DRY: 0.008, HEAVY: 0.03, CHALCO: 0.04, SIDERO: 0.05, METAL: 0.87}
VESTA = {ICE: 0.01, WET: 0.001 , DRY: 0.099, HEAVY: 0.18, CHALCO: 0.06, SIDERO: 0.10, METAL: 0.55}
MERCURY = {ICE: 0.01, WET: 0.001, DRY: 0.229, HEAVY: 0.39, CHALCO: 0.03, SIDERO: 0.04, METAL: 0.3}
EARTH = {ICE: 0.05, WET: 0.06, DRY: 0.26, HEAVY: 0.26, CHALCO: 0.03 , SIDERO: 0.04, METAL: 0.3}
S_METEORITE = {ICE: 0.13, WET: 0.35, DRY: 0.38, HEAVY: 0.08, CHALCO: 0.015, SIDERO: 0.005, METAL: 0.04}
C_METEORITE = {ICE: 0.38, WET: 0.28, DRY: 0.29, HEAVY: 0.025, CHALCO: 0.01, SIDERO: 0.003, METAL: 0.012}
COMET = {ICE: 0.92, WET: 0.03, DRY: 0.03, HEAVY: 0.009, CHALCO: 0.005, SIDERO: 0.001, METAL: 0.005}

e = PGenEnv.new  # use generic 28-element universe
sploopn = 50000
specsm = Hash.new(0.0)

# add a depletion factor per distance
puts "dist AU:"
dau = gets.chomp.to_f
ef = vdef_filter(dau)

mdist = C_METEORITE
spabd = species(e, :ABD, [:ICE, :DRY, :HEAVY, :CHALCO, :SIDERO, :METAL], nil,  ef)
#spabd = mdist.keys.inject({}) {|h, x| h[x] = species(e, :ABD, [x], nil,  ef); h}

mtot = 0.0
atot = 0.0
spcnt = 0
slookup = {}

loop do
	sploopn.times do |spi|
#		mdk = wtpick(mdist)
#		sk = specpick_c(e, spabd[mdk])
		sk = specpick_c(e, spabd)
		s = e.mat[sk].formula
		sdk = e.mat[sk].types.sample
		slookup[s] = sk if slookup[s].nil?
		amt = (rand > 0.5 ? (1.0 / (0.3 + 0.7 * rand)) : (0.3 + 0.7 * rand))
		amt = amt * mdist[sdk]
		specsm[s] += amt
		atot += amt
		mtot += amt * e.mat[sk].delta
	end
	spcnt += sploopn
	bins = elemsum(e, specsm)
	elemhhist(e, bins)
	gets
	
	ss = slookup.keys.sort {|a,b| specsm[b] <=> specsm[a]}
	ss.each do |sf|
		sk = slookup[sf]
		printf("%-40s: %8.1f %6.3f\n", "#{sk} (#{sf})", specsm[sf], specsm[sf] * 100.0 / atot)
	end
	puts "-" * 77
	
	puts sprintf("DIST: %5.1f  DELTA: %7.1f  COUNT: %i\n", dau, mtot / atot, spcnt)
	print "Continue?"
	dummy = gets.chomp
	puts
	if dummy =~ /[qQ]/
		break
	end
end
