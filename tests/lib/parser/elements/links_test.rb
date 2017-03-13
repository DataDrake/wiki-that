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
class LinkTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('', lexer.result, 'Nothing should have been generated')
  end

  def test_external_unbalanced
    lexer = WikiThat::Lexer.new('[', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal('[', lexer.result, 'Empty link should have been generated')
  end

  def test_external_empty
    lexer = WikiThat::Lexer.new('[]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'\'></a>', lexer.result, 'Empty link should have been generated')
  end

  def test_external_incomplete
    start = '[http://example.com|Hello'
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'Valid link should not have been generated')
  end

  def test_external
    lexer = WikiThat::Lexer.new('[http://example.com]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'http://example.com\'></a>', lexer.result, 'Valid link should have been generated')
  end

  def test_external_inline
    lexer = WikiThat::Lexer.new('Go Here: [http://example.com]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<p>Go Here: <a href=\'http://example.com\'></a></p>', lexer.result, 'Valid link should have been generated')
  end

  def test_external_inline2
    lexer = WikiThat::Lexer.new('[http://example.com] <-- Follow', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'http://example.com\'></a><p> <-- Follow</p>', lexer.result, 'Valid link should have been generated')
  end

  def test_external_alt
    lexer = WikiThat::Lexer.new('[http://example.com|Example]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'http://example.com\'>Example</a>', lexer.result, 'Valid link should have been generated')
  end

  def test_internal_incomplete
    lexer = WikiThat::Lexer.new('[[', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal('[[', lexer.result, 'Link should not have been generated')
  end

  def test_internal_incomplete2
    lexer = WikiThat::Lexer.new('[[]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal('[[]', lexer.result, 'Link should not have been generated')
  end

  def test_internal_empty
    lexer = WikiThat::Lexer.new('[[]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'wiki/BOB/sub/folder/\'></a>', lexer.result, 'Link should have been generated')
  end

  def test_internal_home
    lexer = WikiThat::Lexer.new('[[public/Home]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'wiki/BOB/sub/folder/public/Home\'></a>', lexer.result, 'Link should have been generated')
  end

  def test_internal_relative
    lexer = WikiThat::Lexer.new('[[/public/Home]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<a href=\'wiki/BOB/public/Home\'></a>', lexer.result, 'Link should have been generated')
  end

  def test_internal_audio
    lexer = WikiThat::Lexer.new('[[Audio:/public/test.wav]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<audio controls><source src=\'wiki/BOB/public/test.wav\'></audio>', lexer.result, 'Link should have been generated')
  end

  def test_internal_video
    lexer = WikiThat::Lexer.new('[[Video:/public/test.wav]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<video controls><source src=\'wiki/BOB/public/test.wav\'></video>', lexer.result, 'Link should have been generated')
  end

  def test_internal_image
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<img src=\'wiki/BOB/public/test.png\'>', lexer.result, 'Link should have been generated')
  end

  def test_internal_image_caption
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|Test PNG]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<div><img src=\'wiki/BOB/public/test.png\'></div>', lexer.result, 'Link should have been generated')
  end

  def test_internal_image_caption_incomplete1
    start = '[[Image:/public/test.png|Test PNG'
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'Link should not have been generated')
  end

  def test_internal_image_caption_incomplete2
    start = "[[Image:/public/test.png|Test PNG\n"
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'Link should not have been generated')
  end

  def test_internal_image_caption_incomplete3
    start = '[[Image:/public/test.png|Test PNG] '
    lexer = WikiThat::Lexer.new(start, 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_false(lexer.success?, 'Parsing should have failed')
    assert_equal(start, lexer.result, 'Link should not have been generated')
  end

  def test_internal_image_frame
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|frame|Test PNG]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<div class=\'frame\'><img src=\'wiki/BOB/public/test.png\'><caption>Test PNG</caption></div>', lexer.result, 'Link should have been generated')
  end

  def test_internal_image_thumb
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|thumb|Test PNG]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<div class=\'thumb\'><a href=\'wiki/BOB/public/test.png\'><img src=\'wiki/BOB/public/test.png\'></a><caption>Test PNG</caption></div>', lexer.result, 'Link should have been generated')
  end

  def test_internal_image_width
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|100px|Test PNG]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<div><img src=\'wiki/BOB/public/test.png\' width=\'100px\'></div>', lexer.result, 'Link should have been generated')
  end

  def test_internal_image_left
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|left|Test PNG]]', 'wiki', 'BOB', 'sub/folder')
    lexer.lex
    assert_true(lexer.success?, 'Parsing should have succeeded')
    assert_equal('<div class=\'left\'><img src=\'wiki/BOB/public/test.png\'></div>', lexer.result, 'Link should have been generated')
  end
end