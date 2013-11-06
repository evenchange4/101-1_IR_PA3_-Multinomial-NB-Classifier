
#testing phase
D = open('../input/training.txt', "rb").read.split(' ')
copus = Array.new(1095){ |index| index+1 }
#### delete training set
# 13 classes c
(0..12).each do |c|
	result = Array.new
	#15 documents d
	(1..15).each do |d|
		dID = D[c*16+d]
		copus.delete(dID.to_i)
	end
end


#### testing
result = Hash.new
copus.each do |dID|
	document = eval(open('../input/document_term_hash/'+dID.to_s+'.txt', "rb").read)
	condprob = eval(open('../output/condprob.txt', "rb").read)
	V = eval(open('../output/features.txt', "rb").read)
	# p condprob
	argmax = Array.new 
	(1..13).each do |c|
		Pc = Math.log10(1/13.to_f)
		score = Pc
		#for each t in W
		document.keys.each do |t|
			if V.include?(t)
				tf = document[t]
				index = V.index(t)
				termScore = condprob[c][index]
				score = score + Math.log10(termScore)*tf
			end
		end
		argmax << score
	end
	p dID.to_s+' test class= ' + (argmax.index(argmax.max)+1).to_s
	result[dID] = argmax.index(argmax.max)+1
end 
p result

# output
f = File.open("../output/testing_result.txt", 'w')
f.write(result)
f.close()