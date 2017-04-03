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

class NoWikiLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_incomplete1
    lexer = WikiThat::Lexer.new('<')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<', lexer.result[0].value)
  end

  def test_incomplete2
    lexer = WikiThat::Lexer.new('<n')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<n', lexer.result[0].value)
  end

  def test_incomplete3
    lexer = WikiThat::Lexer.new('<nowiki')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<nowiki', lexer.result[0].value)
  end

  def test_incomplete4
    lexer = WikiThat::Lexer.new('<nowiki>')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<nowiki>', lexer.result[0].value)
  end

  def test_incomplete5
    lexer = WikiThat::Lexer.new('<nowiki>blah blah blah')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<nowiki>blah blah blah', lexer.result[0].value)
  end

  def test_incomplete6
    lexer = WikiThat::Lexer.new('<nowiki>blah blah blah<')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<nowiki>blah blah blah<', lexer.result[0].value)
  end

  def test_incomplete7
    lexer = WikiThat::Lexer.new('<nowiki>blah blah blah</nowiki')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<nowiki>blah blah blah</nowiki', lexer.result[0].value)
  end

  def test_extra
    lexer = WikiThat::Lexer.new('<<nowiki>blah blah blah</nowiki')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<<nowiki>blah blah blah</nowiki', lexer.result[0].value)
  end

  def test_complete
    lexer = WikiThat::Lexer.new('<nowiki></nowiki>')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:nowiki, lexer.result[0].type)
    assert_equal('', lexer.result[0].value)
  end

  def test_complete2
    lexer = WikiThat::Lexer.new('<pre>def hello()</pre>')
    lexer.lex
    puts lexer.result.inspect
    assert_equal(1, lexer.result.length)
    assert_equal(:pre, lexer.result[0].type)
    assert_equal('def hello()', lexer.result[0].value)
  end

  def test_complete3
    lexer = WikiThat::Lexer.new('<pre><code>def hello()</code></pre>')
    lexer.lex
    puts lexer.result.inspect
    assert_equal(1, lexer.result.length)
    assert_equal(:pre, lexer.result[0].type)
    assert_equal('<code>def hello()</code>', lexer.result[0].value)
  end

end