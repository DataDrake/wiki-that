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
  ##
  # Lexer module for handling headers
  # @author Bryan T. Meyers
  ##
  module Header
    ##
    # Parse the current line as a header
    ##
    def parse_header
      #Read start sequence
      buff        = ''
      start_level = 0
      while match? '='
        buff        += '='
        start_level += 1
        advance
      end

      if start_level < 2
        rewind
        append parse_inline("\n")
        return
      end

      #Read inner content
      end_level = 0
      content   = ''
      while not_match? "\n"
        while match? '='
          buff      += current
          end_level += 1
          advance
        end
        if end_level >= 2
          break
        end
        part      = parse_inline('=')
        buff      += part
        content   += part
        end_level = 0
      end

      if end_level < 2
        error 'Warning: Incomplete header'
        append buff
        return
      end

      #Read the rest of the line
      while not_match? "\n"
        buff += current
        unless whitespace? current
          @state = :header_fail
        end
        advance
      end

      #Fail if it wasn't all whitespace
      if @state == :header_fail
        error "Warning: Text after header not allowed on same line"
        append buff
        return
      end

      #Produce output
      level = start_level > end_level ? end_level : start_level
      append "<h#{level}>#{content}</h#{level}>"

      next_state :break
    end
  end
end