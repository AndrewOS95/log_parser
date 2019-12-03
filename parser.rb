def get_endpoint(file_path)
    file = File.open(file_path, "r")
    @returns = ""
    @arr = []
    @endpoints = []
    @counts = Hash.new(0)
    file.each do |row|
        @arr << row
    end
    @arr.each do |item|
        @endpoints << item.split(' ')[0]
    #return @arr
    end

    @endpoints.each { |item| @counts[item] += 1 }
    item = @counts.sort_by {|key, value| value}.reverse
    item.each do |i|
       @returns += "There were #{i[1]} visits for '#{i[0]}' endpoint\n"
    end
    return @returns
end

puts get_endpoint("./webserver.log")