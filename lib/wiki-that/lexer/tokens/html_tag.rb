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

  TAG_SPECIAL = %w(<)

  ##
  # Lexer module for handling HTML tags
  # @author Bryan T. Meyers
  ##
  module HTMLTag
    ##
    # Lex the current text as an HTML Tag
    ##
    def lex_tag
      buff = current
      advance
      if end?
        append Token.new(:text, buff)
        return
      end
      case current
        when *TAG_SPECIAL
          append Token.new(:text, buff)
          return
        when '!'
          advance 3
          type = :comment
        when '/'
          advance
          type = :tag_close
        else
          type = :tag_open
      end
      tag = ''
      until end? or match? %w(\n >)
        tag += current
        advance
      end
      if end? or not_match? %w(>)
        case type
          when :comment
            tag = '<!--' + tag
          when :tag_close
            tag = '</' + tag
          else
            tag = '<' + tag
        end
        append Token.new(:text, tag)
      else
        advance
        if type == :comment
          tag.chomp!('--')
        end
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
              when :comment
                content += "<!--#{t.value}-->"
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