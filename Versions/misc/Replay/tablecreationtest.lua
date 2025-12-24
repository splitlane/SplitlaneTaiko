--[[
    how bad is table creation
    6 times slower yikes

    concat is worse...
]]


local t = 1000000
local ta = {}

local a = os.clock()

for i = 1, t do
    --[[
    ta[i .. 1] = true
    --]]
    --[[
    ta[i] = {1}
    --]]
end


print(os.clock() - a)






