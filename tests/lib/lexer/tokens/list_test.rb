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

class ListLexTest < Test::Unit::TestCase
  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_ul
    lexer = WikiThat::Lexer.new('*')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('*', lexer.result[0].value)
  end

  def test_ul_li
    lexer = WikiThat::Lexer.new('*A')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('*', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('A', lexer.result[1].value)
  end

  def test_ul_li2
    lexer = WikiThat::Lexer.new('* ABC')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('*', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
  end

  def test_ol
    lexer = WikiThat::Lexer.new('#')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('#', lexer.result[0].value)
  end

  def test_ol_li
    lexer = WikiThat::Lexer.new('#A')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('#', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('A', lexer.result[1].value)
  end

  def test_ol_li2
    lexer = WikiThat::Lexer.new('# ABC')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('#', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
  end

  def test_ol_ul
    lexer = WikiThat::Lexer.new('#* ABC')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('#*', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
  end

  def test_ul_ol_ul
    lexer = WikiThat::Lexer.new("*# AB\n*#* ABC")
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('*#', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' AB', lexer.result[1].value)
    assert_equal(:list_item, lexer.result[2].type)
    assert_equal('*#*', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal(' ABC', lexer.result[3].value)
  end

  def test_dl
    lexer = WikiThat::Lexer.new('- ABC')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('-', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
  end

  def test_dl2
    lexer = WikiThat::Lexer.new('; ABC')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal(';', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
  end

  def test_dl_dt_dn
    lexer = WikiThat::Lexer.new("; ABC\n- DEF")
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal(';', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
    assert_equal(:list_item, lexer.result[2].type)
    assert_equal('-', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal(' DEF', lexer.result[3].value)
  end

  def test_dl_dn_dt
    lexer = WikiThat::Lexer.new("- ABC\n; DEF")
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('-', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
    assert_equal(:list_item, lexer.result[2].type)
    assert_equal(';', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal(' DEF', lexer.result[3].value)
  end


  def test_ol_dl_dt_dn
    lexer = WikiThat::Lexer.new("#; ABC\n#- DEF")
    lexer.lex
    assert_equal(4, lexer.result.length)
    assert_equal(:list_item, lexer.result[0].type)
    assert_equal('#;', lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal(' ABC', lexer.result[1].value)
    assert_equal(:list_item, lexer.result[2].type)
    assert_equal('#-', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal(' DEF', lexer.result[3].value)
  end

end