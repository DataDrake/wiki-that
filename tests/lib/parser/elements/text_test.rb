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

class TextParseTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(:root, parser.result.type)
    assert_equal(nil, parser.result.value)
    assert_equal(0, parser.result.children.length)
  end

  def test_single
    parser = WikiThat::Parser.new('abc', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:paragraph, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('abc', parser.result.children[0].children[0].value)
  end

  def test_double
    parser = WikiThat::Parser.new("abc\n123", 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:paragraph, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('abc', parser.result.children[0].children[0].value)
    assert_equal(:text, parser.result.children[0].children[1].type)
    assert_equal('123', parser.result.children[0].children[1].value)
  end

  def test_double_break
    parser = WikiThat::Parser.new("abc\n\n123", 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(2, parser.result.children.length)
    assert_equal(:paragraph, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('abc', parser.result.children[0].children[0].value)
    assert_equal(:paragraph, parser.result.children[1].type)
    assert_equal(1, parser.result.children[1].children.length)
    assert_equal(:text, parser.result.children[1].children[0].type)
    assert_equal('123', parser.result.children[1].children[0].value)
  end

end