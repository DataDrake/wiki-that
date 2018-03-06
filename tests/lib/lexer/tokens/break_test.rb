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

class BreakLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_newline
    lexer = WikiThat::Lexer.new("\n")
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:break, lexer.result[0].type)
    assert_equal("\n", lexer.result[0].value)
  end

  def test_break1
    lexer = WikiThat::Lexer.new("\n\n")
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:break, lexer.result[0].type)
    assert_equal("\n\n", lexer.result[0].value)
  end

  def test_break2
    lexer = WikiThat::Lexer.new("\n\n\n")
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:break, lexer.result[0].type)
    assert_equal("\n\n\n", lexer.result[0].value)
  end

  def test_break3
    lexer = WikiThat::Lexer.new("Hello\nGoodbye\n\n")
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('Hello', lexer.result[0].value)
    assert_equal(:break, lexer.result[1].type)
    assert_equal("\n", lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('Goodbye', lexer.result[2].value)
    assert_equal(:break, lexer.result[3].type)
    assert_equal("\n\n", lexer.result[3].value)
  end

  def test_break4
    lexer = WikiThat::Lexer.new("Hello\n\nGoodbye\n")
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('Hello', lexer.result[0].value)
    assert_equal(:break, lexer.result[1].type)
    assert_equal("\n\n", lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('Goodbye', lexer.result[2].value)
    assert_equal(:break, lexer.result[3].type)
    assert_equal("\n", lexer.result[3].value)
  end

end