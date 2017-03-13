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
require_relative('links/audio')
require_relative('links/image')
require_relative('links/video')

module WikiThat
  ##
  # Lexer module for links and embedded media
  #
  # This module deviates from standard MediaWiki in its use
  # of namespaces and support for media tags. It is not compliant
  # with the Wikimedia Foundation grammar.
  #
  # @author Bryan T. Meyers
  ##
  module Links

    # Property attributes for images
    IMAGE_ATTRIBUTES = %w(border frame left right center thumb thumbnail)

    ##
    # Parse the current text as a link to content in a namespace
    ##
    def parse_internal
      advance
    end

    ##
    # Parse any link , internal or external
    ##
    def parse_link
      if current.value > 1
        parse_internal
      end
      advance
      url = ''
      while match? [:link_namespace,:text]
        if match? [:link_namespace]
          url += ':'
        else
          url += current.value
        end
        advance
      end
      unless match? [:link_end] and current.value == 1
        warning 'External link not closed by "]"'
        return Element.new(:text,"[#{url}")
      end
      advance
      anchor = Element.new(:a)
      url = url.split(' ')
      anchor.set_attribute(:href, url[0])
      if url.length > 2
        anchor.set_attribute(:alt, url[1...url.length].join(' '))
      elsif url.length == 2
        anchor.set_attribute(:alt, url[1])
      end
      anchor
    end
  end
end