--[[
    commandv1.lua

    to provide commands for the pause menu

    a rewritten version of Commandv5.lua
]]







Command = {}

--Key value table of commands, key is name, value is command
Command.Data = {}











function Command.GetCommand(commandname)
    return Command.Data[commandname]
end

function Command.MakeCommand(t)
    for i = 1, #t do
        local command = t[i]

        Command.Data[command.Name] = command
        for i = 1, #command.Alias do
            Command.Data[command.Alias[i]] = command
        end
    end
end




--Utilities used by commands
function Command.Output()
    
end
































Command.MakeCommand(require('defaultcommands'))