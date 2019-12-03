require 'optparse'
class Parser
  def self.read_and_validate(file_path)
    @final_value = ""
    @file = File.open(file_path, "r")
    @data_arr = []
    @counts = Hash.new(0)
    regex = /^(\/[a-z0-9_]+){1,} [0-9]{3}.[0-9]{3}.[0-9]{3}.[0-9]{3}/
    @file.each do |row|
      if row =~ regex
        @data_arr << row
      end
    end
    return @data_arr
  end

  def self.transform_data
    @endpoints = []
    @addresses = []
    @data_arr.each do |item|
        @endpoints << item.split(' ')[0]
        @addresses << item.split(' ')[1]
    end
    return @endpoints, @addresses
  end

  def self.read_endpoints
    @endpoints.each { |item| @counts[item] += 1 }
    item = @counts.sort_by {|key, value| value}.reverse
    item.each do |i|
       @final_value += "There were #{i[1]} visits for '#{i[0]}' endpoint\n"
    end
    @final_value
  end

  def self.unique_endpoints
    h = @endpoints.zip(@addresses)
    h.each {|item| @counts[item] += 1 }
    h = h.uniq
    result = h.inject(Hash.new(0)) {|hash, element|
      hash[element[0]] += 1
      hash
    }
    res = result.sort_by {|key, val| val}.reverse
    res.each do |i|
      @final_value += "There were #{i[1]} unique visits for '#{i[0]}' endpoint\n"
    end
    @final_value
  end

  def self.get_ips
    @addresses.each { |item| @counts[item] += 1 }
    item = @counts.sort_by {|key, value| value}.reverse
    item.each do |i|
      @final_value +=  "There were #{i[1]} visits from ip: '#{i[0]}'\n"
    end
    @final_value
  end
end

  opts = {}

  OptionParser.new do |opt|
    opt.on('-f', '--file FILE') {|o| opts[:file] = o }
    opt.on('-e', '--get_endpoints')
    opt.on('-u', '--get_unique_endpoints')
    opt.on('-i', '--get_ips')
  end.parse!(into: opts)

  if opts[:file]
    Parser.read_and_validate(opts[:file])
    Parser.transform_data
    if opts[:get_endpoints]
      puts Parser.read_endpoints
    elsif opts[:get_ips]
      puts Parser.get_ips
    elsif opts[:get_unique_endpoints]
      puts Parser.unique_endpoints
    end
  else
    puts "Please import data through a file"
  end
