module WikiThat
  module Text

    FORMAT_SPECIAL = %w(')
    LINK_SPECIAL   = %w([)

    def parse_inline(stop)
      buff = ''
      while not_match?(stop) && not_match?("\n")
        case current
          when *FORMAT_SPECIAL
            buff += parse_formatting
          when *LINK_SPECIAL
            buff += parse_link
          else
            buff += current
            advance
        end
      end
      buff
    end

    def parse_paragraph
      append '<p>'
      until end? || @state == :break
        append parse_inline("\n")
        parse_break
      end
      append '</p>'
    end
  end
end