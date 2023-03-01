--[[
    code.lua

    implementation of the drumroll rendering code used by my unnamed taiko game.

    assumes x1, x2 are in cartesian coordinates.


    Note: I used DrawTexture as a simple texture drawing function, see explanation at line 20.
    Note: Lua for loops conventionally start at 1. and arrays do to. so, i wrote translated code for like c or any other language.


    WARNINGS:
    - the tjap3 / forks endnote texture starts from the middle, so it is like a semicircle. be sure to account for this by adding / subtracting to x1 and x2
    - rectangles have the same size as the notes, and the centers are the same (sizex / 2, sizey / 2). this means that if i do DrawTexture(texture, sourcerect, 2d(0, 0), rotation), it will put the note CENTER ON (0, 0). so, the note texture will span from (-sizex / 2, -sizey / 2) to (sizex / 2, sizey / 2)


    Feel free to ask me if you have any questions
]]


--DrawTexture function
local function DrawTexture(texture, sourcerect, 2d(x, y), rotation)
    --[[
        Simple draw texture function for this implementation.

        For my unnamed taiko game, I use a library called raylib to draw textures and play music. Raylib (https://github.com/raysan5/raylib) is a minimalistic, easy-to-learn, and low-level spartan library for coding games. It is hardware accelerated with OpenGL, and has bindings for over 50 languages including luajit FFI.

        However, it is pretty complicated to grasp all of the low-level parameters, so for this piece of explanation / example code (it doesn't run) I just made this example function to be clear for the explanation.

        
        HOW IT WORKS:

        texture is the texture.
        sourcerect is a selection of the texture. it is just like a cropping rectangle.
        2d(x, y) is a 2d vector
        rotation is a rotation (0 is upright, -90 is left, 90 is right)

        center is tsizex / 2, tsizey / 2. this is not in the parameter for this simple function, and is hard-coded. it is subtracted from the 2d(x, y) vector.
    ]]
end


--Variables

--Textures (self explanatory)
local TEXTURE_startnote
local TEXTURE_middle
local TEXTURE_endnote

local SENotes --Array containing all SENotes

--Texture sizes
local tsizex = 130 --texture size x
local tsizey = 130 --texture size y

local SENoteOffsetY = 80 --how much pixels is SENote below?

--Notes
local startnote = startnote --startnote, self explanatory
local endnote = endnote --endnote, self explanatory

--Coordinates (centers of the note)
local x1, y1 = startnote.x, startnote.y
local x2, y2 = endnote.x, endnote.y

--Rectangles
local allsourcerect --Rectangle covering all of the texture, from (0, 0) to (tsizex, tsizey)


--Main formula for rotation
--You should probably optimize this and not call this every frame unless the startnote and endnote scrolls are different.
local rotationr = 0 - math.deg(math.atan2(
    (y2 - y1),
    (x2 - x1)
))





--Draw middle

--Distance from startnote (used to normalize the increment vector) (simple distance formula!).
local d = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)

--Multipliers used for normalization.
local mulx = (x2 - x1) / d
local muly = (y2 - y1) / d

--Increment values (used for incrementing the position).
local incrementx = tsizex * mulx
local incrementy = tsizey * muly

--Division (splitting up the long drumroll into several texture).
local div = math.floor(d / tsizex)
local mod = d - (div * tsizex)
--mod is the "left over" drumroll length.


--Starting values, these are incremented
local x = x1 + offsetx + (tsizex / 2 * mulx)
local y = y1 + offsety + (tsizey / 2 * muly)

--SENotes subdivision
local subdiv = 4
local subdivoff = -0.5

--for (int i = 0; i < div; i++) {
for i = 1, div do
    DrawTexture(TEXTURE_middle, allsourcerect, (x, y), rotationr)

    --Draw drumroll line senote

    --for (int i2 = 0; i2 < div - 1; i2++) {
    for i2 = 0, subdiv - 1 do
        local x22 = (x + (incrementx * (i2 / subdiv + subdivoff)))
        local y22 = (y + (incrementy * (i2 / subdiv + subdivoff)) + SENoteOffsetY)
        --TODO: Don't hardcode SENote
        DrawTexture(SENotes[9], allsourcerect, (x22, y22), 0)
    end

    x = x + incrementx
    y = y + incrementy
end


--Now for the "left over" drumroll length

--Initialize a rectangle (sourcerect)
local modsourcerect = rl.new('Rectangle', 0, 0, 0, 0)

modsourcerect.x = 0
modsourcerect.y = 0
modsourcerect.width = mod
modsourcerect.height = tsizey

--Initialize a rectangle (destrect)
local modrect = rl.new('Rectangle', 0, 0, 0, 0)

--Use x, y from previous thing
modrect.x = x
modrect.y = y
modrect.width = mod
modrect.height = tsizey

DrawTexture(TEXTURE_middle, modsourcerect, modrect, rotationr)


--Draw drumroll line senote

--for (int i2 = 0; i2 < div - 1; i2++) {
for i2 = 0, subdiv - 1 do
    local x22 = (x + (incrementx * (i2 / subdiv + subdivoff)))
    local y22 = (y + (incrementy * (i2 / subdiv + subdivoff)) + SENoteOffsetY)
    --TODO: Don't hardcode SENote
    DrawTexture(SENotes[9], allsourcerect, (x22, y22), 0)
end

--Draw final SENote
local x22 = (x + (incrementx * (a / subdiv + subdivoff)))
local y22 = (y + (incrementy * (a / subdiv + subdivoff)) + SENoteOffsetY)
--TODO: Don't hardcode SENote
DrawTexture(SENotes[10], allsourcerect, (x22, y22), 0)


x = x + mod * mulx
y = y + mod * muly





--Draw endnote

--[[
    Note: The notes should always be facing upright
]]
DrawTexture(TEXTURE_endnote, allsourcerect, (x, y), rotationr)



--Draw startnote
DrawTexture(TEXTURE_startnote, allsourcerect, (x1, y1), rotationr)