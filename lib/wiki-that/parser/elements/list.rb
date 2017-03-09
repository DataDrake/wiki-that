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
  # Parser module for handling List elements
  # @author Bryan T. Meyers
  ##
  module List

    # Associate a list symbol with its list type
    LIST_MAP     = {'*' => 'ul', '#' => 'ol', ';' => 'dl', '-' => 'dl'}
    # Associate a list symbol with its list item type
    ITEM_MAP     = {'*' => 'li', '#' => 'li', ';' => 'dt', '-' => 'dd'}
    # Special characters for List elements
    LIST_SPECIAL = %w(* # : ; -)

    ##
    # Parse a single list item
    # @return [Boolean,String] True if a new list, False with a value if a parsed item
    ##
    def parse_item
      local_stack = []
      @stack.each do |s|
        case s
          when current
            local_stack.push(s)
            advance
          when '-'
            if match? ';'
              local_stack.push(s)
              advance
            end
          when ';'
            if match? '-'
              local_stack.push(s)
              advance
            end
          else
            break
        end
      end
      if local_stack.length == @stack.length
        rewind
        [false, parse_first_item]
      else
        local_stack.length < @stack.length
        [true, '']
      end
    end

    ##
    # Parse the first item of a new list
    # @return [String] the HTML list item
    ##
    def parse_first_item
      start_tag = "<#{ITEM_MAP[current]}>"
      end_tag   = "</#{ITEM_MAP[current]}>"
      advance
      case current
        when *LIST_SPECIAL
          buff = parse_list2
        else
          buff = parse_inline("\n")
          advance
      end
      start_tag + buff + end_tag
    end

    ##
    # Parse all of the items of a list
    # @return [String] the translated list items
    ##
    def parse_items
      buff = ''
      ## get first list item
      buff += parse_first_item
      done = false
      ## while not end of list
      until end? || done
        done, partial = parse_item
        buff          += partial
      end
      buff
    end

    ##
    # Parse an entire list
    # @return [String] the parsed list
    ##
    def parse_list2
      start_tag = "<#{LIST_MAP[current]}>"
      end_tag   = "</#{LIST_MAP[current]}>"
      @stack.push(current)
      buff = parse_items
      @stack.pop
      start_tag + buff + end_tag
    end

    ##
    # Parse the current text as a list
    ##
    def parse_list
      append parse_list2
      next_state :line_start
    end
  end
end