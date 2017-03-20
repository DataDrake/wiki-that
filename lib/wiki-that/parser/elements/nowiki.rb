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
module WikiThat
  ##
  # Lexer module for <nowiki> tags
  # @author Bryan T. Meyers
  ##
  module NoWiki
    ##
    # Parse the current token as a nowiki tag
    ##
    def parse_nowiki
      nowiki =  Element.new(:nowiki)
      nowiki.add_child(Element.new(:text,current.value))
      append nowiki
      advance
    end
  end
end