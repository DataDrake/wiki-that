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
require_relative('elements/element')
require_relative('elements/formatting')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/nowiki')
require_relative('elements/rule')
require_relative('elements/table')
require_relative('elements/text')
require_relative('../lexer/lexer')
module WikiThat
  ##
  # Parsers are disposable objects for translate a Mediawiki
  # document to an Element tree
  # @author Bryan T. Meyers
  ##
  class Parser
    include WikiThat::Formatting
    include WikiThat::Header
    include WikiThat::Links
    include WikiThat::List
    include WikiThat::NoWiki
    include WikiThat::Rule
    include WikiThat::Table
    include WikiThat::Text

    # All of the errors generated while parsing
    attr_reader :errors, :warnings
    # The output of the translation to HTML
    attr_reader :result

    ##
    # Create a new WikiThat::Parser
    # @param [String] doc the MediaWiki document
    # @param [String] base_url the base URL for relative links
    # @param [String] default_namespace the default namespace for relative links
    # @param [String] sub_url the sub URL for relative links
    #
    # @returns [WikiThat::Parser] a newly configured Parser
    ##
    def initialize(doc, base_url, default_namespace, sub_url)
      @lexer             = WikiThat::Lexer.new(doc)
      @base_url          = base_url
      @default_namespace = default_namespace
      @index             = 0
      @sub_url           = sub_url
      @errors            = []
      @warnings          = []
      @tokens            = []
      @result            = Element.new(:root)
    end

    ##
    # Translate the current Tokens into sero or more elements
    #
    # @returns [Object] the resulting element(s)
    ##
    def parse2
      if match? [:table_end, :table_data, :table_header, :table_row]
        return []
      end
      case current.type
        when :header_start
          parse_header
        when :rule
          parse_rule
        when :list_item
          parse_list
        when :nowiki
          parse_nowiki
        when :table_start
          parse_table
        else
          parse_text
      end
    end

    ##
    # Translate the MediaWiki document into an element tree
    #
    # @returns [Element] the resulting root element
    ##
    def parse
      @lexer.lex
      @tokens = @lexer.result
      until end?
        r = parse2
        if r.is_a? Array
          @result.add_children(*r)
        else
          @result.add_child(r)
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
    # Append Error to the error list
    # @param [String] error the error to append
    ##
    def error(error)
      @errors.push(error)
    end

    ##
    # Append Warning to the warning list
    # @param [String] warn the warning to append
    ##
    def warning(warn)
      @warnings.push(warn)
    end

    ##
    # Get the character at the pointer
    # @return [String] the character being pointed at
    ##
    def current
      @tokens[@index]
    end

    ##
    # Determine if the current character matches any types in a list
    # @param [Array] types a list of types to check
    # @return [Boolean] True iff the current token type is in the list
    ##
    def match?(types)
      if end?
        return false
      end
      types.each do |type|
        if current.type == type
          return true
        end
      end
      false
    end

    ##
    # Determine if the current token does not match any types in a list
    # @param [Array] types a list of types to check
    # @return [Boolean] True iff the current token type is not in the list
    ##
    def not_match?(types)
      if end?
        return true
      end
      types.each do |type|
        if current.type == type
          return false
        end
      end
      true
    end

    ##
    # Check if the end of the tape has been reached
    # @returns [Boolean] True if at or beyond the end
    ##
    def end?
      @tokens.nil? or @index >= @tokens.length
    end

    ##
    # Check if the parsing succeeded
    # @returns [Boolean] True iff no errors
    ##
    def success?
      @errors.length == 0
    end
  end
end