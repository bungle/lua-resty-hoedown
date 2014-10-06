local ffi        = require "ffi"
local ffi_new    = ffi.new
local ffi_typeof = ffi.typeof
local ffi_cdef   = ffi.cdef
local ffi_load   = ffi.load
local ffi_str    = ffi.string
local concat     = table.concat

ffi_cdef[[
typedef enum hoedown_extensions {
	HOEDOWN_EXT_TABLES = (1 << 0),
	HOEDOWN_EXT_FENCED_CODE = (1 << 1),
	HOEDOWN_EXT_FOOTNOTES = (1 << 2),
	HOEDOWN_EXT_AUTOLINK = (1 << 3),
	HOEDOWN_EXT_STRIKETHROUGH = (1 << 4),
	HOEDOWN_EXT_UNDERLINE = (1 << 5),
	HOEDOWN_EXT_HIGHLIGHT = (1 << 6),
	HOEDOWN_EXT_QUOTE = (1 << 7),
	HOEDOWN_EXT_SUPERSCRIPT = (1 << 8),
	HOEDOWN_EXT_MATH = (1 << 9),
	HOEDOWN_EXT_NO_INTRA_EMPHASIS = (1 << 11),
	HOEDOWN_EXT_SPACE_HEADERS = (1 << 12),
	HOEDOWN_EXT_MATH_EXPLICIT = (1 << 13),
	HOEDOWN_EXT_DISABLE_INDENTED_CODE = (1 << 14)
} hoedown_extensions;
typedef enum hoedown_list_flags {
	HOEDOWN_LIST_ORDERED = (1 << 0),
	HOEDOWN_LI_BLOCK = (1 << 1)
} hoedown_list_flags;
typedef enum hoedown_table_flags {
	HOEDOWN_TABLE_ALIGN_LEFT = 1,
	HOEDOWN_TABLE_ALIGN_RIGHT = 2,
	HOEDOWN_TABLE_ALIGN_CENTER = 3,
	HOEDOWN_TABLE_ALIGNMASK = 3,
	HOEDOWN_TABLE_HEADER = 4
} hoedown_table_flags;
typedef enum hoedown_autolink_type {
	HOEDOWN_AUTOLINK_NONE,
	HOEDOWN_AUTOLINK_NORMAL,
	HOEDOWN_AUTOLINK_EMAIL
} hoedown_autolink_type;
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
typedef void *(*hoedown_realloc_callback)(void *, size_t);
typedef void (*hoedown_free_callback)(void *);
struct hoedown_buffer {
	uint8_t *data;
	size_t size;
	size_t asize;
	size_t unit;
	hoedown_realloc_callback data_realloc;
	hoedown_free_callback data_free;
	hoedown_free_callback buffer_free;
};
typedef struct hoedown_buffer hoedown_buffer;
struct hoedown_document;
typedef struct hoedown_document hoedown_document;
struct hoedown_renderer_data { void *opaque; };
typedef struct hoedown_renderer_data hoedown_renderer_data;
struct hoedown_renderer {
	void *opaque;
	void (*blockcode)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_buffer *lang, const hoedown_renderer_data *data);
	void (*blockquote)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*header)(hoedown_buffer *ob, const hoedown_buffer *content, int level, const hoedown_renderer_data *data);
	void (*hrule)(hoedown_buffer *ob, const hoedown_renderer_data *data);
	void (*list)(hoedown_buffer *ob, const hoedown_buffer *content, hoedown_list_flags flags, const hoedown_renderer_data *data);
	void (*listitem)(hoedown_buffer *ob, const hoedown_buffer *content, hoedown_list_flags flags, const hoedown_renderer_data *data);
	void (*paragraph)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*table)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*table_header)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*table_body)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*table_row)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*table_cell)(hoedown_buffer *ob, const hoedown_buffer *content, hoedown_table_flags flags, const hoedown_renderer_data *data);
	void (*footnotes)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	void (*footnote_def)(hoedown_buffer *ob, const hoedown_buffer *content, unsigned int num, const hoedown_renderer_data *data);
	void (*blockhtml)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_renderer_data *data);
	int (*autolink)(hoedown_buffer *ob, const hoedown_buffer *link, hoedown_autolink_type type, const hoedown_renderer_data *data);
	int (*codespan)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_renderer_data *data);
	int (*double_emphasis)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*emphasis)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*underline)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*highlight)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*quote)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*image)(hoedown_buffer *ob, const hoedown_buffer *link, const hoedown_buffer *title, const hoedown_buffer *alt, const hoedown_renderer_data *data);
	int (*linebreak)(hoedown_buffer *ob, const hoedown_renderer_data *data);
	int (*link)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_buffer *link, const hoedown_buffer *title, const hoedown_renderer_data *data);
	int (*triple_emphasis)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*strikethrough)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*superscript)(hoedown_buffer *ob, const hoedown_buffer *content, const hoedown_renderer_data *data);
	int (*footnote_ref)(hoedown_buffer *ob, unsigned int num, const hoedown_renderer_data *data);
	int (*math)(hoedown_buffer *ob, const hoedown_buffer *text, int displaymode, const hoedown_renderer_data *data);
	int (*raw_html)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_renderer_data *data);
	void (*entity)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_renderer_data *data);
	void (*normal_text)(hoedown_buffer *ob, const hoedown_buffer *text, const hoedown_renderer_data *data);
	void (*doc_header)(hoedown_buffer *ob, int inline_render, const hoedown_renderer_data *data);
	void (*doc_footer)(hoedown_buffer *ob, int inline_render, const hoedown_renderer_data *data);
};
typedef struct hoedown_renderer hoedown_renderer;

hoedown_buffer*   hoedown_buffer_new(size_t unit) __attribute__ ((malloc));
void              hoedown_buffer_free(hoedown_buffer *buf);
hoedown_document* hoedown_document_new(const hoedown_renderer *renderer, hoedown_extensions extensions, size_t max_nesting) __attribute__ ((malloc));
void              hoedown_document_render(hoedown_document *doc, hoedown_buffer *ob, const uint8_t *data, size_t size);
void              hoedown_document_render_inline(hoedown_document *doc, hoedown_buffer *ob, const uint8_t *data, size_t size);
void              hoedown_document_free(hoedown_document *doc);
void              hoedown_html_smartypants(hoedown_buffer *ob, const uint8_t *data, size_t size);
hoedown_html_tag  hoedown_html_is_tag(const uint8_t *data, size_t size, const char *tagname);
hoedown_renderer* hoedown_html_renderer_new(hoedown_html_flags render_flags, int nesting_level) __attribute__ ((malloc));
hoedown_renderer* hoedown_html_toc_renderer_new(int nesting_level) __attribute__ ((malloc));
void              hoedown_html_renderer_free(hoedown_renderer *renderer);
void              hoedown_escape_href(hoedown_buffer *ob, const uint8_t *data, size_t size);
void              hoedown_escape_html(hoedown_buffer *ob, const uint8_t *data, size_t size, int secure);
void              hoedown_version(int *major, int *minor, int *revision);

]]

local libhd = ffi_load("libhoedown")

local html_mt = {}

function html_mt.__call(_, source)
    local len = #source
    local buffer = libhd.hoedown_buffer_new(len);
    local renderer = libhd.hoedown_html_renderer_new(0, 0)
    local document = libhd.hoedown_document_new(renderer, 0xfff, 16)
    libhd.hoedown_document_render(document, buffer, source, len);
    libhd.hoedown_document_free(document);
    libhd.hoedown_html_renderer_free(renderer);
    local output = ffi_str(buffer.data, buffer.size)
    libhd.hoedown_buffer_free(buffer);
    return output
end

local html = setmetatable({}, html_mt)

function html.toc(source)
    local len = #source
    local buffer = libhd.hoedown_buffer_new(len);
    local renderer = libhd.hoedown_html_toc_renderer_new(4)
    local document = libhd.hoedown_document_new(renderer, 0xfff, 16)
    libhd.hoedown_document_render(document, buffer, source, len);
    libhd.hoedown_document_free(document);
    libhd.hoedown_html_renderer_free(renderer);
    local output = ffi_str(buffer.data, buffer.size)
    libhd.hoedown_buffer_free(buffer);
    return output
end

function html.smartypants(source)
    local len = #source
    local buffer = libhd.hoedown_buffer_new(len);
    libhd.hoedown_html_smartypants(buffer, source, len);
    local output = ffi_str(buffer.data, buffer.size)
    libhd.hoedown_buffer_free(buffer);
    return output
end

local escape = {}

function escape.href(source)
    local len = #source
    local buffer = libhd.hoedown_buffer_new(len);
    libhd.hoedown_escape_href(buffer, source, len);
    local output = ffi_str(buffer.data, buffer.size)
    libhd.hoedown_buffer_free(buffer);
    return output
end

function escape.html(source, secure)
    local len = #source
    local buffer = libhd.hoedown_buffer_new(len);
    libhd.hoedown_escape_html(buffer, source, len, secure and 1 or 0);
    local output = ffi_str(buffer.data, buffer.size)
    libhd.hoedown_buffer_free(buffer);
    return output
end

local version_mt = { __tostring = function(self)
    return concat({ self.major, self.minor, self.revision }, '.')
end }

local major    = ffi_new("int[1]", 0)
local minor    = ffi_new("int[1]", 0)
local revision = ffi_new("int[1]", 0)

libhd.hoedown_version(major, minor, revision)

local version = setmetatable({ major = tonumber(major[0]), minor = tonumber(minor[0]), revision = tonumber(revision[0]) }, version_mt)

return {
    html = html,
    escape = escape,
    version = version
}
