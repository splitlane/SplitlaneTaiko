--[[
    filesystemcommands.lua

    linux-like filesystem commands
]]
return {
{
    Name = 'cd',
    Alias = {},
    Type = 'Default: FileSystem',
    Description = 'Exits.',
    Args = {},
    Run = function()
        Command.Exit()
    end
},
{
    Name = 'ls',
    Alias = {},
    Type = 'Default: FileSystem',
    Description = 'Exits.',
    Args = {},
    Run = function()
        Command.Exit()
    end
},
{
    Name = '',
    Alias = {},
    Type = 'Default: FileSystem',
    Description = 'Exits.',
    Args = {},
    Run = function()
        Command.Exit()
    end
},
{
    Name = 'filesystem',
    Alias = {'fs'},
    Type = 'Default: FileSystem',
    Description = 'Interactive filesystem.',
    Args = {},
    Run = function()
        Command.Exit()
    end
}
}