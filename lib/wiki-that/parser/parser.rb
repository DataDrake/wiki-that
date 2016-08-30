require_relative('elements/break')
require_relative('elements/header')
require_relative('elements/links')
require_relative('elements/list')
require_relative('elements/text')
module WikiThat
  module Parser
    def self.parse(doc,i = 0)
      output = ''
      while i != doc.length
        case doc[i]
          when '='
            i,partial = WikiThat::Header.parse(doc,i)
          when '['
            i,partial = WikiThat::Links.parse(doc, i)
          when '*', '#', ';', '-'
            i,partial = WikiThat::List.parse(doc,i)
          when '{'
            i,partial = WikiThat::Table.parse(doc,i)
          when "\n"
            i,partial = WikiThat::Break.parse(doc,i)
          else
            print(doc[i])
            i,partial = WikiThat::Paragraph.parse(doc,i)
        end
        if partial.length > 0
          output += partial
        end
      end
      [i,output]
    end
  end
end