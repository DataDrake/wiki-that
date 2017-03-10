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
    IMAGE_PROPERTIES = %w(border frame left right center thumb thumbnail)

    ##
    # Parse the current text as a link to content in a namespace
    ##
    def parse_internal
      buff = '[['
      advance
      link      = ''
      attrs     = []
      namespace = nil
      # Parse Link or Namespace
      while not_match?(']', "\n", '|', ':')
        buff += current
        link += current
        advance
      end
      if end? || match?("\n")
        error 'Warning: Incomplete internal link'
        return buff
      end
      # If namespace, continue parsing link
      if match? ':'
        buff += current
        advance
        namespace = link
        link      = ''
        while not_match?(']', "\n", '|')
          buff += current
          link += current
          advance
        end
      end
      # Parse attributes
      while match? '|'
        buff += current
        advance
        attr = ''
        while not_match?(']', "\n", '|')
          buff += current
          attr += current
          advance
        end
        attrs.push(attr)
      end
      # Fail if not at the end of inner link
      buff += current
      if not_match? ']'
        advance
        error 'Warning: Incomplete internal link'
        return buff
      end
      advance
      if end?
        error 'Warning: Incomplete internal link'
        return buff
      end
      buff += current
      # Fail if not at the end of outer link
      if not_match? ']'
        advance
        error 'Warning: Incomplete internal link'
        return buff
      end
      advance
      # Decide how to handle the link
      if link[0] == '/'
        link = @base_url + '/' + @default_namespace + link
      else
        link = @base_url + '/' + @default_namespace + '/' + @sub_url + '/' + link
      end
      case namespace
        when 'Audio'
          WikiThat::Links::Audio.generate(link, attrs)
        when 'Image'
          WikiThat::Links::Image.generate(link, attrs)
        when 'Video'
          WikiThat::Links::Video.generate(link, attrs)
        else
          "<a href='#{link}'>#{attrs.last}</a>"
      end
    end

    ##
    # Parse any link , internal or external
    ##
    def parse_link
      buff = current
      advance
      if match? '['
        return parse_internal
      end
      link = ''
      alt  = ''
      while not_match?(']', "\n", '|')
        buff += current
        link += current
        advance
      end
      if end?
        error 'Warning: Incomplete external link'
        return buff
      end
      buff += current
      if match? '|'
        advance
        while not_match?(']', "\n")
          alt += current
          advance
        end
      end
      if not_match?(']') or end?
        buff += current
        advance
        error 'Warning: Incomplete external link'
        return buff+alt
      end
      advance

      next_state :inline_text
      "<a href='#{link}'>#{alt}</a>"
    end

    ##
    # Parse the current link as a link
    ##
    def parse_link_line
      append parse_link
      next_state :line_start
    end
  end
end