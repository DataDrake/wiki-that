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

    def self.parse_attributes(doc,i)
      buff = ''
      while i != doc.length && doc[i] != "\n"
        buff += doc[i]
        i += 1
      end
      if i != doc.length
        buff += doc[i]
        i += 1
      end
      attrs = buff.scan(/\w+=".*?"/)
      if attrs.length > 0
        attrs = ' ' + attrs.join(' ')
      end
      [i,buff,attrs]
    end

    def self.parse_caption(doc,i)

    end

    def parse_table
      table = '<table'
      buff = '' + doc[i]
      i += 1
      if doc[i] != '|'
        return [i,buff]
      end
      buff += doc[i]
      i += 1
      i,pbuff,attrs = parse_attributes(doc,i)
      buff += pbuff
      table += "#{attrs}>"
      i,pbuff,ptab = parse_caption(doc,i)
      buff += pbuff
      if ptab.length > 0
        table += ptab
      end
    end
  end
end