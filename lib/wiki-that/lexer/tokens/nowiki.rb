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
      read = 0
      buff = ''
      #Find all consecutive '<'
      while match? NOWIKI_SPECIAL
        read += 1
        buff += current
        advance
      end
      if buff.length != 1
        append Token.new(:text, buff)
        return
      end

      case current
        when 'n'
          tag = 'nowiki'
        when 'p'
          tag = 'pre'
        else
          append Token.new(:text, buff)
          return
      end

      tag.each_char do |c|
        unless current == c
          append Token.new(:text, buff)
          return
        end
        buff += current
        advance
      end

      read = 0
      while current == '>'
        read += 1
        buff += current
        advance
      end
      if read != 1
        append Token.new(:text, buff)
        return
      end
      buff = ''
      body = ''
      done = false
      until end? or done
        if match? NOWIKI_SPECIAL
          #closing tag
          buff = ''
          while match? NOWIKI_SPECIAL
            read += 1
            buff += current
            advance
          end
          if buff.length != 1 or not_match? %w(/)
            body += buff
            redo
          end
          read += 1
          buff += current
          advance
          tag.each_char do |c|
            unless current == c
              break
            end
            read += 1
            buff += current
            advance
          end
          unless current == '>'
            body += buff
            redo
          end
          advance
          done = true
        end
        body += current
        read += 1
        advance
      end
      if done
        append Token.new(tag.to_sym, body)
      else
        append Token.new(:text, "<#{tag}>" + body)
      end

    end
  end
end