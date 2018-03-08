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
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
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
      # Just a plain image link
      return e if attrs.empty?

      # This link may need a wrapping div
      wrapper = Element.new(:figure)
      classes = attrs & IMAGE_ATTRIBUTES
      width   = nil
      attrs.each do |a|
        width = a if a =~ /\d+px/
      end
      # Set class attribute
      wrapper.set_attribute(:class, classes.join(' ')) unless classes.empty?
      attrs -= classes
      # Set width attribute
      if width
        attrs.delete(width)
        e.set_attribute(:width, width.sub('px', ''))
      end
      # Add alt text if available
      e.set_attribute(:alt, attrs.last) unless attrs.empty?
      warning 'Ignoring all but the last attribute' if attrs.length > 1
      # If no other classes, this doesn't need a wrapping div
      return e if classes.empty?
      # Build the wrapper
      wrapper.add_child(e)
      # Add a caption element if needed
      if (%w(frame thumb thumbnail) - classes).length != 3
        caption = Element.new(:figcaption)
        caption.add_child(Element.new(:text, attrs.last))
        wrapper.add_child(caption)
      end
      wrapper
    end
  end
end
