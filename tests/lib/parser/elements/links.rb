require 'test/unit'
require_relative('../../../../lib/wiki-that/parser/parser')
class LinkTest < Test::Unit::TestCase
    # Fake test
  def test_empty
    i,text = WikiThat::Parser.parse('',0)
    assert_equal(0,i,'Link should not advance')
    assert_equal('',text,'Nothing should have been generated')
  end

  def test_external_unbalanced
    i,text = WikiThat::Parser.parse('[',0)
    assert_equal(1,i,'Link should advance')
    assert_equal('[',text,'Empty link should have been generated')
  end

  def test_external_empty
    i,text = WikiThat::Parser.parse('[]',0)
    assert_equal(2,i,'Link should advance')
    assert_equal('<a href=\'\'></a>',text,'Empty link should have been generated')
  end

  def test_external
    i,text = WikiThat::Parser.parse('[http://example.com]',0)
    assert_equal(20,i,'Link should advance')
    assert_equal('<a href=\'http://example.com\'></a>',text,'Valid link should have been generated')
  end

  def test_external_alt
    i,text = WikiThat::Parser.parse('[http://example.com|Example]',0)
    assert_equal(28,i,'Link should advance')
    assert_equal('<a href=\'http://example.com\'>Example</a>',text,'Valid link should have been generated')
  end

  def test_internal_incomplete
    i,text = WikiThat::Parser.parse('[[',0)
    assert_equal(2,i,'Link should advance')
    assert_equal('[[',text,'Link should not have been generated')
  end

  def test_internal_incomplete2
    i,text = WikiThat::Parser.parse('[[]',0)
    assert_equal(3,i,'Link should advance')
    assert_equal('[[]',text,'Link should not have been generated')
  end

  def test_internal_empty
    i,text = WikiThat::Parser.parse('[[]]',0)
    assert_equal(4,i,'Link should advance')
    assert_equal('<a href=\'\'></a>',text,'Link should not have been generated')
  end
end