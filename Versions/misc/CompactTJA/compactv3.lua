--[[
compactv3.lua

Goal:
translate into tja and back
store a ton of tjas

.tjac file


Changes:
compression was trash so just LZW

WARNING:
Byte order mark causes stuff

Use wb+ to write, rb to read
]]




local escapechar = '\\'

local seperatorchar = '\\'
















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
SplitCustom=function(a,b,escape)local c={}for z,d,b in a:gmatch("(.)([^"..b.."]*)("..b.."?)")do if z~=escape then c[#c + 1]=z..d end if b==''then return c end end end

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







local function FindShortest(t, s)
    local i2 = 0
    local check = false
    repeat
        i2 = i2 + 1
        check = true
        for i3 = 1, #t do
            if s ~= t[i3] and string.sub(t[i3], 1, i2) == string.sub(s, 1, i2) then
                check = false
            end
        end
    until check or (i2 > #s)
    return i2
end

local headerchar = '\n'
local headersepchar = ','
local searchcase = true --case sensitive: true = not matter

local function EncodeHeader(t)
    local titles = {}
    local titlesreversed = {}
    for i = 1, #t do
        titles[#titles + 1] = string.lower(string.match(t[i], 'TITLE:(.-)\n'))
        titlesreversed[#titlesreversed + 1] = titles[#titles] and string.reverse(titles[#titles])
    end


    for i = 1, #titles do
        local s = titles[i]

        local a = FindShortest(titles, s)
        local b = FindShortest(titlesreversed, string.reverse(s))
        --print(a, b)

        if string.sub(s, 1, 1) == '-' then
            s = escapechar .. string.sub(s, 2, -1)
        end

        if b + 1 < a then
            --use reversed
            s = '-' .. string.sub(string.reverse(s), 1, b)
        else
            --use normal
            s = string.sub(s, 1, a)
        end

        titles[i] = string.gsub(s, headersepchar, escapechar .. headersepchar)
    end

    
    return table.concat(titles, headersepchar) .. headerchar


end
local function DecodeHeader(str)
    local e = string.find(str, headerchar)
    local header = SplitCustom(string.sub(str, 1, e - 1), headersepchar, escapechar)
    for i = 1, #header do
        header[i] = string.gsub(header[i], escapechar .. headersepchar, headersepchar)
    end
    return header, string.sub(str, e + 1, -1)
end
local function SearchHeader(header, str)

    if searchcase then
        str = string.lower(str)
    end
    for i = 1, #header do
        --print(header[i])
        if (string.sub(header[i], 1, 1) == '-') and (string.lower(header[i]:sub(2, -1)):reverse() == string.sub(str, -(#header - 1), -1)) or ((searchcase and string.lower(header[i]) or header[i]) == string.sub(str, 1, #header[i])) then
            return i
        end
    end



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
    return io.open(file, 'rb'):read('*all')
end

function Compact.Write(file, str)
    return io.open(file, 'wb+'):write(str)
end

function Compact.Compress(t) --t is table of files
    --escape
    for i = 1, #t do
        t[i] = string.gsub(StripBOM(t[i]), seperatorchar, escapechar .. seperatorchar)
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





error('outdated')

-- [[

return Compact

--]]

