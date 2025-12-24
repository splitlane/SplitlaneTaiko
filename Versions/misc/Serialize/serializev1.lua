--[[
    serializev1.lua

    Serialize lua tables into lua code

    DIFFERENT THAN PERSISTENT, SERIALIZE ANYTHING
]]


local Serialize = {}




function Serialize.Save(t)

    local tk = {'{'}
    local tkn = 0
    local out = {}

    -- Save copied tables in `copies`, indexed by original table. --http://lua-users.org/wiki/CopyTable
    local function deepserialize(orig, copies, keyhistory)
        copies = copies or {}
        keyhistory = keyhistory or {}
        local orig_type = type(orig)
        --local copy
        if orig_type == 'table' then
            if copies[orig] then
                --copy = copies[orig]
            else
                --copy = {}
                copies[orig] = keyhistory

                local mt = getmetatable(orig)
                if mt then
                    out[#out + 1] = 'setmetatable('
                end
                
                out[#out + 1] = '{'
                local first = true
                for orig_key, orig_value in next, orig, nil do

                    --keyhistory
                    local keyhistory2 = {}
                    for i = 1, #keyhistory do

                    end

                    if first then
                        first = false
                    else
                        out[#out + 1] = ','
                    end
                    out[#out + 1] = '[' --TODO: bracket optimization for strings
                    if type(orig_key) == 'table' then
                        tkn = tkn + 1
                        if tkn ~= 1 then
                            tk[#tk + 1] = ','
                        end
                        tk, out = out, tk

                        deepserialize(orig_key, copies, keyhistory2)

                        tk, out = out, tk

                        out[#out + 1] = 'k['
                        out[#out + 1] = tostring(tkn)
                        out[#out + 1] = ']'
                    else
                        deepserialize(orig_key, copies, keyhistory2)
                    end
                    out[#out + 1] = ']='
                    deepserialize(orig_value, copies, keyhistory2)
                    --copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
                end
                out[#out + 1] = '}'
                --setmetatable(copy, deepcopy(getmetatable(orig), copies))
                
                if mt then
                    out[#out + 1] = ','
                    deepserialize(mt)
                    out[#out + 1] = ')'
                end
            end
        else -- number, string, boolean, etc
            --copy = orig
            out[#out + 1] = tostring(orig)
        end
        return nil
    end

    deepserialize(t)
    tk[#tk + 1] = '}'
    print('local k='..table.concat(tk)..'local t='..table.concat(out))
end

function Serialize.Load(str)
    --This is just loadstring: BE CAREFUL --UNSAFE
    local f, err = loadstring(str)
    if f then
        local success, out = pcall(f)
        if success then
            return out
        else
            error(out)
        end
    else
        error(err)
    end
end



local t = {[{1}] = 1, 2, 3}
t.t = t

Serialize.Save(t)


return Serialize