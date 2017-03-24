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
  # Elements are precursors to the final document elements
  # @author Bryan T. Meyers
  ##
  class Element

    ##
    # Create a new element
    #
    # @param [Symbol] type the type for this Element
    # @param [Object] value optional value for this Element
    # @return [Element] a newly created Element
    def initialize(type, value = nil)
      @attributes = {}
      @children   = []
      @type       = type
      @value      = value
    end

    attr_reader :attributes, :children, :type
    attr_accessor :value

    ##
    # Set an attribute for this element
    #
    # @param [String] name the name of the attribute
    # @param [String] value the string value of the attribute
    ##
    def set_attribute(name, value)
      @attributes[name] = value
    end

    ##
    # Add a child element to this element
    #
    # @param [Element] child the child element
    ##
    def add_child(child)
      @children.push(child)
    end

    ##
    # Add multiple child elements to this element
    #
    # @param [Element] children the child elements
    ##
    def add_children(*children)
      children.each do |child|
        @children.push(child)
      end
    end

  end
end