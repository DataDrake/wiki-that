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
require_relative('../../../lib/wiki-that')
class TableGenTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal(0, gen.result.length)
  end

  def test_incomplete1
    start = '{'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>{</p>', gen.result)
  end

  def test_incomplete2
    start = '{|'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table></table>', gen.result)
  end

  def test_incomplete3
    start = '{| not an attribute'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table></table><p> not an attribute</p>', gen.result)
  end

  def test_incomplete4
    start = '{| a="b"'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table a="b"></table>', gen.result)
  end

  def test_incomplete5
    start = '{| a="b" c="1234&"'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table a="b" c="1234&"></table>', gen.result)
  end

  def test_incomplete6
    start = "{|\n|+"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table></table>', gen.result)
  end

  def test_incomplete7
    start = "{|\n|+this is a caption"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><caption>this is a caption</caption></table>', gen.result)
  end

  def test_incomplete8
    start = "{|\n|- these are not attributes"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p> these are not attributes</p></td></tr></table>', gen.result)
  end

  def test_incomplete9
    start = "{|\n|- a=\"b\""
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr a="b"></tr></table>', gen.result)
  end

  def test_incomplete10
    start = "{|\n|- \n"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr></tr></table>', gen.result)
  end

  def test_caption_whitespace
    start = "{|\n|+ \n"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_equal('<table><caption> </caption></table>', gen.result)
  end

  def test_incomplete11
    start = "{|\n|-\n1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p>1234</p></td></tr></table>', gen.result)
  end

  def test_incomplete12
    start = "{|\n|-\n| 1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p> 1234</p></td></tr></table>', gen.result)
  end

  def test_incomplete13
    start = "{|\n| 1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p> 1234</p></td></tr></table>', gen.result)
  end

  def test_incomplete14
    start = "{|\n|-\n| a=\"b\" | 1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td a="b"><p> 1234</p></td></tr></table>', gen.result)
  end

  def test_incomplete15
    start = "{|\n|-\n| a=\"b\" | 1234 ! bob"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td a="b"><p> 1234 </p></td><th><p> bob</p></th></tr></table>', gen.result)
  end

  def test_incomplete16
    start = "{|\n|-\n| a=\"b\" | 1234 \n|-\n! bob"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td a="b"><p> 1234 &nbsp;</p></td></tr><tr><th><p> bob</p></th></tr></table>', gen.result)
  end

  def test_incomplete17
    start = "{|\n| 1234 \nparagraph\n! bob"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p> 1234 &nbsp;paragraph&nbsp;</p></td><th><p> bob</p></th></tr></table>', gen.result)
  end

  def test_complete
    start = "{|\n| 1234 \nparagraph\n! bob\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p> 1234 &nbsp;paragraph&nbsp;</p></td><th><p> bob&nbsp;</p></th></tr></table>', gen.result)
  end

  def test_complete2
    start = "{|\n|| 1234 \nparagraph\n! bob\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><p> 1234 &nbsp;paragraph&nbsp;</p></td><th><p> bob&nbsp;</p></th></tr></table>', gen.result)
  end

  def test_nested
    start = "{|\n|-\n|\n{|\n|}\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><table></table></td></tr></table>', gen.result)
  end

  def test_nested2
    start = "{|\n|-\n|\n{|\n|-\n|\n* ABC\n|}\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><table><tr><td><ul><li> ABC</li></ul></td></tr></table></td></tr></table>', gen.result)
  end

end