--[[
    We can specify any byte in a short literal string by its numeric value (including embedded zeros). This can be done with the escape sequence \xXX, where XX is a sequence of exactly two hexadecimal digits, or with the escape sequence \ddd, where ddd is a sequence of up to three decimal digits. (Note that if a decimal escape sequence is to be followed by a digit, it must be expressed using exactly three digits.)
    
    lua 5.3 -> 5.1
    Goal: Convert \xXX to \ddd
]]


io.open('out.lua', 'wb+'):write(((((io.open('unicode.lua', 'rb'):read('*all'):gsub('\\x(.)(.)',function(a, b)
    print(a, b)
    return '\\' .. tonumber(a .. b, 16)
end))))))