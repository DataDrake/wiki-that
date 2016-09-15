module WikiThat
  module List

    LIST_MATCH = /[*#:;]/
    LIST_MAP = {'*' => 'ul', '#' => 'ol', ';' => 'dl', '-' => 'dl'}
    ITEM_MAP = {'*' => 'li', '#' => 'li', ';' => 'dt', '-' => 'dd'}

    def self.parse_item(first)
      unless first
        j = 0
        @stack.each do |t|
          if not_match? t && !(( t == '-' && match?(';')) || (t == ';' && match?('-')))
            rewind j + 1
            return ['',true,false]
          end
          j += 1
          advance
        end
        rewind 1
      end
      start_tag = "<#{ITEM_MAP[current]}>"
      end_tag = "</#{ITEM_MAP[current]}>"
      advance
      broken = false
      if current =~ LIST_MATCH
        buff = parse_list
      else
        buff,broken = WikiThat::Text.parse(doc,i)
      end
      [start_tag + buff + end_tag,broken,false]
    end

    def self.parse_list
      start_tag = "<#{LIST_MAP[current]}>"
      end_tag = "</#{LIST_MAP[current]}>"
      buff = ''
      @stack.push(current)
      done = false
      first = true
      until end? || done
        partial,done,first = parse_item(first)
        buff += partial
      end
      append start_tag + buff + end_tag
    end
  end
end