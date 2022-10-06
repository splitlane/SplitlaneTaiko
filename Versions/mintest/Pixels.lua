--[[
Pixelsv20.lua

Utilities for generating pixel art / graphics

Focus : MAJOR Function Changes. Will break code from Pixelsv19 or below
WARNING: Code from Pixelsv19 will be broken


Major code cleanup:

Make a point class
Clean up options
Clean up code
Comment the code







Focus: Performance (Increase from 6.175 -> 1.813, ~3x faster)
Focus: Mazes

Focus: ZBuffer (Delayed as of current)

TODO: 

Priority: Z-Buffer
Priority: Make a custom triangle algorithm (http://www.sunshine2k.de/coding/java/TriangleRasterization/TriangleRasterization.html)
Priority: Make a color to every pixel, apply during render
Priority: Converting str format to table


Fixed: Expandable canvas might cause issues with 3d canvas


Done: Setting to negative pixels
Done: Expandable canvas
Done: More 3d
Done: Color optimize
Done: Even more optimization
Done: Mazes
Done: Color in Pixel.Line
Done: Pixel.Circle,
Done: Pixel.Polygon,
Done: Pixel.Fill



Work on:
Done: Typo: Rectangles

Done: Add an optable, to save operations such as lines (When zooming in / out, I lose resolution)

3d library
Done: Making the Pixel class work on 5 * 5
From dots

Optable is not supported for graphs. Also, Saving / Drawing Graphs are terribly inefficient.


Instructions:

This library will convert a bitmap (A stream of 0's and 1's with newlines) into braille


Pixel Layout
123
456
789

{x = 1, y = 1}, {x = 2, y = 1}, {x = 3, y = 1}
{x = 1, y = 2}, {x = 2, y = 2}, {x = 3, y = 2}
{x = 1, y = 3}, {x = 2, y = 3}, {x = 3, y = 3}

Format:

{
    Data = '1111\n1111\n1111\n1111',
    Op = {
        {'Line', arguments}
    },
    Color = {
        All = 'Red' --Optional data tag, will get processed
        {x, y, 'Red'} --One color data
    },
    Offset = {
        x,
        y
    }
    Z = {
        {x, y, z} --Z buffer
    }
}




















https://en.wikipedia.org/wiki/Box-drawing_character
▀   ▄   ▌	▐
▖	▗	▘	▙	▚	▛	▜	▝	▞	▟   █

https://en.wikipedia.org/wiki/Braille_Patterns

]]

--Settings
CacheEnabled = false --Enable cache for converting data to pixels.
WarnEnabled = false --Enable warnings, which show you what to fix.
ErrorEnabled = true --Enable errors, which stops the code.
WarnStrict = false --Warns you when you do something wrong.
DefaultPixel = {} --Default pixel.
ReverseY = false --Reverse y.
os.execute('chcp 65001') --Makes your terminal support unicode. If it is buggy, turn it off









--for debug
--[[
    --This does nto work at ALL
profile = {}
profile.strconcat = 0
profile.varmake = 0
profile.varaccess = 0
profile.venv = {}
function profile.start()
    local function ri(var)
        rawset(profile, var, rawget(profile, var) + 1)
    end
    getmetatable('').__concat = function()

    end
    setmetatable(_G, {
        __newindex = function(t, k, v)
            ri('varmake')
            rawset(profile.venv, k, v)
        end,
        __index = function(t, k)
            ri('varaccess')
            return rawget(profile.venv, k)[k]
        end
    })
end

function profile.stop()
    for k, v in pairs(profile) do
        print(k, v)
    end
end



--]]




Escape = {}
Escape.Data = {
    --First handle normal esc sequences
    ['a'] = '\a',
    ['b'] = '\b',
    ['f'] = '\f',
    ['n'] = '\n',
    ['r'] = '\r',
    ['t'] = '\t',
    ['v'] = '\v',
    ['\\'] = '\\',
    ['\"'] = '\"',
    ['\''] = '\'',
    ['['] = '[',
    [']'] = ']',
}
Escape.DataReversed = {}
for k, v in pairs(Escape.Data) do
    Escape.DataReversed[v] = k
end

function Escape.EscapeToString(str)
    local finalstr = ''
    local Escaped = false
    local skip = 0
    for i = 1, #str do
        if skip > 0 then
            skip = skip - 1
        else
            local tempstr = string.sub(str, i, i)
            if Escaped then
                local temp = Escape.Data[tempstr]
                if temp then
                    finalstr = finalstr .. temp
                else
                    local peek = i
                    local peekdata = ''
                    repeat
                        peekdata = peekdata .. string.sub(str, peek, peek)
                        peek = peek + 1
                        if tonumber(string.sub(str, peek, peek)) == nil then
                            break
                        end
                        if peek == #str then
                            error('Invalid Escape Sequence.')
                        end
                    until peek == #str
                    --print(peek, peekdata)
                    finalstr = finalstr .. string.char(tonumber(peekdata))
                    skip = #peekdata - 1
                end
                Escaped = false
            else
                if tempstr == '\\' then
                    Escaped = true
                else
                    finalstr = finalstr .. tempstr
                end
            end
        end
    end
    return finalstr
end

function Escape.StringToEscape(str, f)
    if f then return str end
    return string.gsub(tostring(str), '\27', '\\27')
end












--debug
LuaMode=true;SerialSeperator='~'EndSeperator='/'Minify=true;PrintOutput=true;printplusplus=function(a)local b={assert,collectgarbage,coroutine,coroutine.create,coroutine.resume,coroutine.running,coroutine.status,coroutine.wrap,coroutine.yield,debug,debug.debug,debug.getfenv,debug.gethook,debug.getinfo,debug.getlocal,debug.getmetatable,debug.getregistry,debug.getupvalue,debug.setfenv,debug.sethook,debug.setlocal,debug.setmetatable,debug.setupvalue,debug.traceback,dofile,dump,error,gcinfo,getfenv,getmetatable,io,io.close,io.flush,io.input,io.lines,io.open,io.output,io.popen,io.read,io.stderr,io.stdin,io.stdout,io.tmpfile,io.type,io.write,ipairs,load,loadfile,loadstring,math,math.abs,math.acos,math.asin,math.atan,math.atan2,math.ceil,math.cos,math.cosh,math.deg,math.exp,math.floor,math.fmod,math.frexp,math.huge,math.ldexp,math.log,math.log10,math.max,math.min,math.mod,math.modf,math.pi,math.pow,math.rad,math.random,math.randomseed,math.sin,math.sinh,math.sqrt,math.tan,math.tanh,module,newproxy,next,os,os.clock,os.date,os.difftime,os.execute,os.exit,os.getenv,os.remove,os.rename,os.setlocale,os.time,os.tmpname,package,package.config,package.cpath,package.loaded,string.byte,string.char,string.dump,string.find,string.format,string.gfind,string.gmatch,string.gsub,string.len,string.lower,string.match,string.rep,string.reverse,string.sub,string.upper,table.concat,table.foreach,table.foreachi,table.getn,table.insert,table.maxn,table.remove,table.setn,table.sort,package.loaders,package.loadlib,package.path,package.preload,package.seeall,pairs,pcall,print,rawequal,rawget,rawset,require,select,setfenv,setmetatable,started,string,table,tonumber,tostring,type,unpack,xpcall}local c={'assert','collectgarbage','coroutine','coroutine.create','coroutine.resume','coroutine.running','coroutine.status','coroutine.wrap','coroutine.yield','debug','debug.debug','debug.getfenv','debug.gethook','debug.getinfo','debug.getlocal','debug.getmetatable','debug.getregistry','debug.getupvalue','debug.setfenv','debug.sethook','debug.setlocal','debug.setmetatable','debug.setupvalue','debug.traceback','dofile','dump','error','gcinfo','getfenv','getmetatable','io','io.close','io.flush','io.input','io.lines','io.open','io.output','io.popen','io.read','io.stderr','io.stdin','io.stdout','io.tmpfile','io.type','io.write','ipairs','load','loadfile','loadstring','math','math.abs','math.acos','math.asin','math.atan','math.atan2','math.ceil','math.cos','math.cosh','math.deg','math.exp','math.floor','math.fmod','math.frexp','math.huge','math.ldexp','math.log','math.log10','math.max','math.min','math.mod','math.modf','math.pi','math.pow','math.rad','math.random','math.randomseed','math.sin','math.sinh','math.sqrt','math.tan','math.tanh','module','newproxy','next','os','os.clock','os.date','os.difftime','os.execute','os.exit','os.getenv','os.remove','os.rename','os.setlocale','os.time','os.tmpname','package','package.config','package.cpath','package.loaded','string.byte','string.char','string.dump','string.find','string.format','string.gfind','string.gmatch','string.gsub','string.len','string.lower','string.match','string.rep','string.reverse','string.sub','string.upper','table.concat','table.foreach','table.foreachi','table.getn','table.insert','table.maxn','table.remove','table.setn','table.sort','package.loaders','package.loadlib','package.path','package.preload','package.seeall','pairs','pcall','print','rawequal','rawget','rawset','require','select','setfenv','setmetatable','started','string','table','tonumber','tostring','type','unpack','xpcall'}local function d(e)local f=e;if type(e)=='string'then local e,g=loadstring(e)if e==nil then return f end end;if pcall(function()string.dump(e)end)then if Minify then return'loadstring\''..(string.gsub(string.dump(e),'.',function(h)return'\\'..h:byte()end)or string.dump(e)..'\'')..'\''else return'loadstring(\''..(string.gsub(string.dump(e),'.',function(h)return'\\'..h:byte()end)or string.dump(e)..'\'')..'\')'end else for i=1,#b do if b[i]==e then return c[i]end end end end;local function j(k)local l=getmetatable(k)local m=nil;if l~=nil then local n=nil;m=''for o,p in pairs(l)do n=true;if Minify then m=m..o..'='..d(p)..','else m=m..o..' = '..d(p)..',\n'end end;if n==true then local q;if Minify then q=1 else q=2 end;m=string.sub(m,1,#m-q)return m else return nil end end end;local function r(s)local t=0;for u in pairs(s)do t=t+1 end;return t end;local function v(s,w)local x=j(s)w=w or 0;local y=r(s)>1;local z=string.rep('    ',w+1)local A="{"..(y and'\n'or'')if Minify then z=''A='{'end;for o,p in pairs(s)do A=A..(y and z or'')if type(o)=='number'then elseif type(o)=='string'and o:match("^[A-Za-z_][A-Za-z0-9_]*$")then A=A..o..(Minify and"="or" = ")elseif type(o)=='string'then A=A..(Minify and"[\'"..o.."\']="or"[\'"..o.."\'] = ")else A=A..(Minify and"["..tostring(o).."]="or"["..tostring(o).."] = ")end;local B,C=SerializeMain(p)A=A..B;if next(s,o)then A=A..","end;if not Minify then if y then A=A..'\n'else A=A..' 'end end end;A=A..(y and string.rep('    ',w)or'').."}"if x~=nil then if Minify then A='setmetatable('..A..',{'..x..'})'else A='setmetatable('..A..', {\n'..x..'\n})'end end;return A end;function SerializeMain(a)local D;local E;local F=SerialSeperator;local G=EndSeperator;if type(a)=='number'or type(a)=='boolean'or type(a)=='nil'then D=tostring(a)E=tostring(a)elseif type(a)=='string'then D='\''..tostring(a)..'\''E=F..type(a)..F..tostring(a)..F..G..type(a)..F elseif type(a)=='table'then D=v(a)E=F..type(a)..F..v(a)..F..G..type(a)..F elseif type(a)=='function'then D=d(a)E=F..type(a)..F..d(a)..F..G..type(a)..F elseif type(a)=='userdata'or type(a)=='thread'then D=type(a)E=F..type(a)..F..F..G..type(a)..F end;return D,E end;local D,E=SerializeMain(a)if PrintOutput then print(LuaMode and D or E)else return LuaMode and D or E end end;ppp=printplusplus








--[[


8 bit braille order
1	4
2	5
3	6
7	8

converted to

1   5
2   6
3   7
4   8


0000 0000
1000 0000
0100 0000
1100 0000

...

0 -> byte
1 -> byte reverse
2 -> byte reverse
3 -> byte reverse

raw data




Braille Patterns[1]
Official Unicode Consortium code chart (PDF)
 	    0	1	2	3	4	5	6	7	8	9	A	B	C	D	E	F
U+280x	⠀	⠁	⠂	⠃	⠄	⠅	⠆	⠇	⠈	⠉	⠊	⠋	⠌	⠍	⠎	⠏
U+281x	⠐	⠑	⠒	⠓	⠔	⠕	⠖	⠗	⠘	⠙	⠚	⠛	⠜	⠝	⠞	⠟
U+282x	⠠	⠡	⠢	⠣	⠤	⠥	⠦	⠧	⠨	⠩	⠪	⠫	⠬	⠭	⠮	⠯
U+283x	⠰	⠱	⠲	⠳	⠴	⠵	⠶	⠷	⠸	⠹	⠺	⠻	⠼	⠽	⠾	⠿
(end of 6-dot cell patterns)
U+284x	⡀	⡁	⡂	⡃	⡄	⡅	⡆	⡇	⡈	⡉	⡊	⡋	⡌	⡍	⡎	⡏
U+285x	⡐	⡑	⡒	⡓	⡔	⡕	⡖	⡗	⡘	⡙	⡚	⡛	⡜	⡝	⡞	⡟
U+286x	⡠	⡡	⡢	⡣	⡤	⡥	⡦	⡧	⡨	⡩	⡪	⡫	⡬	⡭	⡮	⡯
U+287x	⡰	⡱	⡲	⡳	⡴	⡵	⡶	⡷	⡸	⡹	⡺	⡻	⡼	⡽	⡾	⡿
U+288x	⢀	⢁	⢂	⢃	⢄	⢅	⢆	⢇	⢈	⢉	⢊	⢋	⢌	⢍	⢎	⢏
U+289x	⢐	⢑	⢒	⢓	⢔	⢕	⢖	⢗	⢘	⢙	⢚	⢛	⢜	⢝	⢞	⢟
U+28Ax	⢠	⢡	⢢	⢣	⢤	⢥	⢦	⢧	⢨	⢩	⢪	⢫	⢬	⢭	⢮	⢯
U+28Bx	⢰	⢱	⢲	⢳	⢴	⢵	⢶	⢷	⢸	⢹	⢺	⢻	⢼	⢽	⢾	⢿
U+28Cx	⣀	⣁	⣂	⣃	⣄	⣅	⣆	⣇	⣈	⣉	⣊	⣋	⣌	⣍	⣎	⣏
U+28Dx	⣐	⣑	⣒	⣓	⣔	⣕	⣖	⣗	⣘	⣙	⣚	⣛	⣜	⣝	⣞	⣟
U+28Ex	⣠	⣡	⣢	⣣	⣤	⣥	⣦	⣧	⣨	⣩	⣪	⣫	⣬	⣭	⣮	⣯
U+28Fx	⣰	⣱	⣲	⣳	⣴	⣵	⣶	⣷	⣸	⣹	⣺	⣻	⣼	⣽	⣾	⣿







⠀	⠁	⠂	⠃	⠄	⠅	⠆	⠇	⠈	⠉	⠊	⠋	⠌	⠍	⠎	⠏	⠐	⠑	⠒	⠓	⠔	⠕	⠖	⠗	⠘	⠙	⠚	⠛	⠜	⠝	⠞	⠟	⠠	⠡	⠢	⠣	⠤	⠥	⠦	⠧	⠨	⠩	⠪	⠫	⠬	⠭	⠮	⠯	⠰	⠱	⠲	⠳	⠴	⠵	⠶	⠷	⠸	⠹	⠺	⠻	⠼	⠽	⠾	⠿	⡀	⡁	⡂	⡃	⡄	⡅	⡆	⡇	⡈	⡉	⡊	⡋	⡌	⡍	⡎	⡏	⡐	⡑	⡒	⡓	⡔	⡕	⡖	⡗	⡘	⡙	⡚	⡛	⡜	⡝	⡞	⡟	⡠	⡡	⡢	⡣	⡤	⡥	⡦	⡧	⡨	⡩	⡪	⡫	⡬	⡭	⡮	⡯	⡰	⡱	⡲	⡳	⡴	⡵	⡶	⡷	⡸	⡹	⡺	⡻	⡼	⡽	⡾	⡿	⢀	⢁	⢂	⢃	⢄	⢅	⢆	⢇	⢈	⢉	⢊	⢋	⢌	⢍	⢎	⢏	⢐	⢑	⢒	⢓	⢔	⢕	⢖	⢗	⢘	⢙	⢚	⢛	⢜	⢝	⢞	⢟	⢠	⢡	⢢	⢣	⢤	⢥	⢦	⢧	⢨	⢩	⢪	⢫	⢬	⢭	⢮	⢯	⢰	⢱	⢲	⢳	⢴	⢵	⢶	⢷	⢸	⢹	⢺	⢻	⢼	⢽	⢾	⢿	⣀	⣁	⣂	⣃	⣄	⣅	⣆	⣇	⣈	⣉	⣊	⣋	⣌	⣍	⣎	⣏	⣐	⣑	⣒	⣓	⣔	⣕	⣖	⣗	⣘	⣙	⣚	⣛	⣜	⣝	⣞	⣟	⣠	⣡	⣢	⣣	⣤	⣥	⣦	⣧	⣨	⣩	⣪	⣫	⣬	⣭	⣮	⣯	⣰	⣱	⣲	⣳	⣴	⣵	⣶	⣷	⣸	⣹	⣺	⣻	⣼	⣽	⣾	⣿


⠀ ⠁ ⠂ ⠃ ⠄ ⠅ ⠆ ⠇ ⠈ ⠉ ⠊ ⠋ ⠌ ⠍ ⠎ ⠏ ⠐ ⠑ ⠒ ⠓ ⠔ ⠕ ⠖ ⠗ ⠘ ⠙ ⠚ ⠛ ⠜ ⠝ ⠞ ⠟ ⠠ ⠡ ⠢ ⠣ ⠤ ⠥ ⠦ ⠧ ⠨ ⠩ ⠪ ⠫ ⠬ ⠭ ⠮ ⠯ ⠰ ⠱ ⠲ ⠳ ⠴ ⠵ ⠶ ⠷ ⠸ ⠹ ⠺ ⠻ ⠼ ⠽ ⠾ ⠿ ⡀ ⡁ ⡂ ⡃ ⡄ ⡅ ⡆ ⡇ ⡈ ⡉ ⡊ ⡋ ⡌ ⡍ ⡎ ⡏ ⡐ ⡑ ⡒ ⡓ ⡔ ⡕ ⡖ ⡗ ⡘ ⡙ ⡚ ⡛ ⡜ ⡝ ⡞ ⡟ ⡠ ⡡ ⡢ ⡣ ⡤ ⡥ ⡦ ⡧ ⡨ ⡩ ⡪ ⡫ ⡬ ⡭ ⡮ ⡯ ⡰ ⡱ ⡲ ⡳ ⡴ ⡵ ⡶ ⡷ ⡸ ⡹ ⡺ ⡻ ⡼ ⡽ ⡾ ⡿ ⢀ ⢁ ⢂ ⢃ ⢄ ⢅ ⢆ ⢇ ⢈ ⢉ ⢊ ⢋ ⢌ ⢍ ⢎ ⢏ ⢐ ⢑ ⢒ ⢓ ⢔ ⢕ ⢖ ⢗ ⢘ ⢙ ⢚ ⢛ ⢜ ⢝ ⢞ ⢟ ⢠ ⢡ ⢢ ⢣ ⢤ ⢥ ⢦ ⢧ ⢨ ⢩ ⢪ ⢫ ⢬ ⢭ ⢮ ⢯ ⢰ ⢱ ⢲ ⢳ ⢴ ⢵ ⢶ ⢷ ⢸ ⢹ ⢺ ⢻ ⢼ ⢽ ⢾ ⢿ ⣀ ⣁ ⣂ ⣃ ⣄ ⣅ ⣆ ⣇ ⣈ ⣉ ⣊ ⣋ ⣌ ⣍ ⣎ ⣏ ⣐ ⣑ ⣒ ⣓ ⣔ ⣕ ⣖ ⣗ ⣘ ⣙ ⣚ ⣛ ⣜ ⣝ ⣞ ⣟ ⣠ ⣡ ⣢ ⣣ ⣤ ⣥ ⣦ ⣧ ⣨ ⣩ ⣪ ⣫ ⣬ ⣭ ⣮ ⣯ ⣰ ⣱ ⣲ ⣳ ⣴ ⣵ ⣶ ⣷ ⣸ ⣹ ⣺ ⣻ ⣼ ⣽ ⣾ ⣿



]]
--[=[
local dotdata6 = [[⠀ ⠁ ⠂ ⠃ ⠄ ⠅ ⠆ ⠇ ⠈ ⠉ ⠊ ⠋ ⠌ ⠍ ⠎ ⠏ ⠐ ⠑ ⠒ ⠓ ⠔ ⠕ ⠖ ⠗ ⠘ ⠙ ⠚ ⠛ ⠜ ⠝ ⠞ ⠟ ⠠ ⠡ ⠢ ⠣ ⠤ ⠥ ⠦ ⠧ ⠨ ⠩ ⠪ ⠫ ⠬ ⠭ ⠮ ⠯ ⠰ ⠱ ⠲ ⠳ ⠴ ⠵ ⠶ ⠷ ⠸ ⠹ ⠺ ⠻ ⠼ ⠽ ⠾ ⠿]]

local dotdata8 = [[⡀ ⡁ ⡂ ⡃ ⡄ ⡅ ⡆ ⡇ ⡈ ⡉ ⡊ ⡋ ⡌ ⡍ ⡎ ⡏ ⡐ ⡑ ⡒ ⡓ ⡔ ⡕ ⡖ ⡗ ⡘ ⡙ ⡚ ⡛ ⡜ ⡝ ⡞ ⡟ ⡠ ⡡ ⡢ ⡣ ⡤ ⡥ ⡦ ⡧ ⡨ ⡩ ⡪ ⡫ ⡬ ⡭ ⡮ ⡯ ⡰ ⡱ ⡲ ⡳ ⡴ ⡵ ⡶ ⡷ ⡸ ⡹ ⡺ ⡻ ⡼ ⡽ ⡾ ⡿ ⢀ ⢁ ⢂ ⢃ ⢄ ⢅ ⢆ ⢇ ⢈ ⢉ ⢊ ⢋ ⢌ ⢍ ⢎ ⢏ ⢐ ⢑ ⢒ ⢓ ⢔ ⢕ ⢖ ⢗ ⢘ ⢙ ⢚ ⢛ ⢜ ⢝ ⢞ ⢟ ⢠ ⢡ ⢢ ⢣ ⢤ ⢥ ⢦ ⢧ ⢨ ⢩ ⢪ ⢫ ⢬ ⢭ ⢮ ⢯ ⢰ ⢱ ⢲ ⢳ ⢴ ⢵ ⢶ ⢷ ⢸ ⢹ ⢺ ⢻ ⢼ ⢽ ⢾ ⢿ ⣀ ⣁ ⣂ ⣃ ⣄ ⣅ ⣆ ⣇ ⣈ ⣉ ⣊ ⣋ ⣌ ⣍ ⣎ ⣏ ⣐ ⣑ ⣒ ⣓ ⣔ ⣕ ⣖ ⣗ ⣘ ⣙ ⣚ ⣛ ⣜ ⣝ ⣞ ⣟ ⣠ ⣡ ⣢ ⣣ ⣤ ⣥ ⣦ ⣧ ⣨ ⣩ ⣪ ⣫ ⣬ ⣭ ⣮ ⣯ ⣰ ⣱ ⣲ ⣳ ⣴ ⣵ ⣶ ⣷ ⣸ ⣹ ⣺ ⣻ ⣼ ⣽ ⣾ ⣿]]

local combattempt1 = [[⠀ ⠁ ⠂ ⠃ ⠄ ⠅ ⠆ ⠇ ⡀ ⡁ ⡂ ⡃ ⡄ ⡅ ⡆ ⡇ ⠈ ⠉ ⠊ ⠋ ⠌ ⠍ ⠎ ⠏ ⡈ ⡉ ⡊ ⡋ ⡌ ⡍ ⡎ ⡏ ⠐ ⠑ ⠒ ⠓ ⠔ ⠕ ⠖ ⠗ ⠘ ⠙ ⠚ ⠛ ⠜ ⠝ ⠞ ⠟ ⡐ ⡑ ⡒ ⡓ ⡔ ⡕ ⡖ ⡗ ⡘ ⡙ ⡚ ⡛ ⡜ ⡝ ⡞ ⡟ ⠠ ⠡ ⠢ ⠣ ⠤ ⠥ ⠦ ⠧ ⠨ ⠩ ⠪ ⠫ ⠬ ⠭ ⠮ ⠯ ⠰ ⠱ ⠲ ⠳ ⠴ ⠵ ⠶ ⠷ ⠸ ⠹ ⠺ ⠻ ⠼ ⠽ ⠾ ⠿ ⡠ ⡡ ⡢ ⡣ ⡤ ⡥ ⡦ ⡧ ⡨ ⡩ ⡪ ⡫ ⡬ ⡭ ⡮ ⡯ ⡰ ⡱ ⡲ ⡳ ⡴ ⡵ ⡶ ⡷ ⡸ ⡹ ⡺ ⡻ ⡼ ⡽ ⡾ ⡿ ⢀ ⢁ ⢂ ⢃ ⢄ ⢅ ⢆ ⢇ ⢈ ⢉ ⢊ ⢋ ⢌ ⢍ ⢎ ⢏ ⢐ ⢑ ⢒ ⢓ ⢔ ⢕ ⢖ ⢗ ⢘ ⢙ ⢚ ⢛ ⢜ ⢝ ⢞ ⢟ ⢠ ⢡ ⢢ ⢣ ⢤ ⢥ ⢦ ⢧ ⢨ ⢩ ⢪ ⢫ ⢬ ⢭ ⢮ ⢯ ⢰ ⢱ ⢲ ⢳ ⢴ ⢵ ⢶ ⢷ ⢸ ⢹ ⢺ ⢻ ⢼ ⢽ ⢾ ⢿ ⣀ ⣁ ⣂ ⣃ ⣄ ⣅ ⣆ ⣇ ⣈ ⣉ ⣊ ⣋ ⣌ ⣍ ⣎ ⣏ ⣐ ⣑ ⣒ ⣓ ⣔ ⣕ ⣖ ⣗ ⣘ ⣙ ⣚ ⣛ ⣜ ⣝ ⣞ ⣟ ⣠ ⣡ ⣢ ⣣ ⣤ ⣥ ⣦ ⣧ ⣨ ⣩ ⣪ ⣫ ⣬ ⣭ ⣮ ⣯ ⣰ ⣱ ⣲ ⣳ ⣴ ⣵ ⣶ ⣷ ⣸ ⣹ ⣺ ⣻ ⣼ ⣽ ⣾ ⣿]]

]=]



Split = function(a,b)c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end






--combined 6 and 8
--https://github.com/qntm/braille-encode/blob/main/index.js
local dotdata = ([[
⠀ ⢀ ⠠ ⢠ ⠐ ⢐ ⠰ ⢰ ⠈ ⢈ ⠨ ⢨ ⠘ ⢘ ⠸ ⢸
⡀ ⣀ ⡠ ⣠ ⡐ ⣐ ⡰ ⣰ ⡈ ⣈ ⡨ ⣨ ⡘ ⣘ ⡸ ⣸
⠄ ⢄ ⠤ ⢤ ⠔ ⢔ ⠴ ⢴ ⠌ ⢌ ⠬ ⢬ ⠜ ⢜ ⠼ ⢼
⡄ ⣄ ⡤ ⣤ ⡔ ⣔ ⡴ ⣴ ⡌ ⣌ ⡬ ⣬ ⡜ ⣜ ⡼ ⣼
⠂ ⢂ ⠢ ⢢ ⠒ ⢒ ⠲ ⢲ ⠊ ⢊ ⠪ ⢪ ⠚ ⢚ ⠺ ⢺
⡂ ⣂ ⡢ ⣢ ⡒ ⣒ ⡲ ⣲ ⡊ ⣊ ⡪ ⣪ ⡚ ⣚ ⡺ ⣺
⠆ ⢆ ⠦ ⢦ ⠖ ⢖ ⠶ ⢶ ⠎ ⢎ ⠮ ⢮ ⠞ ⢞ ⠾ ⢾
⡆ ⣆ ⡦ ⣦ ⡖ ⣖ ⡶ ⣶ ⡎ ⣎ ⡮ ⣮ ⡞ ⣞ ⡾ ⣾
⠁ ⢁ ⠡ ⢡ ⠑ ⢑ ⠱ ⢱ ⠉ ⢉ ⠩ ⢩ ⠙ ⢙ ⠹ ⢹
⡁ ⣁ ⡡ ⣡ ⡑ ⣑ ⡱ ⣱ ⡉ ⣉ ⡩ ⣩ ⡙ ⣙ ⡹ ⣹
⠅ ⢅ ⠥ ⢥ ⠕ ⢕ ⠵ ⢵ ⠍ ⢍ ⠭ ⢭ ⠝ ⢝ ⠽ ⢽
⡅ ⣅ ⡥ ⣥ ⡕ ⣕ ⡵ ⣵ ⡍ ⣍ ⡭ ⣭ ⡝ ⣝ ⡽ ⣽
⠃ ⢃ ⠣ ⢣ ⠓ ⢓ ⠳ ⢳ ⠋ ⢋ ⠫ ⢫ ⠛ ⢛ ⠻ ⢻
⡃ ⣃ ⡣ ⣣ ⡓ ⣓ ⡳ ⣳ ⡋ ⣋ ⡫ ⣫ ⡛ ⣛ ⡻ ⣻
⠇ ⢇ ⠧ ⢧ ⠗ ⢗ ⠷ ⢷ ⠏ ⢏ ⠯ ⢯ ⠟ ⢟ ⠿ ⢿
⡇ ⣇ ⡧ ⣧ ⡗ ⣗ ⡷ ⣷ ⡏ ⣏ ⡯ ⣯ ⡟ ⣟ ⡿ ⣿]]):gsub('\n', ' ')



function GenerateDotData() --im lazy, so this will generate a dictionary with all of the patterns formatted.
    --generate alphanumeric chars
    --local badchars = '	%+1234567890%(%)%-\n '
    --[[
    local badchars = '%+1234567890%(%)%-'
    local startpoint = 65
    local endpoint = 90 --no need for lowercase.
    for i = startpoint, endpoint do
        badchars = badchars .. string.char(i)
    end
    badchars = '[' .. string.lower(badchars) .. string.upper(badchars) .. ']'
    --ok now pattern match them
    dotdata = dotdata:gsub(badchars, '')
    print(dotdata)
    ]] --wont use because i need to split str

    --format data into a 't'
    function ToBinary(a)
        local t = {}
        while a > 0 do
            local r = math.fmod(a, 2)
            t[#t + 1] = string.sub(r, 1, 1)
            a=(a - r) / 2
        end
        local s = string.reverse(table.concat(t))
        return string.rep('0', 8 - #s) .. s
        --return s
    end
    local function format(s)
        --return string.rep('0', 8 - #s) .. s
        return s
    end
    local t = Split(dotdata, ' ')
    local newt = {}
    --print(#t) --> 256
    local inputa = false
    local str = ''
    local sep = ' '
    for i = 1, #t do
        --print(i, ToBinary(i - 1), t[i])
        newt[ToBinary(i - 1)] = format(t[i])
        if inputa then
            print(ToBinary(i - 1) .. t[i])
            local input = io.read()
            if input == '' then
                input = t[i]
            elseif input == 'stop' then
                break
            end
            str = str .. input .. sep
        end
    end
    if inputa then
        print(str)
        io.open('Data.lua', 'a+'):write(str)
    end
    return newt
end
local DotDataFormatted = GenerateDotData()
--Order: LU, RU, LD, RD






Pixel = {}
Pixel.Data = {Box = {['1000'] = '▘', ['0100'] = '▝', ['0010'] = '▖', ['0001'] = '▗', ['1100'] = '▀', ['1001'] = '▚', ['0110'] = '▞', ['0110'] = '▐', ['1010'] = '▌', ['0011'] = '▄', ['1110'] = '▛', ['0111'] = '▟', ['1101'] = '▜', ['1011'] = '▙', ['1111'] = '█'}}
Pixel.Data.Dot = DotDataFormatted

Pixel.Data.Empty = '0'
Pixel.Data.Filled = '1'
Pixel.Data.NewLine = '\n'

--Pixel.DirData = {Box = {{'R', 2}, {'D', 3}, {'RD', 4}}}

--[[
123
456
789

dimensions[1] = x, dimensions[2] = y
]]


--[[
Pixel Order:


1   5
2   6
3   7
4   8

v1

converted to

8   4
7   3
6   2
5   1

v2


]]


--split string: call Split(string, seperator)
Split = function(a,b)c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end

function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--[=[
function ParseArguments(...)
    local Data = {

    }
    --[[
    t format:
    t =
    {
        str = str,
        points = {{x, y}, {x, y}, ...}
        options = options
    }
    ]]
    local a = {...}
    --Create table
    local t = {}
    --#1 is str
    if type(a[1]) == 'table' and a[1].Data then
        t.str = a[1]
    elseif type(a[1]) == 'string' then
        t.str = Pixel.New(a[1])
    else
        Error('ParseArguments: str is invalid. type: {type}.', {type = type(a[1])})
    end
    --#2 is points
end
--]=]

function GetPixelData(str)
    if type(str) == 'table' and str.Data then
        return str
    else
        local t = Pixel.New(str)
        return t
    end
end


function Error(msg, t)
    if not ErrorEnabled then return end
    --http://lua-users.org/wiki/StringInterpolation
    local function Interpolate(s, t)return(s:gsub('(%b{})',function(w)return t[w:sub(2,-2)]or w end))end
    local function Internal_Error(s)
        error(s)
    end
    local str = Interpolate(msg, t)
    Internal_Error(str)
end

function Warn(msg, t)
    if not WarnEnabled then return end
    --http://lua-users.org/wiki/StringInterpolation
    local function Interpolate(s, t)return(s:gsub('(%b{})',function(w)return t[w:sub(2,-2)]or w end))end
    local str = Interpolate(msg, t)
    print('Warning: ' .. str)
    if WarnStrict then
        print('Press enter to continue.')
        io.read()
    end
end





Table = {} --the table variable is a table :)

--Table handling
function Table.Combine(a, b)
    for i = 1, #b do
        table.insert(a, b[i])
    end
    return a
end

--http://lua-users.org/wiki/CopyTable
--Supply ONLY 1 Argument
function Table.Clone(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[Table.Clone(orig_key, copies)] = Table.Clone(orig_value, copies)
            end
            setmetatable(copy, Table.Clone(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end




























--See Terminal.lua for the entire file

--Color library
Pixel.Color = {}
--Color = Pixel.Color

Pixel.Color.Data = {
    --attributes
    reset = 0, clear = 0, space = 0,
    bright = 1, bold = 1,
    dim = 2, faint = 1,
    italic = 3,
    underline = 4,
    blink = 5,
    reverse = 7,
    invisible = 8, hidden = 8,
    strikethrough = 9,

    --foreground
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    purple = 35, magenta = 35,
    cyan = 36,
    white = 37,

    --background
    onblack = 40,
    onred = 41,
    ongreen = 42,
    onyellow = 43,
    onblue = 44,
    onpurple = 45, onmagenta = 45,
    oncyan = 46,
    onwhite = 47,
}

local function GetAnsi(v)
    local t = Split(v, ',') --Split
    local t2 = {} --Trim
    for i = 1, #t do
        local str = string.gsub(t[i], '^%s*(.-)%s*$', '%1')
        table.insert(t2, Pixel.Color.Data[string.lower(str)] or str)
    end
    v = table.concat(t2, ';')
    return '\27[' .. v .. 'm'
end

local function ScanColor(str, nest)
    local original = str
    local mode = true --true means color, false means text
    local past
    str = string.gsub(str, '(%b{})', function(data)
        data = string.sub(data, 2, -2)
        if mode then
            mode = false
            local ansi = GetAnsi(data)
            past = ansi
            return ansi
        else
            mode = true
            local scan = ScanColor(data, past)
            if scan then
                return scan .. (nest or '')
            else
                return data .. (nest or '')
            end
        end
    end)
    if mode == false or finalstr == '' or str == original then
        return nil
    end
    return str
end

function Pixel.Color.Set(v)
    local scan = ScanColor(v)
    if scan then
        return scan .. GetAnsi('0') --Reset the color at the end
    else
        local data = GetAnsi(v)
        local mode = false --true -> color, false -> text
        local tostringcall = ''
        local t
        t = setmetatable({}, {
            __concat = function(l, r) --Concatenation is right associative, so we can't do anything.
                data = tostring(l) .. tostring(r) .. GetAnsi('0') --Reset the color at the end
                return t
            end,
            __call = function(t, s)
                tostringcall = GetAnsi('0') --Reset the color at the end
                if mode then
                    data = data .. GetAnsi(s)
                    mode = false
                else
                    data = data .. s
                    mode = true
                end
                return t
            end,
            __tostring = function()
                return data .. tostringcall
            end
        })
        return t
    end
end





setmetatable(Pixel.Color, {
    __call = function(t, ...)
        return Pixel.Color.Set(...)
    end
})


function Pixel.SetColor(self, x, y, color)
    local str = GetPixelData(self)
    str.Color[x] = str.Color[x] or {}
    str.Color[x][y] = color
    return str
end

function Pixel.SetColorAll(self, color)
    local str = GetPixelData(self)
    str.Color.All = color
    return str
end

function Pixel.GetColor(self, x, y)
    local str = GetPixelData(self)
    if str.Color[x] and str.Color[x][y] then
        return str.Color[x][y]
    end
    --Well, we could not find the color
    --WarnEnabled, WarnStrict = true, true
    if WarnStrict then
        Warn('Unable to find color, x: {x}, y: {y}.', {x = x, y = y})
    end
    return nil
end

function Pixel.GetColorAll(self)
    local str = GetPixelData(self)
    if str.Color.All then
        return str.Color.All
    else
        if WarnStrict then
            Warn('str.Color.All is a nil value.')
        end
        return nil
    end
end

--[[
function Pixel.PushColor(x, y)
    --Pushes the color to a character (2 by 4 pixels)
    --return {x, y, c}
    --print(x - (x - 1) % 2, y - (y - 1) % 4)
    return x - (x - 1) % 2, y - (y - 1) % 4
end
--]]













Pixel.__index = Pixel
Pixel.__tostring = function(t)
    return Pixel.Convert(t)
end


local function GetDefaultPixel()
    return Table.Clone(DefaultPixel)
end


function Pixel.New(str)
    --[[
    str can be a pixeltable or str
    ]]
    if type(str) == 'string' then
        str = Pixel.Convert.To2d(str)
    end
    local PixelObject = {}
    --[[
    local i = 1
    while true do
      local name, value = debug.getlocal(2, i)
      if not name then break end
      print(name, i, value)
      i = i + 1
    end  
    --]]
    PixelObject.Data = str or GetDefaultPixel()
    PixelObject.Op = {}
    PixelObject.Color = {}
    --[[
    PixelObject.Data.gsub = function(...)
        return Pixel.Replace(PixelObject, ...).Data
    end
    --]]
    setmetatable(PixelObject, Pixel)
    return PixelObject
end

function Pixel.Blank()
    --[[
    if x % 2 ~= 0 then
        error('x must be a multiple of 2')
    end
    if y % 4 ~= 0 then
        error('y must be a multiple of 4')
    end
    --]]
    --return Pixel.New(((DefaultPixel):rep(x)..'\n'):rep(y):sub(1, -2))
    --[[
    local str = Pixel.New()
    if cx and cy then
        for x = 1, cx do
            for y = 1, cy do
                str = Pixel.SetPixel(str, x, y, Pixel.Data.Empty)
            end
        end
    end
    --]]
    return Pixel.New()
end


function Pixel.Clear(self)
    --[[
    local str = {}
    str.Data = GetDefaultPixel()
    str.Op = {}
    str.Color = {}
    str.Offset = {0, 0}
    return str
    --]]
    return Pixel.New()
end

function Pixel.Copy(self)
    return Table.Clone(self)
end













Pixel.Convert = {}

function Pixel.Convert.To2d(str, dx, dy)
    local dx, dy = dx or 1, dy or 1
    local x, y = dx, dy
    local t = {}
    for i = 1, #str do
        local a = string.sub(str, i, i)
        if a == '\n' then
            y = y + 1
            x = dx
        else
            t[x] = t[x] or {}
            t[x][y] = a
            x = x + 1
        end
    end
    return t
end

function Pixel.Convert.From2d(str)
    local str = GetPixelData(str)
    local data = str.Data
    --Stats
    local function getmin(t)
        local c = nil
        for k, v in pairs(t) do
            if not c or k < c then
                c = k
            end
        end
        return c
    end
    local function getmax(t)
        local c = nil
        for k, v in pairs(t) do
            if not c or k > c then
                c = k
            end
        end
        return c
    end
    local function itrow(t, func)
        local t2 = {}
        for k, v in pairs(t) do
            --table.insert(t2, func(v))
            local a = func(v)
            if a then
                t2[a] = true
            end
        end
        return func(t2)
    end
    local final = {}
    local minx, maxx, miny, maxy = getmin(data), getmax(data), itrow(data, getmin), itrow(data, getmax)
    for y = miny, maxy do
        for x = minx, maxx do
            table.insert(final, Pixel.GetPixel(str, x, y))
        end
        local i = #final
        repeat
            if final[i] == Pixel.Data.Filled then
                break
            else
                final[i] = nil
                i = i - 1
            end
        until false
        table.insert(final, '\n')
    end
    final[#final] = nil
    return table.concat(final), minx, miny
end




if CacheEnabled then
    Pixel.Cache = {}
end


--https://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua
local function CompareTable(t1,t2,ignore_mt)
local ty1 = type(t1)
local ty2 = type(t2)
if ty1 ~= ty2 then return false end
-- non-table types can be directly compared
if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
-- as well as tables which have the metamethod __eq
local mt = getmetatable(t1)
if not ignore_mt and mt and mt.__eq then return t1 == t2 end
for k1,v1 in pairs(t1) do
local v2 = t2[k1]
if v2 == nil or not CompareTable(v1,v2) then return false end
end
for k2,v2 in pairs(t2) do
local v1 = t1[k2]
if v1 == nil or not CompareTable(v1,v2) then return false end
end
return true
end


local function SearchCache(k)
    for i = 1, #Pixel.Cache do
        --if Pixel.Cache[i][1] == k then
        if CompareTable(Pixel.Cache[i][1], k) then
            return Pixel.Cache[i][2]
        end
    end
    return nil
end

local function UpdateCache(k, v)
    table.insert(Pixel.Cache, {k, v})
end


--[=[
v1
function Pixel.Convert.ToDots(str) --converts a given string. must be formatted.
    --The pixels might look off, but they are not
    --str should be:
    --[[
    1111111111
    0000000000
    etc
    ]]
    --Data
    str = GetPixelData(str)
    --Cache
    if CacheEnabled then
        local a = SearchCache(str)
        if a then
            return a
        end
    end
    local strbackup = str
    CheckInstructions = {'', 'D', 'DD', 'DDD', 'R', 'RD', 'RDD', 'RDDD'}
    DirectionFunctions = {['R'] = function(i, subber) return {i, subber + 1} end, ['D'] = function(i, subber) return {i + 1, subber} end}
    local function c(str, subber)
        if not str then return Pixel.Data.Empty end
        return string.sub(str, subber, subber) --returns empty, if over edge
    end
    local reset = tostring(Pixel.Color('reset'))
    local ignorecolor = false
    local append = reset
    local appendc = ''
    local pastcolor = nil
    local out = {}
    if str.Color.All then
        local c = tostring(Pixel.Color(str.Color.All))
        table.insert(out, c)
        appendc = appendc .. c
        ignorecolor = true
    end
    local rows = Split(str.Data, Pixel.Data.NewLine)
    --optimize
    --[[
    Zero dots: Ignore all 'white space' characters
    ~10x speedup

    for rendering 10 shapes, speedup was from
    43 seconds to 4.4 seconds
    --]]
    local zerostring = string.rep(Pixel.Data.Empty, 8) --Set the 8 to 0 to disable
    local zerodot = Pixel.Data.Dot[zerostring]

    --ppp(rows)
    for i = 1, #rows, 4 do
        for i2 = 1, #rows[i], 2 do
            local str = ''
            for i3 = 1, #CheckInstructions do
                local tempdata = {i, i2}
                for i4 = 1, #CheckInstructions[i3] do
                    tempdata = DirectionFunctions[c(CheckInstructions[i3], i4)](unpack(tempdata))
                end
                str = str .. c(rows[tempdata[1]], tempdata[2])
                --debug
                --print(#str, #c(rows[tempdata[1]], tempdata[2]), c(rows[tempdata[1]], tempdata[2]))
            end
            str = str .. string.rep(Pixel.Data.Empty, 8 - #str)
            if str ~= zerostring then
                local sc = Pixel.GetColor(strbackup, i2, i)
                local pixeldata = Pixel.Data.Dot[str]
                if sc then
                    local a = tostring(Pixel.Color(sc))
                    if pastcolor == a then
                        table.insert(out, pixeldata)
                    else
                        table.insert(out, a)
                        table.insert(out, pixeldata)
                        pastappend = false
                        pastcolor = a
                    end
                else
                    if ignorecolor then
                        if pastappend then
                            table.insert(out, pixeldata)
                        else
                            table.insert(out, appendc)
                            table.insert(out, pixeldata)
                            pastappend = true
                        end
                        pastcolor = appendc
                    else
                        pastappend = false
                        table.insert(out, pixeldata)
                    end
                end
            else
                table.insert(out, zerodot)
            end
        end
        table.insert(out, '\n')
    end
    table.insert(out, append)
    local o = table.concat(out)
    if CacheEnabled then
        UpdateCache(str, o)
    end
    return o
end

--]=]


--v2
function Pixel.Convert.ToDots(str) --converts a given data table
    --The pixels might look off, but they are not
    --[[
    Format:
    t[x][y]

    ]]
    --Data
    str = GetPixelData(str) --Read Only
    local data, color = str.Data, str.Color
    if ReverseY then
        local function reversey(t)
            local new = {}
            for x, v in pairs(t) do
                for y, v2 in pairs(v) do
                    new[x] = new[x] or {}
                    new[x][-y] = v2
                end
            end
            return new
        end
        data = reversey(data)
        color = reversey(color)
    end
    --Make sure to not write to str
    str = {
        Data = data,
        Color = color
    }
    --Stats
    local function getmin(t)
        local c = nil
        for k, v in pairs(t) do
            if not c or k < c then
                c = k
            end
        end
        return c
    end
    local function getmax(t)
        local c = nil
        for k, v in pairs(t) do
            if not c or k > c then
                c = k
            end
        end
        return c
    end
    local function itrow(t, func)
        local t2 = {}
        for k, v in pairs(t) do
            --table.insert(t2, func(v))
            local a = func(v)
            if a then
                t2[a] = true
            end
        end
        return func(t2)
    end
    local minx, maxx, miny, maxy = getmin(data), getmax(data), itrow(data, getmin), itrow(data, getmax)
    --print(minx, maxx, miny, maxy)
    --Optimizations
    local out = {}
    local zerostring = string.rep('0', 8)
    local zerodot = Pixel.Data.Dot[zerostring]
    local currentcolor = nil
    local allcolor = nil
    if str.Color.All then
        local c = tostring(Pixel.Color(str.Color.All))
        table.insert(out, c)
        allcolor = c
    end
    local rows = {}
    for x, v in pairs(data) do
        for y, v2 in pairs(v) do
            rows[y] = rows[y] or {}
            rows[y][x] = v2
        end
    end
    --for x, v in pairs(str.Color) do if type(v) == 'table' then for y, v2 in pairs(v) do print(x, y, v2) end end end
    --Main loop
    if not miny then
        return ''
    end
    for y = miny, maxy, 4 do
        --table.insert(out, string.rep(zerodot, (getmin(rows[y]) - minx - 1) / 2))
        --for x = minx - (getmin(rows[y]) % 2), maxx, 2 do
        for x = minx, maxx, 2 do
            --print(x, y)
            --Get Pixels
            local pixel = ''
            local c = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}}
            for i = 1, 8 do
                local x, y = x + c[i][1], y + c[i][2]
                pixel = pixel .. ((data[x] and data[x][y] or false) and data[x][y] or Pixel.Data.Empty)
            end
            --print(pixel, x, y, color)
            if pixel ~= zerostring then
                pixel = Pixel.Data.Dot[pixel]
                --local x, y = Pixel.PushColor(x, y)
                if not allcolor then
                    local color = Pixel.GetColor(str, x, y)
                    --if color==nil then print(x, y, color) end
                    --if not allcolor and color then
                    --find all 8 pixels
                    if not color then
                        local c = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}}
                        for i = 1, 8 do
                            color = Pixel.GetColor(str, x + c[i][1], y + c[i][2])
                            if color then
                                break
                            end
                        end
                    end
                    if color then
                        color = tostring(Pixel.Color(color))
                    else
                        color = tostring(Pixel.Color('reset'))
                    end
                    if currentcolor == color then
                        --Do Nothing
                    else
                        table.insert(out, color)
                        currentcolor = color
                    end
                end
                --table.insert(out, string.rep(zerodot, (x - minx - 1) / 2))
                table.insert(out, pixel)
            else
                table.insert(out, zerodot)
            end
        end
        table.insert(out, Pixel.Data.NewLine)
    end
    table.insert(out, tostring(Pixel.Color('reset')))
    --ppp(out)
    return table.concat(out)
end


function Pixel.Convert.FromDots(dots)
    if''then return nil end
    --Will not work, because lua does not support unicode iteration
    local function Find(s)
        for k, v in pairs(Pixel.Data.Dot) do
            if v == s then
                return k
            end
        end
    end
    local t = Pixel.Convert.To2d(dots)
    for x = 1, #t do
        for y = 1, #t[x] do
            print(t[x][y])
        end
    end
end

setmetatable(Pixel.Convert, {__call = function(t, ...)
    return Pixel.Convert.ToDots(...)
end})
for k, v in pairs(Pixel.Convert) do
    Pixel[k] = v
end

function Pixel.Format(data, to) --Formats data to the ideal data
    local function IsData()
        for i = 1, #data do
            local temp = string.sub(data, i, i)
            if temp == Pixel.Data.Empty or temp == Pixel.Data.Filled or temp == Pixel.Data.NewLine then
                --Do nothing
            else
                return false
            end
        end
        return true
    end
    local from
    if type(data) == 'string' then
        local check = IsData()
        if check then
            from = 'str'
        else
            from = 'dots'
        end
    elseif type(data) == 'table' then
        from = '2d'
    end
    --Convert Everything to STR
    if from == 'str' then
        --Do nothing
    elseif from == '2d' then
        data = Pixel.Convert.From2d(data)
    elseif from == 'dots' then
        data = Pixel.Convert.FromDots(data)
    else
        Error('Pixel.Format: Could not convert {from} to {to}.', {from = from, to = 'STR'})
    end
    if to == 'str' then
        return data
    elseif to == '2d' then
        return Pixel.Convert.To2d(data)
    elseif to == 'dots' then
        return Pixel.Convert.ToDots(str)
    else
        Error('Pixel.Format: Could not convert {from} to {to}.', {from = 'STR', to = to})
    end
end












local function getmax(t)
    local c = nil
    for k, v in pairs(t) do
        if not c or k > c then
            c = k
        end
    end
    return c
end
function Pixel.GetSizeX(self)
    local str = GetPixelData(self)
    return getmax(str.Data)
end
function Pixel.GetSizeY(self)
    local str = GetPixelData(self)
    local c = nil
    for k, v in pairs(str.Data) do
        local a = getmax(v)
        if (not c or a > c) and a then
            c = a
        end
    end
    return c
end






function Pixel.SetPixel(self, x, y, value) --str should be a canvas object
    --preserve metatables
    --print(x, y, value)
    local str = GetPixelData(self)
    str.Data[x] = str.Data[x] or {}
    str.Data[x][y] = value
    return str
end

function Pixel.GetPixel(self, x, y)
    local str = GetPixelData(self)
    return str.Data[x] and str.Data[x][y] or nil
end



--Legacy
function Pixel.SetPixels(self, t) --t should be {{x, y, value}, {x, y, value}, {...}}
    local str = GetPixelData(self)
    for i = 1, #t do
        str.Data = Pixel.SetPixel(str.Data, t[i][1], t[i][2], t[i][3])
    end
    return str
end

--Operations

function Pixel.Equal(self, x1, y1, x2, y2)
    local str = GetPixelData(self)
    return Pixel.GetPixel(x1, y1) == Pixel.GetPixel(x2, y2)
end

function Pixel.MovePixel(self, x1, y1, x2, y2)
    local str = GetPixelData(self)
    return Pixel.SetPixel(Pixel.SetPixel(str, x2, y2, Pixel.GetPixel(x1, y1)), x1, y1, Pixel.Data.Empty)
end

function Pixel.SwapPixel(self, x1, y1, x2, y2)
    local str = GetPixelData(self)
    local data1 = Pixel.GetPixel(str, x1, y1)
    return Pixel.SetPixel(Pixel.SetPixel(str, x1, y1, Pixel.GetPixel(str, x2, y2)), x2, y2, data1)
end

function Pixel.Replace(self, find, replace)
    local str = GetPixelData(self)
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            if v2 == find and str.Data[x] then
                str = Pixel.SetPixel(str, x, y, replace)
            end
        end
    end
    return str
end

function Pixel.SetAll(self, value)
    local str = GetPixelData(self)
    return Pixel.Replace(str, Pixel.Data.Empty, value)
end

function Pixel.Flip(self)
    local str = GetPixelData(self)
    --improve this
    return Pixel.Replace(Pixel.Replace(Pixel.Replace(str, '0, 2'), '1', '0'), '2', '1')
end

function Pixel.GetRect(self, cx, cy, x1, y1, x2, y2)
    --Get a subset of a pixel rect between 2 points
    local str = GetPixelData(self)
    local new = Pixel.New()
    if x1 > y1 then
        x1, y1 = y1, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end
    for x = x1, x2 do
        for y = y1, y2 do
            new = Pixel.SetPixel(new, x - x1 + cx, y - y1 + cy, Pixel.GetPixel(str, x, y))
        end
    end
    return new
end




--[[
function Pixel.PixelZoomIn(self, times)
    
end

function Pixel.PixelZoomOut(self, times)
    
end
--]]

function Pixel.ZoomIn(self, times) --assumes origin at 1, 1
    local str = GetPixelData(self)
    local new = Pixel.New()
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            for x2 = (x - 1) * times + 1, x * times do
                for y2 = (y - 1) * times + 1, y * times do
                    new = Pixel.SetPixel(new, x2, y2, v2)
                end
            end
        end
    end
    return new
end

function Pixel.ZoomOut(self, times) --assumes origin at 1, 1
    local str = GetPixelData(self)
    local new = Pixel.New()
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            if (x - 1) % times == 0 and (y - 1) % times == 0 then
                local count = {}
                for x2 = x, x + times - 1 do
                    for y2 = y, y + times - 1 do
                        local a = Pixel.GetPixel(str, x2, y2)
                        --print(x2, y2, a)
                        if a then
                            count[a] = count[a] and count[a] + 1 or 1
                        end
                    end
                end
                local c = nil
                for k, v in pairs(count) do
                    --print(k, v)
                    if not c or v > count[c] then
                        c = k
                    elseif c and v == count[c] then
                        k = Pixel.Data.Empty
                        break
                    end
                end
                --print(c)
                new = Pixel.SetPixel(new, (x - 1) / times + 1, (y - 1) / times + 1, c)
            end
        end
    end
    return new
end




function Pixel.Resize(self, x, y)

end

function Pixel.Offset(self, offx, offy)

end







--2d library
--rewrite of Pixel.Line

local function GetPointTable(...)
    local t = {...}
    if #t == 1 and type(t[1]) == 'table' then
        return unpack(t[1])
    else
        return ...
        --return unpack(t)
    end
end

local function SaveOpData(str, funcname, ...)
    local t = {...}
    if t[#t] ~= true then
        --print('OP: '..funcname..','..#t)
        table.insert(str.Op, {funcname, ...})
    end
end

local function OrganizeColor(a, b)
    if type(a) == 'boolean' and type(b) == 'table' then
        return b, a
    elseif type(a) == 'table' and type(b) == 'boolean' then
        return a, b
    elseif type(a) == 'table' then
        return a, b
    end
end


--http://rosettacode.org/wiki/Bitmap/Bresenham%27s_line_algorithm#Lua
function Pixel.Line(self, ...)
    local vararg = {GetPointTable(...)}
    local x1, y1, x2, y2, a, b = unpack(vararg)
    local options, op = OrganizeColor(a, b)
    options = options or {}
    local color, callback, init, func = options.color, options.callback, options.init, options.setfunction
    if init then
        init()
    end
    local str = GetPixelData(self)
    --Handle negatives
    local offx, offy = 0, 0
    --x
    if x1 < 0 and x1 < offx then
        offx = x1
    end
    if x2 < 0 and x2 < offx then
        offx = x2
    end
    --y
    if y1 < 0 and y1 < offy then
        offy = y1
    end
    if y2 < 0 and y2 < offy then
        offy = y2
    end
    x1, y1, x2, y2 = x1 - offx, y1 - offy, x2 - offx, y2 - offy
    --Save Op
    SaveOpData(str, 'Line', x1, y1, x2, y2, options, op)
    local function Set(x, y)
        local x, y = x + offx, y + offy
        --t[(dimx * (y - 1)) + x] = c
        if callback then
            local r = callback(str, x, y, Pixel.Data.Filled)
            if r then
                Pixel.SetPixel(str, x, y, r)
            end
        else
            Pixel.SetPixel(str, x, y, Pixel.Data.Filled)
        end
        if color then
            --local x, y = Pixel.PushColor(x, y)
            Pixel.SetColor(str, x, y, color)
        end
        --table.insert(pixelt, {x, y, Pixel.Data.Filled})
    end
    if options.setfunction then
        Set = options.setfunction
    end
    local dx, sx = math.abs(x2-x1), x1<x2 and 1 or -1
    local dy, sy = math.abs(y2-y1), y1<y2 and 1 or -1
    local err = math.floor((dx>dy and dx or -dy)/2)
    while(true) do
      Set(x1, y1)
      if (x1==x2 and y1==y2) then break end
      if (err > -dx) then
        err, x1 = err-dy, x1+sx
        if (x1==x2 and y1==y2) then
          Set(x1, y1)
          break
        end
      end
      if (err < dy) then
        err, y1 = err+dx, y1+sy
      end
    end
    return str
end





--https://rosettacode.org/wiki/Bitmap/B%C3%A9zier_curves/Quadratic#Lua
function Pixel.Bezier2(self, x1, y1, x2, y2, x3, y3, nseg)
    local str = GetPixelData(self)
    nseg = nseg or 10
    local prevx, prevy, currx, curry
    for i = 0, nseg do
      local t = i / nseg
      local a, b, c = (1-t)^2, 2*t*(1-t), t^2
      prevx, prevy = currx, curry
      currx = math.floor(a * x1 + b * x2 + c * x3 + 0.5)
      curry = math.floor(a * y1 + b * y2 + c * y3 + 0.5)
      if i > 0 then
        Pixel.Line(str, prevx, prevy, currx, curry)
      end
    end
    return str
end

--https://rosettacode.org/wiki/Bitmap/B%C3%A9zier_curves/Cubic#Lua
function Pixel.Bezier3(self, x1, y1, x2, y2, x3, y3, x4, y4, nseg)
    local str = GetPixelData(self)
    nseg = nseg or 10
    local prevx, prevy, currx, curry
    for i = 0, nseg do
      local t = i / nseg
      local a, b, c, d = (1-t)^3, 3*t*(1-t)^2, 3*t^2*(1-t), t^3
      prevx, prevy = currx, curry
      currx = math.floor(a * x1 + b * x2 + c * x3 + d * x4 + 0.5)
      curry = math.floor(a * y1 + b * y2 + c * y3 + d * y4 + 0.5)
      if i > 0 then
        Pixel.Line(str, prevx, prevy, currx, curry)
      end
    end
    return str
end
   


















function Pixel.Fill(self, x, y, a, b)
    local options, op = OrganizeColor(a, b)
    local str = GetPixelData(self)
    SaveOpData(str, 'Fill', x, y, options, op)
    --Recursive
    local function main(x, y)
        if Pixel.GetPixel(str, x, y) == Pixel.Data.Filled then
            return
        else
            Pixel.SetPixel(str, x, y, Pixel.Data.Filled)
            main(x - 1, y)
            main(x + 1, y)
            main(x, y - 1)
            main(x, y + 1)
        end
    end
    main(x, y)
    return str
end





--http://www.sunshine2k.de/coding/java/TriangleRasterization/TriangleRasterization.html
--Standard algorithm
--[[
Split triangle into 2 (top and bottom)
Fill
]]
--[[
TODO:
Since this algorithm only uses straight lines, optimize
]]
local function TopFlat(str, x1, y1, x2, y2, x3, y3, options)
    local slope1 = (x3 - x1) / (y3 - y1)
    local slope2 = (x3 - x2) / (y3 - y2)
    
    local cx1 = x3
    local cx2 = x3

    local i = y3
    repeat
        str = Pixel.Line(str, Round(cx1), i, Round(cx2), i, options)
        cx1, cx2 = cx1 - slope1, cx2 - slope2
        i = i - 1
    until i < y1
    return str
end
local function BottomFlat(str, x1, y1, x2, y2, x3, y3, options)
    local slope1 = (x2 - x1) / (y2 - y1)
    local slope2 = (x3 - x1) / (y3 - y1)
    
    local cx1 = x1
    local cx2 = x1

    local i = y1
    repeat
        str = Pixel.Line(str, Round(cx1), i, Round(cx2), i, options)
        cx1, cx2 = cx1 + slope1, cx2 + slope2
        i = i + 1
    until i > y2
    return str
end
function Pixel.Tri(self, x1, y1, x2, y2, x3, y3, options)
    local str = GetPixelData(self)
    local t1, t2 = {}, {}
    local fill = true
    local color = nil
    local fillcolor = nil
    local callback = nil
    options = options or {}
    local function a(a, b)
        if a ~= nil then
            return a
        else
            return b
        end
    end
    fill = a(options.fill, fill)
    color = a(options.color, color)
    fillcolor = a(options.fillcolor, fillcolor)
    callback = a(options.callback, callback)
    local edget, fillt = {color = color, callback = callback}, {color = fillcolor, callback = callback}
    if fill then
        --Sort points by y ascending (y1 is top)
        --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
        local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end
        local t = {
            {x1, y1},
            {x2, y2},
            {x3, y3}
        }
        local t2 = {}
        for k, v in spairs(t, function(t, a, b) return t[a][2] < t[b][2] end) do
            table.insert(t2, v[1])
            table.insert(t2, v[2])
        end
        t = t2
        x1, y1, x2, y2, x3, y3 = t[1], t[2], t[3], t[4], t[5], t[6]
        --Check for some cases
        if y2 == y3 then --Bottom flat
            str = BottomFlat(str, x1, y1, x2, y2, x3, y3, fillt)
        elseif y1 == y2 then --Top flat
            str = TopFlat(str, x1, y1, x2, y2, x3, y3, fillt)
        else --General
            --Get line points
            local x4, y4 = Round(x1 + (y2 - y1) / (y3 - y1) * (x3 - x1)), y2
            str = BottomFlat(str, x1, y1, x2, y2, x4, y4, fillt)
            str = TopFlat(str, x2, y2, x4, y4, x3, y3, fillt)
        end
    end
    --Edges again
    str = Pixel.Line(str, x1, y1, x2, y2, edget)
    str = Pixel.Line(str, x2, y2, x3, y3, edget)
    str = Pixel.Line(str, x3, y3, x1, y1, edget)
    return str
end

function Pixel.PolygonFill(str, ...)
    local points = {...}
    local options
    if #points % 2 == 1 then
        options = points[#points]
        table.remove(points, #points)
    end
    local function area(poly)
        local n = #poly
        local a = 0
        p = n - 1
        for q = 1, n, 2 do
            a = a + poly[p] * poly[q + 1] - poly[q] * poly[p + 1]
            p = q
        end --for q
        return a * 0.5
    end --area
    local function insideTriangle(Ax, Ay, Bx, By, Cx, Cy, Px, Py)
        local ax, ay, bx, by, cx, cy, apx, apy, bpx, bpy, cpx, cpy
        local cCROSSap, bCROSScp, aCROSSbp

        ax = Cx - Bx
        ay = Cy - By
        bx = Ax - Cx
        by = Ay - Cy
        cx = Bx - Ax
        cy = By - Ay
        apx = Px - Ax
        apy = Py - Ay
        bpx = Px - Bx
        bpy = Py - By
        cpx = Px - Cx
        cpy = Py - Cy

        aCROSSbp = ax * bpy - ay * bpx
        cCROSSap = cx * apy - cy * apx
        bCROSScp = bx * cpy - by * cpx

        return (aCROSSbp >= 0.0) and (bCROSScp >= 0.0) and (cCROSSap >= 0.0)
    end
    local EPSILON = 0.000001
    local function snip(contour, u, v, w, n, V)
        local Ax, Ay, Bx, By, Cx, Cy, Px, Py

        Ax = contour[V[u]]
        Ay = contour[V[u] + 1]

        Bx = contour[V[v]]
        By = contour[V[v] + 1]

        Cx = contour[V[w]]
        Cy = contour[V[w] + 1]

        if (EPSILON > (((Bx - Ax) * (Cy - Ay)) - ((By - Ay) * (Cx - Ax)))) then
            return false
        end --if

        for p = 1, n do
            if (p == u) or (p == v) or (p == w) then
            else
                Px = contour[V[p]]
                Py = contour[V[p] + 1]
                if (insideTriangle(Ax, Ay, Bx, By, Cx, Cy, Px, Py)) then
                    return false
                end --if
            end --if
        end --for p
        return true
    end
    --Problem with triangulation: It will error if there are 2 same points.
    local function triangulate(poly)
        local result = {}
        if #poly < 6 then
            return nil
        elseif #poly == 6 then
            return {poly}
        end
        --poly must be counter-clockwise
        local nv = #poly / 2
        local V = {}
        if area(poly) >= 0 then
            for i = 1, nv do
                V[i] = i * 2 - 1
            end
        else
            for i = 1, nv do
                V[i] = #poly - i * 2 + 1
            end
        end
        --remove nv-2 Vertices, creating 1 triangle every time
        local count = nv * 2
        local v = nv
        while nv > 2 do
            count = count - 1
            if count < 0 then
                return nil
            end
            --three consecutive vertices in current polygon, <u,v,w>
            local u = v
            if u > nv then
                u = 1
            end
            v = u + 1
            if v > nv then
                v = 1
            end
            local w = v + 1
            if w > nv then
                w = 1
            end
            if snip(poly, u, v, w, nv, V) then
                local a = V[u]
                local b = V[v]
                local c = V[w]
                table.insert(result, poly[a])
                table.insert(result, poly[a + 1])
                table.insert(result, poly[b])
                table.insert(result, poly[b + 1])
                table.insert(result, poly[c])
                table.insert(result, poly[c + 1])
                table.remove(V, v)
                nv = nv - 1
                count = nv * 2
            end
        end
        --result is a point table, so split into tri tables
        local temp = {}
        local chunk = 6
        for i = 1, #result, chunk do
            local temp2 = {}
            for i2 = 1, chunk do
                table.insert(temp2, result[i + i2 - 1])
            end
            table.insert(temp, temp2)
        end
        result = temp
        return result
    end
    local tris = triangulate(points)
    if options then
        for i = 1, #tris do
            Pixel.Tri(str, unpack(Table.Combine(tris[i], {options})))
        end
    else
        for i = 1, #tris do
            Pixel.Tri(str, unpack(tris[i]))
        end
    end
    return str
end

function Pixel.Polygon(self, ...)
    local str = GetPixelData(self)
    local fill = true
    local color = nil
    local fillcolor = nil
    local t = {GetPointTable(...)}
    if #t % 2 == 1 and type(t) == 'table' then --Vararg contains options
        local options = t[#t]
        local function a(a, b)
            if a ~= nil then
                return a
            else
                return b
            end
        end
        fill = a(options.fill, fill)
        color = a(options.color, color)
        fillcolor = a(options.fillcolor, fillcolor)
    end
    if fill then
        str = Pixel.PolygonFill(str, unpack(t))
    else
        table.remove(t, #t)
        local o = {color = color}
        for i = 1, #t - 2, 2 do
            --print(t[i], t[i + 1], t[i + 2], t[i + 3])
            str = Pixel.Line(str, t[i], t[i + 1], t[i + 2], t[i + 3], true, o)
        end
        str = Pixel.Line(str, t[#t - 1], t[#t], t[1], t[2], true, o)
    end
    SaveOpData(str, 'Polygon', ...)
    return str
end








--[=[
--v1
function Pixel.Circle(self, centerx, centery, r, op, options)
    local str = GetPixelData(self)
    local options, op = OrganizeColor(op, options)
    SaveOpData(str, 'Circle', centerx, centery, r, op, options)
--[[

a is the length of the cross section of circle (output)
r is the radius (input)
d is the distance from radius to line (input)

basic math explanation:
we use the pythagorean theorem (a ^ 2 + b ^ 2 = c ^ 2). we will plug in the r and d for a and b, and get the output. to get the length, all we have to do is to square root it. make sure to get the absolute value.


diagram:


         , - ~ ~ - ,
     , '             ' ,
   , |\                  ,
  ,  |   \ <--r           ,
 ,   |      \              ,
 ,a->|--<-d->-●            ,
 ,   |      /              ,
  ,  |   / <--r           ,
   , |/                  ,
     ,                , '
       ' - , _ _ ,  '



code:
--error checking
if d > r or d < 0 or r < 0 then
    error()
end

--actual formula
a = math.sqrt( (r ^ 2) - (d ^ 2) ) * 2
print(a)
]]



    for i = 1, r do
        local d = r - i
        if d > r or d < 0 or r < 0 then
            break
        end
        local a = math.sqrt( (r ^ 2) - (d ^ 2) ) * 2
        local a2 = Round(a / 2)
        --local a2 = math.floor(a / 2)
        --local a2 = math.ceil(a / 2)
        local offsetx = 0
        local offsety = 0
        str = Pixel.Line(str, i + centerx - r + offsetx, centery - a2 + offsety, i + centerx - r + offsetx, centery + a2 + offsety, true, options) --Left
        str = Pixel.Line(str, r - i + centerx + 1 + offsetx, centery - a2 + offsety, r - i + centerx + 1 + offsetx, centery + a2 + offsety, true, options) --Right
    end
    return str
end
--]=]

function Pixel.Ellipse(self, cx, cy, sx, sy, options)
    options = options or {}
    local str = GetPixelData(self)
    local set = Pixel.Data.Filled
--[[
Scanline Algorithm
https://stackoverflow.com/questions/10322341/simple-algorithm-for-drawing-filled-ellipse-in-c-c
Do a quarter, then mirror
Region is: Right Down
--]]
    local function check(x, y)
        return x ^ 2 * sy ^ 2 + y ^ 2 * sx ^ 2 <= sx ^ 2 * sy ^ 2
    end
    local x = sx
    for y = 0, sy do
        local a = false
        repeat
            a = check(x, y)
            x = x - 1
        until a
        x = x + 1
        
        for x2 = 0, x do
            Pixel.SetPixel(str, cx + x2, cy + y, set, options)
            Pixel.SetPixel(str, cx - x2, cy + y, set, options)
            Pixel.SetPixel(str, cx + x2, cy - y, set, options)
            Pixel.SetPixel(str, cx - x2, cy - y, set, options)


            --color --FIX
            if options.color then
                Pixel.SetColor(str, cx + x2, cy + y, options.color)
                Pixel.SetColor(str, cx - x2, cy + y, options.color)
                Pixel.SetColor(str, cx + x2, cy - y, options.color)
                Pixel.SetColor(str, cx - x2, cy - y, options.color)
            end
        end

    end
    return str
end

function Pixel.Circle(self, x, y, r, options)
    return Pixel.Ellipse(self, x, y, r, r, options)
end

















function Pixel.Graph(str, func, startx, endx, round) --func should return 1 value after inputted 1 value. it should be error proof.
    local round = round or true
    local startx = startx or 1
    local str = GetPixelData(str)
    local endx = endx or Pixel.GetSizeX(str)
    local t = str.Data
    if round then
        for i = startx, endx do
            local data = Round(func(i))
            t = Pixel.Line(str, i, data, i, data)
        end
    else
        for i = startx, endx do
            local data = func(i)
            t = Pixel.Line(str, i, data, i, data)
        end
    end
    return t
end



--Math / Complex Library

function Pixel.Area(self)
    local str = GetPixelData(self)
    local area = 0
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            if Pixel.GetPixel(x, y) == Pixel.Data.Filled then
                area = area + 1
            end
        end
    end
    return area
end

function Pixel.GetOutline(self)
    local str = GetPixelData(self)
    local new = Pixel.New()
    local check = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            local a = false
            for i = 1, #check do
                if Pixel.GetPixel(str, x + check[i][1], y + check[i][2]) ~= Pixel.Data.Filled then
                    a = true
                end
            end
            if a then
                new = Pixel.SetPixel(new, x, y, Pixel.Data.Filled)
            end
        end
    end
    return new
end
















--Maze / Pathfinding Library
PixelMaze = {}

--Binary tree algorithm
--[[
For each cell in the grid
    Check if a north or west neighbor exists
        1. Get a random neighbor
        2. Set the pixel between current cell and neighbor, to empty
]]
function PixelMaze.BT(cx, cy)
    local Visited = {}
    local cx, cy = cx % 2 + cx + 1, cy % 2 + cy + 1
    local str = Pixel.Polygon(Pixel.New(), 1, 1, cx, 1, cx, cy, 1, cy, {fill = true})
    for y = 2, cy, 2 do
        for x = 2, cx, 2 do
            str = Pixel.SetPixel(str, x, y, Pixel.Data.Empty)
            local t = {}
            if x > 2 then
                table.insert(t, {x - 1, y})
            end
            if y > 2 then
                table.insert(t, {x, y - 1})
            end
            if #t ~= 0 then
                local n = t[math.random(1, #t)]
                str = Pixel.SetPixel(str, n[1], n[2], Pixel.Data.Empty)
            end
        end
    end
    return str
end

--Depth-first search algorithm, http://rosettacode.org/wiki/Maze_generation
--[[
1. Start at a random cell
Mark the current cell as visited
    If there are no neighbors, then terminate
    For each randomly selected neighbor
        1. Set the pixel between current cell and neighbor, to empty
        2. Recurse as the neighbor
]]
function PixelMaze.DFS(cx, cy)
    local Visited = {}
    local cx, cy = cx % 2 + cx + 1, cy % 2 + cy + 1
    local str = Pixel.Polygon(Pixel.New(), 1, 1, cx, 1, cx, cy, 1, cy, {fill = true})
    local function RandomCell(cx, cy)
        return math.random(1, cx), math.random(1, cy)
    end
    local function GetRandomNeighbor(Visited, x, y, cx, cy)
        local t = {}
        local function Check(x, y)
            if x > cx or y > cy or x < 1 or y < 1 then
                return
            else
                table.insert(t, {x, y})
            end
        end
        local a = 2
        Check(x - a, y)
        Check(x + a, y)
        Check(x, y - a)
        Check(x, y + a)
        if #t > 0 then
            return t
        else
            return nil
        end
    end
    local function ShuffleTable(t)
        for i = 1, #t - 1 do
            local r = math.random(i, #t)
            t[i], t[r] = t[r], t[i]
        end
        return t
    end
    local function MakeTable(k)
        Visited[k] = Visited[k] or {}
    end
    local function Recurse(x, y)
        Pixel.SetPixel(str, x, y, Pixel.Data.Empty)
        MakeTable(x)
        Visited[x][y] = true --Mark current cell as visited
        --Get neighbors
        local t = GetRandomNeighbor(Visited, x, y, cx, cy)
        if t then
            --Shuffle
            t = ShuffleTable(t)
            for i = 1, #t do
                --Neighbor x, y
                local nx, ny = t[i][1], t[i][2]
                if Visited[nx] and Visited[nx][ny] then

                elseif nx > 0 and ny > 0 and nx <= cx and ny <= cy then
                    --Get the wall, (Between neighbor and current)
                    str = Pixel.SetPixel(str, (nx - x) / 2 + x, (ny - y) / 2 + y, Pixel.Data.Empty)
                    Recurse(nx, ny)
                end
            end
        else
            return
        end
    end
    local x, y = RandomCell(cx, cy)
    x, y = x % 2 + x, y % 2 + y
    Recurse(x, y)
    return str
end

--Kruskal's
--[[

]]










--Recursive Backtracker
--[[
Set current as start
Repeat
    Find neighbors that are walkable, and not visited
        If no neighbor, return
        Recurse as the neighbor
]]
function PixelMaze.Solve(str, sx, sy, ex, ey)
    local Directions = {
        ['l'] = {-1, 0, 'r'},
        ['r'] = {1, 0, 'l'},
        ['u'] = {0, -1, 'd'},
        ['d'] = {0, 1, 'u'}
    }
    local past = {}
    local function Recurse(x, y, steps, data)
        steps = steps or {}
        data = data or {}
        past[x] = past[x] or {}
        past[x][y] = true
        if x == ex and y == ey then
            return steps, data
        end
        local open = false
        for k, v in pairs(Directions) do
            local nx, ny = x + v[1], y + v[2]
            if past[nx] == nil or past[nx][ny] == nil then
                open = true
                if Pixel.GetPixel(str, nx, ny) == Pixel.Data.Empty then
                    table.insert(steps, k)
                    table.insert(data, {nx, ny})
                    local n = #steps
                    local a, b = Recurse(nx, ny, steps, data)
                    if a then
                        return a, b
                    else
                        local newsteps = {}
                        for i = 1, n - 1 do
                            table.insert(newsteps, steps[i])
                        end
                        steps = newsteps
                        local newdata = {}
                        for i = 1, n - 1 do
                            table.insert(newdata, data[i])
                        end
                        data = newdata
                    end
                end
            end
        end
        if open == false then
            return nil
        end
    end
    local steps, data = Recurse(sx, sy, {})
    --table.remove(steps, 1)
    return steps, data
end

--A star
--[[
https://medium.com/@nicholas.w.swift/easy-a-star-pathfinding-7e6689c7f7b2
]]
function PixelMaze.SolveShort(str, sx, sy, ex, ey)
    --Options
    local shortest = true --If true, it searches every cell to find the absolute shortest. false is for performance
    --Configurable options
    local cx = Pixel.GetSizeX(str)
    local cy = Pixel.GetSizeY(str)
    local function CalculateDistance(x1, y1, x2, y2)
        return (x2 - x1) ^ 2 + (y2 - y1) ^ 2
    end
    local function CalculateG(x, y)
        return CalculateDistance(x, y, sx, sy)
    end
    local function CalculateH(x, y)
        return CalculateDistance(x, y, ex, ey)
    end
    local function CalculateF(g, h)
        return g + h
    end
    local function Return(current)
        local c = current
        local t = {}
        local d = {}
        repeat
            if c then
                table.insert(t, {c.x, c.y})
                table.insert(d, c.d)
            else
                break
            end
            c = c.p
        until false
        local rt = {}
        local rd = {}
        for i = #t, 1, -1 do
            table.insert(rt, t[i])
            table.insert(rd, d[i])
        end
        return rd, rt
    end
    --Diagonal
    local neighbor = {
        {-1, -1, 'lu'},
        {0, -1, 'u'},
        {1, -1, 'ru'},
        {-1, 0, 'l'},
        --Current
        {1, 0, 'r'},
        {-1, 1, 'ld'},
        {0, 1, 'd'},
        {1, 1, 'rd'}
    }
    --LRUD
    local neighbor = {
        {0, -1, 'u'},
        {-1, 0, 'l'},
        --Current
        {1, 0, 'r'},
        {0, 1, 'd'}
    }
    local open = {}
    local closed = {}
    table.insert(open, {
        x = sx,
        y = sy,
        g = 0,
        h = 0,
        f = 0
    })
    local current
    while #open ~= 0 do
        current = nil
        for i = 1, #open do
            if not current or open[i].f < current.f then
                current = open[i]
            end
        end
        if not shortest and current.x == ex and current.y == ey then
            return Return(current)
        end
        table.insert(closed, current)
        for i = 1, #open do
            if open[i].x == current.x and open[i].y == current.y then
                table.remove(open, i)
                break
            end
        end
        for i = 1, #neighbor do
            local nx, ny, dir = current.x + neighbor[i][1], current.y + neighbor[i][2], neighbor[i][3]
            if nx > 0 and nx <= cx and ny > 1 and nx <= cy then
                if Pixel.GetPixel(str, nx, ny) == Pixel.Data.Empty then
                    local inclosed = false
                    for i2 = 1, #closed do
                        local c = closed[i2]
                        if c.x == nx and c.y == ny then
                            inclosed = true
                            break
                        end
                    end
                    if inclosed == false then
                        local inopen = false
                        for i2 = 1, #closed do
                            local c = closed[i2]
                            if c.x == nx and c.y == ny then
                                inopen = true
                                break
                            end
                        end
                        if inopen == false then
                            local t = {
                                x = nx,
                                y = ny,
                                g = CalculateG(nx, ny),
                                h = CalculateH(nx, ny),
                                
                                p = current,
                                d = dir
                            }
                            t.f = CalculateF(t.g, t.h)
                            table.insert(open, t)
                        else
                            
                        end
                    end
                end
            end
        end
    end
    if shortest then
        return Return(current)
    else
        return nil --Unable to find path
    end
end

function PixelMaze.Mark(str, sx, sy, t, set) --t should be an output from PixelMaze.Solve
    local Directions = {
        ['l'] = {-1, 0, 'r'},
        ['r'] = {1, 0, 'l'},
        ['u'] = {0, -1, 'd'},
        ['d'] = {0, 1, 'u'}
    }
    local x, y = sx, sy
    for i = 1, #t do
        str = Pixel.SetPixel(str, x, y, set)
        local d = Directions[t[i]]
        x, y = d[1] + x, d[2] + y
    end
    return str
end


function PixelMaze.Color(str, sx, sy, t, set) --t should be an output from PixelMaze.Solve
    local Directions = {
        ['l'] = {-1, 0, 'r'},
        ['r'] = {1, 0, 'l'},
        ['u'] = {0, -1, 'd'},
        ['d'] = {0, 1, 'u'}
    }
    local x, y = sx, sy
    for i = 1, #t do
        str = Pixel.SetColor(str, x, y, set)
        local d = Directions[t[i]]
        x, y = d[1] + x, d[2] + y
    end
    --print(#str.Color)
    return str
end


















--3d Library

Pixel3d = {}



--Some functions



--Translated from scratch
local function ProjectPoint(x, y, z, camx, camy, camz, rotx, roty, viewfactor)
    --Reverse rotx and roty (what the fuck?)
    rotx, roty = roty, rotx
    --Negate rotx and roty (what the fuck?)
    rotx, roty = -rotx, -roty
    --Convert to radians
    rotx, roty = math.rad(rotx), math.rad(roty)
    --Calculate trig values
    local sinx, cosx, siny, cosy = math.sin(rotx), math.cos(rotx), math.sin(roty), math.cos(roty)
    --Set point
    x, y, z = x - camx, y - camy, z - camz
    --Set point
    x, y, z = (z * siny) + (x * cosy), y, (z * cosy) - (x * siny)
    --Set point
    x, y, z = x, (y * cosx) - (z * sinx), (y * sinx) + (z * cosx)
    --Z clipping
    
    --View factor?
    rx, ry = viewfactor * (x / z), viewfactor * (y / z)
    --Round (added step)
    rx, ry = Round(rx), Round(ry)
    return rx, ry
end

local function ClipTri3d(a, b, c)
    --todo
end
--http://graphics.cs.cmu.edu/nsp/course/15-462/Spring04/slides/06-viewing.pdf
--https://rosettacode.org/wiki/Sutherland-Hodgman_polygon_clipping#Lua
local function ClipPolygon(cx, cy, ...)
    cx, cy = cx / 2, cy / 2
    local subjectPolygon = {}
    local t = {...}
    for i = 1, #t, 2 do
        table.insert(subjectPolygon, {t[i], t[i + 1]})
    end
    local clipPolygon = {{-cx, -cy}, {cx, -cy}, {cx, cy}, {-cx, cy}}
    
    local function inside(p, cp1, cp2)
        return (cp2.x - cp1.x) * (p.y - cp1.y) > (cp2.y - cp1.y) * (p.x - cp1.x)
    end
    
    local function intersection(cp1, cp2, s, e)
        local dcx, dcy = cp1.x - cp2.x, cp1.y - cp2.y
        local dpx, dpy = s.x - e.x, s.y - e.y
        local n1 = cp1.x * cp2.y - cp1.y * cp2.x
        local n2 = s.x * e.y - s.y * e.x
        local n3 = 1 / (dcx * dpy - dcy * dpx)
        local x = (n1 * dpx - n2 * dcx) * n3
        local y = (n1 * dpy - n2 * dcy) * n3
        return {x = x, y = y}
    end
    
    local function clip(subjectPolygon, clipPolygon)
        local outputList = subjectPolygon
        local cp1 = clipPolygon[#clipPolygon]
        for _, cp2 in ipairs(clipPolygon) do -- WP clipEdge is cp1,cp2 here
            local inputList = outputList
            outputList = {}
            local s = inputList[#inputList]
            for _, e in ipairs(inputList) do
                if inside(e, cp1, cp2) then
                    if not inside(s, cp1, cp2) then
                        outputList[#outputList + 1] = intersection(cp1, cp2, s, e)
                    end
                    outputList[#outputList + 1] = e
                elseif inside(s, cp1, cp2) then
                    outputList[#outputList + 1] = intersection(cp1, cp2, s, e)
                end
                s = e
            end
            cp1 = cp2
        end
        return outputList
    end
    
    local function main()
        local function mkpoints(t)
            for i, p in ipairs(t) do
                p.x, p.y = p[1], p[2]
            end
        end
        mkpoints(subjectPolygon)
        mkpoints(clipPolygon)
    
        local outputList = clip(subjectPolygon, clipPolygon)
        local out = {}
        for i = 1, #outputList do
            local x, y = outputList[i].x, outputList[i].y
            local duplicate = false
            for i2 = 1, #out, 2 do
                if i ~= i2 and x == out[i2] and y == out[i2 + 1] then
                    duplicate = true
                end
            end
            if duplicate == false then
                table.insert(out, Round(x))
                table.insert(out, Round(y))
            end
        end
        return unpack(out)
    end
    
    return main()
end

local function AngleInRange(angle, r1, r2)
    --is angle between r1 and r2?
    --use normalized angles
    r1 = (r1 > 180) and (r1 - 360) or r1
    angle = (angle > 180) and (angle - 360) or angle
    return (r1 < angle) and (angle < r2)
end
local function NormalizeAngle(deg)
    return deg - (math.floor(deg / 360) * 360)
end
local function Normalize(x1, y1, z1, x2, y2, z2)
    --Sets the line length to 1, while preserving everything else
    xn, yn, zn = x < 0, y < 0, z < 0
    x, y, z = x2 - x1, y2 - y1, z2 - z1
    n = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
    x, y, z = x / n, y / n, z / n
    if xn then
        x = x * -1
    end
    if yn then
        y = y * -1
    end
    if zn then
        z = z * -1
    end
    return x1, y1, z1, x1 + x, y1 + y, z1 + z
end



local function ParseObject(str)
    --[[
    This function parses an object file.
    Pass on the file content.
    In blender, the object must be exported as an 'Wavefront Object' file. 'Triangulate faces' and 'Export as obj' must be on, and everything else should be off.
    --]]
    local t = {}
    local vertices = {} --Format: {{x, y, z}, {x, y, z}, ...}
    local polygons = {} --Format: {{{x1, y1, z1}, {x2, y2, z2}, {x3, y3, z3}}, {{x1, y1, z1}, {x2, y2, z2}, {x3, y3, z3}}, ...}
    local polygonindex = {} --Format: {{p1, p2, p3}, {p1, p2, p3}, ...}
    local counter = 0
    local function Hook(start, func)
        table.insert(t, {start, func})
    end
    --Vertex
    Hook('v', function(t)
        local temp = {}
        for i = 2, #t do
            table.insert(temp, tonumber(t[i]))
        end
        table.insert(vertices, temp)
    end)
    --Polygon
    Hook('f', function(t)
        local temp = {}
        local temp2 = {}
        for i = 2, #t do
            table.insert(temp, vertices[tonumber(t[i])])
            table.insert(temp2, tonumber(t[i]))
        end
        table.insert(polygons, temp)
        table.insert(polygonindex, temp2)
    end)
    local data = Split(str, '\n')
    for i = 1, #data do
        local chunk = Split(data[i], ' ')
        for i2 = 1, #t do
            if t[i2][1] == chunk[1] then
                counter = counter + 1
                t[i2][2](chunk)
                break
            end
        end
    end
    return vertices, polygons, polygonindex
end






function Pixel3d.New(t)
    --t should be a dictionary with attributes
    --Example: t = {x = 1, y = 1, z = 1, size = 100}
    local Object = {}
    setmetatable(Object, Pixel3d)
    if t then
        for k, v in pairs(t) do
            Object[string.lower(k)] = v
        end
        return Object
    end
end

function Pixel3d.Default()
    local Object = Pixel3d.New(
    {
        x = 0,
        y = 0,
        z = 0,
        size = {
            x = 0,
            y = 0,
            z = 0
        }
    })
    return Object
end

function Pixel3d.Point()
    local Object = Pixel3d.New(
    {
        x = 0,
        y = 0,
        z = 0,
        type = 'Point',
        size = {
            x = 0,
            y = 0,
            z = 0
        }
    })
    return Object
end

function Pixel3d.Box(sx, sy, sz)
    local Object = Pixel3d.New(
    {
        --Type
        type = 'Box',
        --Coordinates
        x = 0,
        y = 0,
        z = 0,
        --Size
        size = {
            x = 0,
            y = 0,
            z = 0
        },
        fill = nil, --Fill the surface
        color = nil, --Color of the edges
        fillcolor = nil, --Color of the surface
        colorall = nil --Overrides color and fillcolor, to set a color for all of the object
    })
    Object.size.x, Object.size.y, Object.size.z = sx, sy, sz
    return Object
end

function Pixel3d.Sphere(rsx, sy, sz)
    local Object = Pixel3d.New(
    {
        x = 0,
        y = 0,
        z = 0,
        radius = rsx,
        type = 'Sphere'
    })
    return Object
end

--https://stackoverflow.com/questions/9614109/how-to-calculate-an-angle-from-points
--result is in degrees
local function CalculateAngle(cx, cy, ex, ey)
    local dy = ey - cy
    local dx = ex - cx
    if dx == 0 then
        if dy > 0 then
            return 90
        elseif dy < 0 then
            return 270
        else
            return 0 --cx, cy = ex, ey ?
        end
    end
    local theta = math.atan2(dy, dx) --rad
    theta = theta * 180 / math.pi
    return theta
end

function Pixel3d.RenderObject(Object, cx, cy, cz, fov, rx, ry, options)
    --Default settings
    local fov = fov or 105 --field of view (degrees) (minecraft is 70, 150)
    fov = 180
    fov = 105
    local cx, cy, cz = cx or 0, cy or 0, cz or 0 --Camera coordinates
    local rx, ry = rx or 0, ry or 0 --Camera Rotation, in degrees
    local scale = scale or 25 --Scale
    local clipx, clipy = 200, 200 --Total Width
    clipx, clipy = 100, 100
    --Normalize Angle
    rx = NormalizeAngle(rx)

    --[[
    --Z Buffer
    local ZBuffer = {}
    --]]

    --Options
    local options = options or {fill = false, color = 'red'}

    --Make Blank
    local str = Pixel.New() --Relies on expandable canvas
    str.Color.All = options.colorall

    --Parse Object
    local v, p, index = ParseObject(Object) --Vertex, Polygon
    local ProjectedPoint = {}

    --2d Map (debug)
    local _ = 2
    local map = Pixel.New()
    local crx, crz = Round(cx), Round(cz)
    map = Pixel.SetPixel(map, crx * _, crz * _, Pixel.Data.Filled)
    map = Pixel.SetColor(map, crx * _, crz * _, 'red')
    -- [[
    print(rx, (NormalizeAngle(rx - fov / 2)))
    local fovx1, fovy1, fovz1 = Pixel3d.CalculateMovement(crx * _, 0, crz * _, (NormalizeAngle(rx - fov / 2)), 0, 10)
    local fovx2, fovy2, fovz2 = Pixel3d.CalculateMovement(crx * _, 0, crz * _, (NormalizeAngle(rx + fov / 2)), 0, 10)
    map = Pixel.Line(map, crx * _, crz * _, Round(fovx1), Round(fovz1))
    map = Pixel.Line(map, crx * _, crz * _, Round(fovx2), Round(fovz2))
    --]]
    local fx, fy, fz = Pixel3d.CalculateMovement(crx * _, 0, crz * _, (NormalizeAngle(rx)), 0, 20)
    map = Pixel.Line(map, crx * _, crz * _, Round(fx), Round(fz))

    --Parse Verticies
    for i = 1, #v do
        local point = v[i]
        local x, y, z = point[1], point[2], point[3]
        local px, py = ProjectPoint(x, y, z, cx, cy, cz, rx, ry, scale)
        local zbuffer = math.sqrt((cx - x) ^ 2 + (cy - y) ^ 2 + (cz - z) ^ 2) --3d distance formula
        --[[
         , - ~ ~ ~ - ,
     , ' rx-fov/2      ' ,rx+fov/2
   ,  \                 /  ,
  ,      \           /      ,
 ,          \     /          ,
 ,             P             ,
 ,                           ,
  ,                 O       ,
   ,                       ,
     ,                  , '
       ' - , _ _ _ ,  '        
        ]]
        --calculate angle
        local angle = NormalizeAngle(CalculateAngle(cx, cz, x, z) - 90)
        --negate it if it's behind
        --range
        --print('RANGE', (rx - fov / 2), (rx + fov / 2), 'ANGLE', angle)
        map = Pixel.SetPixel(map, x * _, z * _, Pixel.Data.Filled)

        --if angle > NormalizeAngle(rx - fov / 2) and angle < NormalizeAngle(rx + fov / 2) then
        if AngleInRange(angle, NormalizeAngle(rx - fov / 2), NormalizeAngle(rx + fov / 2)) then
            --in range
        else
            
            zbuffer = -zbuffer
        end
        table.insert(ProjectedPoint, {px, py, {x, y, z}, zbuffer})
    end
    print(map)
    for i = 1, #index do
        local Projected = {}
        --if any points on zbuf greater than 0
        --todo: implement real zbuffer
        local valid = false
        for i2 = 1, #index[i] do
            local point = ProjectedPoint[index[i][i2]]
            local px, py = point[1], point[2]
            local zbuffer = point[4]
            if zbuffer > 0 then
                valid = true
            end
            table.insert(Projected, px)
            table.insert(Projected, py)
        end
        if valid then
            Projected = {ClipPolygon(clipx, clipy, unpack(Projected))}
            if #Projected >= 6 then
                local valid = true
                for i = 1, #Projected do
                    --detect NAN, INF
                    local a = Projected[i]
                    if a ~= a or a == 1/0 then
                        valid = false
                    end
                end
                if valid then
                    table.insert(Projected, options) --Bug in lua, unpacking and mixing arguments don't work well
                    --Draw Polygons
                    Pixel.Polygon(str, unpack(Projected))
                end
            end
        end
    end
    return str
end



function Pixel3d.CalculateMovement(x, y, z, rx, ry, distance)
    --rx, ry should be deg
    rx, ry = math.rad(rx), ry
    --[[
    Get x, y from x, y, angle, distance


    Radians
    360 = 2pi radians
    90 = pi/2 radians
    45 = pi/4 radians
    
    X

            0


    270     O     90


           180


    Y

           0


D   270    O     90   U


          180
    --]]
    return x + math.sin(rx) * distance, y + math.sin(ry), z + math.cos(rx) * distance
end

--https://www.khanacademy.org/computer-programming/interactive-3d-cube/6436122472742912
--
function Pixel3d.Interactive(Object, cx, cy, cz, fov, rx, ry, options)
    --Default settings
    local fov = fov or 70 --field of view
    local cx, cy, cz = cx or 0, cy or 0, cz or 0 --Camera coordinates
    local rx, ry = rx or 0, ry or 0 --Camera Rotation, in degrees

    --Settings
    local cms = 1 --Camera moving speed
    local crs = 10 --Camera rotation speed
    
    crs = 45



    print('Use wasd to move, and ijkl to move camera. Type stop to stop.')
    --Keybinds
    local t = {}
    local function Main(input)
        if t[input] then
            t[input]()
        end
    end
    local function Bind(k, f)
        t[k] = f
    end
    --Move
    local function Move(x)
        cx, cy, cz = Pixel3d.CalculateMovement(cx, cy, cz, (rx + x), (ry), cms)
    end
    Bind('w', function()
        Move(0)
    end)
    Bind('a', function()
        rx = rx - crs
    end)
    Bind('s', function()
        Move(-180)
    end)
    Bind('d', function()
        rx = rx + crs
    end)
    --Camera
    Bind('c', function()
        Move(-90)
    end)
    Bind('v', function()
        Move(90)
    end)

    Bind('i', function()
        ry = ry + crs
    end)
    Bind('j', function()
        rx = rx - crs
    end)
    Bind('k', function()
        ry = ry - crs
    end)
    Bind('l', function()
        rx = rx + crs
    end)
    --Debug
    Bind('debug', function()
        print(cx, cy, cz)
        print(rx, ry)
        --print(sinx, cosx, siny, cosy)
    end)
    Bind('up', function()cy = cy + cms end)
    Bind('down', function()cy = cy - cms end)
    repeat
        print(Pixel3d.RenderObject(Object, cx, cy, cz, fov, rx, ry, options))
        local input = string.lower(io.read())
        Main(input)
    until input == 'stop'
end






















--Conway's Game of Life
--[[
- Each cell has 8 neighbors
- Any live cell with fewer than two live neighbours dies, as if by underpopulation.
- Any live cell with two or three live neighbours lives on to the next generation.
- Any live cell with more than three live neighbours dies, as if by overpopulation.
- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
--]]

GameOfLife = {}


--[=[
--v1, no optimizations
function GameOfLife.NextGeneration(self)
    local str = GetPixelData(self)
    local new = Pixel.New()
    local function CheckN(x, y)
        local a = 0
        local t = {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}}
        local t = 
        {
        {-1, -1}, {0, -1}, {1, -1},
        {-1, 0},           {1, 0},
        {-1, 1},  {0, 1},  {1, 1}
        }
        for i = 1, #t do
            --print(Pixel.GetPixel(str, x + t[i][1], y + t[i][2]))
            a = a + tonumber(Pixel.GetPixel(str, x + t[i][1], y + t[i][2]) or 0)
        end
        --print('OVER')
        return a
    end
    local function CheckCell(x, y)
        --print(x,y)
        local n = CheckN(x, y)
        local p = Pixel.GetPixel(str, x, y)
        if p == Pixel.Data.Filled then
            if n == 2 or n == 3 then
                Pixel.SetPixel(new, x, y, Pixel.Data.Filled)
            else
                --Pixel.SetPixel(new, x, y, Pixel.Data.Empty)
            end
        elseif n == 3 then --Should be dead
            Pixel.SetPixel(new, x, y, Pixel.Data.Filled)
        end
    end
    local minx, miny, maxx, maxy = nil, nil, nil, nil
    for x, v in pairs(str.Data) do
        --[[
        if minx then
            if x < minx then
                minx = x
            end
        else
            minx = x
        end
        --]]
        minx = minx and ( ( minx > x ) and x or minx ) or x
        maxx = maxx and ( ( maxx < x ) and x or maxx ) or x
        for y, v2 in pairs(v) do
            miny = miny and ( ( miny > y ) and y or miny ) or y
            maxy = maxy and ( ( maxy < y ) and y or maxy ) or y
            --CheckCell(x, y)
        end
    end
    --Check cells of all the grid. Even "nil" ones
    for x = minx, maxx do
        for y = miny, maxy do
            CheckCell(x, y)
        end
    end
    --[[
    Check cells just around the grid.
    C = check
    . = cell
    CCCCC
    C...C
    C...C
    C...C
    CCCCC
    ]]
    for x = minx - 1, maxx do
        CheckCell(x, miny - 1)
    end
    for y = miny - 1, maxy do
        CheckCell(maxx + 1, y)
    end
    for x = maxx + 1, minx, -1 do
        CheckCell(x, maxy + 1)
    end
    for y = maxy + 1, miny, -1 do
        CheckCell(minx - 1, y)
    end
    return new
end
--]=]


function GameOfLife.NextGeneration(self)
    local str = GetPixelData(self)
    local new = Pixel.New()
    local function CheckCell(x, y)
        --print(x,y)
        -- [[
        local n = 0
        n = Pixel.GetPixel(str, x-1, y-1) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x  , y-1) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x+1, y-1) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x-1, y  ) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x+1, y  ) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x-1, y+1) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x  , y+1) == Pixel.Data.Filled and n + 1 or n
        n = Pixel.GetPixel(str, x+1, y+1) == Pixel.Data.Filled and n + 1 or n
        --]]
        local p = Pixel.GetPixel(str, x, y)
        if p == Pixel.Data.Filled then
            if n == 2 or n == 3 then
                Pixel.SetPixel(new, x, y, Pixel.Data.Filled)
            else
                --Pixel.SetPixel(new, x, y, Pixel.Data.Empty)
            end
        elseif n == 3 then --Should be dead
            Pixel.SetPixel(new, x, y, Pixel.Data.Filled)
        end
    end
    local c = {}
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            c[x-1] = c[x-1] or {}
            c[x  ] = c[x  ] or {}
            c[x+1] = c[x+1] or {}

            
            c[x-1][y-1] = true
            c[x  ][y-1] = true
            c[x+1][y-1] = true
            c[x-1][y  ] = true
            c[x  ][y  ] = true
            c[x+1][y  ] = true
            c[x-1][y+1] = true
            c[x  ][y+1] = true
            c[x+1][y+1] = true
        end
    end
    for x, v in pairs(c) do
        for y, v2 in pairs(v) do
            CheckCell(x, y)
        end
    end
    return new
end











--DrawWithJoints.lua
--Inspiration: https://www.youtube.com/watch?v=pgAHW8OpcTY
local armlength = 50
local function GetJoint(x1, y1, x2, y2)
    --https://www.geeksforgeeks.org/find-points-at-a-given-distance-on-a-line-of-given-slope/
    --midpoint
    local mx, my = (x1 + x2) / 2, (y1 + y2) / 2
    --perpendicular slope to line x1y1 to x2y2
    local slope = -1 / ((y2 - y1) / (x2 - x1))
    local distance = math.sqrt((armlength ^ 2) - ((((mx - x1) ^ 2 + (my - y1) ^ 2))))
    --print(distance)

    
    --there should be plus and minus, but we are only including plus for now.
    --joint will always be on the right or up. just swap points if u want left or down.
    if x1 == x2 then
        return Round(mx + distance), Round(my)
    elseif y1 == y2 then
        return Round(mx), Round(my + distance)
    else
        local dx = (distance / math.sqrt(1 + (slope ^ 2)));
        local dy = slope * dx;
        return Round(mx + dx), Round(mx + dy)
    end


    --[=[
    --doesn't work
    local mx, my = (x1 + x2) / 2, (y1 + y2) / 2
    --perpendicular slope to line x1y1 to x2y2
    --local slope = -1 / ((y2 - y1) / (x2 - x1))
    --slope of line x1y1 to x2y2
    local slope = ((y2 - y1) / (x2 - x1))
    local distance = (x2 - x1) ^ 2 + (y2 - y1) ^ 2
    --[[
    form a triangle
    armlength ^ 2 = (distance / 2) ^ 2 + (pointdistance) ^ 2
    pointdistance ^ 2 = armlength ^ 2 - (distance / 2) ^ 2
    --]]
    local pointdistance = math.sqrt(armlength ^ 2 - (distance / 2) ^ 2)
    --If slope is closer to 0, more down. If closer to 1, more directional.
    return mx + (distance * ()), my + (distance * ())
    --]=]
    --[[
for i = 1, 1 do
    local x1, y1, x2, y2 = 0, 0, i, 0
    local x3, y3 = GetJoint(x1, y1, x2, y2)
    print(x3, y3)
    print(Pixel.New():Line(x1, y1, x3, y3):Line(x3, y3, x2, y2))
end
print('START')

for i = 1, 10 do
    local x1, y1, x2, y2 = 0, i, 8, 0
    local x3, y3 = GetJoint(x1, y1, x2, y2)
    print(x3, y3)
    print(Pixel.New():Line(x1, y1, x3, y3):Line(x3, y3, x2, y2))
end
    ]]
end

local function CreateArm(str, x1, y1, x2, y2)
    local x3, y3 = GetJoint(x1, y1, x2, y2)
    str = Pixel.Line(str, x1, y1, x3, y3)
    str = Pixel.Line(str, x3, y3, x2, y2)
    return str
end

function Pixel.AnimateWrite(old, new, ox, oy)
    local interpolate = true
    --old should be a canvas to write on, new should just have the places to write filled, ox and oy should be the place where the arm starts.
    old = GetPixelData(old)
    new = GetPixelData(new)
    ox = ox or 0
    oy = oy or 0
    local tx = {}
    local ty = {}
    for x, v in pairs(new.Data) do
        for y, v2 in pairs(v) do
            if v2 == Pixel.Data.Filled then
                table.insert(tx, x)
                ty[x] = ty[x] or {}
                table.insert(ty[x], y)
            end
        end
    end
    --ppp(tx)ppp(ty)
    table.sort(tx)
    local function Output(str)
        print(str)
        --wait
        --local a=os.clock()repeat until a+0.5<=os.clock()
    end
    local function Interpolate(x1, y1, x2, y2)
        local n = 0
        if math.abs(x2 - x1) <= 1 and math.abs(y2 - y1) <= 1 then
            --nothing to interpolate
            return n
        else
            --use pixel.line but with funcs
            Pixel.Line(Pixel.New(), x1, y1, x2, y2, {setfunction = function(x, y)
                --print(x, y)
                if (x == x1 and y == y1) or (x == x2 and y == y2) then
                    --ignore
                else
                    --print('INTERPOLATE', x, y)
                    n = n + 1
                    local temp = Pixel.Copy(old)
                    temp = CreateArm(temp, ox, oy, x, y)
                    Output(temp)
                end
            end})
            return n
        end
    end
    local lastx, lasty
    for i = 1, #tx do
        local x = tx[i]
        if lastx ~= x then
            table.sort(ty[x])
            for i2 = 1, #ty[x] do
                local y = ty[x][i2]
                if lasty then
                    if lastx and i2 == 1 then
                        --special happens when x change
                        --print(lastx, lasty, x, y)
                        Interpolate(lastx, lasty, x, y)
                    else
                        --print(x, lasty, x, y)
                        Interpolate(x, lasty, x, y)
                    end
                end
                --print(ox, oy, x2, y2, x, y)
                local temp = Pixel.Copy(old)
                temp = CreateArm(temp, ox, oy, x, y)
                old = Pixel.SetPixel(old, x, y, Pixel.Data.Filled)
                Output(temp)
                lasty = y
            end
            lastx = x
        end
    end
end

















--https://github.com/Rochet2/lualzw/blob/master/lualzw.lua
--[[
MIT License
Copyright (c) 2016 Rochet2
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]


local char = string.char
local type = type
local select = select
local sub = string.sub
local tconcat = table.concat

local basedictcompress = {}
local basedictdecompress = {}
for i = 0, 255 do
    local ic, iic = char(i), char(i, 0)
    basedictcompress[ic] = iic
    basedictdecompress[iic] = ic
end

local function dictAddA(str, dict, a, b)
    if a >= 256 then
        a, b = 0, b+1
        if b >= 256 then
            dict = {}
            b = 1
        end
    end
    dict[str] = char(a,b)
    a = a+1
    return dict, a, b
end

local function compress(input)
    if type(input) ~= "string" then
        return nil, "string expected, got "..type(input)
    end
    local len = #input
    if len <= 1 then
        return "u"..input
    end

    local dict = {}
    local a, b = 0, 1

    local result = {"c"}
    local resultlen = 1
    local n = 2
    local word = ""
    for i = 1, len do
        local c = sub(input, i, i)
        local wc = word..c
        if not (basedictcompress[wc] or dict[wc]) then
            local write = basedictcompress[word] or dict[word]
            if not write then
                return nil, "algorithm error, could not fetch word"
            end
            result[n] = write
            resultlen = resultlen + #write
            n = n+1
            if  len <= resultlen then
                return "u"..input
            end
            dict, a, b = dictAddA(wc, dict, a, b)
            word = c
        else
            word = wc
        end
    end
    result[n] = basedictcompress[word] or dict[word]
    resultlen = resultlen+#result[n]
    n = n+1
    if  len <= resultlen then
        return "u"..input
    end
    return tconcat(result)
end

local function dictAddB(str, dict, a, b)
    if a >= 256 then
        a, b = 0, b+1
        if b >= 256 then
            dict = {}
            b = 1
        end
    end
    dict[char(a,b)] = str
    a = a+1
    return dict, a, b
end

local function decompress(input)
    if type(input) ~= "string" then
        return nil, "string expected, got "..type(input)
    end

    if #input < 1 then
        return nil, "invalid input - not a compressed string"
    end

    local control = sub(input, 1, 1)
    if control == "u" then
        return sub(input, 2)
    elseif control ~= "c" then
        return nil, "invalid input - not a compressed string"
    end
    input = sub(input, 2)
    local len = #input

    if len < 2 then
        return nil, "invalid input - not a compressed string"
    end

    local dict = {}
    local a, b = 0, 1

    local result = {}
    local n = 1
    local last = sub(input, 1, 2)
    result[n] = basedictdecompress[last] or dict[last]
    n = n+1
    for i = 3, len, 2 do
        local code = sub(input, i, i+1)
        local lastStr = basedictdecompress[last] or dict[last]
        if not lastStr then
            return nil, "could not find last from dict. Invalid input?"
        end
        local toAdd = basedictdecompress[code] or dict[code]
        if toAdd then
            result[n] = toAdd
            n = n+1
            dict, a, b = dictAddB(lastStr..sub(toAdd, 1, 1), dict, a, b)
        else
            local tmp = lastStr..sub(lastStr, 1, 1)
            result[n] = tmp
            n = n+1
            dict, a, b = dictAddB(tmp, dict, a, b)
        end
        last = code
    end
    return tconcat(result)
end



--Pixel.Compress
--[[
TODO: Encode metadata
]]

function Pixel.Compress(str)
    local str = GetPixelData(str)



    --Add metadata before compression
    local metadata = {'M'}
    table.insert(metadata, 'Color{')
    for x, v in pairs(str.Color) do
        table.insert(metadata, '[')
        table.insert(metadata, tostring(x))
        table.insert(metadata, ']={')
        for y, v2 in pairs(v) do
            if v2 then
                table.insert(metadata, '[')
                table.insert(metadata, tostring(y))
                table.insert(metadata, ']=\'')
                table.insert(metadata, tostring(v2))
                table.insert(metadata, '\',')
            end
        end
        metadata[#metadata] = '\''
        table.insert(metadata, '}')
    end
    table.insert(metadata, '}')
    metadata = table.concat(metadata)


    --Pixel.Convert.From2d
    local from2d, x, y = Pixel.Convert.From2d(str)
    local string = 'X' .. tostring(x) .. 'Y' .. tostring(y) .. 'S' .. from2d .. metadata
    --Pixel.Convert.From2d + lzw
    local stringlzw = compress(string)

    do
        return '1' .. stringlzw
    end










    --Rectangle
    local final = {}
    --Compress Data
    --[[
        t = {
            [1] = {
                [1] = '1',
                ...
            },
            ...
        }
        OPCODE
        --point
        X 1 SETX 1
        Y 1 SETY 1
        S 1 SET '1'
        --rectangle
        A 1 SETX1 1
        B 1 SETY1 1
        C 1 SETX2 1
        D 1 SETY2 1
    ]]
    --Compress into rectangle
    local size = 4
    local unfilledpenalty = 0
    local filledreward = 0
    local rect = {}
    for x1, v in pairs(str.Data) do --Get a point
        for y1, v2 in pairs(v) do
            for x2, v3 in pairs(str.Data) do --Get another point
                for y2, v4 in pairs(v3) do
                    if x2 > x1 and y2 > y1 then --No repeat check
                        if math.abs(x2 - x1) > size and math.abs(y2 - y1) > size then
                            local count = 0
                            for x = x1, x2 do --Count points (Filled)
                                for y = y1, y2 do
                                    if Pixel.GetPixel(str, x, y) == Pixel.Data.Filled then
                                        count = count + 1
                                    end
                                end
                            end
                            local area = ((math.abs(x2 - x1) + 1) * (math.abs(y2 - y1) + 1))
                            if (count / area) > 0.8  then --Over threshold
                                --Estimate reduction in space
                                --print(area, (area - count) == 1)
                                --local reduction = ((((math.abs(x2 - x1) + 1) * 2) + (area * 2)) - (8 + ((area - count) * 4)))
                                --Algorithm for reduction
                                local reduction = ((2 + #tostring(x1) + #tostring(y1) + area + (math.abs(x2 - x1))) - (4 + #tostring(x1) + #tostring(y1) + #tostring(x2) + #tostring(y2) + (unfilledpenalty * (area - count) + (filledreward * ((count / area) == 1 and 1 or 0))))) / 1
                                --local reduction = count / area
                                if reduction > 0 then
                                    table.insert(rect, {reduction, x1, y1, x2, y2})
                                    --print('YAY', reduction, x1, y1, x2, y2)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end
    for k, v in spairs(rect, function(t, a, b) return t[a][1] > t[b][1] end) do
        if v then
            --print(v[2], v[3], v[4], v[5])
            --print(k, v[1])
            local a = {v[2], v[3], v[4], v[5]}
            --Destroy all other overlaps
            for k2, v in pairs(rect) do
                if k ~= k2 then
                    --print(k, k2)
                    local b = {v[2], v[3], v[4], v[5]}
                    --https://stackoverflow.com/questions/306316/determine-if-two-rectangles-overlap-each-other
                    --if (RectA.Left < RectB.Right && RectA.Right > RectB.Left &&
                    --    RectA.Top > RectB.Bottom && RectA.Bottom < RectB.Top ) 
                    --print(a[1] < b[3] , a[3] > b[1] , a[2] > b[4] , a[2] < b[4])
                    if a[1] < b[3] and a[3] > b[1] and a[2] < b[4] and a[4] > b[2] then
                        --print('overlap')
                        rect[k2] = nil
                    end
                end
            end
        end
    end
    local cx, cy = nil, nil
    local function Encode(x, y, v)
        local s = false
        if not (cx == x) then
            table.insert(final, 'X')
            table.insert(final, x)
            cx = x
            s = true
        end
        if not (cy and (cy + 1 == y) or false) then
            table.insert(final, 'Y')
            table.insert(final, y)
            s = true
        end
        if s then
            table.insert(final, 'S')
        end
        table.insert(final, v)
        cy = y
    end
    for k, v in spairs(rect, function(t, a, b) return t[a][1] > t[b][1] end) do
        --print(k, v[1])
        local a = {v[2], v[3], v[4], v[5]}
        --print(unpack(a))
        --Make opcodes for rect
        table.insert(final, 'A')
        table.insert(final, a[1])
        table.insert(final, 'B')
        table.insert(final, a[2])
        table.insert(final, 'C')
        table.insert(final, a[3])
        table.insert(final, 'D')
        table.insert(final, a[4])
        table.insert(final, 'S')
        table.insert(final, Pixel.Data.Filled)
        --Find points that are empty
        local t = {}
        for x = a[1], a[3] do
            for y = a[2], a[4] do
                if Pixel.GetPixel(str, x, y) == Pixel.Data.Empty then
                    table.insert(t, {x, y})
                else
                    if str.Data[x] then
                        str.Data[x][y] = nil --Set it to nil to not get it picked up by later compression
                    end
                    if str.Data[x] then
                        local delete = true
                        for k, v in pairs(str.Data[x]) do
                            delete = false
                            break
                        end
                        if delete then
                            str.Data[x] = nil
                        end
                    end
                end
            end
        end
        for i = 1, #t do
            Encode(t[i][1], t[i][2], Pixel.Data.Empty)
        end
    end
    --Encode all other points
    for x, v in pairs(str.Data) do
        for y, v2 in pairs(v) do
            if v2 == Pixel.Data.Filled then
                Encode(x, y, Pixel.Data.Filled)
            end
        end
    end
    --rectangle
    local rectangle = table.concat(final) .. metadata
    --rectangle + lzw
    local rectanglelzw = compress(rectangle)



    local final = nil
    local lengtht = {string, stringlzw, rectangle, rectanglelzw}
    local codes = {'0', '1', '2', '3'}
    for k, v in pairs(lengtht) do print(k, #v )end
    for k, v in spairs(lengtht, function(t, a, b) return #t[a] < #t[b] end) do
        final = codes[k] .. v
        --print(codes[k])
        break
    end





    return final
end

function Pixel.Decompress(str)
    local a = string.sub(str, 1, 1)
    str = string.sub(str, 2, -1)
    local rectmode = false
    if a == '0' then --STRING only
        
    elseif a == '1' then --STRING + LZW
        str = decompress(str)
    elseif a == '2' then --RECT only
        rectmode = true
    elseif a == '3' then --RECT + LZW
        rectmode = true
        str = decompress(str)
    end
    --print(a, str)
    --Find metadata
    local i = #str
    repeat
        if string.sub(str, i, i) == 'M' then
            break
        end
        i = i - 1
        if i <= 0 then
            error('No metadata found')
        end
        --print(i)
    until false
    local metadata = string.sub(str, i + 1, -1)
    str = string.sub(str, 1, i - 1)
    --print(str)
    --[[
    if rectmode == false then
        return Pixel.New(str)
    end
    --]]
    --Main rectangle decompression + 2d works too
    local new = Pixel.New()
    local OPDATA = {}
    local function Execute(op, args)
        --print(op, args)
        if op == 'S' then
            args = tostring(args)
            for i = 1, #args do
                local s = string.sub(args, i, i)
                if OPDATA.A and OPDATA.B and OPDATA.C and OPDATA.D then
                    for x = OPDATA.A, OPDATA.C do
                        for y = OPDATA.B, OPDATA.D do
                            Pixel.SetPixel(new, x, y, s)
                        end
                    end
                    OPDATA.A, OPDATA.B, OPDATA.C, OPDATA.D = nil, nil, nil, nil
                elseif OPDATA.X and OPDATA.Y then
                    if rectmode == false then
                        if s == Pixel.Data.NewLine then
                            OPDATA.Y = OPDATA.Y + 1
                            OPDATA.X = OPDATA.DX
                        else
                            --print('SET', OPDATA.X, OPDATA.Y)
                            Pixel.SetPixel(new, OPDATA.X, OPDATA.Y, s)
                            OPDATA.X = OPDATA.X + 1
                            --OPDATA.X = OPDATA.X + 1
                        end
                    else
                        if s == Pixel.Data.NewLine then
                            OPDATA.X = OPDATA.X + 1
                        else
                            --print('SET', OPDATA.X, OPDATA.Y)
                            Pixel.SetPixel(new, OPDATA.X, OPDATA.Y, s)
                            OPDATA.Y = OPDATA.Y + 1
                            --OPDATA.X = OPDATA.X + 1
                        end
                    end
                else
                    error('Unable to determine opdata set')
                end
            end
        else
            args = tonumber(args)
            OPDATA[op] = args
            if rectmode == false and op == 'X' then
                OPDATA.DX = OPDATA.X
            end
        end
        --[=[
        if type(OPCODES[op]) == number then
            rect[OPCODES[op]] = args
        elseif OPCODES == x then

        elseif OPCODES == y then
            y = args
        end
        --]=]
    end
    local OPCODES = {
        A = true,
        B = true,
        C = true,
        D = true,
        X = true,
        Y = true,
        S = true
    }
    local getarg = false
    local op = ''
    local a = ''
    for i = 1, #str + 1 do
        local s = string.sub(str, i, i)
        if OPCODES[s] or (i == #str + 1) then
            if getarg then
                Execute(op, a)
            end
            getarg = true
            op = s
            a = ''
        else
            if getarg then
                a = a .. s
            else
                error('Invalid opcode: ' .. s .. ', i: ' .. i)
            end
        end
    end
    return new
end



























BenchmarkOn = false
function Pixel.Benchmark()
    if BenchmarkOn then
        local o = os.clock() - BenchmarkOn
        print(o)
    else
        BenchmarkOn = os.clock()
    end
end

BenchmarkFunctionStats = {
    {'', 'Test Length', 'Count', 'Per Second', 'Per Operation'}
}
function Pixel.BenchmarkFunction(func, arg, noinsert)
    if type(arg[1]) == 'table' and arg[1].Data then

    else
        if noinsert then

        else
            table.insert(arg, 1, Pixel.New())
        end
    end
    local f
    if type(func) == 'function' then
        f = func
    elseif type(func) == 'string' then
        f = Pixel[func]
    else
        error('Invalid Function.')
    end
    local b = 5
    local c = 0
    --local str = Pixel.New()
    local a = os.clock()
    repeat
        --f(str, unpack(arg))
        f(unpack(arg))
        c = c + 1
    until a + b <= os.clock()
    local t = {}
    t[1] = tostring(func)
    t[2] = b
    t[3] = c
    t[4] = c / b
    t[5] = b / c
    table.insert(BenchmarkFunctionStats, t)
    --[[
    local out = 'Function: ' .. tostring(func) .. '\nCount: ' .. c .. '\nPer Second: ' .. (c/b) .. '\nPer Operation: ' .. (b/c) .. '\nTest Length: ' .. b
    print(out)
    return out
    --]]
end

function Pixel.BenchmarkFunctionChart()
    local function Chart(t)
        --organized in x, y fashion
        --make rows
        local rows = {}
        for x = 1, #t do
            for y = 1, #t[x] do
                rows[y] = rows[y] or {}
                rows[y][x] = t[x][y]
            end
        end
        --get column index
        local x = {}
        for i = 1, #t do
            table.insert(x, t[i][1])
        end
        --get row index
        local y = {}
        for i = 1, #t[1] do
            table.insert(y, t[1][i])
        end
        --find min distances
        local min = {}
        for i = 1, #t do
            local max = 0
            for i2 = 1, #t[i] do
                local a = #tostring(t[i][i2])
                max = (a > max) and a or max 
            end
            table.insert(min, max + 1)
        end
        local final = {}
        for i = 1, #rows do
            for i2 = 1, #rows[i] do
                local a = tostring(rows[i][i2])
                table.insert(final, a .. string.rep(' ', min[i2] - #a))
            end
            table.insert(final, '\n')
        end
        return table.concat(final)
    end
    local jit = pcall(function()require'jit'end)
    local out = 'Version: ' .. _VERSION .. (jit and ' JIT' or '') .. '\n' .. Chart(BenchmarkFunctionStats) .. '\n'
    print(out)
    return out
    --[[
    print(Chart({
        {'', 'Pixel.Test', 'Pixel.TestFunction'},
        {'Count', '123', '4567'},
        {'Per Second', '1', '33'},
    }))
    --]]
end



return Pixel