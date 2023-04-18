--https://eryn.io/Cmdr/Changelog.html
return {
{
    Name = '!',
    Alias = {},
    Type = 'Default: Cmdr',
    Description = 'Reruns some previous command',
    Args = {
        {
            Name = 'History Number',
            Type = 'Number',
            Description = 'The history number for command to rerun',
            Optional = true
        }
    },
    Run = function(n)
        n = tonumber(n)

        n = n or -1
        n = n < 0 and n + #Command.History or n

        --Rewrite history to be explicit so no stack overflow
        Command.History[#Command.History] = '! ' .. n

        Command.Run(Command.History[n])
    end
}
}