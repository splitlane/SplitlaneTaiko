return {
{
    Name = 'setlocal',
    Alias = {'local set'},
    Type = 'Default: Debug',
    Description = 'Set a local variable to an expression.',
    Args = {
        {
            Name = 'Name',
            Type = 'String',
            Description = 'Name of local',
            Optional = false
        },
        {
            Name = 'Expression',
            Type = 'String',
            Description = 'Expression to set the value',
            Optional = false
        }
    },
    Run = function(name, str)
        local v = Command.LoadstringExpression(str)
        local l = Command.SetLocal(name, v)
    end
},
{
    Name = 'getlocal',
    Alias = {'local get'},
    Type = 'Default: Debug',
    Description = 'Set a local variable to an expression.',
    Args = {
        {
            Name = 'Name',
            Type = 'String',
            Description = 'Name of local',
            Optional = false
        }
    },
    Run = function(name)
        local l = Command.GetLocal(name)
        Command.Print(l)
    end
},
{
    Name = '',
    Alias = {},
    Type = 'Default: Debug',
    Description = 'Exits.',
    Args = {},
    Run = function()
        Command.Exit()
    end
},
{
    Name = '',
    Alias = {},
    Type = 'Default: Debug',
    Description = 'Exits.',
    Args = {},
    Run = function()
        Command.Exit()
    end
},
{
    Name = '',
    Alias = {},
    Type = 'Default: Debug',
    Description = 'Exits.',
    Args = {},
    Run = function()
        Command.Exit()
    end
}
}