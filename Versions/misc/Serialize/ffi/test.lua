#!..\..\raylua_s.exe 

--https://stackoverflow.com/questions/12344095/how-do-i-convert-a-cdata-structure-into-a-lua-string/12347111#12347111

local ffi = require('ffi')

local ctype = 'Rectangle'
local a = rl.new(ctype, 1, 2, 3, 4)


--https://stackoverflow.com/questions/9137415/lua-writing-hexadecimal-values-as-a-binary-file
local function fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end


--Serialize

s = ffi.string(a, ffi.sizeof(a)) -- specify how long the byte sequence is
print(tohex(s)) --> 0100000002030405060708000000000000000900


--Deserialize

local a2 = ffi.cast(ctype .. '*', s)
print(a2.x)


local ffi=require'ffi'_CDATA=function(t,h)return ffi.cast(t..'*',h:gsub('..',function(c)return string.char(tonumber(c,16))end))end 

local a3 = _CDATA(ctype, tohex(s))
print(a3.x)