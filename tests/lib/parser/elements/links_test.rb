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
class LinkParseTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(0, parser.result.children.length)
  end

  def test_external_unbalanced
    parser = WikiThat::Parser.new('[', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('[', parser.result.children[0].children[0].value)
  end

  def test_external_empty
    parser = WikiThat::Parser.new('[]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('', parser.result.children[0].children[0].attributes[:href])
  end

  def test_external_incomplete
    start  = '[http://example.com Hello'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal(start, parser.result.children[0].children[0].value)
  end

  def test_external
    parser = WikiThat::Parser.new('[http://example.com]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('http://example.com', parser.result.children[0].children[0].attributes[:href])
  end

  def test_external_space
    parser = WikiThat::Parser.new('[ http://example.com ]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('http://example.com', parser.result.children[0].children[0].attributes[:href])
  end

  def test_external_inline
    parser = WikiThat::Parser.new('Go Here: [http://example.com]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('Go Here: ', parser.result.children[0].children[0].value)
    assert_equal(:a, parser.result.children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[1].attributes.length)
    assert_equal('http://example.com', parser.result.children[0].children[1].attributes[:href])
  end

  def test_external_inline2
    parser = WikiThat::Parser.new('[http://example.com] -- Follow', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(4, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('http://example.com', parser.result.children[0].children[0].attributes[:href])
    assert_equal(:text, parser.result.children[0].children[1].type)
    assert_equal(' ', parser.result.children[0].children[1].value)
    assert_equal(:text, parser.result.children[0].children[2].type)
    assert_equal('&mdash;', parser.result.children[0].children[2].value)
    assert_equal(:text, parser.result.children[0].children[3].type)
    assert_equal(' Follow', parser.result.children[0].children[3].value)
  end

  def test_external_alt
    parser = WikiThat::Parser.new('[http://example.com Example]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('http://example.com', parser.result.children[0].children[0].attributes[:href])
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('Example', parser.result.children[0].children[0].children[0].value)
  end

  def test_internal_incomplete
    parser = WikiThat::Parser.new('[[', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('[[', parser.result.children[0].children[0].value)
  end

  def test_internal_incomplete2
    parser = WikiThat::Parser.new('[[]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('[[]', parser.result.children[0].children[0].value)
  end

  def test_internal_empty
    parser = WikiThat::Parser.new('[[]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/sub/folder/', parser.result.children[0].children[0].attributes[:href])
  end

  def test_internal_home
    parser = WikiThat::Parser.new('[[public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/sub/folder/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_internal_page
    parser = WikiThat::Parser.new('[[Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/sub/folder/Home', parser.result.children[0].children[0].attributes[:href])
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('Home', parser.result.children[0].children[0].children[0].value)
  end

  def test_internal_no_base_url
    parser = WikiThat::Parser.new('[[public/Home]]', nil , 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/BOB/sub/folder/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_internal_no_sub_url
    parser = WikiThat::Parser.new('[[public/Home]]', 'wiki' , 'BOB', '', '')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_internal_no_namespace
    parser = WikiThat::Parser.new('[[public/Home]]', 'wiki' , '', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/sub/folder/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_internal_space
    parser = WikiThat::Parser.new('[[ public/Home ]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/sub/folder/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_internal_relative
    parser = WikiThat::Parser.new('[[/public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_interwiki
    parser = WikiThat::Parser.new('[[Test123:public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/Test123/sub/folder/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_interwiki_space
    parser = WikiThat::Parser.new('[[ Test123 : public/Home ]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/Test123/sub/folder/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_interwiki_relative
    parser = WikiThat::Parser.new('[[Test123:/public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/Test123/public/Home', parser.result.children[0].children[0].attributes[:href])
  end

  def test_interwiki_named
    parser = WikiThat::Parser.new('[[Test123:/public/Home|Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/Test123/public/Home', parser.result.children[0].children[0].attributes[:href])
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('Home', parser.result.children[0].children[0].children[0].value)
  end

  def test_interwiki_named_space
    parser = WikiThat::Parser.new('[[ Test123 : /public/Home | Home ]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/Test123/public/Home', parser.result.children[0].children[0].attributes[:href])
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[0].type)
    assert_equal('Home', parser.result.children[0].children[0].children[0].value)
  end

  def test_internal_audio
    parser = WikiThat::Parser.new('[[Audio:/public/test.wav]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:audio, parser.result.children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].attributes.length)
    assert_equal(true, parser.result.children[0].children[0].attributes[:controls])
    assert_equal('/media/folder/BOB/public/test.wav', parser.result.children[0].children[0].attributes[:src])
  end

  def test_internal_video
    parser = WikiThat::Parser.new('[[Video:/public/test.mp4]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:video, parser.result.children[0].children[0].type)
    assert_equal(2, parser.result.children[0].children[0].attributes.length)
    assert_equal(true, parser.result.children[0].children[0].attributes[:controls])
    assert_equal('/media/folder/BOB/public/test.mp4', parser.result.children[0].children[0].attributes[:src])
  end

  def test_internal_image
    parser = WikiThat::Parser.new('[[Image:/public/test.png]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:img, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/media/folder/BOB/public/test.png', parser.result.children[0].children[0].attributes[:src])
  end

  def test_internal_image_caption
    parser = WikiThat::Parser.new('[[Image:/public/test.png|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:img, parser.result.children[0].children[0].type)
    assert_equal('/media/folder/BOB/public/test.png', parser.result.children[0].children[0].attributes[:src])
    assert_equal('Test PNG', parser.result.children[0].children[0].attributes[:alt])
  end

  def test_internal_image_caption_incomplete1
    start  = '[[Image:/public/test.png|Test PNG'
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('[[Image:/public/test.png|Test PNG', parser.result.children[0].children[0].value)
  end

  def test_internal_image_caption_incomplete2
    start  = "[[Image:/public/test.png|Test PNG\n"
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('[[Image:/public/test.png|Test PNG', parser.result.children[0].children[0].value)
    assert_equal(:text, parser.result.children[0].children[1].type)
    assert_equal('&nbsp;', parser.result.children[0].children[1].value)
  end

  def test_internal_image_caption_incomplete3
    start  = '[[Image:/public/test.png|Test PNG] '
    parser = WikiThat::Parser.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(2, parser.result.children[0].children.length)
    assert_equal(:text, parser.result.children[0].children[0].type)
    assert_equal('[[Image:/public/test.png|Test PNG]', parser.result.children[0].children[0].value)
    assert_equal(:text, parser.result.children[0].children[1].type)
    assert_equal(' ', parser.result.children[0].children[1].value)
  end

  def test_internal_image_frame
    parser = WikiThat::Parser.new('[[Image:/public/test.png|frame|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:figure, parser.result.children[0].children[0].type)
    assert_equal('frame', parser.result.children[0].children[0].attributes[:class])
    assert_equal(2, parser.result.children[0].children[0].children.length)
    assert_equal(:img, parser.result.children[0].children[0].children[0].type)
    assert_equal('/media/folder/BOB/public/test.png', parser.result.children[0].children[0].children[0].attributes[:src])
    assert_equal('Test PNG', parser.result.children[0].children[0].children[0].attributes[:alt])
    assert_equal(:figcaption, parser.result.children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[1].children[0].type)
    assert_equal('Test PNG', parser.result.children[0].children[0].children[1].children[0].value)
  end

  def test_internal_image_thumb
    parser = WikiThat::Parser.new('[[Image:/public/test.png|thumb|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:figure, parser.result.children[0].children[0].type)
    assert_equal('thumb', parser.result.children[0].children[0].attributes[:class])
    assert_equal(2, parser.result.children[0].children[0].children.length)
    assert_equal(:img, parser.result.children[0].children[0].children[0].type)
    assert_equal('/media/folder/BOB/public/test.png', parser.result.children[0].children[0].children[0].attributes[:src])
    assert_equal('Test PNG', parser.result.children[0].children[0].children[0].attributes[:alt])
    assert_equal(:figcaption, parser.result.children[0].children[0].children[1].type)
    assert_equal(1, parser.result.children[0].children[0].children[1].children.length)
    assert_equal(:text, parser.result.children[0].children[0].children[1].children[0].type)
    assert_equal('Test PNG', parser.result.children[0].children[0].children[1].children[0].value)
  end

  def test_internal_image_width
    parser = WikiThat::Parser.new('[[Image:/public/test.png|100px|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:img, parser.result.children[0].children[0].type)
    assert_equal('/media/folder/BOB/public/test.png', parser.result.children[0].children[0].attributes[:src])
    assert_equal('100', parser.result.children[0].children[0].attributes[:width])
    assert_equal('Test PNG', parser.result.children[0].children[0].attributes[:alt])
  end

  def test_internal_image_left
    parser = WikiThat::Parser.new('[[Image:/public/test.png|left|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:figure, parser.result.children[0].children[0].type)
    assert_equal('left', parser.result.children[0].children[0].attributes[:class])
    assert_equal(1, parser.result.children[0].children[0].children.length)
    assert_equal(:img, parser.result.children[0].children[0].children[0].type)
    assert_equal('/media/folder/BOB/public/test.png', parser.result.children[0].children[0].children[0].attributes[:src])
    assert_equal('Test PNG', parser.result.children[0].children[0].children[0].attributes[:alt])
  end

  def test_internal_header
    parser = WikiThat::Parser.new('[[#Bob 1234]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('#Bob_1234', parser.result.children[0].children[0].attributes[:href])
  end

  def test_hyphenated
    parser = WikiThat::Parser.new('[[Bob-1234]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    parser.parse
    assert_true(parser.success?, 'Parsing should have succeeded')
    assert_equal(1, parser.result.children.length)
    assert_equal(:p, parser.result.children[0].type)
    assert_equal(1, parser.result.children[0].children.length)
    assert_equal(:a, parser.result.children[0].children[0].type)
    assert_equal(1, parser.result.children[0].children[0].attributes.length)
    assert_equal('/wiki/BOB/sub/folder/Bob-1234', parser.result.children[0].children[0].attributes[:href])
    assert_equal('Bob-1234', parser.result.children[0].children[0].children[0].value)
  end
end