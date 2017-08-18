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

class NoWikiParseTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(0, parser.result.children.length, 'Nothing should have been generated')
  end

  def test_complete
    start  = '<nowiki>this is not wiki markup</nowiki>'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:nowiki, parser.result.children[0].type)
    assert_equal('this is not wiki markup', parser.result.children[0].value)
  end

  def test_complete2
    start  = '<pre>this is not wiki markup</pre>'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:pre, parser.result.children[0].type)
    assert_equal('this is not wiki markup', parser.result.children[0].value)
  end

  def test_complete3
    parser = WikiThat::Parser.new('1234 <tt>code</tt>', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('1234 ', parser.result.children[0].children[0].value)
    assert_equal(:tt, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].type)
    assert_equal('code', parser.result.children[0].children[1].children[0].value)
  end

  def test_complete4
    start  = '1234 <pre>this is not wiki markup</pre> hello world'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(3, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('1234 ', parser.result.children[0].children[0].value)
    assert_equal(:pre, parser.result.children[0].children[1].type)
    assert_equal('this is not wiki markup', parser.result.children[0].children[1].value)
    assert_equal(:text, parser.result.children[0].children[2].type)
    assert_equal(' hello world', parser.result.children[0].children[2].value)
  end

  def test_incomplete_comment1
    parser = WikiThat::Parser.new('<!', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('<!', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment2
    parser = WikiThat::Parser.new('<!-', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('<!-', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment3
    parser = WikiThat::Parser.new('<!--', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('&lt;!--', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment4
    parser = WikiThat::Parser.new('<!-- ABC1235', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('&lt;!-- ABC1235', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment5
    parser = WikiThat::Parser.new('<!-- ABC1235', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('&lt;!-- ABC1235', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment6
    parser = WikiThat::Parser.new('<!-- ABC1235-', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('<!-- ABC1235-', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment7
    parser = WikiThat::Parser.new('<!-- ABC1235--', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('<!-- ABC1235--', parser.result.children[0].children[0].value)
  end

  def test_incomplete_comment8
    parser = WikiThat::Parser.new("<!-- ABC1235\n", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('<!-- ABC1235', parser.result.children[0].children[0].value)
    assert_equal(:text, parser.result.children[0].children[1].type)
    assert_equal('&nbsp;', parser.result.children[0].children[1].value)
  end

  def test_complete_comment
    parser = WikiThat::Parser.new('<!-- ABC1235 -->', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:comment, parser.result.children[0].type)
    assert_equal(' ABC1235 ', parser.result.children[0].value)
  end

end