#算出每一個term 的LLR value
#input Training Document set D
D = open('../input/training.txt', "rb").read.split(' ')

##### Basic feature selection algorithm #####
#input Extract training document set Vocabuliary
V = eval(open('../output/training_dictionary_hash.txt', "rb").read)
#Ouput Feature in Array L
L = Hash.new
dfTable = Hash.new	#class => presend
# T = Array.new
TH = Hash.new
#for each term t in Vocabuliary V
V.keys.each do |t|
	puts '=========== term "' + t +'"' 
	T = Array.new
#### create table #####
	# 13 classes c
	(0..12).each do |c|
		n = 0
		#15 documents d
		(1..15).each do |d|
			document = eval(open('../input/document_term_hash/'+D[c*16+d].to_s+'.txt', "rb").read)
			if document.keys.include?(t)
				n = n + 1
			end
		end # end each document		
		dfTable[(c+1).to_s] = n
	end # end each class
	# puts dfTable
##### compute this term, each class' Ratios #####
	# first class
	n01 = 0
	n00 = 0
	n11 = dfTable[1.to_s]
	n10 = 15 - n11
	(1..12).each do |j|
		index = ( (1+j) %13)
		if index != 0
			n01 = n01 + dfTable[index.to_s]
		else
			n01 = n01 + dfTable['13']
		end
	end	
	n00 = 180-n01
	n11n01 = n11+n01
	#print table
	# puts "#"+'class: '+ 1.to_s + "\tpresent \t absent"
	# puts "on  topic \t n11: "+n11.to_s + "\t\t n10: "+n10.to_s
	# puts "off topic \t n01: "+n01.to_s + "\t\t n00: "+n00.to_s
	# puts "================================= total = 195\n"

	pt = (n11+n01)/195.to_f
	p1 = n11/15.to_f
	p2 = n01/180.to_f
	numerator = (pt**n11)*((1-pt)**n10)*(pt**n01)*((1-pt)**n00)
	denominator = (pt**n11)*((1-p1)**n10)*(p2**n01)*((1-p2)**n00)
	result = (-2)*(Math.log10(numerator/denominator))
	T << result		

	# other class
	(2..13).each do |i|
		n00 = 0
		n11 = dfTable[i.to_s]
		n10 = 15 - n11
		n01 = n11n01 - n11
		n00 = 180-n01
		#print table
		# puts "#"+'class: '+ i.to_s + "\tpresent \t absent"
		# puts "on  topic \t n11: "+n11.to_s + "\t\t n10: "+n10.to_s
		# puts "off topic \t n01: "+n01.to_s + "\t\t n00: "+n00.to_s
		# puts "================================= total = 195\n"
		#compute LLR value
		pt = (n11+n01)/195.to_f
		p1 = n11/15.to_f
		p2 = n01/180.to_f
		numerator = (pt**n11)*((1-pt)**n10)*(pt**n01)*((1-pt)**n00)
		denominator = (pt**n11)*((1-p1)**n10)*(p2**n01)*((1-p2)**n00)
		result = (-2)*(Math.log10(numerator/denominator))
		T << result
	end  # end each class
	p TH[t] = T
end #end each Vocabuliary

#output
f = File.open("../output/LLR_value.txt", 'w')
f.write(TH)
f.close()
