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

class TableLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_start_bad
    lexer = WikiThat::Lexer.new('{A')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('{A', lexer.result[0].value)
  end

  def test_start
    lexer = WikiThat::Lexer.new('{|')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:table_start, lexer.result[0].type)
  end

  def test_start2
    lexer = WikiThat::Lexer.new('{| class="wikitable"')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_start, lexer.result[0].type)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' class="wikitable"', lexer.result[1].value)
  end

  def test_end
    lexer = WikiThat::Lexer.new('|}')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:table_end, lexer.result[0].type)
  end

  def test_caption
    lexer = WikiThat::Lexer.new("{|\n|+Caption Here")
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:table_start, lexer.result[0].type)
    assert_equal(:table_caption, lexer.result[1].type)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('Caption Here', lexer.result[2].value)
  end

  def test_caption2
    lexer = WikiThat::Lexer.new("|+Caption Here")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_caption, lexer.result[0].type)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Caption Here', lexer.result[1].value)
  end

  def test_row
    lexer = WikiThat::Lexer.new("{|\n|-Row Here")
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:table_start, lexer.result[0].type)
    assert_equal(:table_row, lexer.result[1].type)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('Row Here', lexer.result[2].value)
  end

  def test_row2
    lexer = WikiThat::Lexer.new("|-Row Here")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_row, lexer.result[0].type)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Row Here', lexer.result[1].value)
  end

  def test_th
    lexer = WikiThat::Lexer.new("!Header Here")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_header, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Header Here', lexer.result[1].value)
  end

  def test_th2
    lexer = WikiThat::Lexer.new("!!Header Here")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_header, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Header Here', lexer.result[1].value)
  end

  def test_td
    lexer = WikiThat::Lexer.new("|Column Here")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_column, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Column Here', lexer.result[1].value)
  end

  def test_td2
    lexer = WikiThat::Lexer.new("||Column Here")
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:table_column, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Column Here', lexer.result[1].value)
  end

end