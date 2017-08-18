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
  # Lexer module for handling raw text
  # @author Bryan T. Meyers
  ##
  module Text

    ##
    # Continue reading text tokens until a linebreak
    # @param [Symbol] stop the type to stop parsing at
    ##
    def parse_inline(*stop)
      children = []
      until match? stop or match? [:break] or end?
        case current.type
          when :format
            children.push(*parse_format)
          when :comment, :tag_open
            children.push(parse_tag)
          when :rule
            children.push(parse_rule(true))
          when :link_start
            children.push(parse_link)
          when :nowiki, :pre
            children.push(parse_nowiki)
          when :text
            children.push(Element.new(:text, current.value))
            advance
          else
            return children
        end
      end
      children
    end

    ##
    # Continue reading text tokens until a linebreak
    ##
    def parse_text
      text = Element.new(:p)
      while match? [:break]
        @line += current.value
        advance
      end

      while match? [:text, :break, :link_start, :format, :comment, :tag_open]
        if match? [:break]
          @line += current.value
          if current.value == 1
            text.add_child(Element.new(:text, '&nbsp;'))
            advance
          else
            advance
            break
          end
        else
          text.add_children(*parse_inline)
        end
      end
      text
    end
  end
end