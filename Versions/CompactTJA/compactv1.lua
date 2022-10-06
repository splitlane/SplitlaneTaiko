--[[
compactv1.lua

Goal:
translate into tja and back
store a ton of tjas

.tjac file
]]


Compact = {}





local digits = [[ !"#$%&'()*+-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~]]

local function DecompressNumber(str)
    local base = #digits
    local new = 0
    for i = #str, 1, -1 do
        --new = new + (base ^ (#str - i + 1) * tonumber(string.sub(str, i, i)))
        new = new + (base ^ (#str - i) * ((string.find(digits, string.sub(str, i, i))) - 1))
    end
    return new
end


function Compact.Compress(str)
    local function CompressNumber(n)
    --https://stackoverflow.com/questions/3554315/lua-base-converter
        --if not b or b == 10 then return tostring(n) end
        --32 - 126, no backslash no comma
        --93 total
        
        local b = #digits
        local t = {}
        local sign = ""
        if n < 0 then
            sign = "-"
            n = -n
        end
        repeat
            local d = (n % b) + 1
            n = math.floor(n / b)
            table.insert(t, 1, digits:sub(d,d))
        until n == 0
        return sign .. table.concat(t,"")
    end
    local function Check(n)print(n == DecompressNumber(CompressNumber(n)), n, DecompressNumber(CompressNumber(n))) end
    Check(100000000000500000000000000000000008000000000000)
    Check()
    error()

    local binarychar = '\\'
    str = string.gsub(str, binarychar, '\\' .. binarychar)

end






file = '../tja/ekiben.tja'

print(Compact.Compress(io.open(file,'r'):read('*all')))