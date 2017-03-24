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
  # Lexer module for handling List elements
  # @author Bryan T. Meyers
  ##
  module List
    ##
    # Check if this item belongs to the current list
    # @param [String] prefix the prefix of the current list
    # @param [Integer] depth the depth of the current list
    # @param [String] value the value of the current list item
    # @return [Boolean] True if belongs to list
    ##
    def check_item(prefix, depth, value)
      (0..depth).each do |i|
        case value[i]
          when prefix[i]
            # good
          when ':'
            unless prefix[i] == ';'
              return false
            end
          when ';'
            unless prefix[i] == ':'
              return false
            end
          else
            return false
        end
      end
      true
    end
    ##
    # Parse all the items at the current depth
    # @param [String] curr the list item string
    # @param [Integer] depth the current nesting depth
    ##
    def parse_items(curr, depth)
      items = []
      while not end? and current.type == :list_item and check_item(curr, depth, current.value)
        case current.value[depth]
          when ';'
            item = Element.new(:dt)
          when ':'
            item = Element.new(:dd)
          else
            item = Element.new(:li)
        end
        if depth < (current.value.length - 1)
          item.add_child(parse_list2(current.value,depth+1))
        else
          advance
          item.add_children(*parse_inline("\n"))
        end
        items.push(item)
        if not end? and current.type == :break
          if current.value == 1
            advance
          else
            advance
            break
          end
        end
      end
      items
    end

    ##
    # Parse a level of a list
    # @param [String] curr the list item string
    # @param [Integer] depth the current nesting depth
    # @return [String] the parsed list
    ##
    def parse_list2(curr, depth)
      case curr[depth]
        when ';', ':'
          list = Element.new(:dl)
        when '#'
          list = Element.new(:ol)
        else
          list = Element.new(:ul)
      end
      list.add_children(*parse_items(curr, depth))
      list
    end

    ##
    # Parse the current text as a list
    ##
    def parse_list
      parse_list2(current.value,0)
    end
  end
end