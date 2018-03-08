##
# Copyright 2017-2018 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##
require 'test/unit'
require_relative('../../../lib/wiki-that')
class HeaderGenTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('', gen.result)
  end

  def test_short
    start = '= Incomplete Header ='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>= Incomplete Header =</p>', gen.result)
  end

  def test_incomplete
    start = '== Incomplete Header'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('== Incomplete Header', gen.result)
  end

  def test_incomplete2
    start = '== Incomplete Header ='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('== Incomplete Header =', gen.result)
  end

  def test_h2
    start = '== Complete Header =='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_equal('<h2 id="Complete_Header"> Complete Header </h2>', gen.result)
  end

  def test_h2_unbalanced_right
    start = '== Complete Header ==='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<h2 id="Complete_Header"> Complete Header </h2>', gen.result)
  end

  def test_h2_unbalanced_left
    start = '=== Complete Header =='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<h2 id="Complete_Header"> Complete Header </h2>', gen.result)
  end

  def test_h2_trailing_whitespace
    start = '== Complete Header ==     '
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<h2 id="Complete_Header"> Complete Header </h2>', gen.result)
  end

  def test_h2_trailing_text
    start = '== Complete Header ==text'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_false(gen.success?, 'Generation should have failed')
    assert_equal('', gen.result)
  end

  def test_h2_trailing_link
    start = '== Complete Header ==[http://example.com]'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    #assert_false(gen.success?, 'Generation should have failed')
    assert_equal('', gen.result)
  end

  def test_h2_trailing_multiple
    start = '== Complete Header ==[http://example.com] text'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_false(gen.success?, 'Generation should have failed')
    assert_equal('', gen.result)
  end

  def test_h3
    start = '=== Complete Header ==='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<h3 id="Complete_Header"> Complete Header </h3>', gen.result)
  end

  def test_h4
    start = '==== Complete Header ===='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<h4 id="Complete_Header"> Complete Header </h4>', gen.result)
  end

  def test_h5
    start = '===== Complete Header ====='
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<h5 id="Complete_Header"> Complete Header </h5>', gen.result)
  end

  def test_h6
    start = '====== Complete Header ======'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_equal('<h6 id="Complete_Header"> Complete Header </h6>', gen.result)
  end
end
