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
    # Generator for Img tags
    # @author Bryan T. Meyers
    ##
    module Image
      ##
      # Create an img tag from the pre-parsed link data
      # @param [String] link the URL for the img source
      # @param [String] attrs the attributes for this img tag
      # @return [String] the generated tag
      ##
      def self.generate(link, attrs)
        if attrs.length > 0
          final   = '</div>'
          classes = []
          width   = nil
          attrs.each do |a|
            if IMAGE_PROPERTIES.include? a
              classes.push(a)
            end
            if a =~ /\d+px/
              width = a
            end
          end
          attrs -= classes
          if classes.include?('frame') || classes.include?('thumb') || classes.include?('thumbnail')
            final = "<caption>#{attrs.last}</caption>" + final
          end
          img = "<img src='#{link}'"
          if width
            img += " width='#{width}'"
          end
          img += '>'
          if classes.include?('thumb') || classes.include?('thumbnail')
            img = "<a href='#{link}'>#{img}</a>"
          end
          final = img + final
          if classes.length > 0
            "<div class='#{classes.join(' ')}'>" + final
          else
            '<div>' + final
          end
        else
          "<img src='#{link}'>"
        end
      end
    end
  end
end