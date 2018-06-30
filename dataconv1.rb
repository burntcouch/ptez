#!/usr/bin/ruby
#
# tank test 1

require './nukecook.rb'
include NukeCooker

nuke = load_nukes('./data/nuclides.csv')

xsecs = {}

File.open('./data/cross_sect.csv').each do |fline|
	z = fline.chomp.strip.split(',')
	unless z.nil?
		xsecs[z[0].strip] = z[1].to_f
	end
end

nuke.keys.each do |nk|
	z = nk.to_s.match(/([A-Z][a-z]?)(\d+)/)
	unless z.nil?
		e = z[1]
		w = z[2]
		xkey = "#{w}#{e}"
		if xsecs[xkey].nil?
			nuke[nk][:xn] = 0.5 + ((nuke[nk][:n] + nuke[nk][:p]) / 50.0).round(1)
		else
			nuke[nk][:xn] = xsecs[xkey]
		end
	else	
		nuke[nk][:xn] = 0.0
	end
end

nuke.each do |k,v|
	puts "#{k} #{v[:n]}/#{v[:p]} XN: #{v[:xn]}"
end
