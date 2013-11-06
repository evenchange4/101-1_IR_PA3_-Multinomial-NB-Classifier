#平均選擇，select the top k/n features for each n classifiers

#input LLR value of each term
LLRs = eval(open('../output/LLR_value.txt', "rb").read)
V = eval(open('../output/LLR_value.txt', "rb").read)
features_array = Array.new
#each class
(0..12).each do |c|
	puts "class= "+ (c+1).to_s
	index_of_top40 = Array.new
	# all LLR value of a class 
	LLRarray = LLRs.values.transpose[c]
	rank40 = LLRarray.sort.reverse.take(121).uniq!

	#each LLR value
	rank40.each do |value|
		index = LLRarray.each_with_index.select { |i, idx| i == value}
		index.map! { |i| i[1] }
		index_of_top40 << index
	end
	#拆掉小[]
	index_of_top40.flatten!
	# map term
	index_of_top40.each do |index|
		features_array << V.keys[index]
	end
end
p features_array.uniq!.count

#output
f = File.open("../output/features.txt", 'w')
f.write(features_array.sort!)
f.close()
