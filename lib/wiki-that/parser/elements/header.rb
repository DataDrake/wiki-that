##
# Copyright 2017-2018 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permisssions and
#	limitations under the License.
##

module WikiThat
  ##
  # Lexer module for handling headers
  # @author Bryan T. Meyers
  ##
  module Header
    ##
    # Parse the current line as a header
    ##
    def parse_header
      result = []
      start  = current
      advance
      content = parse_inline(:header_end)
      if not_match? [:header_end]
        result.push(Element.new(:text, start.value))
        content.each do |c|
          result.push(c)
        end
        warning 'Incomplete Header Parsed'
        return result
      end
      finish = current
      advance
      post = parse_inline
      fail = false
      if post.length == 1
        if post[0].type == :text
          post[0].value.each_char do |c|
            unless " \t".include? c
              fail = true
              break
            end
          end
        else
          fail = true
        end
      elsif post.length > 1
        fail = true
      end
      if fail
        result.push(Element.new(:text, start.value))
        content.each do |c|
          result.push(c)
        end
        result.push(Element.new(:text, finish.value))
        post.each do |c|
          result.push(c)
        end
        error 'Only trailing whitespace characters are allowed on the same line as a header'
        return result
      end
      depth = finish.value.length
      if start.value.length != finish.value.length
        warning 'Unbalanced header tags found'
      end
      if finish.value.length > start.value.length
        depth = start.value.length
      end
      header = Element.new("h#{depth}".to_sym)
      header.set_attribute(:id, content.first.value.strip.gsub(' ','_'))
      header.add_children(*content)
      header
    end
  end
end