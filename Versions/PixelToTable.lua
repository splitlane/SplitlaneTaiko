function Convert(data)
    data = data.Data or data
    local out = '{'
    --[[
    local rows = {}
    local t = {}
    for x, v in pairs(data) do
        for y, v2 in pairs(v) do
            t[y] = t[y] or {}
            t[y][x] = v2
        end
    end
    --]]
    t = data
    --require'ppp'(t)
    for y, v in pairs(t) do
        local exec = false
        for x, v2 in pairs(v) do
            if v2 == '1' then
                exec = true
            end
        end
        if exec then
            out = out .. '[' .. y .. ']={'
            local out1 = ''
            local out2 = ''
            for x, v2 in pairs(v) do
                if v2 == '1' then
                    out2 = out2 .. '[' .. x .. ']=\'' .. v2 .. '\','
                end
                out1 = out1 .. '\'' .. v2 .. '\','
            end
            if #out1 < #out2 then
                out = out .. out1
            else
                out = out .. out2
            end
            out = string.sub(out, 1, -2) .. '},'
        end
    end
    return string.sub(out, 1, -2) .. '}'
end

return Convert