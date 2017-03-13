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

class TextLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_single
    lexer = WikiThat::Lexer.new('abc')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('abc', lexer.result[0].value)
  end

  def test_double
    lexer = WikiThat::Lexer.new("abc\n123")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('abc', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('123', lexer.result[1].value)
  end

  def test_double_break
    lexer = WikiThat::Lexer.new("abc\n\n123")
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('abc', lexer.result[0].value)
    assert_equal(:break, lexer.result[1].type)
    assert_equal(2, lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('123', lexer.result[2].value)
  end

end