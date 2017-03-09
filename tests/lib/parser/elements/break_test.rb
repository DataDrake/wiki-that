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

class BreakTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('',parser.result)
  end

  def test_newline
    parser = WikiThat::Parser.new("\n",'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p></p>',parser.result)
  end

  def test_break1
    parser = WikiThat::Parser.new("\n\n",'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p></p>',parser.result)
  end

  def test_break2
    parser = WikiThat::Parser.new("\n\n\n",'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p></p>',parser.result)
  end

  def test_break3
    parser = WikiThat::Parser.new("Hello\nGoodbye\n\n",'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p>HelloGoodbye</p>',parser.result)
  end

  def test_break4
    parser = WikiThat::Parser.new("Hello\n\nGoodbye\n",'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<p>Hello</p><p>Goodbye</p>',parser.result)
  end

end