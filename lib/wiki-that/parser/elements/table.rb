module WikiThat
  module Table

    def self.parse_attributes(doc,i)
      buff = ''
      while i != doc.length && doc[i] != "\n"
        buff += doc[i]
        i += 1
      end
      if i != doc.length
        buff += doc[i]
        i += 1
      end
      attrs = buff.scan(/\w+=".*?"/)
      if attrs.length > 0
        attrs = ' ' + attrs.join(' ')
      end
      [i,buff,attrs]
    end

    def self.parse_caption(doc,i)

    end

    def parse_table
      table = '<table'
      buff = '' + doc[i]
      i += 1
      if doc[i] != '|'
        return [i,buff]
      end
      buff += doc[i]
      i += 1
      i,pbuff,attrs = parse_attributes(doc,i)
      buff += pbuff
      table += "#{attrs}>"
      i,pbuff,ptab = parse_caption(doc,i)
      buff += pbuff
      if ptab.length > 0
        table += ptab
      end
    end
  end
end