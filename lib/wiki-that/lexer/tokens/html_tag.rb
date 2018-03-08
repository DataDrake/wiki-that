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
  TAG_SPECIAL = %w[<].freeze

  ##
  # Lexer module for handling HTML tags
  # @author Bryan T. Meyers
  ##
  module HTMLTag
    ##
    # Lex the current text as an HTML Comment
    ##
    def lex_comment
      start = '<' + current
      advance
      start += read_matching(%w[-])
      # First '-'
      if start != '<!--'
        append Token.new(:text, start)
        return
      end
      start.gsub!('<', '&lt;')
      # Read Comment
      buff = ''
      while not_match? ['-', "\n", "\r", '<']
        buff += current
        advance
      end
      if end?
        append Token.new(:text, start + buff)
        return
      end

      # Read Closing --
      close = read_matching(%w[-])
      if (close != '--') || current != '>'
        append Token.new(:text, start + buff + close)
        return
      end
      advance
      append Token.new(:comment, buff)
    end

    ##
    # Lex the current text as an HTML Tag
    ##
    def lex_tag
      start = current
      advance
      if end?
        append Token.new(:text, start)
        return
      end
      case current
        when '!'
          # Lexing a Comment
          lex_comment
          return
        when '/'
          type = :tag_close
          advance
        when *TAG_SPECIAL
          append Token.new(:text, '&lt;')
          return
        else
          type = :tag_open
      end

      tag = ''
      while not_match?(%W[\r \n > <])
        tag += current
        advance
      end
      if end? || not_match?(%w[>])
        tag = case type
                when :tag_close
                  '&lt;/' + tag
                else
                  '&lt;' + tag
              end
        append Token.new(:text, tag)
        return
      end
      ## Skip closing >
      advance
      # Handle special <nowiki> and <pre> tags
      if (type == :tag_open) && ((tag == 'nowiki') || (tag == 'pre'))
        content = ''
        done    = false
        until done || end?
          while not_match?(TAG_SPECIAL)
            content += current
            advance
          end
          break if end?
          lex_tag
          t = @result.pop
          case t.type
            when :tag_open
              content += "<#{t.value}>"
            when :tag_close
              if t.value == tag
                done = true
              else
                content += "</#{t.value}>"
              end
            else
              content += t.value
          end
        end
        append Token.new(tag.to_sym, content)
      else
        append Token.new(type, tag)
      end
    end
  end
end
