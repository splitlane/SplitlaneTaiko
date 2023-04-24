#!..\raylua_s.exe .\test.lua
--[[
    commandv1.lua

    to provide commands for the pause menu

    a rewritten version of Commandv5.lua


    References:
    https://eryn.io/Cmdr/
    https://devforum.roblox.com/t/cmdr-a-fully-extensible-and-type-safe-command-console-for-roblox-developers/182815/18
    https://github.com/evaera/Cmdr/releases

    FS: https://github.com/evaera/Cmdr/issues/78


    TODO:
    Wrap text
    Autocomplete better GUI
    Command.Input
    Validation on str so commands don't error when passed with incorrect arguments
    Type validation
    Type parsing (no need to manually check if number)
    Add default to args
    Compute display results once so it doesn't have to be recomputed each time
    Compute autocompleterender in Command.AutoComplete
    FileSystem
        commands
        prompt
    Alias replaces itself with the one name

    NOTE:
    Autocomplete results also include aliases
]]


--SETTINGS (--TODO MOVE TO CONFIG)
local fontsize = 50 --Used to render text (font size)
--local lineheight = fontsize + 25 --Used for scrolling --NOPE: Calculed using GetTextSize
local scrollwheelmul = 20 --Multiplier for scroll wheel

--SCROLLBAR
local scrollbarwidth = 34 --Scrollbar width in pixels

local scrollbarbackgroundrect = rl.new('Rectangle', Config.ScreenWidth - scrollbarwidth, 0, scrollbarwidth, Config.ScreenHeight) --Rectangle for the background of scrollbar (will be outlined (overlapping the rect) with a white 1px)
local scrollbarrect = rl.new('Rectangle', Config.ScreenWidth - scrollbarwidth, 0, scrollbarwidth, Config.ScreenHeight) --Rectangle for the scrollbar (will be outlined (overlapping the rect) with a white 1px)

--Copied straight from command prompt colors (windows 10)
local scrollbarbackgroundcolor = rl.new('Color', 240, 240, 240, 255) --Scrollbar background color
local scrollbarcoloridle = rl.new('Color', 205, 205, 205, 255) --Scrollbar color
local scrollbarcolorhover = rl.new('Color', 166, 166, 166, 255) --Scrollbar color (hovering)
local scrollbarcolormove = rl.new('Color', 96, 96, 96, 255) --Scrollbar color (moving)

local scrollbarcolor = scrollbarcoloridle

--AUTOCOMPLETE
local autocompletetitlecolor = rl.new('Color', 20, 20, 20, 255)
local autocompletedescriptioncolor = rl.new('Color', 80, 80, 80, 255)
local autocompletetypecolor = rl.new('Color', 60, 60, 60, 255)
local autocompleteresultscolor = rl.new('Color', 130, 130, 130, 255)
local autocompleteselectedcolor = rl.new('Color', 0, 0, 0, 255)
local autocompleteselectedprogresscolor = rl.new('Color', 66, 135, 245, 255)












local function utf8Encode(t,derp,...)
    if derp ~= nil then
        t = {t,derp,...}
    end
    local s = {}
    for i, codepoint in ipairs(t) do
        -- manually doing the common codepoints to avoid calling logarithm
        if codepoint < 0x80 then
            s[#s + 1] = string.char(codepoint)
        elseif codepoint < 0x800 then
            s[#s + 1] = string.char(bit.bor(bit.rshift(codepoint,6),0xc0))
            s[#s + 1] = string.char(bit.bor(bit.band(codepoint,0x3F),0x80))   
        elseif codepoint < 0x10000 then
            s[#s + 1] = string.char(bit.bor(bit.rshift(codepoint,12),0xe0))
            s[#s + 1] = string.char(bit.bor(bit.band(bit.rshift(codepoint,6),0x3F),0x80))
            s[#s + 1] = string.char(bit.bor(bit.band(codepoint,0x3F),0x80))
        elseif codepoint < 0x200000 then
            s[#s + 1] = string.char(bit.bor(bit.rshift(codepoint,18),0xf0))
            s[#s + 1] = string.char(bit.bor(bit.band(bit.rshift(codepoint,12),0x3F),0x80))
            s[#s + 1] = string.char(bit.bor(bit.band(bit.rshift(codepoint,6),0x3F),0x80))
            s[#s + 1] = string.char(bit.bor(bit.band(codepoint,0x3F),0x80))
        else
            -- alpha centauri?!
            s[#s + 1] = utf8longEncode(codepoint)
        end
    end
    return table.concat(s)
end

local function utf8Decode(s)
    local res, seq, val = {}, 0, nil
    for i = 1, #s do
        local c = string.byte(s, i)
        if seq == 0 then
            table.insert(res, val)
            seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6 or
                error("invalid UTF-8 character sequence")
            val = bit.band(c, 2^(8-seq) - 1)
        else
            val = bit.bor(bit.lshift(val, 6), bit.band(c, 0x3F))
        end
        seq = seq - 1
    end
    table.insert(res, val)
    --table.insert(res, 0)
    return res
end


--Taikov34.lua function
local function GetTextSize(str, fontsize)
    --[[
    return rl.MeasureText(str, fontsize) --only x
    --]]

    -- [[
    local defaultfontsize = 10
    if fontsize < defaultfontsize then
        fontsize = defaultfontsize
    end
    local spacing = fontsize / defaultfontsize

    local v = rl.MeasureTextEx(rl.GetFontDefault(), str, fontsize, spacing)
    return math.floor(v.x), math.floor(v.y)
    --]]
end

--Original functions
local function IsVectorInRectangle(v, r)
    return r.x <= v.x and v.x <= r.x + r.width and r.y <= v.y and v.y <= r.y + r.height
end

--[[
    https://www.raylib.com/examples/text/loader.html?name=text_rectangle_bounds
    
    Implemented my own algorithm after all.
    It is efficient, and returns a table of table of codepoints
--]]
local function WrapText(text, font, fontsize, sx, spacing, wordwrapon)
    --local text = utf8Decode(rawtext)
    --text is codepoint array

    --config
    local textoffsety = 0 --when newline
    local textoffsetx = 0
    local scalefactor = fontsize / font.baseSize

    local insertdash = true --insert dash to signify word continuance
    if wordwrapon then
        insertdash = false
    end
    local dashchar = string.byte('-')


    --out
    local out = {
        --list of list of codepoints
    }
    local previousseeki = 1
    local previousi = 1
    local cx = 0
    local newlineflag = nil
    local dontinsertthiscodepointflag = nil --Avoid duplicating newlines
    local dontinsertdashflag = true --Avoid inserting dash when intentional newline (NOTE: turned on at start since we don't want dash at start)
    local insertdashnextflag = nil --Dashhes are inserted next

    for i = 1, #text do
        local codepoint = text[i]

        local index = rl.GetGlyphIndex(font, codepoint)


        if codepoint == 10 then --\n
            previousseeki = i
            dontinsertdashflag = true
            dontinsertthiscodepointflag = true
            newlineflag = true
        else
            cx = cx + ((font.glyphs[index].advanceX == 0) and (font.recs[index].width * scalefactor) or (font.glyphs[index].advanceX * scalefactor))
            if i < #text then
                cx = cx + spacing
            end

            if not wordwrapon then
                if cx >= sx then
                    newlineflag = true
                    --use last previousseeki
                else
                    previousseeki = i
                end
            end
        end
        --print(i, string.char(codepoint), cx)
        if wordwrapon and codepoint == 32 then --space
            --[[
            if cx >= sx or (previousi == previousseeki + 1) then
                --print(cx, sx)
                --one word longer than entire line
                if previousi == previousseeki then
                    previousseeki = i
                elseif previousi == previousseeki + 1 then
                    previousseeki = i
                end
                newlineflag = true
                --use last previousseeki
                --print('G', previousi, previousseeki, rawtext:sub(previousi, previousseeki))
            --]]
            if cx >= sx then
                newlineflag = true
                --use last previousseeki
            else
                previousseeki = i
                --print('B', previousi, previousseeki, rawtext:sub(previousseeki, previousi))
            end
        end

        if newlineflag then
            local t = {}

            if insertdashnextflag then
                t[#t + 1] = dashchar
                insertdashnextflag = nil
            end
            if insertdash and (not dontinsertdashflag) then
                insertdashnextflag = true
            end

            for i2 = previousi, previousseeki - 1 do
                t[#t + 1] = text[i2]
            end

            if not dontinsertthiscodepointflag then
                t[#t + 1] = text[previousseeki]
            end

            out[#out + 1] = t
            previousi = previousseeki + 1
            cx = 0

            newlineflag = nil
            dontinsertthiscodepointflag = nil
            dontinsertdashflag = nil
        end
    end

    --put remaining
    local t = {}
    for i2 = previousi, #text do
        t[#t + 1] = text[i2]
    end
    out[#out + 1] = t

    return out
end

--[[
a = WrapText('hsdamogusamogusamogusamogusamogus hsdamogusamogusamogusamogusamogus a hsdamogusamogusamogusamogusamogus a hsdamogusamogusamogusamogusamogus a hsdamogusamogusamogusamogusamogus a hsdamogusamogusamogusamogusamogus a', rl.GetFontDefault(), 10, 200, 5, true)
for i = 1, #a do
    print(utf8Encode(a[i]))
end
error()
--]]


--[[
    Easy helper function for wrapping display text.

    Inefficient + lazy but works
]]
local function WrapStringConcat(str, fontsize, sx, spacing, wordwrapon)
    local out = WrapText(utf8Decode(str), rl.GetFontDefault(), fontsize, sx, spacing, wordwrapon)
    for i = 1, #out do
        out[i] = utf8Encode(out[i])
    end
    return table.concat(out, '\n')
end























Command = {}

--Key value table of commands / types, key is name, value is command / types
Command.Data = {
    Command = {

    },
    Type = {

    }
}

--Log of all output
Command.Log = {}

--History of all commands
Command.History = {}

--Last AutoComplete results only
Command.LastAutoComplete = {
    Data = {
        --[[
            [Rank (higher the better, starts at 1)] = string or Command / Arg data table
        --]]
    },
    DataType = nil, --Type of data ('String' or nil if DataTable)
    Arg = nil, --Nil unless Data is not empty and the has arg data
    Error = nil, --Error message here if it errors
}

--Up-to-date strings that have been concatted
Command.Strings = {
    Log = '',
    Path = '',
    Prefix = '',
}

--Event hooks that are set when we need the Command.Init loop to do something
-- [[
Command.Events = {
    Exit = nil,
}
--]]

--Scroll that is shared with Command.Init and Command.Input
Command.Scroll = 0

--FileSystem
Command.Path = {}
Command.User = 'mc08'




--Util
--[[
    Wraps a function. f1 is run first, then f2 is run, then the result of f2 is returned
]]
function Command.MergeFunction(f1, f2)
    return function(...)
        f1(...)
        return f2(...)
    end
end

--[[
    WARNING: Command by itself trusts loadstring and all the commands

    Error wrapped loadstring
]]

--[[
    Returns:
    1. success
    2. function
--]]
function Command.LoadstringF(str)
    local f, err = loadstring(str)
    if f then
        return true, f
    else
        Command.Print(err)
        return nil, err
    end
end

--[[
    Returns:
    1. success
    2. output of run code
--]]
function Command.Loadstring(str)
    local success, f = Command.LoadstringF(str)
    if success then
        local success, out = pcall(f)
        Command.Print(out)
        if success then
            return true, out
        else
            return true, out
        end
    else
        return nil, f
    end
end

--[[
    Returns:
    1. success
    2. function that, when called, returns an expression
--]]
function Command.LoadstringExpressionF(str)
    return Command.LoadstringF('return ' .. str)
end

--[[
    Returns:
    1. success
    2. expression
--]]
function Command.LoadstringExpression(str)
    return Command.Loadstring('return ' .. str)
end


--[[
    Local manipulating functions
]]
local defaultstacklevel = 4 --Default: Function / env that called Command.Init
function Command.GetLocal(name, stacklevel)
    stacklevel = (stacklevel or defaultstacklevel) + 1

    local i = 1
    while true do
        local n, v = debug.getlocal(stacklevel, i)
        if n then
            if n == name then
                return {v}
            end
        else
            --Unable to find local
            return nil
        end
        i = i + 1
    end
end

--You can only set a value of an existing local
function Command.SetLocal(name, value, stacklevel)
    stacklevel = (stacklevel or defaultstacklevel) + 1

    local i = 1
    while true do
        local n, v = debug.getlocal(stacklevel, i)
        if n then
            if n == name then
                debug.setlocal(stacklevel, i, value)
                return true
            end
        else
            --Unable to find local
            return nil
        end
        i = i + 1
    end
end

function Command.GetLocalTable(stacklevel)
    stacklevel = (stacklevel or defaultstacklevel) + 1

    local t = {}

    local i = 1
    while true do
        local n, v = debug.getlocal(stacklevel, i)
        if n then
            --Be able to store nils
            --t[n] = {v}
            --OR
            t[#t + 1] = {n, v}
        else
            --Unable to find local
            break
        end
        i = i + 1
    end

    return t
end

--[[
    Get a table like _G where you can just modify / get values
    WARNING: SLOW
]]
function Command.GetDynamicLocalTable(stacklevel)
    stacklevel = (stacklevel or defaultstacklevel) + 1

    --NOPE: newindex needs A NEW INDEX!
    --[[
    local t = {}

    local i = 1
    while true do
        local n, v = debug.getlocal(stacklevel, i)
        if n then
            t[n] = v
        else
            --Unable to find local
            break
        end
        i = i + 1
    end
    --]]

    local t = {}

    return setmetatable(t, {
        __index = function(t, k)
            return Command.GetLocal(k, stacklevel - 1) --TAIL CALL, so stacklevel-1
        end,
        __newindex = function(t, k, v)
            return Command.SetLocal(k, v, stacklevel - 1) --TAIL CALL, so stacklevel-1
        end
    })
end



--Getters / Setters

function Command.GetType(typename)
    return Command.Data.Type[typename]
end

function Command.MakeType(t)
    for i = 1, #t do
        local argtype = t[i]

        --Validate




        --Make
        Command.Data.Type[argtype.Type] = argtype
    end
end

function Command.GetCommand(commandname)
    return Command.Data.Command[commandname]
end

function Command.MakeCommand(t)
    for i = 1, #t do
        local command = t[i]

        --Debug / Validation
        if command.Name ~= '' then
            --Validate

            --Duplicate Check
            if Command.Data.Command[command.Name] then
                error('Command.MakeCommand: Command ' .. command.Name .. ' already exists')
            end


            --Optional Arg Check
            for i = 1, #command.Args do
                local arg = command.Args[i]
                if arg.Optional and i ~= #command.Args then
                    error('Command.MakeCommand: Command ' .. command.Name .. ' has an optional argument that is not at the end')
                end
            end



            --Make
            Command.Data.Command[command.Name] = command
            for i = 1, #command.Alias do
                --Duplicate Check
                if Command.Data.Command[command.Alias[i]] then
                    error('Command.MakeCommand: Command Alias ' .. command.Name .. ' already exists')
                end

                Command.Data.Command[command.Alias[i]] = command
            end
        end
    end
end



--Search algorithm for autocomplete
function Command.AutoCompleteSearch(str, t)

    --Lower the score the better
    --firstmatch algorithm
    local function search(str1, str2)
        --Assumes #str1 < #str2
        if string.sub(str2, 1, #str1) == str1 then
            return #str2 - #str1
        else
            return nil
        end
    end

    --str is probably smaller than any of the strings in t
    local scores = {}
    for i = 1, #t do
        local str2 = t[i]
        scores[str2] = search(str, str2)
    end

    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

    local out = {}
    for k, v in spairs(scores, function(t, a, b)
        return t[a] < t[b]
    end) do
        --k is str, v is score
        out[#out + 1] = k
    end

    return out
end
--Dictionary version
function Command.AutoCompleteSearchD(str, d)

    --Lower the score the better
    --firstmatch algorithm
    local function search(str1, str2)
        --Assumes #str1 < #str2
        if string.sub(str2, 1, #str1) == str1 then
            return #str2 - #str1
        else
            return nil
        end
    end

    --str is probably smaller than any of the strings in t
    local scores = {}
    for k, v in pairs(d) do
        --WARNING: if it is scores[v] then alias will overwrite!
        scores[k] = search(str, k)
    end

    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

    local out = {}
    for k, v in spairs(scores, function(t, a, b)
        return t[a] < t[b]
    end) do
        --k is str, v is score

        --d[k] -> value, k -> key
        out[#out + 1] = d[k]
    end

    return out
end

--[[
    Updates:

    Command.LastAutoComplete
    Command.Strings.LastAutoComplete

    How it works: Replace argument that is selected with selected autocomplete
]]
function Command.AutoComplete(str)
    local success, out = Command.Parse(str)

    if success then
        if #out == 1 then
            --No arguments, suggest commands
            if out[1] == '' then
                --No input, blank
                Command.LastAutoComplete = {
                    Data = {},
                    Error = nil
                }
            else
                --Input, suggest command
                Command.LastAutoComplete = {
                    Data = Command.AutoCompleteSearchD(out[1], Command.Data.Command),
                    Error = nil
                }
            end
        else
            --Yes arguments, suggest arguments
            local autocomplete = nil

            local command = Command.GetCommand(out[1])

            if command then
                --Get argument type
                local argn = #out - 1
                local arg = command.Args[argn]

                if arg then
                    --Get argument type
                    local argtypename = arg.Type
                    local argtype = Command.GetType(argtypename)
                    --print(argtypename, argtype)

                    --Get type autocomplete
                    local autocomplete = argtype.AutoComplete

                    if autocomplete then
                        Command.LastAutoComplete = {
                            Data = Command.AutoCompleteSearchD(out[#out], autocomplete()),
                            Arg = arg,
                            Error = nil
                        }
                    else
                        --Type has no autocomplete, blank
                        Command.LastAutoComplete = {
                            Data = {},
                            Arg = arg,
                            Error = nil
                        }
                    end
                else
                    --Error message
                    Command.LastAutoComplete = {
                        Data = {},
                        Error = 'AutoComplete: Unable to find arg ' .. argn
                    }
                end
            else
                --Error message
                Command.LastAutoComplete = {
                    Data = {},
                    Error = 'AutoComplete: Unable to find command ' .. out[1]
                }
            end
        end
    else
        --Error message
        Command.LastAutoComplete = {
            Data = {},
            Error = 'AutoComplete: Parsing failed: ' .. out
        }
    end

    if Command.LastAutoComplete.Data then
        Command.LastAutoComplete.DataType = type(Command.LastAutoComplete.Data[1]) == 'string' and 'String' or 'Data'
    end
end


local specialpattern = '["\' ]'
local escapedata = {
    ['\\'] = '\\\\',
    ['\"'] = '\\\"'
}

--Returns the list of arguments (ALSO INCLUDES command)
function Command.Parse(str)
    local currentp = 1 --pos of last arg start
    local seekingp = 1 --start finding from this pos, special + 1
    local out = {}
    while true do
        local specialp = string.find(str, specialpattern, seekingp)
        if specialp then
            local special = string.sub(str, specialp, specialp)

            if special == ' ' then
                out[#out + 1] = string.sub(str, currentp, specialp - 1)
                currentp = specialp + 1
                seekingp = specialp + 1
            elseif special == '"' or special == '\'' then
                --print(specialp, currentp)
                if specialp == currentp then
                    --start quote

                    --SLOW
                    local backslash = false --backslashes in a row
                    local out2 = {}
                    while true do
                        seekingp = seekingp + 1

                        --print(seekingp, #str)
                        if seekingp > #str then
                            --ignore?
                            --break

                            return false, 'Quote does not have an end'
                        end

                        local s = string.sub(str, seekingp, seekingp)
                        --print('s: ', s)
                        if s == '\\' then
                            if backslash then
                                --backslashed backslash
                                out2[#out2 + 1] = s
                            else
                                --starting backslash
                                backslash = true
                            end
                        elseif s == special then
                            if backslash then
                                --backslashed quote
                                out2[#out2 + 1] = s
                                backslash = false
                            else
                                --end
                                seekingp = seekingp + 2
                                currentp = seekingp
                                break
                            end
                        else
                            backslash = false
                            out2[#out2 + 1] = s
                        end
                    end

                    seekingp = seekingp + 1

                    if string.sub(str, seekingp, seekingp) == ' ' then
                        out[#out + 1] = table.concat(out2)
                        currentp = seekingp + 1
                        seekingp = seekingp + 1
                    elseif seekingp > #str then
                        out[#out + 1] = table.concat(out2)
                        break
                    else
                        --ignore?
                        --NO EASY SOLUTION TO IGNORE THIS

                        return false, 'Quote ends in the middle of an argument'
                    end

                else
                    --ignore?
                    --seekingp = specialp + 1
                    
                    return false, 'Quote starts in the middle of an argument'
                end
            end
        else
            out[#out + 1] = string.sub(str, currentp, -1)
            break
        end
    end
    return true, out
end

--Serializes an str from a table of args
function Command.Serialize(t)
    local out = {}

    for i = 1, #t do
        local arg = t[i]

        if string.find(arg, specialpattern) then
            out[#out + 1] = '"'

            out[#out + 1] = string.gsub(arg, '(.)', function(s)
                return escapedata[s]
            end)

            out[#out + 1] = '"'
        else
            out[#out + 1] = arg
        end

        if i ~= #t then
            out[#out + 1] = ' '
        end
    end

    return table.concat(out)
end

function Command.EscapeArgument(str)
    local out = string.gsub(str, '(.)', function(s)
        return escapedata[s]
    end)
    return out
end

function Command.RunCommand(command, out)
    --TODO: Type validation (actually not validation since the command shouldn't even be sent), parsing

    --ENV (Persistent command.Data)
    local oldData = Data
    Data = command.Data

    command.Run(select(2, unpack(out)))

    --ENV (Persistent command.Data)
    command.Data = Data
    Data = oldData
end

function Command.Run(str)
    local success, out = Command.Parse(str)

    if success then
        --Add command to log
        --Command.Print(str)
        --NOPE, Command.Run is not responsible for this

        --Run command
        local command = Command.GetCommand(out[1])
        
        if command then
            --Run
            --command.Run(select(2, unpack(out)))
            Command.RunCommand(command, out)
        else
            --Error message
            Command.Error('Unable to find command ' .. out[1])
        end
    else
        --Error message
        Command.Error('Parsing failed: ' .. out)
    end
end








--Utilities used by commands
function Command.Input()
    --Either replicate Command.Init or coroutines?

    --Replicate Command.Init it is!

    --local sx, sy = GetTextSize(str, fontsize)
    local out = {}
    local prefix = ''

    local mouseposition = nil
    local lastframemove = false
    local mousemovestartoffset = nil

    --Autocomplete

    --Update display
    local displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
    local sx, sy = GetTextSize(displaytext, fontsize)

    local lastsy = 0

    --https://github.com/raysan5/raylib/blob/e2da32e2daf2cf4de86cc1128a7b3ba66a1bab1c/src/rtext.c#L1078
    --local _, lineheight = GetTextSize('', fontsize)
    local lineheight = fontsize * 1.5
    local spacingbetweenlines = fontsize * 0.5

    --local displaytext = prefix .. ''
    while not (rl.WindowShouldClose() or Command.Events.Exit) do
        mouseposition = rl.GetMousePosition()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        --displaytext
        rl.DrawText(displaytext, 0, -Command.Scroll, fontsize, rl.BLACK)

        --autocomplete

        --scrollbar
        rl.DrawRectangleRec(scrollbarbackgroundrect, scrollbarbackgroundcolor)
        scrollbarrect.height = (Config.ScreenHeight / ((sy - fontsize) + Config.ScreenHeight)) * Config.ScreenHeight
        --scroll == 0 -> sy - lineheight == 0?
        scrollbarrect.y = Command.Scroll == 0 and 0 or ((Command.Scroll / (sy - fontsize)) * (Config.ScreenHeight - scrollbarrect.height))
        if lastframemove then
            scrollbarcolor = scrollbarcolormove
            lastframemove = false
        else
            if IsVectorInRectangle(mouseposition, scrollbarrect) then
                scrollbarcolor = scrollbarcolorhover
            else
                scrollbarcolor = scrollbarcoloridle
            end
        end
        rl.DrawRectangleRec(scrollbarrect, scrollbarcolor)
        rl.DrawRectangleLinesEx(scrollbarbackgroundrect, 1, rl.WHITE)


        rl.EndDrawing()

        while true do
            local c = rl.GetCharPressed()
            if c == 0 then
                break
            else
                out[#out + 1] = c
                --Update display
                displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
                sx, sy = GetTextSize(displaytext, fontsize)
            end
        end

        --Remember, GetCharPressed doesn't detect special keys
        if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
            out[#out] = nil

            --Update display
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
            sx, sy = GetTextSize(displaytext, fontsize)
        end
        if rl.IsKeyPressed(rl.KEY_ENTER) then
            --Add command to log
            Command.Print(prefix .. utf8Encode(out))

            
            return utf8Encode(out)

        end
        if rl.IsKeyPressed(rl.KEY_ESCAPE) then
            return nil
        end



        --scroll
        local scrollwheel = rl.GetMouseWheelMoveV()
        if scrollwheel.y ~= 0 then
            Command.Scroll = Command.Scroll - (scrollwheel.y * scrollwheelmul)
        end
        --[[
        if rl.IsKeyPressed(rl.KEY_UP) then
            scroll = scroll - lineheight
        end
        if rl.IsKeyPressed(rl.KEY_DOWN) then
            scroll = scroll + lineheight
        end
        --]]
        if rl.IsKeyPressed(rl.KEY_PAGE_UP) then
            Command.Scroll = 0
        end
        if rl.IsKeyPressed(rl.KEY_PAGE_DOWN) then
            --[[
            --LEGACY: Calculated with default font and brute force testing
            local _, count = string.gsub(displaytext, '\n', '\n')
            
            scroll = lineheight * (count + 1) - Config.ScreenHeight
            --]]

            --NOW: Calculate with GetTextSize
            --scroll = sy - Config.ScreenHeight
            Command.Scroll = sy
        end
        
        if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT) and IsVectorInRectangle(mouseposition, scrollbarrect) then
            mousemovestartoffset = mouseposition.y - scrollbarrect.y
        end
        --if rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT) and IsVectorInRectangle(mouseposition, scrollbarrect) then
        if rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT) and mousemovestartoffset then
            --[[
            --LEGACY: Skips some distance for imprecision
            print((mouseposition.y - lastmouseposition.y))
            scroll = scroll + (mouseposition.y - lastmouseposition.y)
            --]]

            scrollbarrect.y = mouseposition.y - mousemovestartoffset

            --Reverse! scrollbarpos -> scroll
            --scrollbarrect.y = (scroll / (sy - lineheight)) * (Config.ScreenHeight - scrollbarrect.height)
            Command.Scroll = scrollbarrect.y / (Config.ScreenHeight - scrollbarrect.height) * (sy - fontsize)

            lastframemove = true
        else
            mousemovestartoffset = nil
        end
        --lastmouseposition = mouseposition

        --limit scroll
        if Command.Scroll < 0 then
            Command.Scroll = 0
        end
        --print(scroll, sy - lineheight, sy)
        if Command.Scroll > sy - fontsize then
            Command.Scroll = sy - fontsize
        end


        if sy ~= lastsy then
            local offscreen1 = (lastsy - Command.Scroll) - Config.ScreenHeight

            --Was not offscreen before
            if offscreen1 <= 0 then
                local offscreen2 = (sy - Command.Scroll) - Config.ScreenHeight

                --Now it is offscreen
                if offscreen2 > 0 then
                    Command.Scroll = Command.Scroll + offscreen2
                end
            end
        end

        lastsy = sy

    end
end
function Command.Output(out)
    --equal to io.write in lua
    local str = tostring(out)
    
    Command.Log[#Command.Log + 1] = str
    --Command.Log[#Command.Log + 1] = '\n'

    Command.Strings.Log = table.concat(Command.Log)
end
function Command.Print(out)
    --equal to print in lua
    local str = tostring(out)
    
    Command.Log[#Command.Log + 1] = str
    Command.Log[#Command.Log + 1] = '\n'
    
    Command.Strings.Log = table.concat(Command.Log)
end
function Command.Error(out)
    Command.Print('Error: ' .. out)
end
function Command.Clear()
    Command.Log = {}
    
    Command.Strings.Log = table.concat(Command.Log)
end
function Command.ClearHistory()
    Command.History = {}
end
function Command.Exit()
    Command.Events.Exit = true
end

--Command FileSystem
function Command.UpdatePrefix()
    Command.Strings.Prefix = Command.User .. '@' .. Command.DisplayPath(Command.Path) .. '$ '
end

function Command.DisplayPath(path)
    return table.concat(path, '/')
end
function Command.CopyPath(path)
    local out = {}
    for i = 1, #path do
        out[i] = path[i]
    end
    return out
end
function Command.SetCurrentPath(path)
    Command.Path = path
    Command.Strings.Path = Command.DisplayPath(Command.Path)

    Command.UpdatePrefix()
end

function Command.SetCurrentUser(user)
    Command.User = user
    
    Command.UpdatePrefix()
end



--Init command raylib loop
function Command.Init()
    --local sx, sy = GetTextSize(str, fontsize)
    local out = {}
    --local prefix = '> '
    Command.UpdatePrefix()
    local prefix = Command.Strings.Prefix

    --Text wrap for the command log
    local textwrapwidth = Config.ScreenWidth - scrollbarrect.width
    local wordwrapon = false
    --taken from GetTextSize
    local defaultfontsize = 10
    if fontsize < defaultfontsize then
        fontsize = defaultfontsize
    end
    local spacing = fontsize / defaultfontsize



    --NOPE: moved to Command.Scroll
    --local scroll = 0 --0 is aligned to top (this is subtracted fron fontposy)

    local mouseposition = nil
    local lastframemove = false
    local mousemovestartoffset = nil

    --Autocomplete
    local autocompleteselected = 1
    local autocompleterender = false
    local autocompleteresults = nil
    local autocompletelastselected = -1

    --History
    local historyselected = -1
    local historylastselected = -1

    --Update display
    local displaytext = WrapStringConcat(Command.Strings.Log .. prefix .. utf8Encode(out), fontsize, textwrapwidth, spacing, wordwrapon)
    local sx, sy = GetTextSize(displaytext, fontsize)

    --Catchup Scroll
    local lastsy = 0

    --https://github.com/raysan5/raylib/blob/e2da32e2daf2cf4de86cc1128a7b3ba66a1bab1c/src/rtext.c#L1078
    --local _, lineheight = GetTextSize('', fontsize)
    local lineheight = fontsize * 1.5
    local spacingbetweenlines = fontsize * 0.5

    --local displaytext = prefix .. ''
    while not (rl.WindowShouldClose() or Command.Events.Exit) do
        prefix = Command.Strings.Prefix
        mouseposition = rl.GetMousePosition()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        --displaytext
        rl.DrawText(displaytext, 0, -Command.Scroll, fontsize, rl.BLACK)

        --autocomplete
        local autocompletey = sy - Command.Scroll + spacingbetweenlines
        if Command.LastAutoComplete.Error then
            --Error message
            rl.DrawText(Command.LastAutoComplete.Error, 0, autocompletey, fontsize, rl.RED)
        elseif autocompleterender then
            local y = autocompletey

            --Top Result

            --Title
            local selected = nil
            
            if Command.LastAutoComplete.Arg then
                selected = Command.LastAutoComplete.Arg
            else
                selected = Command.LastAutoComplete.Data[autocompleteselected] --focusing on
            end
            
            
            local nametext = nil
            if selected.Optional then
                nametext = selected.Name .. '?'
            else
                nametext = selected.Name
            end
            rl.DrawText(nametext, 0, y, fontsize, autocompletetitlecolor)
            --y = y + lineheight
            local x, _ = GetTextSize(nametext, fontsize)
            x = x + fontsize / 5

            --Type
            y = y + fontsize * 0.4
            rl.DrawText(': ' .. selected.Type, x, y, fontsize * 0.6, autocompletetypecolor)
            y = y - fontsize * 0.4
            y = y + lineheight

            --Description
            rl.DrawText(selected.Description, 0, y, fontsize * 0.8, autocompletedescriptioncolor)
            local _, count = string.gsub(selected.Description, '\n', '\n')
            y = y + lineheight * 0.8 * (count + 1)




            --Results list
            for i = 1, #Command.LastAutoComplete.Data do
                local a = Command.LastAutoComplete.Data[i]
                local name = Command.LastAutoComplete.DataType == 'String' and a or a.Name

                if i == autocompleteselected then
                    rl.DrawText(name, 0, y, fontsize, autocompleteselectedcolor)
                    --Draw progress / current
                    local success, out = Command.Parse(utf8Encode(out))
                    if success then
                        --Check if first letters are the same
                        local last = out[#out]
                        if string.sub(name, 1, #last) == last then
                            --Draw
                            rl.DrawText(out[#out], 0, y, fontsize, autocompleteselectedprogresscolor)
                        else
                            --Don't draw
                        end
                    else
                        --Couldn't parse???
                        --This should never happen, ignore
                    end
                else
                    rl.DrawText(name, 0, y, fontsize, autocompleteresultscolor)
                end
                y = y + lineheight
            end
        end

        --scrollbar
        rl.DrawRectangleRec(scrollbarbackgroundrect, scrollbarbackgroundcolor)
        scrollbarrect.height = (Config.ScreenHeight / ((sy - fontsize) + Config.ScreenHeight)) * Config.ScreenHeight
        --scroll == 0 -> sy - lineheight == 0?
        scrollbarrect.y = Command.Scroll == 0 and 0 or ((Command.Scroll / (sy - fontsize)) * (Config.ScreenHeight - scrollbarrect.height))
        if lastframemove then
            scrollbarcolor = scrollbarcolormove
            lastframemove = false
        else
            if IsVectorInRectangle(mouseposition, scrollbarrect) then
                scrollbarcolor = scrollbarcolorhover
            else
                scrollbarcolor = scrollbarcoloridle
            end
        end
        rl.DrawRectangleRec(scrollbarrect, scrollbarcolor)
        rl.DrawRectangleLinesEx(scrollbarbackgroundrect, 1, rl.WHITE)


        rl.EndDrawing()

        while true do
            local c = rl.GetCharPressed()
            if c == 0 then
                break
            else
                out[#out + 1] = c
                --Update display
                Command.AutoComplete(utf8Encode(out))
                displaytext = WrapStringConcat(Command.Strings.Log .. prefix .. utf8Encode(out), fontsize, textwrapwidth, spacing, wordwrapon)
                sx, sy = GetTextSize(displaytext, fontsize)
            end
        end

        --Remember, GetCharPressed doesn't detect special keys
        if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
            out[#out] = nil

            --Update display
            Command.AutoComplete(utf8Encode(out))
            displaytext = WrapStringConcat(Command.Strings.Log .. prefix .. utf8Encode(out), fontsize, textwrapwidth, spacing, wordwrapon)
            sx, sy = GetTextSize(displaytext, fontsize)
        end
        if rl.IsKeyPressed(rl.KEY_ENTER) then
            --Add command to log
            Command.Print(prefix .. utf8Encode(out))

            --Add command to history
            Command.History[#Command.History + 1] = utf8Encode(out)

            --Reset selected history
            historyselected = -1

            --Run command
            Command.Run(utf8Encode(out))

            out = {}
            --Update display
            Command.AutoComplete(utf8Encode(out))
            displaytext = WrapStringConcat(Command.Strings.Log .. prefix .. utf8Encode(out), fontsize, textwrapwidth, spacing, wordwrapon)
            sx, sy = GetTextSize(displaytext, fontsize)
        end
        if rl.IsKeyPressed(rl.KEY_ESCAPE) then
            return nil
        end

        autocompleterender = #Command.LastAutoComplete.Data > 0 or Command.LastAutoComplete.Arg
        --for k,v in pairs(Command.LastAutoComplete.Data)do print(k,v)end



        --scroll
        local scrollwheel = rl.GetMouseWheelMoveV()
        if scrollwheel.y ~= 0 then
            Command.Scroll = Command.Scroll - (scrollwheel.y * scrollwheelmul)
        end
        --[[
        if rl.IsKeyPressed(rl.KEY_UP) then
            scroll = scroll - lineheight
        end
        if rl.IsKeyPressed(rl.KEY_DOWN) then
            scroll = scroll + lineheight
        end
        --]]
        if rl.IsKeyPressed(rl.KEY_PAGE_UP) then
            Command.Scroll = 0
        end
        if rl.IsKeyPressed(rl.KEY_PAGE_DOWN) then
            --[[
            --LEGACY: Calculated with default font and brute force testing
            local _, count = string.gsub(displaytext, '\n', '\n')
            
            scroll = lineheight * (count + 1) - Config.ScreenHeight
            --]]

            --NOW: Calculate with GetTextSize
            --scroll = sy - Config.ScreenHeight
            Command.Scroll = sy
        end
        
        if rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT) and IsVectorInRectangle(mouseposition, scrollbarrect) then
            mousemovestartoffset = mouseposition.y - scrollbarrect.y
        end
        --if rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT) and IsVectorInRectangle(mouseposition, scrollbarrect) then
        if rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT) and mousemovestartoffset then
            --[[
            --LEGACY: Skips some distance for imprecision
            print((mouseposition.y - lastmouseposition.y))
            scroll = scroll + (mouseposition.y - lastmouseposition.y)
            --]]

            scrollbarrect.y = mouseposition.y - mousemovestartoffset

            --Reverse! scrollbarpos -> scroll
            --scrollbarrect.y = (scroll / (sy - lineheight)) * (Config.ScreenHeight - scrollbarrect.height)
            Command.Scroll = scrollbarrect.y / (Config.ScreenHeight - scrollbarrect.height) * (sy - fontsize)

            lastframemove = true
        else
            mousemovestartoffset = nil
        end
        --lastmouseposition = mouseposition

        --limit scroll
        if Command.Scroll < 0 then
            Command.Scroll = 0
        end
        --print(scroll, sy - lineheight, sy)
        if Command.Scroll > sy - fontsize then
            Command.Scroll = sy - fontsize
        end




        --autocomplete
        if autocompleterender then
            historyselected = -1
            historylastselected = -1

            if rl.IsKeyPressed(rl.KEY_UP) then
                autocompleteselected = autocompleteselected - 1
            end
            if rl.IsKeyPressed(rl.KEY_DOWN) then
                autocompleteselected = autocompleteselected + 1
            end

            --Clip
            if autocompleteselected > #Command.LastAutoComplete.Data then
                autocompleteselected = #Command.LastAutoComplete.Data
            end
            if autocompleteselected < 1 then
                autocompleteselected = 1
            end


            if autocompleteselected ~= autocompletelastselected then
                --NOPE, it is recomputed each frame
            end
            autocompletelastselected = autocompleteselected

            if rl.IsKeyPressed(rl.KEY_TAB) then

                local selected = Command.LastAutoComplete.Data[autocompleteselected]

                if selected then
                    --Erase last argument

                    --ASSUMES STANDARD CONFORMITY (If it doesn't error on parser, it shouldn't here)
                    local i = #out

                    local quoted = out[i] == string.byte('\'') or out[i] == string.byte('\"')
                    if quoted then
                        quoted = out[i]
                    end

                    while true do
                        if i < 1 then
                            break
                        end

                        --check for space
                        if out[i] == 32 then
                            if quoted then
                                if out[i + 1] == quoted then
                                    break
                                else
                                    out[i] = nil
                                end
                            else
                                break
                            end
                        else
                            out[i] = nil
                        end

                        i = i - 1
                    end
                    i = i + 1
                    --i is where the argument starts (after the space)

                    local out2 = utf8Decode(Command.EscapeArgument(selected.Name))

                    for i = 1, #out2 do
                        out[#out + 1] = out2[i]
                    end
                end

                --Add space if it is not the last argument
                local success, parsedout = Command.Parse(utf8Encode(out))
                if success then
                    local command = Command.Data.Command[parsedout[1]]
                    if command then
                        if #parsedout == #command.Args + 1 then
                            --Do nothing
                        else
                            --Add space
                            out[#out + 1] = 32
                        end
                    else
                        --Do nothing
                    end
                else
                    --Do nothing
                end

                --Update display
                Command.AutoComplete(utf8Encode(out))
                displaytext = WrapStringConcat(Command.Strings.Log .. prefix .. utf8Encode(out), fontsize, textwrapwidth, spacing, wordwrapon)
                sx, sy = GetTextSize(displaytext, fontsize)

                autocompleterender = #Command.LastAutoComplete.Data > 0 or Command.LastAutoComplete.Arg

                --Clip
                if autocompleteselected > #Command.LastAutoComplete.Data then
                    autocompleteselected = #Command.LastAutoComplete.Data
                end
                if autocompleteselected < 1 then
                    autocompleteselected = 1
                end
            end
        else
            autocompletelastselected = -1

            if rl.IsKeyPressed(rl.KEY_UP) then
                if historyselected == -1 then
                    historyselected = #Command.History
                else
                    historyselected = historyselected - 1
                end
            end
            if rl.IsKeyPressed(rl.KEY_DOWN) then
                if historyselected == -1 then

                else
                    historyselected = historyselected + 1
                end
            end

            --Clip
            if historyselected == -1 then

            else
                if historyselected > #Command.History then
                    historyselected = #Command.History
                end
                if historyselected < 1 then
                    historyselected = 1
                end

                if historyselected ~= historylastselected and Command.History[historyselected] then
                    out = utf8Decode(Command.History[historyselected])

                    --Update display
                    --Command.AutoComplete(utf8Encode(out)) --DON'T UPDATE AUTOCOMPLETE SINCE IT DISABLES HISTORY SCROLLING
                    displaytext = WrapStringConcat(Command.Strings.Log .. prefix .. utf8Encode(out), fontsize, textwrapwidth, spacing, wordwrapon)
                    sx, sy = GetTextSize(displaytext, fontsize)
                end
            end

            historylastselected = historyselected
        end


        



        --Catchup scroll
        --Check if text is going below screen
        --print(sy - Command.Scroll > Config.ScreenHeight)

        if sy ~= lastsy then
            local offscreen1 = (lastsy - Command.Scroll) - Config.ScreenHeight

            --Was not offscreen before
            if offscreen1 <= 0 then
                local offscreen2 = (sy - Command.Scroll) - Config.ScreenHeight

                --Now it is offscreen
                if offscreen2 > 0 then
                    Command.Scroll = Command.Scroll + offscreen2
                end
            end
        end

        lastsy = sy

    end
    --[[
    out = utf8Encode(out)
    return out ~= '' and out or nil
    --]]
end




























Command.MakeCommand(require('defaultcommands'))
Command.MakeCommand(require('cmdrcommands'))
Command.MakeCommand(require('raylibcommands'))
Command.MakeCommand(require('filesystemcommands'))
Command.MakeCommand(require('debugcommands'))
Command.MakeType(require('defaulttypes'))

