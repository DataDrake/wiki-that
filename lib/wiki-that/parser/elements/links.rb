require_relative('links/audio')
require_relative('links/image')
require_relative('links/video')

module WikiThat
  module Links

    IMAGE_PROPERTIES = %w(border frame left right center thumb thumbnail)

    def parse_internal
      buff = '[['
      advance
      link = ''
      attrs = []
      namespace = nil
      # Parse Link or Namespace
      while not_match?(']', "\n", '|', ':')
        buff += current
        link += current
        advance
      end
      if end? || match?("\n")
        append buff
        return
      end
      # If namespace, continue parsing link
      if match? ':'
        buff += current
        advance
        namespace = link
        link = ''
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
      if end? || match?("\n")
        append buff
        return
      end
      # Fail if not at the end of inner link
      buff += current
      if not_match? ']'
        advance
        append buff
        return
      end
      advance
      if end?
        append buff
        return
      end
      # Fail if not at the end of outer link
      if not_match? ']'
        append buff
        return
      end
      advance
      # Decide how to handle the link
      if WikiThat.sub_url && link[0] == '/'
        link = WikiThat.sub_url + link
      end
      if WikiThat.default_namespace
        link = WikiThat.default_namespace + '/' + link
      end
      if WikiThat.base_url
        link = WikiThat.base_url + '/' + link
      end
      case namespace
        when 'Audio'
          append WikiThat::Links::Audio.generate(link,attrs)
        when 'Image'
          append WikiThat::Links::Image.generate(link,attrs)
        when 'Video'
          append WikiThat::Links::Video.generate(link,attrs)
        else
          append "<a href='#{link}'>#{attrs.last}</a>"
      end
    end

    def parse_link
      buff = current
      advance
      if match? '['
        parse_internal
        return
      end
      link = ''
      alt = ''
      while not_match?(']', "\n", '|')
        buff += current
        link += current
        advance
      end
      if end?
        append buff
        return
      end
      buff += current
      if match? '|'
        advance
        while not_match?(']', "\n")
          alt += current
          advance
        end
      end
      buff += current
      if not_match?(']')
        advance
        append buff
        return
      end
      advance
      append "<a href='#{link}'>#{alt}</a>"

      next_state :inline_text
    end
  end
end