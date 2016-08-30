require 'test/unit'
require_relative('../../../../lib/wiki-that/parser/parser')

class ListTest < Test::Unit::TestCase
  def test_empty
    i,text = WikiThat::Parser.parse('',0)
    assert_equal(0,i,'List should not advance')
    assert_equal('',text,'Nothing should have been generated')
  end

  def test_ul
    i,text = WikiThat::Parser.parse('*',0)
    assert_equal(1,i,'List should advance')
    assert_equal('<ul><li></li></ul>',text,'Unordered List should have been generated')
  end

  def test_ul_li
    i,text = WikiThat::Parser.parse('*A',0)
    assert_equal(2,i,'List should advance')
    assert_equal('<ul><li>A</li></ul>',text,'Unordered List should have been generated')
  end

  def test_ul_li2
    i,text = WikiThat::Parser.parse('* ABC',0)
    assert_equal(5,i,'List should advance')
    assert_equal('<ul><li> ABC</li></ul>',text,'Unordered List should have been generated')
  end

  def test_ol
    i,text = WikiThat::Parser.parse('#',0)
    assert_equal(1,i,'List should advance')
    assert_equal('<ol><li></li></ol>',text,'Unordered List should have been generated')
  end

  def test_ol_li
    i,text = WikiThat::Parser.parse('#A',0)
    assert_equal(2,i,'List should advance')
    assert_equal('<ol><li>A</li></ol>',text,'Unordered List should have been generated')
  end

  def test_ol_li2
    i,text = WikiThat::Parser.parse('# ABC',0)
    assert_equal(5,i,'List should advance')
    assert_equal('<ol><li> ABC</li></ol>',text,'Unordered List should have been generated')
  end

  def test_ol_ul
    i,text = WikiThat::Parser.parse('#* ABC',0)
    assert_equal(6,i,'List should advance')
    assert_equal('<ol><li><ul><li> ABC</li></ul></li></ol>',text,'Unordered List should have been generated')
  end

  def test_ul_ol_ul
    i,text = WikiThat::Parser.parse("*# AB\n*#* ABC",0)
    assert_equal(13,i,'List should advance')
    assert_equal("<ul><li><ol><li> AB</li><li><ul><li> ABC</li></ul></li></ol></li></ul>",text,'Unordered List should have been generated')
  end
end