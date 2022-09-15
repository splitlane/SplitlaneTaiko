--[[
Taikov1.lua

Objectives:
O: Parse TJA
NEVER: Play frame
O: Play entire song
]]





--Utils

Split=function(a,b)local c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end
Trim=function(s)local a=s:gsub("^%s*(.-)%s*$", "%1")return a end
TrimLeft=function(s)local a=s:gsub("^%s*(.-)$", "%1")return a end
TrimRight=function(s)local a=s:gsub("^(.-)%s*$", "%1")return a end
StartsWith=function(a,b)return a:sub(1,#b)==b end


print(TrimLeft('          amogus'))

function Error(msg)
    error(msg)
end



--[[
https://github.com/bui/taiko-web/wiki/TJA-format
https://whmhammer.github.io/tja-tools/
https://github.com/WHMHammer/tja-tools/blob/master/src/js/parseTJA.js
https://github.com/bui/taiko-web/blob/master/public/src/js/parsetja.js

Steps:
Parse Settings
Parse Measures
]]
function ParseTJA(source)
    local Parsed = {
        Settings = {},
        Data = {}
    }
    local songstarted = false
    local lines = Split(source, '\n')
    for i = 1, #lines do
        local line = TrimLeft(lines[i])
        if StartsWith(line, '//') or line == '' then
            --Do nothing
        else
            local done = false

            
            --Metadata
            if done == false then
                local match = {string.match(line, '(%u+):(.*)')}
                if match[1] then
                    done = true
                end
            end

            --Command
            if done == false then
                local match = {string.match(line, '#(%u-)%s(.*)')}
                if match[1] then
                    done = true
                end
            end


            
            if done == false then
                --Could not recognize command, probably just raw data
            end
            --[[
            if songstarted == false then
                --Get settings / check whether song has started
                
            else

            end
            --]]
        end
    end
end


require'ppp'(ParseTJA(io.open('test.tja','r'):read()))