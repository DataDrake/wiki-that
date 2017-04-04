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
end