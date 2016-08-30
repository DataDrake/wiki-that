require_relative('parser/parser')
module WikiThat
  VERSION = '0.0.1'

  def self.is_whitespace(c)
    c == ' ' || c == "\t"
  end

  def self.is_special_char(c)
    c =~ /[*#;:`-]/
  end

end