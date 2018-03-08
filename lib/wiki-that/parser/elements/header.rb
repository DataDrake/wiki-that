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
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
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
      if not_match? :header_end
        result.push(Element.new(:text, start.value), *content)
        warning 'Incomplete Header Parsed'
        return result
      end
      finish = current
      advance
      post = parse_inline

      if post.length >= 1
        post.each do |entry|
          unless entry.type == :text && entry.value.match(/^\s*$/)
            result.push(Element.new(:text, start.value), *content)
            result.push(Element.new(:text, finish.value), *post)
            error 'Only trailing whitespace characters are allowed on the same line as a header'
            return result
          end
        end
      end
      depth = finish.value.length
      if start.value.length < depth
        warning 'Unbalanced header tags found'
        depth  = start.value.length
      end

      header = Element.new("h#{depth}".to_sym)
      header.set_attribute(:id, content.first.value.strip.tr(' ', '_'))
      header.add_children(*content)
      header
    end
  end
end
