##
# Copyright 2017-2018 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##
module WikiThat
  # Special characters for Horizontal Rules
  RULE_SPECIAL = %w[-].freeze

  ##
  # Lexer module for horizontal rules
  # @author Bryan T. Meyers
  ##
  module Rule
    ##
    # Lex the current text as a horizontal rule if found
    ##
    def lex_horizontal_rule
      buff = read_matching(RULE_SPECIAL)
      if buff.length == 1
        append Token.new(:text, buff)
      else
        append Token.new(:rule, buff)
      end
    end
  end
end
