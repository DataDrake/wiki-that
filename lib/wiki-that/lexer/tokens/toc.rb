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
require_relative('token')
module WikiThat
  TOC_SPECIAL = %w[_].freeze

  ##
  # Lexer module for handling Table of Contents
  # @author Bryan T. Meyers
  ##
  module TableOfContents
    ##
    # Lex the current text as a NOTOC
    ##
    def lex_toc
      start = read_matching(TOC_SPECIAL)
      if start.length != 2
        append Token.new(:text, start)
        return
      end

      case current
        when 'N'
          text = 'NOTOC'
        when 'T'
          text = 'TOC'
        else
          append Token.new(:text, start)
          return
      end
      buff = ''
      text.each_char do |c|
        unless current == c
          append Token.new(:text, start + buff)
          return
        end
        buff += current
        advance
      end

      close = read_matching(TOC_SPECIAL)
      if close.length != 2
        append Token.new(:text, start + buff + close)
        return
      end
      ## Read to the end fo the line. We want to remove this entirely
      advance until end? || match?(BREAK_SPECIAL)
    end
  end
end
