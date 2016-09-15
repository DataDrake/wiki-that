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
        append buff
        return
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
        append buff
        return
      end

      #Choose Minimum Depth
      count = start_count < end_count ? start_count : end_count

      #Produce Tag
      case count
        when 2
          append "<i>#{content}</i>"
        when 3
          append "<b>#{content}</b>"
        when 5
          append "<b><i>#{content}</i></b>"
        else
          append buff
      end

      #Set next state
      if not_match? "\n"
        next_state :inline_text
      else
        next_state :break
      end
    end
  end
end