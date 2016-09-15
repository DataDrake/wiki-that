module WikiThat
  module Text

    def parse_inline(stop)
      buff = ''
      while not_match? stop
        buff += current
        advance
      end
      buff
    end

    def parse_paragraph(doc,i)
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