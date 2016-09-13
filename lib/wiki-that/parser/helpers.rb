module WikiThat
  module Helpers
    def match?(char)
      @index != @doc.length && @doc[@index] == char
    end

    def not_match?(char)
      @index != @doc.length && @doc[@index] != char
    end

    def whitespace?(c)
      c == ' ' || c == "\t"
    end

    def special_char?(c)
      c =~ /[*#;:'=\-\[]/
    end
  end
end