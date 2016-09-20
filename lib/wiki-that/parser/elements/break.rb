module WikiThat
  module Break
    def parse_break
      count = 0

      #Find all consecutive newlines
      while match? "\n"
        count += 1
        advance
      end

      # Break if more than 1
      if count > 1
        next_state :break
      else
        next_state :line_start
      end
    end
  end
end