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

class ListTest < Test::Unit::TestCase
  def test_empty
    lexer = WikiThat::Lexer.new('','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('',lexer.result,'Nothing should have been generated')
  end

  def test_ul
    lexer = WikiThat::Lexer.new('*','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ul><li></li></ul>',lexer.result,'Unordered List should have been generated')
  end

  def test_ul_li
    lexer = WikiThat::Lexer.new('*A','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ul><li>A</li></ul>',lexer.result,'Unordered List should have been generated')
  end

  def test_ul_li2
    lexer = WikiThat::Lexer.new('* ABC','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ul><li> ABC</li></ul>',lexer.result,'Unordered List should have been generated')
  end

  def test_ol
    lexer = WikiThat::Lexer.new('#','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ol><li></li></ol>',lexer.result,'Unordered List should have been generated')
  end

  def test_ol_li
    lexer = WikiThat::Lexer.new('#A','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ol><li>A</li></ol>',lexer.result,'Unordered List should have been generated')
  end

  def test_ol_li2
    lexer = WikiThat::Lexer.new('# ABC','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ol><li> ABC</li></ol>',lexer.result,'Unordered List should have been generated')
  end

  def test_ol_ul
    lexer = WikiThat::Lexer.new('#* ABC','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ol><li><ul><li> ABC</li></ul></li></ol>',lexer.result,'Unordered List should have been generated')
  end

  def test_ul_ol_ul
    lexer = WikiThat::Lexer.new("*# AB\n*#* ABC",'wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ul><li><ol><li> AB</li><li><ul><li> ABC</li></ul></li></ol></li></ul>',lexer.result,'Unordered List should have been generated')
  end

  def test_dl
    lexer = WikiThat::Lexer.new('- ABC','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<dl><dd> ABC</dd></dl>',lexer.result,'Unordered List should have been generated')
  end

  def test_dl2
    lexer = WikiThat::Lexer.new('; ABC','wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<dl><dt> ABC</dt></dl>',lexer.result,'Unordered List should have been generated')
  end

  def test_dl_dt_dn
    lexer = WikiThat::Lexer.new("; ABC\n- DEF",'wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<dl><dt> ABC</dt><dd> DEF</dd></dl>',lexer.result,'Unordered List should have been generated')
  end

  def test_dl_dn_dt
    lexer = WikiThat::Lexer.new("- ABC\n; DEF",'wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<dl><dd> ABC</dd><dt> DEF</dt></dl>',lexer.result,'Unordered List should have been generated')
  end


  def test_ol_dl_dt_dn
    lexer = WikiThat::Lexer.new("#; ABC\n#- DEF",'wiki','BOB','sub/folder')
    lexer.lex

    assert_equal('<ol><li><dl><dt> ABC</dt><dd> DEF</dd></dl></li></ol>',lexer.result,'Unordered List should have been generated')
  end

end