local buffer   = require "resty.hoedown.buffer"
local document = require "resty.hoedown.document"
local lib      = require "resty.hoedown.library"
local ffi      = require "ffi"
local ffi_gc   = ffi.gc
local ffi_cdef = ffi.cdef

ffi_cdef[[
typedef enum hoedown_html_flags {
	HOEDOWN_HTML_SKIP_HTML = (1 << 0),
	HOEDOWN_HTML_ESCAPE = (1 << 1),
	HOEDOWN_HTML_HARD_WRAP = (1 << 2),
	HOEDOWN_HTML_USE_XHTML = (1 << 3)
} hoedown_html_flags;
typedef enum hoedown_html_tag {
	HOEDOWN_HTML_TAG_NONE = 0,
	HOEDOWN_HTML_TAG_OPEN,
	HOEDOWN_HTML_TAG_CLOSE
} hoedown_html_tag;
struct hoedown_html_renderer_state {
    void *opaque;
    struct {
        int header_count;
        int current_level;
        int level_offset;
        int nesting_level;
    } toc_data;
    hoedown_html_flags flags;
    void (*link_attributes)(hoedown_buffer *ob, const hoedown_buffer *url, const hoedown_renderer_data *data);
};
typedef struct hoedown_html_renderer_state hoedown_html_renderer_state;
void              hoedown_html_smartypants(hoedown_buffer *ob, const uint8_t *data, size_t size);
hoedown_html_tag  hoedown_html_is_tag(const uint8_t *data, size_t size, const char *tagname);
hoedown_renderer* hoedown_html_renderer_new(hoedown_html_flags render_flags, int nesting_level) __attribute__ ((malloc));
hoedown_renderer* hoedown_html_toc_renderer_new(int nesting_level) __attribute__ ((malloc));
void              hoedown_html_renderer_free(hoedown_renderer *renderer);
]]

local function free(self)
    lib.hoedown_html_renderer_free(self.___)
end

local toc = { free = free }
toc.__index = toc

function toc.new(nesting)
    return setmetatable({ ___ = ffi_gc(lib.hoedown_html_toc_renderer_new(nesting or 16), lib.hoedown_html_renderer_free) }, toc)
end

local html = { free = free, toc = toc }
html.__index = html

function html.new(flags, nesting)
    return setmetatable({ ___ = ffi_gc(lib.hoedown_html_renderer_new(flags or 0xfff, nesting or 16), lib.hoedown_html_renderer_free) }, html)
end

function html.smartypants(data)
    local str = tostring(data)
    local len = #str
    local buf = buffer.new(len);
    lib.hoedown_html_smartypants(buf.___, str, len);
    return tostring(buf)
end

function html.is_tag(data, tag)
    local str = tostring(data)
    local len = #str
    return tonumber(lib.hoedown_html_is_tag(str, len, tostring(tag)))
end

return html