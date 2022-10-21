--[[
compactv3.lua

Goal:
translate into tja and back
store a ton of tjas

.tjac file


Changes:
Don't compress titles

WARNING:
Byte order mark causes stuff

Use wb+ to write, rb to read
]]




local escapechar = '\\'

local seperatorchar = '\\'





local success, search = pcall(require, ('./CompactTJA/search'))

if not success then
    print('Unable to require \'search\'')
end

local function Escape(str, sep)
    return string.gsub(string.gsub(str, escapechar, escapechar .. escapechar), sep, escapechar .. sep)
end

local function UnEscape(str, sep)
    return string.gsub(string.gsub(str, escapechar .. sep, sep), escapechar .. escapechar, escapechar)
end

local function SplitCustom(str, sep, escape)
    local t = {}
    local current = ''
    for c, d in string.gmatch(str, '([^' .. sep .. ']*)(' .. sep .. '?)') do
        local a, b = string.sub(c, -2, -2), string.sub(c, -1, -1)
        --print(a, b, c, d)
        local push = true
        if a == escape then
            if b == escape then
                --Push
            else
                --Push
            end
        else
            if b == escape then
                --Add to current
                --print('S', a, b, c, d)
                current = current .. string.sub(c, 1, -2) .. d
                push = false
            else
                --Push
            end
        end
        if push then
            current = current .. c
            t[#t + 1] = current
            current = ''
        end
            
        if d == '' then
            return t
        end
    end
    --Just in case
    return error(unpack(t))
end




--https://github.com/Rochet2/lualzw/blob/master/lualzw.lua
--[[
MIT License
Copyright (c) 2016 Rochet2
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]


local char = string.char
local type = type
local select = select
local sub = string.sub
local tconcat = table.concat

local basedictcompress = {}
local basedictdecompress = {}
for i = 0, 255 do
    local ic, iic = char(i), char(i, 0)
    basedictcompress[ic] = iic
    basedictdecompress[iic] = ic
end

local function dictAddA(str, dict, a, b)
    if a >= 256 then
        a, b = 0, b+1
        if b >= 256 then
            dict = {}
            b = 1
        end
    end
    dict[str] = char(a,b)
    a = a+1
    return dict, a, b
end

local function compress(input)
    if type(input) ~= "string" then
        return nil, "string expected, got "..type(input)
    end
    local len = #input
    if len <= 1 then
        return "u"..input
    end

    local dict = {}
    local a, b = 0, 1

    local result = {"c"}
    local resultlen = 1
    local n = 2
    local word = ""
    for i = 1, len do
        local c = sub(input, i, i)
        local wc = word..c
        if not (basedictcompress[wc] or dict[wc]) then
            local write = basedictcompress[word] or dict[word]
            if not write then
                return nil, "algorithm error, could not fetch word"
            end
            result[n] = write
            resultlen = resultlen + #write
            n = n+1
            if  len <= resultlen then
                return "u"..input
            end
            dict, a, b = dictAddA(wc, dict, a, b)
            word = c
        else
            word = wc
        end
    end
    result[n] = basedictcompress[word] or dict[word]
    resultlen = resultlen+#result[n]
    n = n+1
    if  len <= resultlen then
        return "u"..input
    end
    return tconcat(result)
end

local function dictAddB(str, dict, a, b)
    if a >= 256 then
        a, b = 0, b+1
        if b >= 256 then
            dict = {}
            b = 1
        end
    end
    dict[char(a,b)] = str
    a = a+1
    return dict, a, b
end

local function decompress(input)
    if type(input) ~= "string" then
        return nil, "string expected, got "..type(input)
    end

    if #input < 1 then
        return nil, "invalid input - not a compressed string"
    end

    local control = sub(input, 1, 1)
    if control == "u" then
        return sub(input, 2)
    elseif control ~= "c" then
        return nil, "invalid input - not a compressed string"
    end
    input = sub(input, 2)
    local len = #input

    if len < 2 then
        return nil, "invalid input - not a compressed string"
    end

    local dict = {}
    local a, b = 0, 1

    local result = {}
    local n = 1
    local last = sub(input, 1, 2)
    result[n] = basedictdecompress[last] or dict[last]
    n = n+1
    for i = 3, len, 2 do
        local code = sub(input, i, i+1)
        local lastStr = basedictdecompress[last] or dict[last]
        if not lastStr then
            return nil, "could not find last from dict. Invalid input?"
        end
        local toAdd = basedictdecompress[code] or dict[code]
        if toAdd then
            result[n] = toAdd
            n = n+1
            dict, a, b = dictAddB(lastStr..sub(toAdd, 1, 1), dict, a, b)
        else
            local tmp = lastStr..sub(lastStr, 1, 1)
            result[n] = tmp
            n = n+1
            dict, a, b = dictAddB(tmp, dict, a, b)
        end
        last = code
    end
    return tconcat(result)
end





--CUSTOM
--SplitCustom=function(a,b,escape)local c={}for z,d,b in a:gmatch("(.)([^"..b.."]*)("..b.."?)")do if z~=escape then c[#c + 1]=z..d end if b==''then return c end end end

local function StripBOM(str)
    --https://en.wikipedia.org/wiki/Byte_order_mark#Byte_order_marks_by_encoding

    --Everything should be utf8, so dont care about utf16
    if string.sub(str, 1, 3) == '\239\187\191' then
        return string.sub(str, 4, -1)
    else
        return str
    end


    --[[
    local bomchars = {
        ['\239'] = true,
        ['\187'] = true
    }
    i = 0
    repeat
        i = i + 1
    until not bomchars[string.sub(str, i, i)]
    return string.sub(str, i, -1)
    --]]
end






local headerchar = '\n'
local headersepchar = ','
local searchcase = true --case sensitive: true = not matter

local function EncodeHeader(t)
    local titles = {}
    for i = 1, #t do
        print(string.match(t[i], '\nTITLE:(.-)\n'))


        local title = string.match(t[i], 'TITLE:(.-)\n') or string.match(t[i], 'TITLE:(.-)\r')
        if not title then
            print'input title'
            title = io.read()
        end


        titles[#titles + 1] = Escape(title, headersepchar)
    end


    
    return table.concat(titles, headersepchar) .. headerchar


end
local function DecodeHeader(str)
    local e = string.find(str, headerchar)
    local header = SplitCustom(string.sub(str, 1, e - 1), headersepchar, escapechar)
    for i = 1, #header do
        header[i] = UnEscape(header[i], headersepchar)
    end
    return header, string.sub(str, e + 1, -1)
end
local function SearchHeaderAll(header, str)
    local t = {}
    for i = 1, #header do
        --print(header[i])
        t[i] = {i, search(header[i], str), header[i]}
    end

    table.sort(t, function(a, b)
        return a[2] > b[2]
    end)
    return t
end
local function SearchHeader(header, str)
    local t = SearchHeaderAll(header, str)
    --[[
    local t = {}
    for i = 1, #header do
        --print(header[i])
        t[i] = {i, search(header[i], str), header[i]}
    end

    table.sort(t, function(a, b)
        return a[2] > b[2]
    end)
    --]]

    --[[
    for i = 1, #t do
        print(str, unpack(t[i]))
    end;error()
    --]]

    --print(unpack(t[1]))

    return t[1][1]

    --old search
    --[[
    if searchcase then
        str = string.lower(str)
    end
    for i = 1, #header do
        if (searchcase and string.lower(header[i]) or header[i]) == string.sub(str, 1, #header[i]) then
            return i
        end
    end
    --]]
end









Compact = {}



function Compact.Read(file)
    local f = io.open(file, 'rb')
    local s = f:read('*all')
    f:close()
    return s
end

function Compact.Write(file, str)
    local f = io.open(file, 'wb+')
    f:write(str)
    f:close()
end

function Compact.Compress(t) --t is table of files
    --escape
    for i = 1, #t do
        t[i] = Escape(StripBOM(t[i]), seperatorchar)
    end
    local str = table.concat(t, seperatorchar)

    local c = compress(str)
    
    c = EncodeHeader(t) .. c

    --Stats
    print('Before chars: ' .. #str .. '\nAfter Chars:' .. #c .. '\nAfter/Before: ' .. (#c / #str) .. '\nCompression Rate: ' .. (#str / #c) .. 'x')

    return c
end

function Compact.Decompress(str)
    --Remove header first
    local header, str = DecodeHeader(str)
    
    local d = decompress(str)

    --StripBOM
    --nvm already stripped earlier

    local t = SplitCustom(d, seperatorchar, escapechar)

    return t, header
end





--Utils

function Compact.ListFiles(header)
    local t = {}
    for i = 1, #header do
        t[#t + 1] = header[i]
    end
    table.sort(t)
    return table.concat(t, '\n')
end

function Compact.Search(t, header, search)
    local a = SearchHeader(header, search)
    if a then
        return t[a]
    else
        return nil
    end
end

function Compact.Input(str)
    local d, header = Compact.Decompress(str)
    print(Compact.ListFiles(header))
    print('Song Name:')
    local input = io.read()
    local s = Compact.Search(d, header, input)
    if s then
        return s
    else
        error('Invalid input')
    end
end

function Compact.InputFile(file)
    return Compact.Input(Compact.Read(file))
end



function Compact.Merge(t) --t is a table of files (compressed)
    local t2 = {}
    for i = 1, #t do
        local a = Compact.Decompress(t[i])
        for i = 1, #a do
            t2[#t2 + 1] = a[i]
        end
    end
    return Compact.Compress(t2)
end

function Compact.CompressDir(path, base)
    --https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
    -- Lua implementation of PHP scandir function
    local function scandir(directory)
        local i, t, popen = 0, {}, io.popen
        local pfile = popen('dir "'..directory..'" /b')
        for filename in pfile:lines() do
            i = i + 1
            t[i] = filename
        end
        pfile:close()
        return t
    end

    local dir = path
    local t = scandir(dir)
    local exclude = {
        --['1 (1347).tja'] = true --Mirai, UTF-16 le + lf
    }

    local str = {}
    for i = 1, #t do
        local file = t[i]
        local scan = scandir(dir .. '\\' .. file)
        --print(dir .. '\\' .. file, scan)
        --print(dir .. '\\' .. file, '1', scan, scan[1], #scan)
        if #scan ~= 0 and scan[1] ~= file then
            --folder
            local temp = Compact.CompressDir(dir .. '\\' .. file, true)
            for i = 1, #temp do
                str[#str + 1] = temp[i]
            end
        elseif (not exclude[file]) and string.sub(file, -3, -1) == 'tja' then
            --print'tja'
            --.tja
            print(file)
            --print(file)
            str[#str + 1] = dir .. '\\'.. file
            --str[#str + 1] = (io.open(dir .. '\\'.. file,'r'):read('*all'))
        else

        end
        --[[
        if string.find(file, '%.') == nil then
            --folder
            local temp = Compact.CompressDir(dir .. '\\' .. file, true)
            for i = 1, #temp do
                str[#str + 1] = temp[i]
            end
        elseif (not exclude[file]) and string.sub(file, -3, -1) == 'tja' then
            --.tja
            print(file)

            str[#str + 1] = dir .. '\\'.. file
            --str[#str + 1] = (io.open(dir .. '\\'.. file,'r'):read('*all'))
        else
            --print('ERROR' , file)
        end
        --]]
    end
    if base then
        return str
    else
        --print(#str)
        for i = 1, #str do
            --print(str[i])
            --print(str[i])
            local f = io.open(str[i], 'r')
            --print(str[i])
            str[i] = f:read('*all')
            --print(str[i]:sub(1, 20))
            f:close()
        end
        return Compact.Compress(str)
    end
end



--Utils

Compact.SearchHeader = SearchHeader
Compact.SearchHeaderAll = SearchHeaderAll





-- [[

return Compact

--]]

