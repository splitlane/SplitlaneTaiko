
ms = 50

bpm = 120
--sign = 4/4

bps = bpm / 60

--notedensity = bps * (400 / ms) / sign

scroll = 1


noteradius = 1






--((200 / ms * noteradius) * (8 /(bps * (400 / ms) / sign)))
--BEST 9/19/2022


--sign = bpm*mspermeasure/240000

--dbg
sign = 4/4
ms = 100
scroll = 1

distance = (noteradius) * (scroll) / (sign) * (ms / 25)
print(distance)

speed = distance / ms
print(speed)
print(9600*noteradius*scroll/(bpm*mspermeasure))

--full formula
--(noteradius * scroll * ms / ((bpm*mspermeasure/240000) * 25)) / ms
--[[
a=noteradius
b=scroll
c=ms
d=bpm
e=msper
9600ab/(de)
]]


error()



--distance = ((200 / ms * noteradius) * (8 / notedensity))

--distance = 4*noteradius/(bps * sign)


--print(4*noteradius/(bps)*sign, ((200 / ms * noteradius) * (8 / notedensity)))

-- [[

notedensity = 2 / ms

distance = ((200 / ms * noteradius) * (8 / notedensity))
print(4*noteradius*sign/bps, distance)
--[[
distance = distance / noteradius
speed = distance / ms * scroll
print(speed)
print(240*noteradius*sign*scroll/(bpm*ms))
print('distance: ' .. distance .. 'r\nspeed: ' .. speed .. '(r/ms)')error()

--]]

--[[
distance = 200*noteradius/ms * (8 / (bps * (400 / ms * sign)))) / noteradius

a=noteradius
b=ms
c=bps
d=sign
--]]


--((200 / b * a) * (8 / (c * (400 / b) / d)))



