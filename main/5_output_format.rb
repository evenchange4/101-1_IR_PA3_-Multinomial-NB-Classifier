#處理最後需要交出去的格式

result = eval(open('../output/testing_result.txt', "rb").read)
p result

# output
f = File.open("../output/output.txt", 'w')

result.keys.each do |key|
	f.write("#{key} #{result[key]}\n")
end

f.close()