local str = io.open('../test.tjac','r'):read('*all')

local rle = require'rle'

print(#str, #rle.encode(str))
