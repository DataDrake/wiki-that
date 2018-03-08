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
    IMAGE_ATTRIBUTES = %w[border frame left right center thumb thumbnail].freeze

    ##
    # Handle special parsing of namespace links
    # @return [Element] the link itself
    ##
    def parse_namespace_link(namespaces, pieces, attributes, alt, url)
      case namespaces[0].capitalize
        when 'Audio'
          warning 'Ignoring all attributes' unless attributes.empty?
          pieces[1] = @media_base
          url       = pieces.join('/') + url
          parse_audio_link(url)
        when 'Image'
          pieces[1] = @media_base
          url       = pieces.join('/') + url
          parse_image_link(url, attributes)
        when 'Video'
          warning 'Ignoring all attributes' unless attributes.empty?
          pieces[1] = @media_base
          url       = pieces.join('/') + url
          parse_video_link(url)
        else
          url    = pieces.join('/') + url
          anchor = Element.new(:a)
          case attributes.length
            when 0
              if alt.empty? || alt.include?('/')
                anchor.add_child(Element.new(:text, url))
              else
                anchor.add_child(Element.new(:text, alt))
              end
            when 1
              anchor.add_child(Element.new(:text, attributes.last))
            else
              warning 'Ignoring all but the last link attribute'
              anchor.add_child(Element.new(:text, attributes.last))
          end
          anchor.set_attribute(:href, URI.escape(url))
          anchor
      end
    end

    ##
    # Read all of the link attribute tokens
    # @return [Array] list of attributes
    ##
    def parse_link_attributes
      attributes = []
      while match? :link_attribute
        advance
        attr = ''
        while match? :text
          attr += current.value
          advance
        end
        attributes.push(attr.strip) unless attr.empty?
      end
      attributes
    end

    ##
    # Read the URL and alt text
    # @return [Array] containing URL and alt text
    ##
    def parse_url_alt
      url = ''
      alt = ''
      if match? :text
        alt = current.value.strip
        if alt.start_with? '/'
          url += alt
          alt = ''
        else
          url = ''
        end
        advance
      end
      while match? :text
        alt += current.value.strip
        advance
      end
      url += alt
      [url, alt]
    end

    ##
    # Read all of the namespace tokens
    # @return [Array] list of namespaces
    ##
    def parse_namespaces
      namespaces = []
      while match? :link_namespace
        temp = current.value.strip
        if (temp == 'http') || (temp == 'https')
          warning 'External link in internal link brackets?'
        end
        namespaces.push(temp)
        advance
      end
      namespaces
    end

    ##
    # Parse the current text as a link to content in a namespace
    ##
    def parse_link_internal
      advance
      namespaces = parse_namespaces
      url, alt   = parse_url_alt
      attributes = parse_link_attributes

      if not_match?(:link_end) || (match?(:link_end) && (current.value.length != 2))
        warning 'Internal Link not terminated by "]]"'
        text = '[['
        text += namespaces.join(':') + ':' unless namespaces.empty?
        text += url
        text += '|' + attributes.join('|') unless attributes.empty?
        if match? :link_end
          text += current.value
          advance
        end
        return Element.new(:text, text)
      end
      advance
      pieces = ['']
      pieces.push(@base_url) if @base_url && !@base_url.empty?
      ns_index = namespaces.length - 1
      if ns_index > 1
        ns_index = 1
        warning 'Ignoring all but the first two namespaces'
      end
      if (ns_index == -1) || %w[Audio Image Video].include?(namespaces[ns_index].capitalize)
        if @default_namespace && !@default_namespace.empty?
          pieces.push(@default_namespace)
        end
      else
        pieces.push(namespaces[ns_index])
      end
      unless url.start_with? '/'
        if @sub_url && !@sub_url.empty?
          pieces.push(@sub_url)
        end
        pieces.push('')
      end

      if !namespaces.empty?
        parse_namespace_link(namespaces, pieces, attributes, alt, url)
      else
        anchor = Element.new(:a)
        if url.start_with? '#'
          url.tr!(' ', '_')
          anchor.set_attribute(:href, url)
        else
          url = pieces.join('/') + url
          anchor.set_attribute(:href, URI.escape(url))
        end
        case attributes.length
          when 0
            if alt.empty? || alt.include?('/')
              anchor.add_child(Element.new(:text, url))
            else
              anchor.add_child(Element.new(:text, alt))
            end
          when 1
            anchor.add_child(Element.new(:text, attributes.last))
          else
            warning 'Ignoring all but the last link attribute'
            anchor.add_child(Element.new(:text, attributes.last))
        end
        anchor
      end
    end

    ##
    # Parse any link , internal or external
    ##
    def parse_link
      return parse_link_internal if current.value.length > 1
      advance
      url = ''
      while match?(:link_namespace, :text)
        url += current.value
        url += ':' if match? :link_namespace
        advance
      end
      unless match?(:link_end) && (current.value.length == 1)
        warning 'External link not closed by "]"'
        return Element.new(:text, "[#{url}")
      end
      advance
      anchor = Element.new(:a)
      url    = url.split(' ')
      anchor.set_attribute(:href, URI.escape(url[0] ? url[0] : ''))
      if url.length > 2
        anchor.add_child(Element.new(:text, url[1...url.length].join(' ')))
      elsif url.length == 2
        anchor.add_child(Element.new(:text, url[1]))
      end
      anchor
    end
  end
end
