Taiko = {
    Data = {
RatingMultiplier = {
    [0] = 0,
    [1] = 0.5,
    [2] = 1,
    [3] = 2
},


ScoreMode = {
    --combo: current combo, added note
    --status: 0 = bad, 1 = ok, 2 = good, 3 = biggood
    [0] = function(score, combo, init, diff, status)
        --[[
        local a = nil
        if combo < 200 then
            a = (init or 1000)
        else
            a = (init or 1000) + (diff or 1000)
        end
        score = score + (a * Taiko.Data.RatingMultiplier[status])
        --]]


        return score + (((combo < 200) and (init or 1000) or ((init or 1000) + (diff or 1000))) * Taiko.Data.RatingMultiplier[status])
    end,
    [1] = function(score, combo, init, diff, status)
        --INIT + max(0, DIFF * floor((min(COMBO, 100) - 1) / 10))
        return score + (init + math.max(0, diff * math.floor((math.min(combo, 100) - 1) / 10))) * Taiko.Data.RatingMultiplier[status]
    end,
    [2] = function(score, combo, init, diff, status)
        --INIT + DIFF * {100<=COMBO: 8, 50<=COMBO: 4, 30<=COMBO: 2, 10<=COMBO: 1, 0}
        return score + (init + diff * ((combo >= 100) and 8 or (combo >= 50) and 4 or (combo >= 30) and 2 or (combo >= 10) and 1 or 0)) * Taiko.Data.RatingMultiplier[status]
    end
}
    }}

for k, v in pairs(Taiko.Data.ScoreMode) do
    Taiko.Data.ScoreMode[k] = function(...)
        return math.floor(v(...) / 10) * 10
    end
end



local score = 0
local combo = 0

local init = 100
local diff = 50
local scoremode = 1

print(score)
function hit()
    local rating = tonumber(io.read()) or 2
    if rating == 0 then
        combo = 0
    else
        combo = combo + 1
    end
    score = Taiko.Data.ScoreMode[scoremode](score, combo, init, diff, rating)
    
    print(score, combo)
end
while true do hit()end