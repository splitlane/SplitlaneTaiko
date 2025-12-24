local function SplitCustom(str, sep, escape)
    local t = {}
    local current = ''
    for c, d in string.gmatch(str, '([^' .. sep .. ']*)(' .. sep .. '?)') do
        local a, b = string.sub(c, -2, -2), string.sub(c, -1, -1)
        --print(a, b, c, d)
        local push = true
        if a == escape then
            if b == escape then
                --Push
            else
                --Push
            end
        else
            if b == escape then
                --Add to current
                --print('S', a, b, c, d)
                current = current .. string.sub(c, 1, -2) .. d
                push = false
            else
                --Push
            end
        end
        if push then
            current = current .. c
            t[#t + 1] = current
            current = ''
        end
            
        if d == '' then
            return t
        end
    end
    --Just in case
    return error(unpack(t))
end
