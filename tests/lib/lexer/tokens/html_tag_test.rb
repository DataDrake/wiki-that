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
    assert_equal('&lt;n', lexer.result[0].value)
  end

  def test_incomplete3
    lexer = WikiThat::Lexer.new('<nowiki')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('&lt;nowiki', lexer.result[0].value)
  end

  def test_incomplete4
    lexer = WikiThat::Lexer.new('<nowiki>')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:nowiki, lexer.result[0].type)
    assert_equal('', lexer.result[0].value)
  end

  def test_incomplete5
    lexer = WikiThat::Lexer.new('<nowiki>blah blah blah')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:nowiki, lexer.result[0].type)
    assert_equal('blah blah blah', lexer.result[0].value)
  end

  def test_incomplete6
    lexer = WikiThat::Lexer.new('<nowiki>blah blah blah<')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:nowiki, lexer.result[0].type)
    assert_equal('blah blah blah<', lexer.result[0].value)
  end

  def test_incomplete7
    lexer = WikiThat::Lexer.new('<nowiki>blah blah blah</nowiki')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:nowiki, lexer.result[0].type)
    assert_equal('blah blah blah&lt;/nowiki', lexer.result[0].value)
  end

  def test_extra
    lexer = WikiThat::Lexer.new('<<nowiki>blah blah blah</nowiki')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('&lt;', lexer.result[0].value)
    assert_equal(:nowiki, lexer.result[1].type)
    assert_equal('blah blah blah&lt;/nowiki', lexer.result[1].value)
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
    assert_equal(1, lexer.result.length)
    assert_equal(:pre, lexer.result[0].type)
    assert_equal('def hello()', lexer.result[0].value)
  end

  def test_complete3
    lexer = WikiThat::Lexer.new('<pre><code>def hello()</code></pre>')
    lexer.lex

    assert_equal(1, lexer.result.length)
    assert_equal(:pre, lexer.result[0].type)
    assert_equal('<code>def hello()</code>', lexer.result[0].value)
  end

  def test_complete4
    lexer = WikiThat::Lexer.new('1234 <pre><code>def hello()</code></pre>')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('1234 ', lexer.result[0].value)
    assert_equal(:pre, lexer.result[1].type)
    assert_equal('<code>def hello()</code>', lexer.result[1].value)
  end

  def test_complete5
    lexer = WikiThat::Lexer.new('1234 <tt>code</tt>')
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('1234 ', lexer.result[0].value)
    assert_equal(:tag_open, lexer.result[1].type)
    assert_equal('tt', lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('code', lexer.result[2].value)
    assert_equal(:tag_close, lexer.result[3].type)
    assert_equal('tt', lexer.result[3].value)
  end

  def test_complete6
    lexer = WikiThat::Lexer.new('1234 <pre><code>def hello()</code></pre> hello world')
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('1234 ', lexer.result[0].value)
    assert_equal(:pre, lexer.result[1].type)
    assert_equal('<code>def hello()</code>', lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal(' hello world', lexer.result[2].value)
  end

  def test_incomplete_comment1
    lexer = WikiThat::Lexer.new('<!')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<!', lexer.result[0].value)
  end

  def test_incomplete_comment2
    lexer = WikiThat::Lexer.new('<!-')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<!-', lexer.result[0].value)
  end

  def test_incomplete_comment3
    lexer = WikiThat::Lexer.new('!--')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_header, lexer.result[0].type)
    assert_equal(:rule, lexer.result[1].type)
  end

  def test_incomplete_comment4
    lexer = WikiThat::Lexer.new('<!-- ABC1235')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('&lt;!-- ABC1235', lexer.result[0].value)
  end

  def test_incomplete_comment5
    lexer = WikiThat::Lexer.new('<!-- ABC1235')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('&lt;!-- ABC1235', lexer.result[0].value)
  end

  def test_incomplete_comment6
    lexer = WikiThat::Lexer.new('<!-- ABC1235-')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<!-- ABC1235-', lexer.result[0].value)
  end

  def test_incomplete_comment7
    lexer = WikiThat::Lexer.new('<!-- ABC1235--')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<!-- ABC1235--', lexer.result[0].value)
  end

  def test_incomplete_comment8
    lexer = WikiThat::Lexer.new("<!-- ABC1235\n")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('<!-- ABC1235', lexer.result[0].value)
    assert_equal(:break, lexer.result[1].type)
    assert_equal(1, lexer.result[1].value)
  end

  def test_complete_comment
    lexer = WikiThat::Lexer.new('<!-- ABC1235 -->')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:comment, lexer.result[0].type)
    assert_equal(' ABC1235 ', lexer.result[0].value)
  end
end