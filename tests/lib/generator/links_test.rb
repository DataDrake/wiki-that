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
class LinkGenTest < Test::Unit::TestCase

  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('', gen.result)
  end

  def test_external_unbalanced
    gen = WikiThat::HTMLGenerator.new('[', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[</p>', gen.result)
  end

  def test_external_empty
    gen = WikiThat::HTMLGenerator.new('[]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href=""></a></p>', gen.result)
  end

  def test_external_incomplete
    start = '[http://example.com Hello'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[http://example.com Hello</p>', gen.result)
  end

  def test_external
    gen = WikiThat::HTMLGenerator.new('[http://example.com]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="http://example.com"></a></p>', gen.result)
  end

  def test_external_inline
    gen = WikiThat::HTMLGenerator.new('Go Here: [http://example.com]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>Go Here: <a href="http://example.com"></a></p>', gen.result)
  end

  def test_external_inline2
    gen = WikiThat::HTMLGenerator.new('[http://example.com] -- Follow', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="http://example.com"></a> &mdash; Follow</p>', gen.result)
  end

  def test_external_alt
    gen = WikiThat::HTMLGenerator.new('[http://example.com Example]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="http://example.com">Example</a></p>', gen.result)
  end

  def test_external_long_alt
    gen = WikiThat::HTMLGenerator.new('[http://example.com Example Link]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="http://example.com">Example Link</a></p>', gen.result)
  end

  def test_internal_incomplete
    gen = WikiThat::HTMLGenerator.new('[[', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[[</p>', gen.result)
  end

  def test_internal_incomplete2
    gen = WikiThat::HTMLGenerator.new('[[]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[[]</p>', gen.result)
  end

  def test_internal_empty
    gen = WikiThat::HTMLGenerator.new('[[]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/BOB/sub/folder/">/wiki/BOB/sub/folder/</a></p>', gen.result)
  end

  def test_internal_external
    gen = WikiThat::HTMLGenerator.new('[[http://example.com]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/http//example.com">/wiki/http//example.com</a></p>', gen.result)
  end

  def test_internal_relative
    gen = WikiThat::HTMLGenerator.new('[[public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/BOB/sub/folder/public/Home">/wiki/BOB/sub/folder/public/Home</a></p>', gen.result)
  end

  def test_internal_absolute
    gen = WikiThat::HTMLGenerator.new('[[/public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/BOB/public/Home">/wiki/BOB/public/Home</a></p>', gen.result)
  end

  def test_internal_absolute_named
    gen = WikiThat::HTMLGenerator.new('[[/public/Home|Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/BOB/public/Home">Home</a></p>', gen.result)
  end

  def test_interwiki
    gen = WikiThat::HTMLGenerator.new('[[Test123:public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/Test123/sub/folder/public/Home">/wiki/Test123/sub/folder/public/Home</a></p>', gen.result)
  end

  def test_interwiki_relative
    gen = WikiThat::HTMLGenerator.new('[[Test123:/public/Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/Test123/public/Home">/wiki/Test123/public/Home</a></p>', gen.result)
  end

  def test_interwiki_named
    gen = WikiThat::HTMLGenerator.new('[[Test123:/public/Home|Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/Test123/public/Home">Home</a></p>', gen.result)
  end

  def test_interwiki_extra_attributes
    gen = WikiThat::HTMLGenerator.new('[[Test123:/public/Home|center|Home]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><a href="/wiki/Test123/public/Home">Home</a></p>', gen.result)
  end

  def test_internal_audio
    gen = WikiThat::HTMLGenerator.new('[[Audio:/public/test.wav]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><audio src="/media/folder/BOB/public/test.wav" controls></audio></p>', gen.result)
  end

  def test_internal_audio_extra_attributes
    gen = WikiThat::HTMLGenerator.new('[[Audio:/public/test.wav|Test]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><audio src="/media/folder/BOB/public/test.wav" controls></audio></p>', gen.result)
  end

  def test_interwiki_audio
    gen = WikiThat::HTMLGenerator.new('[[Audio:Test123:/public/test.wav]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><audio src="/media/folder/Test123/public/test.wav" controls></audio></p>', gen.result)
  end

  def test_extra_namespace
    gen = WikiThat::HTMLGenerator.new('[[Audio:Test123:Bob:/public/test.wav]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><audio src="/media/folder/Test123/public/test.wav" controls></audio></p>', gen.result)
  end

  def test_internal_video
    gen = WikiThat::HTMLGenerator.new('[[Video:/public/test.mp4]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><video src="/media/folder/BOB/public/test.mp4" controls></video></p>', gen.result)
  end

  def test_internal_video_extra_attributes
    gen = WikiThat::HTMLGenerator.new('[[Video:/public/test.mp4|Test]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><video src="/media/folder/BOB/public/test.mp4" controls></video></p>', gen.result)
  end

  def test_internal_image
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><img src="/media/folder/BOB/public/test.png" /></p>', gen.result)
  end

  def test_internal_image_alt
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><img src="/media/folder/BOB/public/test.png" alt="Test PNG" /></p>', gen.result)
  end

  def test_internal_image_caption_incomplete1
    start = '[[Image:/public/test.png|Test PNG'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[[Image:/public/test.png|Test PNG</p>', gen.result)
  end

  def test_internal_image_caption_incomplete2
    start = "[[Image:/public/test.png|Test PNG\n"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[[Image:/public/test.png|Test PNG&nbsp;</p>', gen.result)
  end

  def test_internal_image_caption_incomplete3
    start = '[[Image:/public/test.png|Test PNG]'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>[[Image:/public/test.png|Test PNG]</p>', gen.result)
  end

  def test_internal_image_frame
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png|frame|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><div class="frame"><img src="/media/folder/BOB/public/test.png" alt="Test PNG" /><caption>Test PNG</caption></div></p>', gen.result)
  end

  def test_internal_image_thumb
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png|thumb|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><div class="thumb"><img src="/media/folder/BOB/public/test.png" alt="Test PNG" /><caption>Test PNG</caption></div></p>', gen.result)
  end

  def test_internal_image_width
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png|100px|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><img src="/media/folder/BOB/public/test.png" width="100" alt="Test PNG" /></p>', gen.result)
  end

  def test_internal_image_width2
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png|100px]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><img src="/media/folder/BOB/public/test.png" width="100" /></p>', gen.result)
  end

  def test_internal_image_left
    gen = WikiThat::HTMLGenerator.new('[[Image:/public/test.png|left|Test PNG]]', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p><div class="left"><img src="/media/folder/BOB/public/test.png" alt="Test PNG" /></div></p>', gen.result)
  end
end