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
    # Create a video element from tokens
    # @param [String] link the URL for the audio source
    # @return [Element] the generated element
    ##
    def parse_video_link(link)
      e = Element.new(:video)
      e.set_attribute(:controls,true)
      e.set_attribute(:src,link)
      e
    end
  end
end