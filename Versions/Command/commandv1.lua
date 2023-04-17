--[[
    commandv1.lua

    to provide commands for the pause menu

    a rewritten version of Commandv5.lua


    References:
    https://eryn.io/Cmdr/
    https://devforum.roblox.com/t/cmdr-a-fully-extensible-and-type-safe-command-console-for-roblox-developers/182815/18

    TODO:
    Wrap text
    Autocomplete better GUI
    Command.Input
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
local function WrapText(text, sx)
    --Brute forcer

end



























Command = {}

--Key value table of commands, key is name, value is command
Command.Data = {}

--Log of all output
Command.Log = {}

--History of all commands
Command.History = {}

--Last AutoComplete results only
Command.LastAutoComplete = {
    Data = {
        --[[
            --If it is suggesting arguments: (this is just standard command data)

            [Rank (higher the better, starts at 1)] = {
                Name = 'Name',
                Type = 'Type',
                Description = 'Description',
                Optional = 'Optional',
            }

            --If it is suggesting arguments: (this is just standard arg data)

            [Rank (higher the better, starts at 1)] = {
                Name = 'Name',
                Alias = 'Alias'
                Type = 'Type', --Not used for anything important, just display
                Description = 'Description',
            }
        --]]
    },
    Error = nil, --Error message here if it errors
}

--Up-to-date strings that have been concatted
Command.Strings = {
    Log = '',
}

--Event hooks that are set when we need the Command.Init loop to do something
Command.Events = {
    Clear = nil,
    Input = nil,
}









function Command.GetCommand(commandname)
    return Command.Data[commandname]
end

function Command.MakeCommand(t)
    for i = 1, #t do
        local command = t[i]

        --Validate

        --Duplicate Check
        if Command.Data[command.Name] then
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
        Command.Data[command.Name] = command
        for i = 1, #command.Alias do
            Command.Data[command.Alias[i]] = command
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
        scores[str2] = search(str, str2.Name)
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
function Command.AutoCompleteSearchD(str, d)
    --convert dictionary to table (assumes k is str2)
    local t = {}
    for k, v in pairs(d) do
        t[#t + 1] = v
    end
    return Command.AutoCompleteSearch(str, t)
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
                    Data = Command.AutoCompleteSearchD(out[1], Command.Data),
                    Error = nil
                }
            end
        else
            --Yes arguments, suggest arguments
            Command.LastAutoComplete = {
                Data = {},
                Error = nil
            }
        end
    else
        --Error message
        Command.LastAutoComplete = {
            Data = {},
            Error = 'AutoComplete: Parsing failed: ' .. out
        }
    end
end

--Returns the list of arguments (ALSO INCLUDES command)
function Command.Parse(str)
    local specialpattern = '["\' ]'
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

                    out[#out + 1] = table.concat(out2)

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
    local specialpattern = '["\' ]'
    local escapedata = {
        ['\\'] = '\\\\',
        ['\"'] = '\\\"'
    }
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
    local escapedata = {
        ['\\'] = '\\\\',
        ['\"'] = '\\\"'
    }
    local out = string.gsub(str, '(.)', function(s)
        return escapedata[s]
    end)
    return out
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
            command.Run(select(2, unpack(out)))
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
function Command.Input(out)
    --local sx, sy = GetTextSize(str, fontsize)
    local out = {}
    --local prefix = 'Input> '
    local prefix = '' --No prefix to allow more customisability

    --Update display
    local displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)

    while not rl.WindowShouldClose() do
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawText(displaytext, 0, 0, fontsize, rl.BLACK)
        rl.EndDrawing()

        while true do
            local c = rl.GetCharPressed()
            if c == 0 then
                break
            else
                out[#out + 1] = c
                --Update display
                displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
            end
        end

        --Remember, GetCharPressed doesn't detect special keys
        if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
            out[#out] = nil
            --Update display
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
        end
        if rl.IsKeyPressed(rl.KEY_ENTER) then
            --Add newline
            Command.Log[#Command.Log + 1] = '\n'

            return utf8Encode(out)

            --[[
            out = {}
            --Update display
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
            --]]
        end
        if rl.IsKeyPressed(rl.KEY_ESCAPE) then
            return nil
        end
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


--Init command raylib loop
function Command.Init()
    --local sx, sy = GetTextSize(str, fontsize)
    local out = {}
    local prefix = '> '
    local scroll = 0 --0 is aligned to top (this is subtracted fron fontposy)

    local mouseposition = nil
    local lastframemove = false
    local mousemovestartoffset = nil

    --Autocomplete
    local autocompleteselected = 1
    local autocompleterender = false
    local autocompleteresults = nil
    local autocompletelastselected = -1

    --Update display
    local displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
    local sx, sy = GetTextSize(displaytext, fontsize)

    --https://github.com/raysan5/raylib/blob/e2da32e2daf2cf4de86cc1128a7b3ba66a1bab1c/src/rtext.c#L1078
    --local _, lineheight = GetTextSize('', fontsize)
    local lineheight = fontsize * 1.5
    local spacingbetweenlines = fontsize * 0.5

    --local displaytext = prefix .. ''
    while not rl.WindowShouldClose() do
        mouseposition = rl.GetMousePosition()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        --displaytext
        rl.DrawText(displaytext, 0, -scroll, fontsize, rl.BLACK)

        --autocomplete
        local autocompletey = sy - scroll + spacingbetweenlines
        if Command.LastAutoComplete.Error then
            --Error message
            rl.DrawText(Command.LastAutoComplete.Error, 0, autocompletey, fontsize, rl.RED)
        elseif autocompleterender then
            local y = autocompletey

            --Top Result

            --Title
            local selected = Command.LastAutoComplete.Data[autocompleteselected] --focusing on
            rl.DrawText(selected.Name, 0, y, fontsize, autocompletetitlecolor)
            --y = y + lineheight
            local x, _ = GetTextSize(selected.Name, fontsize)
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

                if i == autocompleteselected then
                    rl.DrawText(a.Name, 0, y, fontsize, autocompleteselectedcolor)
                else
                    rl.DrawText(a.Name, 0, y, fontsize, autocompleteresultscolor)
                end
                y = y + lineheight
            end
        end

        --scrollbar
        rl.DrawRectangleRec(scrollbarbackgroundrect, scrollbarbackgroundcolor)
        scrollbarrect.height = (Config.ScreenHeight / ((sy - fontsize) + Config.ScreenHeight)) * Config.ScreenHeight
        --scroll == 0 -> sy - lineheight == 0?
        scrollbarrect.y = scroll == 0 and 0 or ((scroll / (sy - fontsize)) * (Config.ScreenHeight - scrollbarrect.height))
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
                displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
                sx, sy = GetTextSize(displaytext, fontsize)
            end
        end

        --Remember, GetCharPressed doesn't detect special keys
        if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
            out[#out] = nil

            --Update display
            Command.AutoComplete(utf8Encode(out))
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
            sx, sy = GetTextSize(displaytext, fontsize)
        end
        if rl.IsKeyPressed(rl.KEY_ENTER) then
            --Add command to log
            Command.Print(prefix .. utf8Encode(out))

            --Add command to history
            Command.History[#Command.History + 1] = utf8Encode(out)

            Command.Run(utf8Encode(out))

            out = {}
            --Update display
            Command.AutoComplete(utf8Encode(out))
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
            sx, sy = GetTextSize(displaytext, fontsize)
        end
        if rl.IsKeyPressed(rl.KEY_ESCAPE) then
            return nil
        end

        autocompleterender = #Command.LastAutoComplete.Data > 0



        --scroll
        local scrollwheel = rl.GetMouseWheelMoveV()
        if scrollwheel.y ~= 0 then
            scroll = scroll - (scrollwheel.y * scrollwheelmul)
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
            scroll = 0
        end
        if rl.IsKeyPressed(rl.KEY_PAGE_DOWN) then
            --[[
            --LEGACY: Calculated with default font and brute force testing
            local _, count = string.gsub(displaytext, '\n', '\n')
            
            scroll = lineheight * (count + 1) - Config.ScreenHeight
            --]]

            --NOW: Calculate with GetTextSize
            --scroll = sy - Config.ScreenHeight
            scroll = sy
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
            scroll = scrollbarrect.y / (Config.ScreenHeight - scrollbarrect.height) * (sy - fontsize)

            lastframemove = true
        else
            mousemovestartoffset = nil
        end
        --lastmouseposition = mouseposition

        --limit scroll
        if scroll < 0 then
            scroll = 0
        end
        --print(scroll, sy - lineheight, sy)
        if scroll > sy - fontsize then
            scroll = sy - fontsize
        end




        --autocomplete
        if autocompleterender then
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
                    local i = #out
                    while true do
                        if i < 1 then
                            break
                        end

                        --check for space
                        if out[i] == 32 then
                            break
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

                    --Add space if it is not the last argument
                    local success, parsedout = Command.Parse(utf8Encode(out))
                    if success then
                        local command = Command.Data[parsedout[1]]
                        if command then
                            if #parsedout[1] == #command.Args + 1 then
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
                    displaytext = Command.Strings.Log .. prefix .. utf8Encode(out)
                    sx, sy = GetTextSize(displaytext, fontsize)

                    autocompleterender = #Command.LastAutoComplete.Data > 0

                    --Clip
                    if autocompleteselected > #Command.LastAutoComplete.Data then
                        autocompleteselected = #Command.LastAutoComplete.Data
                    end
                    if autocompleteselected < 1 then
                        autocompleteselected = 1
                    end
                end
            end
        else
            autocompletelastselected = -1
        end

    end
    --[[
    out = utf8Encode(out)
    return out ~= '' and out or nil
    --]]
end




























Command.MakeCommand(require('defaultcommands'))