#!/usr/bin/ruby
#
#
# nuke cooker 1
#
#

module NukeCooker

	PROTONS = { H: 1, He: 2, Li: 3, Be: 4, B: 5, C: 6, N: 7, O: 8, F: 9, Ne: 10,
		Na: 11, Mg: 12, Al: 13, Si: 14, P: 15, S: 16, Cl: 17, Ar: 18, K: 19, Ca: 20,
		Sc: 21, Ti: 22, V: 23, Cr: 24, Mn: 25, Fe: 26, Co: 27, Ni: 28, Cu: 29, Zn: 30,
		Ga: 31, Ge: 32, As: 33, Se: 34, Br: 35, Kr: 36, Rb: 37, Sr: 38, Y: 39, Zr: 40,
		Nb: 41, Mo: 42, Tc: 43, Ru: 44, Rh: 45, Pd: 46, Ag: 47, Cd: 48, In: 49, Sn: 50,	
		Sb: 51, Te: 52, I: 53, Xe: 54, Cs: 55, Ba: 56, La: 57, Ce: 58, Pr: 59, Nd: 60,
		Pm: 61, Sm: 62, Eu: 63, Gd: 64, Tb: 65, Dy: 66, Ho: 67, Er: 68, Tm: 69, Yb: 70,
		Lu: 71, Hf: 72, Ta: 73, W: 74, Re: 75, Os: 76, Ir: 77, Pt: 78, Au: 79, Hg: 80,
		Tl: 81, Pb: 82, Bi: 83, Po: 84, At: 85, Rn: 86, Fr: 87, Ra: 88, Ac: 89, Th: 90,
		Pa: 91, U: 92, Np: 93, Pu: 94, Am: 95, Cm: 96, Bk: 97, Cf: 98, Es: 99, Fm: 100,
		Md: 101, No: 102, Lr: 103, Rf: 104, Db: 105, Sg: 106, Bh: 107, Hs: 108, Mt: 109, Ds: 110,
		Rg: 111, Cn: 112, Nh: 113, Fl: 114, Mc: 115, Lv: 116, Ts: 117, Og: 118 
	}
	#
	# 'test' data ('nuclides.csv' has 3300 entries!)
	#
	NUKES = { e: {n: 0, p: 0, be: 0.45, half: nil},
		n: {n: 1, p: 0, be: 800.0, half: 881.5, decay: ['b-', 0.782, :H]}, 
		H: {n: 0, p: 1, be: 782.327, half: nil},	
		D: {n: 1, p: 1, be: 1503.327, half: nil}, 
		T: {n: 2, p: 1, be: 2827.265, half: 3.88e8, decay: ['b-', 0.0186, :He3]}, 
		He2: {n: 0, p: 2, be: 1400.000, half: 1e-99, decay: ['ec', 0.0, :D]},
		He3: {n: 1, p: 2, be: 3094.327, half: nil},	
		He4: {n: 2, p: 2, be: 7073.915, half: nil}, 
		He5: {n: 3, p: 2, be: 5512.132, half: 8e-22, decay: ['n', 0.890, :He4]},
		Li5: {n: 2, p: 3, be: 5266.132, half: 3e-22, decay: ['p', 1.965, :He4]},
		Li6: {n: 3, p: 3, be: 5332.331, half: nil},
		Li7: {n: 4, p: 3, be: 5606.439, half: nil},
		Be8: {n: 4, p: 4, be: 7062.435, half: 8e-17, decay: ['a', 0.9184, :He4]},
		Be9: {n: 5, p: 4, be: 6462.668, half: nil},
		Be10: {n: 6, p: 4, be: 6497.63, half: 4.7e10, decay: ['b-', 0.5559, :B10]},
		B8: {n: 3, p: 5, be: 4717.155, half: 0.77, decay: ['b+', 0.0, :Be8]},
		B9: {n: 4, p: 5, be: 6257.07, half: 8.4e-19, decay: ['p', 0.185, :Be8]}, 
		B10: {n: 5, p: 5, be: 6475.083, half: nil}, 
		B11: {n: 6, p: 5, be: 6927.732, half: nil}, 
		B12: {n: 7, p: 5, be: 6631.223, half: 0.0202, decay: [['b-',13.37, :C12, 0.984],['b-a', 6.0023, :Be8, 0.016]]},
		C11: {n: 5, p: 6, be: 6676.456, half: 1220.0, decay: ['b+', 0.960, :B11]}, 
		N13: {n: 6, p: 7, be: 7238.863, half: 598.0, decay: ['b+', 1.198, :C13]},
		C12: {n: 6, p: 6, be: 7680.144, half: nil}, 
		C13: {n: 7, p: 6, be: 7469.849, half: nil}, 
		C14: {n: 8, p: 6, be: 7520.319, half: 1.8e11, decay: ['b-', 0.156, :N14]},
		N14: {n: 7, p: 7, be: 7475.614, half: nil}, 
		N15: {n: 8, p: 7, be: 7699.46, half: nil}, 
		N16: {n: 9, p: 7, be: 7373.796, half: 7.13, decay: ['b-', 10.421, :O16]},
		O15: {n: 7, p: 8, be: 7463.692, half: 122.4, decay: ['b+', 1.732, :N15]}, 
		O16: {n: 8, p: 8, be: 7976.206, half: nil}, 
		O17: {n: 9, p: 8, be: 7750.728, half: nil}, 
		O18: {n: 10, p: 8, be: 7767.097, half: nil}, 
		O19: {n: 11, p: 8, be: 7566.495, half: 26.88, decay: ['b-', 4.822, :F19]}, 
		N17: {n: 10, p: 7, be: 7286.229, half: 4.173, decay: [['b-n', 4.537, :O16, 0.95],['b-', 0.0, :O17, 0.05]]},
		F17: {n: 8, p: 9, be: 7542.328, half: 64.5, decay: ['b+', 1.7838, :O17]}, 
		F18: {n: 9, p: 9, be: 7631.638, half: 6586.2, decay: ['b+', 0.633, :O18]}, 
		F19: {n: 10, p: 9, be: 7779.018, half: nil}, 
		F20: {n: 11, p: 9, be: 7720.134, half: 11.07, decay: ['b-', 7.0245, :Ne20]}, 
		F21: {n: 12, p: 9, be: 7738.293, half: 4.158, decay: ['b-', 5.684, :Ne21]},
		Ne18: {n: 8, p: 10, be: 7341.257, half: 1.672, decay: ['b+', 3.421, :F18]}, 
		Ne19: {n: 9, p: 10, be: 7567.343, half: 17.22, decay: ['b+', 2.2166, :F19]}, 
		Ne20: {n: 10, p: 10, be: 8032.24, half: nil}, 
		Ne21: {n: 11, p: 10, be: 7971.713, half: nil}, 
		Ne22: {n: 12, p: 10, be: 8080.465, half: nil}, 
		Ne23: {n: 13, p: 10, be: 7955.256, half: 37.24, decay: ['b-', 4.375, :Na23]},
		Na23: {n: 12, p: 11, be: 8111.493, half: nil},
		Sc46: {n: 25, p: 21, be: 8622.012, half: 7.238e6, decay: ['sf', 0.0, :Ne23, nil, :Na23] }
	}
	
	SFSPEC = [:C12, :C14, :O16, :O18, :Ne20, :Ne22, :Ne24, :Mg24, :Mg26, :Si28, :Si32, :Si34, :S32, :S34, :S36,
		:Ar36, :Ar38, :Ar40, :Ar42, :Ca40, :Ca44, :Ca48, :Ti48, :Ti50, :Cr52, :Cr54, :Fe56, :Fe60, :Ni62, :Ni64,
		:Sn120, :Sn122, :Sn126, :Xe132, :Xe134, :Xe136, :Ba140, :Ba136, :Ba138, :Te130, :Sr90, :Kr86, :Se82, :Ge76,
		:Zn70, :Zn72, :Zr96, :Mo100, :Ru104, :Ru106, :Pd110, :Cd116, :Ce144, :Nd150]

	NUKEINIT = {H: 0.9, D: 0.01, He3: 0.001, He4: 0.088, Li6: 0.00004, Li7: 0.00095, Be9: 0.00001}

	def load_nukes(fn)
		nukes = { 
			e: {n: 0, p: 0, be: 0.45, half: nil},
			n: {n: 1, p: 0, be: 800.0, half: 881.5, decay: ['b-', 0.782, :H]}, 
			H: {n: 0, p: 1, be: 782.327, half: nil},	
			D: {n: 1, p: 1, be: 1503.327, half: nil}, 
			T: {n: 2, p: 1, be: 2827.265, half: 3.88e8, decay: ['b-', 0.0186, :He3]},
			He2: {n: 0, p: 2, be: 1400.000, half: 1e-99, decay: ['ec', 0.0, :D]}
		}
		
		if !fn.nil? && File.file?(fn)
			tok = false
			File.open(fn).each do |fline|
				# Z,N,symb, half_life [s], decay, decay %, decay, decay %, decay, decay %,Binding/A
				if tok
				 #	puts fline
					z = fline.split(/\s*,\s*/)
					symb = z[2][0].upcase
					symb << z[2][1].downcase unless z[2].length == 1
					zk = "#{symb}#{(z[0].to_i+z[1].to_i).to_s}".intern
					half = (z[3] == "" ? nil : z[3].to_f)
					if half.nil? && !z[4].empty?
						half = 1e-99  # immediately decays!
					end
					nukes[zk] = {n: z[1].to_i, p: z[0].to_i, half: half, be: z[10].to_f}
					if half
						nukes[zk][:decay] = []
						dx = 4
						loop do
							a = [z[dx].downcase, 0.0, ""]
							a << (z[dx+1].empty? ? 1.0 : z[dx+1].to_f/100.0)
							nukes[zk][:decay] << a
							if z[dx+2].empty? || z[dx+1].empty? || dx+2 == 10
								break
							else
								dx += 2
							end
						end
						nukes[zk][:decay].flatten! if nukes[zk][:decay].size == 1
					end
				end
				tok = true
			end
			##
			## postprocess to fix which decay seq to keep
			##
			nukes.keys.each do |nk|
				unless nukes[nk][:half].nil?
					decs = nukes[nk][:decay]
					if decs[0].is_a?(Array) && decs.size > 1
						if decs[1][3] == 1.0
							decs[0] = decs[1]
							decs.delete_at(1)
						end
					end
					if decs[0].is_a?(Array) && decs.size > 1
						if decs[0][3] == 1.0
							dv = decs[1][3] + (decs[2].nil? ? 0.0 : decs[2][3])
							decs[0][3] = 1.0 - dv
						end
					end
					decs.flatten! if decs[0].is_a?(Array) && decs.size == 1
				end
			end
			
		else
			nukes = NUKES
		end
		return nukes
	end
	
	def wpick(whash) # weighted pick : whash has {thing => weight}
		totw = whash.values.inject(0.0) {|t,w| t += w}
		pickw = rand * totw
		ptot = 0.0
		return whash.keys.select {|k| ptot += whash[k]; ptot > pickw}.first
	end

	def findn(nukelist, n, p)
		res = nil
		if p == 1
			res = case n
				when 0 then :H
				when 1 then :D
				when 2 then :T
				else ("H%i" % (1 + n)).intern
			end
		elsif p == 0
			res = case n
				when 1 then :n
				when 0 then :e
			end
		else
			plookup = PROTONS.keys.sort {|a,b| PROTONS[a] <=> PROTONS[b]}
			amu = p + n
			res = "#{plookup[p - 1] .to_s}#{amu.to_s}".intern
		end
		unless nukelist[res].nil?
			res = {res => nukelist[res]}
		else
			res = {res => {new: true, n: n, p: p}}
		end
		return res
	end
	
	def bediff(nl1, nl2)
		be1 = nl1.reject {|n| n == :DELE || n == :GAMMA}.inject(0.0) do |b, n|
			begin
				b += n.be
			rescue
				puts "#{n.name}"
			end 
			b
		end
		be2 = nl2.reject {|n| n == :DELE || n == :GAMMA}.inject(0.0) do |b, n|
			begin
				b += n.be
			rescue
				puts "#{n.name}"
			end 
			b
		end
		return be2 - be1
	end
	
	def befrac(nl1, nl2)
		be1 = nl1.reject {|n| n == :DELE || n == :GAMMA}.inject(0.0) {|b, n| b += n.be; b}
		be2 = nl2.reject {|n| n == :DELE || n == :GAMMA}.inject(0.0) {|b, n| b += n.be; b}
		return (be2 - be1) / be1
	end
	
	class NukeEnv
		attr_accessor :nukes
		
		def initialize(nukefile)
			@nukes = load_nukes(nukefile)
		end
	
	end

	class Nuke
		attr_accessor :name, :nspec, :lasttime
		attr_reader :env
	
		def initialize(env, spec = nil, t = 0.0,  n = nil, p = nil)
			@env = env
			nukelist = @env.nukes
			if spec.nil? || nukelist[spec].nil?
				f = findn(nukelist, n, p)
				@name = f.keys[0]
				@nspec = f.values[0]
			elsif nukelist[spec]
				@name = spec
				@nspec = nukelist[spec]
			end
			@lasttime = t
		end
		
		def to_s
			self.half.nil? ? "" : sprintf("%5.2e", self.half)
			"#{self.name} P#{self.p} N#{self.n} HALF: #{hstr} T:#{self.lasttime}"
		end
		
		def upd(newt)
			self.lasttime = newt
		end
		
		def breakdown?(newt)
			res = false
			unless self.half.nil?
				r = Math::exp(Math::log(0.5) * (newt - self.lasttime) / self.half)
				res = rand > r
			end
			return res 
		end
		
		def decay_to
			res = []
			d = self.decay
			unless d.nil?
				if d[0].is_a?(Array)
					pick = rand
					dd = 0.0; px = 0
					d.each_with_index do |di, dx|
						dd += di[3]
						px = dx
						if pick < dd
							break
						end
					end
					r = d[px]
				else
					r = d
				end
					# make list of resulting stuff
		#		puts self.to_s
		#		puts r.map {|a| a.to_s}.join(',')
				case r[0]
					when 'b-'
						res << Nuke.new(@env, :e, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1, self.p + 1)
					when 'ec'
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p - 1)
					when 'b+'
						res << :DELE
						res << :GAMMA
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p - 1)
					when 'b-n'
						res << Nuke.new(@env, :n, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 2, self.p + 1)
					when 'a'
						res << Nuke.new(@env, :He4, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 2, self.p - 2)
					when 'b-a'
						res << Nuke.new(@env, :He4, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 3, self.p - 1)
					when 'sf'
						res << Nuke.new(@env, SFSPEC.sample, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - res[-1].n, self.p - res[-1].p)
					when 'n'
						res << Nuke.new(@env, :n, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1, self.p)
					when 'p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n, self.p - 1)
					when '2p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << Nuke.new(@env, :H, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n, self.p - 2)
					when 'b-p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1, self.p)
					when 'b-2p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << Nuke.new(@env, :H, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1, self.p - 1)					
					when 'ec+b+'  # assuming is the same as 'ec'
						res << :DELE
						res << :GAMMA
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p - 1)
					when 'b+p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << :DELE
						res << :GAMMA
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p)
					when '2n'
						res << Nuke.new(@env, :n, self.lasttime)
						res << Nuke.new(@env, :n, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 2, self.p)
					when 'ecp'
						res << Nuke.new(@env, :H, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p - 2)
					when 'eca'
						res << Nuke.new(@env, :He4, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1, self.p - 3)
					when 'b+2p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << Nuke.new(@env, :H, self.lasttime)
						res << :DELE
						res << :GAMMA
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p - 1)
					when 'ec2p'
						res << Nuke.new(@env, :H, self.lasttime)
						res << Nuke.new(@env, :H, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n + 1, self.p - 3)
					when '2b-'
						res << Nuke.new(@env, :e, self.lasttime)
						res << Nuke.new(@env, :e, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 2, self.p + 2)
					when '2b+'
						res << :DELE; res << :DELE
						res << :GAMMA; res << :GAMMA
						res << Nuke.new(@env, nil, self.lasttime, self.n + 2, self.p - 2)					
					when 'b-3n'
						res << Nuke.new(@env, :n, self.lasttime)
						res << Nuke.new(@env, :n, self.lasttime)
						res << Nuke.new(@env, :n, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 4, self.p + 1)
					when 'b-2n'
						res << Nuke.new(@env, :n, self.lasttime)
						res << Nuke.new(@env, :n, self.lasttime)
						res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n - 3, self.p + 1)
					when '2ec'
						res << :DELE; res << :DELE
						res << Nuke.new(@env, nil, self.lasttime, self.n + 2, self.p - 2)
					when 'ecsf'
						res << :DELE
						res << Nuke.new(@env, SFSPEC.sample, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1 - res[-1].n, self.p + 1 - res[-1].p)
					when '14c'
						res << Nuke.new(@env, :C14, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1 - res[-1].n, self.p + 1 - res[-1].p)
					when '24ne'
					  res << Nuke.new(@env, :Ne24, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1 - res[-1].n, self.p + 1 - res[-1].p)
					when '22ne'
						res << Nuke.new(@env, :Ne22, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1 - res[-1].n, self.p + 1 - res[-1].p)
					when '28mg'
						res << Nuke.new(@env, :Mg28, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1 - res[-1].n, self.p + 1 - res[-1].p)
					when '34si'
						res << Nuke.new(@env, :Si34, self.lasttime)
						res << Nuke.new(@env, nil, self.lasttime, self.n - 1 - res[-1].n, self.p + 1 - res[-1].p)				
				end
			end
			return res
		end
		
		def fuse(n2)
			Nuke.new(nil, self.lasttime, self.n + n2.n, self.p + n2.p)
		end
	
		def is_new?
			!self.nspec[:new].nil?
		end
		
		def be
			self.name == :e ? self.nspec[:be] : (self.nspec[:be] * (self.n + self.p))
		end
	
		def n
			self.nspec[:n]
		end
	
		def p
			self.nspec[:p]
		end

		def half
			self.nspec[:half]
		end
	
		def decay
			self.nspec[:decay].nil? ? nil : self.nspec[:decay]
		end
	end

	class NukeTank
		attr_accessor :tank, :elec, :stopt, :heat
		attr_reader :env
	
		def initialize(env, ncnt, fill=:INIT)
			@env = env
			@stopt = 0.0
			@elec = 0
			@heat = 0.0
			filltank(ncnt, fill)
		end
		
		def mass
			self.tank.inject(0) {|m, n|	m += (n.n + n.p)}
		end
		
		def temp
			self.heat / (self.mass * 10000.0)
		end
		
		def pcnt
			self.tank.inject(0) {|i, n| i += n.p}
		end
		
		def ncnt
			self.tank.inject(0) {|i, n| i += n.n}
		end
	
		def charge
			self.pcnt - self.elec
		end
		
		def zerocharge(delep = 0)
			c = (delep != 0 ? -delep : self.charge)
			self.elec += c
		end
		
		def cleartank(t=0.0)
			self.tank = []
			self.elec = 0
			self.stopt = t
		end
	
		def filltank(num, opt=:MIX)
			self.tank = []
			if opt == :MIX
				1.upto(num) do |ni|
					npick = @env.nukes.keys.sample
					self.addnuke(Nuke.new(@env, npick))
				end
				self.zerocharge
			elsif opt == :INIT
				1.upto(num) do |ni|
					self.addnuke(Nuke.new(@env, wpick(NUKEINIT)))
				end
				self.zerocharge
			end
			return self
		end
		
		def addnuke(n, no_t=false)
			if n.name != :e
				n.lasttime = self.stopt unless no_t
				self.tank << n
			else
				self.elec += 1
			end
		end
	
		def upd(dt)
			self.get_decayed(dt)
	
			self.stopt += dt
		end
	
		def cook(steps, dt, flux=nil, frate=nil)
			dtt = dt / steps
			# check for decays
			0.upto(steps - 1) do |s|			
				x = get_decayed(self.stopt + dtt * s)													  # decays
				do_flux(flux, steps, self.stopt + dtt * s) unless flux.nil?     # particle fluxes (p and n)
				do_fusion(frate, steps, self.stopt + dtt * s) unless frate.nil? # fusion. need to adjust frate w/temperature...
			end
			self.zerocharge
			self.stopt += dt
		end
		
		def do_fusion(frate, steps, newt)
			# pick2
			nuke1 = rand(self.tank.size)
			nuke2 = nil
			loop do
				nuke2 = rand(self.tank.size)
				break if nuke1 != nuke2
			end
			n1 = self.tank[nuke1]; n2 = self.tank[nuke2]
			baserate = 1.0 / (n1.p * n1.p * n2.p * n2.p)  # coulomb force goes up as square of charge
			baserete = baserate * frate / steps
			newn = Nuke.new(@env, nil,  newt,n1.n + n2.n, n1.p + n2.p)
			netbe = bediff([n1, n2], [newn])
			if rand < baserate && netbe > 0.0
				self.heat += (netbe * 1000.0)
				self.tank.delete_at(nuke1)
				self.tank.delete_at(nuke2)
				if !newn.half.nil? && newn.half < 1e-20
					d = newn.decay_to
					self.proc_decay(d, newt)
				else
					self.addnuke(newn, true)
				end
			end
		end
		
		def do_flux(flux, steps, newt)
			fperc = {}
			flux.each {|fk,fv| fperc[fk] = fv.to_f / steps}
			fperc.keys.each do |fk|
				if rand <= fperc[fk] 
					oldn = nil; nukep = nil;
					loop do
						nukep = rand(self.tank.size)
						oldn = self.tank[nukep]
						break if oldn.name != :n
					end
					newn = Nuke.new(@env, nil,  newt, oldn.n + @env.nukes[fk][:n], oldn.p + @env.nukes[fk][:p])
					#
					netbe = bediff([oldn], [newn])  # add net energy to kinetic E pool
					self.heat += (netbe * 1000.0)
					#
					self.tank.delete_at(nukep)
					 # if halflife is less than 1e-20, break down again
					if !newn.half.nil? && newn.half < 1e-20
						d = newn.decay_to
						self.proc_decay(d, newt)
						self.delete_nuke(fk)
					else
						self.addnuke(newn, true)
						self.delete_nuke(fk)
					end		
				end
			end
		end
		
		def delete_nuke(type)
			ntlist = 0.upto(self.tank.size - 1).inject([]) {|a, x| a << x if self.tank[x].name == type; a}
			oldn = nil
			if ntlist.size > 0
				npickx = ntlist[rand(ntlist.size)]
				oldn = self.tank[npickx]
				self.tank.delete_at(npickx)
			end
			return oldn
		end
		
		def proc_decay(dres, newt)
			dres.each do |n|
				if n == :DELE
					self.zerocharge(1)
					self.heat -= 1000.0  # annihilation and radiation
				elsif n == :GAMMA
					# do something with gammas; radiate away some heat ferinstance
					self.heat -= 1000.0  
				else
					n.lasttime = newt
					self.addnuke(n, true)
				end
			end	
		end
	
		def get_decayed(newt)
			decd = nil
			radn = 0.upto(self.tank.size-1).inject([]) {|a, ex| a << ex unless self.tank[ex].half.nil?; a}
			if radn.size > 0
				pickx = radn[rand(radn.size)]
				decd = self.tank[pickx]
				if decd.breakdown?(newt)
					decayres = decd.decay_to
					netbe = bediff([decd], decayres)  # add net energy to kinetic E pool
					self.heat += (netbe * 1000.0)
					self.tank.delete_at(pickx)
					self.proc_decay(decayres, newt)
				else
					decd = nil
				end
			end
			return decd
		end

	end # class NukeTank

end # module NukeCooker



