module WikiThat
  module Formatting
    def self.parse(doc,i)
      start_count = 0
      buff = ''
      while doc[i] == '\''
        buff += doc[i]
        start_count += 1
        i += 1
      end
      if start_count < 2
        return [i,buff]
      end
      i,part = WikiThat::Text.parse(doc,i)
      buff += part
      if doc[i] != '\''
        return [i,buff]
      end
      end_count = 0
      while doc[i] == '\''
        buff += doc[i]
        end_count += 1
        i += 1
      end
      if end_count < 2
        return [i,buff]
      end
      count = start_count < end_count ? start_count : end_count
      case count
        when 2
          [i, "<i>#{part}</i>"]
        when 3,4
          [i, "<b>#{part}</b>"]
        when 5
          [i, "<b><i>#{part}</i></b>"]
        else
          [i,buff]
      end
    end
  end
end