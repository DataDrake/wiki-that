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
require_relative('../parser/parser')
module WikiThat
  ##
  # HTMLGenerators are disposable objects for translate a Mediawiki
  # document to HTML Documents.
  # @author Bryan T. Meyers
  ##
  class HTMLGenerator
    # All of the errors and warnings generated while parsing
    attr_reader :errors, :warnings
    # The output of the translation to HTML
    attr_reader :result

    ##
    # Create a new WikiThat::HTMLGenerator
    # @param [String] doc the MediaWiki document
    # @param [String] base_url the base URL for relative links
    # @param [String] default_namespace the default namespace for relative links
    # @param [String] sub_url the sub URL for relative links
    # @param [String] media_base the base URL for media sources
    #
    # @returns [WikiThat::HTMLGenerator] a newly configured HTMLGenerator
    ##
    def initialize(doc, base_url, default_namespace, sub_url, media_base)
      @parser   = WikiThat::Parser.new(doc, base_url, default_namespace, sub_url, media_base)
      @index    = 0
      @errors   = []
      @warnings = []
      @root     = nil
      @result   = ''
    end

    ##
    # Translate the MediaWiki document into an HTML partial
    #
    # @returns [String] the resulting HTML partial
    ##
    def generate
      @parser.parse
      @errors   = @parser.errors
      @warnings = @parser.warnings
      @root     = @parser.result
      return unless success?
      @result = generate_element(@root)
    end

    ##
    # Translate an Element into an HTML partial
    # @param [Element] element the current element
    # @returns [String] the resulting HTML partial
    ##
    def generate_element(element)
      case element.type
        when :br
          '<br>'
        when :comment
          "<!--#{element.value}-->"
        when :text
          element.value ? element.value : ''
        when :nowiki, :pre
          "<#{element.type}>#{element.value}</#{element.type}>"
        when :root
          buff = ''
          element.children.each do |c|
            buff += generate_element(c)
          end
          buff
        else
          buff = "<#{element.type}" + generate_attributes(element)
          case element.type
            when :hr, :img, :references
              buff + ' />'
            else
              return '' if (element.type == :p) && element.children.empty?
              buff += '>'
              element.children.each do |c|
                buff += generate_element(c)
              end
              buff + "</#{element.type}>"
          end
      end
    end

    # Translate an Element's attributes into an HTML partial
    # @param [Element] element the current element
    # @returns [String] the resulting HTML partial
    ##
    def generate_attributes(element)
      buff = ['']
      element.attributes.each do |k, v|
        if v.is_a? TrueClass
          buff.push(k.to_s)
        else
          buff.push( "#{k}=\"#{v}\"")
        end
      end
      buff.join(' ')
    end

    ##
    # Check if the parsing succeeded
    # @returns [Boolean] True iff no errors
    ##
    def success?
      @errors.empty?
    end
  end
end
