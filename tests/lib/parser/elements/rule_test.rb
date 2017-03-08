require 'test/unit'
require_relative('../../../../lib/wiki-that/parser/parser')

class RuleTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('',parser.result,'Nothing should have been generated')
  end

  def test_incomplete1
    start = '-'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<dl><dd></dd></dl>',parser.result,'Nothing should have been generated')
  end

  def test_incomplete2
    start = '--'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<dl><dd><dl><dd></dd></dl></dd></dl>',parser.result,'Nothing should have been generated')
  end

  def test_complete1
    start = '---'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<hr/>',parser.result,'Nothing should have been generated')
  end

  def test_complete2
    start = '---'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<hr/>',parser.result,'Nothing should have been generated')
  end
end