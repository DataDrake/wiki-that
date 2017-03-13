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

class FormattingParseTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(0, parser.result.children.length)
  end

  def test_short
    parser = WikiThat::Parser.new('\'', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('\'', parser.result.children[0].children[0].value)
  end

  def test_short2
    parser = WikiThat::Parser.new('\'\'thing\'', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('\'\'', parser.result.children[0].children[0].value)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[1].type)
    assert_equal('thing\'', parser.result.children[0].children[1].value)
    assert_equal(0, parser.result.children[0].children[1].children.length)
  end

  def test_italic
    parser = WikiThat::Parser.new('\'\'italic things\'\'', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:i, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('italic things', parser.result.children[0].children[0].children[0].value)
  end

  def test_italic_inline
    parser = WikiThat::Parser.new('not \'\'italic things\'\' not', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(3, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('not ', parser.result.children[0].children[0].value)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(:i, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].type)
    assert_equal('italic things', parser.result.children[0].children[1].children[0].value)
    assert_equal(:text, parser.result.children[0].children[2].type)
    assert_equal(' not', parser.result.children[0].children[2].value)
    assert_equal(0, parser.result.children[0].children[2].children.length)
  end

  def test_bold
    parser = WikiThat::Parser.new('\'\'\'bold things\'\'\'', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:b, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('bold things', parser.result.children[0].children[0].children[0].value)
  end

  def test_bold_inline
    parser = WikiThat::Parser.new('not \'\'\'bold things\'\'\' not', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(3, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('not ', parser.result.children[0].children[0].value)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(:b, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].type)
    assert_equal('bold things', parser.result.children[0].children[1].children[0].value)
    assert_equal(:text, parser.result.children[0].children[2].type)
    assert_equal(' not', parser.result.children[0].children[2].value)
    assert_equal(0, parser.result.children[0].children[2].children.length)
  end

  def test_both
    parser = WikiThat::Parser.new('\'\'\'\'\'both things\'\'\'\'\'', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:i, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:b, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal('both things', parser.result.children[0].children[0].children[0].children[0].value)

  end

  def test_both_inline
    parser = WikiThat::Parser.new('not \'\'\'\'\'both things\'\'\'\'\' not', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(3, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('not ', parser.result.children[0].children[0].value)
    assert_equal(0, parser.result.children[0].children[0].children.length)
    assert_equal(:i, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:b, parser.result.children[0].children[1].children[0].type)
    assert_equal(1, parser.result.children[0].children[1].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].children[0].type)
    assert_equal('both things', parser.result.children[0].children[1].children[0].children[0].value)
    assert_equal(:text, parser.result.children[0].children[2].type)
    assert_equal(' not', parser.result.children[0].children[2].value)
    assert_equal(0, parser.result.children[0].children[2].children.length)
  end

end