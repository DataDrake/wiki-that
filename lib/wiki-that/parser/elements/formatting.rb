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
module WikiThat
  ##
  # Lexer module for inline formatting
  # @author Bryan T. Meyers
  ##
  module Formatting
    ##
    # Parse the current text as inline formatting
    ##
    def parse_format
      results = []
      start   = current
      advance
      contents = []
      finish   = nil
      until end?
        case current.type
          when :format
            finish = current
            advance
            break
          when :link_start
            contents.push(parse_link)
          when :text
            contents.push(Element.new(:text, current.value))
            advance
          else
            break
        end
      end
      if finish.nil?
        results.push Element.new(:text, start.value)
        results.push(*contents)
        return results
      end
      depth = finish.value.length
      if start.value.length != finish.value.length
        warning "Unbalanced inline formatting"
      end
      if start.value.length < finish.value.length
        depth = start.value.length
      end
      case depth
        when 2
          element = Element.new(:i)
          element.add_children(*contents)
          results.push(element)
        when 3
          element = Element.new(:b)
          element.add_children(*contents)
          results.push(element)
        else
          e1 = Element.new(:b)
          e1.add_children(*contents)
          e2 = Element.new(:i)
          e2.add_child(e1)
          results.push(e2)
      end
      results
    end
  end
end