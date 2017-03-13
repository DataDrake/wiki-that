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
class HeaderTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    lexer = WikiThat::Lexer.new('', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('', lexer.result, 'Response should be empty')
  end

  def test_short
    start = '= Incomplete Header ='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal(start, lexer.result, 'No header should be produced')
  end

  def test_incomplete
    start = '== Incomplete Header'
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'No header should be produced')
  end

  def test_incomplete2
    start = '== Incomplete Header ='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'No header should be produced')
  end

  def test_h2
    start = '== Complete Header =='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>', lexer.result, 'H2 should be produced')
  end

  def test_h2_unbalanced_right
    start = '== Complete Header ==='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>', lexer.result, 'H2 should be produced')
  end

  def test_h2_unbalanced_left
    start = '=== Complete Header =='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>', lexer.result, 'H2 should be produced')
  end

  def test_h2_trailing_whitespace
    start = '== Complete Header ==     '
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h2> Complete Header </h2>', lexer.result, 'H2 should be produced')
  end

  def test_h2_trailing_text
    start = '== Complete Header == text'
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'H2 should not be produced')
  end

  def test_h3
    start = '=== Complete Header ==='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h3> Complete Header </h3>', lexer.result, 'H3 should be produced')
  end

  def test_h4
    start = '==== Complete Header ===='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h4> Complete Header </h4>', lexer.result, 'H4 should be produced')
  end

  def test_h5
    start = '===== Complete Header ====='
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h5> Complete Header </h5>', lexer.result, 'H5 should be produced')
  end

  def test_h6
    start = '====== Complete Header ======'
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<h6> Complete Header </h6>', lexer.result, 'H6 should be produced')
  end
end