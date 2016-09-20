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
      if count < 3
        append buff
        return
      end
      append '<hr/>'
    end
  end
end