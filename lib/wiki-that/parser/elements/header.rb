##
# Copyright 2017 Bryan T. Meyers
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
      start = current
      advance
      content = parse_inline(:header_end)
      if not_match? [:header_end]
        buff = ''
        (0...start.value).each do
          buff += '='
        end
        append Element.new(:text,buff)
        content.each do |c|
          append c
        end
        warning 'Incomplete Header Parsed'
        return
      end
      finish = current
      advance
      post = parse_inline
      fail = false
      if post.length == 1
        if post[0].type == :text
          post[0].value.each_char do |c|
            unless " \n\t".include? c
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
        buff = ''
        (0...start.value).each do
          buff += '='
        end
        append Element.new(:text,buff)
        content.each do |c|
          append c
        end
        buff = ''
        (0...finish.value).each do
          buff += '='
        end
        append Element.new(:text,buff)
        post.each do |c|
          append c
        end
        error 'Only trailing whitespace characters are allowed on the same line as a header'
        return
      end
      depth = finish.value
      if finish.value > start.value
        depth = start.value
      end
      header = Element.new(:header,depth)
      header.add_children(*content)
      append header
    end
  end
end