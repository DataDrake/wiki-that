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
require 'awesome_print'
require 'test/unit'
require_relative('../../../../lib/wiki-that')

class ListParseTest < Test::Unit::TestCase
  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(0, parser.result.children.length)
  end

  def test_ul
    parser = WikiThat::Parser.new('*', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ul, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
  end

  def test_ul_li
    parser = WikiThat::Parser.new('*A', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ul, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('A', parser.result.children[0].children[0].children[0].value)
  end

  def test_ul_li2
    parser = WikiThat::Parser.new('* ABC', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ul, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].value)
  end

  def test_ol
    parser = WikiThat::Parser.new('#', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ol, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(0, parser.result.children[0].children[0].children.length)
  end

  def test_ol_li
    parser = WikiThat::Parser.new('#A', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ol, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('A', parser.result.children[0].children[0].children[0].value)
  end

  def test_ol_li2
    parser = WikiThat::Parser.new('# ABC', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ol, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].value)
  end

  def test_ol_ul
    parser = WikiThat::Parser.new('#* ABC', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ol, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:ul, parser.result.children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].children[0].children[0].value)
  end

  def test_ul_ol_ul
    parser = WikiThat::Parser.new("*# AB\n*#* ABC", 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ul, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:ol, parser.result.children[0].children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].children[0].type)
    assert_equal(' AB', parser.result.children[0].children[0].children[0].children[0].children[0].value)
    assert_equal(:li, parser.result.children[0].children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[1].children.length)
    assert_equal(:ul, parser.result.children[0].children[0].children[0].children[1].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[1].children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].children[0].children[1].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[1].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].children[1].children[0].children[0].children[0].value)
  end

  def test_dl
    parser = WikiThat::Parser.new(': ABC', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:dl, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:dd, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].value)
  end

  def test_dl2
    parser = WikiThat::Parser.new('; ABC', 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:dl, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:dt, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].value)
  end

  def test_dl_dt_dd
    parser = WikiThat::Parser.new("; ABC\n: DEF", 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:dl, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:dt, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].value)
    assert_equal(:dd, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].type)
    assert_equal(' DEF', parser.result.children[0].children[1].children[0].value)
  end

  def test_dl_dn_dt
    parser = WikiThat::Parser.new(": ABC\n; DEF", 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:dl, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:dd, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].value)
    assert_equal(:dt, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[1].children[0].type)
    assert_equal(' DEF', parser.result.children[0].children[1].children[0].value)
  end


  def test_ol_dl_dt_dn
    parser = WikiThat::Parser.new("#; ABC\n#: DEF", 'wiki', 'BOB', 'sub/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:ol, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:li, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:dl, parser.result.children[0].children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].children[0].children.length)
    assert_equal(:dt, parser.result.children[0].children[0].children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[0].children[0].type)
    assert_equal(' ABC', parser.result.children[0].children[0].children[0].children[0].children[0].value)
    assert_equal(:dd, parser.result.children[0].children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].children[1].children[0].type)
    assert_equal(' DEF', parser.result.children[0].children[0].children[0].children[1].children[0].value)
  end

end