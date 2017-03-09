##
# Copyright 2017 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
##
require_relative('elements/break')
require_relative('elements/formatting')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/rule')
require_relative('elements/table')
require_relative('elements/text')
require_relative('helpers')
module WikiThat
  ##
  # Parsers are disposable objects for translatin a Mediawiki
  # document to HTML only once.
  # @author Bryan T. Meyers
  ##
  class Parser
    include WikiThat::Helpers
    include WikiThat::Break
    include WikiThat::Formatting
    include WikiThat::Header
    include WikiThat::Links
    include WikiThat::List
    include WikiThat::Rule
    include WikiThat::Table
    include WikiThat::Text

    # All of the errors generated while parsing
    attr_reader :errors
    # The output of the translation to HTML
    attr_reader :result

    ##
    # Create a new WikiThat::Parser
    # @param [String] doc the MediaWiki document
    # @param [String] base_url the base or the URL to use for relative links
    # @param [String] default_namespace the namespace to use when one isn't specified
    # @param [String] sub_url the base of the url inside the current namespace
    #
    # @returns [WikiThat::Parser] a newly configured Parser
    ##
    def initialize(doc, base_url, default_namespace, sub_url)
      @doc               = doc
      @index             = 0
      @base_url          = base_url
      @default_namespace = default_namespace
      @sub_url           = sub_url
      @state             = :line_start
      @stack             = []
      @errors            = []
      @result            = ''
    end

    ##
    # Translate the MediaWiki document into HTML
    #
    # @returns [String] the resulting HTML partial
    ##
    def parse
      until end?
        case @state
          when :line_start
            case current
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
          when :header
            parse_header
          when :horizontal_rule
            parse_horizontal_rule
          when :link
            parse_link_line
          when :list
            parse_list
          when :table
            parse_table
          when :paragraph
            parse_paragraph
          else
            error "Arrived at illegal state: #{@state}"
        end
      end
    end

    ##
    # Move the parser tape forward
    # @param [Integer] dist how many steps to move forward, default 1
    ##
    def advance(dist = 1)
      @index += dist
    end

    ##
    # Append a string to the result
    # @param [String] str the string to append
    ##
    def append(str)
      @result += str
    end

    ##
    # Get the character at the pointer
    # @return [String] the character being pointed at
    ##
    def current
      if end?
        return ''
      end
      @doc[@index]
    end

    ##
    # Register a new error for the current parsing
    # @param [String] err the error as a string
    ##
    def error(err)
      @errors.push err
    end

    ##
    # Set the state for the next iteration
    # @param [Symbol] state the new state
    ##
    def next_state(state)
      @state = state
    end

    ##
    # Move the parser tape backward
    # @param [Integer] dist how many steps to move backward, default 1
    ##
    def rewind(dist = 1)
      @index -= dist
    end

    ##
    # Check if the end of the tape has been reached
    # @returns [Boolean] True if at or beyond the end
    ##
    def end?
      @index >= @doc.length
    end

    ##
    # Verify that parsing has completed successfully
    # @return [Boolean] True iff the parsing succeeded
    ##
    def success?
      @errors.empty?
    end
  end
end