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

class FormattingLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_short
    lexer = WikiThat::Lexer.new('\'')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('\'', lexer.result[0].value)
  end

  def test_short2
    lexer = WikiThat::Lexer.new('\'\'thing\'')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:format, lexer.result[0].type)
    assert_equal("''", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal("thing'", lexer.result[1].value)
  end

  def test_italic
    lexer = WikiThat::Lexer.new('\'\'italic things\'\'')
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:format, lexer.result[0].type)
    assert_equal("''", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('italic things', lexer.result[1].value)
    assert_equal(:format, lexer.result[2].type)
    assert_equal("''", lexer.result[2].value)
  end

  def test_italic_inline
    lexer = WikiThat::Lexer.new('not \'\'italic things\'\' not')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('not ', lexer.result[0].value)
    assert_equal(:format, lexer.result[1].type)
    assert_equal("''", lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('italic things', lexer.result[2].value)
    assert_equal(:format, lexer.result[3].type)
    assert_equal("''", lexer.result[3].value)
    assert_equal(:text, lexer.result[4].type)
    assert_equal(' not', lexer.result[4].value)
  end

  def test_bold
    lexer = WikiThat::Lexer.new('\'\'\'bold things\'\'\'')
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:format, lexer.result[0].type)
    assert_equal("'''", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('bold things', lexer.result[1].value)
    assert_equal(:format, lexer.result[2].type)
    assert_equal("'''", lexer.result[2].value)
  end

  def test_bold_inline
    lexer = WikiThat::Lexer.new('not \'\'\'bold things\'\'\' not')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('not ', lexer.result[0].value)
    assert_equal(:format, lexer.result[1].type)
    assert_equal("'''", lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('bold things', lexer.result[2].value)
    assert_equal(:format, lexer.result[3].type)
    assert_equal("'''", lexer.result[3].value)
    assert_equal(:text, lexer.result[4].type)
    assert_equal(' not', lexer.result[4].value)
  end

  def test_both
    lexer = WikiThat::Lexer.new('\'\'\'\'\'both things\'\'\'\'\'')
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:format, lexer.result[0].type)
    assert_equal("'''''", lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('both things', lexer.result[1].value)
    assert_equal(:format, lexer.result[2].type)
    assert_equal("'''''", lexer.result[2].value)
  end

  def test_both_inline
    lexer = WikiThat::Lexer.new('not \'\'\'\'\'both things\'\'\'\'\' not')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('not ', lexer.result[0].value)
    assert_equal(:format, lexer.result[1].type)
    assert_equal("'''''", lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('both things', lexer.result[2].value)
    assert_equal(:format, lexer.result[3].type)
    assert_equal("'''''", lexer.result[3].value)
    assert_equal(:text, lexer.result[4].type)
    assert_equal(' not', lexer.result[4].value)
  end

end