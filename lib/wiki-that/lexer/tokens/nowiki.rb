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

  NOWIKI_SPECIAL = %w(<)

  ##
  # Lexer module for handling nowiki tag
  # @author Bryan T. Meyers
  ##
  module NoWiki
    ##
    # Lex the current text as a nowiki
    ##
    def lex_nowiki
      buff = ''
      count = 0
      #Find all consecutive newlines
      while match? NOWIKI_SPECIAL
        buff += current
        count += 1
        advance
      end
      if count != 1
        rewind buff.length
        lex_text
        return
      end

      'nowiki'.each_char do |c|
        unless current == c
          rewind buff.length
          lex_text
          return
        end
        buff += current
        advance
      end

      count = 0
      while current == '>'
        buff += current
        count += 1
        advance
      end
      if count != 1
        rewind buff.length
        lex_text
        return
      end
      body = ''
      until end? or match? NOWIKI_SPECIAL
        body += current
        buff += current
        advance
      end

      #closing tag
      count = 0
      while match? NOWIKI_SPECIAL
        buff += current
        count += 1
        advance
      end
      if count != 1
        rewind buff.length
        lex_text
        return
      end
      '/nowiki'.each_char do |c|
        unless current == c
          rewind buff.length
          lex_text
          return
        end
        buff += current
        advance
      end
      count = 0
      while current == '>'
        buff += current
        count += 1
        advance
      end
      if count != 1
        rewind buff.length
        lex_text
        return
      end
      append Token.new(:nowiki, body)
    end
  end
end