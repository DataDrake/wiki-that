require_relative('../../../../lib/wiki-that/wiki-that')

module WikiThat
  module Header
    def parse_header
      #Read start sequence
      buff = ''
      start_level = 0
      while match? '='
        buff += '='
        start_level += 1
        advance
      end

      #Read inner content
      end_count = 0
      content = ''
      while not_match? "\n"
        while match? '='
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

      #Fail if not at end sequence
      if not_match? '='
        append buff
        return
      end

      #Read end sequence
      end_level = 0
      while match? '='
        buff += '='
        end_level += 1
        advance
      end

      #Read the rest of the line
      while not_match? "\n"
        buff += current
        unless whitespace? current
          @state = :header_fail
        end
        advance
      end

      #Fail if it wasn't alll whitespace
      if @state == :header_fail
        append buff
        return
      end

      #Produce output
      level = start_level > end_level ? end_level : start_level
      append "<h#{level}>#{content}</h#{level}>"

      next_state :break
    end
  end
end