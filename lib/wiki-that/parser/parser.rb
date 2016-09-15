require_relative('elements/break')
require_relative('elements/formatting')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/table')
require_relative('elements/text')
require_relative('helpers')
module WikiThat
  class Parser
    include WikiThat::Helpers
    include WikiThat::Break
    include WikiThat::Formatting
    include WikiThat::Header
    include WikiThat::Links
    include WikiThat::List
    include WikiThat::Table
    include WikiThat::Text

    attr_reader :errors
    attr_reader :result

    def initialize(doc,base_url, default_namespace, sub_url)
      @doc = doc
      @index = 0
      @base_url = base_url
      @default_namespace = default_namespace
      @sub_url = sub_url
      @state = :line_start
      @stack = []
      @errors = []
      @result = ''
    end

    def parse
      until end?
        case @state
          when :line_start
            case current
              when "\n"
                next_state :break
              when *FORMAT_SPECIAL
                next_state :format
              when *HEADER_SPECIAL
                next_state :header
              when *HRULE_SPECIAL
                next_state :horizontal_rule
              when *LINK_SPECIAL
                next_state :link
              when *LIST_SPECIAL
                next_state :list
              when *TABLE_SPECIAL
                next_state :table
              else
                next_state :paragraph
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
            error "Arrived at illegal state: #{@state}"
        end
      end
    end

    def advance(dist = 1)
      @index += dist
    end

    def append(str)
      @result += str
    end

    def current
      if end?
        return ''
      end
      @doc[@index]
    end

    def error(err)
      @errors.push err
    end

    def next_state(state)
      @state = state
    end

    def rewind(dist = 1)
      @index -= dist
    end

    def end?
      @index >= @doc.length
    end

    def success?
      @errors.empty?
    end
  end
end