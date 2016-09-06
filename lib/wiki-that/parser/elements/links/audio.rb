module WikiThat
  module Links
    module Audio
      def self.generate(link,attrs)
        "<audio controls><source src='#{link}'></audio>"
      end
    end
  end
end