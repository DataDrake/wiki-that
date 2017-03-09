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
  # Parser module for handling raw text
  # @author Bryan T. Meyers
  ##
  module Text

    # Special characters for formatting tags
    FORMAT_SPECIAL = %w(')
    # Special Characters for Links
    LINK_SPECIAL   = %w([)

    ##
    # Continue to parse as inline-text until the specified
    # character or end of line
    # @param [String] stop the character to stop at
    # @returns [String] the text read
    ##
    def parse_inline(stop)
      buff = ''
      while not_match?(stop) && not_match?("\n")
        case current
          # Inline formatting
          when *FORMAT_SPECIAL
            buff += parse_formatting
          # Inline links
          when *LINK_SPECIAL
            buff += parse_link
          else
            buff += current
            advance
        end
      end
      buff
    end

    ##
    # Continue reading as raw text until a linebreak
    ##
    def parse_paragraph
      append '<p>'
      until end? || @state == :break
        append parse_inline("\n")
        parse_break
      end
      append '</p>'
      next_state :line_start
    end
  end
end