#
# pgen3 - planet generator 3rd edition
#
#													---	Various heat issues ---
#	U-238 -- 52 Mev / decay, 5.0E9 years, 8 ppb / Si
# U-235 --    , 7.3E8 years, 2-8 ppb / Si
#	Th-232 -- 80 Mev / decay, 14E9 years, 33 ppb / Si
#	K-40 -- 1.33 Mev / decay, 1.5E9 years, 4 ppm / Si
#	Al-26 -- 1.808 Mev / decay, 5E5 years, 6 ppm / Si (could be ten times higher near 'enrichment')
#
#	Specific heats  delta E = mass * delta T * Cp 
# U-116 J/kg-K  granite-790  silica-700  iron-450  ice-2100  H2(gas)-14300  CH4-2190  CO2-839  NH3-4700  N2-1040
#
#	Heat of vaporiz. delta E = mass * Cv
# U-2100 KJ/kg Fe-6090  Al-10500  CH4-481  H2O-2260  NH3-1371  N2-200  H2-450  C-30000  Si-10710
#

module Ptez

	require './pg3const.rb'  # constants

	class PBlob
	
		attr_accessor :heat, :mat
	
		def initialize(env, body, bmass, frac={VOL: 0.3, ROCK: 0.6, METAL: 0.1}, heat=0.0)
				# normalize
			@env = env
			@body = body
			@heat = heat
	#		@state = @env.mat.keys.inject({}) {|h,m| h[m] = [1.0, 0.0]; h} # % of state?  not sure abt how this works
			@mat = self.initmat(bmass,frac)
		end
		
		def mass
			return @mat.values.inject(0.0) {|f,v| f += v} # and FIXING
		end
		
		def temp
			mcp = 0.0
			@mat.each do |k,v|
				mcp += @env.mat[k].specheat * v 
			end
			return self.heat / mcp
		end
		
		def delta
			return self.mass / self.vol
		end
		
		def initmat(mass, frac)  # and FIXING
			ftot = frac.keys.inject(0.0) {|t,f| t += frac[f].to_f; t}
			frm = frac.keys.inject({}) {|h,f| h[f] = mass.to_f * frac[f].to_f / ftot; h}
			
				# this needs to generate, per material 'type' (:VOL, :ROCK, :METAL right now), a given mass
				# of material.  Need a 'specpick * rand(max amount of material)' type function...
			
			return frm
		end
		
		def vol(gfac = 1.0) 
		 return @mat.keys.inject(0.0) { |vi, mk| vi += @mat[mk] / (@env.mat[mk].delta * gfac) } 
		end
		
		
		def merge(blob)
			mh = {}
			@mat.keys.each do |mk|
				mh[mk] = (@mat[mk] + blob.mat[mk])
			end
			self.heat += blob.heat
			@mat = mh
			blob = nil
			return self
		end
		
		def split(parms) # { BYMASS: <mass>, DELTA: <pct +/->  , TEMP: <pct +/-> }
			tmass = nil; dtarg = nil; ttarg = nil
			parms.each do |pk, pv|
				if pk == :BYMASS
					tmass = pv
				elsif pk == :DELTA
					dtarg = pv * (1.0 + self.delta / 100.0)
				elsif pk == :TEMP
					ttarg = pv * (1.0 + self.heat / 100.0)
				end
			end
			
			if dtarg.nil? && ttarg.nil? 
				newmat = self.mat.keys.inject({}) {|mh, mk| mh[mk] = self.mat[mk] * tmass / self.mass}
			
			else
			
			
			end
		
			newblob = PBlob.new(self.env, self.ptez, tmass, newmat, newheat)
		end
		
	end # of class PBlob
	
	class PLayer
	
		attr_accessor :blobs, :rmax, :rmin
		
		def initialize(env, ptez, lmass, rmin, frac, heat)
			@env = env
			@ptez = ptez
			@blobs = []
			self.newblobs(lmass, frac, heat)
			@rmin = rmin
			self.rad(@rmin)
		end
		
		def bix(blob)
			return self.blobs.index {|b| b.equal?(blob)}
		end
		
		def mvblob(layer2, blob)
			layer2.blobs << blob
			self.delete(self.bix(blob))
			return blob
		end
		
		def is_core?
			return self.rmin == 0.0
		end
		
		def heat
			self.blobs.inject(0.0) {|h,b| h += b.heat}
		end
		
		def temp
			mcp = self.blobs.inject(0.0) do |mi, b|
				mi += b.mat.keys.inject(0.0) {|mt, mk| mt += b.mat[mk] * self.env.mat[mk][:CP]} # and FIXING
			end
			return self.heat / mcp
		end
		
		def addblob(mass, frac, heat)
			self.blobs << PBlob.new(self.env, self, mass, frac, heat)
		end
		
		def lightblob
			self.blobs.sort {|a,b| a.delta <=> b.delta}[0]
		end
		
		def heavyblob
			self.blobs.sort {|a,b| b.delta <=> a.delta}[0]
		end
		
		def hotblob
			self.blobs.sort {|a,b| b.temp <=> a.temp}[0]
		end
		
		def coldblob
			self.blobs.sort {|a,b| a.temp <=> b.temp}[0]
		end
		
		def riseblobs(sortby = :TEMP)
			unless sorby == :TEMP
				self.blobs.select {|c| c.delta < self.delta}.sort {|a,b| a.delta <=> b.delta}
			else
				self.blobs.select {|c| c.temp > self.temp}.sort {|a,b| b.temp <=> a.temp}
			end
		end
		
		def sinkblobs(sortby = :TEMP)
			unless sorby == :TEMP
				self.blobs.select {|c| c.delta > self.delta}.sort {|a,b| b.delta <=> a.delta}
			else
				self.blobs.select {|c| c.temp < self.temp}.sort {|a,b| a.temp <=> b.temp}
			end		
		end
		
		def exchange(layer2)
			layer = self
		
		end
		
		def newblobs(mass, frac, heat)
			rmass = mass
			done = false
			until done
				bmass = mass * (10.0 **(-1.0 * rand * 1.5 - 1.0)) # from 1/10 to 1/316
				unless rmass - bmass > 0
					bmass = rmass
					done = true
				end
				bheat = heat * bmass / mass
				bfrac = {}
				btot = 0.0
				frac.each do |fk, fv|
					z = 0.1 * (Math::log(mass / bmass) - 2.0) # varies from 0.03 to 0.35
					z = z * (rand > 0.5 ? -1.0 : 1.0) + 1.0
					bfrac[fk] = frac[fk] * z
					btot += bfrac[fk]
				end
				bfrac.keys.each {|k| bfrac[k] /= btot}
				self.blobs << PBlob.new(self.env, self, bmass, bfrac, bheat)
				rmass -= bmass
			end		
		end
		
		def vol
			return @blobs.inject(0.0) {|v,b| v += b.vol}
		end
		
		def mass
			return @blobs.inject(0.0) {|m,b| m += b.mass}
		end
		
		def delta
			return self.mass / self.vol
		end
	
		def rad(min=0.0)
			@rmin = min
			r3 = 3.0 * Math::PI * self.vol / 4.0 + min * min * min
			@rmax = r3 ** (1.0/3.0)
			return @rmax
		end
		
		def area
			return 4.0 * Math::PI * (@rmax * @rmax - @rmin * @rmin)
		end
		
		def radflux(tsurf=0.0)  # net radiative flux at surface
			return self.area * STEPHBOLTZ * (self.temp - tsurf) ** 4.0
		end
		
		def condflux(t2)  # conductive flux across boundry of surface with another layer with temp t2
			ms = 0.0
			mk = 0.0
			@blobs.each do |v|
				v.mat.each do |vk, vv| 
					mk += vv * self.env.mat[vk][:TC] # and FIXING
					ms += vv
				end
			end
			mk = mk / ms
			return self.area * mk * (self.temp - t2) / (rmax - rmin)
		end	
	end # of class PLayer
	
	class POrbit
	
	
	end
	
	class Planetez
	
		attr_accessor :layers, :orbit, :mass
	
		def initialize(env, name, mass)
			@env = env
		end
	
	end


end # of Ptez module
