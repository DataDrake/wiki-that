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

      if start_level < 2
        append buff
        return
      end

      #Read inner content
      end_level = 0
      content = ''
      while not_match? "\n"
        while match? '='
          buff += current
          end_level += 1
          advance
        end
        if end_level >= 2
          break
        end
        part = parse_inline('=')
        buff += part
        content += part
        end_level = 0
      end

      if end_level < 2
        error 'Warning: Incomplete header'
        append buff
        return
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