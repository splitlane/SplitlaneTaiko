Compact = require'compactv4'







--[[
local file = '../tja/ekiben.tja'
--print(io.open(file,'r'):read('*all'))

local compressed = Compact.Compress({io.open(file,'r'):read('*all')})
local decompressed = Compact.Decompress(compressed)

io.open(file..'c','w+'):write(decompressed)
--]]



-- [=[
--https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
-- Lua implementation of PHP scandir function
function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local dir = [[C:\Users\User\OneDrive\code\Taiko\Versions\taikobuipm]]
local t = scandir(dir)
local exclude = {

}
local str = {}
for i = 1, #t do
    local file = t[i]
    if (not exclude[file]) and string.sub(file, -3, -1) == 'tja' then
        print(file)
        str[#str + 1] = (io.open(dir .. '\\'.. file,'r'):read('*all'))
    end
end
--error()
--]=]

-- [[
local compressed = Compact.Compress(str)
local decompressed = Compact.Decompress(compressed)

local a = io.open('test.tjac','rb'):read('*all')




io.open('taikobuipm.tjac','wb+'):write((compressed))

--io.open('test2.tjac','w+'):write((table.concat(decompressed)))
--]]