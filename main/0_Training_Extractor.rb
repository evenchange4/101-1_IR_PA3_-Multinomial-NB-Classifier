#把所有Training Document set 出現的term 做出一個dictionary出來
#我在使用上使用hashtable，存成training_dictionary_hash.txt
#new Hash for output result
result = Hash.new
#input Training Document set D
D = open('../input/training.txt', "rb").read.split(' ')
#### create Vocabuliary #####
# 13 classes c
(0..12).each do |c|
	#15 documents d
	(1..15).each do |d|
		document = eval(open('../input/document_term_hash/'+D[c*16+d].to_s+'.txt', "rb").read)
		document.keys.each do |key|
			# term exist in hash table, value += 1
			if result.has_key?(key)
				# result << term.stem
				result[key] = result[key] + 1
			else
				# new a hash
				result[key] = 1
			end #end if
		end
	end # end each document		
end # end each class

#output
puts "Save term as a txt file (../output/training_dictionary_hash.txt)"
f = File.open("../output/training_dictionary_hash.txt", 'w')
f.write(Hash[result.sort])
f.close()
