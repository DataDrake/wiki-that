module WikiThat
  module Helpers
    def match?(*chars)
      if end?
        return false
      end
      chars.each do |char|
        if current == char
          return true
        end
      end
      false
    end

    def not_match?(*chars)
      if end?
        return false
      end
      chars.each do |char|
        if current == char
          return false
        end
      end
      true
    end

    def whitespace?(c)
      case c
        when ' ', "\t"
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