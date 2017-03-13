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
  # Helpers contains useful logic functions to be used by Lexer modules
  # @author Bryan T. Meyers
  ##
  module Helpers

    ##
    # Determine if the current character matches any in a list
    # @param [Array] chars a list of characters to check
    # @return [Boolean] True iff the current character is in the list
    ##
    def match?(chars)
      if end?
        return false
      end
      chars.each do |char|
        if current == char
          return true
        end
      end
      false
    end

    ##
    # Determine if the current character does not match any in a list
    # @param [Array] chars a list of characters to check
    # @return [Boolean] True iff the current character is not in the list
    ##
    def not_match?(chars)
      if end?
        return false
      end
      chars.each do |char|
        if current == char
          return false
        end
      end
      true
    end

  end
end