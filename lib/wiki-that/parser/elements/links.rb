require_relative('links/audio')
require_relative('links/image')
require_relative('links/video')

module WikiThat
  module Links

    IMAGE_PROPERTIES = %w(border frame left right center thumb thumbnail)

    def parse_internal
      buff = '[['
      @index += 1
      link = ''
      attrs = []
      namespace = nil
      # Parse Link or Namespace
      while not_match?(']', "\n", '|', ':')
        buff += @doc[@index]
        link += @doc[@index]
        @index += 1
      end
      if @index == @doc.length || match?("\n")
        @result += buff
        return
      end
      # If namespace, continue parsing link
      if match? ':'
        buff += @doc[@index]
        @index += 1
        namespace = link
        link = ''
        while not_match?(']', "\n", '|')
          buff += @doc[@index]
          link += @doc[@index]
          @index += 1
        end
      end
      # Parse attributes
      while match? '|'
        buff += @doc[@index]
        @index += 1
        attr = ''
        while not_match?(']', "\n", '|')
          buff += @doc[@index]
          attr += @doc[@index]
          @index += 1
        end
        attrs.push(attr)
      end
      if @index == @doc.length || match?("\n")
        @result += buff
        return
      end
      # Fail if not at the end of inner link
      buff += @doc[@index]
      if not_match? ']'
        @index += 1
        @result += buff
        return
      end
      @index += 1
      if @index == @doc.length
        @result += buff
        return
      end
      # Fail if not at the end of outer link
      if not_match? ']'
        @result += buff
        return
      end
      @index += 1
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
          @result += WikiThat::Links::Audio.generate(link,attrs)
        when 'Image'
          @result += WikiThat::Links::Image.generate(link,attrs)
        when 'Video'
          @result += WikiThat::Links::Video.generate(link,attrs)
        else
          @result += "<a href='#{link}'>#{attrs.last}</a>"
      end
    end

    def parse_link
      buff = @doc[@index]
      @index += 1
      if match? '['
        return parse_internal(doc,i)
      end
      link = ''
      alt = ''
      while not_match?(']', "\n", '|')
        buff += @doc[@index]
        link += @doc[@index]
        @index += 1
      end
      if @index == doc.length
        @result += buff
        return
      end
      buff += @doc[@index]
      if match? '|'
        @index += 1
        while not_match?(']', "\n")
          alt += @doc[@index]
          @index += 1
        end
      end
      buff += @doc[@index]
      if not_match?(']')
        @index += 1
        @result += buff
        return
      end
      @index += 1
      @result += "<a href='#{link}'>#{alt}</a>"
    end
  end
end