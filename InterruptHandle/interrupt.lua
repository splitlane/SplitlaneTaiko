--Doesn't work
function a()
    --Malicious code here
    while true do
        print'ac'
    end
end


b = function()
    print(pcall(a))
    print'a'
    b()
end

b()