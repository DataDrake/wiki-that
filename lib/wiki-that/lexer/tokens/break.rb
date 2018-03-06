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
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
##
require_relative('token')
module WikiThat

  # Special characters for break tags
  BREAK_SPECIAL = %W(\n \r)
  ##
  # Lexer module for handling line breaks
  # @author Bryan T. Meyers
  ##
  module Break
    ##
    # Lex the current text as a line break
    ##
    def lex_break
      buff = read_matching(BREAK_SPECIAL)
      append Token.new(:break, buff)
    end
  end
end