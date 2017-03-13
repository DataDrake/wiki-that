##
# Copyright 2017 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
##
require 'test/unit'
require_relative('../../../../lib/wiki-that')
class HeaderParseTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(0, parser.result.children.length)
  end

  def test_short
    start = '= Incomplete Header ='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:paragraph, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('= Incomplete Header =', parser.result.children[0].children[0].value)
  end

  def test_incomplete
    start = '== Incomplete Header'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(2, parser.result.children.length)
    assert_equal(:text, parser.result.children[0].type)
    assert_equal('==', parser.result.children[0].value)
    assert_equal(:text, parser.result.children[1].type)
    assert_equal(' Incomplete Header', parser.result.children[1].value)
  end

  def test_incomplete2
    start = '== Incomplete Header ='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(3, parser.result.children.length)
    assert_equal(:text, parser.result.children[0].type)
    assert_equal('==', parser.result.children[0].value)
    assert_equal(:text, parser.result.children[1].type)
    assert_equal(' Incomplete Header ', parser.result.children[1].value)
    assert_equal(:text, parser.result.children[2].type)
    assert_equal('=', parser.result.children[2].value)
  end

  def test_h2
    start = '== Complete Header =='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h2_unbalanced_right
    start = '== Complete Header ==='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h2_unbalanced_left
    start = '=== Complete Header =='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h2_trailing_whitespace
    start = '== Complete Header ==     '
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h2_trailing_text
    start = '== Complete Header == text'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_false(parser.success?, 'Parsing should have failed')
    assert_equal(4, parser.result.children.length)
    assert_equal(:text, parser.result.children[0].type)
    assert_equal('==', parser.result.children[0].value)
    assert_equal(:text, parser.result.children[1].type)
    assert_equal(' Complete Header ', parser.result.children[1].value)
    assert_equal(:text, parser.result.children[2].type)
    assert_equal('==', parser.result.children[2].value)
    assert_equal(:text, parser.result.children[3].type)
    assert_equal(' text', parser.result.children[3].value)
  end

  def test_h3
    start = '=== Complete Header ==='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(3, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h4
    start = '==== Complete Header ===='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(4, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h5
    start = '===== Complete Header ====='
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(5, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end

  def test_h6
    start = '====== Complete Header ======'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:header, parser.result.children[0].type)
    assert_equal(6, parser.result.children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(' Complete Header ', parser.result.children[0].children[0].value)
  end
end