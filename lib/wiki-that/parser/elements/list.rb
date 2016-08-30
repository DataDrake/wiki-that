module WikiThat
  module List

    LIST_MATCH = /[*#:;]/
    LIST_MAP = {'*' => 'ul', '#' => 'ol', ';' => 'dl', '-' => 'dl'}
    ITEM_MAP = {'*' => 'li', '#' => 'li', ';' => 'dt', '-' => 'dd'}

    def self.parse_item(doc,i,stack,first)
      unless first
        j = 0
        stack.each do |t|
          if doc[i] != t && !(( t == '-' && doc[i] == ';') || (t == ';' && doc[i] == '-'))
            i -= j + 1
            return [i,'',true,false]
          end
          j += 1
          i += 1
        end
        i -= 1
      end
      start_tag = "<#{ITEM_MAP[doc[i]]}>"
      end_tag = "</#{ITEM_MAP[doc[i]]}>"
      i += 1
      broken = false
      if doc[i] =~ LIST_MATCH
        i,buff = parse(doc,i,stack)
      else
        i,buff,broken = WikiThat::Text.parse(doc,i)
      end
      [i,start_tag + buff + end_tag,broken,false]
    end

    def self.parse(doc,i, stack = [])
      start_tag = "<#{LIST_MAP[doc[i]]}>"
      end_tag = "</#{LIST_MAP[doc[i]]}>"
      buff = ''
      stack.push(doc[i])
      done = false
      first = true
      while i != doc.length && !done
        i,partial,done,first = parse_item(doc,i,stack,first)
        buff += partial
      end
      [i,start_tag + buff + end_tag]
    end
  end
end