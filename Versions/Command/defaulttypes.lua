return {
{
    Type = 'Command',
    AutoComplete = function()
        return Command.Data.Command
    end,
    Validate = function(str)
        return Command.GetCommand(str)
    end
},
{
    Type = 'String',
    AutoComplete = nil,
    Validate = function(str)
        return tostring(str)
    end
},
{
    Type = 'Number',
    AutoComplete = nil,
    Validate = function(str)
        return tonumber(str)
    end
}
}