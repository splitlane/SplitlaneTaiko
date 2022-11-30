#! ..\raylua_s.exe 

--[[
    texturemap.lua

    Simple raylib library to extract textures from a texturemap


    --update: supports nested


    WARNING: You have to init before loading any textures
]]


TextureMap = {}


function TextureMap.SplitUsingMap(image, map, defaultsize, xymul, origin)
    --[[
        assumes image is loaded

        map = {
            test = {
                x, y, (xsize), (ysize)
            },
            ...
        }

        defaultsize = {xsize, ysize}
        defaultsize is optional, and map is taken priority 
        defaultsize is -1

        xymul = {x, y}
        xymul is optional, and is multiplied with the x, y of map

        origin = {0, 0}
        added to everything
    ]]


    xymul = xymul or {1, 1}
    origin = origin or {0, 0}

    local function scan(t)
        local out = {}
        for k, v in pairs(t) do
            local nested = false
            for k2, v2 in pairs(v) do
                if type(v2) == 'table' then
                    --out[k] = scan(v2)
                    nested = true
                end
            end
            if nested then
                out[k] = scan(v)
            else
                out[k] = rl.ImageFromImage(image, rl.new('Rectangle', v[1] * xymul[1] + origin[1], v[2] * xymul[2] + origin[2], (v[3] or defaultsize[1]) - 1 + origin[1], (v[4] or defaultsize[2]) - 1 + origin[2]))
            end
        end
        return out
    end

    return scan(map)
end



--For loading singular textures from image
function TextureMap.LoadTextureFromImage(image)
    local texture = rl.LoadTextureFromImage(image)
    rl.UnloadImage(image)
    return texture
end



--Replacing an entire texture map that has been generated with TextureMap.SplitUsingMap with textures and unloading the images
function TextureMap.ReplaceWithTexture(texturemap)
    
    --for k, v in pairs(texturemap) do print(k, v) end error()

    local function scan(map)
        local out = {}
        for k, v in pairs(map) do
            if type(v) == 'table' then
                out[k] = scan(v)
            else
                out[k] = TextureMap.LoadTextureFromImage(v)
            end
        end
        return out
    end

    return scan(texturemap)
end



--All-in one, runs TextureMap.SplitUsingMap and TextureMap.ReplaceWithTexture, and same args as TextureMap.SplitUsingMap
function TextureMap.SplitAndReplaceWithTexture(...)
    return TextureMap.ReplaceWithTexture(TextureMap.SplitUsingMap(...))
end







return TextureMap