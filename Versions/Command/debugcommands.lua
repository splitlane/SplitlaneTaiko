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
        if l then
            Command.Print(v)
        else
            Command.Error('Unable to find local ' .. name)
            Command.Error('Note that locals need to be declared to be set')
        end
    end
},
{
    Name = 'getlocal',
    Alias = {'local get'},
    Type = 'Default: Debug',
    Description = 'Get a local variable.',
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
        if l then
            Command.Print(l[1])
        else
            Command.Error('Unable to find local ' .. name)
        end
    end
},
{
    Name = 'listlocals',
    Alias = {'local list'},
    Type = 'Default: Debug',
    Description = 'List all local variables.',
    Args = {},
    Run = function()
        local t = Command.GetLocalTable()
        for i = 1, #t do
            local a = t[i]
            Command.Print(tostring(a[1]) .. ': ' .. tostring(a[2]))
        end
    end
},
{
    Name = 'setglobal',
    Alias = {'global set'},
    Type = 'Default: Debug',
    Description = 'Set a global variable to an expression.',
    Args = {
        {
            Name = 'Name',
            Type = 'String',
            Description = 'Name of global',
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
        _G[name] = v
    end
},
{
    Name = 'getglobal',
    Alias = {'global get'},
    Type = 'Default: Debug',
    Description = 'Get a global variable.',
    Args = {
        {
            Name = 'Name',
            Type = 'String',
            Description = 'Name of global',
            Optional = false
        }
    },
    Run = function(name)
        Command.Print(_G[name])
    end
},
{
    Name = 'listglobals',
    Alias = {'global list'},
    Type = 'Default: Debug',
    Description = 'List all global variables.',
    Args = {},
    Run = function()
        for k, v in pairs(_G) do
            Command.Print(tostring(k) .. ': ' .. tostring(v))
        end
    end
},
{
    Name = 'hookglobal',
    Alias = {'global hook'},
    Type = 'Default: Debug',
    Description = 'Runs code when an event happens to a global.',
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