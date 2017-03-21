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
#	See the License for the specific language governing permissions and
#	limitations under the License.
##
module WikiThat
  ##
  # Parser module for MediaWiki Tables
  # @author Bryan T. Meyers
  ##
  module Table

    def parse_attributes(elem)
      if match? [:text]
        found = false
        current.value.scan(/(\w+)="(\S+?)"/) do |m|
          elem.set_attribute(m[0],m[1])
          found = true
        end
        if found
          advance
        end
      end
      elem
    end

    def parse_caption(elem)
      if match? [:table_caption]
        advance
        if match? [:text]
          caption = Element.new(:caption)
          caption.add_child(Element.new(:text,current.value))
          elem.add_child(caption)
          advance
        end
      end
      elem
    end

    def parse_row(elem)
      case current.type
        when :table_row
          advance
          row = Element.new(:tr)
          row = parse_attributes(row)
          if match? [:break]
            advance
          end
          row = parse_cells(row)
          elem.add_child(row)
        when :table_header, :table_data
          row = Element.new(:tr)
          row = parse_cells(row)
          elem.add_child(row)
      end
      elem
    end

    def parse_cells(row)
      first = true
      while match? [:table_header,:table_data]
        if match? [:table_header]
          cell = Element.new(:th)
        else
          cell = Element.new(:td)
        end
        if first
          if current.value == 2
            warning 'First cell on a new line should be "|" or "!" '
          end
          first = false
        end
        advance
        cell = parse_attributes(cell)
        if cell.attributes.length > 0
          advance
        end
        contents = parse_inline
        puts contents.inspect
        if contents.length > 0
          cell.add_children(*contents)
        end
        if match? [:break]
          advance
          first = true
        end
        until match? [:table_header,:table_data,:table_row, :table_end]
          p = parse_text
          if p.children.length == 0
            break
          end
          cell.add_child(p)
        end
        row.add_child(cell)
      end
      row
    end

    def parse_table
      advance
      table = Element.new(:table)
      table = parse_attributes(table)
      if match? [:break]
        advance
      end
      table = parse_caption(table)
      while not end? and match? [:table_row,:table_header,:table_data]
        table = parse_row(table)
      end
      if match? [:table_end]
        advance
      else
        warning 'Could not find end of table, missing "|}"'
      end
      append table
    end
  end
end