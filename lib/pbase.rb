#!/usr/local/bin/ruby -w

include Math

	#  an implementation of the 'asc' function for v.1.9x and 2.0x
class String
	def asc(n=0)
		return self.bytes.to_a[n]	
	end
end

	# degree to rad conversions
class Numeric
	def to_deg
		return self.to_f * 180.0 / PI
	end

	def to_rad
		return self.to_f * PI / 180.0
	end
end


	# other handy stuff
module Pbase 

	def mstdev(farr)
		mean = farr.inject(0.0) {|sum, i| sum += i.to_f} / farr.size.to_f
		var = farr.inject(0.0) {|v, i| v += (i.to_f - mean) ** 2 }
		return mean, sqrt(var / (farr.size - 1.0))
	end

end # end of module
