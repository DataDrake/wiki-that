require_relative('../../../../lib/wiki-that/wiki-that')

module WikiThat
  module Header

    def self.read_tag(doc,i)
      start_depth = 0
      start_buff = ''
      while i != doc.length && doc[i] == '='
        start_buff += doc[i]
        start_depth += 1
        i += 1
      end
      [i,start_depth,start_buff]
    end

    def self.read_inner(doc,i)
      inner_buff = ''
      while i != doc.length
        i,partial = WikiThat::Text.parse(doc,i,'=')
        inner_buff += partial
        if (i+1) == doc.length || doc[i+1] == '='
          break
        end
      end
      [i,inner_buff]
    end

    def self.parse(doc,i)

      # Read Start Tag
      i,start_depth,start_buff = read_tag(doc,i)
      printf("%i: %s \n", start_depth, start_buff)
      # Fail if not a header or no whitespace after Tag
      if start_depth == 1 || i == doc.length || !WikiThat.is_whitespace(doc[i])
        return i,start_buff
      end

      # Get inner text, stopping at first '==' or '\n'
      i,inner_buff = read_inner(doc,i)
      printf("%i: %s \n", i, inner_buff)
      # Fail if no chance of closing Tag
      if i == doc.length || doc[i] != '='
        return i, start_buff+inner_buff
      end

      # Read inner tag
      end_depth,end_buff = read_tag(doc,i)

      # Get outer text, stopping at '\n'
      i,outer_buff = WikiThat::Text.parse(doc,i)

      # Fail if end Tag is not end Tag
      if end_depth < 2
        return i, start_buff+inner_buff+end_buff+outer_buff
      end

      # return a header with the lower depth as the header level
      if start_depth > end_depth
        return i,"<h#{end_depth}>#{inner_buff}</h#{end_depth}>#{outer_buff}"
      end
      return i,"<h#{start_depth}>#{inner_buff}</h#{start_depth}>#{outer_buff}"
    end
  end
end