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
require_relative('token')
module WikiThat

  TOC_SPECIAL = %w(_)

  ##
  # Lexer module for handling Table of Contents
  # @author Bryan T. Meyers
  ##
  module TableOfContents
    ##
    # Lex the current text as a line break
    ##
    def lex_toc
      buff = ''
      count = 0
      #Find all consecutive newlines
      while match? TOC_SPECIAL
        buff += current
        count += 1
        advance
      end
      if count != 2
        append Token.new(:text, buff)
        return
      end

      'NOTOC'.each_char do |c|
        unless current == c
          append Token.new(:text, buff)
          return
        end
        buff += current
        advance
      end

      count = 0
      #Find all consecutive newlines
      while match? TOC_SPECIAL
        buff += current
        count += 1
        advance
      end
      if count != 2
        append Token.new(:text, buff)
        return
      end
      ## Read to the end fo the line. We want to remove this entirely
      until end? or match? ["\n"]
        advance
      end
      if match? ["\n"]
        advance
      end
    end
  end
end