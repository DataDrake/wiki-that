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
require_relative('token')
module WikiThat
  ##
  # Lexer module for handling raw text
  # @author Bryan T. Meyers
  ##
  module Text

    # Special characters for formatting tags
    FORMAT_SPECIAL = %w(')
    # Special Characters for Links
    LINK_SPECIAL   = %w([)

    ##
    # Continue to lex as inline-text until the specified
    # character or end of line
    # @param [String] stop the character to stop at
    # @returns [String] the text read
    ##
    def lex_inline(stop = nil)
      buff = ''
      while not_match?(stop) && not_match?("\n")
        case current
          # Inline formatting
          when *FORMAT_SPECIAL
            fmt = lex_formatting
            if FORMAT_SPECIAL.include? current
              buff += current
              advance
            else
              if buff.length > 0
                append Token.new(:text,buff.clone)
                buff = ''
              end
              append fmt
            end
          # Inline links
          when *LINK_SPECIAL
            #lex_link
          else
            buff += current
            advance
        end
      end
      if buff.length > 0
        append Token.new(:text,buff)
      end
    end

    ##
    # Continue reading as raw text until a linebreak
    ##
    def lex_text
      until end?
        lex_inline
        lex_break
      end
    end
  end
end