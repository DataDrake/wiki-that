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

class TextGenTest < Test::Unit::TestCase

  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('', gen.result)
  end

  def test_single
    gen = WikiThat::HTMLGenerator.new('abc', 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>abc</p>', gen.result)
  end

  def test_double
    gen = WikiThat::HTMLGenerator.new("abc\n123", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>abc&nbsp;123</p>', gen.result)
  end

  def test_double_break
    gen = WikiThat::HTMLGenerator.new("abc\n\n123", 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>abc</p><p>123</p>', gen.result)
  end

=begin
  def test_doc
    doc =<<-DOC

== Images ==

This describes how to include images in a Wiki page. 

{| class="center" width="100%" border="1" cellpadding="1" cellspacing="0"
|-
!What it looks like
!What you type
|-
|
[[Image:tiger.jpg|frame|right|50px|This is a tiger.]]
This paragraph is attached to this image. 
Do not include any blank lines.
This image is right justified.
|<pre>
[[Image:tiger.jpg|frame|right|50px|This is a tiger.]]
This paragraph is attached to this image. 
Do not include any blank lines.
This image is right justified.
</pre>
|-
!What it looks like
!What you type
|-
|
[[Image:tiger.jpg|frame|left|50px|This is a tiger.]]
This paragraph is attached to this image. 
Do not include any blank lines.
This image is left justified.
|<pre>
[[Image:tiger.jpg|frame|left|50px|This is a tiger.]]
This paragraph is attached to this image. 
Do not include any blank lines.
This image is left justified.
</pre>
|-
!What it looks like
!What you type
|-
|
[[Image:tiger.jpg|frame|center|50px|This is a tiger.]]

This paragraph is not to this image. 
This has a blank line.
This image is centered.
|<pre>
[[Image:tiger.jpg|frame|center|50px|This is a tiger.]]

This paragraph is not attached to this image. 
This has a blank line.
This image is centered.
</pre>
|}
 


[[Wiki Help|Look for more Wiki Help]]
DOC
    gen = WikiThat::HTMLGenerator.new(doc, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<p>abc</p><p>123</p>', gen.result)
  end
=end

end