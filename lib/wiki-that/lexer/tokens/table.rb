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
module WikiThat

  # Special characters for Tables
  TABLE_SPECIAL = %w({ | !)

  ##
  # Lexer module for MediaWiki Tables
  # @author Bryan T. Meyers
  ##
  module Table

    ##
    # Lex any of the possible table tokens
    ##
    def lex_table
      case current
        when '{'
          advance
          unless match? '|'
            rewind
            lex_text
            return
          end
          advance
          append Token.new(:table_start)
          lex_inline
        when '|'
          advance
          case current
            when '}'
              advance
              append Token.new(:table_end)
              lex_inline
            when '+'
              advance
              append Token.new(:table_caption)
              lex_inline
            when '-'
              advance
              append Token.new(:table_row)
              lex_inline('|', '!')
            when '|'
              advance
              append Token.new(:table_column, 2)
              lex_inline('|', '!')
            else
              append Token.new(:table_column, 1)
              lex_inline('|', '!')
          end
        when '!'
          advance
          if match? '!'
            advance
            append Token.new(:table_header, 2)
          else
            append Token.new(:table_header, 1)
          end
          lex_inline('|', '!')
      end
    end
  end
end