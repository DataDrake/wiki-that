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

class TableOfContentsLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_incomplete1
    lexer = WikiThat::Lexer.new('_')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('_', lexer.result[0].value)
  end

  def test_incomplete2
    lexer = WikiThat::Lexer.new('__')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('__', lexer.result[0].value)
  end

  def test_incomplete3
    lexer = WikiThat::Lexer.new('__NOTOC')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('__NOTOC', lexer.result[0].value)
  end

  def test_incomplete4
    lexer = WikiThat::Lexer.new('__NOTOC_')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('__NOTOC_', lexer.result[0].value)
  end

  def test_complete
    lexer = WikiThat::Lexer.new('__NOTOC__')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_complete_trailing
    lexer = WikiThat::Lexer.new('__NOTOC__ this should be ignored')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_complete_trailing_newline
    lexer = WikiThat::Lexer.new("__NOTOC__ this should be ignored\n")
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

end