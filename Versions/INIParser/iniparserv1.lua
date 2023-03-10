--[[
    iniparserv1.lua

    be able to parse INI config files for skins
]]




IniParser = {}




function IniParser.Read(file)
    local f = io.open(file, 'rb')
    local s = f:read('*all')
    f:close()
    return s
end

function IniParser.Write(file, str)
    local f = io.open(file, 'wb+')
    f:write(str)
    f:close()
end





--https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

function IniParser.Save(t)
    --[[
        Assumes it is only 1 heirarchy deep
        (we won't be needing recursion)
    ]]

    local globalout = {}
    local out = {}

    for k, v in spairs(t, function(t, a, b)
        return tostring(a) < tostring(b)
    end) do
        if type(v) == 'table' then
            out[#out + 1] = '['
            out[#out + 1] = tostring(k)
            out[#out + 1] = ']\n'
            for k2, v2 in spairs(v, function(t, a, b)
                return tostring(a) < tostring(b)
            end) do
                --key = value
                out[#out + 1] = tostring(k2)
                out[#out + 1] = ' = '
                out[#out + 1] = tostring(v2)
                out[#out + 1] = '\n'
            end
            out[#out + 1] = '\n'
        else
            --key = value
            globalout[#globalout + 1] = tostring(k)
            globalout[#globalout + 1] = ' = '
            globalout[#globalout + 1] = tostring(v)
            globalout[#globalout + 1] = '\n'
        end
    end

    return table.concat(globalout) .. (#out ~= 0 and ('\n\n' .. table.concat(out)) or '')
end

--pass in t to keep adding to that table
function IniParser.Load(str, out, include)
    str = str .. '\n'
    local out = out or {}
    local include = include or {}
    local currentkey = nil
    local nextnewlinei = 1
    while true do
        --Newline
        local nextnewline = string.find(str, '\n', nextnewlinei)
        local cr = string.find(str, '\r\n', nextnewlinei)
        if cr and cr < nextnewline then
            nextnewline = cr
        end

        if not nextnewline then
            break
        end

        local s = string.sub(str, nextnewlinei, nextnewline - 1)

        if string.sub(s, 1, 1) ~= ';' then

            if string.sub(s, 1, 8) == '#include' then
                include[#include + 1] = string.sub(s, 10, -1)
            else

                --Bracket
                local bracketstart = string.find(s, '%[')
                if bracketstart then
                    local bracketend = string.find(s, '%]')
                    if bracketend then
                        currentkey = string.sub(s, bracketstart + 1, bracketend - 1)
                        out[currentkey] = out[currentkey] or {}
                    end
                end

                --Key-Value
                local equals = string.find(s, '=')
                if equals then
                    --Trim key right whitespace
                    local i = equals - 1
                    while true do
                        local s2 = string.sub(s, i, i)
                        if string.find(s2, '%s') then
                            i = i - 1
                        else
                            break
                        end
                    end

                    --Trim value left whitespace
                    local i2 = equals + 1
                    while true do
                        local s2 = string.sub(s, i2, i2)
                        if string.find(s2, '%s') then
                            i2 = i2 + 1
                        else
                            break
                        end
                    end

                    --Push key-value to out
                    local out2 = out
                    if currentkey then
                        --out[currentkey] = out[currentkey] or {}
                        out2 = out[currentkey]
                    else
                        out2 = out
                    end

                    out2[string.sub(s, 1, i)] = string.sub(s, i2, -1)
                end
            end
        end

        nextnewlinei = nextnewline + (cr and 2 or 1)
    end
    return out, include
end

function IniParser.LoadFile(path)
    local slashp = string.find(string.reverse(path), '[/\\]') --LAST SLASH REVERSED

    local dir = slashp and string.sub(path, 1, #path + 1 - slashp) or ''
    local out = {}
    local include = {slashp and string.sub(path, #path + 2 - slashp) or path}
    while true do
        local path = dir .. include[#include]
        include[#include] = nil
        local f = io.open(path, 'rb')
        if f then
            local data = f:read('*all')
            out, include = IniParser.Load(data, out, include)
            if #include == 0 then
                break
            end
        else
            return nil, 'Unable to open file.'
        end
    end
    return out
end


return IniParser