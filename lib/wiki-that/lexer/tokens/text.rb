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
require_relative('token')
module WikiThat
  ##
  # Lexer module for handling raw text
  # @author Bryan T. Meyers
  ##
  module Text
    ##
    # Append buffer as needed
    ##
    def append_text(buff)
      append Token.new(:text, buff) unless buff.empty?
      ''
    end

    ##
    # Continue to lex as inline-text until the specified
    # character or end of line
    # @param [String] stop the character to stop at
    # @returns [String] the text read
    ##
    def lex_text(stop = [])
      buff = ''
      while not_match?(stop) && not_match?(BREAK_SPECIAL)
        case current
          # Inline formatting
          when *FORMAT_SPECIAL
            fmt = lex_formatting
            if match? FORMAT_SPECIAL
              buff += current
              advance
            else
              buff = append_text buff
              append fmt
            end
          # Inline links
          when *LINK_SPECIAL
            buff = append_text buff
            lex_link
          when *RULE_SPECIAL
            buff = append_text buff
            lex_horizontal_rule
          when *TAG_SPECIAL
            buff = append_text buff
            lex_tag
          else
            buff += current
            advance
        end
      end
      append_text buff
    end
  end
end
