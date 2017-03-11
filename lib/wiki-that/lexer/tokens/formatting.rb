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
  ##
  # Lexer module for inline formatting
  # @author Bryan T. Meyers
  ##
  module Formatting
    ##
    # Lex the current text as inline formatting
    ##
    def lex_formatting
      #Read opening marks
      count = 0
      while match? "'"
        count += 1
        advance
      end

      case count
        when 0
          error 'Format count should never be zero'
          nil
        when 1
          rewind
          nil
        else
          Token.new(:format,count)
      end
    end
  end
end