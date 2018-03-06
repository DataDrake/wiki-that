##
# Copyright 2017-2018 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE:2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
##
require 'test/unit'
require_relative('../../../lib/wiki-that')

class ListGenTest < Test::Unit::TestCase
  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('', gen.result, 'Nothing should have been generated')
  end

  def test_ul
    gen = WikiThat::HTMLGenerator.new('*', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ul><li></li></ul>', gen.result, 'Unordered List should have been generated')
  end

  def test_ul_li
    gen = WikiThat::HTMLGenerator.new('*A', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ul><li>A</li></ul>', gen.result, 'Unordered List should have been generated')
  end

  def test_ul_li2
    gen = WikiThat::HTMLGenerator.new('* ABC', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ul><li> ABC</li></ul>', gen.result, 'Unordered List should have been generated')
  end

  def test_ol
    gen = WikiThat::HTMLGenerator.new('#', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ol><li></li></ol>', gen.result, 'Unordered List should have been generated')
  end

  def test_ol_li
    gen = WikiThat::HTMLGenerator.new('#A', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ol><li>A</li></ol>', gen.result, 'Unordered List should have been generated')
  end

  def test_ol_li2
    gen = WikiThat::HTMLGenerator.new('# ABC', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ol><li> ABC</li></ol>', gen.result, 'Unordered List should have been generated')
  end

  def test_ol_ul
    gen = WikiThat::HTMLGenerator.new('#* ABC', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ol><li><br><ul><li> ABC</li></ul></li></ol>', gen.result, 'Unordered List should have been generated')
  end

  def test_ul_ol_ul
    gen = WikiThat::HTMLGenerator.new("*# AB\n*#* ABC", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ul><li><br><ol><li> AB<ul><li> ABC</li></ul></li></ol></li></ul>', gen.result, 'Unordered List should have been generated')
  end

  def test_dl
    gen = WikiThat::HTMLGenerator.new(': ABC', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<dl><dd> ABC</dd></dl>', gen.result, 'Unordered List should have been generated')
  end

  def test_dl2
    gen = WikiThat::HTMLGenerator.new('; ABC', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<dl><dt> ABC</dt></dl>', gen.result, 'Unordered List should have been generated')
  end

  def test_dl_dt_dn
    gen = WikiThat::HTMLGenerator.new("; ABC\n: DEF", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<dl><dt> ABC</dt><dd> DEF</dd></dl>', gen.result, 'Unordered List should have been generated')
  end

  def test_dl_dn_dt
    gen = WikiThat::HTMLGenerator.new(": ABC\n; DEF", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<dl><dd> ABC</dd><dt> DEF</dt></dl>', gen.result, 'Unordered List should have been generated')
  end


  def test_ol_dl_dt_dn
    gen = WikiThat::HTMLGenerator.new("#; ABC\n#: DEF", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<ol><li><br><dl><dt> ABC</dt><dd> DEF</dd></dl></li></ol>', gen.result, 'Unordered List should have been generated')
  end

end