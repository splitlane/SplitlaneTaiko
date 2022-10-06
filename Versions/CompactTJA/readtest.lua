Compact = require('compactv3')

local d = io.open('test.tjac','rb'):read('*all')
print(#d)

local o = {}
for i = 1, #d do
    local a = string.sub(d, i, i):byte()
    o[a] = o[a] and o[a] + 1 or 1
end




Compact.Decompress(d)