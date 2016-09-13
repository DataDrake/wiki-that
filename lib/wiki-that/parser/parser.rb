require_relative('elements/break')
require_relative('elements/formatting')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/text')
module WikiThat
  class Parser

    include WikiThat::Break
    include WikiThat::Header

    def initialize(doc,base_url, default_namespace, sub_url)
      @doc = doc
      @index = 0
      @base_url = base_url
      @default_namespace = default_namespace
      @sub_url = sub_url
      @state = :line_start
      @stack = []
      @result = ''
    end

    def parse_inline

    end

    def parse
      while @index != @doc.length
        case @state
          when :line_start
            case @doc[@index]
              when '='
                @state = :header
              when '['
                @state = :link
              when '*', '#', ';', '-'
                @state = :list
              when '{'
                @state = :table
              when "\n"
                @state = :break
              when "'"
                @state = :format
              else
                @state = :inline_text
            end
          when :break
            parse_break
          when :header
            parse_header
          else
            @state = :inline_text
        end
      end
    end
  end
end