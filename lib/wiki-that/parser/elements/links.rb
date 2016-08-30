module WikiThat
  module Links

    @@handlers = {
        'Audio' => -> (namespace,link,attrs){
          "<audio controls><source src='#{link}'></audio>"
        },
        'Image' => -> (namespace,link,attrs){
          link = "<img src='#{link}'"
          link += '/>'
          if attrs.length > 0
            link = "<div class='captioned'>#{link}<caption>#{attrs.last}</caption></div>"
          end
          link
        },
        'Video' => -> (namespace,link,attrs){
          "<video controls><source src='#{link}'></video>"
        }
    }

    def self.register_namespace_handler(namespace,handler)
      @@handlers[namespace] = handler
    end

    def self.unregister_namespace_handler(namespace)
      @@handlers.delete(namespace)
    end

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
        while i != doc.length && doc[i] != ']' && doc[i] != "\n"
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
      if @@handlers[namespace]
        [i, @@handlers[namespace].call(namespace, link, attrs)]
      else
        [i,"<a href='#{link}'>#{attrs[0]}</a>"]
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