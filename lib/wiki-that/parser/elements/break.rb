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
  # Parser module for handline line breaks
  # @author Bryan T. Meyers
  ##
  module Break
    ##
    # Parse the current text as a line break
    ##
    def parse_break
      count = 0

      #Find all consecutive newlines
      while match? "\n"
        count += 1
        advance
      end

      # Break if more than 1
      if count > 1
        next_state :break
      else
        next_state :line_start
      end
    end
  end
end