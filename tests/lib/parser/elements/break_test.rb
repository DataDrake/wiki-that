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

class BreakTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('','wiki','BOB','sub/folder')
    lexer.lex
    assert_true(lexer.success?,'Parsing should have succeeded')
    assert_equal('',lexer.result)
  end

  def test_newline
    lexer = WikiThat::Lexer.new("\n",'wiki','BOB','sub/folder')
    lexer.lex
    assert_true(lexer.success?,'Parsing should have succeeded')
    assert_equal('<p></p>',lexer.result)
  end

  def test_break1
    lexer = WikiThat::Lexer.new("\n\n",'wiki','BOB','sub/folder')
    lexer.lex
    assert_true(lexer.success?,'Parsing should have succeeded')
    assert_equal('<p></p>',lexer.result)
  end

  def test_break2
    lexer = WikiThat::Lexer.new("\n\n\n",'wiki','BOB','sub/folder')
    lexer.lex
    assert_true(lexer.success?,'Parsing should have succeeded')
    assert_equal('<p></p>',lexer.result)
  end

  def test_break3
    lexer = WikiThat::Lexer.new("Hello\nGoodbye\n\n",'wiki','BOB','sub/folder')
    lexer.lex
    assert_true(lexer.success?,'Parsing should have succeeded')
    assert_equal('<p>HelloGoodbye</p>',lexer.result)
  end

  def test_break4
    lexer = WikiThat::Lexer.new("Hello\n\nGoodbye\n",'wiki','BOB','sub/folder')
    lexer.lex
    assert_true(lexer.success?,'Parsing should have succeeded')
    assert_equal('<p>Hello</p><p>Goodbye</p>',lexer.result)
  end

end