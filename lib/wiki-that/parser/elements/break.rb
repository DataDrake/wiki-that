module WikiThat
  module Break
    def parse_break
      #Read first newline
      buff = @doc[@index]
      @index += 1

      #Break if second newline
      if match? "\n"
        @result += '<br/>'
        @index += 1
      else
        @result += buff
      end

      #Set next state
      @state = :line_start
    end
  end
end