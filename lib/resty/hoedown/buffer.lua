local lib      = require "resty.hoedown.library"
local ffi      = require "ffi"
local ffi_gc   = ffi.gc
local ffi_str  = ffi.string
local ffi_cdef = ffi.cdef
local tonumber = tonumber

ffi_cdef[[
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
typedef struct  hoedown_buffer hoedown_buffer;
void            hoedown_buffer_init(hoedown_buffer *buffer, size_t unit, hoedown_realloc_callback data_realloc, hoedown_free_callback data_free, hoedown_free_callback buffer_free);
hoedown_buffer* hoedown_buffer_new(size_t unit) __attribute__ ((malloc));
void            hoedown_buffer_reset(hoedown_buffer *buf);
void            hoedown_buffer_grow(hoedown_buffer *buf, size_t neosz);
void            hoedown_buffer_put(hoedown_buffer *buf, const uint8_t *data, size_t size);
void            hoedown_buffer_puts(hoedown_buffer *buf, const char *str);
void            hoedown_buffer_putc(hoedown_buffer *buf, uint8_t c);
void            hoedown_buffer_set(hoedown_buffer *buf, const uint8_t *data, size_t size);
void            hoedown_buffer_sets(hoedown_buffer *buf, const char *str);
int             hoedown_buffer_eq(const hoedown_buffer *buf, const uint8_t *data, size_t size);
int             hoedown_buffer_eqs(const hoedown_buffer *buf, const char *str);
int             hoedown_buffer_prefix(const hoedown_buffer *buf, const char *prefix);
void            hoedown_buffer_slurp(hoedown_buffer *buf, size_t size);
const char*     hoedown_buffer_cstr(hoedown_buffer *buf);
void            hoedown_buffer_printf(hoedown_buffer *buf, const char *fmt, ...) __attribute__ ((format (printf, 2, 3)));
void            hoedown_buffer_free(hoedown_buffer *buf);
]]

local buffer = {}
function buffer:__index(key)
    if     key == "data"  then
        return tostring(self)
    elseif key == "size"  then
        return tonumber(self.___.size)
    elseif key == "asize" then
        return tonumber(self.___.asize)
    elseif key == "unit"  then
        return tonumber(self.___.unit)
    else
        return rawget(buffer, key)
    end
end
function buffer.new(size)
    return setmetatable({ ___ = ffi_gc(lib.hoedown_buffer_new(size or 64), lib.hoedown_buffer_free) }, buffer)
end
function buffer:reset()
    lib.hoedown_buffer_reset(self.___)
end
function buffer:grow(size)
    lib.hoedown_buffer_grow(self.___, size)
end
function buffer:put(str)
    lib.hoedown_buffer_put(self.___, str, #str)
end
function buffer:puts(str)
    lib.hoedown_buffer_puts(self.___, str)
end
function buffer:set(str)
    lib.hoedown_buffer_set(self.___, str, #str)
end
function buffer:sets(str)
    lib.hoedown_buffer_sets(self.___, str)
end
function buffer:eq(str)
    return tonumber(lib.hoedown_buffer_eq(self.___, str, #str)) == 1
end
function buffer:eqs(str)
    return tonumber(lib.hoedown_buffer_eqs(self.___, str)) == 1
end
function buffer:prefix(prefix)
    return tonumber(lib.hoedown_buffer_prefix(self.___, prefix))
end
function buffer:slurp(size)
    lib.hoedown_buffer_slurp(self.___, size)
end
function buffer:cstr()
    return lib.hoedown_buffer_cstr(self.___)
end
function buffer:printf(format, ...)
    lib.hoedown_buffer_printf(self.___, format, ...)
end
function buffer:free()
    lib.hoedown_buffer_free(self.___)
end
function buffer:__len()
    return tonumber(self.___.size)
end
function buffer.__concat(x, y)
    return tostring(x) .. tostring(y)
end
function buffer:__tostring()
    return ffi_str(self.___.data, self.___.size)
end

return buffer