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

class RuleTest < Test::Unit::TestCase

  def test_empty
    parser = WikiThat::Parser.new('','wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('',parser.result,'Nothing should have been generated')
  end

  def test_incomplete1
    start = '-'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<dl><dd></dd></dl>',parser.result,'Nothing should have been generated')
  end

  def test_incomplete2
    start = '--'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<dl><dd><dl><dd></dd></dl></dd></dl>',parser.result,'Nothing should have been generated')
  end

  def test_complete1
    start = '---'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<hr/>',parser.result,'Nothing should have been generated')
  end

  def test_complete2
    start = '---'
    parser = WikiThat::Parser.new(start,'wiki','BOB','sub/folder')
    parser.parse
    assert_true(parser.success?,'Parsing should have succeeded')
    assert_equal('<hr/>',parser.result,'Nothing should have been generated')
  end
end