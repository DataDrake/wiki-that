module WikiThat
  module Break
    def parse_break
      @index += 1
      @count = 0

      #Find all consecutive newlines
      while match? "\n"
        @count += 1
        @index += 1
      end

      # Break if more than 1
      if count > 1
        @result += '<br/>'
      else
        @result += "\n"
      end

      #Set next state
      @state = :line_start
    end
  end
end