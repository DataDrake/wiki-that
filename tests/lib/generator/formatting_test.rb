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

class FormattingGenTest < Test::Unit::TestCase

  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('', gen.result)
  end

  def test_short
    gen = WikiThat::HTMLGenerator.new('\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>\'</p>', gen.result)
  end

  def test_short2
    gen = WikiThat::HTMLGenerator.new('\'\'thing\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>\'\'thing\'</p>', gen.result)
  end

  def test_unbalanced_right
    gen = WikiThat::HTMLGenerator.new('\'\'thing\'\'\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><i>thing</i></p>', gen.result)
  end

  def test_unbalanced_left
    gen = WikiThat::HTMLGenerator.new('\'\'\'thing\'\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><i>thing</i></p>', gen.result)
  end

  def test_italic
    gen = WikiThat::HTMLGenerator.new('\'\'italic things\'\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><i>italic things</i></p>', gen.result)
  end

  def test_italic_inline
    gen = WikiThat::HTMLGenerator.new('not \'\'italic things\'\' not', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_equal('<p>not <i>italic things</i> not</p>', gen.result)
  end

  def test_bold
    gen = WikiThat::HTMLGenerator.new('\'\'\'bold things\'\'\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><b>bold things</b></p>', gen.result)
  end

  def test_bold_inline
    gen = WikiThat::HTMLGenerator.new('not \'\'\'bold things\'\'\' not', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>not <b>bold things</b> not</p>', gen.result)
  end

  def test_both
    gen = WikiThat::HTMLGenerator.new('\'\'\'\'\'both things\'\'\'\'\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><i><b>both things</b></i></p>', gen.result)
  end

  def test_both_inline
    gen = WikiThat::HTMLGenerator.new('not \'\'\'\'\'both things\'\'\'\'\' not', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>not <i><b>both things</b></i> not</p>', gen.result)
  end

  def test_link
    gen = WikiThat::HTMLGenerator.new('\'\'[https://example.com]\'\'', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><i><a href="https://example.com"></a></i></p>', gen.result)
  end

end