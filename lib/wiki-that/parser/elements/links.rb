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
    def parse_link_internal
      advance
      url        = ''
      namespaces = []
      while match? [:link_namespace]
        temp = current.value.strip
        if temp == 'http' or temp == 'https'
          warning 'External link in internal link brackets?'
        end
        namespaces.push(temp)
        advance
      end
      attributes = []
      alt = ''
      first = true
      while match? [:text]
        if first
          alt = current.value.strip
          if alt.start_with? '/'
            alt = ''
          end
          first = false
        else
          alt = ''
        end
        url += current.value.strip
        advance
      end
      while match? [:link_attribute]
        advance
        if match? [:text]
          attributes.push(current.value.strip)
          advance
        end
      end
      if not_match? [:link_end] or (match? [:link_end] and current.value != 2)
        warning 'Internal Link not terminated by "]]"'
        text = '[['
        if namespaces.length > 0
          text += namespaces.join(':') + ':'
        end
        text += url
        if attributes.length > 0
          text += '|' + attributes.join('|')
        end
        if match? [:link_end]
          (0...current.value).each do
            text += ']'
          end
          advance
        end
        return Element.new(:text, text)
      end
      advance
      pieces = ['']
      if @base_url and not @base_url.empty?
        pieces.push(@base_url)
      end
      case namespaces.length
        when 0
          ns_index = -1
        when 1
          ns_index = 0
        when 2
          ns_index = 1
        else
          ns_index = 1
          warning 'Ignoring all but the first two namespaces'
      end
      if ns_index == -1 or %w(Audio Image Video).include? namespaces[ns_index]
        if @default_namespace and not @default_namespace.empty?
          pieces.push(@default_namespace)
        end
      else
        pieces.push(namespaces[ns_index])
      end
      unless url.start_with? '/'
        if @sub_url and not @sub_url.empty?
          pieces.push(@sub_url, '')
        else
          pieces.push('')
        end
      end

      if namespaces.length > 0
        case namespaces[0]
          when 'Audio'
            if attributes.length > 0
              warning 'Ignoring all attributes'
            end
            pieces[1] = @media_base
            url = pieces.join('/') + url
            parse_audio_link(url)
          when 'Image'
            pieces[1] = @media_base
            url = pieces.join('/') + url
            parse_image_link(url, attributes)
          when 'Video'
            if attributes.length > 0
              warning 'Ignoring all attributes'
            end
            pieces[1] = @media_base
            url = pieces.join('/') + url
            parse_video_link(url)
          else
            url = pieces.join('/') + url
            anchor = Element.new(:a)
            case attributes.length
              when 0
                if alt.empty? or alt.include? '/'
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
            anchor.set_attribute(:href, url)
            anchor
        end
      else
        url = pieces.join('/') + url
        anchor = Element.new(:a)
        anchor.set_attribute(:href, url)
        case attributes.length
          when 0
            if alt.empty? or alt.include? '/'
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
      if current.value > 1
        return parse_link_internal
      end
      advance
      url = ''
      while match? [:link_namespace, :text]
        url += current.value
        if match? [:link_namespace]
          url += ':'
        end
        advance
      end
      unless match? [:link_end] and current.value == 1
        warning 'External link not closed by "]"'
        return Element.new(:text, "[#{url}")
      end
      advance
      anchor = Element.new(:a)
      url    = url.split(' ')
      anchor.set_attribute(:href, url[0])
      if url.length > 2
        anchor.add_child(Element.new(:text, url[1...url.length].join(' ')))
      elsif url.length == 2
        anchor.add_child(Element.new(:text, url[1]))
      end
      anchor
    end
  end
end