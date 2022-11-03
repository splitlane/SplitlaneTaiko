--temporary csv testing + coding parser
--https://csv-spec.org/
function csv(s)
    local seperator = ','
    local newline = '\n'
    for i = 1, #s do

    end
end

function taikocsv(str)
    local seperator = ','
    local escape = '\\'
    local t = {}
    local temp = ''
    local escaped = false
    for i = 1, #str do
        local s = string.sub(str, i, i)
        if escaped then
            temp = temp .. s
            escaped = false
        else
            if s == seperator then
                table.insert(t, temp)
                temp = ''
            elseif s == escape then
                escaped = true
            else
                temp = temp .. s
            end
        end
    end
    table.insert(t, temp)
    return t
end
require'ppp'(taikocsv('1,2,3'))