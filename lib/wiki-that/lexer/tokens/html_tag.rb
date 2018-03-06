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
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
##
require_relative('token')
module WikiThat

  TAG_SPECIAL = %w(<)

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
      start += read_matching(%w(-))
      # First '-'
      if start != "<!--"
        append Token.new(:text, start)
        return
      end
      # Read Comment
      buff = ''
      while not_match? ['-', "\n", "\r", '<']
        if end?
          append Token.new(:text, start.gsub('<','&lt;') + buff)
          return
        end
        buff += current
        advance
      end

      # Read Closing --
      close = read_matching(%w(-))
      if close != "--" or not_match? %w(>)
        start.gsub!('<','&lt;')
        append Token.new(:text, start + buff + close)
        return
      end
      advance
      buff.gsub!('<!--','')
      buff.gsub!('--','')
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
        when *TAG_SPECIAL
          # Escape a less-than, try again
          append Token.new(:text, '&lt;')
          return
        when '!'
          # Lexing a Comment
          lex_comment
          return
        when '/'
          type = :tag_close
          advance
        else
          type = :tag_open
      end

      tag = ''
      until end? or match? %W(\r \n > <)
        tag += current
        advance
      end
      if end? or not_match? %w(>)
        case type
          when :tag_close
            tag = '&lt;/' + tag
          else
            tag = '&lt;' + tag
        end
        append Token.new(:text, tag)
      else
        ## Skip closing >
        advance
        # Handle special <nowiki> and <pre> tags
        if type == :tag_open and (tag == 'nowiki' or tag == 'pre')
          content = ''
          done = false
          until done or end?
            until end? or match? TAG_SPECIAL
              content += current
              advance
            end
            if end?
              break
            end
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
end