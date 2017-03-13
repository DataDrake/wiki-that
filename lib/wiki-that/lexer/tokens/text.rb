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

    ##
    # Continue to lex as inline-text until the specified
    # character or end of line
    # @param [String] stop the character to stop at
    # @returns [String] the text read
    ##
    def lex_inline(*stop)
      buff = ''
      while not_match?(*stop) and not_match?("\n")
        case current
          # Inline formatting
          when *FORMAT_SPECIAL
            fmt = lex_formatting
            if FORMAT_SPECIAL.include? current
              buff += current
              advance
            else
              if buff.length > 0
                append Token.new(:text, buff.clone)
                buff = ''
              end
              append fmt
            end
          # Inline links
          when *LINK_SPECIAL
            if buff.length > 0
              append Token.new(:text, buff)
              buff = ''
            end
            lex_link
          when *LIST_SPECIAL
            rewind
            if current == "\n"
              advance
              lex_list
            else
              advance
              buff += current
              advance
            end
          else
            buff += current
            advance
        end
      end
      if buff.length > 0
        append Token.new(:text, buff)
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