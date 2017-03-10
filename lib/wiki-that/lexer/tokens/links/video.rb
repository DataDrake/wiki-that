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
  module Links
    ##
    # Generator for Video tags
    # @author Bryan T. Meyers
    ##
    module Video
      ##
      # Create a video tag from the pre-parsed link data
      # @param [String] link the URL for the video source
      # @param [String] attrs the attributes for this video tag
      # @return [String] the generated tag
      ##
      def self.generate(link, attrs)
        "<video controls><source src='#{link}'></video>"
      end
    end
  end
end