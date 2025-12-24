--[[
    savestate.lua

    Save the state of the environment and load it back
]]




SaveState = {}




--Taken from Render.lua and modified to handle recursiveness


-- Save copied tables in `copies`, indexed by original table. --http://lua-users.org/wiki/CopyTable
local function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
local function CopyTableEquality(t, copyt)
    --copy t to copyt, and also check for equality (lol doesn't work)

    local out = deepcopy(t, copyt)

    return false
end













local defaultstacklevel = 1

function SaveState.Save(stacklevel)
    --[[
        data = {
            locals = {
                [stacklevel] = {
                    {n, v},
                    ...
                },
                ...
            },
            globals = {
                n = v,
                ...
            }
        }
    ]]
    local data = {
        locals = {},
        globals = {}
    }



    --locals
    while true do

        --Taken from commandv1.lua -> Command.GetLocalTable
        stacklevel = (stacklevel or defaultstacklevel) + 1

        if debug.getinfo(stacklevel) then
            --valid
        else
            break
        end

        local t = {}

        local i = 1
        while true do
            local n, v = debug.getlocal(stacklevel, i)
            if n then
                --Be able to store nils
                --t[n] = {v}
                --OR

                t[#t + 1] = {n, deepcopy(v)}
            else
                --Unable to find local
                break
            end
            i = i + 1
        end

        data.locals[stacklevel] = t
        --stacklevel = stacklevel + 1 --already adds 1 by default
    end

    --for k, v in pairs(data.locals) do for k2, v2 in pairs(v) do print(k, v2[1], v2[2]) end end





    --globals
    for k, v in pairs(_G) do
        data.globals[deepcopy(k)] = deepcopy(v)
    end

    --for k, v in pairs(data.globals) do print(k,v)end

    return data
end

function SaveState.Load(data)
    --locals
    for stacklevel, t in pairs(data.locals) do

        --Taken from commandv1.lua -> Command.SetLocal
        --stacklevel = stacklevel

        local i = 1
        while true do
            local n, v = debug.getlocal(stacklevel, i)
            if n then
                for i2 = 1, #t do
                    local a = t[i2]
                    if a[1] == n then
                        --You can only set a value of an existing local
                        debug.setlocal(stacklevel, i, a[2])
                        break
                    end
                end
            else
                --Unable to find local
                break
            end
            i = i + 1
        end
    end


    --globals
    for k, v in pairs(data.globals) do
        _G[k] = v
    end
end





local DATA = {}
function SaveState.SaveSlot(n)
    DATA[n] = SaveState.Save(defaultstacklevel + 1)
    return true, DATA[n]
end
function SaveState.LoadSlot(n)
    if DATA[n] then
        --Copy form DATA and load since we don't want to modify the saved and stored one
        SaveState.Load(deepcopy(DATA[n]))
        return true
    else
        return nil
    end
end


--SaveState.Load(SaveState.Save())