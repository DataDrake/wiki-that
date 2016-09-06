require_relative('links/audio')
require_relative('links/image')
require_relative('links/video')

module WikiThat
  module Links

    IMAGE_PROPERTIES = %w(border frame left right center thumb thumbnail)

    def self.parse_internal(doc,i)
      buff = '[['
      i += 1
      link = ''
      attrs = []
      namespace = nil
      # Parse Link or Namespace
      while i != doc.length && doc[i] != ']' && doc[i] != "\n" && doc[i] != '|' && doc[i] != ':'
        buff += doc[i]
        link += doc[i]
        i += 1
      end
      if i == doc.length || i == "\n"
        return [i,buff]
      end
      # If namespace, continue parsing link
      if doc[i] == ':'
        buff += doc[i]
        i += 1
        namespace = link
        link = ''
        while i != doc.length && doc[i] != ']' && doc[i] != "\n" && doc[i] != '|'
          buff += doc[i]
          link += doc[i]
          i += 1
        end
      end
      # Parse attributes
      while doc[i] == '|'
        buff += doc[i]
        i += 1
        attr = ''
        while i != doc.length && doc[i] != ']' && doc[i] != "\n" && doc[i] != '|'
          doc += doc[i]
          attr += doc[i]
          i += 1
        end
        attrs.push(attr)
      end
      if i == doc.length || i == "\n"
        return [i,buff]
      end
      # Fail if not at the end of inner link
      buff += doc[i]
      if doc[i] != ']'
        i += 1
        return [i,buff]
      end
      i += 1
      if i == doc.length
        return [i,buff]
      end
      # Fail if not at the end of outer link
      if doc[i] != ']'
        return [i,buff]
      end
      i += 1
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
          [i,WikiThat::Links::Audio.generate(link,attrs)]
        when 'Image'
          [i,WikiThat::Links::Image.generate(link,attrs)]
        when 'Video'
          [i,WikiThat::Links::Video.generate(link,attrs)]
        else
          [i,"<a href='#{link}'>#{attrs.last}</a>"]
      end
    end

    def self.parse(doc,i)
      buff = doc[i]
      i += 1
      if doc[i] == '['
        return parse_internal(doc,i)
      end
      link = ''
      alt = ''
      while i != doc.length && doc[i] != ']' && doc[i] != "\n" && doc[i] != '|'
        buff += doc[i]
        link += doc[i]
        i += 1
      end
      if i == doc.length
        return [i,buff]
      end
      buff += doc[i]
      if doc[i] == '|'
        i += 1
        while i != doc.length && doc[i] != ']' && doc[i] != "\n"
          alt += doc[i]
          i += 1
        end
      end
      buff += doc[i]
      if doc[i] != ']'
        i += 1
        return [i,buff]
      end
      i += 1
      [i,"<a href='#{link}'>#{alt}</a>"]
    end
  end
end