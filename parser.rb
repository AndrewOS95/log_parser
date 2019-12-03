class Parser
  def self.get_endpoint(file_path)
    file = File.open(file_path, "r")
    @returns = ""
    @arr = []
    @endpoints = []
    @counts = Hash.new(0)
    regex = /^(\/[a-z0-9_]+){1,} [0-9]{3}.[0-9]{3}.[0-9]{3}.[0-9]{3}/
    file.each do |row|
      if row =~ regex
        @arr << row
      end
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

end