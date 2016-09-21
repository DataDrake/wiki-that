module WikiThat
  module List

    LIST_MAP = {'*' => 'ul', '#' => 'ol', ';' => 'dl', '-' => 'dl'}
    ITEM_MAP = {'*' => 'li', '#' => 'li', ';' => 'dt', '-' => 'dd'}

    LIST_SPECIAL = %w(* # : ; -)

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
        [false,parse_first_item]
      else local_stack.length < @stack.length
        [true,'']
      end
    end

    def parse_first_item
      start_tag = "<#{ITEM_MAP[current]}>"
      end_tag = "</#{ITEM_MAP[current]}>"
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

    def parse_items
      buff = ''
      ## get first list item
      buff += parse_first_item
      done = false
      ## while not end of list
      until end? || done
        done,partial = parse_item
        buff += partial
      end
      buff
    end

    def parse_list2
      start_tag = "<#{LIST_MAP[current]}>"
      end_tag = "</#{LIST_MAP[current]}>"
      @stack.push(current)
      buff = parse_items
      @stack.pop
      start_tag + buff + end_tag
    end
    def parse_list
      append parse_list2
      next_state :line_start
    end
  end
end