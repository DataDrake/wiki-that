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
module WikiThat
  ##
  # Tokens are typed data found by a Lexer
  # @author Bryan T. Meyers
  ##
  class Token

    ##
    # Create a new token
    #
    # @param [Symbol] type the type for this Token
    # @param [Object] value optional value for this Token
    # @return [Token] a newly created Token
    def initialize(type, value = nil)
      @type  = type
      @value = value
    end

    attr_reader :type, :value

  end
end