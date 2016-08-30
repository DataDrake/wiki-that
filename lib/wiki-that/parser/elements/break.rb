module WikiThat
  module Break
    def self.parse(doc,i)
      buff = doc[i]
      i += 1
      if i != doc.length && doc[i] == "\n"
        return [i,'<br/>']
      end
      [i,buff]
    end
  end
end