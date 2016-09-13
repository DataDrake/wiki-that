module WikiThat
  module Text
    def self.parse(doc,i)
      buff = ''
      broken = false
      while i != doc.length && doc[i] != "\n" && !WikiThat.special_char?(doc[i])
        buff += doc[i]
        i += 1
      end
      if doc[i] == "\n"
        i,br = WikiThat::Break.parse(doc,i)
        if br.length > 1
          buff += br
          broken = true
        end
      end
      [i,buff,broken]
    end
  end
end