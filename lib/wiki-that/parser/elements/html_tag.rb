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
  # Lexer module for HTML tags
  # @author Bryan T. Meyers
  ##
  module HTMLTag
    ##
    # Parse the current token as an HTML tag
    ##
    def parse_tag
      case current.type
        when :comment
          tag = Element.new(:comment, current.value)
          advance
        when :tag_close
          tag = Element.new(:text, "</#{current.value}>")
          advance
        else
          name = current.value
          tag = Element.new(name.to_sym)
          advance
          if name == 'nowiki' or name == 'pre'
            until end?
              if current.type == :tag_close and current.value == name
                break
              end
              tag.add_child(current)
            end
          end
          p = parse_inline
          if not_match? [:tag_close]
            warning "HTML tag '#{name}' not terminated, but closing anyways"
          else
            advance
          end

          tag.add_children(*p)
      end
      tag
    end

    ##
    # Parse the current token as nowiki/pre
    ##
    def parse_nowiki
      e = Element.new(current.type, current.value)
      advance
      e
    end
  end
end