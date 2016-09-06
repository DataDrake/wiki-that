module WikiThat
  module Links
    module Video
      def self.generate(link,attrs)
        "<video controls><source src='#{link}'></video>"
      end
    end
  end
end