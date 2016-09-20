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
        error 'Warning: Incomplete internal link'
        return buff
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
        error 'Warning: Incomplete internal link'
        return buff
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
      # Fail if not at the end of outer link
      if not_match? ']'
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
          WikiThat::Links::Audio.generate(link,attrs)
        when 'Image'
          WikiThat::Links::Image.generate(link,attrs)
        when 'Video'
          WikiThat::Links::Video.generate(link,attrs)
        else
          "<a href='#{link}'>#{attrs.last}</a>"
      end
    end

    def parse_link
      buff = current
      advance
      if match? '['
        return parse_internal
      end
      link = ''
      alt = ''
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
      buff += current
      if not_match?(']')
        advance
        error 'Warning: Incomplete external link'
        return buff
      end
      advance

      next_state :inline_text
      "<a href='#{link}'>#{alt}</a>"
    end

    def parse_link_line
      append parse_link
      next_state :line_start
    end
  end
end