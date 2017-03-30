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

require_relative 'lib/wiki-that'
Gem::Specification.new do |s|
  s.name        = 'wiki-that'
  s.version     = WikiThat::VERSION
  s.date        = '2017-03-30'
  s.summary     = 'wiki-that'
  s.description = 'A MediaWiki to HTML parser for the Engineering Design Guide and Environment (EDGE)'
  s.authors     = ['Bryan T. Meyers']
  s.email       = 'bmeyers@datadrake.com'
  s.files       = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.homepage    = 'http://rubygems.org/gems/wiki-that'
  s.license     = 'Apache-2.0'
end