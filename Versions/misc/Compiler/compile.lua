--https://luajit.org/extensions.html#string_dump


local file = io.open('./../Taikov34.lua', 'rb+')

local data = file:read('*all')

file:close()

local f1 = loadstring(data)



local f2 = loadfile('./../Taikov34.lua')


--debug info not stripped
local ns1, ns2 = string.dump(f1), string.dump(f2)

--debug info stripped
local s1, s2 = string.dump(f1, true), string.dump(f2, true)

print(#ns1, #s1, #ns2, #s2)

;(loadstring(s1))()

io.open('out.lua', 'wb+'):write(s1)