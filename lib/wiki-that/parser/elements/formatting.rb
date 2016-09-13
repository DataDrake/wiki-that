module WikiThat
  module Formatting
    def parse_formatting
      #Read opening marks
      start_count = 0
      buff = ''
      while match? "'"
        buff += @doc[@index]
        start_count += 1
        i += 1
      end

      #Fail if not a start sequence
      if start_count < 2
        @result += buff
        return
      end

      #Read inner content, ignoring apostrophes
      end_count = 0
      content = ''
      while not_match? "\n"
        while match? "'"
          buff += @doc[@index]
          end_count += 1
          @index += 1
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
        @result += buff
        return
      end

      #Choose Minimum Depth
      count = start_count < end_count ? start_count : end_count

      #Produce Tag
      case count
        when 2
          @result += "<i>#{content}</i>"
        when 3
          @result += "<b>#{content}</b>"
        when 5
          @result += "<b><i>#{content}</i></b>"
        else
          @result += buff
      end

      #Set next state
      if not_match? "\n"
        @state = :inline_text
      else
        @state = :break
      end
    end
  end
end