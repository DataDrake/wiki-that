require 'test/unit'
require_relative('../../../../lib/wiki-that/parser/elements/header')
class HeaderTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    i,doc = WikiThat::Parser.parse('',0)
    assert_equal(0,i,'Header should not advance')
    assert_equal('',doc,'Response should be empty')
  end

  def test_incomplete
    start = '== Incomplete Header'
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
  end
end