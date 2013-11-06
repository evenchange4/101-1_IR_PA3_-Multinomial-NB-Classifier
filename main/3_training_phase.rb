#training phase
#input Training Document set D
D = open('../input/training.txt', "rb").read.split(' ')
V = eval(open('../output/features.txt', "rb").read)
N = 195
Nc = 15
prior = 1/13

condprob = Hash.new # 'class' => tf array
#for each c in C
(0..12).each do |c|
	#Concatenate Text Of All Docs In Class
	concatenate = Hash.new
	#15 documents d
	(1..15).each do |d|
		document = eval(open('../input/document_term_hash/'+D[c*16+d].to_s+'.txt', "rb").read)
		concatenate.merge!(document){|key, oldval, newval| newval + oldval}
	end # end each document	
	# p concatenate
	Tf_array = Array.new(0)
	#for each t in V
	V.each do |t|
		Tf = concatenate[t] 
		if Tf 
			Tf_array << Tf
		else
			Tf_array << 0
		end
	end
	Tf_array_sum = Tf_array.inject(:+)
	# condprob[t][c] $ (Tct+1) / ∑(Tct’+1)
	Tf_array.map!{|i| (i+1)/(Tf_array_sum+500).to_f}
	condprob[c+1] = Tf_array
end
# p condprob

#output
f = File.open("../output/condprob.txt", 'w')
f.write(condprob)
f.close()