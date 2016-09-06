require_relative('parser/parser')
module WikiThat
  VERSION = '0.0.1'

  class << self
    attr_accessor :base_url
    attr_accessor :default_namespace
    attr_accessor :sub_url
  end

  def self.is_whitespace(c)
    c == ' ' || c == "\t"
  end

  def self.is_special_char(c)
    c =~ /[*#;:'=\-\[]/
  end

end