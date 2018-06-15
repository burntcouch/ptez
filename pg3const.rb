#  pgen3 constants
#
#  pg3const.rb
#
#  ALL MKS
#
BOLTZ = 1.381E-23
AMUKG = 1.66E-27
ELECKG = 9.109E-31
NEUTKG = 1.6749E-27
PROTKG = 1.6726E-27
EVOLT = 1.602E-19
MEVOLT = 1.602E-13
AVOGAD = 6.022E23
STEPHBOLTZ = 5.6696E-9
CEE = 2.9979E8
ONEATM = 1.013E5
SECPERYR = 3.147E7
#
MRAD = 1737000.0
ERAD = 6378000.0
JRAD = 69911000.0
EMASS = 5.976E24
SMASS = 1.990E30
MMASS = 7.3477E22
JMASS = 1.8986E27
KMROCK = 1.31E12
UGRAV = 6.67E-11
#
# VT: vaporization temp - K
# CP: specific heat - J/kg-K
# SG: specific gravity - kg/m^3
# MW: molecular weight - amu
# TC: thermal conductivity - W/m-K
# HV: heat of vaporization - J/kg
#

ELEMFLDS = [:NUM, :AMU, :ABD, :OXY, :ION]

ELEMENTS = {H: [1, 1, 10.446], C: [6, 12, 7.004] , O: [8, 16, 7.377] , N: [7, 14, 6.496] , 
	K: [13, 28, 4.788], Mg: [15, 29, 6.055] , Al: [13, 27, 4.929], Cl: [17, 35 , 3.785 ],
	Si: [14, 28, 6.0] , S: [16, 32, 5.712], Fe: [26, 56, 5.954], U: [92, 238, -1.372]}

SPECFLDS = [:FORMULA, :AMU, :DELTA, :THERMO]

SPECIES = { VOL: {methane: [:CH4, 16, 470] , water: [:H2O, 18, 1000 ] , ammonia: [:NH3, 17, 820 ], 
		carbon_dioxide: [:CO2, 44, 1560 ], sulfur: [:S, 32, 2000], salt: [:KCl, 63, 2165] },
	ROCK: {feldspar: [:AlKMgSi3O8, 300, 2650] , olivine: [:MgFeSiO4, 172, 3800], 
		silca: [:SiO2, 60, 2600] },
	METAL: {pyrite: [:FeS, 88, 5000 ], iron: [:Fe, 56, 7800], pitchblende: [:UFeSiO2, 350, 11000] } 
	}
	
REACT = [ 
	{TYPE: "MISC", LEFT: "Fe + S", RIGHT: "FeS", TEMP: 0, PRESS: 0, HEAT: 500},
	{TYPE: "OXY", LEFT: "(4)Fe + (3)O2", RIGHT: "(2)Fe2O3", HEAT: 500},
	{TYPE: "OXY", LEFT: "S + O2", RIGHT: "SO2", HEAT: 200},
	{TYPE: "CLOUD", LEFT: "(2)H2 + O2", RIGHT: "(2)H2O", HEAT: 500}
]

NREACT = {U238: "Pb", Al26: "Mg", K40: "Ar", U235: "Pb", Th232: "Pb", Cl36: "S", Ca41: "K", Fe60: "Ni",
	Ni59: "Co", Mn53: "Cr", Sn126: "Te", C14: "C"}

MATER={VOL: {MP: 200, BP:400.0, CP: 5000.0, SG: 500, MW: 25.0, TC: 0.2, HV: 1200.0}, 
	ROCK: {MP: 2500.0, BP: 3500.0, CP: 1500.0, SG: 3000, MW: 80.0, TC: 0.8, HV: 10000.0}, 
	METAL: {MP: 2000.0, BP: 3000.0, CP: 800.0, SG: 12000, MW: 100.0, TC: 100.0, HV: 5000.0}}
#
#--Various heat issues ---
#
#  metallic hydrogen onset about 4-500 GPa, various temperatures
#
# Specific heats  delta E = mass * delta T * Cp 
# U-116 J/kg-K  granite-790  silica-700  iron-450  ice-2100  H2(gas)-14300  CH4-2190  CO2-839  NH3-4700  N2-1040
#
# Heat of vaporiz. delta E = mass * Cv
# U-2100 KJ/kg Fe-6090  Al-10500  CH4-481  H2O-2260  NH3-1371  N2-200  H2-450  C-30000  Si-10710
#
# NUKEHEAT: MeV per decay (total decay chain), abundance vs. meteorites, half-life in years
#
NUKEHEAT = {
	U238: [52,8.00E-09,4.47E+09],
	Al26: [2.98,7.50E-05,7.17E+05],
	K40: [1.31,4.50E-05,1.25E+09],
	Th232: [80,3.30E-08,1.40E+10],
	U235: [200,4.00E-09,7.04E+08],
	Cl36: [0.709,1.25E-09,3.01E+05],
	Ca41: [0.421,1.00E-09,1.02E+05],
	Fe60: [3.1,1.00E-09,2.60E+06],
	Ni59: [0.051,1.00E-09,7.60E+04],
	Mn53: [0.597,1.00E-09,3.81E+06],
	Sn126: [4.038,1.00E-09,2.30E+05],
	C14: [0.157,1.00E-05,5.71E+03]
}
#
# Phase points:  Triple point, boiling point, critical point, dissociation and ionization
#
# tpT, tpP (kPa), bpT, bpA (kPa), cpT, cpA (mPa), bondstr kJ/mole, first ionization kJ/mole 
#
PHASEFLDS = [:TPT, :TPP, :BPT, :BPP, :CPT, :CPP, :DISSOC, :IONIZE]

PHASEPT = {
	H2O: [273.16,0.612,373.160,101.000,647.4,22.00,492.2,1312],
	SO2: [197.69,1.670,263.000,101.000,430.7,7.88,300,999.6],
	CO2: [216.55,517.000,216.55,517.000,304.2,7.39,532,1086],
	O2: [54.36,0.152,90.188,101.000,154.8,5.08,498,1313],
	N2: [63.18,12.600,77.355,101.000,126.3,3.39,945,1402],
	D2: [18.63,17.100,25.000,101.000,40.0,2.00,436,1312],
	H2: [13.84,7.040,20.270,101.000,33.2,1.30,436,1312],
	CH4: [90.68,11.700,109.150,101.000,190.6,4.66,435,1086],
	Ar: [83.81,68.900,87.300,101.000,150.7,4.86,nil,1521],
	NH3: [195.40,6.060,239.800,101.000,405.5,11.30,391,1312],
	Ne: [24.57,43.200,27.100,101.000,44.5,2.77,nil,2081],
	Hg: [234.20,1.65E-07,629.880,101.000,1750.0,172.00,nil,1007],
	Pt: [2045.00,2.00E-04,4098.000,101.000,8450,500.00,nil,870],
	Ti: [1941.00,5.30E-03,3560.000,101.000,15500,700.00,nil,659],
	Zn: [692.65,0.065,1180.000,101.000,3380,100.00,nil,906],
	Fe: [1811.00,1.00E-05,3134.000,101.000,9250,887.00,nil,760],
	S: [392.00,0.051,717.800,101.000,1314,20.70,nil,999.6],
	Al2O3: [2072.00,1.00E-03,2977.000,101.000,nil,nil,512,578],
	U: [1405.00,1.00E-04,4404.000,101.000,12500,500.00,nil,597.6]
}

class Array  # a MUCH handier version of 'include?'
	require 'set'
	def inter(x)
		Set.new(self).intersection(Set.new([x].flatten)).to_a
	end
	
	def inter?(x)
		unless x.is_a?(Array)
			return self.include?(x)
		else
			return !self.inter(x).empty?
		end
	end
end

class PMater
	attr_accessor :formula, :delta
	
	attr_reader :types
	
	def initialize(env, name, formula, types, delta, thermo)
		@env = env
		@name = name
		@formula = formula
		@delta = delta
		@types = types
		@thermo = thermo
	end
	
	def add_type(type)
		self.types << type
	end
	
	def set_thermo(thdata)
		thdata.each do |k,v|
			self.thermo[k] = v
		end
	end
	
	def is_type?(t)
		@types.include?(t)
	end
	
	def has?(atom)
		self.atoms.keys.include?(atom)
	end
	
	def x(what)
		res = case what
			when :CP then self.specheat
			when :TP then self.triple
			when :TPT then self.triple[:T]
			when :TPP then self.triple[:P]
			when :AMU then self.amu
			when :CRP then self.critical
			when :CPT then self.critical[:T]
			when :CPP then self.critical[:P]
			when :TC then self.condt
			when :HV then self.vapheat
			when :SG then self.delta
			when :DIS then self.dissoc
			when :ION then self.ionize
			when :HAS then self.atoms.keys
			when :IS then self.types
		end
		return res
	end
	
	def amu
		self.atoms.keys.inject(0) {|a,k| a += @env.elem[k][:AMU] * self.atoms[k]} 
	end
	
	def atoms
		eatoms(@env, @formula)
	end
	
	def triple 
		{T: @thermo[:TPT], P: @thermo[:TPP]}
	end
	
	def boiling
		{T: @thermo[:BPT], P: @thermo[:BPP]}
	end
	
	def critical
		{T: @thermo[:CPT], P: @thermo[:CPP]}
	end
	
	def dissoc
		@thermo[:DISSOC]
	end
	
	def ionize
		@thermo[:IONIZE]
	end
	
	def specheat
		@thermo[:CP].nil? ? MATER[@types[0]][:CP] : @thermo[:CP]
	end
	
	def vapheat
		@thermo[:HV]
	end
	
	def condt 
		@thermo[:TC]
	end
	
	
	def phase(t, p)
#  LOTS of work yet to do here.  SOLID phase does not exist beyond triple point 
# temperature at this point, which doesn't jive with real substances at higher (> 1GPa)
# pressures.  Dissociation and ionization should also be affected by high pressure.
#
		env = @env
		spec = self.formula
		ph = :SOLID
		c = 0
		curv = []
		unless @thermo.nil? || @thermo[:TPT].nil?
			tstart = 1.0
			pstart = 1.0
			pparms = [:TPT, :TPP, :BPT, :BPP, :CPT, :CPP, :DISSOC, :IONIZE]
			loop do
				ttop = @thermo[pparms[c*2]]
				if ttop.nil?
					curv << nil
					c += 1
					break if c == 3
					next
				end
				ptop = @thermo[pparms[c*2 + 1]] * 1000.0
				ptop *= 1000.0 if c == 2
				curv << (Math::log(ptop) - Math::log(pstart)) / (Math::log(ttop) - Math::log(tstart))
				curv[-1] = Math::log(pstart) + (Math::log(t) - Math::log(tstart)) * curv[-1]
				if t > tstart && t <= ttop
					break
				else
					tstart = ttop
					pstart = ptop
					c += 1
					break if c == 3
				end
			end
		end
		if c == 3  # above critical temp
			tt = t / 500.0
			ph = :SUPER
			ph = :GAS if @thermo[:CPP] * 1e6 > p
			ph = :DISSOC if !@thermo[:DISSOC].nil? && @thermo[:DISSOC] < tt
			ph = :IONIZED if !@thermo[:IONIZE].nil? && @thermo[:IONIZE] < tt
		elsif c == 0
			ph = :GAS if Math::log(p) < curv[c] # below triple point
		else
			ph = :LIQUID
			ph = :GAS if Math::log(p) < curv[c]
		end
	
		return ph
	
	end
	
	
end

### YES.  Need to get the below and the above done, then rewrite and test all the 'library' chem functions
# down at the bottom, ie species, specpick, rspec, elem, atoms, phase, nukeheat  etc...
#  THEN....work on the ptez classes PBlob and PLayer...
#
#


class PGenEnv
	attr_accessor :elem, :mat, :mreact, :nreact, :nuke
	
	def initialize(configfile=nil)
		if configfile.nil?
			self.default_config
		else
			self.load_all(configfile)
		end
	end
	
	def default_config
		@elem = ELEMENTS.keys.inject({}) do |eh, ek|
			eh[ek] = 0.upto(ELEMFLDS.size - 1).inject({}) do |ehh, ex| 
				ehh[ELEMFLDS[ex]] = ELEMENTS[ek][ex] unless ELEMENTS[ek][ex].nil?
				ehh[ELEMFLDS[ex]] = nil if ELEMENTS[ek][ex].nil?
				ehh
			end
			eh
		end
		
		@mat = SPECIES.keys.inject({}) do |mh, tk|
			SPECIES[tk].each do |sk,sv|
				unless PHASEPT[sv[0]].nil?
					t = PHASEPT[sv[0]]
					therm = 0.upto(t.size - 1).inject({}) {|h, tx| h[PHASEFLDS[tx]] = t[tx]; h}
				else
					therm = {}
				end	
				mh[sk] = PMater.new(self, sk, sv[0], [tk], sv[2], therm)
			end
			mh
		end
		@mreact = REACT  # this okay for now
		@nreact = NREACT # and this too..nothing dpendend on it yet
		@nuke = NUKEHEAT # and hopefully this will do for a while also
	end
	
	def nukeheat
		# will create a hash of decay items: {nucleus: [MeV total, 1/2 life, final decay product, abundance]}
	
		return self.nuke.nil? ? NUKEHEAT : self.nuke
	end

	def load_elem(fn)
	
	end
	
	def load_mat(fn)
	
	end
	
	def load_react(fn)
	
	end
	
	def load_nuke(fn)
	
	end


	def load_all(cfn)
	
	end

end

def wtpick(whash) # weighted pick : whash has {thing => weight}
	totw = whash.values.inject(0.0) {|t,w| t += w}
	pickw = rand * totw
	ptot = 0.0
	return whash.keys.select {|k| ptot += whash[k]; ptot > pickw}.first
end

def rspec(env, spec)  # converts "(Mg,Fe)2SiO4" to (randomly) "Mg2SiO4" or "FeMgSiO4"
	res = spec.dup
	loop do
		ma = res.match(/(.*)(\((([A-Z][a-z]?,)+([A-Z][a-z]?))\)(\d+)?)(.*)/)
		break if ma.nil?
		break if ma[3].nil? || ma[3] == ""
		elist = ma[3].split(',').map {|e| e.intern}
		numpics = 1
		numpics = ma[6].to_i unless ma[6].nil? || ma[6] == ""
		abd = elem(env, :ABD, elist)
		thepicks = Hash.new(0)
		numpics.times { thepicks[wtpick(abd)] += 1 }
		rsub = thepicks.keys.inject("") do |str, k|
			str << "#{k.to_s}"
			str << "#{thepicks[k].to_s}" if thepicks[k] > 1
			str
		end
		res.sub!(ma[2], rsub)
	end	
	return res
end

def specpick(env) 
	x = species(env, :ABD)
	picklist = x.keys.inject({}) {|h,sk| h[sk] = x[sk][:ABD]; h }
	return wtpick(picklist)
end

def specmass(env, tmass, rounds=1000)
	genmat = Hash.new(0.0)
	rounds.times do |ri|
		x = specpick(env)
		amt = rand * tmass/(rounds.to_f)
		genmat[x] += amt
	end
	
	return genmat
end

def species(env, what, types=:ALL, elist=nil, efilter=nil)
	mlist = env.mat
	ws = nil
	if what == :ABD
		ws = {}
		eabd = elem(env, :ABD, elist, efilter)
		mlist.keys.each do |mtk|
			if types == :ALL || types.inter?(mlist[mtk].types)
				matoms = eatoms(env, mlist[mtk].formula)
				abd = 1.0
				matoms.each do |mak, mav|
					a = eabd[mak] / (mav.to_f)
					abd = a if abd > a
				end 
				ws[mtk] = {ABD: abd, AMU: mlist[mtk].amu}
			end
		end
	elsif what.is_a?(Hash) && !what[:HAS].nil?
		
	end
	
	return ws
end

def elem(env, what, elist=nil, efilter=nil) 
		# elist e.g.: [:C, :H, :O, :N], efilter e.g.: {H: -3.0, O: -0.5}
	elems = env.elem
	we = nil
	if what == :ABD  # abundance fraction
		we = {}
		tot = 0.0
		elems.each do |ek, ev|
			abdi = Math::exp(ev[:ABD] + ((efilter.nil? || efilter[ek].nil?) ? 0.0 : efilter[ek]))
			if elist.nil? || elist == :ALL || elist.include?(ek)
				we[ek] = abdi
				tot += abdi
			end
		end
		we.keys.each do |ek|
			we[ek] /= tot
		end
	end
	return we
end

def eatoms(env,spec)
	atlist = Hash.new(0)
	s = spec.to_s
	t1 = /([A-Z][a-z]?[\d]?[\d]?)+/  #RSx style, e.g. MgSiO3
	t2 = /(\d+[A-Z][a-z]?)+/  #xRxS style, e.g. 1Mg1Si3O
	
	loop do
		ma = s.match(/\((#{t1}|#{t2})\)(\d+)?/)
		break if ma.nil?
		at0 = eatoms(env, ma[1]) unless ma[1].nil? || ma[1] == ""
		unless ma[4] == ""
			at0.keys.each do |k|
				at0[k] *= ma[4].to_i
			end
		end
		atlist.merge!(at0)
		s = s.sub(ma[0],"")
	end
	s = rspec(env, s)
	if s =~ (/\A(#{t1}|#{t2})\z/) 
		loop do
			ma = s.match(/(([A-Z][a-z]?)([\d]?[\d]?))|((\d+)([A-Z][a-z]?))/)
			unless ma.nil?
				if ma[4].nil?
					atlist[ma[2].intern] += 1
					atlist[ma[2].intern] += (ma[3].to_i - 1) unless ma[3] == ""
				else
					atlist[ma[6].intern] += 1
					atlist[ma[6].intern] += (ma[5].to_i - 1) unless ma[5] == ""			
				end
			end
			s = s.sub(ma[0], "")
			break if s == ""
		end
	end
	return atlist
end

def phase
end

def nukeheat(env, t, dt, enrich={})  # t and dt in seconds!  enrich={U238: 2.0} means double the abundance of U238
	nukeh = env.nukeheat
	
	totheat = 0.0
	nukeh.each do |k,v|
		amu = k.to_s.match(/\d+/)[0].to_f
		orgm = 0.14 * (1000.0 / amu) * v[1] * AVOGAD # assumes Si at 14% by mass, but...
		unless enrich[k].nil?
			orgm = orgm * enrich[k]
		end
		unless enrich[:ALL].nil?  # handy.  Si abundance double on Earth vs. meterites...
			orgm = orgm * enrich[:ALL]
		end
		lambda = Math::log(2.0) / (v[2] * SECPERYR)
		if (t - dt/2.0) < 0 || dt.nil?
			decrate = orgm * (1.0 - Math::exp(-1.0 * lambda * t))
			heat += decrate  * v[0] * MEVOLT
		else
			heat = 0.0
			0.upto(99) do |i|
				delt = i.to_f * dt / 100.0
				decrate = orgm * lambda * Math::exp(-1.0 * lambda * (t + delt))
				heat += decrate * v[0] * MEVOLT * dt / 100.0
			end
		end
		# puts "#{k} #{heat}"
		totheat += heat
	end
	return totheat
end

def sinefrac(val, min, max, slack=nil)  # look in pchem to figger what this does exactly
	tol = slack || 0.1
	frac = 1.0
	if !val.nil?
		if !min.nil? && val < min
			frac = 0.5 - 0.5 * Math::sin(0.5 * Math::PI * ((min - val ) / (min - min * (1.0 - tol))))
			frac = 0.0 if val < min * (1.0 - tol)
		elsif !min.nil? && max.nil? && val > min
			frac = 0.5 + 0.5 * Math::sin(0.5 * Math::PI * (val - min) / (min * (1.0 + tol) - min))
			frac = 1.0 if val > min * (1.0 + tol)
		elsif !min.nil? && !max.nil? && val > min && val < max
			frac = 0.5 + 0.5 * Math::sin(Math::PI * (val - min) / (max - min))
		elsif !max.nil? && min.nil? && val < max
			frac = 0.5 + 0.5 * Math::sin(0.5 * Math::PI * (max - val) / (max - max * (1.0 - tol)))
			frac = 1.0 if val < max * (1.0 - tol)
		elsif !max.nil? && val > max
			frac = 0.5 - 0.5 * Math::sin(0.5 * Math::PI * ((val - max ) / (max * (1.0 + tol) - max)))
			frac = 0.0 if val > max * (1.0 + tol)
		end
	end

	return frac
end

# end of pg3const.rb
#  
