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
module WikiThat
  # Special Characters for Links
  LINK_SPECIAL = %w([).freeze

  ##
  # Lexer module for links and embedded media
  #
  # This module deviates from standard MediaWiki in its use
  # of namespaces and support for media tags. It is not compliant
  # with the Wikimedia Foundation grammar.
  #
  # @author Bryan T. Meyers
  ##
  module Links
    ##
    # Lex any link , internal or external
    ##
    def lex_link
      start = read_matching(LINK_SPECIAL)
      append Token.new(:link_start, start)

      until end? or match?(BREAK_SPECIAL)
        lex_text(%w(: | ]))
        case current
          when ':'
            value = ''
            if !@result.last.nil? and @result.last.type == :text
              value = @result.pop.value
            end
            append Token.new(:link_namespace, value)
            advance
          when '|'
            append Token.new(:link_attribute)
            advance
          when ']'
            close = read_matching(%w(]))
            append Token.new(:link_end, close)
            return
        end
      end
    end
  end
end
