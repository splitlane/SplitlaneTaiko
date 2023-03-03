--[[
    opening and reading unicode files or any file

    https://stackoverflow.com/questions/30585574/write-to-file-using-lua-ffi
    https://stackoverflow.com/a/14002993
    https://gist.github.com/akopytov/12ef537ac75c65804d8f4ce47fcf3eed

    Just treat like any other file handle

    WARNING: UNICODEFILENAME IS INTEGRATED INTO TAIKOV33
]]

local ffi = require'ffi'

ffi.cdef[[
typedef struct {
  char *fpos;
  void *base;
  unsigned short handle;
  short flags;
  short unget;
  unsigned long alloc;
  unsigned short buffincrement;
} FILE;

FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);


void *malloc(int64_t);
void free(void *);

int fseek(FILE *stream, long int offset, int whence);
long int ftell(FILE *stream);

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

]]


--fuck windows (paths are utf16)
local windows = ffi.os == 'Windows'
local codepointstostring
local wmode
if windows then
    --https://github.com/taocpp/PEGTL/issues/78
    --https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfilesizeex?redirectedfrom=MSDN
    ffi.cdef[[
    FILE *_wfopen(const wchar_t *filename, const wchar_t *mode);
    ]]
    --[[
    size_t strlen(const char *str);
    size_t mbstowcs(wchar_t* dst, const char* src, size_t len);
    ]]

    --[[
    chartowstring = function(char)
        --local char = ffi.cast('char *', lchar)
        --https://stackoverflow.com/a/5503864
        local size = ffi.C.strlen(char) + 1
        local wchar = ffi.new('wchar_t[?]', size)
        ffi.C.mbstowcs(wchar, char, size)
        return wchar
    end
    --]]

    --[[
    getfilesize = function(f)
        local n = ffi.new('LARGE_INTEGER *')
        ffi.C.GetFileSizeEx(f, n)
        return n
    end
    --]]

    codepointstostring = function(t)
        local size = #t + 1
        local wchar = ffi.new('wchar_t[?]', size)
        for i = 1, #t do
            wchar[i - 1] = t[i]
        end
        wchar[#t] = 0
        return wchar
    end
    
    --rb
    --wmode = codepointstostring({string.byte('r'), string.byte('b')})
end




local function utf8Decode(s)
    local res, seq, val = {}, 0, nil
    for i = 1, #s do
        local c = string.byte(s, i)
        if seq == 0 then
            table.insert(res, val)
            seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                  c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6 or
                  error("invalid UTF-8 character sequence")
            val = bit.band(c, 2^(8-seq) - 1)
        else
            val = bit.bor(bit.lshift(val, 6), bit.band(c, 0x3F))
        end
        seq = seq - 1
    end
    table.insert(res, val)
    --table.insert(res, 0)
    return res
end



--io. drop in replacement

--MAIN!
local wio = {}


function wio.open(path, mode)
    --patht should be like char *, it should be an array of codepoints
    local patht = utf8Decode(path)


    --https://stackoverflow.com/questions/30585574/write-to-file-using-lua-ffi
    local f
    if windows then
        --https://github.com/taocpp/PEGTL/issues/78
        --local wmode = chartowstring('rb')
        local wpath = codepointstostring(patht)
        local wmode = codepointstostring(utf8Decode(mode))
        f = ffi.C._wfopen(wpath, wmode)
    else
        
        --https://stackoverflow.com/a/33485288
        local path = ffi.new("char[?]", #patht + 1)
        for i = 1, #patht do
            path[i - 1] = patht[i]
        end
        path[#patht] = 0

        f = ffi.C.fopen(path, mode)
    end


    --Check if file is null
    if f == nil then
        return nil
    end
    

    --Return file data object
    return setmetatable({
        file = f
    }, {__index = wio})
end



function wio.read(file, mode)
    --WARNING: Doesn't support mode yet, just read all
    if string.sub(mode, 1, 2) ~= '*a' then
        error('File.read: Does not support mode')
    end



    --Get file size

    --https://stackoverflow.com/a/14002993
    --[[
    --https://support.sas.com/documentation/onlinedoc/ccompiler/doc700/html/lr1/z2031150.htm
    SEEK_SET	is the beginning of the file; the value is 0.
    SEEK_CUR	is the current file offset; the value is 1.
    SEEK_END	is the end of the file; the value is 2.
    ]]

    --Get file size
    local f = file.file

    ffi.C.fseek(f, 0, 2)
    local fsize = ffi.C.ftell(f)
    ffi.C.fseek(f, 0, 0)  -- same as rewind(f);

    
    if fsize ~= -1 then
        --char *string = malloc(fsize + 1);
        local str = ffi.cast('char *', ffi.C.malloc(fsize + 1))
        ffi.C.fread(str, fsize, 1, f)
        --ffi.C.fclose(f)
        str[fsize] = 0;

        local lstr = ffi.string(str, fsize)
        ffi.C.free(str)

        return lstr
    else
        error('File error')
    end
end



function wio.write(file, data)

    local f = file.file

    --[[
    local size = ffi.new('size_t', #data)
    local size2 = ffi.new('size_t', 1)
    --]]


    ffi.C.fwrite(data, #data, 1, f)
end



function wio.close(file)
    local f = file.file

    ffi.C.fclose(f)
end








































--Modify io. table
for k, v in pairs(wio) do
    io[k] = v
end










--[[
local b = wio.open('testw.txt', 'wb')
b:write('amogus\0nut')
--]]



local a = wio.open('test.txt', 'rb')

a = a:read('*all')

for i = 1, #a do
    print(a:sub(i, i), a:sub(i, i):byte())
end
