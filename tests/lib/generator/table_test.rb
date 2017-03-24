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
class TableGenTest < Test::Unit::TestCase
  # Fake test
  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal(0, gen.result.length)
  end

  def test_incomplete1
    start = '{'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<p>{</p>', gen.result)
  end

  def test_incomplete2
    start = '{|'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table></table>', gen.result)
  end

  def test_incomplete3
    start = '{| not an attribute'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table></table><p> not an attribute</p>', gen.result)
  end

  def test_incomplete4
    start = '{| a="b"'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table a="b"></table>', gen.result)
  end

  def test_incomplete5
    start = '{| a="b" c="1234&"'
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table a="b" c="1234&"></table>', gen.result)
  end

  def test_incomplete6
    start = "{|\n|+"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table></table>', gen.result)
  end

  def test_incomplete7
    start = "{|\n|+this is a caption"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><caption>this is a caption</caption></table>', gen.result)
  end

  def test_incomplete8
    start = "{|\n|- these are not attributes"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr></tr></table><p> these are not attributes</p>', gen.result)
  end

  def test_incomplete9
    start = "{|\n|- a=\"b\""
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr a="b"></tr></table>', gen.result)
  end

  def test_incomplete10
    start = "{|\n|- \n"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr></tr></table>', gen.result)
  end

  def test_caption_whitespace
    start = "{|\n|+ \n"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_equal('<table></table>', gen.result)
  end

  def test_incomplete11
    start = "{|\n|-\n1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr></tr></table><p>1234</p>', gen.result)
  end

  def test_incomplete12
    start = "{|\n|-\n| 1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td> 1234</td></tr></table>', gen.result)
  end

  def test_incomplete13
    start = "{|\n| 1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td> 1234</td></tr></table>', gen.result)
  end

  def test_incomplete14
    start = "{|\n|-\n| a=\"b\" | 1234"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td a="b"> 1234</td></tr></table>', gen.result)
  end

  def test_incomplete15
    start = "{|\n|-\n| a=\"b\" | 1234 ! bob"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td a="b"> 1234 </td><th> bob</th></tr></table>', gen.result)
  end

  def test_incomplete16
    start = "{|\n|-\n| a=\"b\" | 1234 \n|-\n! bob"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td a="b"> 1234 </td></tr><tr><th> bob</th></tr></table>', gen.result)
  end

  def test_incomplete17
    start = "{|\n| 1234 \nparagraph\n! bob"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td> 1234 <p>paragraph&nbsp;</p></td><th> bob</th></tr></table>', gen.result)
  end

  def test_complete
    start = "{|\n| 1234 \nparagraph\n! bob\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td> 1234 <p>paragraph&nbsp;</p></td><th> bob</th></tr></table>', gen.result)
  end

  def test_complete2
    start = "{|\n|| 1234 \nparagraph\n! bob\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td> 1234 <p>paragraph&nbsp;</p></td><th> bob</th></tr></table>', gen.result)
  end

  def test_nested
    start = "{|\n|-\n|\n{|\n|}\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><table></table></td></tr></table>', gen.result)
  end

  def test_nested2
    start = "{|\n|-\n|\n{|\n|-\n|\n* ABC\n|}\n|}"
    gen   = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<table><tr><td><table><tr><td><ul><li> ABC</li></ul></td></tr></table></td></tr></table>', gen.result)
  end


  def test_doc
    start = <<-DOC
[[Image:public/banner.jpg|634px]]

RIT engineering faculty are active in many research areas. Research takes place across engineering disciplines and often involves other colleges at RIT, local health care institutions, and major industry partners.

Externally sponsored projects are a vital and integral component of RIT's educational and research activity. Faculty and students undertake sponsored projects for a variety of important reasons: to add to the body of knowledge, for professional development, and to strengthen academic programs. Sponsored projects enhance the Institute's academic programs, broaden its research resources, provide opportunities for student participation in research, strengthen university-industrial partnerships, and serve the wider community.

RIT's major public sponsors include the National Science Foundation (NSF), the National Institutes of Health (NIH), the Department of Education (USDE), the Department of Defense (DOD), the National Aeronautics and Science Administration (NASA), and New York State.

== Disciplinary Backgrounds  ==

All of the existing degree programs in the KGCOE contribute to the solution of problems across a variety of application domains, and employ a wide range of technological tools in the process. Students may conduct research in a wide range of academic disciplines, and at both undergraduate and graduate level across the KGCOE:

* Biomedical engineering (BS, PhD)
* Chemical engineering (BS, PhD)
* Computer engineering  (BS, MEng, MS, PhD)
* Electrical and Microelectronic engineering (BS, MEng, MS, PhD)
* Industrial and Systems engineering (BS, MEng, MS, PhD)
* Mechanical engineering (BS, MEng, MS, PhD)
* Microsystems engineering (PhD)

Whatever engineering discipline you may come from, we have a path for your research! The list of Technology Domains presented below provides you with some sense of the breadth of technological tools that our faculty and students use. And, the list of Application Domains illustrates the variety of societal needs that our research seeks to address.

== Technology Domains ==

The technology domains describe WHAT technical tools we bring to bear to address societal needs. If you are interested in a particular technology, the chances are high that some of our faculty are applying these tools across one or more of the application domains listed below.

; Nano-Science & Engineering
: Micro and Nano-electronics
: Semiconductor Devices
: Carbon nano-tubes for energy &gas storage
: Carbon nano-tubes for energy transmission
: Nano-material separation and characterization

; Signal & Image Processing
: Real Time Vision & Image Processing
: Biomedical Signal & Image Analysis
: Wireless Communication & Sensor Systems
: Radio Frequency technology

; Manufacturing & Materials
: Direct Print Electronics
: 3D printing, additive manufacturing and advanced manufacturing
: Nano-materials Development
: Biomaterials Technology

; Robotics & Mechatronics
: Compliant Robotics
: Hardware In the Loop Control Modeling
: Autonomous Vehicles, Devices & Systems
: Multi-agent systems & swarm Intelligence

; Simulation, Modeling & Optimization
: High Performance Computing
: Deterministic & Stochastic Modeling
: Operations Research & Logistics
: Big Data, Analytics & Industrial Statistics
: Operations Management

; Heat Transfer & Thermo-Fluids
: Thermal Analysis & Micro-fluidics
: Water treatment & Purification
: Particle Imaging & Velocimetry
: Roll to Roll Coating

; Performance and Power-Aware Computing
: Bio-inspired computing
: Chip multiprocessors
: Low power circuits and architectures

; Safety & Security
: Resilient and Secure Systems
:  (Hardware, Software and Networks)
: Fault Analysis and Diagnosis
: Physical Security and Safety
: Cryptographic Engineering

; Access & Assistive Technologies
: Universal  Access Technologies
: Artificial Organs, Joints and Limbs
: Human Performance

== Application Domains ==

The application domains describe the societal problem sets that we focus our research efforts on -- WHY we conduct our research.

Engineers solve problems -- and we have developed a particular focus on addressing both fundamental and applied research problems of global importance for the 21st Century, centered on four key industries: Transportation, Energy, Communications and Healthcare (T/E/C/H). Global challenges in T/E/C/H impact every individual on the planet and demand highly trained engineers with deep disciplinary skills and a thorough contextual understanding for their research efforts.

* Transportation
* Energy
* Communications
* Healthcare


----
[[KGCOE-Research]]  | [[Spring 2017 Seminars]] | [[Fall 2016 Seminars]] | [[Spring 2016 Seminars]] | [[Fall 2015 Seminars]]
DOC
    gen = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    puts gen.result
    assert_true(gen.result.length == 0)
  end

end