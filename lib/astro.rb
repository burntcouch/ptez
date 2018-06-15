#!/usr/local/bin/ruby -w
#
# astro.rb -- astronomy forumlae & constants module

include Math
require_relative "vector.rb"
include Vector

module Astromath

	EPOCHZT = 946684800.0			# seconds from...?
	EPOCHY = 2013.0
	ESECS = 86400.0 * 365.25636	#earth sid. year in secs
	EDAYS = 365.25636					#earth sid. year in days
	AU = 1.49598261e11					#meters
	MMASS = 7.3477e22				#kg
	SMASS = 1.988435e30			#kg
	EMASS = 5.9721986e24			#kg
	GC = 6.6732e-11				# gravitational constant
	ESG = 5515.0 						#kg/m^3
	ERAD = 6371.0						# kms

	SMU = SMASS
	SDU = AU
	STU = 5.0226757e6				#secs (58+ days) time to go 1 SDU at 1 SVU
	SVU = 29784.852				#m/sec Earth's orbital velocity 
	
	STUYR = 0.159156				# years in an STU

	EMU = EMASS 
	EDU = 384399000.0				# sma of the moon in meters
	ETU = 375698.7					# secs (~104 hrs) 
	EVU = 1023.1576				#m/sec Moon's orbinal vel. 

	ETUDY = 4.348365				# days in an ETU
	MOONTU = 27.321582				# days in a sid. month

	GZL = 192.85948			# north galactic pole J2000
	GZB = 27.12825

	GXL = 266.405				# galactic 'x-axis' J2000
	GXB = -28.936  


	IACC = 1.0e-6					# accuracy of convergence for kepler and gauss routines 

			# c'mon Pat, yer smart, you could write a program to do this...
			#  -- for naming moons
	ROMNUMS = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII" \
			, "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "XXII", "XXIII", "XXIV" \
			, "XXV", "XXVI", "XXVII", "XXVIII", "XXIX", "XXX", "XXXI", "XXXII", "XXXIII", "XXXIV" \
			, "XXXV", "XXXVI", "XXXVII", "XXXVIII", "XXXIX", "XL", "XLI", "XLII", "XLIII", "XLIV"]

				## coefficients for rkfgrax (Runge-Kutta-Fehlberg grav/accel routine)
				#
	RKC = [1.0/4.0, 3.0/8.0, 3.0/32.0, 9.0/32.0, 12.0/13.0, 1932.0/2197.0, 
			7200.0/2197.0, 7296.0/2197.0, 439.0/216.0, 3680.0/513.0, 845.0/4104.0, 
			1.0/2.0, 8.0/27.0, 3544.0/2565.0, 1859.0/4104.0, 11.0/40.0, 25.0/216.0, 
			1408.0/2565.0, 2197.0/4104.0, 1.0/5.0,  
			16.0/135.0, 6656.0/12825.0, 28561.0/56430.0, 9.0/50.0, 2.0/55.0]


	def t2jd(t=Time.now.gmtime)
		# convert Time or float seconds to Julian Day #
		if t.is_a?(Time)
			yrs = t.year.to_f 
			mos = t.month.to_f
			dys = t.day.to_f + t.hour.to_f / 24.0 + t.min.to_f / 1440.0 + t.sec.to_f / 86400.0
		elsif t.is_a?(String)
				#assumes dd/mm/yyyy (hh:mm(:ss))
			t.match(/(\d+)[\/-](\d+)[\/-](\d+)(\s+)?((\d+)[:](\d+)([:](\d+))?)?/)
			dys = $2.to_f + ($6.nil? ? 0.0 : $6.to_f / 24.0)
			dys += $7.to_f / 1440.0 if !$7.nil? 
			dys += $9.to_f / 86400.0 if !$9.nil?
			mos = $1.to_f
			yrs = $3.to_f 
			yrs += 2000.0 if (yrs < 100) 
		else
			tt = Time.at(t)
			yrs = tt.year.to_f 
			mos = tt.month.to_f
			dys = tt.day.to_f + tt.hour.to_f / 24.0 + tt.min.to_f / 1440.0 + tt.sec.to_f / 86400.0
		end		
		if (mos < 3)
			mos = mos + 12.0
			yrs = yrs - 1.0
		end
		
		if (yrs < 1582) || (yrs == 1582 && mos < 10) || (yrs == 1582 && mos == 10 && dys < 15.0)
			b = 0.0
		else
			b = 2.0 - (yrs / 100).truncate + (yrs / 400).truncate
		end
		c = (365.25 * yrs).truncate
		d = (30.6001 * (mos + 1.0)).truncate

		return b + c + d + dys + 1720994.5

	end

	def jd2t(t=2450000.5, tz=0)
		return Time.at((t.to_f - 2440587.16666666) * 86400.0 + tz * 3600.0)
	end

	def ellr3(r)
			 # calc ellipse from three radius vectors (assumed to be in chron order)
		#check for coplanarity 
		if r[0] * (r[1] ** r[2]) == 0
			s = (r[0] * (r[1].mag - r[2].mag) + r[1] * (r[2].mag - r[0].mag) + r[2] * (r[0].mag - r[1].mag))
			d = (r[0] ** r[1] + r[1] ** r[2] + r[2] ** r[0])
			n = ((r[0] ** r[1]) * r[2].mag  + (r[1] ** r[2]) * r[0].mag + (r[2] ** r[0]) * r[1].mag)
			if (d.mag != 0.0 && n.mag != 0.0 && d * n != 0.0)
				ecc = s.mag / d.mag
				a = (n.mag / d.mag) / (1.0 - ecc * ecc)
				h = r[0] ** r[2]
				h = h / h.mag
				
				e = (s ** n) * (ecc / (s.mag * n.mag))

			# will return sma, e vector, h unit vector
				return a, e, h
			else
				return nil
			end
		else				
			return nil
		end
	end


	def gvec(marr, pv, pax=DVector.new)
		# given an array hashes (:m, :s) (mass, vector)
		# returns an accel. vector
		av = DVector.new
		marr.each do |i|
			rr = i[:s] - pv 
			av += rr * (i[:m] / (rr.mag ** 3.0))
		end  
		return av + pax
	end

		#	Runge-Kutta 4th order with gravity function
		#		mu is an array of hashes with :m (mass) and :s (postion vector)
		# 		USE a time step (dt) of 0.01 or less
		#
	def rk4grax(mu, r, v, dt, pax=DVector.new) 
		k1 = v * dt 
		k2 = ( gvec(mu, r + k1 * (1.0 / 2.0), pax) * (dt / 2.0) + v ) * dt
		k3 = ( gvec(mu, r + k2 * (1.0 / 2.0), pax) * (dt / 2.0) + v ) * dt
		k4 = ( gvec(mu, r + k3, pax) * dt + v) * dt
	
		rnew = r + (k1 + k2 * 2.0 + k3 * 2.0 + k4) * (1.0 / 6.0) 
	
		dv = (gvec(mu, r, pax) + gvec(mu, rnew, pax)) * (dt / 2.0) 
			# return new position and velocity vector	
		return rnew, v + dv
	end
	
		# Runge-Kutta-Fehlberg 5th order, with gravity
		#		mu is an array of hashes with :m (mass) and :s (postion vector)
		# 		USE a time step (dt) of 0.01 or less
		#	
	def rkfgrax(mu, r, v, dt, pax=DVector.new)
			# mu is an array of hashes (:m, :s) for relevant masses
			#
		k1 = v * dt
		k2 = (gvec(mu, r + k1 * RKC[0], pax) * dt * RKC[0] + v) * dt
		k3 = (gvec(mu, r + k1 * RKC[2] + k2 * RKC[3], pax) * dt * RKC[1] + v) * dt
		k4 = (gvec(mu, r + k1 * RKC[5] - k2 * RKC[6] + k3 * RKC[7], pax) * dt * RKC[4] + v) * dt
		k5 = (gvec(mu, r + k1 * RKC[8] - k2 * 8.0 + k3 * RKC[9] - k4 * RKC[10], pax) * dt + v) * dt
		k6 = (gvec(mu, r - k1 * RKC[12] + k2 * 2.0 - k3 * RKC[13] +
			 k4 * RKC[14] - k5 * RKC[15], pax) * dt * RKC[11] + v) * dt 	  
	
		rnew = r + k1 * RKC[16] + k3 * RKC[17] + k4 * RKC[18] - k5 * RKC[19]
		rnew2 = r + k1 * RKC[20] + k3 * RKC[21] + k4 * RKC[22] - k5 * RKC[23] + k6 * RKC[24]
	 
		dv = (gvec(mu, r, pax) + gvec(mu, rnew, pax)) * (dt / 2.0) 
			# return new position and velocity vector	
			#    and approximate error	
		return rnew, v + dv, (rnew - rnew2).mag.abs / dt
	end

	def lum(aa, d=false)
		# returns luminosity from mv
		# if d=true, returns approx. luminosity of star before 
		# white dwarf stage
		if !d
			return 10.0 ** (0.4 * (4.84 - aa))
		else
			return 10.0 ** (3.3 * log10(aa * 1.1))
		end
	end

	def lum2mv(lum)
		return 4.84 - 2.5 * log10(lum.to_f)
	end

	def mmv(mass, d=false)
		if !d 
			# returns approx. mv from mass
			return 4.84 - 8.25 * log10(mass.to_f)
		else
			return 7.5 + rand * 8.0
		end
	end


	def mv2m(mv, d=false)
			# return main seq mass from Mv
		if !d
			return 10.0 ** ((4.84 - mv) / 8.25 )
		else
			return 0.15 + (1.4 * rand * rand) 
		end 
	end

	def mmvdorg(ms)  # returns approximate original Mv of WD
		return mmv(ms * 1.5)
	end

	def rad(mv, temp) 
		# returns radius (S = 1) for given mv and temp
		return sqrt(lum(mv)) * (5780.0 / temp)**2.0
	end

	def stemp(spec)
		# returns temp based on spectrum
		sn = 0.0
		if spec.is_a?(Array)
			sn, = spec
		elsif spec.is_a?(Numeric)
			sn = spec.to_f 
		else
			sn, = sp2n(spec)
		end
		if sn < 100.0
			x1 = -0.0000144834657
			x2 = 0.001887788415
			x3 = -0.08734698
			x4 = 5.1845

			r = sn + 5.0

			if r <= 99.9
				t = 10.0 ** (x1 * r**3 + x2 * r**2 + x3 * r + x4)
			else
				x5 = 1.0 + 8.0 * (r - 96.0)
				t = 10.0 ** (x1 * x5**3 + x2 * x5**2 + x3 * x5 + x4)
			end
			t = 100.0 if t < 100.0
			return t
		else
			return (sn > 100.0 ? (50400 / (sn - 100.0)) : (50000.0 + rand * 30000.0)) 
		end
	end

	def sp2n(spec)
		#from standard 'short' spectral type, outputs
		# 'spectrum' number 0.0 - 100+  (degenerates 100+)
		# and lum. class 1.0 - 6.0 (degenerates 0)
		fi = spec.strip.match(/^[OBAFGKMLTY]\w?\.?\d?/).to_s
		fd = spec.strip.match(/^D[A-Z]*\d*\.?\d?/).to_s
		fj = spec.strip.match(/\s+((VI?)|(IV)|(I+[ab]?[b]?))/)
		fj = fj[0].strip if !fj.nil?
 
		if fi.match(/^[OBAFGKMLTY]/)
			sn = 10.0 * ("OBAFGKMLTY" =~ /#{fi[0]}/)
			snn = fi.match(/\d+\.?\d?/)
			sn += !snn.nil? ? snn[0].to_f : 0.0 
		elsif fd.match(/^D[A-Z]+(\d+(\.\d)?)/)
			tmp = ($1.nil? ? 5.0 : $1.to_f) 
			sn = 100.0 + tmp
		else
			sn = 0.0 
		end

		ln = 0.0
		ln = case fj
			when "Ia" then 1.0
			when "I" then 1.15
			when "Iab" then 1.3
			when "Ib" then 1.7
			when "II" then 2.0
			when "IIa" then 1.9
			when "IIab" then 2.3
			when "IIb" then 2.7
			when "III" then 3.0
			when "IV" then 4.0
			when "V" then 5.0
			when "VI" then 6.0
 			else sn > 99.9 ? 0.0 : 5.0
		end

		return sn, ln 
	end

	def spec2mass(spec)
		sn = ln = 0.0
		if spec.is_a?(Array)
			sn, ln = spec 
		elsif spec.is_a?(Numeric)
			sn = spec.to_f 
			ln = 5.0 
		else
			sn, ln = sp2n(spec)
		end
		if ln <= 4.5
			return 10.0 ** (((64.0 - sn) / (65.0 - ln)) ** 4.0 + (9.0 - 2.0 * ln) / 10.0)
		elsif sn > 99.99
			return 0.15 + (1.4 * rand * rand) 
		else
			return 10.0 ** ((4.84 - spec2mv(sn, 5.0)) / 8.25)
		end
	end

	def spec2mv(sn, ln) 
		if ln < 4.5
			z = 1.0 / (1.5 * (sn + 5.0) / 80.0)
			y1 = (1.0 / 55.0) * sn - 9.5
			y2 = (10.0 / 55.0) * sn - 3.0
			
			return y1 + (((ln - 1.0) / 3.5) ** (1.0 / z)) * (y2 - y1)		
		else
			if sn < 100.0 
				y = 1.8084 + 0.1686 * (sn - 24.2537)
				y += (11.89 / 1.0e4) * ((sn - 24.2537)** 2.0)
				y += (335.74 / 1.0e7 ) * ((sn - 24.2537)** 3.0)
				y += (-104.23 / 1.0e7 ) * ((sn - 24.2537)** 4.0) 
				y += (2.56 / 1.0e7 ) * ((sn - 24.2537)** 5.0) 
				return y
			else
				return 8.0 + (sn - 100.0) * 7.5
			end
		end		
	end

	def spec2CI(spec)		# color index
		sn = ln = 0.0
		if spec.is_a?(Array)
			sn, ln = spec 
		elsif spec.is_a?(Numeric)
			sn = spec.to_f
			ln = 5.0 
		else
			sn, ln = sp2n(spec)
		end
		if sn < 51.0
			return (0.95 / 35.0) * sn - 0.43429
		else
			return (1.55 / 35.0) * sn - 6.22
		end
	end

	def specMJ(spec)  # J-band infrared absolute maginitude vs. spectrum
		sn = 0.0
		if spec.is_a?(Array)
			sn, ln = spec 
		elsif spec.is_a?(Numeric)
			sn = spec.to_f
			ln = 5.0 
		else
			sn, ln = sp2n(spec)
		end
		y = vcorr = 0.0
		if ln > 4.5
			if sn < 66.0
				y = 2.3162 + 0.1169 * (sn - 31.7367)
				y += (-1.27 / 1.0e3) * (sn - 31.7367) ** 2.0
				y += (18.32 / 1.0e6) * (sn - 31.7367) ** 3.0
				y += (-1.7 / 1.0e6) * (sn - 31.7367) ** 4.0
				y += (137.4 / 1.0e9) * (sn - 31.7367) ** 5.0
			else
				y = 13.6083 + 0.1621 * (sn - 76.9092)
				y += (-379.31 / 1.0e6) * (sn - 76.9092) ** 2.0
				y += (1.27 / 1.0e3) * (sn - 76.9092) ** 3.0
				y += (-483.06 / 1.0e9) * (sn - 76.9092) ** 4.0
				y += (483.06 / 1.0e9) * (sn - 76.9092) ** 5.0
			end
		else
			vcorr = spec2mv(sn,ln) - spec2mv(sn,5.0) 
		end
		return y + vcorr
	end

	def degsn(dsn)
		# returns equivalent spec-number equivalent to T of white dwarf
		sn = 40.0
		tt = stemp(dsn)
		(3).upto(99) do |z|
			zz = z.to_f
			if stemp(zz) < tt
				x = (stemp(zz-1.0) - tt) / (stemp(zz - 1.0) - stemp(zz)) 
				sn = zz - 1.0 + x
				break
			end	
		end
		return sn
	end

	def spec2BC(spec)   # bolometric correction
		sn = 0.0
		if spec.is_a?(Array)
			sn, = spec 
		elsif spec.is_a?(Numeric)
			sn = spec.to_f
			ln = 5.0 
		else
			sn, = sp2n(spec)
		end
			# get equivalent class vs. T if WD    
		sn = degsn(sn) if sn > 99.9

		y = 0.0
		if sn < 20.0
				y = -1.61 + 0.306 * (sn - 14.0)
				y += (-6.05 / 1.0e3) * (sn - 14.0) ** 2.0
				y += (-959.4 / 1.0e6) * (sn - 14.0) ** 3.0
		elsif sn < 70.0
				y = -0.0484 - 0.0015  * (sn - 34.2843)
				y += (-379.31 / 1.0e6) * (sn - 34.2843) ** 2.0
				y += (10.0 / 1.0e6) * (sn - 34.2843) ** 3.0
				y += (-2.61 / 1.0e6) * (sn - 34.2843) ** 4.0
				y += (-1.09 / 1.0e9) * (sn - 34.2843) ** 5.0
		else
				y = -11.5746 - 0.0814 * (sn - 98.6195)
				y += (7.85 / 1.0e3) * (sn -  98.6195) ** 2.0
				y += (80.54 / 1.0e6) * (sn - 98.6195) ** 3.0
		end
	
		return y
	end


	def precess(ra, dec, y0, y1) # ra and dec in degrees
		m = 3.07234 + 0.00186 * (y1 - 1900.0) / 100.0
		n = 1.33646 - 0.00057 * (y1 - 1900.0) / 100.0
		np = 20.0468 - 0.0085 * (y1 - 1900.0) / 100.0

		yd = y1 - y0
		
		rra = ra * PI / 180.0
		rdc = dec * PI / 180.0

		s1 = yd * (m + n * sin(rra) * tan(rdc)) / 240.0
		s2 = yd * (np * cos(rra)) / 3600.0

		prd = (ra + s1) % 360.0
		pdc = dec + s2

		return prd, pdc  # in degrees

	end


	def age(mass, met, d)
		tb = (10 ** (10.2 - 2.5 * log(mass * ( d ? 1.1 : 1.0))))
		tb = tb / 1e6
		tb = 15000.0 if tb > 15000.0  
		r = (rand + rand) / 2.0
		if d
			tb = (tb + 5.0 * r) / Math.sqrt(met)      
		else
		 	tb = (tb / Math.sqrt(met)) * r 
		end
		tb = 15000.0 if tb > 15000.0  
		return tb.round.to_f
	end

	def absmagp(dist, rad, albedo, phase, mvstar)
			# dist in AU
			# radius in km
			# Bond albedo
			# phase  0.00 -> 1.00
			# mvstar - absolute mag of star
		res = log10(dist * AU / (2000.0 * rad * sqrt(albedo * phase)))
		res = 5.0 * res + mvstar
		return res
	end

	def appmagp(mp, dist)
			# dist in AU, abs mag of planet from absmagp function
		return mp - 5.0 + 5.0 * log10(dist / 206265.0) 
	end 

	def getir(rat, lim)
		rrat = nil
		rdiff = 2.0
		[5,7,11,13,17,19,23,29,21,37].each do |n|
			(2..13).each do |m|
				next if n.to_f/m.to_f < 1.4
				rdt = (1 - (n.to_f/m.to_f)/rat).abs
				if rdt < rdiff
					rdiff = rdt
					rrat = [n, m]
				end
			end
			break if rdiff < lim
		end 
		return rrat
	end

	def getirrnd
		n = m = 0
		loop do
			nn = [5,7,11,13,17,19,23]
			n = nn[rand(nn.count)]
			mm = [2, 3, 4, 6, 8, 9, 10, 12]
			m = mm[rand(mm.count)]
			break if (n.to_f / m.to_f) > 1.4  
		end
		return [n,m]
	end	


	def gauss(mu, r1, r2, tof, dbg=0, longway=false)
				# requires mass function, two postion vectors (DU), time of flight in TU
				#  returns the velocity vectors at r1 and r2
				# all methods derived from
				# FUNDAMENTALS OF ASTRODYNAMICS (Dover 1971) - Bate, Mueller, White
				#  ch. 5.3 pg 231-237
		dnu = acos(r1 * r2 / (r1.mag * r2.mag))
		if dnu < PI && longway == false
			dm = 1.0
		else
			dm = -1.0
			dnu = 2.0 * PI - dnu
		end
		oa = dm * sqrt(r1.mag * r2.mag * (1.0 + cos(dnu)))
		z = 0.0
		y = 0.0
		zzlim = 70.0 #  necessary to help convergence of z
		zzl2 = 300.0 #	 ...ditto
		loop do
			cee = ess = ceep = essp = 0.0
			loop do
				cee = oC(z); ess = oS(z); ceep = oCp(z); essp = oSp(z)
				y = r1.mag + r2.mag - oa * (1.0 - z * ess) / sqrt(cee)
				break if y > 0 
				z = z - (z / zzl2)  # try to pare down z to something reasonable, nicely
			 	puts "Waaaayyy Hyperbolic!  Fixing z : #{z}" if dbg == 3 
			end
			x = sqrt(y / cee)
			tn = sqrt(1.0 / mu) * ( x ** 3.0 * ess + oa * sqrt(y))
			zz = x**3.0 * (essp - 3.0 * ess * ceep / (2.0 * cee))
			zz += (oa / 8.0) * (3.0 * ess * sqrt(y) / cee + oa / x)
			zz = sqrt(mu) * (tof - tn) / zz

			if zz.abs > zzlim
				zz = zz < 0 ? -zzlim : zzlim
			end

			z += zz
			break if (tn - tof).abs < (tof * IACC).abs
		end 
	   oF = 1 - y / r1.mag
		oG = oa * sqrt(y / mu)
		oGp = 1 - y / r2.mag

		v1 = (r2 - r1 * oF) * (1.0 / oG)
		v2 = (r2 * oGp - r1) * (1.0 / oG)

		puts z if dbg > 0

		return v1, v2
	end

	def kepler(mu, r1, v1, tof)
				# requires mass function, position (DU) and vel vectors (VU)
				#  returns the postions and velocity after tof DU's
				# all methods derived from
				# FUNDAMENTALS OF ASTRODYNAMICS (Dover 1971) - Bate, Mueller, White
				#  ch. 4.4-4.5 pg 193-211
			# hyperbolic or not? 
		e1 = v1.mag * v1.mag - mu / r1.mag
		e2 = r1 * v1
		ev = (r1 * e1 - v1 * e2) * (1.0 / mu)
		sma = mu / (2.0 * mu / r1.mag - v1.mag * v1.mag)
			# estimate first val of x
		sgx = (tof > 0.0 ? 1.0 : -1.0)
		if ev.mag > 1.0	#hyperbolic
			x = sma * ((r1 * v1) + sgx * sqrt(-sma * mu) * (1.0 - r1.mag / sma))
			x = -2.0 * mu * tof / x
			x = log(x) * sgx * sqrt(-sma)
		else
			x = sqrt(mu) * tof / sma
		end
		z = 0
		loop do
			z = x * x / sma
			tn = ((r1 * v1) / sqrt(mu)) * x * x * oC(z) 
			tn += (1.0 - r1.mag/sma)* (x ** 3.0) * oS(z) + r1.mag * x
				# estimate of t close enough?
			break if (tof - tn).abs < (IACC * tof).abs
				# else correct and re-try
			dtdx = x * x * oC(z) + (r1 * v1) * x * (1.0 - z * oS(z)) / sqrt(mu)
			dtdx += r1.mag * (1.0 - z * oC(z))
			x += (tof - tn) / dtdx 
		end
		oF = 1.0 - x * x * oC(z) / r1.mag
		oG = tof - x * x * x * oS(z) / sqrt(mu)
		r2 = r1 * oF + v1 * oG
		oFp = sqrt(mu) * x * (z * oS(z) - 1.0) / (r1.mag * r2.mag)
		oGp = 1.0 - x * x * oC(z) / r2.mag
		v2 = r1 * oFp + v1 * oGp
		return r2, v2
	end

	def fmod(x, xmod)
		return x - xmod * (x / xmod).truncate.to_f
	end

	def ffact(i)
		return 1.upto(i).inject(:*).to_f
	end
		
	def oC(z)
		zz = 0.0
		if z.abs < 0.0001
			i = 0
			loop do
				dz = zz
				zz += (i % 2 ==0 ? 1.0 : -1.0) * (z ** i.to_f) / ffact(2 * i + 2)
				i += 1
				break if (zz - dz).abs < (IACC * zz).abs
			end
		elsif z > 0
			zz = (1.0 - cos(sqrt(z))) / z
		else
			zz = (1.0 - cosh(sqrt(-z))) / z
		end
		return zz
	end

	def oS(z)
		zz = 0.0
		if z.abs < 0.0001
			i = 0
			loop do
				dz = zz
				zz +=  (i % 2 ==0 ? 1.0 : -1.0) * (z ** i.to_f) / ffact(2 * i + 3)
				i += 1
				break if (zz - dz).abs < (IACC * zz).abs
			end
		elsif z > 0
			zz = (sqrt(z) - sin(sqrt(z))) / sqrt(z * z * z)
		else
			zz = (sinh(sqrt(-z)) - sqrt(-z)) / sqrt((-z)**3.0)
		end
		return zz
	end

	def oCp(z)
		return z != 0.0 ? (1.0 / (2.0 * z)) * (1.0 - z * oS(z) - 2.0 * oC(z)) : 1.0 / 24.0
	end

	def oSp(z)
		return z != 0.0 ? (1.0 / (2.0 * z)) * (oC(z) - 3.0 * oS(z)) : 1.0 / 120.0
	end 

	def rg1
		return (rand + rand) / 2.0
	end
	
	def rg2
		return (rand + rand + rand) / 3.0
	end
	
	def rgs1(x)
		return (x * rand + (2.0 - x) * rand) / 2.0
	end
	
	def rr1(x)
		return (1.0 - x / 2.0) + (x * rand) 
	end
	
	def rxg1(x)
		return 10.0 ** (2.3 * x * (1.0 - 2.0 * rg1))
	end
	
	def rxg2(x)
		return 10.0 ** (2.3 * x * (1.0 - 2.0 * rg2))
	end
	
	def rrx(x)
		return 10.0 ** (2.3 * x * (1.0 - 2.0 * rand))
	end

end
