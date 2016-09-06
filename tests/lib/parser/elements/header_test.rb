require 'test/unit'
require_relative('../../../../lib/wiki-that/wiki-that')
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
    assert_equal(start,finish,'No header should be produced')
  end

  def test_incomplete2
    start = '== Incomplete Header ='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal(start,finish,'No header should be produced')
  end

  def test_h2
    start = '== Complete Header =='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h2> Complete Header </h2>',finish,'H2 should be produced')
  end

  def test_h2_unbalanced_right
    start = '== Complete Header ==='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h2> Complete Header </h2>',finish,'H2 should be produced')
  end

  def test_h2_unbalanced_left
    start = '=== Complete Header =='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h2> Complete Header </h2>',finish,'H2 should be produced')
  end

  def test_h3
    start = '=== Complete Header ==='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h3> Complete Header </h3>',finish,'H3 should be produced')
  end

  def test_h4
    start = '==== Complete Header ===='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h4> Complete Header </h4>',finish,'H4 should be produced')
  end

  def test_h5
    start = '===== Complete Header ====='
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h5> Complete Header </h5>',finish,'H5 should be produced')
  end

  def test_h6
    start = '====== Complete Header ======'
    i,finish = WikiThat::Parser.parse(start,0)
    assert_equal(start.length,i,'Header should advance to the end')
    assert_equal('<h6> Complete Header </h6>',finish,'H6 should be produced')
  end
end