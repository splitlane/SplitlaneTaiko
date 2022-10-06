--[[
compactv2.lua

Goal:
translate into tja and back
store a ton of tjas

.tjac file


Changes:
COMPLETELY changed number compression
]]


Compact = {}



local seqn = 7 --bits grouping
local seqadd = 32 --add
local seqpad = 4




function Compact.Compress(str)
    function ToBinary(num)
        --https://stackoverflow.com/questions/9079853/lua-print-integer-as-a-binary
        -- returns a table of bits, least significant first.
        local t={} -- will contain the bits
        local rest
        while num>0 do
            rest=math.fmod(num,2)
            t[#t+1]=rest
            num=(num-rest)/2
        end
        return string.reverse(table.concat(t))
    end
    function TrimZero(a)
        --trim 0's
        for i = 1, #a do
            if string.sub(a, i, i) ~= '0' or i == #a then
                a = string.sub(a, i, -1)
                break
            end
        end
        return a
    end

    --[[
        Compression algorithms
        https://stackoverflow.com/questions/2267200/compression-of-numeric-strings
        https://cs.stackexchange.com/questions/100211/what-is-the-best-way-to-compress-a-string-with-only-numbers-and-commas-in-it
    ]]
    local function CompressNumber(s)
        local len = 4
        local t = {}
        for i = 1, #s do
            local a = ToBinary(tonumber(string.sub(s, i, i)))
            t[#t + 1] = string.rep('0', seqpad - #a) .. a
            --print(1, i, string.rep('0', seqpad - #a) .. a)
        end
        t = table.concat(t)
        local i = 1
        local t2 = {}
        repeat
            local a = string.sub(t, i, i + seqn - 1)
            t2[#t2 + 1] = string.char(tonumber(TrimZero(a), 2) + seqadd)
            if #a ~= seqn then
                t2[#t2 + 1] = #a
            end
            i = i + seqn
        --until i > (#t + seqn)
        until i > #t
        return table.concat(t2)
        --[[
        for i = 1, #t2 do
            print(t2[i])
        end
        --]]
    end
    local function DecompressNumber(s)
        local endchar = tonumber(string.sub(s, -1, -1))
        print(endchar)
        s = string.sub(s, 1, -2)
        local t = {}
        for i = 1, #s do
            local a = ToBinary(string.byte(string.sub(s, i, i)) - seqadd)
            t[#t + 1] = string.rep('0', seqn - #a) .. a
            if i == #s then
                t[#t] = string.sub(t[#t], 1, endchar)
            end
        end
        t = table.concat(t)
        local i = 1
        local t2 = {}
        repeat
            --print(2, i, string.sub(t, i, i + seqpad - 1))
            t2[#t2 + 1] = tostring(tonumber(TrimZero(string.sub(t, i, i + seqpad - 1)), 2))
            i = i + seqpad
            --[[
            if i > #t then
                t2[#t2] = string.sub(t2[#t2], 1, endchar)
            end
            --]]
        until i > #t
        return table.concat(t2)
    end


    --local function Check(n)print(n == DecompressNumber(CompressNumber(n)))print(n)print(DecompressNumber(CompressNumber(n))) end

    local dictionary = {}


    local binarychar = '\\'
    str = string.gsub(str, binarychar, '\\' .. binarychar)


    str = string.gsub(str, '\n(%d+)([,\n])', function(s,e)
        local a = CompressNumber(s)
        dictionary[a] = dictionary[a] and dictionary[a] + 1 or 1
        --unreadable
        --return binarychar .. a .. binarychar

        --readable
        return '\n' .. binarychar .. a .. binarychar .. e
    end)




    local dictionarychar = '&'
    str = string.gsub(str, dictionarychar, '\\' .. dictionarychar)

    local firstn = 10
    



    --sort
    local t = {}
    for k, v in pairs(dictionary) do
        t[#t + 1] = {k, v}
    end
    table.sort(t, function(a, b)
        return a[2] > b[2]
    end)

    for i = 1, firstn do
        print(unpack(t[i]))
    end



    return str
end






file = '../tja/ekiben.tja'

io.open(file..'c','w+'):write(Compact.Compress(io.open(file,'r'):read('*all')))