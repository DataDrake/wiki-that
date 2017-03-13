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
    def parse_inline(stop = nil)
      children = []
      until match? [stop] or end?
        case current.type
          when :format
            children.push(*parse_format)
          when :link_start
            children.push(parse_link)
          when :text
            children.push(Element.new(:text,current.value))
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
      until match? [:break] or end?
        text.add_children(*parse_inline)
      end
      append text
    end
  end
end