module WikiThat
  module Text

    def parse_inline(stop)
      buff = ''
      while not_match?(stop) && not_match?("\n")
        buff += current
        advance
      end
      buff
    end

    def parse_paragraph
      parse_inline("\n")
      parse_break
    end
  end
end