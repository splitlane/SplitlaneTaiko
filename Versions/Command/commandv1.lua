--[[
    commandv1.lua

    to provide commands for the pause menu

    a rewritten version of Commandv5.lua


    References:
    https://eryn.io/Cmdr/
]]


--SETTINGS (--TODO MOVE TO CONFIG)
local fontsize = 50













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
            --If it is suggesting arguments:

            [Rank (higher the better, starts at 1)] = {
                Name = 'Name',
                Type = 'Type',
                Description = 'Description',
                Optional = 'Optional',
            }

            --If it is suggesting arguments:

            [Rank (higher the better, starts at 1)] = {
                Name = 'Name',
                Alias = 'Alias'
                Type = 'Type', --Not used for anything important, just display
                Description = 'Description',
            }
        --]]
    },

}

--Up-to-date strings that have been concatted
Command.Strings = {
    Log = '',
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
                Command.LastAutoComplete = {}
            else
                --Input, suggest command

            end
        else
            --Yes arguments, suggest arguments

        end
        Command.Strings.LastAutoComplete = table.concat(Command.AutoComplete)
    else
        --Error message
        Command.Strings.LastAutoComplete = 'AutoComplete: Parsing failed: ' .. out
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
            elseif special == '"' then
                --print(specialp, currentp)
                if specialp == currentp then
                    --start quote

                    --SLOW
                    local backslash = false --backslashes in a row
                    local out2 = {}
                    while true do
                        seekingp = seekingp + 1

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
                        elseif s == '"' then
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

    --Update display
    local displaytext = Command.Strings.Log .. prefix .. utf8Encode(out) .. '\n' .. Command.Strings.LastAutoComplete

    --local displaytext = prefix .. ''
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
                Command.AutoComplete(utf8Encode(out))
                displaytext = Command.Strings.Log .. prefix .. utf8Encode(out) .. '\n' .. Command.Strings.LastAutoComplete
            end
        end

        --Remember, GetCharPressed doesn't detect special keys
        if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
            out[#out] = nil

            --Update display
            Command.AutoComplete(utf8Encode(out))
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out) .. '\n' .. Command.Strings.LastAutoComplete
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
            displaytext = Command.Strings.Log .. prefix .. utf8Encode(out) .. '\n' .. Command.Strings.LastAutoComplete
        end
        if rl.IsKeyPressed(rl.KEY_ESCAPE) then
            return nil
        end
    end
    --[[
    out = utf8Encode(out)
    return out ~= '' and out or nil
    --]]
end




























Command.MakeCommand(require('defaultcommands'))