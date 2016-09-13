require_relative('../../../../lib/wiki-that/wiki-that')

module WikiThat
  module Header
    def parse_header
      buff = ''
      start_level = 0
      while @index != @doc.length && @doc[@index] == '='
        buff += '='
        start_level += 1
        @index += 1
      end
      content = parse_inline
      buff += content
      if @state != :header
        @result += buff
        return
      end
      end_level = 0
      while @index != @doc.length && @doc[@index] == '='
        buff += '='
        end_level += 1
        @index += 1
      end
      while @index != @doc.length && @doc[@index] != "\n"
        buff += @doc[@index]
        unless WikiThat.is_whitespace(@doc[@index])
          @state = :header_fail
        end
        @index += 1
      end
      if @state == :header_fail
        @result += buff
        return
      end
      if start_level > end_level
        @result += "<h#{end_level}>#{content}</h#{end_level}>"
      else
        @result += "<h#{start_level}>#{content}</h#{start_level}>"
      end
      @state = :break
    end
  end
end