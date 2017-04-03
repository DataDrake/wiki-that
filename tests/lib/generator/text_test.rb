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

  def test_doc
    doc =<<-DOC

__TOC__

== Hello World ==

This page was created using the code shown below. 
It begins with a table of contents and a top level heading. 
Headings within the page start at the second level (two equal signs). 
First level headings are reserved for the EDGE site itself, 
to make it have a common look and feel for all users.
===Subheading 1===
Subheadings can be included to a number of levels, 
simply by encapsulating the text of each sub heading 
within equal signs. As you increase the number of equal signs, 
you make the headings smaller and smaller.

Start a new paragraph by leaving a blank line.
===Subheading 2===
For example, check out this fourth level heading.

{| class="wikitable"
|+ '''Hello World Table'''
! Heading 1 
! Heading 2  
|-
|Row 1 Col 1
|Row 1 Col 2 
|-
|Row 2 Col 1
|Row 2 Col 2 
|}

====Sub-subheading====

And now, the excitement builds with fifth level headings!
[[Image:conceptdiagram.jpg|frame|center|50px|This is a tiger.]]

This paragraph is not attached to this image. 
This has a blank line.
This image is centered.

====sub-sub-subheading====
The fun never stops!
====sub-sub-subheading====
;Terms
:Can be conveniently defined in this manner.
== Good bye World==
Another heading can be included at any point in the page.
DOC
    gen = WikiThat::HTMLGenerator.new(doc, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<p>abc</p><p>123</p>', gen.result)
  end

end