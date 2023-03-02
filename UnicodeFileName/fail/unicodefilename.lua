--codepoint to utf16 LE
--https://gist.github.com/actboy168/9e06b1214858a5e8973f064fe1184141

local bit = require'bit'

local function tochar(code)
    --return strchar(code & 0xFF, (code >> 8) & 0xFF)
    return string.char(bit.band(code, 0xFF), bit.band(bit.rshift(code, 8), 0xFF))
end


local function utf16char(code)
    if code < 0x10000 then
        return tochar(code)
    else
        code = code - 0x10000
        return tochar(0xD800 + bit.rshift(code, 10)) .. tochar(0xDC00 + bit.band(code, 0x3FF))
    end
end


local function utf16Encode(t)
    local out = {}
    for i = 1, #t do
        out[#out + 1] = utf16char(t[i])
    end
    return table.concat(out)
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




















--PS: Get-Location | Out-String | Format-Hex





local function hex(s)
    for i = 1, #s do
        print(s:sub(i, i), s: sub(i, i):byte())
    end
end

print(io.open(utf16Encode(utf8Decode([[C:\Users\User\OneDrive\code\Taiko\UnicodeFileName\a.txt]])), 'rb'))

hex(utf16char(12354))

hex(io.open('b.txt', 'rb'):read'*all')

--print(io.open([[C:\Users\User\Downloads\あ\test.txt]], 'rb'):read'*all')