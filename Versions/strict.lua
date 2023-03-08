--[[
    strict.lua
    
    detect global definitions and log them to catch errors
]]




local on = false





if on then
    setmetatable(_G, {
        __index = function(t, k)
            print(t, k)
            print(debug.traceback())
            error()
        end,
        __newindex = function(t, k, v)
            rawset(t, k, v)
            print(t, k, v)
        end
    })
end