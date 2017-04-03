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
A "family" is a group of closely related projects, which are all focused on a particular application. Project families are typically built around areas of common interest held by one or more faculty members in the College, regardless of what discipline or technical background they may be from. Often, a family of projects is closely aligned with a particular technology track. 

[[P07000:public/Home|P07000]], [[P08000:public/Home|P08000]], P09000 and P10000 '''Assistive Devices''' Family sponsored by the '''National Science Foundation'''.

P08020, P09020, P10020 '''Artificial Organ''' Family.

P08040, P08050, P09040, P09050, P10040-50 '''Bioengineering Fundamentals''' Family.

[[P07100:public/Home|P07100]] and [[P08100:public/Home|P08100]] '''METEOR''' Family sponsored by '''Harris Corporation'''.

P07120, P08120, P09120 '''Micro-Air Vehicle (MAV)''' Family sponsored by '''RIT MAV Club'''.

P09140, P09230, P10230 '''UAV''' Family sponsored by '''ITT Space Systems''' and '''RIT Mechanical Engineering'''.

[[P07200:public/Home|P07200]], [[P08200:public/Home|P08200]], and [[P09200:public/Home|P09200]] Modular Scalable Robotic Vehicle Platform Family sponsored by the '''Gleason Foundation''' and '''RIT Mechanical Engineering'''.

P07220, P08220, P09222, P10220 '''FSAE Autosports''' Family sponsored by '''RIT FSAE Club'''.

[[P07300:public/Home|P07300]], [[P08300:public/Home|P08300]], P09300, P10230  '''Modular Scalable Systems and Controls''' Family sponsored by '''Harris Corporation''', '''Polaris Corporation''', and '''RIT'''.

[[P07400:public/Home|P07400]] and [[P08400:public/Home|P08400]] '''Sustainable Technologies for Developing Countries''' Family sponsored by the '''Environmental Protection Agency''' and other organizations.

[[P07421:public/Home|P07420]] '''Sustainable Technologies for the RIT Campus''' sponsored by '''RIT Facilities Management'''.

[[P07440:public/Home|P07440]] and P08440 '''Next Generation Thermoelectric Systems''' Family sponsored by '''RIT Mechanical Engineering'''.

[[P08450:public/Home|P08450]], P09450, P10450 '''Sustainable Technologies for the Global Marketplace''' sponsored by '''Dresser-Rand Corporation'''.

P07500, P08500, and P09500 '''Printing Systems''' Family sponsored by '''Xerox Corporation'''.

[[P08540:public/Home|P08540]], P09560, and P09570 '''Image and Color Science''' Family sponsored by '''RIT Imaging Science'''.

[[P09700:public/Home|P09700]], P10700 '''Wegmans Process Innovation''' Family sponsored by '''Wegmans'''.



''(Within each project family, the faculty are offering several inter-related projects).
DOC
    gen = WikiThat::HTMLGenerator.new(doc, 'wiki', 'BOB', 'sub/folder', 'media/folder')
    gen.generate

    assert_equal('<p>abc</p><p>123</p>', gen.result)
  end

end