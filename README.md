# lua-resty-hoedown

`lua-resty-hoedown` is a Markdown, SmartyPants, buffer, and html and href/url escaping library implementing LuaJIT bindings to
[Hoedown](https://github.com/hoedown/hoedown).

## Hello World with lua-resty-hoedown

```lua
local hoedown = require "resty.hoedown"
hoedown[[
# Are you ready for the truth?

Now that there is the Tec-9, a crappy spray gun from South Miami.
This gun is advertised as the most popular gun in American crime.
Do you believe that shit? It actually says that in the little book
that comes with it: the most popular gun in American crime. Like
they're actually proud of that shit.

## I'm serious as a heart attack

The path of the righteous man is beset on all sides by the iniquities
of the selfish and the tyranny of evil men. Blessed is he who, in the
name of charity and good will, shepherds the weak through the valley
of darkness, for he is truly his brother's keeper and the finder of
lost children. And I will strike down upon thee with great vengeance
and furious anger those who would attempt to poison and destroy My
brothers.
]]
```

This will return string containing:

```html
<h1>Are you ready for the truth?</h1>

<p>Now that there is the Tec-9, a crappy spray gun from South Miami.
This gun is advertised as the most popular gun in American crime.
Do you believe that shit? It actually says that in the little book
that comes with it: the most popular gun in American crime. Like
they&#39;re actually proud of that shit.</p>

<h2>I&#39;m serious as a heart attack</h2>

<p>The path of the righteous man is beset on all sides by the iniquities
of the selfish and the tyranny of evil men. Blessed is he who, in the
name of charity and good will, shepherds the weak through the valley
of darkness, for he is truly his brother&#39;s keeper and the finder of
lost children. And I will strike down upon thee with great vengeance
and furious anger those who would attempt to poison and destroy My
brothers.</p>
```

## Installation

Just place [`resty directory`](https://github.com/bungle/lua-resty-hoedown/blob/master/lib/resty) somewhere in your `package.path`. If you are using OpenResty, the default location would be `/usr/local/openresty/lualib`.
Please check though that you do not overwrite the existing resty-directory if one exists already.

### Compiling and Installing Hoedown C-library

These are just rudimentary notes. Better installation instructions will follow:

1. First download Hoedown from here: https://github.com/hoedown/hoedown
2. Run `make`
3. Place `libhoedown.so` in Lua's `package.cpath` (or modify `resty/hoedown/library.lua` and point `ffi_load("libhoedown")` with full path to `libhoedown.so`.

### Using LuaRocks or MoonRocks

If you are using LuaRocks >= 2.2:

```Shell
$ luarocks install lua-resty-hoedown
```

If you are using LuaRocks < 2.2:

```Shell
$ luarocks install --server=http://rocks.moonscript.org moonrocks
$ moonrocks install lua-resty-hoedown
```

MoonRocks repository for `lua-resty-hoedown` is located here: https://rocks.moonscript.org/modules/bungle/lua-resty-hoedown.

## Lua API

### Document Processing Extensions

With extensions, you may extend how to document processing works.
Here are the available extensions:

```lua
tables                = HOEDOWN_EXT_TABLES,
fenced_code           = HOEDOWN_EXT_FENCED_CODE,
footnotes             = HOEDOWN_EXT_FOOTNOTES,
autolink              = HOEDOWN_EXT_AUTOLINK,
strikethrough         = HOEDOWN_EXT_STRIKETHROUGH,
underline             = HOEDOWN_EXT_UNDERLINE,
highlight             = HOEDOWN_EXT_HIGHLIGHT,
quote                 = HOEDOWN_EXT_QUOTE,
superscript           = HOEDOWN_EXT_SUPERSCRIPT,
math                  = HOEDOWN_EXT_MATH,
no_intra_emphasis     = HOEDOWN_EXT_NO_INTRA_EMPHASIS,
space_headers         = HOEDOWN_EXT_SPACE_HEADERS,
math_explicit         = HOEDOWN_EXT_MATH_EXPLICIT,
disable_indented_code = HOEDOWN_EXT_DISABLE_INDENTED_CODE
```

##### Example

```lua
local hoedown = require "resty.hoedown"
print(hoedown.document.extensions.tables)
local doc = require "resty.hoedown.document"
local extensions = doc.extensions
print(extensions.tables)
```

### HTML Rendering Flags

With HTML rendering flags you can control the HTML rendering process.
Hare are the available flags:

```lua
skip_html = HOEDOWN_HTML_SKIP_HTML,
escape    = HOEDOWN_HTML_ESCAPE,
hard_wrap = HOEDOWN_HTML_HARD_WRAP,
use_xhtml = HOEDOWN_HTML_USE_XHTML
```

##### Example

```lua
local hoedown = require "resty.hoedown"
print(hoedown.html.flags.skip_html)
local html  = require "resty.hoedown.html"
local flags = html.flags
print(flags.use_xhtml)
```

### HTML Tag States

These present values returned from `resty.hoedown.html.is_tag` function.
The possible values are:

```lua
none  = HOEDOWN_HTML_TAG_NONE,
open  = HOEDOWN_HTML_TAG_OPEN,
close = HOEDOWN_HTML_TAG_CLOSE
```

##### Example

```lua
local hoedown = require "resty.hoedown"
print(hoedown.html.tag.open)
local html = require "resty.hoedown.html"
local tag  = html.tag
print(tag.open)
```

### resty.hoedown

A helper library that you may `require` with a single statement.

#### string hoedown(source, opts)

Helper function to rendering. `source` is a `string` containing a source document.
You can also pass in options with `opts` argument. Here are the different options
that you may use (you can also skip passing options):

```lua
opts = {
    renderer    = ("html" or "html.toc" or function or nil),
    extensions  = (table or number or nil),
    max_nesting = (number or nil),
    flags       = (table or number or nil),
    nesting     = (number or nil),
    smartypants = (true or false or nil)
}
```

##### Example

```lua
local hoedown = require "resty.hoedown"
print(hoedown[[
# Hello World

Hi this is Markdown.
]])

local flags = hoedown.html.flags

print(hoedown([[
# Hello World

Hi this is Markdown.
]], {
    rendered    = "html.toc",
    nesting     = 1,
    flags       = { flags.use_xhtml, "escape", 1 },
    extensions  = { "underline", "quote" },
    smartypants = true
}))
```

#### table resty.hoedown.buffer

This returns a [`buffer`](#restyhoedownbuffer) module.

#### table resty.hoedown.document

This returns a [`document`](#restyhoedowndocument) module.

#### table resty.hoedown.html

This returns an [`html`](#restyhoedownhtml) module.

#### table resty.hoedown.escape

This returns an [`escape`](#restyhoedownescape) module.

#### table resty.hoedown.version

This returns a [`version`](#restyhoedownversion) module.

### resty.hoedown.buffer

TBD

### resty.hoedown.document

TBD

### resty.hoedown.html

TBD

### resty.hoedown.escape

TBD

### resty.hoedown.version

TBD

## License

`lua-resty-hoedown` uses two clause BSD license.

```
Copyright (c) 2014, Aapo Talvensaari
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
