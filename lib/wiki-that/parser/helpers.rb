module WikiThat
  module Helpers
    def match?(char)
      @index != @doc.length && @doc[@index] == char
    end

    def not_match?(char)
      @index != @doc.length && @doc[@index] != char
    end

    def whitespace?(c)
      case c
        when ' ', "\n"
          true
        else
          false
      end
    end

    FORMAT_SPECIAL = %w(')
    HEADER_SPECIAL = %w(=)
    HRULE_SPECIAL  = %w(-)
    LINK_SPECIAL   = %w([)
    LIST_SPECIAL   = %w(* # : ;)
    TABLE_SPECIAL  = %w({)

    def special_char?(c)
      c =~ /[*#;:'=\-\[]/
      case c
        when *FORMAT_SPECIAL
          true
        when *HEADER_SPECIAL
          true
        when *HRULE_SPECIAL
          true
        when *LINK_SPECIAL
          true
        when *LIST_SPECIAL
          true
        when *TABLE_SPECIAL
          true
        else
          false
      end
    end
  end
end