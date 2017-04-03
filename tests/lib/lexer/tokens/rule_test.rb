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

class RuleLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_incomplete1
    start = '-'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('-', lexer.result[0].value)
  end

  def test_incomplete2
    start = '--'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:rule, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
  end

  def test_complete1
    start = '---'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:rule, lexer.result[0].type)
    assert_equal(3, lexer.result[0].value)
  end

  def test_complete2
    start = '----'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:rule, lexer.result[0].type)
    assert_equal(4, lexer.result[0].value)
  end
end