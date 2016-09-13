require_relative('elements/break')
require_relative('elements/formatting')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/text')
module WikiThat
  class Parser

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



    def parse(doc,i = 0)
      output = ''
      while i != doc.length
        case @state
          when :line_start
            case doc[i]
              when '='
                @state = :header
                @stack.push(WikiThat::Header.new)
              when '['
                @state = :link_start
              when '*', '#', ';', '-'
                @state = :list_start
              when '{'
                @state = :table_start
              when "\n"
                @state = :break_start
              when "'"
                @state = :format_start
              else
                @state = :inline_text
            end
          when :header_start
            parse_header
          else
            @state = :inline_text
        end
      end
    end
  end
end