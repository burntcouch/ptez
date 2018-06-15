#!/usr/local/bin/ruby -w

include Math

module Vector

class DVector

	attr_accessor :x, :y, :z

	def initialize(xora=0.0, y=0.0, z=0.0)
		if xora.is_a?(Array)
			@x = xora[0].to_f
			@y = xora[1].to_f
			@z = xora[2].to_f
		else
			@x = xora.to_f
			@y = y.to_f
			@z = z.to_f
		end
	end

	def +(b)
		return DVector.new(self.x + b.x, self.y + b.y, self.z + b.z)
	end

	def -(b)
		return DVector.new(self.x - b.x, self.y - b.y, self.z - b.z)
	end

	def /(b)
		b = 1.0 / b.to_f
		return self * b
	end

	def *(b)
		# Vector product (dot product) if self and b are DVectors
		# ...or, if b is a flout, the scalar product
		#
		if self.is_a?(DVector) && b.is_a?(Float)  
			return DVector.new(b * self.x, b * self.y, b * self.z)
		else  
			return b.x * self.x + b.y * self.y + b.z * self.z
		end
	end

	def mag
		return Math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	end

	def dup
		return DVector.new(self.x, self.y, self.z)
	end

	def u
		# unit vector
		#
		res = (self * (1.0 / self.mag)) 
		return res 
	end

	def norm(b)
		# The 'normal' of two vectors, i.e. a unit vector perpendicular
		# to the plane defined by self and b.
		#
		res = (self ** b).u
		return res 
	end

	def -@
		return DVector.new(-self.x, -self.y, -self.z)
	end

	def neg
		return DVector.new(-self.x, -self.y, -self.z)
	end

	def **(b)
		#vector cross product
		#
		res = DVector.new
		res.x = self.y * b.z - self.z * b.y  
		res.y = self.z * b.x - self.x * b.z
		res.z = self.x * b.y - self.y * b.x
		return res
	end

	def to_s
		"x:#{self.x} - y:#{self.y} - z:#{self.z} - mag:#{self.mag}" 
	end

	def fout(delim=',')
		return [self.x.to_s,self.y.to_s,self.z.to_s].join(delim) 
	end

	def rot(b, ang)
	#Usage:
	#if b is 'i' or 'x', rotate by 'ang' around I unit vector
	#  '' '' 'j' or 'y', rotate by 'ang' around J unit vector
	#  '' '' 'k' or 'z', rotate by 'ang' around K unit vector
	#  '' '' is a DVector, rotate self around vector b, with b-centric
	# coordinates defined as: 'nx' - unit vector parallel to b
	# 'nz' - unit vector parallel to cross product of self and b
	# 'ny' - unit vector orthagonal to nx and nz
	# 'ang' in Radians, or as a string with 'd' meaning degrees, i.e. '45d'   

		ang = ang =~ /\d\s*d/ ? ang.chop.to_f * Math::PI / 180.0 
			: ang.to_f
		ca = cos(ang)
		sa = sin(ang)
		if b =~ /[ix]/i 
			return DVector.new(
				self.x, self.y * ca - self.z * sa, self.y * sa + self.z * ca)
		elsif b =~ /[jy]/i
			return DVector.new(
				self.x * ca + self.z * sa, self.y, self.z * ca - self.x * sa)
		elsif b =~ /[kz]/i 
			return DVector.new(
				self.x * ca - self.y * sa, self.x * sa + self.y * ca, self.z)
		elsif b.is_a?(DVector)
			nx = b.u
			nz = (self ** b).u
			ny = nx ** nz
			res1 = DVector.new(nx * self, ny * self, nz * self)
			res2 = DVector.new(res1.x, res1.y * ca - res1.z * sa,
				res1.y * sa + res1.z * ca)
			res3 = DVector.new(
				res2.x * nx.x + res2.y * ny.x + res2.z * nz.x, 
				res2.x * nx.y + res2.y * ny.y + res2.z * nz.y, 
				res2.x * nx.z + res2.y * ny.z + res2.z * nz.z )
			return res3 
		else
			return nil
		end
	end

end  # end of DVector

end # end of module
