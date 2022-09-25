--From Obfuscator + Supports powershell

--[[
    For windows:
    If you are not on windows, just run the Current.lua file directly.

    cd "c:\Users\User\OneDrive\code\Obfuscator\Current\src"
    lua "c:\Users\User\OneDrive\code\Obfuscator\Current\src\Loader.lua"
    
]]



local filename='Taikov2.lua'



--powershell -Command "lua"

local a=os.execute('start /max /wait powershell -Command "lua Taikov2.lua"')
if a~=0 then dofile(filename)end

--]]











--[[
--Raw Windows
--Luajit
local a=os.execute('start /max /wait cmd /k powershell luajit "\''..filename..'\' \' \'"')if a~=0 then dofile(filename)end
--Lua
local a=os.execute('start /max /wait cmd /k powershell lua "\''..filename..'\' \' \'"')if a~=0 then dofile(filename)end
]]















--powershell
--[[
local a=os.execute('start /max /wait powershell lua "\''..filename..'\' \' \'"')if a~=0 then dofile(filename)end
--]]











--Legacy Version for command prompt
--[[
local a=os.execute('start /max /wait cmd /k lua '..filename..' ""')if a~=0 then dofile(filename)end
--]]