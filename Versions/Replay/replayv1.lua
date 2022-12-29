--[[
replayv1.lua

Goal:
store replay files efficiently


Changes:


WARNING:
Byte order mark causes stuff

Use wb+ to write, rb to read





Format:

Raw:
{
    [ms] = {'KEY', 'KEY2', ...},
    ...
}


]]

Replay = {}
Replay.Version = 'beta-1'












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























function Replay.TranscodeRaw(raw)
    --[[
        raw file just concats key with ms, so basically no table creation
        DEPRACATED
    ]]
    local out = {}
    for k, v in pairs(raw) do
        local split = string.find(k, ' ')
        out[tonumber(string.sub(k, 1, split - 1))] = tonumber(string.sub(k, split + 1, -1))
    end
    return out
end

function Replay.TranscodeRawKey(raw)
    --[[
        every key has table creation, but ms is just put in
    ]]
    local out = {}
    for k, v in pairs(raw) do
        for i = 1, #v do
            local ms = v[i]
            out[ms] = out[ms] and out[ms] or {}
            out[ms][#out[ms] + 1] = k
        end
    end
    return out
end

function Replay.Save(t, m)
    local out = {}
    --Calculate metadata
    local i, min, max = 0
    for k, v in pairs(t) do
        min = (not min or k < min) and k or min
        max = (not max or k > max) and k or max
        i = i + 1
    end
    
    --Write metadata
    --[[
        possible:
        date
    ]]
    out = {
        'version ', Replay.Version,
        '\ntotalms ', tostring(max - min),
        '\nactivecount ', tostring(i),
        '\ndata '
    }

    --Add incoming metadata
    m = m or {}
    for i = 1, #m do
        out[#out + 1] = m[i]
    end

    --Don't care about order
    local data = {}
    for k, v in pairs(t) do
        data[#data + 1] = tostring(k)
        data[#data + 1] = ' '
        data[#data + 1] = table.concat(v) --ASSUMES KEYS ARE 1 LONG
        data[#data + 1] = '\n'
    end
    out[#out + 1] = compress(table.concat(data))


    return table.concat(out)
end

function Replay.Load(str)
    --Extract metadata
    local finddata, finddata2 = string.find(str, 'data ')
    local metadata = string.sub(str, 1, finddata - 1)

    local data = string.sub(str, finddata2 + 1, -1)
    local d = decompress(data)

    local out = {}

    local i = 1
    while true do
        local s, e = string.find(d, '\n', i)
        if not s then
            break
        end

        local line = string.sub(d, i, s - 1)
        i = e + 1
        local split = string.find(line, ' ')
        local ms = string.sub(line, 1, split - 1)
        local keys = string.sub(line, split + 1, -1)
        local t = {}
        for i2 = 1, #keys do
            t[#t + 1] = string.sub(keys, i2, i2)
        end
        out[tonumber(ms)] = t
    end
    return out --metadata?
end

return Replay