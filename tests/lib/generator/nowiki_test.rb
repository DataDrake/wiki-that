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

class NoWikiGenTest < Test::Unit::TestCase

  def test_empty
    gen = WikiThat::HTMLGenerator.new('', 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('', gen.result)
  end

  def test_complete
    start = '<nowiki>this is not wiki markup</nowiki>'
    gen = WikiThat::HTMLGenerator.new(start, 'wiki', 'BOB', 'sub/folder')
    gen.generate
    assert_true(gen.success?, 'Generation should have succeeded')
    assert_equal('<nowiki>this is not wiki markup</nowiki>', gen.result)
  end

end