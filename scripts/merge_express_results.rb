#=== conf ===
target_col = 6 # est_counts
#target_col = 7 # eff_counts
#target_col = 10 # fpkm
#===

def show_usage
  puts "Usage:"
  puts "$ruby merge_express_result.rb dir1 dir2 dir3 ..."
  puts "      assuming that each dirN includes eXpress output file named 'results.xprs'"
end

if ARGV[0] == "-h" or ARGV[0] == "--help" or ARGV.size == 0
  puts show_usage
  exit
end

dirs = ARGV



data = {}
data_len = {}

names = []
dirs.each do |dir|
  name = dir.split("/").last
  names << name
  data[name] = {}
  File.open("#{dir}/results.xprs").each_with_index do |l, i|
    next if i == 0
    a = l.chomp.split(/\t/, -1)
    id = a[1]
    val = a[target_col]
    data[name][id] = val
    
    data_len[id] = a[2].to_i
  end
end



ids = data[names[0]].keys.sort

puts "#=== eXpress Summary Table ==="
puts "#"
puts "# source:"
names.each do |n|
  puts "#   #{n}/express_out/results.xprs"
end
puts "# target column: " + target_col.to_s
puts "# script: #{__FILE__}"
puts "# date:   #{Time.now}"
puts "# author: Shuji Shigenobu <shige@nibb.ac.jp>"
puts "#"
puts "id\t" + names.join("\t") + "length"

ids.each do |id|
  values = names.map{|n| data[n][id]}
  puts [id, values, data_len[id]].flatten.join("\t")
end
