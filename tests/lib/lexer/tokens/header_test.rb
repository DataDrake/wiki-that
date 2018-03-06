##
# Copyright 2017-2018 Bryan T. Meyers
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
class HeaderLexTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_short
    start = '= Incomplete Header ='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('= Incomplete Header =', lexer.result[0].value)
  end

  def test_incomplete
    start = '== Incomplete Header'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("==", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Incomplete Header', lexer.result[1].value)
  end

  def test_incomplete2
    start = '== Incomplete Header ='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("==", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Incomplete Header ', lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('=', lexer.result[2].value)
  end

  def test_h2
    start = '== Complete Header =='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("==", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("==", lexer.result[2].value)
  end

  def test_h2_unbalanced_right
    start = '== Complete Header ==='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("==", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("===", lexer.result[2].value)
  end

  def test_h2_unbalanced_left
    start = '=== Complete Header =='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("===", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("==", lexer.result[2].value)
  end

  def test_h2_trailing_whitespace
    start = '== Complete Header ==     '
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("==", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("==", lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('     ', lexer.result[3].value)
  end

  def test_h2_trailing_text
    start = '== Complete Header == text'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("==", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("==", lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal(' text', lexer.result[3].value)
  end

  def test_h3
    start = '=== Complete Header ==='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("===", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("===", lexer.result[2].value)
  end

  def test_h4
    start = '==== Complete Header ===='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("====", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("====", lexer.result[2].value)
  end

  def test_h5
    start = '===== Complete Header ====='
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("=====", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("=====", lexer.result[2].value)
  end

  def test_h6
    start = '====== Complete Header ======'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:header_start, lexer.result[0].type)
    assert_equal("======", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' Complete Header ', lexer.result[1].value)
    assert_equal(:header_end, lexer.result[2].type)
    assert_equal("======", lexer.result[2].value)
  end
end