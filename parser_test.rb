require 'test/unit'
require_relative './parser.rb'

class ParserTests < Test::Unit::TestCase

  def get_data
    Parser.read_and_validate("./testserver.log")
  end

  def transform_data
    Parser.transform_data
  end

  def test_data
    pb = get_data
    refute_includes(pb, "home 122.318.669.962\n")
    refute_includes(pb, "help/page 122.318.669.962\n")
    refute_includes(pb, "/help_page/1 126.318.35.38\n")
    refute_includes(pb, "/help page/1 126.318.035.038\n")
    refute_includes(pb, "home 122.318.669.962\n")
    assert_includes(pb, "/contact 184.123.665.067\n")
    assert_includes(pb, "/contact 184.123.665.068\n")
    assert_includes(pb, "/home 184.123.665.067\n")
    assert_includes(pb, "/about/2 444.701.448.104\n")
  end

  def test_endpoints
    get_data
    transform_data
    res = Parser.read_endpoints
    pb = res.split("\n")
    assert_equal(4, pb.count)
    assert_equal("There were 3 visits for '/contact' endpoint", pb[0])
    assert_equal("There were 1 visits for '/help_page/1' endpoint", pb[1])
  end

  def test_ips
    get_data
    res = Parser.get_ips
    pb = res.split("\n")
    assert_equal(4, pb.count)
    assert_equal("There were 3 visits from ip: '184.123.665.067'", pb[0])
    assert_equal("There were 1 visits from ip: '126.318.035.038'", pb[1])
  end

  def test_unique_endpoints
    get_data
    res = Parser.unique_endpoints
    pb = res.split("\n")
    assert_equal(4, pb.count)
    assert_equal("There were 2 unique visits for '/contact' endpoint", pb[0])
  end

end
