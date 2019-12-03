require "optparse"
class Parser
  def self.read_and_validate(file_path)
    @returns = ""
    @file = File.open(file_path, "r")
    @arr = []
    @counts = Hash.new(0)
    regex = /^(\/[a-z0-9_]+){1,} [0-9]{3}.[0-9]{3}.[0-9]{3}.[0-9]{3}/
    @file.each do |row|
      if row =~ regex
        @arr << row
      end
    end
    return @arr
  end

  def self.transform_data
    @endpoints = []
    @addresses = []
    @arr.each do |item|
        @endpoints << item.split(' ')[0]
        @addresses << item.split(' ')[1]
    end
    return @endpoints, @addresses
  end

  def self.read_endpoints
    @endpoints.each { |item| @counts[item] += 1 }
    item = @counts.sort_by {|key, value| value}.reverse
    item.each do |i|
       @returns += "There were #{i[1]} visits for '#{i[0]}' endpoint\n"
    end
    @returns
  end
end


opts = {}
OptionParser.new do |opt|
  opt.on('-f', '--file FILE') {|o| opts[:file] = o }
  opt.on('-e', '--get_endpoints')
end.parse!(into: opts)

if opts[:file] && opts[:get_endpoints]
  Parser.read_and_validate(opts[:file])
  Parser.transform_data
  puts Parser.read_endpoints
else
  puts "Please import data through a file"
end