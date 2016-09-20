require 'test/unit'
require_relative('../../../../lib/wiki-that/wiki-that')

class FormattingTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('',parser.result)
  end

  def test_italic
    parser = WikiThat::Parser.new('\'\'italic things\'\'','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p><i>italic things</i></p>',parser.result)
  end

  def test_italic_inline
    parser = WikiThat::Parser.new('not \'\'italic things\'\' not','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p>not <i>italic things</i> not</p>',parser.result)
  end

  def test_bold
    parser = WikiThat::Parser.new('\'\'\'bold things\'\'\'','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p><b>bold things</b></p>',parser.result)
  end

  def test_bold_inline
    parser = WikiThat::Parser.new('not \'\'\'bold things\'\'\' not','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p>not <b>bold things</b> not</p>',parser.result)
  end

  def test_both
    parser = WikiThat::Parser.new('\'\'\'\'\'both things\'\'\'\'\'','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p><b><i>both things</i></b></p>',parser.result)
  end

  def test_both_inline
    parser = WikiThat::Parser.new('not \'\'\'\'\'both things\'\'\'\'\' not','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p>not <b><i>both things</i></b> not</p>',parser.result)
  end

end