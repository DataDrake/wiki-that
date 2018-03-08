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
  # Parser module for MediaWiki Tables
  # @author Bryan T. Meyers
  ##
  module Table
    ##
    # Parse all K-V pairs on this line
    # @param [Element] elem the element to set the attributes on
    ##
    def parse_attributes(elem)
      if match? :text
        found = false
        current.value.scan(/(\w+)="([^"]*)"/) do |m|
          elem.set_attribute(m[0], m[1])
          found = true
        end
        advance if found
      end
      skip :break
      elem
    end

    ##
    # Parse a caption if it exists on this line
    # @param [Element] elem the table to add the caption to
    ##
    def parse_caption(elem)
      if match? :table_caption
        advance
        if not_match? :break
          p = parse_inline
          unless p.empty?
            caption = Element.new(:caption)
            caption.add_children(*p)
            elem.add_child(caption)
          end
        end
      end
      skip :break
      elem
    end

    ##
    # Parse a table row
    # @param [Element] elem the table to add the row to
    ##
    def parse_row(elem)
      case current.type
        when :table_row
          advance
          row = Element.new(:tr)
          row = parse_attributes(row)
          if match? :text
            whitespace = true
            current.value.each_char do |c|
              unless "\t ".include? c
                whitespace = false
                break
              end
            end
            advance if whitespace
          end
          skip :break
          row = parse_cells(row)
          elem.add_child(row)
        when :table_header, :table_data
          row = Element.new(:tr)
          row = parse_cells(row)
          elem.add_child(row)
      end
      elem
    end

    ##
    # Parse all the table cells on this row
    # @param [Element] row the row to add cells to
    ##
    def parse_cells(row)
      first = true
      while match?(:table_header, :table_data) || (first && !end?)
        cell = if match? :table_header
                 Element.new(:th)
               else
                 Element.new(:td)
               end
        if first
          if current.value == 2
            warning 'First cell on a new line should be "|" or "!" '
          end
          first = false
        elsif current.value != 2
          warning 'Inline cells should be "||" or "!!"'
        end
        advance if match?(:table_header, :table_data)
        cell = parse_attributes(cell)
        ## skip next tag since attributes were read
        advance if !cell.attributes.empty? && match?(:table_data, :table_header)
        contents = parse2(true)
        if contents.is_a? Array
          break if contents.empty?
          cell.add_children(*contents)
        else
          cell.add_child(contents)
        end
        advance(-1)
        first = true if match? :break
        advance
        ## Parse multi-line cell
        until end? || match?(:table_header, :table_data, :table_row, :table_end)
          if match? :break
            @line += current.value.length
            advance
            first = true
            redo
          end
          curr = @index
          p    = parse2(true)
          if p.nil? && (curr == @index)
            error 'Unable to continue parsing table. Is this actually MediaWiki?'
          end
          break if p.is_a?(Array) && p.empty?
          cell.add_child(p)
        end
        row.add_child(cell)
      end
      row
    end

    ##
    # Parse an entire table
    # @return [Element] the parsed table
    ##
    def parse_table
      advance
      table = Element.new(:table)
      table = parse_attributes(table)
      table = parse_caption(table)
      while match?(:table_row, :table_header, :table_data)
        table = parse_row(table)
      end
      if match? :table_end
        advance
      else
        warning 'Could not find end of table, missing "|}"'
      end
      table
    end
  end
end
