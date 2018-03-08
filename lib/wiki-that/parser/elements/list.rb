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
        success = value[i] == prefix[i]
        success ||= value[i] == ':' && prefix[i] == ';'
        success ||= value[i] == ';' && prefix[i] == ':'
        return false unless success
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
      while match?(:list_item) && check_item(curr, depth, current.value)
        item = case current.value[depth]
                 when ';'
                   Element.new(:dt)
                 when ':'
                   Element.new(:dd)
                 else
                   Element.new(:li)
               end
        if depth < (current.value.length - 1)
          if items.empty?
            item.add_child(Element.new(:br))
            item.add_child(parse_list2(current.value, depth + 1))
            items.push(item)
          else
            items.last.add_child(parse_list2(current.value, depth + 1))
          end
        else
          advance
          item.add_children(*parse_inline)
          items.push(item)
        end

        skip :break
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
      parse_list2(current.value, 0)
    end
  end
end
