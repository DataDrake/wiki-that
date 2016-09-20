module WikiThat
  module Formatting
    def parse_formatting
      #Read opening marks
      start_count = 0
      buff = ''
      while match? "'"
        buff += current
        start_count += 1
        advance
      end

      #Fail if not a start sequence
      if start_count < 2
        return buff
      end

      #Read inner content, ignoring apostrophes
      end_count = 0
      content = ''
      while not_match? "\n"
        while match? "'"
          buff += current
          end_count += 1
          advance
        end
        if end_count >= 2
          break
        end
        part = parse_inline("'")
        buff += part
        content += part
        end_count = 0
      end

      #Fail if not an end sequence
      if end_count < 2
        return buff
      end

      #Choose Minimum Depth
      count = start_count < end_count ? start_count : end_count

      #Produce Tag
      case count
        when 2
          buff = "<i>#{content}</i>"
        when 3
          buff = "<b>#{content}</b>"
        when 5
          buff = "<b><i>#{content}</i></b>"
        else ## do nothing
      end

      next_state :inline_text
      buff
    end
  end
end