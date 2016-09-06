module WikiThat
  module Links
    module Image
      def self.generate(link,attrs)
        if attrs.length > 0
          final = '</div>'
          classes = []
          width = nil
          attrs.each do |a|
            if IMAGE_PROPERTIES.include? a
              classes.push(a)
            end
            if a =~ /\d+px/
              width = a
            end
          end
          attrs -= classes
          if classes.include?('frame') || classes.include?('thumb') || classes.include?('thumbnail')
            final = "<caption>#{attrs.last}</caption>" + final
          end
          img = "<img src='#{link}'"
          if width
            img += " width='#{width}'"
          end
          img += '>'
          if classes.include?('thumb') || classes.include?('thumbnail')
            img = "<a href='#{link}'>#{img}</a>"
          end
          final = img + final
          if classes.length > 0
            "<div class='#{classes.join(' ')}'>" + final
          else
            '<div>' + final
          end
        else
          "<img src='#{link}'>"
        end
      end
    end
  end
end