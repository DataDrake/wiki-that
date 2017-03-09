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
require_relative('../../../../lib/wiki-that/parser/parser')
class LinkTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('',parser.result,'Nothing should have been generated')
  end

  def test_external_unbalanced
    parser = WikiThat::Parser.new('[','wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal('[',parser.result,'Empty link should have been generated')
  end

  def test_external_empty
    parser = WikiThat::Parser.new('[]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'\'></a>',parser.result,'Empty link should have been generated')
  end

  def test_external_incomplete
    start = '[http://example.com|Hello'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'Valid link should not have been generated')
  end

  def test_external
    parser = WikiThat::Parser.new('[http://example.com]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'http://example.com\'></a>',parser.result,'Valid link should have been generated')
  end

  def test_external_inline
    parser = WikiThat::Parser.new('Go Here: [http://example.com]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p>Go Here: <a href=\'http://example.com\'></a></p>',parser.result,'Valid link should have been generated')
  end

  def test_external_inline2
    parser = WikiThat::Parser.new('[http://example.com] <-- Follow','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'http://example.com\'></a><p> <-- Follow</p>',parser.result,'Valid link should have been generated')
  end

  def test_external_alt
    parser = WikiThat::Parser.new('[http://example.com|Example]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'http://example.com\'>Example</a>',parser.result,'Valid link should have been generated')
  end

  def test_internal_incomplete
    parser = WikiThat::Parser.new('[[','wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal('[[',parser.result,'Link should not have been generated')
  end

  def test_internal_incomplete2
    parser = WikiThat::Parser.new('[[]','wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal('[[]',parser.result,'Link should not have been generated')
  end

  def test_internal_empty
    parser = WikiThat::Parser.new('[[]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'wiki/BOB/sub/folder/\'></a>',parser.result,'Link should have been generated')
  end

  def test_internal_home
    parser = WikiThat::Parser.new('[[public/Home]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'wiki/BOB/sub/folder/public/Home\'></a>',parser.result,'Link should have been generated')
  end

  def test_internal_relative
    parser = WikiThat::Parser.new('[[/public/Home]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<a href=\'wiki/BOB/public/Home\'></a>',parser.result,'Link should have been generated')
  end

  def test_internal_audio
    parser = WikiThat::Parser.new('[[Audio:/public/test.wav]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<audio controls><source src=\'wiki/BOB/public/test.wav\'></audio>',parser.result,'Link should have been generated')
  end

  def test_internal_video
    parser = WikiThat::Parser.new('[[Video:/public/test.wav]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<video controls><source src=\'wiki/BOB/public/test.wav\'></video>',parser.result,'Link should have been generated')
  end

  def test_internal_image
    parser = WikiThat::Parser.new('[[Image:/public/test.png]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<img src=\'wiki/BOB/public/test.png\'>',parser.result,'Link should have been generated')
  end

  def test_internal_image_caption
    parser = WikiThat::Parser.new('[[Image:/public/test.png|Test PNG]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<div><img src=\'wiki/BOB/public/test.png\'></div>',parser.result,'Link should have been generated')
  end

  def test_internal_image_caption_incomplete1
    start = '[[Image:/public/test.png|Test PNG'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'Link should not have been generated')
  end

  def test_internal_image_caption_incomplete2
    start = "[[Image:/public/test.png|Test PNG\n"
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'Link should not have been generated')
  end

  def test_internal_image_caption_incomplete3
    start = '[[Image:/public/test.png|Test PNG] '
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_false(parser.success?,'Parsing should have failed')
    assert_equal(start,parser.result,'Link should not have been generated')
  end

  def test_internal_image_frame
    parser = WikiThat::Parser.new('[[Image:/public/test.png|frame|Test PNG]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<div class=\'frame\'><img src=\'wiki/BOB/public/test.png\'><caption>Test PNG</caption></div>',parser.result,'Link should have been generated')
  end

  def test_internal_image_thumb
    parser = WikiThat::Parser.new('[[Image:/public/test.png|thumb|Test PNG]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<div class=\'thumb\'><a href=\'wiki/BOB/public/test.png\'><img src=\'wiki/BOB/public/test.png\'></a><caption>Test PNG</caption></div>',parser.result,'Link should have been generated')
  end

  def test_internal_image_width
    parser = WikiThat::Parser.new('[[Image:/public/test.png|100px|Test PNG]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<div><img src=\'wiki/BOB/public/test.png\' width=\'100px\'></div>',parser.result,'Link should have been generated')
  end

  def test_internal_image_left
    parser = WikiThat::Parser.new('[[Image:/public/test.png|left|Test PNG]]','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<div class=\'left\'><img src=\'wiki/BOB/public/test.png\'></div>',parser.result,'Link should have been generated')
  end
end