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
class LinkLexTest < Test::Unit::TestCase

  def test_empty
    lexer = WikiThat::Lexer.new('')
    lexer.lex
    assert_equal(0, lexer.result.length)
  end

  def test_external_unbalanced
    lexer = WikiThat::Lexer.new('[')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
  end

  def test_external_empty
    lexer = WikiThat::Lexer.new('[]')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:link_end, lexer.result[1].type)
    assert_equal(1, lexer.result[1].value)
  end

  def test_external_incomplete
    start = '[http://example.com|Hello'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(6, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('http', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('//example.com', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('Hello', lexer.result[5].value)
  end

  def test_external
    lexer = WikiThat::Lexer.new('[http://example.com]')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('http', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('//example.com', lexer.result[3].value)
    assert_equal(:link_end, lexer.result[4].type)
    assert_equal(1, lexer.result[4].value)
  end

  def test_external_inline
    lexer = WikiThat::Lexer.new('Go Here: [http://example.com]')
    lexer.lex
    assert_equal(6, lexer.result.length)
    assert_equal(:text, lexer.result[0].type)
    assert_equal('Go Here: ', lexer.result[0].value)
    assert_equal(:link_start, lexer.result[1].type)
    assert_equal(1, lexer.result[1].value)
    assert_equal(:text, lexer.result[2].type)
    assert_equal('http', lexer.result[2].value)
    assert_equal(:link_namespace, lexer.result[3].type)
    assert_equal('', lexer.result[3].value)
    assert_equal(:text, lexer.result[4].type)
    assert_equal('//example.com', lexer.result[4].value)
    assert_equal(:link_end, lexer.result[5].type)
    assert_equal(1, lexer.result[5].value)
  end

  def test_external_inline2
    lexer = WikiThat::Lexer.new('[http://example.com] <-- Follow')
    lexer.lex
    assert_equal(6, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('http', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('//example.com', lexer.result[3].value)
    assert_equal(:link_end, lexer.result[4].type)
    assert_equal(1, lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal(' <-- Follow', lexer.result[5].value)
  end

  def test_external_alt
    lexer = WikiThat::Lexer.new('[http://example.com|Example]')
    lexer.lex
    assert_equal(7, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(1, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('http', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('//example.com', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('Example', lexer.result[5].value)
    assert_equal(:link_end, lexer.result[6].type)
    assert_equal(1, lexer.result[6].value)
  end

  def test_internal_incomplete
    lexer = WikiThat::Lexer.new('[[')
    lexer.lex
    assert_equal(1, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
  end

  def test_internal_incomplete2
    lexer = WikiThat::Lexer.new('[[]')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:link_end, lexer.result[1].type)
    assert_equal(1, lexer.result[1].value)
  end

  def test_internal_empty
    lexer = WikiThat::Lexer.new('[[]]')
    lexer.lex
    assert_equal(2, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:link_end, lexer.result[1].type)
    assert_equal(2, lexer.result[1].value)
  end

  def test_internal_home
    lexer = WikiThat::Lexer.new('[[public/Home]]')
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('public/Home', lexer.result[1].value)
    assert_equal(:link_end, lexer.result[2].type)
    assert_equal(2, lexer.result[2].value)
  end

  def test_internal_relative
    lexer = WikiThat::Lexer.new('[[/public/Home]]')
    lexer.lex
    assert_equal(3, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('/public/Home', lexer.result[1].value)
    assert_equal(:link_end, lexer.result[2].type)
    assert_equal(2, lexer.result[2].value)
  end

  def test_internal_audio
    lexer = WikiThat::Lexer.new('[[Audio:/public/test.wav]]')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Audio', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.wav', lexer.result[3].value)
    assert_equal(:link_end, lexer.result[4].type)
    assert_equal(2, lexer.result[4].value)
  end

  def test_internal_video
    lexer = WikiThat::Lexer.new('[[Video:/public/test.wav]]')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Video', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.wav', lexer.result[3].value)
    assert_equal(:link_end, lexer.result[4].type)
    assert_equal(2, lexer.result[4].value)
  end

  def test_internal_image
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png]]')
    lexer.lex
    assert_equal(5, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_end, lexer.result[4].type)
    assert_equal(2, lexer.result[4].value)
  end

  def test_internal_image_caption
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|Test PNG]]')
    lexer.lex
    assert_equal(7, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('Test PNG', lexer.result[5].value)
    assert_equal(:link_end, lexer.result[6].type)
    assert_equal(2, lexer.result[6].value)
  end

  def test_internal_image_caption_incomplete1
    start = '[[Image:/public/test.png|Test PNG'
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(6, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('Test PNG', lexer.result[5].value)
  end

  def test_internal_image_caption_incomplete2
    start = "[[Image:/public/test.png|Test PNG\n"
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(6, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('Test PNG', lexer.result[5].value)
  end

  def test_internal_image_caption_incomplete3
    start = '[[Image:/public/test.png|Test PNG] '
    lexer = WikiThat::Lexer.new(start)
    lexer.lex
    assert_equal(8, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('Test PNG', lexer.result[5].value)
    assert_equal(:link_end, lexer.result[6].type)
    assert_equal(1, lexer.result[6].value)
    assert_equal(:text, lexer.result[7].type)
    assert_equal(' ', lexer.result[7].value)
  end

  def test_internal_image_frame
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|frame|Test PNG]]')
    lexer.lex
    assert_equal(9, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('frame', lexer.result[5].value)
    assert_equal(:link_attribute, lexer.result[6].type)
    assert_equal('', lexer.result[6].value)
    assert_equal(:text, lexer.result[7].type)
    assert_equal('Test PNG', lexer.result[7].value)
    assert_equal(:link_end, lexer.result[8].type)
    assert_equal(2, lexer.result[8].value)
  end

  def test_internal_image_thumb
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|thumb|Test PNG]]')
    lexer.lex
    assert_equal(9, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('thumb', lexer.result[5].value)
    assert_equal(:link_attribute, lexer.result[6].type)
    assert_equal('', lexer.result[6].value)
    assert_equal(:text, lexer.result[7].type)
    assert_equal('Test PNG', lexer.result[7].value)
    assert_equal(:link_end, lexer.result[8].type)
    assert_equal(2, lexer.result[8].value)
  end

  def test_internal_image_width
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|100px|Test PNG]]')
    lexer.lex
    assert_equal(9, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('100px', lexer.result[5].value)
    assert_equal(:link_attribute, lexer.result[6].type)
    assert_equal('', lexer.result[6].value)
    assert_equal(:text, lexer.result[7].type)
    assert_equal('Test PNG', lexer.result[7].value)
    assert_equal(:link_end, lexer.result[8].type)
    assert_equal(2, lexer.result[8].value)
  end

  def test_internal_image_left
    lexer = WikiThat::Lexer.new('[[Image:/public/test.png|left|Test PNG]]')
    lexer.lex
    assert_equal(9, lexer.result.length)
    assert_equal(:link_start, lexer.result[0].type)
    assert_equal(2, lexer.result[0].value)
    assert_equal(:text, lexer.result[1].type)
    assert_equal('Image', lexer.result[1].value)
    assert_equal(:link_namespace, lexer.result[2].type)
    assert_equal('', lexer.result[2].value)
    assert_equal(:text, lexer.result[3].type)
    assert_equal('/public/test.png', lexer.result[3].value)
    assert_equal(:link_attribute, lexer.result[4].type)
    assert_equal('', lexer.result[4].value)
    assert_equal(:text, lexer.result[5].type)
    assert_equal('left', lexer.result[5].value)
    assert_equal(:link_attribute, lexer.result[6].type)
    assert_equal('', lexer.result[6].value)
    assert_equal(:text, lexer.result[7].type)
    assert_equal('Test PNG', lexer.result[7].value)
    assert_equal(:link_end, lexer.result[8].type)
    assert_equal(2, lexer.result[8].value)
  end
end