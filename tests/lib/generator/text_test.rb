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

Here is a large selection of examples for using ''semantic markup'' to make [[About Wiki|wiki nodes]] look nice and function well.

== Basic formatting ==

This describes how to modify text to make it stand out beyond normal font styles.

{| class="center" width="100%" border="1" cellpadding="2" cellspacing="0"
|-
!What it looks like
!What you type
|-
|
You can ''italicize text'' by putting 2 
apostrophes on each side. 

3 apostrophes will bold '''the text'''. 

5 apostrophes will bold and italicize 
'''''the text'''''.

(4 apostrophes don't do anything special
 -- there's just ''''one left over''''.)
|<pre>
You can ''italicize text'' by putting 2 
apostrophes on each side. 

3 apostrophes will bold '''the text'''. 

5 apostrophes will bold and italicize 
'''''the text'''''.

(4 apostrophes don't do anything special
 -- there's just ''''one left over''''.)
</pre>
|-
|
A single newline
has no effect
on the layout.
But an empty line

starts a new paragraph.
|<pre>
A single newline
has no effect
on the layout.
But an empty line

starts a new paragraph.
</pre>
|-
|
You can break lines<br />
without a new paragraph.<br />
Please use this sparingly.
|<pre>
You can break lines<br />
without a new paragraph.<br />
Please use this sparingly.
</pre>
|-
|
Some useful ways to use HTML:

Put text in a <tt>typewriter font</tt>. The same
font is generally used for <code>computer code</code>.

Superscripts and subscripts:
X<sup>2</sup>, H<sub>2</sub>O
|<pre>
Some useful ways to use HTML:

Put text in a <tt>typewriter
font</tt>. The same font is 
generally used for <code>
computer code</code>.

Superscripts and subscripts:
X<sup>2</sup>, H<sub>2</sub>O
</pre>
|}

== Organizing your writing ==

This section disusses how to arrange and organize text to make it more readable. A full discussion of tables is not given here, but a good reference is the [[wikipedia:Help:Table|Wikipedia article on tables]].

{| class="center" width="100%" border="1" cellpadding="2" cellspacing="0"
|-
!What it looks like
!What you type
|-
|
== Section headings ==

''Headings'' organize your writing into sections.
The Wiki software can automatically generate
a table of contents from them.

=== Subsection ===

Using more equals signs creates a subsection.

==== A smaller subsection ====

Don't skip levels, 
like from two to four equals signs.

Start with 2 equals signs not 1 
because 1 creates H1 tags
which should be reserved for page title.
|<pre>
== Section headings ==

''Headings'' organize your writing into sections.
The Wiki software can automatically generate
a table of contents from them.

=== Subsection ===

Using more equals signs creates a subsection.

==== A smaller subsection ====

Don't skip levels, 
like from two to four equals signs.

Start with 2 equals signs not 1 
because 1 creates H1 tags
which should be reserved for page title.
</pre>
|-
|
* ''Unordered lists'' are easy to do:
** Start every line with a star.
*** More stars indicate a deeper level.
*: Previous item continues.
** A newline
* in a list  
marks the end of the list.
*Of course you can start again.
|<pre>
* ''Unordered lists'' are easy to do:
** Start every line with a star.
*** More stars indicate a deeper level.
*: Previous item continues.
** A newline
* in a list  
marks the end of the list.
* Of course you can start again.
</pre>
|-
|
# ''Numbered lists'' are:
## Very organized
## Easy to follow
A newline marks the end of the list.
# New numbering starts with 1.

|<pre>
# ''Numbered lists'' are also good:
## Very organized
## Easy to follow
A newline marks the end of the list.
# New numbering starts with 1.
</pre>
|-
|
Another kind of list is a ''definition list'':
; Word : Definition of the word
; Here is a longer phrase that needs a definition
: Phrase defined
; A word : Which has a definition
: Also a second one
: And even a third
|<pre>
Another kind of list is a ''definition list'':
; Word : Definition of the word
; Here is a longer phrase that needs a definition
: Phrase defined
; A word : Which has a definition
: Also a second one
: And even a third
</pre>
|-
|
* You can even do mixed lists
*# and nest them
*# inside each other
*#* or break lines<br />in lists.
*#; definition lists, however
*#: cannot be nested
|<pre>
* You can even do mixed lists
*# and nest them
*# inside each other
*#* or break lines<br />in lists.
*#; definition lists, however
*#: cannot be nested
</pre>
|-
|
: A colon (:) indents a line or paragraph.
A newline after that starts a new paragraph.
: We use 1 colon to indent once.
:: We use 2 colons to indent twice.
::: We use 3 colons to indent 3 times, and so on.
|<pre>
: A colon (:) indents a line or paragraph.
A newline after that starts a new paragraph.
: We use 1 colon to indent once.
:: We use 2 colons to indent twice.
::: We use 3 colons to indent 3 times, and so on.
</pre>
|-
|
You can make horizontal dividing lines (----)
to separate text.
----
But you should usually use sections instead,
so that they go in the table of contents.
|<pre>
You can make horizontal dividing lines (----)
to separate text.
----
But you should usually use sections instead,
so that they go in the table of contents.
</pre>
|-
|
You can add footnotes to sentences using the ''ref'' tag -- this is especially good for citing a source.

:There are over six billion people in the world.<ref>CIA World Factbook, 2006.</ref> <br />

References: <references/>
|
<pre>
You can add footnotes to sentences using the ''ref'' tag
-- this is especially good for citing a source.

:There are over six billion people in the world.
<ref>CIA World Factbook, 2006.</ref> 

References: <references/>

</pre>
|}

== Links ==

You will often want to make clickable ''links'' to other pages.

{| class="center" width="100%" border="1" cellpadding="2" cellspacing="0"
|-
!What it looks like
!What you type
|-
|
Here's a link to a page named [[About Wiki]].
|<pre>
Here's a link to a page named [[About Wiki]].
</pre>
|-
|
Links can have path information.

A leading slash "/" indicates absolute path in the
project's ''web space'', as in [[/public/Home]].

Relative paths can be created too. If you want to go
up one directory, use [[../Home]]
|<pre>
Links can have path information.

A leading slash "/" indicates absolute path in the
project's ''web space'', as in [[/public/Home]].

Relative paths can be created too. If you want to go
up one directory, use [[../Home]]
</pre>
|-
|
You can put formatting around a link.
Example: ''[[Index]]''.
|<pre>
You can put formatting around a link.
Example: ''[[Index]]''.
</pre>
|-
|
[[The weather in Moscow]] is a page that doesn't exist
yet. You could create it by clicking on the link.
|<pre>
[[The weather in Moscow]] is a page that doesn't exist
yet. You could create it by clicking on the link.
</pre>
|-
|
You can link to a page section by its title:

*[[About Subversion#Subversion Development]].

If multiple sections have the same title, add
a number. [[#Example section 3]] goes to the
third section named "Example section".
|<pre>
You can link to a page section by its title:

*[[About Subversion#Subversion Development]].

If multiple sections have the same title, add
a number. [[#Example section 3]] goes to the
third section named "Example section".
</pre>
|-
|
You can make a link point to a different place
with a "piped link". Put the link target first,
then the pipe character "|", then the link text.

*[[/public/Home|Home Node]]
*[[About Subversion#Subversion Development|SVN
development]]

Or you can use the "pipe trick" so that only the
node name is displayed.

*[[/path/to/Spinning (textiles)#Section|]]
|<pre>
You can make a link point to a different place
with a "piped link". Put the link
target first, then the pipe character "|", then
the link text.

*[[/public/Home|Home Node]]
*[[About Subversion#Subversion Development|SVN
development]]

Or you can use the "pipe trick" so that only the
node name is displayed.

*[[/path/to/Spinning (textiles)#Section|]]
</pre>
|-
|
You can make an external link just by typing a URL:
http://www.nupedia.com

You can give it a title:
[http://www.nupedia.com Nupedia]

Or leave the title blank:
[http://www.nupedia.com]
|
<pre>
You can make an external link just by typing a URL:
http://www.nupedia.com

You can give it a title:
[http://www.nupedia.com Nupedia]

Or leave the title blank:
[http://www.nupedia.com]
</pre>
|-
|
Linking to an e-mail address works the same way:
mailto:someone@domain.com or 
[mailto:someone@domain.com someone]
|
<pre>
Linking to an e-mail address works the same way:
mailto:someone@domain.com or 
[mailto:someone@domain.com someone]
</pre>
|}

== Images ==

Image linking and display are explained in [[Image Examples]].

== Citation of Sources ==

Citation is explained in-depth in [[Citation Examples]].

== Non-wiki Formatting ==

The following examples cannot have their sources shown properly because the tools used precede the <tt>pre</tt> tags used to display the markup source.
To 'fix' this, the tags used in the "What you type" column have spaces inserted after the opening left bracket (''eg.'' "<this" must be shown as "< this").

{| class="center" width="100%" border="1" cellpadding="2" cellspacing="0"
|-
!What it looks like
!What you type
|-
|
Invisible comments to editors ( <!-- here --> ) 
only appear while editing the page.
<!-- Note to editors: blah blah blah. -->
|
<pre>
Invisible comments to editors ( <!-- here --> ) 
only appear while editing the page.
<!-- Note to editors: blah blah blah. -->
</pre>
|-
* don't interpret special wiki markup
* reformat text (removing newlines and multiple spaces)
<nowiki>
text

''italics''
[[link]]
</nowiki>
|
<pre>
* don't interpret special wiki markup
* reformat text (removing newlines and multiple spaces)
<nowiki>
text

''italics''
[[link]]
</nowiki>
</pre>
|-
* don't interpret special wiki markup
* don't reformat text
<pre>
text

''italics''
[[link]]
</pre>
|
<pre>
* don't interpret special wiki markup
* don't reformat text
<pre>
text

''italics''
[[link]]
</pre>
</pre>
|}
DOC
    gen = WikiThat::HTMLGenerator.new(doc, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<p>abc</p><p>123</p>', gen.result)
  end

end