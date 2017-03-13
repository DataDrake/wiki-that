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
require_relative('tokens/break')
require_relative('tokens/formatting')
require_relative('tokens/header')
require_relative('tokens/links')
require_relative('tokens/list')
require_relative('tokens/rule')
require_relative('tokens/table')
require_relative('tokens/text')
require_relative('helpers')
module WikiThat
  ##
  # Lexers are disposable objects for translate a Mediawiki
  # document to a Token list.
  # @author Bryan T. Meyers
  ##
  class Lexer
    include WikiThat::Helpers
    include WikiThat::Break
    include WikiThat::Formatting
    include WikiThat::Header
    include WikiThat::Links
    include WikiThat::List
    include WikiThat::Rule
    include WikiThat::Table
    include WikiThat::Text

    # All of the errors generated while lexing
    attr_reader :errors
    # The output of the translation to HTML
    attr_reader :result

    ##
    # Create a new WikiThat::Lexer
    # @param [String] doc the MediaWiki document
    #
    # @returns [WikiThat::Lexer] a newly configured Lexer
    ##
    def initialize(doc)
      @doc    = doc
      @index  = 0
      @result = []
    end

    ##
    # Translate the MediaWiki document into HTML
    #
    # @returns [String] the resulting HTML partial
    ##
    def lex
      until end?
        case current
          when "\n"
            lex_break
          when *HEADER_SPECIAL
            lex_header
          when *RULE_SPECIAL
            lex_horizontal_rule
          when *LIST_SPECIAL
            lex_list
          when *TABLE_SPECIAL
            lex_table
          else
            lex_text
        end
      end
    end

    ##
    # Move the lexer tape forward
    # @param [Integer] dist how many steps to move forward, default 1
    ##
    def advance(dist = 1)
      @index += dist
    end

    ##
    # Append Tokens to the result
    # @param [Token] toks the Tokens to append
    ##
    def append(toks)
      @result.push(*toks)
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
    # Move the lexer tape backward
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
  end
end