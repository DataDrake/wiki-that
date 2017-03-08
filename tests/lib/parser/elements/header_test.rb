require 'test/unit'
require_relative('../../../../lib/wiki-that/wiki-that')
class HeaderTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    parser = WikiThat::Parser.new('','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('',parser.result,'Response should be empty')
  end

  def test_short
    start = '= Incomplete Header ='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal(start,parser.result,'No header should be produced')
  end

  def test_incomplete
    start = '== Incomplete Header'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'No header should be produced')
  end

  def test_incomplete2
    start = '== Incomplete Header ='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'No header should be produced')
  end

  def test_h2
    start = '== Complete Header =='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>',parser.result,'H2 should be produced')
  end

  def test_h2_unbalanced_right
    start = '== Complete Header ==='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>',parser.result,'H2 should be produced')
  end

  def test_h2_unbalanced_left
    start = '=== Complete Header =='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>',parser.result,'H2 should be produced')
  end

  def test_h2_trailing_whitespace
    start = '== Complete Header ==     '
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>',parser.result,'H2 should be produced')
  end

  def test_h2_trailing_text
    start = '== Complete Header == text'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'H2 should not be produced')
  end

  def test_h3
    start = '=== Complete Header ==='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h3> Complete Header </h3>',parser.result,'H3 should be produced')
  end

  def test_h4
    start = '==== Complete Header ===='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h4> Complete Header </h4>',parser.result,'H4 should be produced')
  end

  def test_h5
    start = '===== Complete Header ====='
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h5> Complete Header </h5>',parser.result,'H5 should be produced')
  end

  def test_h6
    start = '====== Complete Header ======'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<h6> Complete Header </h6>',parser.result,'H6 should be produced')
  end
end