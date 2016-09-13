module WikiThat
  module Break
    def parse_break
      buff = @doc[@index]
      @index += 1
      if @index != @doc.length && @doc[@index] == "\n"
        @result += '<br/>'
      else
        @result += buff
      end
    end
  end
end