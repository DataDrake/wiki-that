# wiki-that
A custom MediaWiki lexer which generates HTML partials for 
use in the Engineering Design Guide and Environment (EDGE),
developed at the Rochester Institute of Technology. This 
library does adapts the WikiMedia Foundation MediaWiki grammar
in order to support richer use of namespaces in a 
project-oriented system. It does not strive for full compatibilty
with MediaWiki proper.

## Supported Features

1. Headings
2. Formatting
    * Bold / Italic / Both
3. Lists
    * Unordered
    * Ordered
    * Definition
4. Links
    * Internal / External
    * Embedded Media
        * Audio
        * Images
            * Captions, Frames, Thumbnails, etc.
        * Videos
5. Tables
    * Captions
    * Table/Row/Cell Attributes
    * Inline Cells
    * Multi-line Cells
    * Nested Tables and non-inline elements
6. MISC
    * Horizontal Rules
    * \<nowiki> Tag

## Deviations from Wikimedia MediaWiki

### Link Namespace Handling
Usually link namespaces are used for grouping pages and content
in a MediaWiki document. This helps a MediaWiki engine with knowing 
where to look in storage for a document, for example.

In our "flavor" of MediaWiki, link namespaces serve two purposes:

1. **Embedded Media**   
   The namespaces `Audio`, `Image`, and `Video` are reserved
   to inform the parser that an internal link represents a file
   to be embedded into the document. This enables authors to embed
   any W3C standardized media file format into a document. The
   Project or Category of these files may be specified after this
   media namespace or fallback to the configured `default_namespace` 
   variable.
   
2. **Projects or Categories**  
   Non-reserved namespaces may be used to group multiple documents
   into the same document root. This allows these documents to be
   grouped according to a particular category or project. This has
   the additional benefit of allowing for ***interwiki links***
   which enabling linking to objects in other namespaces.

## License

Copyright 2017 Bryan T. Meyers

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.