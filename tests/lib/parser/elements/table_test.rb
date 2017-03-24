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
class TableParseTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(0, parser.result.children.length)
  end

  def test_incomplete1
    start = '{'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(start, parser.result.children[0].children[0].value)
  end

  def test_incomplete2
    start = '{|'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
  end

  def test_incomplete3
    start = '{| not an attribute'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(2, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(:p, parser.result.children[1].type)
  end

  def test_incomplete4
    start = '{| a="b"'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(1,parser.result.children[0].attributes.length)
    assert_equal('b', parser.result.children[0].attributes['a'])
  end

  def test_incomplete5
    start = '{| a="b" c="1234&"'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(2,parser.result.children[0].attributes.length)
    assert_equal('b', parser.result.children[0].attributes['a'])
    assert_equal('1234&', parser.result.children[0].attributes['c'])
  end

  def test_incomplete6
    start = "{|\n|+"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(0,parser.result.children[0].children.length)
  end

  def test_incomplete7
    start = "{|\n|+this is a caption"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:caption, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('this is a caption', parser.result.children[0].children[0].children[0].value)
  end

  def test_incomplete8
    start = "{|\n|- these are not attributes"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(2, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(0, parser.result.children[0].children[0].attributes.length)
    assert_equal(:p, parser.result.children[1].type)
  end

  def test_incomplete9
    start = "{|\n|- a=\"b\""
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('b', parser.result.children[0].children[0].attributes['a'])
  end

  def test_incomplete10
    start = "{|\n|- \n"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(0, parser.result.children[0].children[0].attributes.length)
  end

  def test_caption_whitespace
    start = "{|\n|+ \n"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:caption, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
  end

  def test_incomplete11
    start = "{|\n|-\n1234"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(2, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(0, parser.result.children[0].children[0].attributes.length)
    assert_equal(:p, parser.result.children[1].type)
    assert_equal(1,parser.result.children[1].children.length)
    assert_equal(:text, parser.result.children[1].children[0].type)
    assert_equal('1234', parser.result.children[1].children[0].value)
  end

  def test_incomplete12
    start = "{|\n|-\n| 1234"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234', parser.result.children[0].children[0].children[0].children[0].value)
  end

  def test_incomplete13
    start = "{|\n| 1234"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234', parser.result.children[0].children[0].children[0].children[0].value)
  end

  def test_incomplete14
    start = "{|\n|-\n| a=\"b\" | 1234"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].attributes.length)
    assert_equal('b', parser.result.children[0].children[0].children[0].attributes['a'])
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234', parser.result.children[0].children[0].children[0].children[0].value)
  end

  def test_incomplete15
    start = "{|\n|-\n| a=\"b\" | 1234 ! bob"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].attributes.length)
    assert_equal('b', parser.result.children[0].children[0].children[0].attributes['a'])
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234 ', parser.result.children[0].children[0].children[0].children[0].value)
    assert_equal(:th, parser.result.children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[1].children[0].type)
    assert_equal(' bob', parser.result.children[0].children[0].children[1].children[0].value)
  end

  def test_incomplete16
    start = "{|\n|-\n| a=\"b\" | 1234 \n|-\n! bob"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(2,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].attributes.length)
    assert_equal('b', parser.result.children[0].children[0].children[0].attributes['a'])
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234 ', parser.result.children[0].children[0].children[0].children[0].value)
    assert_equal(:tr, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:th, parser.result.children[0].children[1].children[0].type)
    assert_equal(1, parser.result.children[0].children[1].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].children[0].type)
    assert_equal(' bob', parser.result.children[0].children[1].children[0].children[0].value)
  end

  def test_incomplete17
    start = "{|\n| 1234 \nparagraph\n! bob"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234 ', parser.result.children[0].children[0].children[0].children[0].value)
    assert_equal(:p, parser.result.children[0].children[0].children[0].children[1].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[0].type)
    assert_equal('paragraph', parser.result.children[0].children[0].children[0].children[1].children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[1].type)
    assert_equal('&nbsp;', parser.result.children[0].children[0].children[0].children[1].children[1].value)
    assert_equal(:th, parser.result.children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[1].children[0].type)
    assert_equal(' bob', parser.result.children[0].children[0].children[1].children[0].value)
  end

  def test_complete
    start = "{|\n| 1234 \nparagraph\n! bob\n|}"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234 ', parser.result.children[0].children[0].children[0].children[0].value)
    assert_equal(:p, parser.result.children[0].children[0].children[0].children[1].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[0].type)
    assert_equal('paragraph', parser.result.children[0].children[0].children[0].children[1].children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[1].type)
    assert_equal('&nbsp;', parser.result.children[0].children[0].children[0].children[1].children[1].value)
    assert_equal(:th, parser.result.children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[1].children[0].type)
    assert_equal(' bob', parser.result.children[0].children[0].children[1].children[0].value)
  end

  def test_complete2
    start = "{|\n|| 1234 \nparagraph\n! bob\n|}"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(0,parser.result.children[0].attributes.length)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr, parser.result.children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children.length)
    assert_equal(:td, parser.result.children[0].children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(' 1234 ', parser.result.children[0].children[0].children[0].children[0].value)
    assert_equal(:p, parser.result.children[0].children[0].children[0].children[1].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[0].type)
    assert_equal('paragraph', parser.result.children[0].children[0].children[0].children[1].children[0].value)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[1].type)
    assert_equal('&nbsp;', parser.result.children[0].children[0].children[0].children[1].children[1].value)
    assert_equal(:th, parser.result.children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[1].children[0].type)
    assert_equal(' bob', parser.result.children[0].children[0].children[1].children[0].value)
  end

  def test_nested
    start = "{|\n|-\n|\n{|\n|}\n|}"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr,parser.result.children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children.length)
    assert_equal(:td,parser.result.children[0].children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:table,parser.result.children[0].children[0].children[0].children[0].type)
  end

  def test_nested2
    start = "{|\n|-\n|\n{|\n|-\n|\n* ABC\n|}\n|}"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:table, parser.result.children[0].type)
    assert_equal(1,parser.result.children[0].children.length)
    assert_equal(:tr,parser.result.children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children.length)
    assert_equal(:td,parser.result.children[0].children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:table,parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children[0].children[0].children.length)
    assert_equal(:tr,parser.result.children[0].children[0].children[0].children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children[0].children[0].children[0].children.length)
    assert_equal(:td,parser.result.children[0].children[0].children[0].children[0].children[0].children[0].type)
    assert_equal(1,parser.result.children[0].children[0].children[0].children[0].children[0].children[0].children.length)
    assert_equal(:ul,parser.result.children[0].children[0].children[0].children[0].children[0].children[0].children[0].type)
  end

end