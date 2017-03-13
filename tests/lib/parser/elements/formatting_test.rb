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

class FormattingTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('', lexer.result)
  end

  def test_short
    lexer = WikiThat::Lexer.new('\'', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p>\'</p>', lexer.result)
  end

  def test_short2
    lexer = WikiThat::Lexer.new('\'\'thing\'', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p>\'\'thing\'</p>', lexer.result)
  end

  def test_italic
    lexer = WikiThat::Lexer.new('\'\'italic things\'\'', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p><i>italic things</i></p>', lexer.result)
  end

  def test_italic_inline
    lexer = WikiThat::Lexer.new('not \'\'italic things\'\' not', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p>not <i>italic things</i> not</p>', lexer.result)
  end

  def test_bold
    lexer = WikiThat::Lexer.new('\'\'\'bold things\'\'\'', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p><b>bold things</b></p>', lexer.result)
  end

  def test_bold_inline
    lexer = WikiThat::Lexer.new('not \'\'\'bold things\'\'\' not', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p>not <b>bold things</b> not</p>', lexer.result)
  end

  def test_both
    lexer = WikiThat::Lexer.new('\'\'\'\'\'both things\'\'\'\'\'', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p><b><i>both things</i></b></p>', lexer.result)
  end

  def test_both_inline
    lexer = WikiThat::Lexer.new('not \'\'\'\'\'both things\'\'\'\'\' not', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p>not <b><i>both things</i></b> not</p>', lexer.result)
  end

end