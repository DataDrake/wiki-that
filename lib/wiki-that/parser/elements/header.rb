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
        @index += 1
      end

      #Read inner content
      content = parse_inline('=')
      buff += content

      #Fail if not at end sequence
      if not_match? '='
        @result += buff
        return
      end

      #Read end sequence
      end_level = 0
      while match? '='
        buff += '='
        end_level += 1
        @index += 1
      end

      #Read the rest of the line
      while not_match? "\n"
        buff += @doc[@index]
        unless whitespace? @doc[@index]
          @state = :header_fail
        end
        @index += 1
      end

      #Fail if it wasn't alll whitespace
      if @state == :header_fail
        @result += buff
        return
      end

      #Produce output
      level = start_level > end_level ? end_level : start_level
      @result += "<h#{level}>#{content}</h#{level}>"

      #Set next state
      @state = :break
    end
  end
end