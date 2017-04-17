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
require 'awesome_print'
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
References in a wiki node should be made in the following order of decreasing precedence:
# Wikilink to current or other project
# Inter-wiki link to external materials on supported websites (more terse than a full link)
# Normal full link to external website
# Citation reference to non-web materials
# In-line description of reference, '''strongly discouraged'''

== Examples ==

Citing sources in a large document can be made easier by using the MediaWiki-style [[wikipedia:Wikipedia:Footnotes|citation format]].

These examples are taken from the above-linked page, which is more detailed than this node aspires to be.

The examples given here are simply for short reference, and not intended to be authoritative. A lot of this paragraph text is just taking up space to spread the page out.<ref>Miller, E: "The Sun.", page 23. Academic Press, 2005</ref>

Here is an example of a simple citation used in the preceding paragraph:
<pre>
<ref>Miller, E: "The Sun.", page 23. Academic Press, 2005</ref>
</pre>
Notice how the citation itself is replaced by a small symbol, and the <tt><nowiki><references/></nowiki></tt> tag below is replaced by the citation contents with cross-links.
The cross-links make checking citations simple.

Here is a full paragraph of citations:<br>
This is an example of multiple references to the same footnote.<ref name="multiple">Remember that when you refer to the same footnote multiple times, the text from the first reference is used.</ref>
Such references are particularly useful when citing sources, if different statements come from the same source.<ref name="multiple">This text is superfluous, and won't show up anywhere. We may as well just use an empty tag.</ref>
A concise way to make multiple references is to use empty ref tags, which have a slash at the end.<ref name="multiple"/>

The three preceeding citations are, respectively:<br>
* <tt><nowiki><ref name="multiple">Remember that when you refer to the same footnote multiple times, the text from the first reference is used.</ref></nowiki></tt><br>
* <tt><nowiki><ref name="multiple">This text is superfluous, and won't show up anywhere. We may as well just use an empty tag.</ref></nowiki></tt><br>
* <tt><nowiki><ref name="multiple"/></nowiki></tt><br>

== References ==

This section contains a single <tt><nowiki><references/></nowiki></tt> tag as its body:

<references/>

DOC
    gen = WikiThat::HTMLGenerator.new(doc, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    ap gen.errors
    ap gen.warnings
    puts gen.result
    assert_equal('<p>abc</p><p>123</p>', gen.result)
  end

end