##
# Copyright 2017-2018 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##
require_relative('tokens/break')
require_relative('tokens/formatting')
require_relative('tokens/header')
require_relative('tokens/links')
require_relative('tokens/list')
require_relative('tokens/html_tag')
require_relative('tokens/rule')
require_relative('tokens/table')
require_relative('tokens/text')
require_relative('tokens/toc')
module WikiThat
  ##
  # Lexers are disposable objects for translate a Mediawiki
  # document to a Token list.
  # @author Bryan T. Meyers
  ##
  class Lexer
    include WikiThat::Break
    include WikiThat::Formatting
    include WikiThat::Header
    include WikiThat::Links
    include WikiThat::List
    include WikiThat::HTMLTag
    include WikiThat::Rule
    include WikiThat::Table
    include WikiThat::Text
    include WikiThat::TableOfContents

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
    # Translate the MediaWiki document into a Token list
    #
    # @returns [Array] the resulting Token List
    ##
    def lex
      until end?
        case current
          when *BREAK_SPECIAL
            lex_break
          when *HEADER_SPECIAL
            lex_header
          when *RULE_SPECIAL
            lex_horizontal_rule
          when *LIST_SPECIAL
            lex_list
          when *TABLE_SPECIAL
            lex_table
          when *TOC_SPECIAL
            lex_toc
          when *TAG_SPECIAL
            lex_tag
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
    # @param [Token] tokens the Tokens to append
    ##
    def append(tokens)
      @result.push(*tokens)
    end

    ##
    # Get the character at the pointer
    # @return [String] the character being pointed at
    ##
    def current
      return '' if end?
      @doc[@index]
    end

    ##
    # Determine if the current character matches any in a list
    # @param [Array] chars a list of characters to check
    # @return [Boolean] True iff the current character is in the list
    ##
    def match?(chars)
      !end? && chars.include?(current)
    end

    ##
    # Continue reading until the characters no longer match
    # @param [Array] chars a list of characters to check
    # @return [String] the characters read
    ##
    def read_matching(chars)
      buff = ''
      while match? chars
        buff += current
        advance
      end
      buff
    end

    ##
    # Determine if the current character does not match any in a list
    # @param [Array] chars a list of characters to check
    # @return [Boolean] True iff the current character is not in the list
    ##
    def not_match?(chars)
      return false if end?
      chars.each do |char|
        return false if current == char
      end
      true
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
