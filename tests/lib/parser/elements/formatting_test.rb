require 'test/unit'
require_relative('../../../../lib/wiki-that/wiki-that')

class FormattingTest < Test::Unit::TestCase

  def test_empty
    i,text = WikiThat::Parser.parse('',0)
    assert_equal(0,i)
    assert_equal('',text)
  end

  def test_italic
    i,text = WikiThat::Parser.parse('\'\'italic things\'\'',0)
    assert_equal(17,i)
    assert_equal('<i>italic things</i>',text)
  end

  def test_italic_inline
    i,text = WikiThat::Parser.parse('not \'\'italic things\'\' not',0)
    assert_equal(25,i)
    assert_equal('not <i>italic things</i> not',text)
  end

  def test_bold
    i,text = WikiThat::Parser.parse('\'\'\'bold things\'\'\'',0)
    assert_equal(17,i)
    assert_equal('<b>bold things</b>',text)
  end

  def test_bold_inline
    i,text = WikiThat::Parser.parse('not \'\'\'bold things\'\'\' not',0)
    assert_equal(25,i)
    assert_equal('not <b>bold things</b> not',text)
  end

  def test_both
    i,text = WikiThat::Parser.parse('\'\'\'\'\'both things\'\'\'\'\'',0)
    assert_equal(21,i)
    assert_equal('<b><i>both things</i></b>',text)
  end

  def test_both_inline
    i,text = WikiThat::Parser.parse('not \'\'\'\'\'both things\'\'\'\'\' not',0)
    assert_equal(29,i)
    assert_equal('not <b><i>both things</i></b> not',text)
  end

end