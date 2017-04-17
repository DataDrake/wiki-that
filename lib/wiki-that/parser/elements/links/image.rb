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
    # Create an img tag from the pre-parsed link data
    # @param [String] link the URL for the img source
    # @param [String] attrs the attributes for this img tag
    # @return [String] the generated tag
    ##
    def parse_image_link(link, attrs)
      e = Element.new(:img)
      e.set_attribute(:src, URI.escape(link))
      if attrs.length > 0
        classes = []
        width   = nil
        attrs.each do |a|
          if IMAGE_ATTRIBUTES.include? a
            classes.push(a)
          end
          if a =~ /\d+px/
            width = a
          end
        end
        wrapper = Element.new(:figure)
        if classes.length > 0
          wrapper.set_attribute(:class, classes.join(' '))
        end
        if width
          attrs -= [width]
          e.set_attribute(:width, width.sub('px',''))
        end
        attrs -= classes
        if attrs.length > 1
          warning 'Ignoring all but the last attribute'
          e.set_attribute(:alt, attrs.last)
        elsif attrs.length > 0
          e.set_attribute(:alt, attrs.last)
        end
        if classes.empty?
          return e
        end
        wrapper.add_child(e)
        if classes.include?('frame') || classes.include?('thumb') || classes.include?('thumbnail')
          caption = Element.new(:figcaption)
          caption.add_child(Element.new(:text, attrs.last))
          wrapper.add_child(caption)
        end
        wrapper
      else
        e
      end
    end
  end
end