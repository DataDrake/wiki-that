module WikiThat
  module Rule
    def parse_horizontal_rule
      buff = ''
      count = 0
      while match? '-'
        buff += current
        count += 1
        advance
      end
      case count
        when 1,2
          rewind(count)
          next_state :list
          return
        else

      end
      append '<hr/>'
    end
  end
end