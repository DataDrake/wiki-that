require_relative('elements/break')
require_relative('elements/formatting')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/text')
require_relative('helpers')
module WikiThat
  class Parser
    include WikiThat::Helpers
    include WikiThat::Break
    include WikiThat::Formatting
    include WikiThat::Header
    include WikiThat::List
    include WikiThat::Table
    include WikiThat::Text

    attr_reader :error
    attr_reader :result

    def initialize(doc,base_url, default_namespace, sub_url)
      @doc = doc
      @index = 0
      @base_url = base_url
      @default_namespace = default_namespace
      @sub_url = sub_url
      @state = :line_start
      @stack = []
      @error = nil
      @result = ''
    end

    def parse
      while @index != @doc.length
        case @state
          when :line_start
            case @doc[@index]
              when "\n"
                @state = :break
              when *FORMAT_SPECIAL
                @state = :format
              when *HEADER_SPECIAL
                @state = :header
              when *HRULE_SPECIAL
                @state = :horizontal_rule
              when *LINK_SPECIAL
                @state = :link
              when *LIST_SPECIAL
                @state = :list
              when *TABLE_SPECIAL
                @state = :table
              else
                @state = :paragraph
            end
          when :break
            parse_break
          when :format
            parse_formatting
          when :header
            parse_header
          when :horizontal_rule
            parse_horizontal_rule
          when :link
            parse_link
          when :list
            parse_list
          when :table
            parse_table
          else
            @error = "Arrived at illegal state: #{@state}"
        end
      end
    end

    def success?
      @error == nil
    end
  end
end