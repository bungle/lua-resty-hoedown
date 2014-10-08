package = "lua-resty-hoedown"
version = "dev-1"
source = {
    url = "git://github.com/bungle/lua-resty-hoedown.git"
}
description = {
    summary = "LuaJIT FFI bindings to Hoedown, a standards compliant, fast, secure markdown processing library in C",
    detailed = "lua-resty-hoedown is a Markdown, SmartyPants, buffer, and HTML/URL escaping library for LuaJIT.",
    homepage = "https://github.com/bungle/lua-resty-hoedown",
    maintainer = "Aapo Talvensaari <aapo.talvensaari@gmail.com>",
    license = "BSD"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        ["resty.hoedown"]          = "lib/resty/hoedown.lua",
        ["resty.hoedown.buffer"]   = "lib/resty/hoedown/buffer.lua",
        ["resty.hoedown.document"] = "lib/resty/hoedown/document.lua",
        ["resty.hoedown.escape"]   = "lib/resty/hoedown/escape.lua",
        ["resty.hoedown.html"]     = "lib/resty/hoedown/html.lua",
        ["resty.hoedown.library"]  = "lib/resty/hoedown/library.lua",
        ["resty.hoedown.version"]  = "lib/resty/hoedown/version.lua"
    }
}
