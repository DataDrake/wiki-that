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

  # Special characters for List elements
  LIST_SPECIAL = %w(* # : ;)

  ##
  # Lexer module for handling List elements
  # @author Bryan T. Meyers
  ##
  module List

    ##
    # Lex the current text as a list
    ##
    def lex_list
      buff = ''
      while match? LIST_SPECIAL
        buff += current
        advance
      end
      append Token.new(:list_item, buff)
    end
  end
end