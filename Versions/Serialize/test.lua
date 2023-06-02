local t = {
    a = t
}

print(t.a)


local t
t = {
    a = t
}

print(t.a)


local t = {

}
t.a = t

print(t.a)


--HMMMMMM::: INDEX IS EVALUATED FIRST WHILE VALUE IS SET

a=function()print('a')return 2 end b=function()print'b't[2] = nil end

t[a()] = b()

print(t[a()])


t[{}] = 1
print(t[{}])