#!/usr/bin/ruby
#
#
# nuke cooker 1
#
#

PROTONS = { H: 1, He: 2, Li: 3, Be: 4, B: 5, C: 6, N: 7, O: 8, F: 9 Ne: 10,
	Na: 11, Mg: 12, Al: 13, Si: 14, P: 15, S: 16, Cl: 17, Ar: 18, K: 19, Ca: 20,
	Sc: 21, Ti: 22, V: 23, Cr: 24, Mn: 25, Fe: 26, Co: 27, Ni: 28, Cu: 29, Zn: 30,
	Ga: 31, Ge: 32, As: 33, Se: 34, Br: 35, Kr: 36, Rb: 37, Sr: 38, Y: 39, Zr: 40
}
NUKES = { n: {n: 1, p: 0, half: 881.5, decay: ['b+', 0.782, :H]}, 
	H: {n: 0, p: 1, half: nil},	D: {n: 1, p: 1, half: nil}, 
	T: {n: 2, p: 1, half: 3.88e12, decay: ['b-', 0.0186, :He3]}, 
	He3: {n: 1, p: 2, half: nil},	He4: {n: 2, p: 2, half: nil}, 
	He5: {n: 3, p: 2, half: 8e-22, decay: ['n', 0.890, :He4]},
	Li5: {n: 2, p: 3, half: 3e-22, decay: [ , , ]},
	Li6: {n: 3, p: 3, half: nil},
	Li7: {n: 4, p: 3, half: nil},
	Be8: {n: 4, p: 4, half: 8e-17, decay: [ , , ]},
	Be9: {n: 5, p: 4, half: nil},
	Be10: {n: 6, p: 4, half: 4.7e10, decay: [ , , ]},
	B8: {n: 3, p: 5, half: 0.77, decay: [ , , ]},
	B9: {n: 4, p: 5, half: 8.4e-19, decay: [ , , ]}, 
	B10: {n: 5, p: 5, half: nil}, B11: {n: 6, p: 5, half: nil}, 
	B12: {n: 7, p: 5, half: 0.0202, decay: [ , , ]},
	C11: {n: 5, p: 6, half: 1220.0, decay: [ , , ]}, 
	N13: {n: 6, p: 7, half: 598.0, decay: [ , , ]},
	C12: {n: 6, p: 6, half: nil}, C13: {n: 7, p: 6, half: nil}, 
	C14: {n: 8, p: 6, half: 1.8e11, decay: [ , , ]},
	N14: {n: 7, p: 7, half: nil}, N15: {n: 8, p: 7, half: nil}, 
	N16: {n: 9, p: 7, half: 7.13, decay: [ , , ]},
	O15: {n: 7, p: 8, half: 122.4, decay: [ , , ]}, 
	O16: {n: 8, p: 8, half: nil}, O17: {n: 9, p: 8, half: nil}, 
	O18: {n: 10, p: 8, half: nil}, 
	O19: {n: 11, p: 8, half: 26.88, decay: [ , , ]}, 
	N17: {n: 10, p: 7, half: 4.173, decay: [ , , ]},
	F17: {n: 8, p: 9, half: 64.5, decay: [ , , ]}, 
	F18: {n: 9, p: 9, half: 6586.2, decay: [ , , ]}, 
	F19: {n: 10, p: 9, half: nil}, 
	F20: {n: 11, p: 9, half: 11.07, decay: [ , , ]}, 
	F21: {n: 12, p: 9, half: 4.158, decay: [ , , ]},
	Ne18: {n: 8, p: 10, half: 1.672, decay: [ , , ]}, 
	Ne19: {n: 9, p: 10, half: 17.22, decay: [ , , ]}, 
	Ne20: {n: 10, p: 10, half: nil}, 
	Ne21: {n: 11, p: 10, half: nil}, Ne22: {n: 12, p: 10, half: nil}, 
	Ne23: {n: 12, p: 10, half: 37.24, decay: [ , , ]},
	blank: {n: 0, p: 0, half: nil, decay: [ , , ] }
	}

INIT = {H: 0.8, D: 0.02, He3: 0.001 He4: 0.149, Li6: 0.004, Li7: 0.025, Be9: 0.001}

def findn(n)
	res = nil
	if n[:p] == 1
		res = case n[:n]
			when 0 then NUKES[:H]
			when 1 then NUKES[:D]
			when 2 then NUKES[:T]
			else ("H%i" % (1 + n[:n])).intern
		end
	elsif n[:p] = 0 && n[:n] == 1
		res = :n
	else
		plookup = PROTONS.keys.sort {|a,b| PROTONS[a] <=> PROTONS[b]}
		amu = n[:p] + n[:n]
		res = "#{plookup(n[:p]).to_s}#{amu.to_s}".intern
	end
	unless NUKES[res].nil?
		res = NUKES[res]
	else
		res = {res => {new: true, n: n[:n], p: n[:p]}}
	end
	return res
end

def react(n1, n2, dt)
	prod = {n: n1[:n] + n2[:n], p: n1[:p] + n2[:p]}
	f = findn(prod)
	if f[:new].nil?  # a nucleus not in the NUKES list
	
	else
	
	end
	
	
end


