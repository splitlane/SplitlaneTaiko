local s = io.open('test.lua', 'rb'):read'*all'


for i=1,#s do print(s:sub(i, i):byte())end