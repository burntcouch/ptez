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
		Ga: 31, Ge: 32, As: 33, Se: 34, Br: 35, Kr: 36, Rb: 37, Sr: 38, Y: 39, Zr: 40
	}
	NUKES = { e: {n: 0, p: 0, half: nil},
		n: {n: 1, p: 0, half: 881.5, decay: ['b-', 0.782, :H]}, 
		H: {n: 0, p: 1, half: nil},	D: {n: 1, p: 1, half: nil}, 
		T: {n: 2, p: 1, half: 3.88e12, decay: ['b-', 0.0186, :He3]}, 
		He3: {n: 1, p: 2, half: nil},	He4: {n: 2, p: 2, half: nil}, 
		He5: {n: 3, p: 2, half: 8e-22, decay: ['n', 0.890, :He4]},
		Li5: {n: 2, p: 3, half: 3e-22, decay: ['p', 1.965, :He4]},
		Li6: {n: 3, p: 3, half: nil},
		Li7: {n: 4, p: 3, half: nil},
		Be8: {n: 4, p: 4, half: 8e-17, decay: ['a', 0.9184, :He4]},
		Be9: {n: 5, p: 4, half: nil},
		Be10: {n: 6, p: 4, half: 4.7e10, decay: ['b-', 0.5559, :B10]},
		B8: {n: 3, p: 5, half: 0.77, decay: ['b+', 0.0, :Be8]},
		B9: {n: 4, p: 5, half: 8.4e-19, decay: ['p', 0.185, :Be8]}, 
		B10: {n: 5, p: 5, half: nil}, B11: {n: 6, p: 5, half: nil}, 
		B12: {n: 7, p: 5, half: 0.0202, decay: [['b-',13.37, :C12, 0.984],['b-a', 6.0023, :Be8, 0.016]]},
		C11: {n: 5, p: 6, half: 1220.0, decay: ['b+', 0.960, :B11]}, 
		N13: {n: 6, p: 7, half: 598.0, decay: ['b+', 1.198, :C13]},
		C12: {n: 6, p: 6, half: nil}, C13: {n: 7, p: 6, half: nil}, 
		C14: {n: 8, p: 6, half: 1.8e11, decay: ['b-', 0.156, :N14]},
		N14: {n: 7, p: 7, half: nil}, N15: {n: 8, p: 7, half: nil}, 
		N16: {n: 9, p: 7, half: 7.13, decay: ['b-', 10.421, :O16]},
		O15: {n: 7, p: 8, half: 122.4, decay: ['b+', 1.732, :N15]}, 
		O16: {n: 8, p: 8, half: nil}, O17: {n: 9, p: 8, half: nil}, 
		O18: {n: 10, p: 8, half: nil}, 
		O19: {n: 11, p: 8, half: 26.88, decay: ['b-', 4.822, :F19]}, 
		N17: {n: 10, p: 7, half: 4.173, decay: [['b-n', 4.537, :O16, 0.95],['b-', 0.0, :O17, 0.05]]},
		F17: {n: 8, p: 9, half: 64.5, decay: ['b+', 1.7838, :O17]}, 
		F18: {n: 9, p: 9, half: 6586.2, decay: ['b+', 0.633, :O18]}, 
		F19: {n: 10, p: 9, half: nil}, 
		F20: {n: 11, p: 9, half: 11.07, decay: ['b-', 7.0245, :Ne20]}, 
		F21: {n: 12, p: 9, half: 4.158, decay: ['b-', 5.684, :Ne21]},
		Ne18: {n: 8, p: 10, half: 1.672, decay: ['b+', 3.421, :F18]}, 
		Ne19: {n: 9, p: 10, half: 17.22, decay: ['b+', 2.2166, :F19]}, 
		Ne20: {n: 10, p: 10, half: nil}, 
		Ne21: {n: 11, p: 10, half: nil}, Ne22: {n: 12, p: 10, half: nil}, 
		Ne23: {n: 13, p: 10, half: 37.24, decay: ['b-', 4.375, :Na23]},
		Na23: {n: 12, p: 11, half: nil},
		Sc46: {n: 25, p: 21, half: 7.238e6, decay: ['SF', 0.0, :Ne23, nil, :Na23] }
	}

	INIT = {H: 0.8, D: 0.02, He3: 0.001, He4: 0.149, Li6: 0.004, Li7: 0.025, Be9: 0.001}

	def findn(n)
		res = nil
		if n[:p] == 1
			res = case n[:n]
				when 0 then NUKES[:H]
				when 1 then NUKES[:D]
				when 2 then NUKES[:T]
				else ("H%i" % (1 + n[:n])).intern
			end
		elsif n[:p] == 0 && n[:n] == 1
			res = :n
		else
			plookup = PROTONS.keys.sort {|a,b| PROTONS[a] <=> PROTONS[b]}
			amu = n[:p] + n[:n]
			res = "#{plookup[n[:p] - 1] .to_s}#{amu.to_s}".intern
		end
		unless NUKES[res].nil?
			res = {res => NUKES[res]}
		else
			res = {res => {new: true, n: n[:n], p: n[:p]}}
		end
		return res
	end

	class Nuke
		attr_accessor :name, :nspec, :orgtime, :currtime
	
		def initialize(spec = nil, t = 0.0,  n = nil, p = nil)
			if spec.nil? || NUKES[spec].nil?
				f = findn({n: @n, p: @p})
				@name = f.keys[0]
				@nspec = f.values[0]
			elsif NUKES[spec]
				@name = spec
				@nspec = NUKES[spec]
			end
			@orgtime = t
			@currtime = t
		end
		
		def upd(newt)
			self.currtime = newt
		end
		
		def breakdown?(newt)
			res = false
			unless self.half.nil?
				r = Math::exp(Math::log(0.5) * (newt - self.orgtime) / self.half)
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
				res = [Nuke.new(r[2], self.currtime)]
					# make list of resulting stuff
				case r[0]
					when 'b-'
						res << Nuke.new(:e, self.currtime)
					when 'b+'
						res << :DELE
					when 'b-n'
						res << Nuke.new(:n, self.currtime)
						res << :DELE
					when 'a'
						res << Nuke.new(:He4, self.currtime)
					when 'b-a'
						res << Nuke.new(:He4, self.currtime)
						res << :DELE
					when 'SF'
						res << Nuke.new(r[4], self.currtime)
					when 'n'
						res << Nuke.new(:n, self.currtime)
					when 'p'
						res << Nuke.new(:p, self.currtime)
				end
			end
			return res
		end
	
		def is_new?
			!self.nspec[:new].nil?
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
		attr_accessor :tank, :rate, :temp, :press
	
		def initialize(ncnt)
			@tank = filltank(ncnt)
	
		end
	
		def filltank(num)
	
		end
	
		def upd(dt)
			self.get_decayed(dt)
	
		end
	
		def cook(steps, dt)
	
	
		end
	
		def get_decayed(dt)
	

		end
	
		def react(n1, n2, dt)
			res = nil
			prod = {n: n1.n + n2.n, p: n1.p + n2.p}
			f = findn(prod)
			if f[:new].nil?  # a nucleus in the NUKES list
				if f[:half] 
		
				end
			elsif f[:new]
				res = f
			end
	
	
		end

	end # class NukeTank

end # module NukeCooker



