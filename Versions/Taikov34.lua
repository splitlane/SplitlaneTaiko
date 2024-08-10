#!.\raylua_s.exe 
--[[
Taikov34.lua


Make into a full simulator

Changes: Taiko.PlaySong improved!
Added Taiko.SongSelect (base, simple)!




TODO: Add raylib option
    Textures.PlaySong
    Rendering
    PlaySong
    SongSelect
    Fix note rendering priority --DONE
    Use gettime instead of os.clock() --ABORT
    Unload Textures.PlaySong + sound later on
    CleanUp
    Don't init audio if not playmusic
    Add Toffset, fix screenrect --DONE
    Use branched barline texture
    Fix drumroll --DONE
    TODO: git rebase HEAD~10 to be consistent on playsong capitalization

    DONE: Sort loaded before rendering:
        Barline first
        Drumroll
        Last -> First notes

    SENOTES
    
    SongSelect Raylib version
    Add keypad to PlaySong Controls
    Use tweening for jposscroll + gradation
    Add balloon, guage, donchan
    Make Resizeall function to reduce code repetition --DONE
    TODO: Draw before / after rendering? --DONE
    TODO: Transition away from loadms and into CalculatePosition + InRectangle --NEVER
    TODO: Sudden
    TODO: Fix Loadms --HALFDONE
    TODO: Fix status for good big --FIXED
    TODO: Fix status calculating for every rendering
    TODO: SongSelect
    TODO: Move Setting mapping to songselect
    Animation system rework: use rect
    TODO: Recording and Replaying --DONE
    Remove requires and integrate libraries --DONE
    TODO: Make a queue for stopms (delay) just like jposscroll --DONE
    TODO: Transition size, sourcerect, center to Textures table --DONE
    TODO: Soul meter, guage, donchan animation, combo sound + combo dialogue, balloon dialogue + counter
    TODO: Fix replay side taiko anim --DONE
    TODO: SENOTES + GAUGE --DONE
    TODO: Find 1p sign --DOESN'T EXIST
    TODO: Score add effect
    TODO: Gauge meter animation (full / overflow) --DONE
    TODO: Text animation (combo, score)
    TODO: Metadata (title, subtitle)
    TODO: SENOTES (Parser + PlaySong) --DONE
    TODO: Localize locals so we don't run out
    TODO: Calculate SENOTES when pushing --DONE
    TODO: Add CalculateLoadMsDrumroll --DONE
    TODO: notehitgauge anim 2
    TODO: skinresolution
    TODO: gogo anims
    TODO: judgement anims (cubicout) --DONE
    TODO: switch to easing functions (transparency, judgement)
    TODO: consistent on good -> ok, great -> good --DONE
    TODO: donchan
    TODO: nameplate
    TODO: look at skinconfig.ini / otherconfig.ini and realign some stuff AUTOMATICALLY (base config on that)
    TODO: move away from optionsmap, implement it in songselect
    TODO: MAJOR REFACTORING
    TODO: prequeue jposscroll and stopms and bpmchange, don't check for every note --DONE
    TODO: fix loadms for bpmchange --DONE
    TODO: have just one SENOTE pr
    TODO: fix drumroll scaling when losing aspect ratio
    TODO: parse box.def
    TODO: parse Config.ini files
    TODO: GIMMICK: sine in scrolls
    TODO: Add errors to PlaySong / SongSelect when invalid tja (popup)
    TODO: Work on pause menu PlaySong --DONE
    TODO: ParseTJA, ParseTJAFile, and SongSelect, handle errors
    TODO: Indenting issues in PlaySong --DONE
    TODO: REVAMP Options Mapping
    TODO: Make Taiko.Game() no arguments --DONE
    TODO: Calculate loadms by doing the jposscrolls --DELAYED
    TODO: Note.CalculatePosition(ms) (custom calculateposition for each note)
    TODO: parse box.def --DONE
    TODO: get texture pos for songselect
    TODO: get position from ini
    TODO: fix retrying while screen is resized
    TODO: CleanUp Raylib function
    TODO: fix note timings (music late, note early)
    TODO: Config Edtor
    TODO: SongSelect Search --DONE
    TODO: Implement score rounding as a function
    TODO: gaugeincr
    TODO: add title, subtitle, genre
    TODO: SerializeTJA
    TODO: songselect difficulty select
    TODO: songselect textures
    TODO: songselect settings (auto, 2x speed, etc)
    TODO: title
    TODO: serializetja jposscroll, bpmchange
    TODO: webvtt
    TODO: LYRICS
    TODO: LYRICS TO WEBVTT
    TODO: REVAMP Parsed so JPOSSCROLL AND BPMCHANGE AND STOPSONG AND LYRIC ARE ALL STORED IN BASE TABLE
    TODO: USE FFI with WFOPEN to open unicode file names?! --DONE
    TODO: Inconsistensies with responsibilities of parsetja and playsong:
        note offset is calced in playsong
        lyric offset is calced in parsetja (required cause webvtt no offset, differentiate)
    TODO: Unicode font, convert rl.DrawText into rl.DrawTextCodepoints
    TODO: REMOVE utf8Decode function repetition, theres like 3 --DONE
    TODO: STOP HARDCODING positions, parse from ini
    TODO: implement 1080p and other resolutions, dont hardcode
        keep in mind that .ini positions are absolute, and are not multiplied by anything
    TODO: SongSelect textures, then INI configs, then resolutions
    TODO: Results
    TODO: Moving Background --DONE, CONFIG DELAYED
    TODO: Fix LoadSongFromMemory
    TODO: Fix opening a/ and then a/b/ and then closing a/ causes the last few items of a/ to remain --DONE
    TODO: Push note attach to currentmeasure instead of setting a parser flag (section, NO: suddenappear?, NO: suddenmove?) --DONE
    TODO: SUDDEN
        how to implement
        
        for each note
            if ms < note.appearancems then
                --hide note
            else
                --show note
            end
            if ms < note.movems then
                --place note into precalculated static position
            else
                --calc position and move it
            end --DONE
    TODO: Rename note.delay to note.delayms?
    TODO: JPOSSCROLL + LOADMS FIX
    TODO: #Section
    TODO: Branches
    TODO: Playsong branches
    TODO: Lyrics
    TODO: SongSelect Difficulties
    TODO: Cursed drumrolls (scrolls using 0) -DONE
    TODO: Serialize barline for SerializeTJA
    TODO: Fix some delay edge case glitchiness with SerializeTJA
    TODO: Print notes, notedata human readable
    TODO: Fix drumrollbend over multiple measures --DONE
    TODO: Fix drumrollbend applying even for normal drumrolls --DONE
    TODO: Fix weird phantom hit (blue L, blue R) when auto
    TODO: Integrate command --DELAYED until command is finished
    TODO: EDITOR
        TODO: Saving (I think diff files)
    TODO: Remove cdata from notes (NOT POSSIBLE SINCE pr is used in editor)
    
    
    TODO: Allow configuring hold for every shortcut
    TODO: Replace time management (rl.GetFrameTime) with something else since its not really accurate (only gets time between begindraw and enddraw, not during input processing) --DONE
    TODO: Add Settings page (modify configs)
    TODO: Allow calibration of offsets (one with only music, one with only notes (visual))
    TODO: Fix pausing (old) --DONE
    TODO: Editor serialize to TJA
    TODO: Editor import tja (easy)
    TODO: Serializetja v3
    TODO: Delay is not added to barline when change????? --DONE
    TODO: Improve precision of SerializeTJA
    TODO: move defaultcalibrate and defaultconfig and defaults to default folder
    TODO: raygui
    TODO: RayGuiDifficulty
    TODO: jposscroll editor
    hbscroll / bmscroll editor
    gimmick editor
    properties inspector
    USE DIALOGS NOT FULL SCREEN
    TODO: review and fix calibrate bs
    

    FOR ESE GIT: git commit -a
    git push -u https://ese.tjadataba.se/mc08/ESE.git
    TODO: Fix complex scroll no number was found with "1-i" or "i"
    TODO: Fix charts without songs crashing
    











TODO: Taiko.Game
TODO: Taiko.SongSelect
TODO: Focus on Playability
TODO: Improve Auto


TODO: Refactor Code
    Case Consistency
    Optimize Parser

TODO: Check for match[2] so no error
TODO: Note lyrics
TODO: Docs
TODO: Use io.write instead of print in PlaySong
TODO: Fix serializetja
TODO: Fix taikocurses unicode support


TODO: Song select screen
    Results
    Scroll Animation

TODO: Lyrics

TODO: PlaySong
    Display
    2P SUPPORT!




Objectives:
O: Parse TJA
NEVER: Play frame
O: Play entire song

Tags: --WIP, --FIX, --TODO, --PERFORMANCE

TODO:
modes
scoreinit



How resizing works:
5 wide
1 speed

X = goal / outline, O = note
X   0
X  0
X 0
X0
0



Notes on curses:
getch always doesn't display screen on first run











]]







--[[
How to run on powershell

cd C:\Users\User\OneDrive\code\Taiko\Versions\
lua C:\Users\User\OneDrive\code\Taiko\Versions\Taikov4.lua
]]







--Optimized Pixels
--local OptimizedPixel = nil --Will be generated later





--Requires

--curses + pixels
--[[
local curses = require('taikocurses') --required later on
local Compact = require('./CompactTJA/compact')
--]]



--raylib
--[[
local Compact = require('CompactTJA/compact')
local Replay = require('ReplayTaiko/replayv1')
local Persistent = require('Persistent/persistentv1')
--]]
















-- require'strict'
do
--[[
    strict.lua
    
    detect global definitions and log them to catch errors
]]




local on = false





if on then
    setmetatable(_G, {
        __index = function(t, k)
            print(t, k)
            print(debug.traceback())
            error()
        end,
        __newindex = function(t, k, v)
            rawset(t, k, v)
            print(t, k, v)
        end
    })
end
end























--Unicode Manipulation
--[[
    https://github.com/cyisfor/lua_utf8/blob/master/utf8.lua
    Modified
    + optimized to avoid string concat
]]
--utf8

local function utf8longEncode(codepoint)
    local chars = ""
    local trailers = 0
    --local ocodepoint = codepoint

    -- feckin backwards compatability
    if codepoint < 0x80 then return string.char(codepoint) end

    local topspace = 0x20 -- we lose a bit of space left on the top every time

    -- even if the codepoint is <0x40 and will fit inside 10xxxxxx, 
    -- we add a 11100000  byte in front, because it won't fit inside
    -- 0x20 xxxxx so we need a blank top and an extra continuation.
    -- example: 0x90b
    -- bit.rshift(0x90b,6) => 0x24
    -- 0x24 = 00100100
    -- top =  11100000
    --          ^ oh noes info lost
    -- thus we do:
    --        11100000 - 10100100 - ...
    --
    while codepoint > topspace do -- as long as there's too much for the top
        local derp = bit.bor(bit.band(codepoint,0x3F),0x80)
        chars = string.char(derp) .. chars
        codepoint = bit.rshift(codepoint,6)
        trailers = trailers + 1
        topspace = bit.rshift(topspace,1)
    end

    -- is there a better way to make 0xFFFF0000 from 4 than lshift/rshift?
    local mask = bit.lshift(bit.rshift(0xFF,7-trailers),7-trailers)

    local last = bit.bor(mask,codepoint)
    return string.char(last) .. chars
end

local function utf8Encode(t,derp,...)
    if derp ~= nil then
        t = {t,derp,...}
    end
    local s = {}
    for i, codepoint in ipairs(t) do
        -- manually doing the common codepoints to avoid calling logarithm
        if codepoint < 0x80 then
            s[#s + 1] = string.char(codepoint)
        elseif codepoint < 0x800 then
            s[#s + 1] = string.char(bit.bor(bit.rshift(codepoint,6),0xc0))
            s[#s + 1] = string.char(bit.bor(bit.band(codepoint,0x3F),0x80))   
        elseif codepoint < 0x10000 then
            s[#s + 1] = string.char(bit.bor(bit.rshift(codepoint,12),0xe0))
            s[#s + 1] = string.char(bit.bor(bit.band(bit.rshift(codepoint,6),0x3F),0x80))
            s[#s + 1] = string.char(bit.bor(bit.band(codepoint,0x3F),0x80))
        elseif codepoint < 0x200000 then
            s[#s + 1] = string.char(bit.bor(bit.rshift(codepoint,18),0xf0))
            s[#s + 1] = string.char(bit.bor(bit.band(bit.rshift(codepoint,12),0x3F),0x80))
            s[#s + 1] = string.char(bit.bor(bit.band(bit.rshift(codepoint,6),0x3F),0x80))
            s[#s + 1] = string.char(bit.bor(bit.band(codepoint,0x3F),0x80))
        else
            -- alpha centauri?!
            s[#s + 1] = utf8longEncode(codepoint)
        end
    end
    return table.concat(s)
end

local function utf8Decode(s)
    local res, seq, val = {}, 0, nil
    for i = 1, #s do
        local c = string.byte(s, i)
        if seq == 0 then
            table.insert(res, val)
            seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6 or
                error("invalid UTF-8 character sequence")
            val = bit.band(c, 2^(8-seq) - 1)
        else
            val = bit.bor(bit.lshift(val, 6), bit.band(c, 0x3F))
        end
        seq = seq - 1
    end
    table.insert(res, val)
    --table.insert(res, 0)
    return res
end

--[[
    --https://github.com/LuaLS/lua-language-server/blob/master/script/encoder/utf16.lua
    modified to work in lua 5.1
]]
--utf16

local function utf16be_tochar(code)
    return string.char(bit.band(bit.rshift(code, 8), 0xFF), bit.band(code, 0xFF))
end
local function utf16le_tochar(code)
    return string.char(bit.band(code, 0xFF), bit.band(bit.rshift(code, 8), 0xFF))
end

local function utf16char(tochar, code)
    if code < 0x10000 then
        return tochar(code)
    else
        code = code - 0x10000
        return tochar(0xD800 + bit.rshift(code, 10))..tochar(0xDC00 + bit.band(code, 0x3FF))
    end
end

local function utf16Encode(t)
    --USES LE
    local out = {
        '\255\254' --header? bom?
    }
    for i = 1, #t do
        out[#out + 1] = utf16char(utf16le_tochar, t[i])
    end
    return table.concat(out)
end








































do
    --[[
        opening and reading unicode files or any file

        https://stackoverflow.com/questions/30585574/write-to-file-using-lua-ffi
        https://stackoverflow.com/a/14002993
        https://gist.github.com/akopytov/12ef537ac75c65804d8f4ce47fcf3eed

        Just treat like any other file handle

        WARNING: UNICODEFILENAME IS INTEGRATED INTO TAIKOV33
    ]]

    local ffi = require'ffi'

    ffi.cdef[[
    typedef struct {
    char *fpos;
    void *base;
    unsigned short handle;
    short flags;
    short unget;
    unsigned long alloc;
    unsigned short buffincrement;
    } FILE;

    FILE *fopen(const char *filename, const char *mode);
    int fclose(FILE *stream);


    void *malloc(int64_t);
    void free(void *);

    int fseek(FILE *stream, long int offset, int whence);
    long int ftell(FILE *stream);

    size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
    size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

    ]]


    --fuck windows (paths are utf16)
    local windows = ffi.os == 'Windows'
    local codepointstostring
    --local wmode
    if windows then
        --https://github.com/taocpp/PEGTL/issues/78
        --https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfilesizeex?redirectedfrom=MSDN
        ffi.cdef[[
        FILE *_wfopen(const wchar_t *filename, const wchar_t *mode);
        ]]
        --[[
        size_t strlen(const char *str);
        size_t mbstowcs(wchar_t* dst, const char* src, size_t len);
        ]]

        --[[
        chartowstring = function(char)
            --local char = ffi.cast('char *', lchar)
            --https://stackoverflow.com/a/5503864
            local size = ffi.C.strlen(char) + 1
            local wchar = ffi.new('wchar_t[?]', size)
            ffi.C.mbstowcs(wchar, char, size)
            return wchar
        end
        --]]

        --[[
        getfilesize = function(f)
            local n = ffi.new('LARGE_INTEGER *')
            ffi.C.GetFileSizeEx(f, n)
            return n
        end
        --]]

        codepointstostring = function(t)
            local size = #t + 1
            local wchar = ffi.new('wchar_t[?]', size)
            for i = 1, #t do
                wchar[i - 1] = t[i]
            end
            wchar[#t] = 0
            return wchar
        end
        
        --rb
        --wmode = codepointstostring({string.byte('r'), string.byte('b')})
    end



    --[[
    local function utf8Decode(s)
        local res, seq, val = {}, 0, nil
        for i = 1, #s do
            local c = string.byte(s, i)
            if seq == 0 then
                table.insert(res, val)
                seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                    c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6 or
                    error("invalid UTF-8 character sequence")
                val = bit.band(c, 2^(8-seq) - 1)
            else
                val = bit.bor(bit.lshift(val, 6), bit.band(c, 0x3F))
            end
            seq = seq - 1
        end
        table.insert(res, val)
        --table.insert(res, 0)
        return res
    end
    --]]



    --io. drop in replacement

    --MAIN!
    local wio = {}

    local ioopen = io.open
    function wio.open(path, mode)
        --patht should be like char *, it should be an array of codepoints
        local patht = utf8Decode(path)


        --Check if there is any unicode character in filename
        local unicode = false
        for i = 1, #patht do
            if patht[i] > 255 then
                unicode = true
                break
            end
        end
        if unicode == false then
            return ioopen(path, mode)
        end


        --https://stackoverflow.com/questions/30585574/write-to-file-using-lua-ffi
        local f
        if windows then
            --https://github.com/taocpp/PEGTL/issues/78
            --local wmode = chartowstring('rb')
            local wpath = codepointstostring(patht)
            local wmode = codepointstostring(utf8Decode(mode))
            f = ffi.C._wfopen(wpath, wmode)
        else
            
            --https://stackoverflow.com/a/33485288
            --[[
            local path = ffi.new("char[?]", #patht + 1)
            for i = 1, #patht do
                path[i - 1] = patht[i]
            end
            path[#patht] = 0
            --]]

            f = ffi.C.fopen(path, mode)
        end



        --Check if file is null
        if f == nil then
            return nil
        end




        --Return file data object
        return setmetatable({
            file = f
        }, {__index = wio})
    end



    function wio.read(file, mode)
        --WARNING: Doesn't support mode yet, just read all
        if string.sub(mode, 1, 2) ~= '*a' then
            error('File.read: Does not support mode')
        end



        --Get file size

        --https://stackoverflow.com/a/14002993
        --[[
        --https://support.sas.com/documentation/onlinedoc/ccompiler/doc700/html/lr1/z2031150.htm
        SEEK_SET	is the beginning of the file; the value is 0.
        SEEK_CUR	is the current file offset; the value is 1.
        SEEK_END	is the end of the file; the value is 2.
        ]]

        --Get file size
        local f = file.file

        ffi.C.fseek(f, 0, 2)
        local fsize = ffi.C.ftell(f)
        ffi.C.fseek(f, 0, 0)  -- same as rewind(f);

        
        if fsize ~= -1 then
            --char *string = malloc(fsize + 1);
            local str = ffi.cast('char *', ffi.C.malloc(fsize + 1))
            ffi.C.fread(str, fsize, 1, f)
            --ffi.C.fclose(f)
            str[fsize] = 0;

            local lstr = ffi.string(str, fsize)
            ffi.C.free(str)

            return lstr
        else
            error('File error')
        end
    end



    function wio.write(file, data)

        local f = file.file

        --[[
        local size = ffi.new('size_t', #data)
        local size2 = ffi.new('size_t', 1)
        --]]


        ffi.C.fwrite(data, #data, 1, f)
    end



    function wio.close(file)
        local f = file.file

        ffi.C.fclose(f)
    end








    --Modify io. table
    --[[
    for k, v in pairs(wio) do
        io[k] = v
    end
    --]]


    --Actually, only modify io.open
    io.open = wio.open



















end










do

    --[[
        A combined version of compactv4 and search
    ]]



    --[[
    compactv4.lua

    Goal:
    translate into tja and back
    store a ton of tjas

    .tjac file


    Changes:
    Don't compress titles

    WARNING:
    Byte order mark causes stuff

    Use wb+ to write, rb to read
    ]]




    local escapechar = '\\'

    local seperatorchar = '\\'







    --[[
        https://github.com/swarn/fzy-lua/blob/main/src/fzy_lua.lua

        might use Commandv5.lua
    ]]








    -- The lua implementation of the fzy string matching algorithm

    local SCORE_GAP_LEADING = -0.005
    local SCORE_GAP_TRAILING = -0.005
    local SCORE_GAP_INNER = -0.01
    local SCORE_MATCH_CONSECUTIVE = 1.0
    local SCORE_MATCH_SLASH = 0.9
    local SCORE_MATCH_WORD = 0.8
    local SCORE_MATCH_CAPITAL = 0.7
    local SCORE_MATCH_DOT = 0.6
    local SCORE_MAX = math.huge
    local SCORE_MIN = -math.huge
    local MATCH_MAX_LENGTH = 1024

    local fzy = {}

    -- Check if `needle` is a subsequence of the `haystack`.
    --
    -- Usually called before `score` or `positions`.
    --
    -- Args:
    --   needle (string)
    --   haystack (string)
    --   case_sensitive (bool, optional): defaults to false
    --
    -- Returns:
    --   bool
    function fzy.has_match(needle, haystack, case_sensitive)
    if not case_sensitive then
        needle = string.lower(needle)
        haystack = string.lower(haystack)
    end

    local j = 1
    for i = 1, string.len(needle) do
        j = string.find(haystack, needle:sub(i, i), j, true)
        if not j then
        return false
        else
        j = j + 1
        end
    end

    return true
    end

    local function is_lower(c)
    return c:match("%l")
    end

    local function is_upper(c)
    return c:match("%u")
    end

    local function precompute_bonus(haystack)
    local match_bonus = {}

    local last_char = "/"
    for i = 1, string.len(haystack) do
        local this_char = haystack:sub(i, i)
        if last_char == "/" or last_char == "\\" then
        match_bonus[i] = SCORE_MATCH_SLASH
        elseif last_char == "-" or last_char == "_" or last_char == " " then
        match_bonus[i] = SCORE_MATCH_WORD
        elseif last_char == "." then
        match_bonus[i] = SCORE_MATCH_DOT
        elseif is_lower(last_char) and is_upper(this_char) then
        match_bonus[i] = SCORE_MATCH_CAPITAL
        else
        match_bonus[i] = 0
        end

        last_char = this_char
    end

    return match_bonus
    end

    local function compute(needle, haystack, D, M, case_sensitive)
    -- Note that the match bonuses must be computed before the arguments are
    -- converted to lowercase, since there are bonuses for camelCase.
    local match_bonus = precompute_bonus(haystack)
    local n = string.len(needle)
    local m = string.len(haystack)

    if not case_sensitive then
        needle = string.lower(needle)
        haystack = string.lower(haystack)
    end

    -- Because lua only grants access to chars through substring extraction,
    -- get all the characters from the haystack once now, to reuse below.
    local haystack_chars = {}
    for i = 1, m do
        haystack_chars[i] = haystack:sub(i, i)
    end

    for i = 1, n do
        D[i] = {}
        M[i] = {}

        local prev_score = SCORE_MIN
        local gap_score = i == n and SCORE_GAP_TRAILING or SCORE_GAP_INNER
        local needle_char = needle:sub(i, i)

        for j = 1, m do
        if needle_char == haystack_chars[j] then
            local score = SCORE_MIN
            if i == 1 then
            score = ((j - 1) * SCORE_GAP_LEADING) + match_bonus[j]
            elseif j > 1 then
            local a = M[i - 1][j - 1] + match_bonus[j]
            local b = D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE
            score = math.max(a, b)
            end
            D[i][j] = score
            prev_score = math.max(score, prev_score + gap_score)
            M[i][j] = prev_score
        else
            D[i][j] = SCORE_MIN
            prev_score = prev_score + gap_score
            M[i][j] = prev_score
        end
        end
    end
    end

    -- Compute a matching score.
    --
    -- Args:
    --   needle (string): must be a subequence of `haystack`, or the result is
    --     undefined.
    --   haystack (string)
    --   case_sensitive (bool, optional): defaults to false
    --
    -- Returns:
    --   number: higher scores indicate better matches. See also `get_score_min`
    --     and `get_score_max`.
    function fzy.score(needle, haystack, case_sensitive)
    local n = string.len(needle)
    local m = string.len(haystack)

    if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > m then
        return SCORE_MIN
    --elseif n == m then
    elseif needle == haystack then
        return SCORE_MAX
    else
        local D = {}
        local M = {}
        compute(needle, haystack, D, M, case_sensitive)
        return M[n][m]
    end
    end

    -- Compute the locations where fzy matches a string.
    --
    -- Determine where each character of the `needle` is matched to the `haystack`
    -- in the optimal match.
    --
    -- Args:
    --   needle (string): must be a subequence of `haystack`, or the result is
    --     undefined.
    --   haystack (string)
    --   case_sensitive (bool, optional): defaults to false
    --
    -- Returns:
    --   {int,...}: indices, where `indices[n]` is the location of the `n`th
    --     character of `needle` in `haystack`.
    --   number: the same matching score returned by `score`
    function fzy.positions(needle, haystack, case_sensitive)
    local n = string.len(needle)
    local m = string.len(haystack)

    if n == 0 or m == 0 or m > MATCH_MAX_LENGTH or n > m then
        return {}, SCORE_MIN
    elseif n == m then
        local consecutive = {}
        for i = 1, n do
        consecutive[i] = i
        end
        return consecutive, SCORE_MAX
    end

    local D = {}
    local M = {}
    compute(needle, haystack, D, M, case_sensitive)

    local positions = {}
    local match_required = false
    local j = m
    for i = n, 1, -1 do
        while j >= 1 do
        if D[i][j] ~= SCORE_MIN and (match_required or D[i][j] == M[i][j]) then
            match_required = (i ~= 1) and (j ~= 1) and (
            M[i][j] == D[i - 1][j - 1] + SCORE_MATCH_CONSECUTIVE)
            positions[i] = j
            j = j - 1
            break
        else
            j = j - 1
        end
        end
    end

    return positions, M[n][m]
    end

    -- Apply `has_match` and `positions` to an array of haystacks.
    --
    -- Args:
    --   needle (string)
    --   haystack ({string, ...})
    --   case_sensitive (bool, optional): defaults to false
    --
    -- Returns:
    --   {{idx, positions, score}, ...}: an array with one entry per matching line
    --     in `haystacks`, each entry giving the index of the line in `haystacks`
    --     as well as the equivalent to the return value of `positions` for that
    --     line.
    function fzy.filter(needle, haystacks, case_sensitive)
    local result = {}

    for i, line in ipairs(haystacks) do
        if fzy.has_match(needle, line, case_sensitive) then
        local p, s = fzy.positions(needle, line, case_sensitive)
        table.insert(result, {i, p, s})
        end
    end

    return result
    end

    -- The lowest value returned by `score`.
    --
    -- In two special cases:
    --  - an empty `needle`, or
    --  - a `needle` or `haystack` larger than than `get_max_length`,
    -- the `score` function will return this exact value, which can be used as a
    -- sentinel. This is the lowest possible score.
    function fzy.get_score_min()
    return SCORE_MIN
    end

    -- The score returned for exact matches. This is the highest possible score.
    function fzy.get_score_max()
    return SCORE_MAX
    end

    -- The maximum size for which `fzy` will evaluate scores.
    function fzy.get_max_length()
    return MATCH_MAX_LENGTH
    end

    -- The minimum score returned for normal matches.
    --
    -- For matches that don't return `get_score_min`, their score will be greater
    -- than than this value.
    function fzy.get_score_floor()
    return MATCH_MAX_LENGTH * SCORE_GAP_INNER
    end

    -- The maximum score for non-exact matches.
    --
    -- For matches that don't return `get_score_max`, their score will be less than
    -- this value.
    function fzy.get_score_ceiling()
    return MATCH_MAX_LENGTH * SCORE_MATCH_CONSECUTIVE
    end

    -- The name of the currently-running implmenetation, "lua" or "native".
    function fzy.get_implementation_name()
    return "lua"
    end

    --return fzy

    -- [[
    local search = function(t, str)
        return fzy.score(str, t) --Bigger = better
    end
    --]]






















    local function Escape(str, sep)
        return string.gsub(string.gsub(str, escapechar, escapechar .. escapechar), sep, escapechar .. sep)
    end

    local function UnEscape(str, sep)
        return string.gsub(string.gsub(str, escapechar .. sep, sep), escapechar .. escapechar, escapechar)
    end

    local function SplitCustom(str, sep, escape)
        local t = {}
        local current = ''
        for c, d in string.gmatch(str, '([^' .. sep .. ']*)(' .. sep .. '?)') do
            local a, b = string.sub(c, -2, -2), string.sub(c, -1, -1)
            --print(a, b, c, d)
            local push = true
            if a == escape then
                if b == escape then
                    --Push
                else
                    --Push
                end
            else
                if b == escape then
                    --Add to current
                    --print('S', a, b, c, d)
                    current = current .. string.sub(c, 1, -2) .. d
                    push = false
                else
                    --Push
                end
            end
            if push then
                current = current .. c
                t[#t + 1] = current
                current = ''
            end
                
            if d == '' then
                return t
            end
        end
        --Just in case
        return error(unpack(t))
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





    --CUSTOM
    --SplitCustom=function(a,b,escape)local c={}for z,d,b in a:gmatch("(.)([^"..b.."]*)("..b.."?)")do if z~=escape then c[#c + 1]=z..d end if b==''then return c end end end

    local function StripBOM(str)
        --https://en.wikipedia.org/wiki/Byte_order_mark#Byte_order_marks_by_encoding

        --Everything should be utf8, so dont care about utf16
        if string.sub(str, 1, 3) == '\239\187\191' then
            return string.sub(str, 4, -1)
        else
            return str
        end


        --[[
        local bomchars = {
            ['\239'] = true,
            ['\187'] = true
        }
        i = 0
        repeat
            i = i + 1
        until not bomchars[string.sub(str, i, i)]
        return string.sub(str, i, -1)
        --]]
    end






    local headerchar = '\n'
    local headersepchar = ','
    --local searchcase = true --case sensitive: true = not matter

    local function EncodeHeader(t)
        local titles = {}
        for i = 1, #t do
            print(string.match(t[i], '\nTITLE:(.-)\n'))


            local title = string.match(t[i], 'TITLE:(.-)\n') or string.match(t[i], 'TITLE:(.-)\r')
            if not title then
                print'input title'
                title = io.read()
            end


            titles[#titles + 1] = Escape(title, headersepchar)
        end


        
        return table.concat(titles, headersepchar) .. headerchar


    end
    local function DecodeHeader(str)
        local e = string.find(str, headerchar)
        local header = SplitCustom(string.sub(str, 1, e - 1), headersepchar, escapechar)
        for i = 1, #header do
            header[i] = UnEscape(header[i], headersepchar)
        end
        return header, string.sub(str, e + 1, -1)
    end
    local function SearchHeaderAll(header, str)
        local t = {}
        for i = 1, #header do
            --print(header[i])
            t[i] = {i, search(header[i], str), header[i]}
        end

        table.sort(t, function(a, b)
            return a[2] > b[2]
        end)
        return t
    end
    local function SearchHeader(header, str)
        local t = SearchHeaderAll(header, str)
        --[[
        local t = {}
        for i = 1, #header do
            --print(header[i])
            t[i] = {i, search(header[i], str), header[i]}
        end

        table.sort(t, function(a, b)
            return a[2] > b[2]
        end)
        --]]

        --[[
        for i = 1, #t do
            print(str, unpack(t[i]))
        end;error()
        --]]

        --print(unpack(t[1]))

        return t[1][1]

        --old search
        --[[
        if searchcase then
            str = string.lower(str)
        end
        for i = 1, #header do
            if (searchcase and string.lower(header[i]) or header[i]) == string.sub(str, 1, #header[i]) then
                return i
            end
        end
        --]]
    end









    Compact = {}



    function Compact.Read(file)
        local f = io.open(file, 'rb')
        local s = f:read('*all')
        f:close()
        return s
    end

    function Compact.Write(file, str)
        local f = io.open(file, 'wb+')
        f:write(str)
        f:close()
    end

    function Compact.Compress(t) --t is table of files
        --escape
        for i = 1, #t do
            t[i] = Escape(StripBOM(t[i]), seperatorchar)
        end
        local str = table.concat(t, seperatorchar)

        local c = compress(str)
        
        c = EncodeHeader(t) .. c

        --Stats
        print('Before chars: ' .. #str .. '\nAfter Chars:' .. #c .. '\nAfter/Before: ' .. (#c / #str) .. '\nCompression Rate: ' .. (#str / #c) .. 'x')

        return c
    end

    function Compact.Decompress(str)
        --Remove header first
        local header, str = DecodeHeader(str)
        
        local d = decompress(str)

        --StripBOM
        --nvm already stripped earlier

        local t = SplitCustom(d, seperatorchar, escapechar)

        return t, header
    end





    --Utils

    function Compact.ListFiles(header)
        local t = {}
        for i = 1, #header do
            t[#t + 1] = header[i]
        end
        table.sort(t)
        return table.concat(t, '\n')
    end

    function Compact.Search(t, header, search)
        local a = SearchHeader(header, search)
        if a then
            return t[a]
        else
            return nil
        end
    end

    function Compact.Input(str)
        local d, header = Compact.Decompress(str)
        print(Compact.ListFiles(header))
        print('Song Name:')
        local input = io.read()
        local s = Compact.Search(d, header, input)
        if s then
            return s
        else
            error('Invalid input')
        end
    end

    function Compact.InputFile(file)
        return Compact.Input(Compact.Read(file))
    end



    function Compact.Merge(t) --t is a table of files (compressed)
        local t2 = {}
        for i = 1, #t do
            local a = Compact.Decompress(t[i])
            for i = 1, #a do
                t2[#t2 + 1] = a[i]
            end
        end
        return Compact.Compress(t2)
    end

    function Compact.CompressDir(path, base)
        --https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
        -- Lua implementation of PHP scandir function
        local function scandir(directory)
            local i, t, popen = 0, {}, io.popen
            local pfile = popen('dir "'..directory..'" /b')
            for filename in pfile:lines() do
                i = i + 1
                t[i] = filename
            end
            pfile:close()
            return t
        end

        local dir = path
        local t = scandir(dir)
        local exclude = {
            --['1 (1347).tja'] = true --Mirai, UTF-16 le + lf
        }

        local str = {}
        for i = 1, #t do
            local file = t[i]
            local scan = scandir(dir .. '\\' .. file)
            --print(dir .. '\\' .. file, scan)
            --print(dir .. '\\' .. file, '1', scan, scan[1], #scan)
            if #scan ~= 0 and scan[1] ~= file then
                --folder
                local temp = Compact.CompressDir(dir .. '\\' .. file, true)
                for i = 1, #temp do
                    str[#str + 1] = temp[i]
                end
            elseif (not exclude[file]) and string.sub(file, -3, -1) == 'tja' then
                --print'tja'
                --.tja
                print(file)
                --print(file)
                str[#str + 1] = dir .. '\\'.. file
                --str[#str + 1] = (io.open(dir .. '\\'.. file,'r'):read('*all'))
            else

            end
            --[[
            if string.find(file, '%.') == nil then
                --folder
                local temp = Compact.CompressDir(dir .. '\\' .. file, true)
                for i = 1, #temp do
                    str[#str + 1] = temp[i]
                end
            elseif (not exclude[file]) and string.sub(file, -3, -1) == 'tja' then
                --.tja
                print(file)

                str[#str + 1] = dir .. '\\'.. file
                --str[#str + 1] = (io.open(dir .. '\\'.. file,'r'):read('*all'))
            else
                --print('ERROR' , file)
            end
            --]]
        end
        if base then
            return str
        else
            --print(#str)
            for i = 1, #str do
                --print(str[i])
                --print(str[i])
                local f = io.open(str[i], 'r')
                --print(str[i])
                str[i] = f:read('*all')
                --print(str[i]:sub(1, 20))
                f:close()
            end
            return Compact.Compress(str)
        end
    end



    --Utils

    Compact.SearchHeader = SearchHeader
    Compact.SearchHeaderAll = SearchHeaderAll
    Compact.Search = search --Export for use with SongSelect




    --[[

    return Compact

    --]]
end

















































do
    --[[
    replayv1.lua

    Goal:
    store TAIKO replay files efficiently


    Changes:


    WARNING:
    Byte order mark causes stuff

    Use wb+ to write, rb to read





    Format:

    .trp file

    1 = don
    2 = ka

    ]]

    Replay = {}
    Replay.Version = 'beta-2'
    Replay.Notes = {
        --Not internally used by replay, but by taiko

        --Compatible with 'beta-1' and above
        ['1'] = {1, false},
        ['2'] = {2, false},
        ['3'] = {1, true},
        ['4'] = {2, true},
    }











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



















    function Replay.Read(file)
        local f = io.open(file, 'rb')
        local s = f:read('*all')
        f:close()
        return s
    end

    function Replay.Write(file, str)
        local f = io.open(file, 'wb+')
        f:write(str)
        f:close()
    end



    function Replay.TranscodeRaw(raw)
        --[[
            raw file just concats key with ms, so basically no table creation
            DEPRACATED
        ]]
        local out = {}
        for k, v in pairs(raw) do
            local split = string.find(k, ' ')
            out[tonumber(string.sub(k, 1, split - 1))] = tonumber(string.sub(k, split + 1, -1))
        end
        return out
    end

    function Replay.TranscodeRawKey(raw)
        --[[
            every key has table creation, but ms is just put in
        ]]
        local out = {}
        for k, v in pairs(raw) do
            for i = 1, #v do
                local ms = v[i]
                out[ms] = out[ms] and out[ms] or {}
                out[ms][#out[ms] + 1] = k
            end
        end
        return out
    end

    function Replay.Save(t, m)
        local out = {}
        --Calculate metadata
        local i, min, max = 0
        for k, v in pairs(t) do
            min = (not min or k < min) and k or min
            max = (not max or k > max) and k or max
            i = i + 1
        end
        
        --Write metadata
        --[[
            possible:
            date
        ]]
        out = {
            'version ', Replay.Version,
            '\ntotalms ', tostring(max - min),
            '\nactivecount ', tostring(i)
        }

        --Add incoming metadata
        m = m or {}
        for i = 1, #m do
            out[#out + 1] = m[i]
        end

        out[#out + 1] = '\ndata '

        --Don't care about order
        local data = {}
        for k, v in pairs(t) do
            data[#data + 1] = tostring(k)
            data[#data + 1] = ' '
            data[#data + 1] = table.concat(v) --ASSUMES KEYS ARE 1 LONG
            data[#data + 1] = '\n'
        end
        out[#out + 1] = compress(table.concat(data))


        return table.concat(out)
    end

    function Replay.Load(str)
        --Extract metadata
        local finddata, finddata2 = string.find(str, 'data ')
        local metadata = string.sub(str, 1, finddata - 1)
        local mt = {}
        string.gsub(metadata, '(.-) (.-)\n', function(k, v)
            mt[k] = v
        end)


        local data = string.sub(str, finddata2 + 1, -1)
        local d = decompress(data)

        local out = {}

        local i = 1
        while true do
            local s, e = string.find(d, '\n', i)
            if not s then
                break
            end

            local line = string.sub(d, i, s - 1)
            i = e + 1
            local split = string.find(line, ' ')
            local ms = string.sub(line, 1, split - 1)
            local keys = string.sub(line, split + 1, -1)
            local t = {}
            for i2 = 1, #keys do
                t[#t + 1] = string.sub(keys, i2, i2)
            end
            out[tonumber(ms)] = t
        end
        return out, mt --metadata?
    end

    --return Replay
end




























































do
    --[[
        FileDialog.lua

        Wrapper for tinyfiledialogs
    ]]

    local ffi = require('ffi')


    --[[
        Use tinyfiledialogs64 for raylib
        Use tinyfiledialogs32 for luajit
    ]]
    local FileDialogC = ffi.load('tinyfiledialogs64')

    --https://stackoverflow.com/questions/53805913/how-to-define-c-functions-with-luajit
    --REMEMBER TO DEFINE NEEDED FUNCTIONS (tinyfiledialogs.h)
    ffi.cdef[[
    char * tinyfd_openFileDialog(
        char const * aTitle, /* NULL or "" */
        char const * aDefaultPathAndFile, /* NULL or "" */
        int aNumOfFilterPatterns , /* 0 (2 in the following example) */
        char const * const * aFilterPatterns, /* NULL or char const * lFilterPatterns[2]={"*.png","*.jpg"}; */
        char const * aSingleFilterDescription, /* NULL or "image files" */
        int aAllowMultipleSelects ) ; /* 0 or 1 */
            /* in case of multiple files, the separator is | */
            /* returns NULL on cancel */

    char * tinyfd_selectFolderDialog(
        char const * aTitle, /* NULL or "" */
        char const * aDefaultPath); /* NULL or "" */
            /* returns NULL on cancel */

    char const * tinyfd_saveFileDialog(
        char const * aTitle , // NULL or ""
        char const * aDefaultPathAndFile , // NULL or ""
        int aNumOfFilterPatterns , // 0 (1 in the following example)
        char const * const * aFilterPatterns , // NULL or char const * lFilterPatterns[1]={"*.txt"};
        char const * aSingleFilterDescription ); // NULL or "text files"
            // returns NULL on cancel
    ]]








    FileDialog = {}




    function FileDialog.Open(title, defaultpath, filter, filterdescription, allowmultipleselects)
        --Defaults
        title = title or ''
        defaultpath = defaultpath or ''
        local filterlength = filter and #filter or 0
        local filterpattern = nil
        if filter then
            -- [[
            filterpattern = ffi.new('const char * [?]', filterlength)
            for i = 1, #filter do
                filterpattern[i - 1] = ffi.new('char [?]', #filter[i] + 1, filter[i])
            end
            --]]
        end
        local multipleselects = allowmultipleselects and 1 or 0

        local out = FileDialogC.tinyfd_openFileDialog(title, defaultpath, filterlength, filterpattern, filterdescription, multipleselects)
        if out == nil then
            --Cancel

            return nil
        else
            --Return

            return ffi.string(out)
        end
    end


    function FileDialog.OpenFolder(title, defaultpath)
        --Defaults
        title = title or ''
        defaultpath = defaultpath or ''

        
        local out = FileDialogC.tinyfd_selectFolderDialog(title, defaultpath)
        if out == nil then
            --Cancel

            return nil
        else
            --Return

            return ffi.string(out)
        end
    end


    function FileDialog.Save(title, defaultpath, filter, filterdescription)
        --Defaults
        title = title or ''
        defaultpath = defaultpath or ''
        local filterlength = filter and #filter or 0
        local filterpattern = nil
        if filter then
            -- [[
            filterpattern = ffi.new('const char * [?]', filterlength)
            for i = 1, #filter do
                filterpattern[i - 1] = ffi.new('char [?]', #filter[i] + 1, filter[i])
            end
            --]]
        end

        local out = FileDialogC.tinyfd_saveFileDialog(title, defaultpath, filterlength, filterpattern, filterdescription)
        if out == nil then
            --Cancel

            return nil
        else
            --Return

            return ffi.string(out)
        end
    end







    --Full handling
    function FileDialog.LoadFile(...)
        local out = FileDialog.Open(...)
        if out then
            local f = io.open(out, 'rb')
            local str = f:read('*all')
            f:close()
            return str
        else
            return nil
        end
    end

    function FileDialog.SaveFile(...)
        local out = FileDialog.Save(...)
        if out then
            local f = io.open(out, 'wb+')
            f:write()
            f:close()
            return true
        else
            return nil
        end
    end


end






















































































do
    --[[
    persistentv2.lua

    ADDED COMMENTS, and comment stripper. Parser is the same (except 1 line, added acceptiongkeys to equalsparse)

    Goal:
    save scores (numbers) and strings elegantly and compactly

    maybe lzw?



    Look at:
    https://github.com/Dynodzzo/Lua_INI_Parser/blob/master/LIP.lua


    file format:
    tpd (taiko persistent data)
    (pcd)
    ]]











    Persistent = {}







    function Persistent.Read(file)
        local f = io.open(file, 'rb')
        local s = f:read('*all')
        f:close()
        return s
    end

    function Persistent.Write(file, str)
        local f = io.open(file, 'wb+')
        f:write(str)
        f:close()
    end




    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

    function Persistent.Save(t, out, indent)
        --[[
            assumes t is not recursive
            assumes all keys are key strings
            assumes strings do not have invalid chars
        ]]
        local originalout = out
        out = out or {'Automatically generated by Persistent.\nThis file will be read and overwritten.\nDO NOT EDIT\n'}
        indent = indent and indent + 1 or 1

        out[#out + 1] = '{\n'
        for k, v in spairs(t, function(t, a, b)
            return tostring(a) < tostring(b)
        end) do
            out[#out + 1] = string.rep('\t', indent)
            if type(k) == 'string' then
                out[#out + 1] = '\''
                out[#out + 1] = k
                out[#out + 1] = '\''
            elseif type(k) == 'number' or type(k) == 'boolean' or type(k) == 'nil' then
                out[#out + 1] = tostring(k)
            else
                error('Invalid key type, ' .. type(k))
            end
            out[#out + 1] = ' = '
            if type(v) == 'table' then
                Persistent.Save(v, out, indent)
            elseif type(v) == 'string' then
                out[#out + 1] = '\''
                out[#out + 1] = v
                out[#out + 1] = '\''
            elseif type(v) == 'number' or type(v) == 'boolean' or type(v) == 'nil' then
                out[#out + 1] = tostring(v)
            else
                error('Invalid value type, ' .. type(v))
            end
            out[#out + 1] = ',\n'
        end
        out[#out + 1] = string.rep('\t', indent - 1)
        out[#out + 1] = '}'
        if not originalout then
            return table.concat(out)
        end
    end


    function Persistent.Load(str)
        str = Persistent.StripComments(str)
        --print(str)
        --[[
            Instead of lazy loadstringing, we parse
        ]]
        local out = {}

        local escapetable = 0
        local escapestring = 0
        local lastescapestring = true
        local consecutivebackslash = 0
        local acceptingkey = true
        local acceptingvalue = false
        local lastkey = {}
        local lastvalue = {}
        local path = {}
        local currentt = out

        --print('s\tkey\tvalue')
        --Find first table, ignore everything before
        local i = string.find(str, '{') - 1
        repeat
            i = i + 1

            if acceptingkey and string.sub(str, i, i + 2) == ' = ' then
                acceptingkey = false
                acceptingvalue = true
                lastvalue = {}
                i = i + 3
            end

            local s = string.sub(str, i, i)
            --print(s, acceptingkey, acceptingvalue)
            --print(table.concat(lastkey), table.concat(lastvalue))

            if s == '{' then
                escapetable = escapetable + 1
                if escapetable >= 2 then
                    acceptingkey = true
                    acceptingvalue = false

                    local k = table.concat(lastkey)
                    --Parse Key
                    k = string.sub(k, 1, 1) == '\'' and string.sub(k, 2, -2) or tonumber(k) and tonumber(k) or k == 'true' and true or k == 'false' and false

                    path[#path + 1] = k
                    lastkey = {}

                    local t = out
                    for i = 1, #path - 1 do
                        t = t[path[i]]
                    end
                    t[path[#path]] = {}
                    currentt = t[path[#path]]
                end
            elseif s == '}' then
                escapetable = escapetable - 1
                if #path >= 1 then
                    path[#path] = nil

                    local t = out
                    for i = 1, #path do
                        t = t[path[i]]
                    end
                    currentt = t
                end
            elseif s == '\'' and consecutivebackslash % 2 == 0 then
                escapestring = lastescapestring and escapestring + 1 or escapestring - 1
                lastescapestring = not lastescapestring
            elseif s == '\\' then
                consecutivebackslash = consecutivebackslash + 1
            --elseif acceptingkey and string.find(s, '%a') then
            end
            if acceptingkey and s ~= '{' and s ~= '}' and s ~= ',' and s ~= '\t' and s ~= '\n' and s~= '\r' and s ~= ' ' then
                lastkey[#lastkey + 1] = s
            end
            --print(table.concat(lastkey))
                
            if acceptingvalue then
                if escapestring == 0 and s == ',' then

                    local k = table.concat(lastkey)
                    --Parse Key
                    k = string.sub(k, 1, 1) == '\'' and string.sub(k, 2, -2) or tonumber(k) and tonumber(k) or k == 'true' and true or k == 'false' and false

                    local v = table.concat(lastvalue)
                    --Parse Value
                    v = string.sub(v, 1, 1) == '\'' and string.sub(v, 2, -2) or tonumber(v) and tonumber(v) or v == 'true' and true or v == 'false' and false

                    currentt[k] = v
                    acceptingkey = true
                    acceptingvalue = false
                    lastkey = {}
                else
                    lastvalue[#lastvalue + 1] = s
                end
            end

            if s ~= '\\' then
                consecutivebackslash = 0
            end
        until i >= #str

        return out
    end




    function Persistent.StripComments(str)
        --DIRTY AS FUCK
        --you better not have // anywhere
        return string.gsub(str, '//.-\n', '')
    end



    --return Persistent
end































do
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

    --return TextureMap
end

























do
    --[[
        iniparserv1.lua

        be able to parse INI config files for skins
    ]]




    IniParser = {}




    function IniParser.Read(file)
        local f = io.open(file, 'rb')
        local s = f:read('*all')
        f:close()
        return s
    end

    function IniParser.Write(file, str)
        local f = io.open(file, 'wb+')
        f:write(str)
        f:close()
    end





    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

    function IniParser.Save(t)
        --[[
            Assumes it is only 1 heirarchy deep
            (we won't be needing recursion)
        ]]

        local globalout = {}
        local out = {}

        for k, v in spairs(t, function(t, a, b)
            return tostring(a) < tostring(b)
        end) do
            if type(v) == 'table' then
                out[#out + 1] = '['
                out[#out + 1] = tostring(k)
                out[#out + 1] = ']\n'
                for k2, v2 in spairs(v, function(t, a, b)
                    return tostring(a) < tostring(b)
                end) do
                    --key = value
                    out[#out + 1] = tostring(k2)
                    out[#out + 1] = ' = '
                    out[#out + 1] = tostring(v2)
                    out[#out + 1] = '\n'
                end
                out[#out + 1] = '\n'
            else
                --key = value
                globalout[#globalout + 1] = tostring(k)
                globalout[#globalout + 1] = ' = '
                globalout[#globalout + 1] = tostring(v)
                globalout[#globalout + 1] = '\n'
            end
        end

        return table.concat(globalout) .. (#out ~= 0 and ('\n\n' .. table.concat(out)) or '')
    end

    --pass in t to keep adding to that table
    function IniParser.Load(str, out, include)
        str = str .. '\n'
        local out = out or {}
        local include = include or {}
        local currentkey = nil
        local nextnewlinei = 1
        while true do
            --Newline
            local nextnewline = string.find(str, '\n', nextnewlinei)
            local cr = string.find(str, '\r\n', nextnewlinei)
            if cr and cr < nextnewline then
                nextnewline = cr
            end

            if not nextnewline then
                break
            end

            local s = string.sub(str, nextnewlinei, nextnewline - 1)

            if string.sub(s, 1, 1) ~= ';' then

                if string.sub(s, 1, 8) == '#include' then
                    include[#include + 1] = string.sub(s, 10, -1)
                else

                    --Bracket
                    local bracketstart = string.find(s, '%[')
                    if bracketstart then
                        local bracketend = string.find(s, '%]')
                        if bracketend then
                            currentkey = string.sub(s, bracketstart + 1, bracketend - 1)
                            out[currentkey] = out[currentkey] or {}
                        end
                    end

                    --Key-Value
                    local equals = string.find(s, '=')
                    if equals then
                        --Trim key right whitespace
                        local i = equals - 1
                        while true do
                            local s2 = string.sub(s, i, i)
                            if string.find(s2, '%s') then
                                i = i - 1
                            else
                                break
                            end
                        end

                        --Trim value left whitespace
                        local i2 = equals + 1
                        while true do
                            local s2 = string.sub(s, i2, i2)
                            if string.find(s2, '%s') then
                                i2 = i2 + 1
                            else
                                break
                            end
                        end

                        --Push key-value to out
                        local out2 = out
                        if currentkey then
                            --out[currentkey] = out[currentkey] or {}
                            out2 = out[currentkey]
                        else
                            out2 = out
                        end

                        out2[string.sub(s, 1, i)] = string.sub(s, i2, -1)
                    end
                end
            end

            nextnewlinei = nextnewline + (cr and 2 or 1)
        end
        return out, include
    end

    function IniParser.LoadFile(path)
        local slashp = string.find(string.reverse(path), '[/\\]') --LAST SLASH REVERSED

        local dir = slashp and string.sub(path, 1, #path + 1 - slashp) or ''
        local out = {}
        local include = {slashp and string.sub(path, #path + 2 - slashp) or path}
        while true do
            local path = dir .. include[#include]
            include[#include] = nil
            local f = io.open(path, 'rb')
            if f then
                local data = f:read('*all')
                out, include = IniParser.Load(data, out, include)
                if #include == 0 then
                    break
                end
            else
                return nil, 'Unable to open file.'
            end
        end
        return out
    end



    --extras for skins

    function IniParser.ParseCSV(str) --No errors are possible
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
    function IniParser.ParseCSVN(str)
        local t = IniParser.ParseCSV(str)
        for i = 1, #t do
            local a = tonumber(t[i])
            if a then
                t[i] = a
            else
                error('IniParser: csvn value not a number')
            end
        end
        return t
    end
end








































do
    --[[
        romaji.lua
        a utility to convert romaji to hiragana
    ]]




    --[[
    local function utf8Decode(s)
        local res, seq, val = {}, 0, nil
        for i = 1, #s do
            local c = string.byte(s, i)
            if seq == 0 then
                table.insert(res, val)
                seq = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or
                    c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6 or
                    error("invalid UTF-8 character sequence")
                val = bit.band(c, 2^(8-seq) - 1)
            else
                val = bit.bor(bit.lshift(val, 6), bit.band(c, 0x3F))
            end
            seq = seq - 1
        end
        table.insert(res, val)
        --table.insert(res, 0)
        return res
    end
    --]]














    Romaji = {}


    --[Romaji] = {Hiragana, Katakana}
    --Check generate.lua
    Romaji.Data = {
        To = {
            ['a'] = {'あ', 'ア'},        
            ['i'] = {'い', 'イ'},        
            ['u'] = {'う', 'ウ'},        
            ['e'] = {'え', 'エ'},        
            ['o'] = {'お', 'オ'},        
            ['ka'] = {'か', 'カ'},       
            ['ki'] = {'き', 'キ'},       
            ['ku'] = {'く', 'ク'},       
            ['ke'] = {'け', 'ケ'},       
            ['ko'] = {'こ', 'コ'},       
            ['kya'] = {'きゃ', 'キャ'},  
            ['kyu'] = {'きゅ', 'キュ'},  
            ['kyo'] = {'きょ', 'キョ'},  
            ['sa'] = {'さ', 'サ'},       
            ['shi'] = {'し', 'シ'},      
            ['su'] = {'す', 'ス'},       
            ['se'] = {'せ', 'セ'},       
            ['so'] = {'そ', 'ソ'},       
            ['sha'] = {'しゃ', 'シャ'},  
            ['shu'] = {'しゅ', 'シュ'},  
            ['sho'] = {'しょ', 'ショ'},  
            ['ta'] = {'た', 'タ'},       
            ['chi'] = {'ち', 'チ'},      
            ['tsu'] = {'つ', 'ツ'},      
            ['te'] = {'て', 'テ'},       
            ['to'] = {'と', 'ト'},       
            ['cha'] = {'ちゃ', 'チャ'},  
            ['chu'] = {'ちゅ', 'チュ'},  
            ['cho'] = {'ちょ', 'チョ'},  
            ['na'] = {'な', 'ナ'},       
            ['ni'] = {'に', 'ニ'},       
            ['nu'] = {'ぬ', 'ヌ'},       
            ['ne'] = {'ね', 'ネ'},       
            ['no'] = {'の', 'ノ'},       
            ['nya'] = {'にゃ', 'ニャ'},  
            ['nyu'] = {'にゅ', 'ニュ'},  
            ['nyo'] = {'にょ', 'ニョ'},  
            ['ha'] = {'は', 'ハ'},       
            ['hi'] = {'ひ', 'ヒ'},       
            ['fu'] = {'ふ', 'フ'},       
            ['he'] = {'へ', 'ヘ'},       
            ['ho'] = {'ほ', 'ホ'},       
            ['hya'] = {'ひゃ', 'ヒャ'},  
            ['hyu'] = {'ひゅ', 'ヒュ'},  
            ['hyo'] = {'ひょ', 'ヒョ'},  
            ['ma'] = {'ま', 'マ'},       
            ['mi'] = {'み', 'ミ'},       
            ['mu'] = {'む', 'ム'},       
            ['me'] = {'め', 'メ'},       
            ['mo'] = {'も', 'モ'},       
            ['mya'] = {'みゃ', 'ミャ'},  
            ['myu'] = {'みゅ', 'ミュ'},  
            ['myo'] = {'みょ', 'ミョ'},  
            ['ya'] = {'や', 'ヤ'},       
            ['yu'] = {'ゆ', 'ユ'},       
            ['yo'] = {'よ', 'ヨ'},       
            ['ra'] = {'ら', 'ラ'},       
            ['ri'] = {'り', 'リ'},       
            ['ru'] = {'る', 'ル'},       
            ['re'] = {'れ', 'レ'},       
            ['ro'] = {'ろ', 'ロ'},       
            ['rya'] = {'りゃ', 'リャ'},  
            ['ryu'] = {'りゅ', 'リュ'},  
            ['ryo'] = {'りょ', 'リョ'},  
            ['wa'] = {'わ', 'ワ'},       
            ['wo'] = {'を', 'ヲ'},       
            ['n'] = {'ん', 'ン'},        
            ['ga'] = {'が', 'ガ'},       
            ['gi'] = {'ぎ', 'ギ'},       
            ['gu'] = {'ぐ', 'グ'},       
            ['ge'] = {'げ', 'ゲ'},       
            ['go'] = {'ご', 'ゴ'},       
            ['gya'] = {'ぎゃ', 'ギャ'},  
            ['gyu'] = {'ぎゅ', 'ギュ'},  
            ['gyo'] = {'ぎょ', 'ギョ'},  
            ['za'] = {'ざ', 'ザ'},       
            ['ji'] = {'じ', 'ジ'},       
            ['zu'] = {'ず', 'ズ'},       
            ['ze'] = {'ぜ', 'ゼ'},       
            ['zo'] = {'ぞ', 'ゾ'},       
            ['ja'] = {'じゃ', 'ジャ'},   
            ['ju'] = {'じゅ', 'ジュ'},   
            ['jo'] = {'じょ', 'ジョ'},   
            ['da'] = {'だ', 'ダ'},       
            ['ji'] = {'ぢ', 'ヂ'},       
            ['zu'] = {'づ', 'ヅ'},       
            ['de'] = {'で', 'デ'},       
            ['do'] = {'ど', 'ド'},       
            ['ja'] = {'ぢゃ', 'ヂャ'},   
            ['ju'] = {'ぢゅ', 'ヂュ'},   
            ['jo'] = {'ぢょ', 'ヂョ'},   
            ['ba'] = {'ば', 'バ'},       
            ['bi'] = {'び', 'ビ'},       
            ['bu'] = {'ぶ', 'ブ'},       
            ['be'] = {'べ', 'ベ'},       
            ['bo'] = {'ぼ', 'ボ'},       
            ['bya'] = {'びゃ', 'ビャ'},  
            ['byu'] = {'びゅ', 'ビュ'},  
            ['byo'] = {'びょ', 'ビョ'},  
            ['pa'] = {'ぱ', 'パ'},       
            ['pi'] = {'ぴ', 'ピ'},       
            ['pu'] = {'ぷ', 'プ'},       
            ['pe'] = {'ぺ', 'ペ'},       
            ['po'] = {'ぽ', 'ポ'},       
            ['pya'] = {'ぴゃ', 'ピャ'},  
            ['pyu'] = {'ぴゅ', 'ピュ'},  
            ['pyo'] = {'ぴょ', 'ピョ'},



            --small tsu
            ['si'] = {'し', 'シ'},
            ['kka'] = {'っか', 'ッカ'},
            ['kki'] = {'っき', 'ッキ'},
            ['kku'] = {'っく', 'ック'},
            ['kke'] = {'っけ', 'ッケ'},
            ['kko'] = {'っこ', 'ッコ'},
            ['kkya'] = {'っきゃ', 'ッキャ'},    
            ['kkyu'] = {'っきゅ', 'ッキュ'},    
            ['kkyo'] = {'っきょ', 'ッキョ'},    
            ['ssa'] = {'っさ', 'ッサ'},
            ['sshi'] = {'っし', 'ッシ'},        
            ['ssu'] = {'っす', 'ッス'},
            ['sse'] = {'っせ', 'ッセ'},
            ['sso'] = {'っそ', 'ッソ'},
            ['ssha'] = {'っしゃ', 'ッシャ'},    
            ['sshu'] = {'っしゅ', 'ッシュ'},    
            ['ssho'] = {'っしょ', 'ッショ'},    
            ['tta'] = {'った', 'ッタ'},
            ['cchi'] = {'っち', 'ッチ'},        
            ['ttsu'] = {'っつ', 'ッツ'},        
            ['tte'] = {'って', 'ッテ'},
            ['tto'] = {'っと', 'ット'},
            ['ccha'] = {'っちゃ', 'ッチャ'},    
            ['cchu'] = {'っちゅ', 'ッチュ'},    
            ['ccho'] = {'っちょ', 'ッチョ'},    
            ['hha'] = {'っは', 'ッハ'},
            ['hhi'] = {'っひ', 'ッヒ'},
            ['ffu'] = {'っふ', 'ッフ'},
            ['hhe'] = {'っへ', 'ッヘ'},
            ['hho'] = {'っほ', 'ッホ'},
            ['hhya'] = {'っひゃ', 'ッヒャ'},    
            ['hhyu'] = {'っひゅ', 'ッヒュ'},    
            ['hhyo'] = {'っひょ', 'ッヒョ'},    
            ['mma'] = {'っま', 'ッマ'},
            ['mmi'] = {'っみ', 'ッミ'},
            ['mmu'] = {'っむ', 'ッム'},
            ['mme'] = {'っめ', 'ッメ'},
            ['mmo'] = {'っも', 'ッモ'},
            ['mmya'] = {'っみゃ', 'ッミャ'},    
            ['mmyu'] = {'っみゅ', 'ッミュ'},    
            ['mmyo'] = {'っみょ', 'ッミョ'},    
            ['yya'] = {'っや', 'ッヤ'},
            ['yyu'] = {'っゆ', 'ッユ'},
            ['yyo'] = {'っよ', 'ッヨ'},
            ['rra'] = {'っら', 'ッラ'},
            ['rri'] = {'っり', 'ッリ'},
            ['rru'] = {'っる', 'ッル'},
            ['rre'] = {'っれ', 'ッレ'},
            ['rro'] = {'っろ', 'ッロ'},
            ['rrya'] = {'っりゃ', 'ッリャ'},    
            ['rryu'] = {'っりゅ', 'ッリュ'},    
            ['rryo'] = {'っりょ', 'ッリョ'},    
            ['wwa'] = {'っわ', 'ッワ'},
            ['wwo'] = {'っを', 'ッヲ'},
            ['gga'] = {'っが', 'ッガ'},
            ['ggi'] = {'っぎ', 'ッギ'},
            ['ggu'] = {'っぐ', 'ッグ'},
            ['gge'] = {'っげ', 'ッゲ'},
            ['ggo'] = {'っご', 'ッゴ'},
            ['ggya'] = {'っぎゃ', 'ッギャ'},    
            ['ggyu'] = {'っぎゅ', 'ッギュ'},    
            ['ggyo'] = {'っぎょ', 'ッギョ'},    
            ['zza'] = {'っざ', 'ッザ'},
            ['jji'] = {'っじ', 'ッジ'},
            ['zzu'] = {'っず', 'ッズ'},
            ['zze'] = {'っぜ', 'ッゼ'},
            ['zzo'] = {'っぞ', 'ッゾ'},
            ['jja'] = {'っじゃ', 'ッジャ'},     
            ['jju'] = {'っじゅ', 'ッジュ'},     
            ['jjo'] = {'っじょ', 'ッジョ'},     
            ['dda'] = {'っだ', 'ッダ'},
            ['jji'] = {'っぢ', 'ッヂ'},
            ['zzu'] = {'っづ', 'ッヅ'},
            ['dde'] = {'っで', 'ッデ'},
            ['ddo'] = {'っど', 'ッド'},
            ['jja'] = {'っぢゃ', 'ッヂャ'},     
            ['jju'] = {'っぢゅ', 'ッヂュ'},     
            ['jjo'] = {'っぢょ', 'ッヂョ'},     
            ['bba'] = {'っば', 'ッバ'},
            ['bbi'] = {'っび', 'ッビ'},
            ['bbu'] = {'っぶ', 'ッブ'},
            ['bbe'] = {'っべ', 'ッベ'},
            ['bbo'] = {'っぼ', 'ッボ'},
            ['bbya'] = {'っびゃ', 'ッビャ'},    
            ['bbyu'] = {'っびゅ', 'ッビュ'},    
            ['bbyo'] = {'っびょ', 'ッビョ'},    
            ['ppa'] = {'っぱ', 'ッパ'},
            ['ppi'] = {'っぴ', 'ッピ'},
            ['ppu'] = {'っぷ', 'ップ'},
            ['ppe'] = {'っぺ', 'ッペ'},
            ['ppo'] = {'っぽ', 'ッポ'},
            ['ppya'] = {'っぴゃ', 'ッピャ'},    
            ['ppyu'] = {'っぴゅ', 'ッピュ'},    
            ['ppyo'] = {'っぴょ', 'ッピョ'},
        }
    }



    function Romaji.ToHiragana(ostr)
        --Config
        local index = 1 --index for Romaji.Data.To, 1 is hiragana, 2 is katakana
        local str = string.lower(ostr) --don't use uppercase, for getting indexes from data

        local out = {}
        local i = 1


        while true do
            --[[
            local s = string.sub(str, i, i)

            --lookup
            if Romaji.Data.To[s] then
                out[#out + 1] = Romaji.Data.To[s][index]
                i = i + 1
            elseif i < #str then
                local s2 = string.sub(str, i, i + 1)
                if Romaji.Data.To[s2] then
                    out[#out + 1] = Romaji.Data.To[s2][index]
                    i = i + 2
                elseif i < #str - 1 then
                    local s3 = string.sub(str, i, i + 2)
                    if Romaji.Data.To[s3] then
                        out[#out + 1] = Romaji.Data.To[s3][index]
                        i = i + 3
                    end
                else
                    i = i + 1
                end
            else
                i = i + 1
            end
            --]]

            local done = false

            if not done and i < #str - 1 then
                local s3 = string.sub(str, i, i + 2)
                if Romaji.Data.To[s3] then
                    out[#out + 1] = Romaji.Data.To[s3][index]
                    i = i + 3
                    done = true
                end
            end
            if not done and i < #str then
                local s2 = string.sub(str, i, i + 1)
                if Romaji.Data.To[s2] then
                    out[#out + 1] = Romaji.Data.To[s2][index]
                    i = i + 2
                    done = true
                end
            end
            if not done then
                local s1 = string.sub(str, i, i)
                if Romaji.Data.To[s1] then
                    out[#out + 1] = Romaji.Data.To[s1][index]
                    i = i + 1
                    done = true
                end
            end
            if not done then
                out[#out + 1] = string.sub(str, i, i)
                i = i + 1
            end


            --next
            if i > #str then
                break
            end
        end

        return table.concat(out)
    end

    function Romaji.ToRomaji(str)

    end


end

































do
    --[[
        savestate.lua

        Save the state of the environment and load it back
    ]]




    SaveState = {}




    --Taken from Render.lua and modified to handle recursiveness


    -- Save copied tables in `copies`, indexed by original table. --http://lua-users.org/wiki/CopyTable
    local function deepcopy(orig, copies)
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
                    copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
                end
                setmetatable(copy, deepcopy(getmetatable(orig), copies))
            end
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end
    local function CopyTableEquality(t, copyt)
        --copy t to copyt, and also check for equality (lol doesn't work)

        local out = deepcopy(t, copyt)

        return false
    end













    local defaultstacklevel = 1

    function SaveState.Save(stacklevel)
        --[[
            data = {
                locals = {
                    [stacklevel] = {
                        {n, v},
                        ...
                    },
                    ...
                },
                globals = {
                    n = v,
                    ...
                }
            }
        ]]
        local data = {
            locals = {},
            globals = {}
        }



        --locals
        while true do

            --Taken from commandv1.lua -> Command.GetLocalTable
            stacklevel = (stacklevel or defaultstacklevel) + 1

            if debug.getinfo(stacklevel) then
                --valid
            else
                break
            end

            local t = {}

            local i = 1
            while true do
                local n, v = debug.getlocal(stacklevel, i)
                if n then
                    --Be able to store nils
                    --t[n] = {v}
                    --OR

                    t[#t + 1] = {n, deepcopy(v)}
                else
                    --Unable to find local
                    break
                end
                i = i + 1
            end

            data.locals[stacklevel] = t
            --stacklevel = stacklevel + 1 --already adds 1 by default
        end

        --for k, v in pairs(data.locals) do for k2, v2 in pairs(v) do print(k, v2[1], v2[2]) end end





        --globals
        for k, v in pairs(_G) do
            data.globals[deepcopy(k)] = deepcopy(v)
        end

        --for k, v in pairs(data.globals) do print(k,v)end

        return data
    end

    function SaveState.Load(data)
        --locals
        for stacklevel, t in pairs(data.locals) do

            --Taken from commandv1.lua -> Command.SetLocal
            --stacklevel = stacklevel

            local i = 1
            while true do
                local n, v = debug.getlocal(stacklevel, i)
                if n then
                    for i2 = 1, #t do
                        local a = t[i2]
                        if a[1] == n then
                            --You can only set a value of an existing local
                            debug.setlocal(stacklevel, i, a[2])
                            break
                        end
                    end
                else
                    --Unable to find local
                    break
                end
                i = i + 1
            end
        end


        --globals
        for k, v in pairs(data.globals) do
            _G[k] = v
        end
    end





    local DATA = {}
    function SaveState.SaveSlot(n)
        DATA[n] = SaveState.Save(defaultstacklevel + 1)
        return true, DATA[n]
    end
    function SaveState.LoadSlot(n)
        if DATA[n] then
            --Copy form DATA and load since we don't want to modify the saved and stored one
            SaveState.Load(deepcopy(DATA[n]))
            return true
        else
            return nil
        end
    end


    --SaveState.Load(SaveState.Save())
end
































do
    --[[
        serializev3.lua

        Serialize lua tables into lua code

        DIFFERENT THAN PERSISTENT, SERIALIZE ANYTHING

        v2 note: I gave up on making a serializer, just stole on from lua-nucleo
        v3 note: serializer for ctypes works!!!
    ]]


    Serialize = {}









    local ffi = require('ffi')
    local function tohex(str)
        return (str:gsub('.', function (c)
            return string.format('%02X', string.byte(c))
        end))
    end



    --https://github.com/lua-nucleo/lua-nucleo/blob/master/lua-nucleo/tserialize.lua
    --MODIFIED TO REMOVE IMPORTS

    --------------------------------------------------------------------------------
    --- Serialize arbitrary Lua data to Lua code
    -- @module lua-nucleo.tserialize
    -- This file is a part of lua-nucleo library
    -- @copyright lua-nucleo authors (see file `COPYRIGHT` for the license)
    --------------------------------------------------------------------------------

    -- Serializes arbitrary lua tables to lua code
    -- that can be loaded back via loadstring()
    -- Functions, threads, userdata are not supported
    -- Metatables are ignored
    -- Usage:
    --     str = tserialize(explist) --> to serialize data
    --     =(loadstring(str)()) --> to load it back

    local tserialize
    do
    local pairs, type, tostring, select
        = pairs, type, tostring, select
    local table_concat, table_remove = table.concat, table.remove
    local string_format, string_match = string.format, string.match

    local lua_keywords = {
        ["and"] = true,    ["break"] = true,  ["do"] = true,
        ["else"] = true,   ["elseif"] = true, ["end"] = true,
        ["false"] = true,  ["for"] = true,    ["function"] = true,
        ["if"] = true,     ["in"] = true,     ["local"] = true,
        ["nil"] = true,    ["not"] = true,    ["or"] = true,
        ["repeat"] = true, ["return"] = true, ["then"] = true,
        ["true"] = true,    ["until"] = true,  ["while"] = true
    }
    local serialize_number
    do
        local t =
        {
        [tostring(1/0)] = "1/0";
        [tostring(-1/0)] = "-1/0";
        [tostring(0/0)] = "0/0";
        }
        number_to_string = function(number)
        -- no argument checking - called very often
        local text = tostring(number)
        return t[text] or text
        end
        serialize_number = function(number)
        -- no argument checking - called very often
        local text = ("%.17g"):format(number)
        -- on the same platform tostring() and string.format()
        -- return the same results for 1/0, -1/0, 0/0
        -- so we don't need separate substitution table
        return t[text] or text
        end
    end

    local cur_buf
    local cat = function(v)
        cur_buf[#cur_buf + 1] = v
    end

    local function general_iterator(tbl, i)
        i = i + 1
        local v = tbl[i]
        if v ~= nil then
        return i, v
        end
    end

    local function metatable_iterator(tbl, i)
        i = i + 1
        local v = rawget(tbl, i)
        if v ~= nil then
        return i, v
        end
    end

    -- Starting from Lua 5.3, size of the array tables with holes is different
    -- that in older versions and is really undetermined as the Lua manual
    -- always been said. This affects native `ipair` iterator and breaks
    -- serialization of some tables with holes in Lua >= 5.3. To resolve it,
    -- we introduce modified ipairs iterator that gets rid of that uncertainty.
    -- `ipairs_raw` iterates the table starting from the first element until
    -- the `nil` element is found. Access is made via `rawget` if the input table
    -- has metatable, and via table key accessor otherwise.
    local function ipairs_raw(list)
        if getmetatable(list) then
        return metatable_iterator, list, 0
        end

        return general_iterator, list, 0
    end

    local function explode_rec(t, add, vis, added)
        local t_type = type(t)
        if t_type == "table" then
        if not (added[t] or vis[t]) then
            vis[t] = true
            for k,v in pairs(t) do
            explode_rec(k, add, vis, added)
            explode_rec(v, add, vis, added)
            end
        else
            if not added[t] and vis[t] then
            add[#add+1] = t
            added[t] = { name = "_["..#add.."]", num = #add}
            end
        end
        end
    end

    local parse_rec
    do
        local started

        local function impl(t, added, rec_info)
        local t_type = type(t)
        local rec = false
        if t_type == "table" then
            if not added[t]or not started then
            started = true
            for k, v in pairs(t) do
                if impl(k, added, rec_info) or impl(v, added, rec_info) then
                rec = true
                if type(k) == "table" then
                    rec_info[k] = true
                end
                if type(v) == "table" then
                    rec_info[v] = true
                end
                end
            end
            else
            return true
            end
        end
        return rec
        end

        parse_rec = function(t, added, rec_info)
        started = false
        rec_info[t] = true
        impl(t, added, rec_info)
        end

    end
    local function recursive_proceed(t, added, rec_info, after, started)
        local t_type = type(t)
        if t_type == "table" then
        if not started or not added[t] then
        local started = true
            cat("{")
            -- Serialize numeric indices
            local next_i = 0
            for i, v in ipairs_raw(t) do
            next_i = i
            if not (rec_info[i] or rec_info[v]) then
                if i ~= 1 then cat(",") end
                recursive_proceed(v, added, rec_info, after, started)
            else
                next_i = i - 1
                break
            end
            end
            next_i = next_i + 1
            -- Serialize hash part
            -- Skipping comma only at first element if there is no numeric part.
            local comma = (next_i > 1) and "," or ""
            for k, v in pairs(t) do
            local k_type = type(k)
            if not (rec_info[k] or rec_info[v]) then
            --that means, if the value does not contain a recursive link
            -- to the table itself
            --and the index does not contain a recursive link...
                if k_type == "string"  then
                cat(comma)
                comma = ","
                --check if we can use the short notation
                -- eg {a=3,b=5} istead of {["a"]=3,["b"]=5}
                if
                    not lua_keywords[k] and string_match(k, "^[%a_][%a%d_]*$")
                then
                    cat(k); cat("=")
                else
                    cat(string_format("[%q]=", k))
                end
                    recursive_proceed(v, added, rec_info, after, started)
                elseif
                k_type ~= "number" or -- non-string non-number
                k >= next_i or k < 1 or -- integer key in hash part of the table
                k % 1 ~= 0 -- non-integral key.
                then
                cat(comma)
                comma = ","
                cat("[")
                recursive_proceed(k, added, rec_info, after, started)
                cat("]")
                cat("=")
                recursive_proceed(v, added, rec_info, after, started)
                end
            else
                after[#after + 1] = {k,v}
            end
            end
            cat("}")
        else -- already visited!
            cat(added[t].name)
        end
        elseif t_type == "string" then
        cat(string_format("%q", t))
        elseif t_type == "number" then
        cat(serialize_number(t))
        elseif t_type == "boolean" then
        cat(tostring(t))
        elseif t_type == "cdata" then
            cat("nil")
        --[[
        local ctype = string.match(tostring(ffi.typeof(t)), 'ctype<struct (.-)>')
        if not ctype then
            ctype = 'void *'
        end
        local s = ffi.string(t, ffi.sizeof(t)) -- specify how long the byte sequence is
        cat('_CDATA(\'' .. ctype .. '\',\'' .. tohex(s) .. '\')')
        --]]

        elseif t == nil then
        cat("nil")
        else
            cat("nil")
        return nil
        end
        return true
    end

    local function recursive_proceed_simple(t, added)
        local t_type = type(t)
        if t_type == "table" then
        if not added[t] then
            cat("{")
            -- Serialize numeric indices
            local next_i = 0
            for i, v in ipairs_raw(t) do
            next_i = i
            if i ~= 1 then cat(",") end
            recursive_proceed_simple(v, added)
            end
            next_i = next_i + 1
            -- Serialize hash part
            -- Skipping comma only at first element if there is no numeric part.
            local comma = (next_i > 1) and "," or ""
            for k, v in pairs(t) do
            local k_type = type(k)
            if k_type == "string"  then
                cat(comma)
                comma = ","
                --check if we can use the short notation
                -- eg {a=3,b=5} istead of {["a"]=3,["b"]=5}
                if
                not lua_keywords[k] and string_match(k, "^[%a_][%a%d_]*$")
                then
                cat(k); cat("=")
                else
                cat(string_format("[%q]=", k))
                end
                recursive_proceed_simple(v, added)
            elseif
                k_type ~= "number" or -- non-string non-number
                k >= next_i or k < 1 or -- integer key in hash part of the table
                k % 1 ~= 0 -- non-integral key.
            then
                cat(comma)
                comma = ","
                cat("[")
                recursive_proceed_simple(k, added)
                cat("]")
                cat("=")
                recursive_proceed_simple(v, added)
            end
            end
            cat("}")
        else -- already visited!
            cat(added[t].name)
        end
        elseif t_type == "string" then
        cat(string_format("%q", t))
        elseif t_type == "number" then
        cat(serialize_number(t))
        elseif t_type == "boolean" then
        cat(tostring(t))
        elseif t_type == "cdata" then
            cat("nil")
        --[[
        local ctype = string.match(tostring(ffi.typeof(t)), 'ctype<struct (.-)>')
        if not ctype then
            ctype = 'void *'
        end
        local s = ffi.string(t, ffi.sizeof(t)) -- specify how long the byte sequence is
        cat('_CDATA(\'' .. ctype .. '\',\'' .. tohex(s) .. '\')')
        --]]

        elseif t == nil then
        cat("nil")
        else
            cat("nil")
        return nil
        end
        return true
    end



    local afterwork = function(k, v, buf, name, added)
        cur_buf = buf
        cat(" ")
        cat(name)
        cat("[")
        local after = buf.afterwork
        if not recursive_proceed_simple(k, added) then
        return false
        end
        cat("]=")
        if not recursive_proceed_simple(v, added) then
        return false
        end
        cat(" ")
        return true
    end

    tserialize = function (...)
    --===================================--
    --===========THE MAIN PART===========--
    --===================================--
        --PREPARATORY WORK: LOCATE THE RECURSIVE AND SHARED PARTS--
        local narg = select("#", ...)
        local visited = {}
        -- table, containing recursive parts of our variables
        local additional_vars = { }
        local added = {}
        for i = 1, narg do
        local v = select(i, ...)
        explode_rec(v, additional_vars, visited, added) -- discover recursive subtables
        end
        visited = nil -- no more needed
        local nadd = #additional_vars
        --SERIALIZE ADDITIONAL FIRST--
        local rec_info = {}

        for i = 1, nadd do
        local v = additional_vars[i]
        parse_rec(v, added, rec_info)
        end
        local buf = {}
        for i = 1, nadd do
        local v = additional_vars[i]
        buf[i] = {afterwork = {}}
        local after = buf[i].afterwork
        cur_buf = buf[i]
        if not recursive_proceed(v, added, rec_info, after) then
            return nil, "Unserializable data in parameter #" .. i
        end
        end

        rec_info = {}
        for i = 1, nadd do
        local v = additional_vars[i]
        buf[i].afterstart = #buf[i]
        for j = 1, #(buf[i].afterwork) do
            if not afterwork(
                buf[i].afterwork[j][1],
                buf[i].afterwork[j][2],
                buf[i],
                added[v].name,
            added
                )
            then
            return nil, "Unserializable data in parameter #" .. i
            end
        end
        end

        --SERIALIZE GIVEN VARS--

        for i = 1, narg do
        local v = select(i, ...)
        buf[i + nadd] = {}
        cur_buf = buf[i + nadd]
        if not recursive_proceed_simple(v, added) then
            return nil, "Unserializable data in parameter #" .. i
        end
        end

        --DECLARE ADDITIONAL VARS--

        local prevbuf = {}
        for v, inf in pairs(added) do
        prevbuf[ #prevbuf + 1] =
        "[" .. inf.num .. "]=" .. table_concat(buf[inf.num], "", 1, buf[inf.num].afterstart)..";"
        end

        --CONCAT PARTS--
        for i = 1, nadd do
        buf[i] = table_concat(buf[i], "", buf[i].afterstart + 1)
        end
        for i = nadd + 1, nadd+narg do
        buf[i] = table_concat(buf[i])
        end

        --RETURN THE RESULT--

        local cdata = "local ffi=require'ffi'_CDATA=function(t,h)return ffi.cast(t..'*',h:gsub('..',function(c)return string.char(tonumber(c,16))end))end "

        if  nadd == 0 then
        return cdata .. "return " .. table_concat(buf,",")
        else
        local rez = {
            "do local _={";
            table_concat(prevbuf, " ");
            '}';
            table_concat(buf, " ", 1, nadd);
            " return ";
            table_concat(buf, ",", nadd+1);
            " end";
        }
        return cdata .. table_concat(rez)
        end
    end
    end



























    function Serialize.Save(t)
        return tserialize(t)
    end

    function Serialize.Load(str)
        --This is just loadstring: BE CAREFUL --UNSAFE
        local f, err = loadstring(str)
        if f then
            local success, out = pcall(f)
            if success then
                return out
            else
                error(out)
            end
        else
            error(err)
        end
    end


end

































do
    --[[
        persistentparsed.lua

        Be able to store parsed data in VERY efficient formats

        File extention: ppd (decompressed) or ppdc (compressed)


        Notes:
        Lazy af, it just uses metalua serialize and compresses using lualzw
    ]]


    PersistentParsed = {}

    local ffi = require('ffi')
    local function tohex(str)
        return (str:gsub('.', function (c)
            return string.format('%02X', string.byte(c))
        end))
    end







    --[[
        example:
        {["n"]=247,["bpm"]=194,["senotepr"]=cdata,["oms"]=33092.783505155,["odelay"]=0,["mspermeasure"]=1237.1134020619,["scrollx"]=-1,["senote"]=1,["type"]=1,["setdelay"]=false,["osenotepr"]=cdata,["tcenter"]=cdata,["line"]=57,["p"]={},["scrolly"]=0,["data"]="note",["nextnote"]=248,["loadms"]=33382.711340206,["rotationr"]=0,["radiusr"]=1,["tcentero"]=cdata,["CalculatePosition"]=_[1],["speed"]={-0.776,0},["delay"]=0,["gogo"]=false,["radius"]=1,["ms"]=34601.783505155,["brokecombo"]=false,["pop"]=false,["pr"]=cdata,["senotet"]=0}
    ]]
    PersistentParsed.CompressKeyData = {
        n = 'a',
        bpm = 'b',
        senotepr = 'c',
        oms = 'd',
        odelay = 'e',
        mspermeasure = 'f',
        scrollx = 'g',
        senote = 'h',
        type = 'i',
        setdelay = 'j',
        osenotepr = 'k',
        tcenter = 'l',
        line = 'm',
        p = 'n',
        scrolly = 'o',
        data = 'p',
        nextnote = 'q',
        loadms = 'r',
        rotationr = 's',
        radiusr = 't',
        tcentero = 'u',
        CalculatePosition = 'v',
        speed = 'w',
        delay = 'x',
        gogo = 'y',
        radius = 'z',
        ms = 'A',
        brokecombo = 'B',
        pop = 'C',
        pr = 'D',
        senotet = 'E',
        event = 'F',
        startnote = 'G',
        endnote = 'H',
        onnotepush = 'I',
        lengthms = 'J',
        endtype = 'K',
        drumrollbend = 'L',
        notetype = 'M',
        recttype = 'N',

        obpm = 'O',
    }



    PersistentParsed.DecompressKeyData = {}
    for k, v in pairs(PersistentParsed.CompressKeyData) do
        PersistentParsed.DecompressKeyData[v] = k
    end

















    --serialize.lua

    --https://github.com/fab13n/metalua/blob/no-dll/src/lib/serialize.lua
    --MODIFIED TO BE MINIFIED

    --------------------------------------------------------------------------------
    -- Serialize an object into a source code string. This string, when passed as
    -- an argument to loadstring()(), returns an object structurally identical
    -- to the original one. The following are currently supported:
    -- * strings, numbers, booleans, nil
    -- * functions without upvalues
    -- * tables thereof. Tables can have shared part, but can't be recursive yet.
    -- Caveat: metatables and environments aren't saved.
    --------------------------------------------------------------------------------

    local no_identity = { number=1, boolean=1, string=1, ['nil']=1 }

    function serialize (x)
    
    local gensym_max =  0  -- index of the gensym() symbol generator
    local seen_once  = { } -- element->true set of elements seen exactly once in the table
    local multiple   = { } -- element->varname set of elements seen more than once
    local nested     = { } -- transient, set of elements currently being traversed
    local nest_points = { }
    local nest_patches = { }
    
    local function gensym()
        gensym_max = gensym_max + 1 ;  return gensym_max
    end
    
    -----------------------------------------------------------------------------
    -- nest_points are places where a table appears within itself, directly or not.
    -- for instance, all of these chunks create nest points in table x:
    -- "x = { }; x[x] = 1", "x = { }; x[1] = x", "x = { }; x[1] = { y = { x } }".
    -- To handle those, two tables are created by mark_nest_point:
    -- * nest_points [parent] associates all keys and values in table parent which
    --   create a nest_point with boolean `true'
    -- * nest_patches contain a list of { parent, key, value } tuples creating
    --   a nest point. They're all dumped after all the other table operations
    --   have been performed.
    --
    -- mark_nest_point (p, k, v) fills tables nest_points and nest_patches with
    -- informations required to remember that key/value (k,v) create a nest point
    -- in table parent. It also marks `parent' as occuring multiple times, since
    -- several references to it will be required in order to patch the nest
    -- points.
    -----------------------------------------------------------------------------
    local function mark_nest_point (parent, k, v)
        local nk, nv = nested[k], nested[v]
        assert (not nk or seen_once[k] or multiple[k])
        assert (not nv or seen_once[v] or multiple[v])
        local mode = (nk and nv and "kv") or (nk and "k") or ("v")
        local parent_np = nest_points [parent]
        local pair = { k, v }
        if not parent_np then parent_np = { }; nest_points [parent] = parent_np end
        parent_np [k], parent_np [v] = nk, nv
        table.insert (nest_patches, { parent, k, v })
        seen_once [parent], multiple [parent]  = nil, true
    end
    
    -----------------------------------------------------------------------------
    -- First pass, list the tables and functions which appear more than once in x
    -----------------------------------------------------------------------------
    local function mark_multiple_occurences (x)
        if no_identity [type(x)] then return end
        if     seen_once [x]     then seen_once [x], multiple [x] = nil, true
        elseif multiple  [x]     then -- pass
        else   seen_once [x] = true end
        
        if type (x) == 'table' then
            nested [x] = true
            for k, v in pairs (x) do
                if nested[k] or nested[v] then mark_nest_point (x, k, v) else
                mark_multiple_occurences (k)
                mark_multiple_occurences (v)
                end
            end
            nested [x] = nil
        end
    end

    local dumped    = { } -- multiply occuring values already dumped in localdefs
    local localdefs = { } -- already dumped local definitions as source code lines


    -- mutually recursive functions:
    local dump_val, dump_or_ref_val

    --------------------------------------------------------------------
    -- if x occurs multiple times, dump the local var rather than the
    -- value. If it's the first time it's dumped, also dump the content
    -- in localdefs.
    --------------------------------------------------------------------            
    function dump_or_ref_val (x)
        if nested[x] then return 'false' end -- placeholder for recursive reference
        if not multiple[x] then return dump_val (x) end
        local var = dumped [x]
        if var then return "_[" .. var .. "]" end -- already referenced
        local val = dump_val(x) -- first occurence, create and register reference
        var = gensym()
        table.insert(localdefs, "_["..var.."]="..val)
        dumped [x] = var
        return "_[" .. var .. "]"
    end

    -----------------------------------------------------------------------------
    -- Second pass, dump the object; subparts occuring multiple times are dumped
    -- in local variables which can be referenced multiple times;
    -- care is taken to dump locla vars in asensible order.
    -----------------------------------------------------------------------------
    function dump_val(x)
        local  t = type(x)
        if     x==nil        then return 'nil'
        elseif t=="number"   then return tostring(x)
        elseif t=="string"   then return string.format("%q", x)
        elseif t=="boolean"  then return x and "true" or "false"
        elseif t=="function" then
            return string.format ("loadstring(%q,'@serialized')", string.dump (x))
        elseif t=="table" then

            local acc        = { }
            local idx_dumped = { }
            local np         = nest_points [x]
            for i, v in ipairs(x) do
                if np and np[v] then
                table.insert (acc, 'false') -- placeholder
                else
                table.insert (acc, dump_or_ref_val(v))
                end
                idx_dumped[i] = true
            end
            for k, v in pairs(x) do
                if np and (np[k] or np[v]) then
                --check_multiple(k); check_multiple(v) -- force dumps in localdefs
                elseif not idx_dumped[k] then
                    if PersistentParsed.CompressKeyData[k] then
                        table.insert (acc, PersistentParsed.CompressKeyData[k] .. "=" .. dump_or_ref_val(v))
                    else
                        table.insert (acc, "[" .. dump_or_ref_val(k) .. "]=" .. dump_or_ref_val(v))
                    end
                end
            end
            return "{"..table.concat(acc,",").."}"
        else
            --return 'cdata'
            --error ("Can't serialize data of type "..t)

            --cdata serializer
            local t = x
            local ctype = string.match(tostring(ffi.typeof(t)), 'ctype<struct (.-)>')
            if not ctype then
                ctype = 'void *'
            else
                --remove pointer
                ctype = string.gsub(ctype, '%s%*', '')
            end
            local s = ffi.string(t, ffi.sizeof(t)) -- specify how long the byte sequence is
            return '_CDATA(\'' .. ctype .. '\',\'' .. tohex(s) .. '\')'
        end
    end
            
    local function dump_nest_patches()
        for _, entry in ipairs(nest_patches) do
            local p, k, v = unpack (entry)
            assert (multiple[p])
            local set = dump_or_ref_val (p) .. "[" .. dump_or_ref_val (k) .. "]=" .. 
                dump_or_ref_val (v)
            table.insert (localdefs, set)
        end
    end
    
    mark_multiple_occurences (x)
    local toplevel = dump_or_ref_val (x)
    dump_nest_patches()

    --cdata serializer
    local cdata = "local ffi=require'ffi'_CDATA=function(t,h)return ffi.cast(t..'*',h:gsub('..',function(c)return string.char(tonumber(c,16))end))end "
    
    if next (localdefs) then
        return cdata .. "local _={}" ..
            table.concat (localdefs, "") .. 
            "return " .. toplevel
    else
        return cdata .. "return " .. toplevel
    end
    end






















    --lualzw.lua

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





















    --disable compression (max fastness, but shit storage)
    --[[
    compress = function(str)return str end
    decompress = compress
    --]]

    --HEADER
    local header = 'THIS IS EDITOR SAVE DATA\nAutomatically generated by PersistentParsed.\nThis file will be read and overwritten.\nDO NOT EDIT\n'








    function PersistentParsed.Save(Parsed)
        --Trim Parsed.Data so that serialization would be way faster


        --Index notes [note] = i
        local index = {}
        for i = 1, #Parsed.Data do
            index[Parsed.Data[i]] = i
        end

        for i = 1, #Parsed.Data do
            local note = Parsed.Data[i]
            

            --change nextnote, startnote, endnote into numbers
            if note.nextnote then
                note.nextnote = index[note.nextnote]
            end
            if note.startnote then
                note.startnote = index[note.startnote]
            end
            if note.endnote then
                note.endnote = index[note.endnote]
            end
        end
        
        --Compress keys is included in serializd
        return header .. compress(serialize(Parsed))
    end

    function PersistentParsed.Load(str)
        local data = decompress(string.sub(str, #header + 1, -1))
        if data then
            local f = loadstring(data)
            if f then
                local success, Parsed = pcall(f)

                if success then

                    --Decompress keys
                    for i = 1, #Parsed.Data do
                        local note = Parsed.Data[i]
                        local new = {}
                        --[=[
                        for k, v in pairs(note) do
                            if PersistentParsed.DecompressKeyData[k] then
                                note[PersistentParsed.DecompressKeyData[k]] = v
                                note[k] = nil
                            end
                        end
                        --]=]
                        for k, v in pairs(note) do
                            if PersistentParsed.DecompressKeyData[k] then
                                new[PersistentParsed.DecompressKeyData[k]] = v
                            else
                                new[k] = v
                            end
                        end

                        Parsed.Data[i] = new
                    end

                    --Undo index
                    for i = 1, #Parsed.Data do
                        local note = Parsed.Data[i]
                        

                        --change nextnote, startnote, endnote into numbers
                        if note.nextnote then
                            note.nextnote = Parsed.Data[note.nextnote]
                        end
                        if note.startnote then
                            note.startnote = Parsed.Data[note.startnote]
                        end
                        if note.endnote then
                            note.endnote = Parsed.Data[note.endnote]
                        end
                    end

                    --Undo cdata???? cdata is nil so it dissappears after second iteration


                    return Parsed
                else
                    return nil
                end
            else
                return nil
            end
        else
            return nil
        end
    end




    
    function PersistentParsed.Read(file)
        local f = io.open(file, 'rb')
        local s = f:read('*all')
        f:close()
        return s
    end

    function PersistentParsed.Write(file, str)
        local f = io.open(file, 'wb+')
        f:write(str)
        f:close()
    end



end






























local lfs
do
local bit = require "bit"
local ffi = require "ffi"


local band = bit.band
local rshift = bit.rshift
local lib = ffi.C
local ffi_str = ffi.string
local concat = table.concat
local has_table_new, new_tab = pcall(require, "table.new")
if not has_table_new or type(new_tab) ~= "function" then
    new_tab = function () return {} end
end


local _M = {
    _VERSION = "0.1",
}

-- common utils/constants
local IS_64_BIT = ffi.abi('64bit')
local ERANGE = 'Result too large'

if not pcall(ffi.typeof, "ssize_t") then
    -- LuaJIT 2.0 doesn't have ssize_t as a builtin type, let's define it
    ffi.cdef("typedef intptr_t ssize_t")
end

ffi.cdef([[
    char* strerror(int errnum);
]])

local function errno()
    return ffi_str(lib.strerror(ffi.errno()))
end

local OS = ffi.os
-- sys/syslimits.h
local MAXPATH
local MAXPATH_UNC = 32760
local HAVE_WFINDFIRST = true
local wchar_t
local win_utf8_to_unicode
local win_unicode_to_utf8
if OS == 'Windows' then
    MAXPATH = 260
    ffi.cdef([[
        typedef int mbstate_t;
        /*
        In VC2015, M$ change the definition of mbstate_t to this and breaks the ABI.
        */
        typedef struct _Mbstatet
        { // state of a multibyte translation
            unsigned long _Wchar;
            unsigned short _Byte, _State;
        } _Mbstatet;
        typedef _Mbstatet mbstate_t;

        size_t mbrtowc(wchar_t* pwc,
            const char* s,
            size_t n,
            mbstate_t* ps);
    ]])

    function wchar_t(s)
        local mbstate = ffi.new('mbstate_t[1]')
        local wcs = ffi.new('wchar_t[?]', #s + 1)
        local i = 0
        local offset = 0
        local len = #s
        while true do
            local processed = lib.mbrtowc(
                wcs + i, ffi.cast('const char *', s) + offset, len, mbstate)
            if processed <= 0 then break end
            i = i + 1
            offset = offset + processed
            len = len - processed
        end
        return wcs
    end

elseif OS == 'Linux' then
    MAXPATH = 4096
else
    MAXPATH = 1024
end

-- misc
if OS == "Windows" then
    local utime_def
    if IS_64_BIT then
        utime_def = [[
            typedef __int64 time_t;
            struct __utimebuf64 {
                time_t actime;
                time_t modtime;
            };
            typedef struct __utimebuf64 utimebuf;
            int _utime64(unsigned char *file, utimebuf *times);
        ]]
    else
        utime_def = [[
            typedef __int32 time_t;
            struct __utimebuf32 {
                time_t actime;
                time_t modtime;
            };
            typedef struct __utimebuf32 utimebuf;
            int _utime632(unsigned char *file, utimebuf *times);
        ]]
    end

    ffi.cdef([[
        char *_getcwd(char *buf, size_t size);
        wchar_t *_wgetcwd(wchar_t *buf, size_t size);
        int _chdir(const char *path);
        int _wchdir(const wchar_t *path);
        int _rmdir(const char *pathname);
        int _wrmdir(const wchar_t *pathname);
        int _mkdir(const char *pathname);
        int _wmkdir(const wchar_t *pathname);
        ]] .. utime_def .. [[
        typedef wchar_t* LPTSTR;
        typedef unsigned char BOOLEAN;
        typedef unsigned long DWORD;
        BOOLEAN CreateSymbolicLinkW(
            LPTSTR lpSymlinkFileName,
            LPTSTR lpTargetFileName,
            DWORD dwFlags
        );

        int _fileno(struct FILE *stream);
        int _setmode(int fd, int mode);
    ]])
    
    ffi.cdef([[

    size_t wcslen(const wchar_t *str);
    wchar_t *wcsncpy(wchar_t *strDest, const wchar_t *strSource, size_t count);
    
    int WideCharToMultiByte(
        unsigned int     CodePage,
        DWORD    dwFlags,
        const wchar_t*  lpWideCharStr,
        int      cchWideChar,
        char*    lpMultiByteStr,
        int      cbMultiByte,
        const char*   lpDefaultChar,
        int*   lpUsedDefaultChar);
    
    int MultiByteToWideChar(
        unsigned int     CodePage,
        DWORD    dwFlags,
        const char*   lpMultiByteStr,
        int      cbMultiByte,
        wchar_t*   lpWideCharStr,
        int      cchWideChar);
    
    ]])
    ffi.cdef[[
        
        uint32_t GetLastError();
        uint32_t FormatMessageA(
            uint32_t dwFlags,
            const void* lpSource,
            uint32_t dwMessageId,
            uint32_t dwLanguageId,
            char* lpBuffer,
            uint32_t nSize,
            va_list *Arguments
        );
    ]]
    -- Some helper functions
    local function error_win(lvl)
        local errcode = ffi.C.GetLastError()
        local str = ffi.new("char[?]",1024)
        local FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000;
        local FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200;
        local numout = ffi.C.FormatMessageA(bit.bor(FORMAT_MESSAGE_FROM_SYSTEM,
            FORMAT_MESSAGE_IGNORE_INSERTS), nil, errcode, 0, str, 1023, nil)
        if numout == 0 then
            error("Windows Error: (Error calling FormatMessage)", lvl)
        else
            error("Windows Error: "..ffi.string(str, numout), lvl)
        end
    end
    local CP_UTF8 = 65001
    local WC_ERR_INVALID_CHARS = 0x00000080
    local MB_ERR_INVALID_CHARS  = 0x00000008
    function win_utf8_to_unicode(szUtf8)
        local dwFlags = _M.unicode_errors and MB_ERR_INVALID_CHARS or 0
        local nLenWchar = lib.MultiByteToWideChar(CP_UTF8, dwFlags, szUtf8, -1, nil, 0 );
        if nLenWchar ==0 then error_win(2) end
        local szUnicode = ffi.new("wchar_t[?]",nLenWchar)
        nLenWchar = lib.MultiByteToWideChar(CP_UTF8, dwFlags, szUtf8, -1, szUnicode, nLenWchar);
        if nLenWchar ==0 then error_win(2) end
        return szUnicode, nLenWchar
    end
    _M.win_utf8_to_unicode = win_utf8_to_unicode
    function win_unicode_to_utf8( szUnicode)
        local dwFlags = _M.unicode_errors and WC_ERR_INVALID_CHARS or 0
        local nLen = lib.WideCharToMultiByte(CP_UTF8, dwFlags, szUnicode, -1, nil, 0, nil, nil);
        if nLen ==0 then error_win(2) end
        local str = ffi.new("char[?]",nLen)
        nLen = lib.WideCharToMultiByte(CP_UTF8, dwFlags, szUnicode, -1, str, nLen, nil, nil);
        if nLen ==0 then error_win(2) end
        return str
    end
    _M.win_unicode_to_utf8 = win_unicode_to_utf8
    local CP_ACP = 0
    function _M.win_utf8_to_acp(utf)
        local szUnicode = win_utf8_to_unicode(utf)
        local dwFlags = _M.unicode_errors and WC_ERR_INVALID_CHARS or 0
        local nLen = lib.WideCharToMultiByte(CP_ACP, dwFlags, szUnicode, -1, nil, 0, nil, nil);
        if nLen ==0 then error_win(2) end
        local str = ffi.new("char[?]",nLen)
        nLen = lib.WideCharToMultiByte(CP_ACP, dwFlags, szUnicode, -1, str, nLen, nil, nil);
        if nLen ==0 then error_win(2) end
        return ffi_str(str)
    end
    function _M.chdir(path)
        if _M.unicode then
            local uncstr = win_utf8_to_unicode(path)
            if lib._wchdir(uncstr) == 0 then return true end
        else
            if type(path) ~= 'string' then
                error('path should be a string')
            end
            if lib._chdir(path) == 0 then
                return true
            end
        end
        return nil, errno()
    end

    function _M.currentdir()
        if _M.unicode then
            local buf = ffi.new("wchar_t[?]",MAXPATH_UNC)
            if lib._wgetcwd(buf, MAXPATH_UNC) ~= nil then
                local buf_utf = win_unicode_to_utf8(buf)
                return ffi_str(buf_utf)
            end
            error("error in currentdir")
        else
        local size = MAXPATH
        while true do
            local buf = ffi.new("char[?]", size)
            if lib._getcwd(buf, size) ~= nil then
                return ffi_str(buf)
            end
            local err = errno()
            if err ~= ERANGE then
                return nil, err
            end
            size = size * 2
        end
        end
    end

    function _M.mkdir(path)
        if _M.unicode then
            local unc_str = win_utf8_to_unicode(path)
            if lib._wmkdir(unc_str) == 0 then
                return true
            end
        else
            if type(path) ~= 'string' then
                error('path should be a string')
            end
            if lib._mkdir(path) == 0 then
                return true
            end
        end
        return nil, errno()
    end

    function _M.rmdir(path)
        if _M.unicode then
            local unc_str = win_utf8_to_unicode(path)
            if lib._wrmdir(unc_str) == 0 then
                return true
            end
        else
            if type(path) ~= 'string' then
                error('path should be a string')
            end
            if lib._rmdir(path) == 0 then
                return true
            end
        end
        return nil, errno()
    end

    function _M.touch(path, actime, modtime)
        local buf

        if type(actime) == "number" then
            modtime = modtime or actime
            buf = ffi.new("utimebuf")
            buf.actime  = actime
            buf.modtime = modtime
        end

        local p = ffi.new("unsigned char[?]", #path + 1)
        ffi.copy(p, path)
        local utime = IS_64_BIT and lib._utime64 or lib._utime32
        if utime(p, buf) == 0 then
            return true
        end
        return nil, errno()
    end

    function _M.setmode(file, mode)
        if io.type(file) ~= 'file' then
            error("setmode: invalid file")
        end
        if mode ~= nil and (mode ~= 'text' and mode ~= 'binary') then
            error('setmode: invalid mode')
        end
        mode = (mode == 'text') and 0x4000 or 0x8000
        local prev_mode = lib._setmode(lib._fileno(file), mode)
        if prev_mode == -1 then
            return nil, errno()
        end
        return true, (prev_mode == 0x4000) and 'text' or 'binary'
    end

    local function check_is_dir(path)
        return _M.attributes(path, 'mode') == 'directory' and 1 or 0
    end

    function _M.link(old, new)
        local is_dir = check_is_dir(old)
        if lib.CreateSymbolicLinkW(
                wchar_t(new),
                wchar_t(old), is_dir) ~= 0 then
            return true
        end
        return nil, errno()
    end

    local findfirst
    local findnext
    local wfindfirst
    local wfindnext
    if IS_64_BIT then
        ffi.cdef([[
            typedef struct _finddata64_t {
                uint64_t  attrib;
                uint64_t  time_create;
                uint64_t  time_access;
                uint64_t  time_write;
                uint64_t  size;
                char      name[]] .. MAXPATH ..[[];
            } _finddata_t;
            intptr_t _findfirst64(const char *filespec, _finddata_t *fileinfo);
            int _findnext64(intptr_t handle, _finddata_t *fileinfo);
            int _findclose(intptr_t handle);
            typedef struct _wfinddata_t { //is _wfinddata64_t
                uint64_t  attrib;
                uint64_t  time_create;
                uint64_t  time_access;
                uint64_t  time_write;
                uint64_t  size;
                wchar_t      name[]] .. MAXPATH ..[[];
            } _wfinddata_t;
            intptr_t _wfindfirst64(const wchar_t *filespec, struct _wfinddata_t *fileinfo);  
            int _wfindnext64(intptr_t handle,struct _wfinddata_t *fileinfo);  
                                                              
        ]])
        findfirst = lib._findfirst64
        findnext = lib._findnext64
        wfindfirst = lib._wfindfirst64
        wfindnext = lib._wfindnext64
    else
        ffi.cdef([[
            typedef struct _finddata32_t {
                uint32_t  attrib;
                uint32_t  time_create;
                uint32_t  time_access;
                uint32_t  time_write;
                uint32_t  size;
                char      name[]] .. MAXPATH ..[[];
            } _finddata_t;
            intptr_t _findfirst32(const char* filespec, _finddata_t* fileinfo);
            int _findnext32(intptr_t handle, _finddata_t *fileinfo);
            
            intptr_t _findfirst(const char* filespec, _finddata_t* fileinfo);
            int _findnext(intptr_t handle, _finddata_t *fileinfo);
            
            typedef struct _wfinddata_t {
                uint32_t  attrib;
                uint32_t  time_create;
                uint32_t  time_access;
                uint32_t  time_write;
                uint32_t  size;
                wchar_t      name[]] .. MAXPATH ..[[];
            } _wfinddata_t;
            intptr_t _wfindfirst(  
            const wchar_t *filespec,  
            struct _wfinddata_t *fileinfo   
            );
            intptr_t _wfindfirst32(  
                const wchar_t *filespec,  
                struct _wfinddata_t *fileinfo
            );  
            
            int _wfindnext(  
                intptr_t handle,  
                struct _wfinddata_t *fileinfo   
            );  
            int _wfindnext32(  
                intptr_t handle,  
                struct _wfinddata_t *fileinfo   
            );  
            int _findclose(intptr_t handle);
        ]])
        local ok
        ok,findfirst = pcall(function() return lib._findfirst32 end)
        if not ok then findfirst = lib._findfirst end
        ok,findnext = pcall(function() return lib._findnext32 end)
        if not ok then findnext = lib._findnext end
        ok,wfindfirst = pcall(function() return lib._wfindfirst end)
        if not ok then ok,wfindfirst = pcall(function() return lib._wfindfirst32 end) end
        if not ok then HAVE_WFINDFIRST = false end
        ok,wfindnext = pcall(function() return lib._wfindnext end)
        if not ok then ok,wfindnext = pcall(function() return lib._wfindnext32 end) end
    end

    local function findclose(dentry)
        if dentry and dentry.handle ~= -1 then
            lib._findclose(dentry.handle)
            dentry.handle = -1
        end
    end

    local dir_type = ffi.metatype("struct {intptr_t handle;}", {
        __gc = findclose
    })

    local function close(dir)
        findclose(dir._dentry)
        dir.closed = true
    end

    local function iterator(dir)
        if dir.closed ~= false then error("closed directory") end
        local entry = ffi.new("_finddata_t")
        if not dir._dentry then
            dir._dentry = ffi.new(dir_type)
            dir._dentry.handle = findfirst(dir._pattern, entry)
            if dir._dentry.handle == -1 then
                dir.closed = true
                return nil, errno()
            end
            return ffi_str(entry.name)
        end

        if findnext(dir._dentry.handle, entry) == 0 then
            return ffi_str(entry.name)
        end
        close(dir)
        return nil
    end
    
    local function witerator(dir)
        if dir.closed ~= false then error("closed directory") end
        local entry = ffi.new("_wfinddata_t")
        if not dir._dentry then
            dir._dentry = ffi.new(dir_type)
            local szPattern = win_utf8_to_unicode(dir._pattern);
            dir._dentry.handle = wfindfirst(szPattern, entry)
            if dir._dentry.handle == -1 then
                dir.closed = true
                return nil, errno()
            end
            local szName = win_unicode_to_utf8(entry.name)--, -1, szName, 512);
            return ffi_str(szName)
        end

        if wfindnext(dir._dentry.handle, entry) == 0 then
            local szName = win_unicode_to_utf8(entry.name)--, -1, szName, 512);
            return ffi_str(szName)
        end
        close(dir)
        return nil
    end

    local dirmeta = {__index = {
        next = iterator,
        close = close,
    }}

    function _M.sdir(path)
        if #path > MAXPATH - 2 then
            error('path too long: ' .. path)
        end
        local dir_obj = setmetatable({
            _pattern = path..'/*',
            closed  = false,
        }, dirmeta)
        return iterator, dir_obj
    end
    
    local wdirmeta = {__index = {
        next = witerator,
        close = close,
    }}

    function _M.wdir(path)
        if #path > MAXPATH - 2 then
            error('path too long: ' .. path)
        end
        local dir_obj = setmetatable({
            _pattern = path..'/*',
            closed  = false,
        }, wdirmeta)
        return witerator, dir_obj
    end
    
    function _M.dir(path)
        if _M.unicode then
            return _M.wdir(path)
        else
            return _M.sdir(path)
        end
    end
    
    ffi.cdef([[
        int _fileno(struct FILE *stream);
        int fseek(struct FILE *stream, long offset, int origin);
        long ftell(struct FILE *stream);
        int _locking(int fd, int mode, long nbytes);
    ]])

    local mode_ltype_map = {
        r = 2, -- LK_NBLCK
        w = 2, -- LK_NBLCK
        u = 0, -- LK_UNLCK
    }
    local SEEK_SET = 0
    local SEEK_END = 2

    local function lock(fh, mode, start, len)
        local lkmode = mode_ltype_map[mode]
        if not len or len <= 0 then
            if lib.fseek(fh, 0, SEEK_END) ~= 0 then
                return nil, errno()
            end
            len = lib.ftell(fh)
        end
        if not start or start <= 0 then
            start = 0
        end
        if lib.fseek(fh, start, SEEK_SET) ~= 0 then
            return nil, errno()
        end
        local fd = lib._fileno(fh)
        if lib._locking(fd, lkmode, len) == -1 then
            return nil, errno()
        end
        return true
    end

    function _M.lock(filehandle, mode, start, length)
        if mode ~= 'r' and mode ~= 'w' then
            error("lock: invalid mode")
        end
        if io.type(filehandle) ~= 'file' then
            error("lock: invalid file")
        end
        local ok, err = lock(filehandle, mode, start, length)
        if not ok then
            return nil, err
        end
        return true
    end

    function _M.unlock(filehandle, start, length)
        if io.type(filehandle) ~= 'file' then
            error("unlock: invalid file")
        end
        local ok, err = lock(filehandle, 'u', start, length)
        if not ok then
            return nil, err
        end
        return true
    end
else
    ffi.cdef([[
        char *getcwd(char *buf, size_t size);
        int chdir(const char *path);
        int rmdir(const char *pathname);
        typedef unsigned int mode_t;
        int mkdir(const char *pathname, mode_t mode);
        typedef size_t time_t;
        struct utimebuf {
            time_t actime;
            time_t modtime;
        };
        int utime(const char *file, const struct utimebuf *times);
        int link(const char *oldpath, const char *newpath);
        int symlink(const char *oldpath, const char *newpath);
    ]])

    function _M.chdir(path)
        if lib.chdir(path) == 0 then
            return true
        end
        return nil, errno()
    end

    function _M.currentdir()
        local size = MAXPATH
        while true do
            local buf = ffi.new("char[?]", size)
            if lib.getcwd(buf, size) ~= nil then
                return ffi_str(buf)
            end
            local err = errno()
            if err ~= ERANGE then
                return nil, err
            end
            size = size * 2
        end
    end

    function _M.mkdir(path, mode)
        if lib.mkdir(path, mode or 509) == 0 then
            return true
        end
        return nil, errno()
    end

    function _M.rmdir(path)
        if lib.rmdir(path) == 0 then
            return true
        end
        return nil, errno()
    end

    function _M.touch(path, actime, modtime)
        local buf

        if type(actime) == "number" then
            modtime = modtime or actime
            buf = ffi.new("struct utimebuf")
            buf.actime  = actime
            buf.modtime = modtime
        end

        local p = ffi.new("unsigned char[?]", #path + 1)
        ffi.copy(p, path)

        if lib.utime(p, buf) == 0 then
            return true
        end
        return nil, errno()
    end

    function _M.setmode()
        return true, "binary"
    end

    function _M.link(old, new, symlink)
        local f = symlink and lib.symlink or lib.link
        if f(old, new) == 0 then
            return true
        end
        return nil, errno()
    end

    local dirent_def
    if OS == 'OSX' or OS == 'BSD' then
        dirent_def = [[
            /* _DARWIN_FEATURE_64_BIT_INODE is NOT defined here? */
            struct dirent {
                uint32_t d_ino;
                uint16_t d_reclen;
                uint8_t  d_type;
                uint8_t  d_namlen;
                char d_name[256];
            };
        ]]
    else
        dirent_def = [[
            struct dirent {
                int64_t           d_ino;
                size_t           d_off;
                unsigned short  d_reclen;
                unsigned char   d_type;
                char            d_name[256];
            };
        ]]
    end
    ffi.cdef(dirent_def .. [[
        typedef struct  __dirstream DIR;
        DIR *opendir(const char *name);
        struct dirent *readdir(DIR *dirp);
        int closedir(DIR *dirp);
    ]])

    local function close(dir)
        if dir._dentry ~= nil then
            lib.closedir(dir._dentry)
            dir._dentry = nil
            dir.closed = true
        end
    end

    local function iterator(dir)
        if dir.closed ~= false then error("closed directory") end

        local entry = lib.readdir(dir._dentry)
        if entry ~= nil then
            return ffi_str(entry.d_name)
        else
            close(dir)
            return nil
        end
    end

    local dir_obj_type = ffi.metatype([[
        struct {
            DIR *_dentry;
            bool closed;
        }
    ]],
    {__index = {
        next = iterator,
        close = close,
    }, __gc = close
    })

    function _M.dir(path)
        local dentry = lib.opendir(path)
        if dentry == nil then
            error("cannot open "..path.." : "..errno())
        end
        local dir_obj = ffi.new(dir_obj_type)
        dir_obj._dentry = dentry
        dir_obj.closed = false;
        return iterator, dir_obj
    end

    local SEEK_SET = 0
    local F_SETLK = (OS == 'Linux') and 6 or 8
    local mode_ltype_map
    local flock_def
    if OS == 'Linux' then
        flock_def = [[
            struct flock {
                short int l_type;
                short int l_whence;
                int64_t l_start;
                int64_t l_len;
                int l_pid;
            };
        ]]
        mode_ltype_map = {
            r = 0, -- F_RDLCK
            w = 1, -- F_WRLCK
            u = 2, -- F_UNLCK
        }
    else
        flock_def = [[
            struct flock {
                int64_t l_start;
                int64_t l_len;
                int32_t l_pid;
                short   l_type;
                short   l_whence;
            };
        ]]
        mode_ltype_map = {
            r = 1, -- F_RDLCK
            u = 2, -- F_UNLCK
            w = 3, -- F_WRLCK
        }
    end

    ffi.cdef(flock_def..[[
        int fileno(struct FILE *stream);
        int fcntl(int fd, int cmd, ... /* arg */ );
        int unlink(const char *path);
    ]])

    local function lock(fd, mode, start, len)
        local flock = ffi.new('struct flock')
        flock.l_type = mode_ltype_map[mode]
        flock.l_whence = SEEK_SET
        flock.l_start = start or 0
        flock.l_len = len or 0
        if lib.fcntl(fd, F_SETLK, flock) == -1 then
            return nil, errno()
        end
        return true
    end

    function _M.lock(filehandle, mode, start, length)
        if mode ~= 'r' and mode ~= 'w' then
            error("lock: invalid mode")
        end
        if io.type(filehandle) ~= 'file' then
            error("lock: invalid file")
        end
        local fd = lib.fileno(filehandle)
        local ok, err = lock(fd, mode, start, length)
        if not ok then
            return nil, err
        end
        return true
    end

    function _M.unlock(filehandle, start, length)
        if io.type(filehandle) ~= 'file' then
            error("unlock: invalid file")
        end
        local fd = lib.fileno(filehandle)
        local ok, err = lock(fd, 'u', start, length)
        if not ok then
            return nil, err
        end
        return true
    end
end

-- lock related
local dir_lock_struct
local create_lockfile
local delete_lockfile

if OS == 'Windows' then
    ffi.cdef([[
        typedef const wchar_t* LPCWSTR;
        typedef struct _SECURITY_ATTRIBUTES {
            DWORD nLength;
            void *lpSecurityDescriptor;
            int bInheritHandle;
        } SECURITY_ATTRIBUTES;
        typedef SECURITY_ATTRIBUTES *LPSECURITY_ATTRIBUTES;
        void *CreateFileW(
            LPCWSTR lpFileName,
            DWORD dwDesiredAccess,
            DWORD dwShareMode,
            LPSECURITY_ATTRIBUTES lpSecurityAttributes,
            DWORD dwCreationDisposition,
            DWORD dwFlagsAndAttributes,
            void *hTemplateFile
        );

        int CloseHandle(void *hObject);
    ]])

    local GENERIC_WRITE = 0x40000000
    local CREATE_NEW = 1
    local FILE_NORMAL_DELETE_ON_CLOSE = 0x04000080

    dir_lock_struct = 'struct {void *lockname;}'

    function create_lockfile(dir_lock, _, lockname)
        lockname = wchar_t(lockname)
        dir_lock.lockname = lib.CreateFileW(lockname, GENERIC_WRITE, 0, nil, CREATE_NEW,
                FILE_NORMAL_DELETE_ON_CLOSE, nil)
        return dir_lock.lockname ~= ffi.cast('void*', -1)
    end

    function delete_lockfile(dir_lock)
        return lib.CloseHandle(dir_lock.lockname)
    end
else
    dir_lock_struct = 'struct {char *lockname;}'
    function create_lockfile(dir_lock, path, lockname)
        dir_lock.lockname = ffi.new('char[?]', #lockname + 1)
        ffi.copy(dir_lock.lockname, lockname)
        return lib.symlink(path, lockname) == 0
    end

    function delete_lockfile(dir_lock)
        return lib.unlink(dir_lock.lockname)
    end
end

local function unlock_dir(dir_lock)
    if dir_lock.lockname ~= nil then
        dir_lock:delete_lockfile()
        dir_lock.lockname = nil
    end
    return true
end

local dir_lock_type = ffi.metatype(dir_lock_struct,
    {__gc = unlock_dir,
    __index = {
        free = unlock_dir,
        create_lockfile = create_lockfile,
        delete_lockfile = delete_lockfile,
    }}
)

function _M.lock_dir(path, _)
    -- It's interesting that the lock_dir from vanilla lfs just ignores second paramter.
    -- So, I follow this behavior too :)
    local dir_lock = ffi.new(dir_lock_type)
    local lockname = path .. '/lockfile.lfs'
    if not dir_lock:create_lockfile(path, lockname) then
        return nil, errno()
    end
    return dir_lock
end

-- stat related
local stat_func
local lstat_func
if OS == 'Linux' then
    ffi.cdef([[
        long syscall(int number, ...);
    ]])
    local ARCH = ffi.arch
    -- Taken from justincormack/ljsyscall
    local stat_syscall_num
    local lstat_syscall_num
    if ARCH == 'x64' then
        ffi.cdef([[
            typedef struct {
                unsigned long   st_dev;
                unsigned long   st_ino;
                unsigned long   st_nlink;
                unsigned int    st_mode;
                unsigned int    st_uid;
                unsigned int    st_gid;
                unsigned int    __pad0;
                unsigned long   st_rdev;
                long            st_size;
                long            st_blksize;
                long            st_blocks;
                unsigned long   st_atime;
                unsigned long   st_atime_nsec;
                unsigned long   st_mtime;
                unsigned long   st_mtime_nsec;
                unsigned long   st_ctime;
                unsigned long   st_ctime_nsec;
                long            __unused[3];
            } lfs_stat;
        ]])
        stat_syscall_num = 4
        lstat_syscall_num = 6
    elseif ARCH == 'x86' then
        ffi.cdef([[
            typedef struct {
                unsigned long long      st_dev;
                unsigned char   __pad0[4];
                unsigned long   __st_ino;
                unsigned int    st_mode;
                unsigned int    st_nlink;
                unsigned long   st_uid;
                unsigned long   st_gid;
                unsigned long long      st_rdev;
                unsigned char   __pad3[4];
                long long       st_size;
                unsigned long   st_blksize;
                unsigned long long      st_blocks;
                unsigned long   st_atime;
                unsigned long   st_atime_nsec;
                unsigned long   st_mtime;
                unsigned int    st_mtime_nsec;
                unsigned long   st_ctime;
                unsigned long   st_ctime_nsec;
                unsigned long long      st_ino;
            } lfs_stat;
        ]])
        stat_syscall_num = IS_64_BIT and 106 or 195
        lstat_syscall_num = IS_64_BIT and 107 or 196
    elseif ARCH == 'arm' then
        if IS_64_BIT then
            ffi.cdef([[
                typedef struct {
                    unsigned long   st_dev;
                    unsigned long   st_ino;
                    unsigned int    st_mode;
                    unsigned int    st_nlink;
                    unsigned int    st_uid;
                    unsigned int    st_gid;
                    unsigned long   st_rdev;
                    unsigned long   __pad1;
                    long            st_size;
                    int             st_blksize;
                    int             __pad2;
                    long            st_blocks;
                    long            st_atime;
                    unsigned long   st_atime_nsec;
                    long            st_mtime;
                    unsigned long   st_mtime_nsec;
                    long            st_ctime;
                    unsigned long   st_ctime_nsec;
                    unsigned int    __unused4;
                    unsigned int    __unused5;
                } lfs_stat;
            ]])
            stat_syscall_num = 106
            lstat_syscall_num = 107
        else
            ffi.cdef([[
                typedef struct {
                    unsigned long long      st_dev;
                    unsigned char   __pad0[4];
                    unsigned long   __st_ino;
                    unsigned int    st_mode;
                    unsigned int    st_nlink;
                    unsigned long   st_uid;
                    unsigned long   st_gid;
                    unsigned long long      st_rdev;
                    unsigned char   __pad3[4];
                    long long       st_size;
                    unsigned long   st_blksize;
                    unsigned long long      st_blocks;
                    unsigned long   st_atime;
                    unsigned long   st_atime_nsec;
                    unsigned long   st_mtime;
                    unsigned int    st_mtime_nsec;
                    unsigned long   st_ctime;
                    unsigned long   st_ctime_nsec;
                    unsigned long long      st_ino;
                } lfs_stat;
            ]])
            stat_syscall_num = 195
            lstat_syscall_num = 196
        end
    elseif ARCH == 'ppc' or ARCH == 'ppcspe' then
        ffi.cdef([[
            typedef struct {
                unsigned long long st_dev;
                unsigned long long st_ino;
                unsigned int    st_mode;
                unsigned int    st_nlink;
                unsigned int    st_uid;
                unsigned int    st_gid;
                unsigned long long st_rdev;
                unsigned long long __pad1;
                long long       st_size;
                int             st_blksize;
                int             __pad2;
                long long       st_blocks;
                int             st_atime;
                unsigned int    st_atime_nsec;
                int             st_mtime;
                unsigned int    st_mtime_nsec;
                int             st_ctime;
                unsigned int    st_ctime_nsec;
                unsigned int    __unused4;
                unsigned int    __unused5;
            } lfs_stat;
        ]])
        stat_syscall_num = IS_64_BIT and 106 or 195
        lstat_syscall_num = IS_64_BIT and 107 or 196
    elseif ARCH == 'mips' or ARCH == 'mipsel' then
        ffi.cdef([[
            typedef struct {
                unsigned long   st_dev;
                unsigned long   __st_pad0[3];
                unsigned long long      st_ino;
                mode_t          st_mode;
                nlink_t         st_nlink;
                uid_t           st_uid;
                gid_t           st_gid;
                unsigned long   st_rdev;
                unsigned long   __st_pad1[3];
                long long       st_size;
                time_t          st_atime;
                unsigned long   st_atime_nsec;
                time_t          st_mtime;
                unsigned long   st_mtime_nsec;
                time_t          st_ctime;
                unsigned long   st_ctime_nsec;
                unsigned long   st_blksize;
                unsigned long   __st_pad2;
                long long       st_blocks;
                long __st_padding4[14];
            } lfs_stat;
        ]])
        stat_syscall_num = IS_64_BIT and 4106 or 4213
        lstat_syscall_num = IS_64_BIT and 4107 or 4214
    end

    if stat_syscall_num then
        stat_func = function(filepath, buf)
            return lib.syscall(stat_syscall_num, filepath, buf)
        end
        lstat_func = function(filepath, buf)
            return lib.syscall(lstat_syscall_num, filepath, buf)
        end
    else
        ffi.cdef('typedef struct {} lfs_stat;')
        stat_func = function() error("TODO support other Linux architectures") end
        lstat_func = stat_func
    end
elseif OS == 'Windows' then
    ffi.cdef([[
        typedef __int64 __time64_t;
        typedef struct {
            unsigned int        st_dev;
            unsigned short      st_ino;
            unsigned short      st_mode;
            short               st_nlink;
            short               st_uid;
            short               st_gid;
            unsigned int        st_rdev;
            __int64             st_size;
            __time64_t          st_atime;
            __time64_t          st_mtime;
            __time64_t          st_ctime;
        } lfs_stat;

        int _stat64(const char *path, lfs_stat *buffer);
        int _wstat64(const wchar_t *path, lfs_stat *buffer);      
    ]])

    stat_func = function(filepath, buf)
        if _M.unicode then
            local szfp = win_utf8_to_unicode(filepath);
            return lib._wstat64(szfp, buf)
        else
            return lib._stat64(filepath, buf)
        end
    end
    lstat_func = stat_func
elseif OS == 'OSX' then
    ffi.cdef([[
        struct lfs_timespec {
            time_t tv_sec;
            long tv_nsec;
        };
        typedef struct {
            uint32_t           st_dev;
            uint16_t          st_mode;
            uint16_t         st_nlink;
            uint64_t         st_ino;
            uint32_t           st_uid;
            uint32_t           st_gid;
            uint32_t           st_rdev;
            struct lfs_timespec st_atimespec;
            struct lfs_timespec st_mtimespec;
            struct lfs_timespec st_ctimespec;
            struct lfs_timespec st_birthtimespec;
            int64_t           st_size;
            int64_t        st_blocks;
            int32_t       st_blksize;
            uint32_t        st_flags;
            uint32_t        st_gen;
            int32_t         st_lspare;
            int64_t         st_qspare[2];
        } lfs_stat;
        int stat64(const char *path, lfs_stat *buf);
        int lstat64(const char *path, lfs_stat *buf);
    ]])
    stat_func = lib.stat64
    lstat_func = lib.lstat64
elseif OS == 'BSD' then
    ffi.cdef([[
        struct lfs_timespec {
            time_t tv_sec;
            long tv_nsec;
        };
        typedef struct {
            uint32_t           st_dev;
            uint32_t         st_ino;
            uint16_t          st_mode;
            uint16_t         st_nlink;
            uint32_t           st_uid;
            uint32_t           st_gid;
            uint32_t           st_rdev;
            struct lfs_timespec st_atimespec;
            struct lfs_timespec st_mtimespec;
            struct lfs_timespec st_ctimespec;
            int64_t           st_size;
            int64_t        st_blocks;
            int32_t       st_blksize;
            uint32_t        st_flags;
            uint32_t        st_gen;
            int32_t         st_lspare;
            struct lfs_timespec st_birthtimespec;
        } lfs_stat;
        int stat(const char *path, lfs_stat *buf);
        int lstat(const char *path, lfs_stat *buf);
    ]])
    stat_func = lib.stat
    lstat_func = lib.lstat
else
    ffi.cdef('typedef struct {} lfs_stat;')
    stat_func = function() error('TODO: support other posix system') end
    lstat_func = stat_func
end

local STAT = {
    FMT   = 0xF000,
    FSOCK = 0xC000,
    FLNK  = 0xA000,
    FREG  = 0x8000,
    FBLK  = 0x6000,
    FDIR  = 0x4000,
    FCHR  = 0x2000,
    FIFO  = 0x1000,
}

local ftype_name_map = {
    [STAT.FREG]  = 'file',
    [STAT.FDIR]  = 'directory',
    [STAT.FLNK]  = 'link',
    [STAT.FSOCK] = 'socket',
    [STAT.FCHR]  = 'char device',
    [STAT.FBLK]  = "block device",
    [STAT.FIFO]  = "named pipe",
}

local function mode_to_ftype(mode)
    local ftype = band(mode, STAT.FMT)
    return ftype_name_map[ftype] or 'other'
end

local function mode_to_perm(mode)
    local perm_bits = band(mode, tonumber(777, 8))
    local perm = new_tab(9, 0)
    local i = 9
    while i > 0 do
        local perm_bit = band(perm_bits, 7)
        perm[i] = (band(perm_bit, 1) > 0 and 'x' or '-')
        perm[i-1] = (band(perm_bit, 2) > 0 and 'w' or '-')
        perm[i-2] = (band(perm_bit, 4) > 0 and 'r' or '-')
        i = i - 3
        perm_bits = rshift(perm_bits, 3)
    end
    return concat(perm)
end

local function time_or_timespec(time, timespec)
    local t = tonumber(time)
    if not t and timespec then
        t = tonumber(timespec.tv_sec)
    end
    return t
end

local attr_handlers = {
    access = function(st) return time_or_timespec(st.st_atime, st.st_atimespec) end,
    blksize = function(st) return tonumber(st.st_blksize) end,
    blocks = function(st) return tonumber(st.st_blocks) end,
    change = function(st) return time_or_timespec(st.st_ctime, st.st_ctimespec) end,
    dev = function(st) return tonumber(st.st_dev) end,
    gid = function(st) return tonumber(st.st_gid) end,
    ino = function(st) return tonumber(st.st_ino) end,
    mode = function(st) return mode_to_ftype(st.st_mode) end,
    modification = function(st) return time_or_timespec(st.st_mtime, st.st_mtimespec) end,
    nlink = function(st) return tonumber(st.st_nlink) end,
    permissions = function(st) return mode_to_perm(st.st_mode) end,
    rdev = function(st) return tonumber(st.st_rdev) end,
    size = function(st) return tonumber(st.st_size) end,
    uid = function(st) return tonumber(st.st_uid) end,
}
local mt = {
    __index = function(self, attr_name)
        local func = attr_handlers[attr_name]
        return func and func(self)
    end
}
local stat_type = ffi.metatype('lfs_stat', mt)

-- Add target field for symlinkattributes, which is the absolute path of linked target
local get_link_target_path
if OS == 'Windows' then
    local ENOSYS = 40
    function get_link_target_path()
        return nil, "could not obtain link target: Function not implemented ",ENOSYS
    end
else

    ffi.cdef('ssize_t readlink(const char *path, char *buf, size_t bufsize);')
    local EINVAL = 22
    function get_link_target_path(link_path, statbuf)
        local size = statbuf.st_size
        size = size == 0 and MAXPATH or size
        local buf = ffi.new('char[?]', size + 1)
        local read = lib.readlink(link_path, buf, size)
        if read == -1 then
            return nil, "could not obtain link target: "..errno(), ffi.errno()
        end
        if read > size then
            return nil, "not enought size for readlink: "..errno(), ffi.errno()
        end
        buf[size] = 0
        return ffi_str(buf)
    end
end

local buf = ffi.new(stat_type)
local function attributes(filepath, attr, follow_symlink)
    local func = follow_symlink and stat_func or lstat_func
    if func(filepath, buf) == -1 then
        return nil, string.format("cannot obtain information from file '%s' : %s",tostring(filepath),errno()), ffi.errno()
    end

    local atype = type(attr)
    if atype == 'string' then
        local value, err, errn
        if attr == 'target' and not follow_symlink then
            value, err, errn = get_link_target_path(filepath, buf)
            return value, err, errn
        else
            value = buf[attr]
        end
        if value == nil then
            error("invalid attribute name '" .. attr .. "'")
        end
        return value
    else
        local tab = (atype == 'table') and attr or {}
        for k, _ in pairs(attr_handlers) do
            tab[k] = buf[k]
        end
        if not follow_symlink then
            tab.target = get_link_target_path(filepath, buf)
        end
        return tab
    end
end

function _M.attributes(filepath, attr)
    return attributes(filepath, attr, true)
end

function _M.symlinkattributes(filepath, attr)
    return attributes(filepath, attr, false)
end

_M.unicode = HAVE_WFINDFIRST
_M.unicode_errors = false
--this would error with _M.unicode_errors = true
--local cad = string.char(0xE0,0x80,0x80)--,0xFD,0xFF)

lfs = _M


end
































































































































--Utils



--string

String = {}
String.Split=function(a,b)local c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end
String.Trim=function(s)local a=s:gsub("^%s*(.-)%s*$", "%1")return a end
String.TrimLeft=function(s)local a=s:gsub("^%s*(.-)$", "%1")return a end
String.TrimRight=function(s)local a=s:gsub("^(.-)%s*$", "%1")return a end
String.StartsWith=function(a,b)return a:sub(1,#b)==b end
String.EndsWith=function(a,b)return a:sub(-#b,-1)==b end








--table

--http://lua-users.org/wiki/CopyTable
--Supply ONLY 1 Argument
Table = {}
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



--number

ClipN = function(n, a, b)
    if n < a then
        return a
    elseif n > b then
        return b
    else
        return n
    end
end








--error

function Error(msg)
    --error(msg, 2) --Add error position info
    error(msg, 0) --Don't add error position info
    --print(msg)
    
    --[[
    if msg:sub(-1, -1) == '@' then
        if LastSongName ~= SongName then
            print('\n' .. SongName)
        end
        print(msg)
        LastSongName = SongName
    end
    --]]
end

--[[
LastSongName = nil
SongName = ''
--]]
LineN = nil
function ParseError(cmd, msg, data)
    --Error(cmd .. ': ' .. msg .. (data and (', ' .. data) or ''))
    Error('Line: ' .. LineN .. '\n' .. cmd .. ': ' .. msg .. (data and (', ' .. data) or ''))
end












--Time Utils

function MsToS(ms)
    return ms / 1000
end

function SToMs(s)
    return s * 1000
end


--[[
Hex to RGB Modified
https://gist.github.com/fernandohenriques/12661bf250c8c2d8047188222cab7e28
]]
function HexToRGB(hex)
    --[[
        rgb -> [0, 255]
    ]]
    hex = string.gsub(hex, '#', '')
    if #hex == 3 then
        --return (tonumber('0x' .. string.sub(hex, 1, 1)) * 17), (tonumber('0x' .. string.sub(hex, 2, 2)) * 17), (tonumber('0x' .. string.sub(hex, 3, 3)) * 17)
        return (tonumber(string.sub(hex, 1, 1), 16) * 17), (tonumber(string.sub(hex, 2, 2), 16) * 17), (tonumber(string.sub(hex, 3, 3), 16) * 17)
    else
        --return (tonumber('0x' .. string.sub(hex, 1, 2))), (tonumber('0x' .. string.sub(hex, 3, 4))), (tonumber('0x' .. string.sub(hex, 5, 6)))
        return (tonumber(string.sub(hex, 1, 2), 16)), (tonumber(string.sub(hex, 3, 4), 16)), (tonumber(string.sub(hex, 5, 6), 16))
    end
end



















Taiko = {}



--[[
https://github.com/bui/taiko-web/wiki/TJA-format
https://whmhammer.github.io/tja-tools/
https://github.com/WHMHammer/tja-tools/blob/master/src/js/parseTJA.js
https://github.com/bui/taiko-web/blob/master/public/src/js/parsetja.js

Steps:
Parse Metadata (Settings)
Parse Measures

Metadata:
[] = required, () = optional
[TITLE,TITLEEN,TITLEJA,TITLECN,TITLETW,TITLEKO]
(SUBTITLE,SUBTITLEEN,SUBTITLEJA,SUBTITLECN,SUBTITLETW,SUBTITLEKO)
(BPM) default:120
(WAVE)
(OFFSET) default:0
(DEMOSTART) default:0
(GENRE)
(SCOREMODE) default:1
(MAKER) -> (MAKER<URL>)
(LYRICS) overrides #LYRICS
(SONGVOL) default:100
(SEVOL) default:100
(SIDE) ignored
(LIFE) default:0
(GAME) default:Taiko
(HEADSCROLL) default:1
(BGIMAGE) ignored
(BGMOVIE) ignored
(MOVIEOFFSET) ignored
(TAIKOWEBSKIN) ignored



Courses for each difficulty has the same format as the regular metadata, they can be mixed together with the regular metadata and old values will be reused for other courses unless defined again.

Course Metadata:
[COURSE] default:Oni
[LEVEL]
(BALLOON)
(SCOREINIT)
(SCOREDIFF)
(BALLOONNOR,BALLOONEXP,BALLOONMAS)
(STYLE)
(EXAM1,EXAM2,EXAM3)
(GAUGEINCR)
(TOTAL)
(HIDDENBRANCH)



gogo can be infered from note data, but events make it easier



scroll and bpm

scroll = just speed, no change of note ms
bpm = change of note ms






distance between notes and speed of notes

perfectly touching at
8 notes at 0.5 scroll
16 notes at 1 scroll
32 notes at 2 scroll



]]

Taiko.Data = {
    Languages = {'', 'EN', 'JA', 'CN', 'TW', 'KO'}, --Order as order of desiredness
    GenreAlias = {
        --https://github.com/bui/taiko-web/wiki/TJA-format#genre-i
        --Custom genres are also supported
        Pop = {'pop', 'j-pop'},
        Anime = {'anime', 'アニメ'},
        Kids = {'kids', 'どうよう'}, --from taiko-web TJA specifications
        Variety = {'variety', 'バラエティ'},
        VOCALOID = {'vocaloid', 'ボーカロイド'},
        Classic = {'classic', 'クラシック'},
        ['Game Music'] = {'game music', 'ゲームミュージック'},
        ['Namco Original'] = {'namco original', 'ナムコオリジナル'}
    },
    --[[
    GenreName = {
        [0] = 'Custom',
        [1] = 'Pop',
        [2] = 'Kids',
        [3] = 'Anime',
        [4] = 'Classic',
        [5] = 'Game Music',
        [6] = 'VOCALOID',
        [7] = 'Variety',
        [8] = 'Namco Original'
    }
    GenreId = {

    }
    --]]
    CourseId = {
        easy = 0,
        normal = 1,
        hard = 2,
        oni = 3,
        edit = 4,
        tower = 5,
        dan = 6,
        ura = 4
    },
    CourseName = {
        [0] = 'Easy', 'Normal', 'Hard', 'Oni', 'Edit', 'Tower', 'Dan', 'Ura'
    },
    RatingMultiplier = {
        [0] = 0,
        [1] = 0.5,
        [2] = 1,
        [3] = 2
    },
    GogoMultiplier = 1.2,
    ScoreMode = {
        Note = {
            --combo: current combo, added note
            --status: 0 = bad, 1 = ok, 2 = good, 3 = biggood
            [0] = function(score, combo, init, diff, status, gogo)
                --https://github.com/bui/taiko-web/wiki/TJA-format#scoremode
                --[[
                local a = nil
                if combo < 200 then
                    a = (init or 1000)
                else
                    a = (init or 1000) + (diff or 1000)
                end
                score = score + (a * Taiko.Data.RatingMultiplier[status])
                --]]


                return math.floor((score + (((combo < 200) and (init or 1000) or ((init or 1000) + (diff or 1000))) * Taiko.Data.RatingMultiplier[status] * (gogo and Taiko.Data.GogoMultiplier or 1))) / 10) * 10
            end,
            [1] = function(score, combo, init, diff, status, gogo)
                --https://github.com/bui/taiko-web/wiki/TJA-format#scoremode
                --INIT + max(0, DIFF * floor((min(COMBO, 100) - 1) / 10))
                return math.floor((score + ((init + math.max(0, diff * math.floor((math.min(combo, 100) - 1) / 10))) * Taiko.Data.RatingMultiplier[status] * (gogo and Taiko.Data.GogoMultiplier or 1))) / 10) * 10
            end,
            [2] = function(score, combo, init, diff, status, gogo)
                --https://github.com/bui/taiko-web/wiki/TJA-format#scoremode
                --INIT + DIFF * {100<=COMBO: 8, 50<=COMBO: 4, 30<=COMBO: 2, 10<=COMBO: 1, 0}
                return math.floor((score + ((init + diff * ((combo >= 100) and 8 or (combo >= 50) and 4 or (combo >= 30) and 2 or (combo >= 10) and 1 or 0)) * Taiko.Data.RatingMultiplier[status] * (gogo and Taiko.Data.GogoMultiplier or 1))) / 10) * 10
            end
        },
        Drumroll = {
            [0] = function(score, notetype, gogo)
                --https://www.youtube.com/watch?v=tsrP10HpNk0&list=PLDAsXb4iso2c_J51wrq4IrP_SkaiYXBdF
                --checked a video in slow motion
                --300 normal, 600 bi
                return score + ((notetype == 5 and 300 or notetype == 6 and 600) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [1] = function(score, notetype, gogo)
                --https://taikotime.blogspot.com/2010/08/advanced-rules.html
                --300 normal, 600 big
                return score + ((notetype == 5 and 300 or notetype == 6 and 600) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [2] = function(score, notetype, gogo)
                --https://taikotime.blogspot.com/2010/08/advanced-rules.html
                --100 normal, 200 big
                return score + ((notetype == 5 and 100 or notetype == 6 and 200) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end
        },
        Balloon = {
            [0] = function(score, notetype, gogo)
                --https://www.youtube.com/watch?v=tsrP10HpNk0&list=PLDAsXb4iso2c_J51wrq4IrP_SkaiYXBdF
                --checked a video in slow motion
                --for last balloon, call balloon and balloonpop
                return score + ((notetype == 7 and 300) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [1] = function(score, notetype, gogo)
                --https://youtu.be/aRyHC00qMY4?t=61
                --checked a video in slow motion
                --for last balloon, call balloon and balloonpop
                return score + ((notetype == 7 and 300) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [2] = function(score, notetype, gogo)
                --https://taikotime.blogspot.com/2010/08/advanced-rules.html
                --for last balloon, call balloon and balloonpop
                return score + ((notetype == 7 and 300) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end
        },
        BalloonPop = {
            [0] = function(score, notetype, gogo)
                --https://www.youtube.com/watch?v=tsrP10HpNk0&list=PLDAsXb4iso2c_J51wrq4IrP_SkaiYXBdF
                --checked a video in slow motion
                --for last balloon, call balloon and balloonpop
                return score + ((notetype == 7 and 5000) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [1] = function(score, notetype, gogo)
                --https://taikotime.blogspot.com/2010/08/advanced-rules.html
                --for last balloon, call balloon and balloonpop
                return score + ((notetype == 7 and 5000) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [2] = function(score, notetype, gogo)
                --https://taikotime.blogspot.com/2010/08/advanced-rules.html
                --for last balloon, call balloon and balloonpop
                return score + ((notetype == 7 and 5000) * (gogo and Taiko.Data.GogoMultiplier or 1))
            end
        }
    },
    Autoscore = { --TODO
        [0] = function(Parsed)
            --https://youtu.be/4diqeVUp_NI?list=PLDAsXb4iso2ff7y8rI1zzOFCfKbnVYmkH&t=148
        end,
        [1] = function(Parsed)

        end,
        [2] = function(Parsed)

        end
    },
    SideId = {
        normal = 1,
        ex = 2,
        both = 3
    },
    SideName = {
        'normal',
        'ex',
        'both'
    },
    StyleId = {
        single = 1,
        double = 2,
        couple = 2
    },
    StyleName = {
        'single', 'double'
    },
    Exam = {
        Condition = {
            g = true,
            jp = true,
            jg = true,
            jb = true,
            s = true,
            r = true,
            h = true,
            c = true
        },
        Scope = {
            m = true,
            l = true
        }
    },
    Branch = {
        PathId = {
            N = 0,
            E = 1,
            M = 2
        },
        PathName = {
            [0] = 'N',
            [1] = 'E',
            [2] = 'M'
        },
        Requirements = {
            r = function()
                --TODO
            end,
            p = function()

            end
        }
    },
    Timing = {
        --[[
        GetFunction = function(course)
            return function(framems)
                --https://github.com/bui/taiko-web/blob/ba1a6ab3068af8d5f8d3c5e81380957493ebf86b/public/src/js/gamerules.js
                if course == 0 or course == 1 then
                    return {
                        good = 5 / 2 * framems,
                        ok = 13 / 2 * framems,
                        bad = 15 / 2 * framems
                    }
                else
                    return {
                        good = 3 / 2 * framems,
                        ok = 9 / 2 * framems,
                        bad = 13 / 2 * framems
                    }
                end
            end
        end
        --]]
            --[[
All timing/judge zones (Good, Ok, Bad; in ms) : 
75, 108, 125　Lv0 
58, 108, 125　Lv1 
42, 108, 125　Lv2 (Easy Normal)　
42, 75, 108　Lv3 
25, 75, 108　Lv4 (Hard Extreme)　
25, 58, 108　 Lv5 
17, 42, 108　Lv6

Timing mods alter the judge zone level by the following :
Loose : -2
Lenient : -1
Normal : 0
Strict : 1
Rigorous : 2
Setting a lower level judge zone gives you a score and coin malus, higher level judge zone a noticeable coin bonus 

--Opentaiko Dev
--https://discord.com/channels/906882956272992287/925314069236420618/1006074367475732550
            ]]
        Level = {
            [0] = {good = 75, ok = 108, bad = 125},
            [1] = {good = 58, ok = 108, bad = 125},
            [2] = {good = 42, ok = 108, bad = 125}, --easy, normal
            [3] = {good = 42, ok = 75, bad = 108},
            [4] = {good = 25, ok = 75, bad = 108}, --hard, oni
            [5] = {good = 25, ok = 58, bad = 108},
            [6] = {good = 17, ok = 42, bad = 108}
        },
        Course = function(course)
            if course == 0 or course == 1 then
                return 2
            else
                return 4
            end
        end
    },
    StatusId = {
        bad = 0,
        ok = 1,
        good = 2,
        biggood = 3
    },
    StatusName = {
        [0] = 'BAD',
        [1] = 'OK',
        [2] = 'GOOD',
        [3] = 'GOOD'
    },
    ModeId = {
        [''] = 0,
        P1 = 1,
        P2 = 2
    },
    ModeName = {
        [0] = '',
        'P1',
        'P2'
    },
    Combo = { --Notes that affect combo
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    },
    BigLeniency = 2, --How much times easier to hit (x Timing)
    Gauge = {
        --https://github.com/bui/taiko-web/blob/c01f30b34a846a37680cb1a45a4501ed5ee071d3/public/src/js/gamerules.js#L44
        --[[

        ]]
        Soul = {
            [0] = function(combo)
                local good = 10000 / combo * 1.575
                local ok = good * 0.75
                local bad = good / -2
                return {
                    [2] = good,
                    [1] = ok,
                    [0] = bad
                }
            end,
            [1] = function(combo)
                local good = 10000 / combo / 0.7
                local ok = good * 0.75
                local bad = good / -0.75
                return {
                    [2] = good,
                    [1] = ok,
                    [0] = bad
                }
            end,
            [2] = function(combo)
                local good = 10000 / combo * 1.5
                local ok = good * 0.75
                local bad = good / -0.8
                return {
                    [2] = good,
                    [1] = ok,
                    [0] = bad
                }
            end,
            [3] = function(combo)
                local good = 10000 / combo / 0.7
                local ok = good * 0.5
                local bad = good * -1.6
                return {
                    [2] = good,
                    [1] = ok,
                    [0] = bad
                }
            end,
            [4] = function(combo)
                local good = 10000 / combo / 0.7
                local ok = good * 0.5
                local bad = good * -1.6
                return {
                    [2] = good,
                    [1] = ok,
                    [0] = bad
                }
            end
        },
        --[[
            not percent, but in normal number form
        ]]
        Percent = function(soul)
            return (soul / 200) / 50
        end,
        ClearPercent = 0.8,
        OverflowPercent = 1
    },
    --SENotes.png
    --1 is topmost
    SENotes = {

        --Note = {note1, ex_note1, ex_note2}
        [1] = {1, 2, 3},
        [2] = {4, 5},
        [3] = {6, 6, 6},
        [4] = {7, 7},

        --Drumroll = {start, middle, end}
        [5] = {8, 9, 10},
        [6] = {11, 9, 10},

        --Balloon = {balloon}
        [7] = {12}
    },








    --Utility data for notes
    --Currently only supports 0-9, check for nil
    Notes = {
        ReverseNotes = {
            [0] = 0,
            [1] = 2,
            [2] = 1,
            [3] = 4,
            [4] = 3,
            [5] = 5,
            [6] = 6,
            [7] = 7,
            [8] = 8,
            [9] = 9,
        }
    },
    BigNoteMul = 1.5, --1.6 with pixels, 1.5 with raylib






    --[[
    --Strings
    --https://github.com/bui/taiko-web/blob/master/public/src/js/strings.js
    Strings = {
        Notes = {
            --TODO
        }
    }
    --]]
}



--Wrap scoring
--[[
for k, v in pairs(Taiko.Data.ScoreMode.Note) do
    Taiko.Data.ScoreMode.Note[k] = function(...)
        return math.floor(v(...) / 10) * 10
    end
end
--]]



























function Taiko.ReplaceNewline(source)
    --CRLF to LF
    return string.gsub(source, '\r\n', '\n')
end










--WEBVTT Parser

--[[
    https://www.w3.org/TR/webvtt1/#file-structure
    https://www.w3.org/TR/webvtt1/#webvtt-parser
    
    For the parser, the bare minimum is implemented
]]

local function FromTimestamp(timestamp)
    --The most non-conforming timestamp parser ever
    local h, m, s, ms = string.match(timestamp, '(..)%:(..)%:(..)%.(...)')

    if not h then
        h = '00'
        m, s, ms = string.match(timestamp, '(..)%:(..)%.(...)')
    end

    h, m, s, ms = tonumber(h), tonumber(m), tonumber(s), tonumber(ms)

    return h * 60 * 60 * 1000 + m * 60 * 1000 + s * 1000 + ms
end

function Taiko.ParseWebVTT(source)
    --[[
        NON-CONFORMING, BARE MINIMUM
    ]]
    local Lyric = {}

    source = source .. '\n\n'
    string.gsub(source, '\n([%d%:%.]+)[ \t]-%-%-%>[ \t]-([%d%:%.]+)\n(.-)\n', function(starttime, endtime, data)
        --print(starttime, endtime, data)
        local s, e = FromTimestamp(starttime), FromTimestamp(endtime)
        Lyric[#Lyric + 1] = {
            ms = s,
            lengthms = e,
            data = data
        }
    end)

    return Lyric
end















local function ToTimestamp(ms)
    --https://www.w3.org/TR/webvtt1/#webvtt-timestamp
    local hours = math.floor(ms / (1000 * 60 * 60))
    local minutes = math.floor((ms % (1000 * 60 * 60)) / (1000 * 60))
    local seconds = math.floor((ms % (1000 * 60)) / (1000))
    local milliseconds = math.floor((ms % (1000)) / (1))
    
    local out = {}

    --[[
    1. Optionally (required if hours is non-zero):
        1. Two or more ASCII digits, representing the hours as a base ten integer.
        2. A U+003A COLON character (:)
    ]]
    if hours ~= 0 then
        local a = tostring(hours)
        if #a >= 2 then
            --Valid
        else
            out[#out + 1] = '0'
        end
        out[#out + 1] = a
        out[#out + 1] = ':'
    else
        out[#out + 1] = '00:'
    end

    --[[
        2. Two ASCII digits, representing the minutes as a base ten integer in the range 0 ≤ minutes ≤ 59.
        3. A U+003A COLON character (:)
    ]]
    local a = tostring(minutes)
    if #a >= 2 then
        --Valid
    else
        out[#out + 1] = '0'
    end
    out[#out + 1] = a
    out[#out + 1] = ':'

    --[[
        4. Two ASCII digits, representing the seconds as a base ten integer in the range 0 ≤ seconds ≤ 59.
        5. A U+002E FULL STOP character (.).
    ]]
    local a = tostring(seconds)
    if #a >= 2 then
        --Valid
    else
        out[#out + 1] = '0'
    end
    out[#out + 1] = a
    out[#out + 1] = '.'

    --[[
        6. Three ASCII digits, representing the thousandths of a second seconds-frac as a base ten integer.
    ]]
    local a = tostring(milliseconds)
    if #a == 1 then
        out[#out + 1] = '00'
    elseif #a == 2 then
        out[#out + 1] = '0'
    else
        --Valid
    end
    out[#out + 1] = a

    return table.concat(out)
end

function Taiko.SerializeWebVTT(t, songendms)
    --[[
        t is an unsorted / sorted array of lyrics, just like Parsed.Lyric
    ]]

    --Sort
    table.sort(t, function(a, b)
        return a.ms < b.ms
    end)


    local out = {'WEBVTT\n\n'}

    --Loop
    for i = 1, #t do
        local lyric = t[i]
        
        --Nothing, probably just removing lyric
        if lyric.data ~= '' then
            local ms = lyric.ms

            --Make timestamp

            --[[
                1. A WebVTT timestamp representing the start time offset of the cue. The time represented by this WebVTT timestamp must be greater than or equal to the start time offsets of all previous cues in the file.
                2. One or more U+0020 SPACE characters or U+0009 CHARACTER TABULATION (tab) characters.
                3. The string "-->" (U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS, U+003E GREATER-THAN SIGN).
                4. One or more U+0020 SPACE characters or U+0009 CHARACTER TABULATION (tab) characters.
                5. A WebVTT timestamp representing the end time offset of the cue. The time represented by this WebVTT timestamp must be greater than the start time offset of the cue.
            ]]
            out[#out + 1] = ToTimestamp(ms)
            out[#out + 1] = ' --> '
            
            local endms = nil
            if lyric.lengthms then
                endms = ms + lyric.lengthms
            elseif i ~= #t then
                endms = t[i + 1].ms
            else
                --WARNING: NO END
                endms = songendms
            end
            out[#out + 1] = ToTimestamp(endms)


            --Data
            out[#out + 1] = '\n'
            out[#out + 1] = lyric.data
            out[#out + 1] = '\n\n'
        end
    end

    if out[#out] == '\n\n' then
        out[#out] = nil
    end

    return table.concat(out)
end

--[[
print(Taiko.SerializeWebVTT({{ms = 1, data = 'n'}, {ms = 1500, data = 'hi'}, {ms = 2000, data = 'b'}}, 1000))

error()
--]]


--[[
local a = Taiko.SerializeWebVTT({{ms = 1, data = 'n'}, {ms = 1500, data = 'hi'}, {ms = 2000, data = 'b'}}, 1000)
print(a)
require'ppp'(Taiko.ParseWebVTT(a))

error()
--]]























--TJA Parser

function Taiko.ParseTJA(source)
    local time = os.clock()

    --Parsing settings
    local zeroopt = true --Don't parse zeros
    local gimmick = true --Are gimmicks enabled?
    local extragimmick = true --EXTRA gimmicks enabled? (NON-STANDARDIZED)
    local originalgimmick = true --ORIGINAL gimmicks enabled? (NON-STANDARDIZED, Not currently in any other simulator, proposed, weird)
    local multilinebrackets = true --Try parsing multi-line lines ([[]]) NON-STANDARDIZED

    local strict = true --Be strict with parsing






    local Out = {}
    local Parsed = {
        Flag = {
            PARSER_FORCE_OLD_SPEED_CALCULATION = false,
            PARSER_FORCE_OLD_NOTERADIUS = false,
            PARSER_FORCE_OLD_TARGET = false,
            PARSER_FORCE_OLD_BPMCHANGE = false,
        },
        Metadata = {
            SUBTITLE = '', --not required --taiko-web


            BPM = 120,
            WAVE = 'main.mp3', --taiko-web
            OFFSET = 0,
            DEMOSTART = 0, --taiko-web no preview
            SCOREMODE = 1,
            SONGVOL = 100, --taiko-web ignored
            SEVOL = 100, --taiko-web ignored
            SIDE = 3, -- --taiko-web ignored
            LIFE = 0, --taiko-web ignored
            GAME = 'Taiko', --taiko-web ignored
            HEADSCROLL = 1, --taiko-web ignored
            MOVIEOFFSET = 0, --taiko-web ignored
            COURSE = 'ONI',
            LEVEL = 0,
            BALLOON = nil,
            BALLOONNOR = nil,
            BALLOONEXP = nil,
            BALLOONMAS = nil,
            STYLE = 1,
            EXAM1 = nil,
            EXAM2 = nil,
            EXAM3 = nil,
            GAUGEINCR = 'NORMAL',
            TOTAL = nil,
            HIDDENBRANCH = 0,
            DIVERGENOTES = false,



            --temporary values
            SCOREINIT = 0,
            SCOREDIFF = 0,




            --Rendering / Game
            STOPSONG = false
        },
        Data = {},
        --[[
            Format:
            {
                {
                    ms = 1000,
                    data = 'note',
                    type = 1,
                    txt = 'don',
                    gogo = false,
                    event = 'enablegogo'
                }
            }
        ]]

        --Timestamp events
        --[[
        STOPSONG = {},
        JPOSSCROLL = {},
        BPMCHANGE = {},
        --]]
        --[[
            Format:
            Instead of being attached to the notes, these events will be just inserted into this table

            UPDATE 2/26/2023: I feel like there is no need to implement these event based: only Lyric is really needed to be implemented this way
        ]]

        Lyric = {},
        --[[
            Format:
            {
                {
                    ms = 1000,
                    lengthms = 1000
                    data = ''
                }
            }
        ]]

        --KEEP IN MIND THAT PARSED IS CLONED FOR EACH DIFFICULTY, BUT NOT FULL CLONE
    }



    --Parser flags
    --[[
        List of parser flags:
        $PARSER_FORCE_OLD_SPEED_CALCULATION (old (Taiko.CalculateSpeed))
        $PARSER_FORCE_OPENTAIKO_SPEED_CALCULATION (default opentaiko (Taiko.CalculateSpeedInterval))
        $PARSER_FORCE_OLD_NOTERADIUS (old noteradius)
        $PARSER_FORCE_OLD_TARGET (old target pos)
        $PARSER_FORCE_OLD_BPMCHANGE (old bpmchange (no respecting hbscroll))
        $PARSER_UNCOMMENT_@@@ (uncomment lines of comments delimited by @@@ present in those lines)

        Make sure to comment them out so other simulators can still play the file. Also, if a flag is found anywhere in the file, it will apply to all difficulties.
    ]]

    if string.find(source, '$PARSER_FORCE_OLD_SPEED_CALCULATION') then
        Parsed.Flag.PARSER_FORCE_OLD_SPEED_CALCULATION = true
    elseif string.find(source, '$PARSER_FORCE_OPENTAIKO_SPEED_CALCULATION') then
        --default
    else
        --default
    end

    if string.find(source, '$PARSER_FORCE_OLD_NOTERADIUS') then
        Parsed.Flag.PARSER_FORCE_OLD_NOTERADIUS = true
    end

    if string.find(source, '$PARSER_FORCE_OLD_TARGET') then
        Parsed.Flag.PARSER_FORCE_OLD_TARGET = true
    end

    if string.find(source, '$PARSER_FORCE_OLD_BPMCHANGE') then
        Parsed.Flag.PARSER_FORCE_OLD_BPMCHANGE = true
    end

    if string.find(source, '$PARSER_UNCOMMENT_@@@') then
        Parsed.Flag.PARSER_UNCOMMENT_TRIPLE_ATMARK = true --flag doesn't do anything
        source = string.gsub(source, '$PARSER_UNCOMMENT_@@@', '') --gsub so it doesn't catch the @@@ and comment
        
        local i = 0
        while true do
            if i > #source then
                break
            end
            local s, e = string.find(source, '@@@', i)
            if s then
                local i2 = s
                while true do
                    if string.sub(source, i2, i2) == '\n' then
                        break
                    else
                        i2 = i2 - 1
                    end
                end
                local s2, e2 = string.find(source, '@@@', e)
                if s2 then
                    local i3 = e2
                    while true do
                        if string.sub(source, i3, i3) == '\n' then
                            break
                        else
                            i3 = i3 + 1
                        end
                    end

                    --take chunk and gsub
                    local str = string.gsub(string.gsub(string.sub(source, i2, i3), '@@@', ''), '//(.-\n)', '%1')
                    --print(i2, i3)
                    source = string.sub(source, 1, i2 - 1) .. str .. string.sub(source, i3 + 1, -1)


                    i = e2

                else
                    break
                end
            else
                break
            end
        end
    end

    --Alias for all TJAP3 compat
    if string.find(source, '$PARSER_TJAP3_COMPAT') then
        Parsed.Flag.PARSER_TJAP3_SUDDEN_COMPAT = true
        Parsed.Flag.PARSER_TJAP3_DRUMROLL_SUDDEN_COMPAT = true
        Parsed.Flag.PARSER_TJAP3_INFINITE_DRUMROLL_COMPAT = true
        Parsed.Flag.PARSER_TJAP3_SUDDEN_MS_PRECISION = true
        Parsed.Flag.PARSER_TJAP3_JPOSSCROLL_FLIP_Y = true
        Parsed.Flag.PARSER_TJAP3_DIRECTION_FLIP_Y = true
    end
    if string.find(source, '$PARSER_TJAP3_SUDDEN_COMPAT') then
        Parsed.Flag.PARSER_TJAP3_SUDDEN_COMPAT = true
    end
    if string.find(source, '$PARSER_TJAP3_DRUMROLL_SUDDEN_COMPAT') then
        Parsed.Flag.PARSER_TJAP3_DRUMROLL_SUDDEN_COMPAT = true
    end
    if string.find(source, '$PARSER_TJAP3_INFINITE_DRUMROLL_COMPAT') then
        Parsed.Flag.PARSER_TJAP3_INFINITE_DRUMROLL_COMPAT = true
    end
    if string.find(source, '$PARSER_TJAP3_SUDDEN_MS_PRECISION') then
        Parsed.Flag.PARSER_TJAP3_SUDDEN_MS_PRECISION = true
    end
    if string.find(source, '$PARSER_TJAP3_JPOSSCROLL_FLIP_Y') then
        Parsed.Flag.PARSER_TJAP3_JPOSSCROLL_FLIP_Y = true
    end
    if string.find(source, '$PARSER_TJAP3_DIRECTION_FLIP_Y') then
        Parsed.Flag.PARSER_TJAP3_DIRECTION_FLIP_Y = true
    end
    


























    --Local functions
    local function GetTranslated(name)
        local a = Taiko.Data.Languages
        for i = 1, #a do
            local b = Parsed.Metadata[name .. a[i]]
            if b then
                return b
            end
        end
        return nil
    end
    local function CheckN(cmd, n, e)
        local a = tonumber(n)
        if a then
            return a
        else
            ParseError(cmd, e, n)
        end
    end
    local function Check(cmd, a, e, data)
        if a then
            return a
        else
            ParseError(cmd, e, data)
        end
    end
    local function CheckB(cmd, b, e)
        local boolean = {
            ['true'] = true,
            ['false'] = false,
            yes = true,
            no = false,
            ['1'] = true,
            ['0'] = false,
            [1] = true,
            [0] = false
        }
        local a = boolean[b] ~= nil
        if a then
            return a
        else
            ParseError(cmd, e, b)
        end
    end
    local function CheckF(cmd, s, e) --DIRTY --SLOW
        local f, out = loadstring(s)
        if f then
            return f
        else
            ParseError(cmd, s, e .. ': ' .. out)
        end
    end
    local function CheckCSV(cmd, str) --No errors are possible
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
    local function CheckCSVN(cmd, str, e)
        local t = CheckCSV(cmd, str)
        for i = 1, #t do
            t[i] = CheckN(cmd, t[i], e, str)
        end
        return t
    end
    local function CheckBalloon(cmd, s, e)
        if s and s ~= '' then
            return CheckCSVN(cmd, s, e)
        else
            return {}
        end
    end
    local function CheckExam(cmd, s, e)
        if s and s ~= '' then
            local t = CheckCSV(cmd, s, e)
            Check(cmd, Taiko.Data.Exam.Condition[t[1]], e)
            t[2] = CheckN(cmd, t[2], e)
            t[3] = CheckN(cmd, t[3], e)
            Check(cmd, Taiko.Data.Exam.Scope[t[4]], e)
            return t
        else
            return {}
        end
    end
    




    --Parse Functions
    local DoError = error
    local function CheckFraction(s)
        return string.find(s, '/')
    end
    local function ParseFraction(s)
        --No decimals
        --return string.match(s, '(%d+)/(%d+)')

        --Yes decimals
        return string.match(s, '(.+)/(.+)')
    end
    local function ParseNumber(s)
        local sign = nil
        local decimal = false
        local current = ''
        for i = 1, #s do
            local c = string.sub(s, i, i)
            if c == '+' or c == '-' then
                if sign then
                    DoError('There are multiple signs')
                else
                    sign = c
                end
            elseif c == '.' then
                if decimal then
                    DoError('There are multiple decimal points')
                else
                    current = current .. c
                    decimal = true
                end
            elseif tonumber(c) then
                current = current .. c
            end
        end
        if current == '' then
            DoError('No number was found')
        end
        return tonumber((sign or '+') .. current)
    end
    local function ParseAnyNumber(s)
        local a = tonumber(s)
        if a then
            return a
        end
        local clean = string.gsub(s, '[^%d%.%-%+]', '')
        if clean == '' then
            return 0
        end
        return tonumber(clean) or ParseNumber(s) or ParseNumber(clean)
    end
    local function CheckComplexNumber(s)
        return string.find(s, 'i')
    end
    local function ParseComplexNumber(s)
        local t = {
            0, --real
            0 --imaginary
        }
        local imaginary = false
        local current = ''
        for i = 1, #s do
            local c = string.sub(s, i, i)
            if c == '+' or c == '-' then
                --t[1] = t[1] + tonumber(current)
                t[1] = t[1] + ParseAnyNumber(current)
                current = c
            elseif c == 'i' then
                --t[2] = t[2] + tonumber(current)
                --leniency when parsing complex: 1+i or 1-i allowed
                if current == '+' or current == '-' or current == '' then
                    current = current .. '1'
                end
                t[2] = t[2] + ParseAnyNumber(current)
                current = ''
            else
                current = current .. c
            end
        end
        if current ~= '' then
            t[1] = t[1] + ParseAnyNumber(current)
        end
        return t
    end
    local function ParseComplexNumberSimple(s)
        --Can handle fractions
        --VERY MEMORY INTENSIVE --DIRTY
        local t = String.Split(s, '%+')
        local newt = {}
        for i = 1, #t do
            local t2 = String.Split(t[i], '%-')
            for i = 1, #t2 do
                if i == 1 then
                    newt[#newt + 1] = t2[i]
                else
                    newt[#newt + 1] = '-' .. t2[i]
                end
            end
        end
        t = newt
        local out = {
            0, --real
            0 --imaginary
        }
        local fracdata = {
            false, --real
            false --imaginary
        }
        for i = 1, #t do
            if t[i] ~= '' then
                local imaginary = false
                if string.find(t[i], 'i') then
                    imaginary = true
                    t[i] = string.gsub(t[i], 'i', '')
                end
                if CheckFraction(t[i]) then
                    --WARNING: Negative is handled by ParseFraction
                    --[[
                    local negative = false
                    if string.find(t[i], '%-') then
                        negative = true
                    end
                    --]]
                    local a, b = ParseFraction(t[i])
                    t[i] = (a/b) --UNSAFE
                    fracdata[imaginary and 2 or 1] = true
                    --[[
                    if negative then
                        t[i] = -t[i]
                    end
                    --]]
                else
                    --Leniency for 1+i, etc
                    if imaginary and (t[i] == '' or t[i] == '-') then
                        t[i] = t[i] .. '1'
                    end
                    --POSSIBLY USE PARSENUMBER? UNSAFE
                    t[i] = tonumber(t[i]) --UNSAFE
                end
                if imaginary then
                    out[2] = out[2] + t[i]
                else
                    out[1] = out[1] + t[i]
                end
            end
        end
        return out, fracdata
    end
    local function CheckPolarNumber(s)
        return string.find(s, ',')
    end
    local function ParsePolarNumber(r, rad)
        return {r * math.cos(rad), r * math.sin(rad)}
    end
    --print(unpack(ParseComplexNumber(source)))error()
    local function ParseArguments(s)
        --TaikoManyGimmicks Style
        --return String.Split(s, ',')
        return String.Split(s, ' ')
    end
    
    local function ParseScroll(match)
        local scrollx = nil
        local scrolly = nil

        if gimmick and CheckComplexNumber(match[2]) then
            --Complex Scroll (TaikoManyGimmicks + OpenTaiko)
            --(x) + (y)i
            local complex = ParseComplexNumber(match[2])
            scrollx = -complex[1]
            scrolly = -complex[2]
        elseif gimmick and CheckPolarNumber(match[2]) then
            --Polar Scroll (TaikoManyGimmicks)
            --(r),(div),(n)
            local t = CheckCSVN(match[1], match[2], 'Invalid polar scroll')
            if #t == 3 then
                local polar = ParsePolarNumber(t[1], math.rad(t[3] / t[2] * 360))
                scrollx = -polar[1]
                scrolly = -polar[2]
            else
                ParseError(match[1], 'Invalid polar scroll')
            end
        else
            --Normal Scroll
            scrollx = CheckN(match[1], match[2], 'Invalid scroll')
            if scrollx then
                scrollx = -scrollx
            end
            scrolly = 0
        end

        --original gimmick: scroll can be 0
        if not originalgimmick and scrollx == 0 and scrolly == 0 then
            ParseError(match[1], 'Scroll cannot be 0')
        end

        return scrollx, scrolly
    end







    local Parser = {}

    local function GetParser()
        local Parser = {
            settings = {
                noteparse = {
                    --[[
                    notealias = {
                        A = 3,
                        B = 4
                    },
                    noteexceptions = {
                        [','] = true,
                        [' '] = true,
                        ['\t'] = true
                    }
                    --]]
                    notes = {
                        [0] = true,
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = true,
                        [7] = true,
                        [8] = true,
                        [9] = true,
                        ['A'] = true,
                        ['B'] = true,
                    }
                },
                command = {
                    matchexceptions = {
                        --scrapped
                    }
                },
                --constant
                directionweight = {
                    --In polar degrees (degrees from positive x-axis, going counterclockwise)
                    --NOT IN OPENTAIKO OR ANY OTHER!
                    R = 0,      --From right
                    U = 90,     --From up
                    L = 180,    --From left
                    D = 270,    --From down
                    --TJA
                    -- 0: From right, 1: From above, 2: From below, 3: From top-right, 4: From bottom-right, 5: From left, 6: From top-left, 7: From bottom-left
                    ['0'] = 0,
                    ['1'] = 90,
                    ['2'] = 270,
                    ['3'] = 45,
                    ['4'] = 315,
                    ['5'] = 180,
                    ['6'] = 135,
                    ['7'] = 225
                },

                --only matters if strict is on
                strict = {
                    noteparse = {
                        notes = {
                            --[','] = true,
                            [' '] = true,
                            ['\t'] = true,
                            ['\n'] = true,
                            ['\r'] = true,
                        }
                    }
                }
            },
    
    
    
            bpm = 0,
            ms = 0,
            songstarted = false,
            timingpoint = nil,
            sign = 4/4,
            mpm = 0,
            mspermeasure = 0,
            --scroll = 1, --reversed
            scrollx = -1, --actual
            scrolly = 0, --actual
            measuredone = true,
            currentmeasure = {},
            measurepushto = Parsed.Data,
            barline = true,
            insertbarline = true,
            gogo = false,
            --noteparse
            lastlong = nil,
            balloonn = 1,
    
            --branch
            currentbranch = nil,
            branch = {
                on = false,
                requirements = {
    
                },
                paths = {
    
                }
            },
            msbeforebranch = nil,
            section = false,



            --bmscroll and hbscroll
            disablescroll = false,
            attachbpmchange = false,
            stopsong = false,
            delay = 0,

            --sudden
            suddenappear = nil,
            suddenmove = nil,




            --note chain
            --notechain = {},
            senotems = nil,
            senotei = false,
            lastsenote = nil,
            lastlastsenote = nil,
            senotechange = nil,




            jposscroll = {
                lengthms = nil, --Length of transition
                p = nil, --Position (pixel (x, y))
                lanep = nil --Position (relative to lane (x, y))
            },



            zeroopt = zeroopt,
            --[[
                if zeroopt is on
                    if stopsong and there is delay in measure, it is turned off for measure
                    if there is jposscroll in measure, it is turned off for measure
                if it is off
                    just parse all zeros
            ]]
            


            --[[
                drumrollbend

                stores the table of startnote.drumrollbend

                drumrollbendstart

                stores the startnote
            ]]
            drumrollbend = nil,
            drumrollbendstart = nil,



            --[[
                positionf

                stores the function (that was loadstringed) that will override CalculatePosition
            ]]
            positionf = nil,

        }






        --Parser functions
        --[[
            SENOTES
            https://github.com/EricLiver/cjdg/blob/master/public/src/js/parsetja.js#L178-L203
        ]]
        --[[
        local function isalldon(notechain, startpos)
            for i = startpos, #notechain do
                local note = notechain[i]
                if note and note.type ~= 1 and note.type ~= 3 then
                    return false
                end
            end
            return true
        end
        function Parser.checknotechain(notechain, measurelength, islast)
            local alldonpos = nil
            for i = 1, #notechain - (islast and 1 or 0) do
                local note = notechain[i]
                if alldonpos == nil and is_last and isalldon(notechain, i) then
                    alldonpos = i
                end
                --note.senote = note.senote or Taiko.Data.SENotes[note.type][(alldonpos ~= nil and i - alldonpos % 2 or 0) + 1]
                note.senote = Taiko.Data.SENotes[note.type][(alldonpos ~= nil and i - alldonpos % 2 or 0) + 1]
            end
        end
        --]]










        function Parser.createnote(n)
            if n then
                --[[
                Notes:
                    - 0 - Blank, no note.
                    - 1 - Don.
                    - 2 - Ka.
                    - 3 - DON (Big).
                    - 4 - KA (Big).
                    - 5 - Drumroll.
                        - Should end with an 8.
                    - 6 - DRUMROLL (Big).
                        - Should end with an 8.
                    - 7 - Balloon.
                        - Should end with an 8.
                    - 8 - End of a balloon or drumroll.
                    - 9 - Kusudama, yam, oimo, or big balloon (has the same appearance as a regular balloon in taiko-web).
                        - Should end with an 8.
                        - Use another 9 to specify when to lower the points for clearing.
                        - Ignored in taiko-web.
                    - A - DON (Both), multiplayer note with hands.
                    - B - KA (Both), multiplayer note with hands.
                    - F - ADLIB, hidden note that will increase combo if discovered and does not give a BAD when missed.
                        - Ignored in taiko-web.


                    https://taikotime.blogspot.com/2010/08/advanced-rules.html
                    https://outfox.wiki/dev/mode-support/tja-support/
                ]]


                
                --[[
                if Parser.settings.noteparse.notes[n] then
                    
                else
                    return nil
                end
                --]]


                local note = {
                    ms = nil,
                    data = nil, --'note'
                    type = n,
                    txt = nil,
                    gogo = Parser.gogo,
                    --speed = (Parser.bpm) / 60 * (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    --scroll = (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    scrollx = (Parser.scrollx * Parsed.Metadata.HEADSCROLL),
                    scrolly = (Parser.scrolly * Parsed.Metadata.HEADSCROLL),
                    mspermeasure = Parser.mspermeasure,
                    bpm = Parser.bpm,
                    --measuredensity = nil,
                    nextnote = nil,
                    radius = 1, --multiplier
                    requiredhits = nil,
                    lengthms = nil,
                    endnote = nil,
                    section = nil,
                    text = nil,
                    delay = Parser.delay,
                    senote = nil,
                    --Sudden: relative ms
                    appearancems = Parser.suddenappear,
                    movems = Parser.suddenmove,

                    dummy = Parser.dummy,

                    positionf = Parser.positionf,




                    onnotepush = nil,
                    currentbranch = Parser.currentbranch, --nil if no branch



                    --debug
                    line = LineN,
                }
                --note.type = n




                --Big note
                if n == 3 or n == 4 or n == 6 then
                    --note.radius = note.radius * 1.6
                    note.radius = note.radius * Taiko.Data.BigNoteMul
                end

                if n == 5 or n == 6 or n == 7 or n == 9 then
                    if Parser.lastlong then
                        --9 is special, so exclude
                        if n == 9 then
                            --Parser.lastlong = nil
                            --Lower points for clearing
                            
                        else
                            ParseError('parser.noteparse', 'Last long note has not ended')
                        end
                    else
                        --print('set', LineN)
                        Parser.lastlong = note
                        if n == 7 or n == 9 then
                            --print(LineN)
                            note.requiredhits = Check('parser.noteparse', Parsed.Metadata.BALLOON[Parser.balloonn], 'Invalid number of balloons', Parser.balloonn)
                            Parser.balloonn = Parser.balloonn + 1
                        end
                    end
                end

                if n == 8 then
                    --print('unset', LineN)
                    local lastlong = Parser.lastlong
                    Parser.lastlong = nil
                    note.startnote = lastlong
                    if lastlong then
                        note.onnotepush = function()
                            lastlong.lengthms = note.ms - lastlong.ms
                            lastlong.endnote = note
                            --Parser.lastlong = nil
                            --note.type = 0 --to delete note
                        end
                    else
                        ParseError('parser.noteparse', 'Last long note has already ended')
                    end
                end


                if Parser.section then
                    note.section = true
                    Parser.section = false
                end

                --SENotes
                if n and Parser.senotechange then
                    note.senote = Parser.senotechange
                    Parser.senotechange = nil
                --[[
                elseif note.type and Taiko.Data.SENotes[note.type] then
                    note.senote = Taiko.Data.SENotes[note.type][1]
                --]]
                end

                return note
            else
                return {
                    ms = nil,
                    data = nil, --'note'
                    type = n,
                    txt = nil,
                    gogo = Parser.gogo,
                    --speed = (Parser.bpm) / 60 * (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    --scroll = (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    scrollx = (Parser.scrollx * Parsed.Metadata.HEADSCROLL),
                    scrolly = (Parser.scrolly * Parsed.Metadata.HEADSCROLL),
                    mspermeasure = Parser.mspermeasure,
                    bpm = Parser.bpm,
                    --measuredensity = nil,
                    nextnote = nil,
                    radius = 1, --multiplier
                    requiredhits = nil,
                    lengthms = nil,
                    endnote = nil,
                    section = nil,
                    text = nil,
                    delay = Parser.delay,
                    senote = nil,
                    --Sudden: relative ms
                    appearancems = Parser.suddenappear,
                    movems = Parser.suddenmove,

                    dummy = Parser.dummy,

                    positionf = Parser.positionf,




                    onnotepush = nil,
                    currentbranch = Parser.currentbranch, --nil if no branch



                    --debug
                    line = LineN,
                }
            end
        end








        function Parser.createbarline()
            local note = Parser.createnote()
            note.ms = Parser.ms
            note.data = 'event'
            note.event = 'barline'
            return note
        end



        function Parser.endbranch()
            --Copy (Move) branches into Parsed.Data
            local n = Parser.createnote()
            n.data = 'event'
            n.event = 'branch'
            n.branch = {
                requirements = Parser.branch.requirements,
                paths = Parser.branch.paths
            }
            Parser.branch.on = false
            Parser.currentbranch = nil
            Parser.branch.requirements = {}
            Parser.branch.paths = {}
            table.insert(Parsed.Data, n)
            Parser.measurepushto = Parsed.Data        
            --Parser.ms = Parser.msbeforebranch + Parser.msinbranch
        end







        return Parser
    end



    Parser = GetParser()








    































    --Start
    local lines = String.Split(source, '\n')
    local jumpi = 0
    for i = 1, #lines do
        if i < jumpi then
            --Ignore line
        else
    
        LineN = i

        --local line = String.TrimLeft(lines[i])
        local line = String.Trim(lines[i])
        if String.StartsWith(line, '//') or line == '' then
            --Do nothing
        else
            --Check for comments
            local comment = string.find(line, '//')
            if comment then
                line = string.sub(line, 1, comment - 1)
            end


            --NOT STANDARDIZED
            --Combine multiple lines
            if multilinebrackets then
                local s, e = string.find(line, '%[%[')
                if s then
                    --Check for matching bracket
                    local s2, e2 = string.find(line, '%]%]', e)
                    if s2 then
                        --Nope, bracket ends
                    else
                        --No bracket end, assume next line
                        line = string.sub(line, 1, s - 1) .. string.sub(line, e + 1, -1)
                        local i2 = i + 1
                        local s3, e3
                        while true do
                            s3, e3 = string.find(lines[i2], '%]%]')
                            if s3 then
                                break
                            else
                                line = line .. '\n' .. lines[i2]
                            end
                            i2 = i2 + 1
                        end

                        jumpi = i2
                        line = line .. '\n' .. string.sub(lines[i2], 1, s3 - 1)
                        lines[i2] = string.sub(lines[i2], e3 + 1, -1)

                    end
                end
            end




            local done = false

            
            --Metadata
            if Parser.songstarted == false and done == false then
                local match = {string.match(line, '(%u+):(.*)')}
                if match[1] then
                    local a = String.Trim(match[2])
                    if a ~= '' then
                        Parsed.Metadata[String.Trim(match[1])] = a
                    end
                    
                    done = true
                    --[[
                    local a = String.Trim(match[2])
                    if a ~= '' then
                        Parsed.Metadata[String.Trim(match[1])] = a
                    end
                    done = true
                    ]]
                end
            end

            --Command
            if (Parser.songstarted or String.StartsWith(line, '#START') or String.StartsWith(line, '#BMSCROLL') or String.StartsWith(line, '#HBSCROLL') or String.StartsWith(line, '#NMSCROLL')) and done == false then
                local match = {string.match(line, '#(%u-)%s(.*)')}
                if not match[1] then
                    match = {string.match(line, '#(%u+)')}
                    --[=[
                    if not Parser.settings.command.matchexceptions[match[1]] then
                        match = {}
                    end
                    --]=]
                end
                if match[1] then
                    if match[1] == 'START' then
                        --[[
                            - Marks the beginning and end of the song notation where only notes and commands are accepted and metadata for the song cannot be changed.
                            - #START with value set to "P1" or "P2" will mark it as the chart for the first or second player respectively, but only if same difficulty is picked by both players.
                                - One difficulty may have three different song notations: singleplayer (no value in #START), multiplayer P1, and multiplayer P2.
                                - These values are not supported in taiko-web.
                        --]]
                        if Parser.songstarted then
                            ParseError(match[1], 'Song has already started')
                        else
                            --Parse metadata
                            Parsed.OriginalMetadata = Table.Clone(Parsed.Metadata)


                            --Mode (match[2])
                            if match[2] then
                                Parsed.Metadata.MODE = Check(match[1], Taiko.Data.ModeId[match[2]], 'Invalid mode', match[2])
                            else
                                Parsed.Metadata.MODE = 0
                            end
                            --Main metadata
                            --[[
                            TITLE: (i)
                                - Song's title that appears on song selection, in the game, and on the results screen.
                                - When hosted on taiko-web, "title" field in the database is used.

                            TITLEEN: (i)
                                - Translated version of the title, overrides TITLE: if translations are preferred by the user.
                                - Other versions of this header:
                                    - "TITLEJA:" - Japanese, if the original title is not in Japanese.
                                    - "TITLEEN:" - English.
                                    - "TITLECN:" - Simplified Chinese.
                                    - "TITLETW:" - Traditional Chinese.
                                    - "TITLEKO:" - Korean.
                                - When hosted on taiko-web, "title_lang" field in the database is used.
                            ]]
                            Parsed.Metadata.TITLE = Check(match[1], GetTranslated('TITLE'), 'Title is missing')
                            --[[
                            SUBTITLE: (i)
                                - The sub-title that appears on the selected song in song selection that may explain the origin of the song, such as the originating media or the lead singer.
                                - Adding -- or ++ at the beginning changes the appearance of the subtitle on the results screen by either hiding (--) or showing it (++) next to the title. This has no effect in taiko-web.
                                - When translations are preferred by the user, SUBTITLE: will not be displayed if a translated TITLEEN: is specified, even if there is no matching SUBTITLEEN:.
                                - When hosted on taiko-web, "subtitle" field in the database is used.

                            SUBTITLEEN: (i)
                                - Translated version of the subtitle, overrides SUBTITLE: if translations are preferred by the user.
                                - Unlike SUBTITLE:, this header does not strip the leading -- and ++ because the translated subtitle appearance on the results screen should be the same as the original subtitle.
                                - Other versions of this header:
                                    - "SUBTITLEJA:" - Japanese, if the original subtitle is not in Japanese.
                                    - "SUBTITLEEN:" - English.
                                    - "SUBTITLECN:" - Simplified Chinese.
                                    - "SUBTITLETW:" - Traditional Chinese.
                                    - "SUBTITLEKO:" - Korean.
                                - When hosted on taiko-web, "subtitle_lang" field in the database is used.
                            ]]
                            Parsed.Metadata.SUBTITLE = Check(match[1], GetTranslated('SUBTITLE'), 'Subtitle is missing')
                            --[[
                            BPM:
                                - Song's beats per minute.
                                - The following formula is used: BPM = MEASURE / SIGN * 4, where MEASURE is amount of measures per minute and SIGN is the time signature, eg. 4 / 4 if the current time signature is common.
                                - If omitted, BPM defaults to 120.
                            ]]
                            Parsed.Metadata.BPM = CheckN(match[1], Parsed.Metadata.BPM, 'Invalid bpm')
                            --[[
                            OFFSET:
                                - Floating point value for chart offset in seconds.
                                - Negative values will delay notes, positive will cause them to appear sooner.
                                - If the "offset" field is set in a taiko-web database, both values will be summed together.
                            ]]
                            Parsed.Metadata.OFFSET = SToMs(CheckN(match[1], Parsed.Metadata.OFFSET, 'Invalid offset'))
                            --[[
                            DEMOSTART: (i)
                                - Offset of song preview during song selection in seconds.
                                - Default is 0, which also disables the generation of a "preview.mp3" file when hosted on taiko-web.
                                - When hosted on taiko-web, "preview" field in the database is used.
                            ]]
                            Parsed.Metadata.DEMOSTART = SToMs(CheckN(match[1], Parsed.Metadata.DEMOSTART, 'Invalid demostart'))
                            if Parsed.Metadata.DEMOSTART == 0 then
                                --No preview
                                Parsed.Metadata.DEMOSTART = nil
                            end
                            --[[
                            GENRE: (i)
                                - Song's genre that controls where the song appears in the song selection.
                                - The following values can be used:
                                    - "J-POP"
                                    - "アニメ"
                                    - "どうよう"
                                    - "バラエティ"
                                    - "ボーカロイド", "VOCALOID"
                                    - "クラシック"
                                    - "ゲームミュージック"
                                    - "ナムコオリジナル"
                                - In addition to that list, taiko-web supports genres in different languages as well as directory names containing the genre.
                                - Overrides the genre set in "genre.ini" and "box.def" files.
                                - When hosted on taiko-web, "category_id" field and "categories" collection in the database are used.
                            ]]
                            --Lua doesn't work well with unicode, so just convert them
                            for k, v in pairs(Taiko.Data.GenreAlias) do
                                for i = 1, #v do
                                    if v[i] == Parsed.Metadata.GENRE then
                                        Parsed.Metadata.GENRE = k
                                    end
                                end
                            end
                            --[[
                            SCOREMODE:
                                - Scoring method that affects the final score. All scores are divided by 10, rounded towards negative infinity, then multiplied by 10.
                                - Value of "0" - AC 1 to AC 7 generation scoring.
                                    - Less than 200 combo: INIT or 1000 pts per note.
                                    - 200 combo or more: INIT + DIFF or 2000 pts (1000+1000) per note.
                                    This value is not supported in taiko-web.
                                - Value of "1" - AC 8 to AC 14 generation scoring.
                                    - Combo multiplier rises by DIFF with each 10 combo until 100, after which it increases at a constant rate.
                                    - Formula: INIT + max(0, DIFF * floor((min(COMBO, 100) - 1) / 10))
                                - Value of "2" - AC 0 generation scoring.
                                    - Similar to "1" with some DIFF multipliers missing.
                                    - Formula: INIT + DIFF * {100<=COMBO: 8, 50<=COMBO: 4, 30<=COMBO: 2, 10<=COMBO: 1, 0}
                                - Default is "1".
                            ]]
                            Parsed.Metadata.SCOREMODE = CheckN(match[1], Parsed.Metadata.SCOREMODE, 'Invalid scoremode')
                            Check(match[1], Taiko.Data.ScoreMode.Note[Parsed.Metadata.SCOREMODE], 'Invalid scoremode', Parsed.Metadata.SCOREMODE)
                            --[[
                            MAKER: (i)
                                - Chart creator's name.
                                - Marks the song with "Creative" badge and adds the name to difficulty selection.
                                - Optionally, chart creator's url can be added inside angle brackets after the name.
                                - When hosted on taiko-web, "maker_id" field and "makers" collection in the database are used.
                            ]]
                            if Parsed.Metadata.MAKER then
                                Parsed.Metadata.CREATORURLT = {}
                                Parsed.Metadata.CREATOR = String.Trim(string.gsub(Parsed.Metadata.MAKER, '(<.->)', function(url)
                                    table.insert(Parsed.Metadata.CREATORURLT, string.sub(url, 2, -2))
                                    return ''
                                end))
                                Parsed.Metadata.CREATORURL = table.concat(Parsed.Metadata.CREATORURLT, ', ')
                                Parsed.Metadata.CREATIVE = false
                            else
                                Parsed.Metadata.CREATIVE = false
                            end
                            --[[
                            LYRICS: (i)
                                - Path to a timed WEBVTT lyrics file, usually with a .vtt extension.
                                - Shows song lyrics at the bottom of the screen.
                                - Marks the song as having lyrics on the song select.
                                - Contents of the vtt file:
                                    - Offset of all lyrics can be specified after the header as a floating point number in seconds: WEBVTT Offset: 0.250
                                    - All commands are separated with a double new line.
                                    - Timestamps are separated with --> and have either MM:SS.msc or HH:MM:SS.msc format.
                                        - First timestamp is when the line should appear, second is when it should end.
                                        - Timestamps within the file should be sequentially ordered, a line cannot start before the previous one ends.
                                    - Ruby tags can be used to display annotations for complex words: <ruby>漢字<rt>かんじ</rt></ruby>
                                    - <lang en> (where "en" is the language code) begins a translated version of the line.
                                        - If user's language does not match any of the lang tags, the line before all of them is used.
                                - Overrides #LYRIC commands in the notation.
                                - When hosted on taiko-web, setting "lyrics" field in the database to true will force the value to be "main.vtt", otherwise it will be ignored.
                            ]]
                            --TODO
                            --[[
                            SONGVOL: (?)
                                - Music volume percentage.
                                - Default is 100, but can be made louder by increasing the value further.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.SONGVOL = CheckN(match[1], Parsed.Metadata.SONGVOL, 'Invalid songvol') / 100
                            --[[
                            SEVOL: (?)
                                - Sound effect volume percentage, such as drumming and Don's voice lines.
                                - Default is 100.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.SEVOL = CheckN(match[1], Parsed.Metadata.SEVOL, 'Invalid sevol') / 100
                            --[[
                            SIDE: (?)
                                - Value can be either:
                                    - "Normal" or "1"
                                    - "Ex" or "2"
                                    - "Both" or "3"
                                - Value of "Normal" and "1" makes the song appear when song selection is in the default mode.
                                - "Ex" and "2" hides the song from default song selection.
                                    - The song appears after the user presses the buttons for next song and previous song 20 times alternatingly (10 for each button).
                                - Default is "Both", making the song appear during song selection in both modes.
                                Ignored in taiko-web.
                            ]]
                            local a = tonumber(Parsed.Metadata.SIDE)
                            if a then
                                Check(match[1], Taiko.Data.SideName[a], 'Invalid side id', Parsed.Metadata.SIDE)
                                Parsed.Metadata.SIDE = a
                            else
                                Parsed.Metadata.SIDE = Check(match[1], Taiko.Data.SideId[string.lower(Parsed.Metadata.SIDE)], 'Invalid side name', Parsed.Metadata.SIDE)
                            end
                            --[[
                            LIFE: (?)
                                - Amount of misses that are allowed to be made before interrupting the game and immediately showing the results screen.
                                - Removes the gauge, replacing it with lit up souls that fade one by one after missing a note.
                                - The amount is not limited, but only 16 souls fit on screen.
                                - Default is 0, which does not limit the misses and will play until the end.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.LIFE = CheckN(match[1], Parsed.Metadata.LIFE, 'Invalid life')
                            if Parsed.Metadata.LIFE == 0 then
                                Parsed.Metadata.LIFE = nil
                            end
                            --[[
                            GAME: (?)
                                - Value can be either "Taiko" or "Jube".
                                - Game will be forced to autoplay mode with "Jube" value.
                                - Default is "Taiko".
                                - Ignored in taiko-web.
                            ]]
                            --TODO
                            Parsed.Metadata.GAME = string.lower(Parsed.Metadata.GAME)
                            if Parsed.Metadata.GAME == 'taiko' then
                                --Normal
                            elseif Parsed.Metadata.GAME == 'jube' then
                                --Force Autoplay
                            else

                            end
                            --[[
                            HEADSCROLL: (?)
                                - Initial game scrolling speed.
                                - #SCROLL command in a song notation will be a multiple of this value.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.HEADSCROLL = CheckN(match[1], Parsed.Metadata.HEADSCROLL, 'Invalid headscroll')
                            --[[
                            BGIMAGE: (?)
                                - A limited song skin that combines donbg and songbg into a single image.
                                - Scaling is not applied to the image, its size should match simulator's internal resolution.
                                - Ignored in taiko-web.
                            ]]
                            --TODO
                            --[[
                            BGMOVIE: (?)
                                - Video file that is played in the background during the gameplay.
                                - Can be turned off by the user.
                                - Ignored in taiko-web.
                            ]]
                            --TODO
                            --[[
                            MOVIEOFFSET: (?)
                                - Floating point offset of video file's starting position in seconds.
                                - Cannot be a negative number.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.MOVIEOFFSET = CheckN(match[1], Parsed.Metadata.MOVIEOFFSET, 'Invalid movieoffset')
                            --[[
                            TAIKOWEBSKIN: (i)
                                - Selects a skin to be used for the song's background.
                                - Works only for songs imported to taiko-web by the user, when hosted on taiko-web, "skin_id" field and "song_skins" collection in the database are used.

                                CHART HERE
                            ]]
                            --TODO

























                            --Course Metadata
                            --[[
                            COURSE:
                                - The name of the difficulty (case-insensitive), value is either:
                                    - "Easy" or "0".
                                    - "Normal" or "1".
                                    - "Hard" or "2".
                                    - "Oni" or "3".
                                    - "Edit" or "4" - hidden Ura Oni mode, revealed when right button on rightmost difficulty is hit on difficulty selection.
                                    - "Tower" or "5" - causes all drumroll notes (5 and 6) to draw above all other notes.
                                    - "Dan" or "6" - starts the course in dojo mode with three gauges that should be cleared.
                                - "Ura" is also accepted in taiko-web, which is the same as "Edit" and "4".
                                - "Tower", "5", "Dan", and "6" values are not supported in taiko-web.
                                Default is "Oni".
                            ]]
                            local a = tonumber(Parsed.Metadata.COURSE)
                            if a then
                                Check(match[1], Taiko.Data.CourseName[a], 'Invalid course id', Parsed.Metadata.COURSE)
                                Parsed.Metadata.COURSE = a
                            else
                                Parsed.Metadata.COURSE = Check(match[1], Taiko.Data.CourseId[string.lower(Parsed.Metadata.COURSE)], 'Invalid course name', Parsed.Metadata.COURSE)
                            end

                            --Timing Point
                            --Parsed.Metadata.TIMING = Taiko.Data.Timing.GetFunction(Parsed.Metadata.COURSE)
                            Parsed.Metadata.TIMING = Taiko.Data.Timing.Course(Parsed.Metadata.COURSE)


                            --[[
                            LEVEL: (i)
                                - The difficulty integer between 1 and 10.
                                - Represents the amount of stars that appear on the song select next to the difficulty.
                                - Floating point numbers will be rounded down and numbers outside of the range will be clipped.
                                - When hosted on taiko-web, the value is taken from "easy", "normal", "hard", "oni", or "ura" subfield from the "courses" field.
                            ]]
                            Parsed.Metadata.LEVEL = ClipN(math.floor(CheckN(match[1], Parsed.Metadata.LEVEL, 'Invalid level')), 0, 10)
                            --[[
                            BALLOON:
                                - Comma separated array of integers for Balloon notes (7) and Kusudama notes (9).
                                - Required when balloon notes appear in the course.
                                - Amount of values in the array should correspond to the amount of balloons in the course.
                                - The balloon values are used as they appear in the chart and the values have to be repeated when branches are used.
                            ]]
                            Parsed.Metadata.BALLOON = CheckBalloon(match[1], Parsed.Metadata.BALLOON, 'Invalid balloon')
                            --[[
                            SCOREINIT:
                                - Sets INIT value for the scoring method. See SCOREMODE: header for more information.
                            ]]
                            Parsed.Metadata.SCOREINIT = CheckN(match[1], Parsed.Metadata.SCOREINIT, 'Invalid scoreinit')
                            --[[
                            SCOREDIFF:
                                - Sets DIFF value for the scoring method. See SCOREMODE: header for more information.
                            ]]
                            Parsed.Metadata.SCOREDIFF = CheckN(match[1], Parsed.Metadata.SCOREDIFF, 'Invalid scoreinit')
                            --[[
                            BALLOONNOR:, BALLOONEXP:, BALLOONMAS: (?)
                                - BALLOON: command that is separated for branches.
                                - BALLOONNOR: are balloons during a normal branch, BALLOONEXP: during an advanced branch, BALLOONMAS: during a master branch.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.BALLOONNOR = CheckBalloon(match[1], Parsed.Metadata.BALLOONNOR, 'Invalid balloonnor')
                            Parsed.Metadata.BALLOONEXP = CheckBalloon(match[1], Parsed.Metadata.BALLOONEXP, 'Invalid balloonexp')
                            Parsed.Metadata.BALLOONMAS = CheckBalloon(match[1], Parsed.Metadata.BALLOONMAS, 'Invalid balloonmas')
                            --[[
                            STYLE: (?)
                                - Play the song notation after next #START depending on if playing in singleplayer or multiplayer.
                                - The values can be either:
                                    - "Single" or "1" (default).
                                    - "Double", "Couple", or "2" - both players should pick the same difficulty in multiplayer to play the song notation below this command.
                                - "#START P1" and "#START P2" commands can be used instead when first and second players' charts differ.
                                Ignored in taiko-web.
                            ]]
                            local a = tonumber(Parsed.Metadata.STYLE)
                            if a then
                                Check(match[1], Taiko.Data.StyleName[a], 'Invalid style id', Taiko.Data.STYLE)
                                Parsed.Metadata.STYLE = a
                            else
                                Parsed.Metadata.STYLE = Check(match[1], Taiko.Data.StyleId[string.lower(Parsed.Metadata.STYLE)], 'Invalid style name', Parsed.Metadata.STYLE)
                            end
                            --[[
                            EXAM1:, EXAM2:, EXAM3: (?)
                                - The three gauges required to clear a dojo course (COURSE: with "Dan" or "6" value)
                                - Value is a comma separated array with the following values: condition, red clear requirement, gold clear requirement, scope.
                                - Condition value:
                                    - g - Gauge percentage (default)
                                    - jp - GOOD amount
                                    - jg - OK amount
                                    - jb - BAD amount
                                    - s - Score
                                    - r - Drumroll hits
                                    - h - Number of correct hits and drumroll hits
                                    - c - MAX Combo
                                - Scope value:
                                    - m - Greater than requirement (default)
                                    - l - Less than requirement
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.EXAM1 = CheckExam(Parsed.Metadata.EXAM1)
                            Parsed.Metadata.EXAM2 = CheckExam(Parsed.Metadata.EXAM2)
                            Parsed.Metadata.EXAM3 = CheckExam(Parsed.Metadata.EXAM3)
                            --[[
                            GAUGEINCR: (?)
                                - Gauge increment method, performing rounding with each note that is hit, value is either:
                                    - NORMAL - Default calculation method, which delays the gauge from appearing at the beginning.
                                    - FLOOR - Round towards negative infinity.
                                    - ROUND - Round towards nearest whole.
                                    - NOTFIX - Do not perform rounding.
                                    - CEILING - Round towards positive infinity, the gauge appears to fill with the first note.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.GAUGEINCR = string.lower(Parsed.Metadata.GAUGEINCR)
                            --[[
                            TOTAL: (?)
                                - Percentage multiplier for amount of notes in the song notation that is applied to gauge calculation.
                                - Value of 100 will require all notes to be hit perfectly to get a full gauge at the end.
                                - Values less than 100 will make it impossible to get a full gauge.
                                - Values greater than 100 will make it easier to fill the gauge.
                                - Ignored in taiko-web.
                            ]]
                            if Parsed.Metadata.TOTAL then
                                Parsed.Metadata.TOTAL = CheckN(match[1], Parsed.Metadata.TOTAL, 'Invalid total')
                            end
                            --[[
                            HIDDENBRANCH: (?)
                                - Hide the diverge notes indication on the song selection screen and current branch in the game until branching actually starts.
                                - Ignored in taiko-web.
                            ]]
                            Parsed.Metadata.HIDDENBRANCH = CheckB(match[1], Parsed.Metadata.HIDDENBRANCH, 'Invalid hiddenbranch')















                            



















                            Parser.bpm = Parsed.Metadata.BPM
                            Parser.songstarted = true
                        end
                    elseif match[1] == 'END' then
                        if Parser.songstarted then
                            if #Parser.currentmeasure ~= 0 then
                                ParseError(match[1], 'Current measure is not empty')
                            end

                            table.insert(Out, Parsed)
                            Parsed = {
                                Flag = Parsed.Flag,
                                Metadata = Table.Clone(Parsed.OriginalMetadata),
                                Data = {},
                                Lyric = {},
                            }
                            --reset parser?
                            Parser = GetParser()

                            --No need to do this, Parser is reset completely and created
                            --[[
                            --reset parser?
                            Parser.songstarted = false
                            Parser.measurepushto = Parsed.Data --Very important
                            --]]
                        else
                            ParseError(match[1], 'Song has already ended')
                        end
                    elseif match[1] == 'MEASURE' then
                        --[[
                            - Changes time signature used.
                            - Numerator and denominator from the value are divided by one another.
                            - Formula to get the amount of milliseconds per measure: 60000 * MEASURE * 4 / BPM.
                            - After inserting a note, the current timing point is increased by milliseconds per measure divided by amount of notes in the current measure.
                            - Command can only be placed between measures.
                        ]]
                        --[[
                            60 bpm -> 1000 ms per beat
                            120 bpm -> 500 ms per beat
                            mspb = 60000 / bpm
                        ]]
                        --Parser.measure = tonumber(match[2]) --UNSAFE
                        --local a, b = string.match(match[2], '(%d+)/(%d+)')
                        local a, b = ParseFraction(match[2])
                        a = CheckN(match[1], a, 'Invalid measure')
                        b = CheckN(match[1], b, 'Invalid measure')
                        Parser.sign = (a/b) or Parser.sign --UNSAFE
                        --[[
                        Parser.mpm = Parsed.Metadata.BPM * Parser.sign / 4
                        Parser.mspermeasure = 60000 * Parser.sign * 4 / Parsed.Metadata.BPM
                        --]]
                    elseif match[1] == 'BPMCHANGE' then
                        --[[
                            - Changes song's BPM, similar to BPM: command in metadata.
                            - Can be placed in the middle of a measure, therefore it is necessary to calculate milliseconds per measure value for each note.
                        ]]
                        --Parsed.Metadata.BPM = tonumber(match[2]) or Parsed.Metadata.BPM --UNSAFE
                        Parser.bpm = CheckN(match[1], match[2], 'Invalid bpmchange') or Parser.bpm --UNSAFE

                        if Parser.attachbpmchange then
                            --Parser.zeroopt = false
                            --NO: Attach it to next note
                            table.insert(Parser.currentmeasure, {
                                --match[1],
                                'BPMCHANGE',
                                Parser.bpm
                            }) --Just like delay
                        end
                    elseif match[1] == 'DELAY' then
                        --[[
                            - Floating point value in seconds that offsets the position of the following song notation.
                            - If value is negative, following song notation will overlap with the previous. - All notes should be placed in such way that notes after #DELAY do not appear earlier or at the same time as the notes before.
                            Can be placed in the middle of a measure.
                        ]]
                        --Parser.ms = Parser.ms + (1000 * (tonumber(match[2]) or 0)) --UNSAFE --QUESTIONABLE
                        local a = SToMs((CheckN(match[1], match[2], 'Invalid delay') or 0)) --UNSAFE
                        --[=[
                        if Parser.stopsong then
                            Parser.delay = Parser.delay + a
                            --[[
                            table.insert(Parser.currentmeasure, {
                                --match[1] .. '2',
                                'DELAY2',
                                a
                            })
                            --]]
                        end
                        -- [[
                        table.insert(Parser.currentmeasure, {
                            --match[1],
                            'DELAY',
                            a
                        })
                        --]]
                        --]=]
                        if Parsed.Metadata.STOPSONG then
                            Parser.delay = Parser.delay + a
                            --Parser.zeroopt = false
                        end
                        table.insert(Parser.currentmeasure, {
                            --match[1],
                            'DELAY',
                            a
                        })


                        --[[
                        --don't add ms delay if stopsong (wrong)
                        if Parser.stopsong then
                            Parser.delay = Parser.delay + a
                        else
                            table.insert(Parser.currentmeasure, {
                                match[1],
                                a
                            })
                        end
                        --]]
                    elseif match[1] == 'SCROLL' then
                        --[[
                            - Multiplies the default scrolling speed by this value
                            - Changes how the notes appear on the screen, values above 1 will make them scroll faster and below 1 scroll slower.
                            - Negative values will scroll notes from the left instead of the right. This behaviour is not supported in taiko-web.
                            - The value cannot be 0.
                            - Can be placed in the middle of a measure.
                        ]]
                        if Parser.disablescroll then

                        else
                            Parser.scrollx, Parser.scrolly = ParseScroll(match)
                        end
                    elseif match[1] == 'GOGOSTART' then
                        --[[
                            - Activates Go-Go Time mode for notes between #GOGOSTART and #GOGOEND.
                            - Don will be dancing, bar will be glowing, and marker will be burning during this mode.
                            - Score is multiplied by 1.2 for all notes hit during this mode.
                            - Can be placed in the middle of a measure.
                        ]]
                        --[[
                        table.insert(Parsed.Data, {
                            ms = ms,
                            data = 'event',
                            event = 'enablegogo'
                        })
                        --]]
                        --[[
                        table.insert(Parser.currentmeasure, {
                            match[1]
                        })
                        ]]
                        Parser.gogo = true
                    elseif match[1] == 'GOGOEND' then
                        --[[
                        table.insert(Parsed.Data, {
                            ms = ms,
                            data = 'event',
                            event = 'disablegogo'
                        })
                        --]]
                        --[[
                        table.insert(Parser.currentmeasure, {
                            match[1]
                        })
                        --]]
                        Parser.gogo = false
                    elseif match[1] == 'BARLINEOFF' then
                        --[[
                            - Turns off the visual appearance of measure lines between #BARLINEOFF and #BARLINEON commands.
                        ]]
                        Parser.barline = false
                    elseif match[1] == 'BARLINEON' then
                        Parser.barline = true
                    elseif match[1] == 'BRANCHSTART' then
                        --[[
                            - Having this command in a song notation will mark the song's difficulty on song selection as having diverge notes and the song will appear to start on the Normal branch. When hosted on taiko-web, branch field in the database is used.
                            - Value is a comma separated array. First value in that array is type, second is advanced requirement, third is master requirement.
                            - If the type is "r", amount of drumroll and balloon hits determines the path.
                            - If the type is "p" or any other value, accuracy determines the path. Note accuracy between #SECTION and one measure before #BRANCHSTART are summed together, divided by their amount, and multiplied by 100 (exception: zero amount of notes will equal zero accuracy). GOOD notes have 1 accuracy, OK notes have 0.5 accuracy, and BAD notes have 0 accuracy.
                            - Advanced requirement and master requirement values is the minimum threshold for drumroll hits or accuracy. Some paths can be made impossible to get to by placing the requirement value out of bounds (such as negative values and values above 100 for "p" type) or having advanced requirement greater than master, which makes the master requirement override advanced.
                            - The requirement is calculated one measure before #BRANCHSTART, changing the branch visually when it is calculated and changing the notes after #BRANCHSTART.
                            - The first measure's line after #BRANCHSTART is always yellow.
                            - Branch can be ended either with #BRANCHEND or with another #BRANCHSTART.
                        ]]
                        if Parser.branch.on then
                            --Branch can be ended with #BRANCHSTART too
                            --ParseError(match[1], 'Branch has not ended')
                            Parser.endbranch()
                        end
                        Parser.msbeforebranch = Parser.ms
                        Parser.branch.on = true
                        Parsed.Metadata.DIVERGENOTES = true
                        local t = CheckCSV(match[1], match[2])
                        local f = Check(match[1], Taiko.Data.Branch.Requirements[string.lower(t[1])], 'Invalid type', t[1])
                        Parser.branch.requirements = {f}
                        local i = 2
                        while true do
                            if not t[i] then
                                break
                            end
                            local p = Taiko.Data.Branch.PathName[i - 1]
                            if p then
                                Parser.branch.requirements[p] = t[i]
                            else
                                break
                            end
                            i = i + 1
                        end
                    --elseif match[1] == 'N' then
                    elseif Taiko.Data.Branch.PathId[match[1]] then
                        --[[
                            - Starts a song notation for a path:
                                - #N - starts Normal path, background is the default grey.
                                - #E - starts Advanced or Professional path, background is blue.
                                - #M - starts Master path, background is purple.
                            - Only one of the paths from a #BRANCHSTART can be played in one go.
                            - When taking a path, it skips measures, notes, and commands from all other paths, except for iterating over the BALLOON: metadata.
                            - The path is required if the requirement does not make it impossible to get to.
                            - All paths can be omitted, ending the branch with #BRANCHEND immediately.
                            - All paths are required to have their measures complete in the same time at the end.
                        ]]
                        if Parser.branch.on then
                            Parser.ms = Parser.msbeforebranch
                            Parser.currentbranch = match[1]
                            Parser.branch.paths[match[1]] = {}
                            Parser.measurepushto = Parser.branch.paths[match[1]]
                        else
                            ParseError(match[1], 'Branch has not started')
                        end
                    --elseif match[1] == 'E' then
                    --elseif match[1] == 'M' then
                    elseif match[1] == 'BRANCHEND' then
                        --[[
                            - Begins a normal song notation without branching.
                            - Retains the visual branch from previous #BRANCHSTART.
                        ]]
                        if Parser.branch.on then
                            Parser.endbranch()
                        else
                            ParseError(match[1], 'Branch has already ended')
                        end
                    elseif match[1] == 'SECTION' then
                        --[[
                            - Reset accuracy values for notes and drumrolls on the next measure.
                            - Placing it near #BRANCHSTART or a measure before does not reset the accuracy for that branch. The value is calculated before it and a measure has not started yet at that point.
                        ]]
                        Parser.section = true
                    elseif match[1] == 'LYRIC' then
                        --[[
                            - Shows song lyrics at the bottom of the screen until the next #LYRIC command.
                            - Line breaks can be added with \n.
                            - Has to be repeated for each difficulty.
                            - Can be placed in the middle of a measure.
                            - If LYRICS: is defined in the metadata, the command is ignored.
                        ]]
                        --WebVTT is handled in the Metadata section (before song start)
                        table.insert(Parser.currentmeasure, {
                            --match[1],
                            'LYRIC',
                            match[2]
                        }) --Just like delay
                    elseif match[1] == 'LEVELHOLD' then
                        --[[
                            - The branch that is currently being played is forced until the end of the song.
                            - Ignored in taiko-web.
                        ]]
                    elseif match[1] == 'BMSCROLL' then
                        --[[
                            - Command that appears one line before a #START command.
                            - #BPMCHANGE will make the notes after it appear at the same scrolling speed as the notes that are currently being played, but then change their speed suddenly after #BPMCHANGE is passed.
                            - #DELAY will stop the scrolling completely.
                            - #BMSCROLL ignores #SCROLL commands.
                            - Behaviour can be turned off by the user.
                            - Ignored in taiko-web.
                        ]]
                        --[[
                        https://wikiwiki.jp/jiro/%E5%A4%AA%E9%BC%93%E3%81%95%E3%82%93%E6%AC%A1%E9%83%8E
                            - Please describe before #START.
                            - If this command is present, the musical score is forcibly scrolled in the same manner as Taiko-san Taro (the value of #SCROLL is ignored).
                            - Also, at this time, the score stops scrolling at the point where #DELAY is.
                            - In short, the score scrolls according to the current BPM.
                        ]]
                        Parser.disablescroll = true
                        if not Parsed.Flag.PARSER_FORCE_OLD_BPMCHANGE then
                            Parser.attachbpmchange = true
                        end
                        --Parser.stopsong = true
                        Parsed.Metadata.STOPSONG = true
                    elseif match[1] == 'HBSCROLL' then
                        --[[
                        https://wikiwiki.jp/jiro/%E5%A4%AA%E9%BC%93%E3%81%95%E3%82%93%E6%AC%A1%E9%83%8E
                            - Please describe before #START.
                            - If this instruction is present, the scroll method will include the effect of #SCROLL in BMSCROLL.
                        ]]
                        if not Parsed.Flag.PARSER_FORCE_OLD_BPMCHANGE then
                            Parser.attachbpmchange = true
                        end
                        --Parser.stopsong = true
                        Parsed.Metadata.STOPSONG = true
                    elseif match[1] == 'NMSCROLL' then
                        --[[
                            https://github.com/0auBSQ/OpenTaiko/issues/308
                            - Additionally, provide a #NMSCROLL command to reset to Normal scrolltype.
                        ]]
                        if not Parsed.Flag.PARSER_FORCE_OLD_BPMCHANGE then
                            Parser.attachbpmchange = false
                        end
                        Parsed.Metadata.STOPSONG = false
                    elseif match[1] == 'SENOTECHANGE' then
                        --[[
                            - Force note lyrics with a specific value, which is an integer index for the following lookup table:
                                - 1: ドン, 2: ド, 3: コ, 4: カッ, 5: カ, 6: ドン(大), 7: カッ(大), 8: 連打, 9: ー, 10: ーっ!!, 11: 連打(大), 12: ふうせん
                            - The lyrics are replaced only if the next note is Don (1) or Ka (2).
                            - Can be placed in the middle of a measure.
                            - Ignored in taiko-web.
                        ]]
                        Parser.senotechange = CheckN(match[1], match[2], 'Invalid senotechange')
                    elseif match[1] == 'NEXTSONG' then
                        --[[
                            - Changes song when COURSE: is set to "Dan" or "6".
                            - Value is a comma separated array, with these values, all of which are required:
                                - Title
                                - Subtitle
                                - Genre
                                - Audio filename
                                - ScoreInit
                                - ScoreDiff
                            - Comma character in the value can be escaped with a backslash character (\,).
                            - Ignored in taiko-web.
                        ]]
                    elseif match[1] == 'DIRECTION' then
                        --[[
                            - Scrolling direction for notes afterwards.
                            - Value is an integer index for the following lookup table:
                                - 0: From right, 1: From above, 2: From below, 3: From top-right, 4: From bottom-right, 5: From left, 6: From top-left, 7: From bottom-left
                            - Default is 0.
                            - Can be placed in the middle of a measure.
                            Ignored in taiko-web.
                        ]]

                        --Weight
                        --Make seperate function?
                        local str = match[2]
                        local t = Parser.settings.directionweight
                        local sum = 0
                        local n = 0
                        for i = 1, #str do
                            local s = string.sub(str, i, i)
                            if t[s] then
                                sum = sum + t[s]
                                n = n + 1
                            end
                        end
                        if n == 0 then
                            ParseError(match[1], 'Invalid direction')
                        end
                        local final = sum / n
                        local d = math.sqrt(Parser.scrollx ^ 2 + Parser.scrolly ^ 2)
                        local polar = ParsePolarNumber(d, math.rad(final))
                        Parser.scrollx = -polar[1]

                        -- [[
                        Parser.scrolly = polar[2]
                        --print(Parser.scrollx, Parser.scrolly)
                        --]]




                        --[[
                        --by iid
                        Parser.scrolly = polar[2]
                        --print(Parser.scrollx, Parser.scrolly)

                        if Parsed.Flag.PARSER_TJAP3_DIRECTION_FLIP_Y then
                            Parser.scrolly = -Parser.scrolly
                        end
                        --Cancel out the later vertical speed inversion by PARSER_TJAP3_SUDDEN_COMPAT
                        if Parsed.Flag.PARSER_TJAP3_SUDDEN_COMPAT then
                            Parser.scrolly = -Parser.scrolly
                        end
                        --]]


                    elseif match[1] == 'SUDDEN' then
                        --[[
                            - Delays notes from appearing, starting their movement in the middle of the screen instead of off-screen.
                            - The value is two floating point numbers separated with a space.
                            - First value is appearance time, marking the note appearance this many seconds in advance.
                            - Second value is movement wait time, notes stay in place and start moving when this many seconds are left.
                            - Can be placed in the middle of a measure.
                            - Ignored in taiko-web.
                        ]]
                        local t = ParseArguments(match[2])
                        --Both are relative to note ms
                        Parser.suddenappear = -SToMs(CheckN(match[1], t[1], 'Invalid sudden') or (Parser.suddenappear and -MsToS(Parser.suddenappear) or 0))
                        Parser.suddenmove = -SToMs(CheckN(match[1], t[2], 'Invalid sudden') or (Parser.suddenmove and -MsToS(Parser.suddenmove) or 0))
                        if Parsed.Flag.PARSER_TJAP3_SUDDEN_MS_PRECISION then
                            Parser.suddenappear = -math.floor(-Parser.suddenappear)
                            Parser.suddenmove = -math.floor(-Parser.suddenmove)

                            --Possibly a separate flag? any value <0 is considered to be 0 in tjap3
                            if -Parser.suddenappear < 0 then
                                Parser.suddenappear = 0
                            end
                            if -Parser.suddenmove < 0 then
                                Parser.suddenmove = 0
                            end
                        end
                        if Parser.suddenappear == 0 then
                            Parser.suddenappear = nil
                        end
                        if Parser.suddenmove == 0 then
                            Parser.suddenmove = nil
                        end

                        
                    elseif match[1] == 'JPOSSCROLL' then
                        --[[
                            - Linearly transition cursor's position to a different position on a bar.
                            - Value is a space-separated array:
                                - First value is the amount of seconds it takes for cursor to transition. If it takes too long before another #JPOSSCROLL is passed, it will be cancelled and next transition will happen at the cursor's current position.
                                - Second value is the relative distance in pixels to move the cursor.
                            - Third value is the direction, "0" is left and "1" is right.
                            - Can be placed in the middle of a measure.
                            - Ignored in taiko-web.
                        ]]

                        --Parser.zeroopt = false
                        local valid = false
                        local t = ParseArguments(match[2])
                        
                        local function ParseJposscrollDistance(n, str, direction, lanep)
                            --lanep can be used to force
                            if (gimmick and CheckFraction(str)) or (lanep) then
--[[
                            TaikoManyGimmicks
                            JPOSSCROLL.txt

                            Translated
This is a file that describes how to specify the movement distance of JPOSSCROLL.
Please refer to it when creating gimmick scores.

First, there are three ways to specify the movement distance.
As a first example,

#JPOS SCROLL 1 700 1

It's like this,
This is a familiar form in TJAP3.
To explain this example once, it will be like moving 700px to the right over 1 second.

As a second example,

#JPOSSCROLL 1 2/8 1

It's like this,
In TJAP3, it is specified in px, so if the lane length is different depending on the skin, it will not work as expected.
This is the designation method for such people,
To explain this, it's like moving to the right 2/8ths the length of the lane in 1 second.
px can also be specified, but this is prepared for those who want to keep compatibility with other skins.

As a third example,

#JPOS SCROLL 1 default 0

It's like this,
In this example the third parameter becomes meaningless,
If you explain this, it will be like moving to the default position over 1 second.
This is used when you want to return the judgment frame to its original position.
]]
                                Parser.jposscroll.lanep = Parser.jposscroll.lanep or {nil, nil}
                                if CheckFraction(str) then
                                    local a, b = ParseFraction(str)
                                    a = CheckN(match[1], a, 'Invalid jposscroll')
                                    b = CheckN(match[1], b, 'Invalid jposscroll')
                                    Parser.jposscroll.lanep[n] = (a/b) --UNSAFE
                                else
                                    Parser.jposscroll.lanep[n] = str
                                end
                                if direction then
                                    if n == 1 then --x
                                        Parser.jposscroll.lanep[n] = Parser.jposscroll.lanep[n] * (Check(match[1], direction == '0' and -1 or direction == '1' and 1, 'Invalid jposscroll', direction) or 1)
                                    else
                                        Parser.jposscroll.lanep[n] = Parser.jposscroll.lanep[n] * (Check(match[1], direction == '0' and 1 or direction == '1' and -1, 'Invalid jposscroll', direction) or 1)
                                    end
                                end

                                if n == 2 then
                                    if not Parsed.Flag.PARSER_TJAP3_JPOSSCROLL_FLIP_Y then
                                        Parser.jposscroll.lanep[n] = -Parser.jposscroll.lanep[n]
                                    end
                                end
                            elseif gimmick and str == 'default' then
                                Parser.jposscroll.p = 'default'
                            else
                            --[[
                                TJAP3 Default
                                
                                - Linearly transition cursor's position to a different position on a bar.
                                - Value is a space-separated array:
                                    - First value is the amount of seconds it takes for cursor to transition. If it takes too long before another #JPOSSCROLL is passed, it will be cancelled and next transition will happen at the cursor's current position.
                                    - Second value is the relative distance in pixels to move the cursor.
                                - Third value is the direction, "0" is left and "1" is right.
                                - Can be placed in the middle of a measure.
                                - Ignored in taiko-web.
                            ]]
                                Parser.jposscroll.p = Parser.jposscroll.p or {nil, nil}
                                Parser.jposscroll.p[n] = CheckN(match[1], str, 'Invalid jposscroll')

                                if direction then
                                    if n == 1 then --x
                                        Parser.jposscroll.p[n] = Parser.jposscroll.p[n] * (Check(match[1], direction == '0' and -1 or direction == '1' and 1, 'Invalid jposscroll', direction) or 1)
                                    else
                                        Parser.jposscroll.p[n] = Parser.jposscroll.p[n] * (Check(match[1], direction == '0' and 1 or direction == '1' and -1, 'Invalid jposscroll', direction) or 1)
                                    end
                                end

                                if n == 2 then
                                    if not Parsed.Flag.PARSER_TJAP3_JPOSSCROLL_FLIP_Y then
                                        Parser.jposscroll.p[n] = -Parser.jposscroll.p[n]
                                    end
                                end
                            end
                        end



                        if extragimmick then
                            --[[
                                Extra gimmick that I made
                                It's just like scroll
                            ]]
                            if CheckComplexNumber(t[2]) then
                                --Complex Scroll (OpenTaiko)
                                --(x) + (y)i
                                local complex, fracdata = ParseComplexNumberSimple(t[2])
                                --print(LineN, complex[1], complex[2])
                                -- print(t[3])
                                ParseJposscrollDistance(1, complex[1], t[3], fracdata[1])
                                ParseJposscrollDistance(2, complex[2], t[3], fracdata[2])
                                valid = true
                            elseif CheckPolarNumber(t[2]) then
                                --Polar Scroll (TaikoManyGimmicks)
                                --(r),(div),(n)
                                local t2 = CheckCSV(match[1], t[2])
                                if #t2 == 3 then
                                    local lanep = false
                                    if CheckFraction(t2[2]) then
                                        lanep = true
                                        local a, b = ParseFraction(t2[2])
                                        a = CheckN(match[1], a, 'Invalid polar jposscroll')
                                        b = CheckN(match[1], b, 'Invalid polar jposscroll')
                                        t2[2] = (a/b) --UNSAFE
                                    else
                                        t2[2] = CheckN(match[1], t2[2], 'Invalid polar jposscroll')
                                    end
                                    t2[1] = CheckN(match[1], t2[1], 'Invalid polar jposscroll')
                                    t2[3] = CheckN(match[1], t2[3], 'Invalid polar jposscroll')
                                    local polar = ParsePolarNumber(t2[1], math.rad(t2[3] / t2[2] * 360))
                                    ParseJposscrollDistance(1, polar[1], t[3], lanep)
                                    ParseJposscrollDistance(2, polar[2], t[3], lanep)
                                    valid = true
                                else
                                    ParseError(match[1], 'Invalid polar jposscroll')
                                end
                            end
                        else
                        end

                        if valid == false then
                            ParseJposscrollDistance(1, t[2], t[3])
                        end

                        Parser.jposscroll.lengthms = SToMs(CheckN(match[1], t[1], 'Invalid jposscroll') or 0)

                        --[=[
                        --Attach it to last note
                        if #Parser.currentmeasure ~= 0 then
                            Parser.currentmeasure[#Parser.currentmeasure].jposscroll = Parser.jposscroll
                        else
                            Parsed.Data[#Parsed.Data].jposscroll = Parser.jposscroll
                        end
                        --[[
                        Parser.jposscroll.time = nil
                        Parser.jposscroll.p = nil
                        Parser.jposscroll.lanep = nil
                        --]]
                        Parser.jposscroll = {}
                        --]=]



                        --NO: Attach it to next note
                        table.insert(Parser.currentmeasure, {
                            --match[1],
                            'JPOSSCROLL',
                            Parser.jposscroll
                        }) --Just like delay
                        Parser.jposscroll = {}
                        
                    --elseif gimmick then

                        --[[
                            Gimmicks
                        ]]


                        --[[
                            https://github.com/0auBSQ/OpenTaiko/issues/290
                            OpenTaiko-
                        ]]
                        elseif gimmick and match[1] == 'GAMEMODE' then
                            --[[
                                - Change the gamemode in realtime ([game mode] : "Taiko" or "Konga")
                            ]]

                        elseif gimmick and match[1] == 'SPLITLANE' then
                            --[[
                                - Split the lane in 2 distinct lanes, dons appearing at the top lane and kas at the bottom, purple notes are squashed horizontally but overlap the 2 lanes
                            ]]
                            Parser.positionf = function(note, ms, target)
                                local offset = 100 --TODO: DIRTY
                                if note.type == 1 or note.type == 3 then
                                    local newtarget = {target[1], target[2] + offset}
                                    return Taiko.CalculatePosition(note, ms, newtarget)
                                elseif note.type == 2 or note.type == 4 then
                                    local newtarget = {target[1], target[2] - offset}
                                    return Taiko.CalculatePosition(note, ms, newtarget)
                                else
                                    return Taiko.CalculatePosition(note, ms, target)
                                end
                            end
                        elseif gimmick and match[1] == 'MERGELANE' then
                            --[[
                                - Merge back to a single lane if the lane is split
                            ]]
                            Parser.positionf = nil
                        elseif gimmick and match[1] == 'BARLINE' then
                            --[[
                                - Display a barline at the current position
                            ]]
                            --table.insert(Parser.measurepushto, Parser.createbarline())
                            --Push to currentmeasure so delay, jposscroll, etc can be applied
                            table.insert(Parser.currentmeasure, Parser.createbarline())








                        --[[
                            TaikoManyGimmicks
                            readme.txt

                            Translated

==================================================

                 TaikoManyGimmicks

==================================================

●About this simulator

This simulator is made by a kid named barrier.

●Rules

It's a simulator like taiko no 0 people, but it has nothing to do with the original.
Secondary distribution of this simulator is "self-responsibility". (I don't know what will happen)
When posting to SNS such as YouTube, you don't have to ask.

- Contents (file order)

◎Songs folder
Please put the song and score file here.

◎Graphic Set folder
It is a creative skin that can only be used in this simulation (sorry).

◎config.ini
Sim configuration file.

◎DxLib Copyright.txt
This is the copyright notice of the library used.

◎DxLib.dll
This file is essential for running this simulator on a 32bit PC (probably).

◎DxLib_x64.dll
It is an essential file to run this simulator on a 64bitPC (probably).

◎ About GRADATION command sentences.txt
I wrote a separate explanation about the GRADATION statement.

◎keyconfig.ini
It is a key setting file when hitting.

◎readme.txt
It's this file, are you looking at it?

◎TaikoManyGimmicks ver0.6α.exe
This is the startup file of the simulator.

◎TaikoManyGimmicks ver0.6α.exe.config
I don't understand this

◎taikosimu(NN) ver0.5α.pdb
Debug files.

●Functions and command sentences in musical scores

◎ How to operate

Operation is possible with the key data written in keyconfig.ini.
Due to the use of the library used, the method of specifying key data is different from Taiko Sanjiro.

By default S, D, K, L are edges and F, G, H, J are faces.

If you press the slash key, it will enter command input mode and a list of commands will appear.
Let's check the effect of the command by yourself! (= troublesome)

If you set TJACreateMode to 1 in config.ini, it will become a mode specialized for music editing
I'll write down how it works then.

Q key -> Reload sheet music
PgUp -> move forward one bar
PgDn -> go back one bar
Home -> Go to top of score
End -> go to the end of the score

◎ Supported musical score commands (there are also new commands)

#START
■ Declare the start of the score data. Of course, without this, the score will not flow.

#END
■Declare the end of the music data, it is essential when dividing the course.

#SCROLL <rate>
■N times the speed of music flow.

#SCROLL <Realrate>+<Imaginaryrate>i
■ Multiply the speed of the musical score by a+bi (eg #SCROLL 1+2i).

#SCROLL <radius>,<divvalue>,<angle>
■It is a scroll effect consisting of polar coordinates r and θ. If you enter the distance for r, the number of circle divisions for d, and the angle for θ, you can flow from the corresponding angle and distance.

#BPMCHANGE <beattempo>
■ Set the score BPM to n.

#MEASURE <Left>/<Right>
■ Change the length of a bar to a fractional length.

#GOGOSTART
■Start Go Go Time.

#GOGOEND
■ End Go Go Time.

#BARLINEON
■ Display bar lines.

#BARLINOFF
■ Erase bar lines.

#DELAY <second>
■ Shift the musical score for the specified number of seconds.

#BRANCHSTART <type>,<Expart>,<Master>
■ After specifying the type of score branch (p for precision branch, r for repeated hit branch, s for score branch), specify the numerical value for expert branching, and the numerical value for expert branching (N < E < M).

#N
■ Write a normal score from where you wrote this.

#E
■ Write a professional score from where you wrote this.

#M
■ Write a master score from where you wrote this.

#BRANCHEND
■It is for normal completion of musical score branching.

#JUDGEDELAY <x> <y> <z> <w>
When x is 0, return to the normal position, when x is 1 or 3, enter the number of seconds in y or 2, enter the x-axis coordinate, and when x is 2, enter the y-axis coordinate in z or If 3, enter x-axis coordinates, and if x is 3, enter y-axis coordinates.

#DUMMYSTART
■It becomes dummy notes.

#DUMMYEND
■It becomes normal notes.

#NOTESPAWN <type> <second>
■When type is 0, nothing happens from that place.When type is 1, specify the position in seconds to appear.When type is 2, specify the position in seconds to make transparent.

#LYRIC <string>
■ Display the lyrics written in string.

#SUDDEN <second> <second>
■ Appears a seconds ago and starts moving b seconds ago.

#JPOSSCROLL <second> <motionpx> <type>
■ Specify the travel time, travel distance, direction, and specify the travel distance in a separate txt file.

#SIZE <rate>
■ Multiply the note size by x

#COLOR <red> <green> <blue> <alpha>
■You can change the color of your notes.

#ANGLE <angle>
■ Rotate the Notes image n degrees

#GRADATION <type> <second> <type1> <type2>
■ Because it is difficult to explain, please see the txt file that explains how to write

#BARLINESIZE <width> <height>
■ You can change the length and width of bar lines

#RESETCOMMAND
■ Returns the effects of all commands to their initial values

● Release notes

ver 0.1α
■For the time being, distribution and repeated hits are not supported yet, but we plan to support them someday.

ver 0.1β
■ I fixed various bugs and added temporary musical score branches. Also, I diverted the song selection screen that was developed before.

ver 0.2α
■Implemented musical score branching, fixed some skin file loading bugs, added repeated hits, and added a start screen.

ver 0.3α
■ Fixed various bugs and added the concept of commands.

ver 0.3.1α
■ NOTESPAWN bug fix... I thought there was a new bug ()

ver 0.4α
■Fixed various bugs, forcibly fixed the skin loading bug, stabilized the behavior of HBSCROLL, made it compatible with D&D, and also tried implementing the quota gauge and subtitles (loading the skin just for the quota gauge) I can't say that the mechanism has been renewed...).

ver 0.5α
■Fixed various bugs, tentatively supported genre division (maybe it works unexpectedly), tried to change the processing at SongPlaySpeed ​​by frequency (please make it lighter).

ver 0.6α
■Various bug fixes, various original behaviors, more commands added, and since I downgraded to .NET Framework 4, it is now compatible with models up to WinXP (although there may be bugs).

◎Special Thanks

Microsoft
■It is a company that created a code editor called Visual Studio, which is fully equipped with development environments such as C# and C++.

Takumi Yamada
■The person who created the super easy-to-use library called DxLib used in this software.

Akasoko
■This is the person who helped me read the musical score, which is the basis of the taiko drum simulator.

Everyone who DL
■I would appreciate it if you could download it.
                        ]]
                        elseif gimmick and match[1] == 'DUMMYSTART' then
                            --[[
                                - It becomes dummy notes.
                            ]]
                            Parser.dummy = true
                        elseif gimmick and match[1] == 'DUMMYEND' then
                            --[[
                                - It becomes normal notes.
                            ]]
                            Parser.dummy = false
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == '' then
                        elseif gimmick and match[1] == 'RESETCOMMAND' then
                            --[[
                                Returns the effects of all commands to their initial values
                            ]]
                            --Just reset parser?

                            --yes i guess
                            --reset parser?
                            Parser = GetParser()
                            Parser.songstarted = true
                        --end








                    --elseif originalgimmick then

                        
                        elseif originalgimmick and match[1] == 'POSITIONF' then
                            --[[
                                - Note position function override
                                - Called instead of CalculatePosition
                                - Callled with (note, ms, target)
                                - Function should return (x, y) TRANSFORMED
                                - Essentially, function should be the same as CalculatePosition
                                - Function is loadstringed --UNSAFE --DIRTY
                                - Use with no second argument to clear
                            ]]
                            if not match[2] or match[2] == '' then
                                Parser.positionf = nil
                            else

                                

                                --add surrounding function and call to get inner function --DIRTY

                                local f = nil

                                if string.sub(String.TrimLeft(match[2]), 1, #'return function(') == 'return function(' then
                                    --return function expr, add nothing

                                    f = CheckF(match[1], match[2], 'Invalid positionf')()
                                elseif string.sub(String.TrimLeft(match[2]), 1, #'function(') == 'function(' then
                                    --function expr, add return

                                    f = CheckF(match[1], 'return ' .. match[2], 'Invalid positionf')()
                                elseif string.sub(String.TrimLeft(match[2]), 1, #'return ') == 'return ' then
                                    --return normal code, add function wrap

                                    f = CheckF(match[1], 'return function(note,ms,target)' .. match[2] .. ' end', 'Invalid positionf')()
                                else
                                    --normal code, add function wrap and return

                                    f = CheckF(match[1], 'return function(note,ms,target)return ' .. match[2] .. ' end', 'Invalid positionf')()
                                end

                                Parser.positionf = f
                            end

                        elseif originalgimmick and match[1] == 'POSITIONT' then
                            --[[
                                - Functions
                                    - Note position function override
                                    - Called instead of CalculatePosition
                                    - Callled with (note, ms, target)
                                    - Function should return (x, y) TRANSFORMED
                                    - Essentially, function should be the same as CalculatePosition
                                    - Function is loadstringed --UNSAFE --DIRTY
                                - Time
                                    - ms before note hit, positive
                                - Return
                                    - starttime, function, starttime, function, starttime, function, ...
                                - Use with no second argument to clear
                            ]]
                            if not match[2] or match[2] == '' then
                                Parser.positionf = nil
                            else

                                

                                --add surrounding function and call to get inner function --DIRTY

                                local t = nil

                                if string.sub(String.TrimLeft(match[2]), 1, #'return ') == 'return ' then
                                    --return expr, add nothing

                                    t = {CheckF(match[1], match[2], 'Invalid positiont')()}
                                else
                                    --expr, add return

                                    t = {CheckF(match[1], 'return ' .. match[2], 'Invalid positiont')()}
                                end

                                --make t into {{starttime, function}, {starttime, function}, {starttime, function}, ...}
                                local t2 = {}
                                for i = 1, #t, 2 do
                                    t2[#t2 + 1] = {t[i], t[i + 1], {}}
                                end
                                t = nil

                                --sort t2
                                table.sort(t2, function(a, b)
                                    return a[1] > b[1]
                                end)

                                local edgecase = nil
                                if t2[1][1] == math.huge then
                                    edgecase = t2[1]
                                    table.remove(t2, 1)
                                end
                                

                                --Generate positionf function from t
                                Parser.positionf = function(note, ms, target)
                                    --calculate targets
                                    for i = #t2, 1, -1 do
                                        local a = t2[i]
                                        if i == #t2 then
                                            a[3][1], a[3][2] = target[1], target[2]
                                        else
                                            local howmuchmsbefore = t2[i + 1][1] - (t2[i + 2] and t2[i + 2][1] or 0)
                                            -- local howmuchmsbefore = t2[i][1] - (t2[i + 1] and t2[i + 1][1] or 0)
                                            a[3][1], a[3][2] = (t2[i + 1])[2](note, note.ms - howmuchmsbefore, t2[i + 1][3])
                                        end
                                        --print(a[1], unpack(a[3]))
                                    end

                                    local mstilhit = note.ms - ms
                                    --print(mstilhit)
                                    for i = #t2, 1, -1 do
                                        local a = t2[i]
                                        if mstilhit < a[1] then
                                            local finishms = t2[i + 1] and t2[i + 1][1] or 0
                                            --if math.random(1,2)==1 then return unpack(a[3])end
                                            return a[2](note, ms + finishms, a[3])
                                        end
                                    end

                                    --unable to satisfy any time conditions, use calculateposition default
                                    local howmuchmsbefore = t2[1][1] - (t2[2] and t2[2][1] or 0)
                                    edgecase[3][1], edgecase[3][2] = (t2[1])[2](note, note.ms - howmuchmsbefore, t2[1][3])

                                    local finishms = t2[1] and t2[1][1] or 0
                                    --if math.random(1,2)==1 then return unpack(edgecase[3])end
                                    return edgecase[2](note, ms + finishms, edgecase[3])
                                end
                            end

                        elseif originalgimmick and (match[1] == 'POSITIONS' or match[1] == 'SCROLLT') then --TODO: OPTIMIZE, SLOW, DIRTY (especially the positionf function)
                            --[[
                                - Scroll values:
                                    - Complex or normal
                                - Time
                                    - ms before note hit, positive
                                - Use with no second argument to clear
                            ]]
                            if not match[2] or match[2] == '' then
                                Parser.positionf = nil
                            else

                                

                                --add surrounding function and call to get inner function --DIRTY

                                local t = nil

                                if string.sub(String.TrimLeft(match[2]), 1, #'return ') == 'return ' then
                                    --return expr, add nothing

                                    t = {CheckF(match[1], match[2], 'Invalid positions')()}
                                else
                                    --expr, add return

                                    t = {CheckF(match[1], 'return ' .. match[2], 'Invalid positions')()}
                                end

                                --Set both scrolls to 1, so that the position calculation works correctly (DIRTY)
                                local oldscrollx, oldscrolly = Parser.scrollx, Parser.scrolly
                                Parser.scrollx = 1
                                Parser.scrolly = 1


                                --make t into {{starttime, function}, {starttime, function}, {starttime, function}, ...}
                                local t2 = {}
                                for i = 1, #t, 2 do
                                    --ONLY DIFFERENT PART FROM POSITIONT (DIRTY, POSSIBLY OPTIMIZE)
                                    t[i + 1] = {ParseScroll({match[1], t[i + 1]})}
                                    -- print(t[i + 1], scrollx, scrolly)

                                    t2[#t2 + 1] = {t[i], t[i + 1], {}}
                                end
                                t = nil

                                --sort t2
                                table.sort(t2, function(a, b)
                                    return a[1] > b[1]
                                end)

                                local edgecase = nil
                                if t2[1][1] == math.huge then
                                    edgecase = t2[1]
                                    table.remove(t2, 1)
                                else
                                    --use old scroll
                                    edgecase = {math.huge, {oldscrollx, oldscrolly}, {}}
                                end



                                --Generate positionf function from t
                                local ospeed = nil
                                Parser.positionf = function(note, ms, target)
                                    --calculate targets (CANNOT DO FOR #POSITIONF since targets may be dynamic)
                                    if not t2[1][3][1] then
                                        ospeed = note.speed
                                        for i = #t2, 1, -1 do
                                            local a = t2[i]
                                            if i == #t2 then
                                                a[3][1], a[3][2] = target[1], target[2]
                                            else
                                                local howmuchmsbefore = t2[i + 1][1] - (t2[i + 2] and t2[i + 2][1] or 0)
                                                -- local howmuchmsbefore = t2[i + 1][1] - (t2[i + 2] and t2[i + 2][1] or 0)
                                                note.speed = {ospeed[1] * t2[i + 1][2][1], ospeed[2] * t2[i + 1][2][2]}
                                                a[3][1], a[3][2] = Taiko.CalculatePosition(note, note.ms - howmuchmsbefore, t2[i + 1][3])
                                            end

                                            -- print(a[1], unpack(a[3]))
                                        end

                                        local howmuchmsbefore = t2[1][1] - (t2[2] and t2[2][1] or 0)
                                        note.speed = {ospeed[1] * t2[1][2][1], ospeed[2] * t2[1][2][2]}
                                        edgecase[3][1], edgecase[3][2] = Taiko.CalculatePosition(note, note.ms - howmuchmsbefore, t2[1][3])
    


                                        note.speed = ospeed
                                    end
                                    -- error()

                                    local mstilhit = note.ms - ms
                                    --print(mstilhit)
                                    for i = #t2, 1, -1 do
                                        local a = t2[i]
                                        if mstilhit < a[1] then
                                            local finishms = t2[i + 1] and t2[i + 1][1] or 0
                                            --if math.random(1,2)==1 then return unpack(a[3])end
                                            note.speed = {ospeed[1] * a[2][1], ospeed[2] * a[2][2]}
                                            return Taiko.CalculatePosition(note, ms + finishms, a[3])
                                        end
                                    end

                                    --unable to satisfy any time conditions, use calculateposition default

                                    local finishms = t2[1] and t2[1][1] or 0
                                    --if math.random(1,2)==1 then return unpack(edgecase[3])end
                                    return Taiko.CalculatePosition(note, ms + finishms, edgecase[3])
                                end
                            end
                        --end







                    else
                        --Invalid command
                        if strict then
                            ParseError('parser.parsecommand', 'Invalid command')
                        end
                    end



                    done = true
                end
            end


            if (Parser.songstarted) and done == false then
                --Recalculate
                Parser.mpm = Parser.bpm * Parser.sign / 4
                Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm

                --[=[
                --UPDATE: ADD WHEN PUSHING
                --Barline
                --get first note and make barline
                if Parser.barline and #Parser.currentmeasure == 0 then
                    --[[
                    table.insert(Parsed.Data, {
                        ms = Parser.ms,
                        data = 'event',
                        event = 'barline'
                    })
                    --]]
                    local note = Parser.createnote()
                    note.ms = Parser.ms
                    note.data = 'event'
                    note.event = 'barline'
                    table.insert(Parser.currentmeasure, note)
                end
                --]=]



                --BARLINE
                if Parser.barline and Parser.insertbarline then
                    --[[
                    table.insert(Parsed.Data, {
                        ms = Parser.ms,
                        data = 'event',
                        event = 'barline'
                    })
                    --]]
                    --table.insert(Parser.currentmeasure, 1, note)
                    --table.insert(Parser.measurepushto, 1, note)
                    --table.insert(Parser.measurepushto, Parser.createbarline())
                    --Push to currentmeasure so delay, jposscroll, etc can be applied
                    table.insert(Parser.currentmeasure, Parser.createbarline())
                    Parser.insertbarline = false
                end











                --Could not recognize command, probably just raw data
                --example: 11,
                --get raw data
                --local data = {}

                for i = 1, #line do
                    local s = string.sub(line, i, i)
                    --[[
                    local n = CheckN('parser.noteparse', tonumber(s) or Parser.settings.noteparse.notealias[s] or s, 'Invalid note')
                    if n then
                        local note = Parser.createnote(n)
                        note.data = 'note'
                        --note.type = n
                        table.insert(Parser.currentmeasure, note)
                    end
                    --]]
                    local n = tonumber(s) or s
                    if Parser.settings.noteparse.notes[n] then
                        local note = Parser.createnote(n)
                        note.data = 'note'
                        --note.type = n
                        table.insert(Parser.currentmeasure, note)
                    else
                        if strict then
                            if Parser.settings.strict.noteparse.notes[s] then
                                --Good
                            else
                                local lastsymbol = #String.TrimRight(line)
                                if i == lastsymbol then
                                    --Edge case: Ends with comma
                                else
                                    --ParseError('parser.noteparse', 'Invalid symbol' .. string.byte(s))
                                    ParseError('parser.noteparse', 'Invalid symbol')
                                end
                            end
                        end
                    end
                end

                if String.EndsWith(String.TrimRight(line), ',') then
                    -- [[
                    --Recalculate --FIX
                    Parser.mpm = Parser.bpm * Parser.sign / 4
                    Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm
                    --]]








                    --add notes
                    if #Parser.currentmeasure == 0 then
                        Parser.ms = Parser.ms + Parser.mspermeasure

                        Parser.measuredone = true
                        --Parser.currentmeasure = {}
                        --Parser.zeroopt = zeroopt
                        Parser.insertbarline = true
                    elseif #Parser.currentmeasure == 1 and Parser.currentmeasure[1].data == 'event' and Parser.currentmeasure[1].event == 'barline' then
                        Parsed.Data[#Parsed.Data + 1] = Parser.currentmeasure[1]
                        Parser.ms = Parser.ms + Parser.mspermeasure

                        Parser.measuredone = true
                        Parser.currentmeasure = {}
                        --Parser.zeroopt = zeroopt
                        Parser.insertbarline = true
                    else
                        --count notes
                        local notes = 0
                        local firstmspermeasure = nil
                        --local delaytemp = 0
                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]
                            if c.data == 'note' then
                                firstmspermeasure = firstmspermeasure or c.mspermeasure
                                --delaytemp = delaytemp - (delaytemp - c.delay)
                                notes = notes + 1
                            end
                        end
                        firstmspermeasure = firstmspermeasure or Parser.mspermeasure
                        --loop
                        local increment = firstmspermeasure / notes
                        --print(increment)
                        --print(firstmspermeasure, increment, notes)
                        local nextjposscroll = false
                        local nextbpmchange = false
                        local nextlyric = false

                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]

                            if c[1] == 'DELAY' then
                                Parser.ms = Parser.ms + c[2]
                            elseif c[1] == 'JPOSSCROLL' then
                                --[[
                                if i == #Parser.currentmeasure then
                                    --We'll push it later after initing currentmeasure
                                    --Last note: move it to next measure
                                    Parser.currentmeasure[i] = nil
                                    nextjposscroll = c
                                else
                                    --Not last note: add it to next note
                                    nextjposscroll = c
                                end
                                --]]
                                nextjposscroll = c
                                Parser.zeroopt = false
                            elseif c[1] == 'BPMCHANGE' then
                                nextbpmchange = c
                                Parser.zeroopt = false
                            elseif c[1] == 'LYRIC' then
                                nextlyric = c
                                Parser.zeroopt = false
                            else
                                --drumrollbend?
                                if Parser.drumrollbend and c.type == 0 and (c.scrollx ~= Parser.drumrollbendstart.scrollx or c.scrolly ~= Parser.drumrollbendstart.scrolly or c.positionf ~= Parser.drumrollbendstart.positionf) then
                                    --WARMING: ms not yet included
                                    Parser.drumrollbend[#Parser.drumrollbend + 1] = c
                                end

                                --if it is not air
                                if not Parser.zeroopt or c.type ~= 0 then --zeroopt
                                    c.ms = Parser.ms

                                    --sudden?
                                    --[[
                                    c.appearancems = c.appearancems and (c.ms - (c.appearancems))
                                    c.movems = c.movems and (c.ms - (c.movems))
                                    --]]
                                    --c.measuredensity = notes
                                    local lastnote = Parser.measurepushto[#Parser.measurepushto] or Parsed.Data[#Parsed.Data]
                                    if lastnote then
                                        lastnote.nextnote = c
                                        --[[
                                        --to stop infinite loop from table visualizers --PERFORMANCE
                                        setmetatable(lastnote, {
                                            __index = function(t, k)
                                                if k == 'nextnote' then
                                                    return c
                                                end
                                            end,
                                            __metatable = {}
                                        })
                                        --]]
                                    end


                                    --benddrumroll?
                                    if originalgimmick then
                                        if c.type == 5 or c.type == 6 and (not Parser.drumrollbend) then
                                            c.drumrollbend = {}
                                            Parser.drumrollbend = c.drumrollbend
                                            Parser.drumrollbendstart = c
                                        end
                                        if c.type == 8 then
                                            Parser.drumrollbend = nil
                                        end
                                    end


                                    table.insert(Parser.measurepushto, c)
                                    --onnotepush --balloon
                                    if c.onnotepush then
                                        c.onnotepush()
                                    end
                                    --increment = (c.mspermeasure / notes) / c.speed
                                    increment = c.mspermeasure / notes
                                end

                                if nextjposscroll then
                                    --Put jposscroll on!
                                    c.jposscroll = nextjposscroll[2]
                                    --c.jposscroll.startms = c.ms --no need, just use note.ms
                                    nextjposscroll = false
                                end
                                if nextbpmchange then
                                    --Put bpmchange on!
                                    c.bpmchange = nextbpmchange[2]
                                    nextbpmchange = false
                                end
                                if nextlyric then
                                    --Put lyric on!

                                    --Actually, don't put lyric on! put it in Parsed.Lyric, use note.ms
                                    table.insert(Parsed.Lyric, {
                                        ms = c.ms - Parsed.Metadata.OFFSET,
                                        lengthms = nil, --nil means indefinite
                                        data = nextlyric[2]
                                    })
                                    nextlyric = false
                                end

                                --All leading attaches have been resolved
                                if c.type == 0 then
                                    Parser.zeroopt = zeroopt
                                end

                                --[[
                                    SENOTES v2
                                    just check if increment was same as before
                                ]]
                                if c.type == 1 or c.type == 2 then
                                    if not Parser.senotems then
                                        --notechain new start
                                        if Parser.senotems == nil then
                                            Parser.senotems = false
                                        elseif Parser.lastsenote then
                                            --START
                                            local a = (c.ms or Parser.ms) - Parser.lastsenote.ms
                                            --break notechain if too far ms (ADJUST SENOTE)
                                            if a < 200 then
                                                Parser.senotems = a
                                                if Parser.lastlastsenote and (Parser.lastsenote.ms - Parser.lastlastsenote.ms == Parser.senotems) then
                                                    --Amend
                                                    Parser.lastlastsenote.senote = Taiko.Data.SENotes[Parser.lastlastsenote.type][2]
                                                end
                                            end
                                        end
                                    end

                                    if Parser.senotems then
                                        if c.ms - (Parser.lastsenote and Parser.lastsenote.ms or 0) == Parser.senotems then
                                            --notechain continues
                                            --[[
                                            Parser.lastsenote.senote = Taiko.Data.SENotes[Parser.lastsenote.type][Parser.senotei == false and 3 or 2]
                                            Parser.senotei = not Parser.senotei
                                            --]]
                                            Parser.lastsenote.senote = Taiko.Data.SENotes[Parser.lastsenote.type][2]
                                        elseif Parser.lastsenote and Taiko.Data.SENotes[Parser.lastsenote.type] then
                                            --notechain ends (last note)
                                            --print(Parser.senotems, c.ms - (Parser.lastsenote and Parser.lastsenote.ms or 0))
                                            Parser.lastsenote.senote = Taiko.Data.SENotes[Parser.lastsenote.type][1]
                                            --Parser.senotei = false
                                            Parser.senotems = false
                                        end
                                    elseif Parser.lastsenote then
                                        Parser.lastsenote.senote = Taiko.Data.SENotes[Parser.lastsenote.type][1]
                                    end

                                    --print(c.ms - (Parser.lastsenote and Parser.lastsenote.ms or 0))


                                    

                                    Parser.lastlastsenote = Parser.lastsenote
                                    Parser.lastsenote = c

                                elseif c.type == 3 or c.type == 4 or c.type == 7 or c.type == 5 or c.type == 6 then
                                    --[[
                                        big notes, balloon: just use senotes cause theres only 1
                                        drumroll: just use start senote, let playsong handle rest
                                    ]]
                                    c.senote = Taiko.Data.SENotes[c.type][1]
                                    --break notechain
                                    Parser.senotems = false
                                
                                end








                                --[[
                                    SENOTES
                                    https://github.com/EricLiver/cjdg/blob/master/public/src/js/parsetja.js#L258-L289

                                    in js, and is evalued before or
                                --]]
                                --[[
                                if c.type then
                                    if c.type == 1 or c.type == 2 or c.type == 3 or c.type == 4 then
                                        Parser.notechain[#Parser.notechain + 1] = c
                                    else
                                        if #Parser.notechain > 1 and #Parser.currentmeasure >= 8 then
                                            Parser.checknotechain(Parser.notechain, #Parser.currentmeasure, false)
                                        end
                                        Parser.notechain = {}
                                    end
                                elseif
                                    (#Parser.currentmeasure < 24 or (
                                        Parser.currentmeasure[i + 1]
                                        and (not Parser.currentmeasure[i + 1].type)
                                    ) and (#Parser.currentmeasure < 48 or (
                                        Parser.currentmeasure[i + 2]
                                        and (not Parser.currentmeasure[i + 2].type)
                                        and Parser.currentmeasure[i + 3]
                                        and (not Parser.currentmeasure[i + 3].type)
                                    ))) then
                                    if #Parser.notechain > 1 and #Parser.currentmeasure >= 8 then
                                        Parser.checknotechain(Parser.notechain, #Parser.currentmeasure, true)
                                    end
                                    Parser.notechain = {}
                                end
                                --]]


                                if c.data == 'note' then
                                    --not barline
                                    Parser.ms = Parser.ms + increment
                                end
                            end
                        end

                        Parser.measuredone = true
                        Parser.currentmeasure = {}
                        Parser.zeroopt = zeroopt
                        Parser.insertbarline = true
                        if nextjposscroll then
                            Parser.currentmeasure[#Parser.currentmeasure + 1] = nextjposscroll
                            --Parser.zeroopt = false
                        end
                        if nextbpmchange then
                            Parser.currentmeasure[#Parser.currentmeasure + 1] = nextbpmchange
                            --Parser.zeroopt = false
                        end
                        if nextlyric then
                            Parser.currentmeasure[#Parser.currentmeasure + 1] = nextlyric
                            --Parser.zeroopt = false
                        end
                        --Parser.zeroopt = zeroopt
                    end
                else
                    Parser.measuredone = false
                end
            end

        end
        end
    end



    --Put lyrics for other difficulties if not found
    local lyric = nil
    for k, v in pairs(Out) do
        if #v.Lyric ~= 0 then
            lyric = v.Lyric
            break
        end
    end
    if lyric then
        for k, v in pairs(Out) do
            if #v.Lyric == 0 then
                v.Lyric = lyric
            end
        end
    end


    LineN = 1 --Reset LineN

    --print('Parsing Took: '.. SToMs(os.clock() - time) .. 'ms')


    return Out
end




--Helper Function For Reading TJA and Setting Song Name
--[[
    Returns:

    If success:
        Parsed, nil
    If error:
        nil, Error
]]
function Taiko.ParseTJAFile(path)
    local file = io.open(path, 'r')
    if file then
        local data = file:read('*all')
        file:close()
        --local Parsed = Taiko.ParseTJA(data)

        local Parsed
        local Success, Error = pcall(function()
            Parsed = Taiko.ParseTJA(data)
        end)
        if Success then
            --do nothing, go on
        else
            return nil, Error
        end

        local slashp = string.find(string.reverse(path), '[/\\]') --LAST SLASH REVERSED
        for k, v in pairs(Parsed) do
            v.Metadata.SONG = (
                slashp
                and string.sub(path, 1, #path + 1 - slashp) --Path is in a directory, get directory
                or '' --Path is not in a directory
            ) .. v.Metadata.WAVE
        end
        return Parsed
    else
        return nil, 'Unable to open file'
    end
end






--Taiko.ParseTJA(io.open('./tja/imaginarytest.tja','r'):read('*all'))error()
--Taiko.ParseTJA(io.open('./tja/neta/ekiben/ekiben.tja','r'):read('*all'))error()


--[[
--DELAY MAKER
print('DIF!')
a=Taiko.ParseTJA(io.open('./tja/neta/ekiben/ekiben.tja','r'):read('*all'))
b=Taiko.ParseTJA(io.open('./tja/neta/ekiben/delay.tja','r'):read('*all'))
a,b=a[1].Data,b[1].Data
print(#a,#b)
for k, v in pairs(a) do
    --if a[k].ms~=b[k].ms then
    if math.floor(a[k].ms)~=math.floor(b[k].ms) then
    print(k, a[k].ms, b[k].ms, a[k].type, b[k].line)error()end
    
end
error()

--]]


--[[
--DELAY MAKER
print('DIF!')
a=Taiko.ParseTJA(io.open('./tja/neta/kita/fixedkita.tja','r'):read('*all'))
b=Taiko.ParseTJA(io.open('./taikobuipm/Kita Saitama 2000.tja','r'):read('*all'))
a,b=a[1].Data,b[1].Data
print(#a,#b)
for k, v in pairs(a) do
    --if a[k].ms~=b[k].ms then
    if a[k].type ~=b[k].type then print(k, a[k].ms, b[k].ms, a[k].type, b[k].type, a[k].line, b[k].line) end
    --if math.floor(a[k].ms + 0.5)~=math.floor(b[k].ms+ 0.5) then print(k, a[k].ms, b[k].ms, a[k].type, b[k].type, a[k].line, b[k].line)error()end
    
end
error()

--]]


--[[
--DELAY MAKER
print('DIF!')
a=Taiko.ParseTJA(io.open('./tja/neta/ekiben/neta.tja','r'):read('*all'))
b=Taiko.ParseTJA(io.open('./taikobuipm/Ekiben 2000.tja','r'):read('*all'))
a,b=a[1].Data,b[1].Data
print(#a,#b)
for k, v in pairs(a) do
    if v.data ~= 'note' then
        a[k] = nil
    end
end

for k, v in pairs(b) do
    if v.data ~= 'note' then
        b[k] = nil
    end
end


for k, v in pairs(a) do
    --if a[k].ms~=b[k].ms then
    if a[k].type ~=b[k].type then print(k, a[k].ms, b[k].ms, a[k].type, b[k].type, a[k].line, b[k].line)error() end
    --if math.floor(a[k].ms + 0.5)~=math.floor(b[k].ms+ 0.5) then print(k, a[k].ms, b[k].ms, a[k].type, b[k].type, a[k].line, b[k].line)error()end
    
end
error()
--]]


--[===[
--v1
--Serialize TJA Parsed into TJA
function Taiko.SerializeTJA(Parsed) --Parsed should be a top level parsed object
    --[[
        TODO:
        BMSCROLL, HBSCROLL
    ]]




    local function Round(a)
        return math.floor(a + 0.5)
    end
    local decplaces = 5
    local decmult = 10 ^ decplaces
    local function RoundFloat(f)
        return math.floor(f * decmult + 0.5) / decmult
    end
    local function FloatToString(f)
        if math.floor(f) ~= f then
        return string.format('%f', f)
        else
            return tostring(f)
        end
    end

    --https://www.geeksforgeeks.org/program-find-gcd-floating-point-numbers/
    local function Gcd(a, b)
        --negative check
        --[[
        if a < 0 or b < 0 then
            return nil
        end
        --]]

        if a < b then
            return Gcd(b, a)
        end
        if math.abs(b) < 0.001 then
            return a
        else
            return Gcd(b, a - math.floor(a / b) * b)
        end
    end
    local function ToFraction(n)
        local a = Gcd(n, 1)
        return Round(n / a), Round(1 / a)
    end
    local function FromFraction(f)
        local a, b = string.match(f, '(%d+)/(%d+)')
        return a, b
    end


    --Simple, can't handle complex
    local function SerializeCSV(t)
        for i = 1, #t do
            t[i] = tostring(t[i])
        end
        return table.concat(t, ',')
    end

    local function Serialize(ParsedData)
        local Out = {}

        local MsData = {
            OFFSET = true,
            DEMOSTART = true,
        }

        --Metadata
        --This also stores debug information + unneeded, since there is no efficient way to filter metadata
        for k, v in pairs(ParsedData.Metadata) do
            local v2
            if type(v) == 'number' then
                --figure out if ms or not
                if MsData[k] then
                    v2 = tostring(MsToS(tonumber(v)))
                else
                    v2 = tostring(v)
                end
            elseif type(v) == 'table' then
                --assume csv
                v2 = SerializeCSV(v)
            elseif type(v) == 'string' then
                v2 = tostring(v)
            else
                v2 = nil
            end

            if v2 then
                Out[#Out + 1] = k
                Out[#Out + 1] = ':'
                Out[#Out + 1] = v2
                Out[#Out + 1] = '\n'
            end
        end
        Out[#Out + 1] = '\n\n'



        --One look through notes (barline)
        local barline = false
        local delay = false
        local scroll = ParsedData.Metadata.HEADSCROLL
        for i = 1, #ParsedData.Data do
            local note = ParsedData.Data[i]
            note.ms = note.ms - note.delay --DELAY
            --barline
            if note.data == 'event' and note.event == 'barline' then
                barline = true
                --print(i)
            end
            --delay
            if note.delay and note.delay ~= 0 then
                delay = true
            end
            --scroll
            if note.scroll and note.scroll ~= scroll then
                scroll = false
            end

        end

        if delay then
            if scroll then
                Out[#Out + 1] = '#BMSCROLL\n'
            else
                Out[#Out + 1] = '#HBSCROLL\n'
            end
        end

        Out[#Out + 1] = '#START\n'

        if barline then
            Out[#Out + 1] = '#BARLINEON\n'
        else
            Out[#Out + 1] = '#BARLINEOFF\n'
        end










        --Do notes
        --Measure grouping will be dirty, but as long as it works

        local currentmeasure = {
            startms = nil,
        }
        local mspermeasure = nil
        local measurestartms = 0

        --parser / ram
        local state = {
            scroll = 0,
            bpm = ParsedData.Metadata.BPM,
            measure = nil,
            gogo = false,
            delay = 0
        }

        --containing all the data to compute
        local current = {
            --name = {'#CMD', currentvalue, function to get value, recompute every time?, don't replace with value}
            scroll = {'#SCROLL ', nil, function(note)
                local a = note.scroll / ParsedData.Metadata.HEADSCROLL
                if a ~= state.scroll then
                    state.scroll = a
                    return tostring(a)
                end
            end},
            bpm = {'#BPMCHANGE ', tostring(ParsedData.Metadata.BPM), function(note)
                local a = note.bpm
                if a ~= state.bpm then
                    state.bpm = a
                    return tostring(a)
                end
            end},
            measure = {'#MEASURE ', false, function(note)
                --BPM = MEASURE / SIGN * 4
                --SIGN = MEASURE / BPM * 4
                local a, b = ToFraction(note.bpm * note.mspermeasure / 240000)
                local c = a .. '/' .. b
                if c ~= state.measure then
                    state.measure = c
                    return c
                end
            end},
            
            --others
            gogo = {'#GOGO', false, function(note)
                local a = note.gogo
                if a ~= state.gogo then
                    state.gogo = a
                    if a then
                        return 'START'
                    else
                        return 'END'
                    end
                end
            end},
            delay = {'#DELAY ', nil, function(note)
                if note.delay ~= state.delay then
                    local a = note.delay - state.delay
                    state.delay = note.delay
                    return FloatToString(MsToS(a))
                end
            end}

        }


        --createnote
        for i = 1, #ParsedData.Data do
            local note = ParsedData.Data[i]
            local ms = note.ms
            if note.data == 'note' then
                currentmeasure[#currentmeasure + 1] = note

            elseif note.data == 'event' and note.event == 'barline' then
                currentmeasure.startms = note.ms

                currentmeasure[#currentmeasure + 1] = note
            end

            local nextnote = ParsedData.Data[i + 1]
            if (nextnote and nextnote.data == 'event' and nextnote.event == 'barline') or (i == #ParsedData.Data) then
                --push





                
                if #currentmeasure == 0 then
                    --empty measure
                    --current note is barline, next is barline too
                    error('No barline')
                else
                    --push

                    --insert filler
                    local difs = {}
                    for i = 2, #currentmeasure do
                        local n = currentmeasure[i - 1]
                        local n2 = currentmeasure[i]
                        --difs[#difs + 1] = (n2.ms - n2.delay) - (n.ms - n.delay)
                        difs[#difs + 1] = math.abs(n2.ms - n.ms)
                    end
                    --for i = 1, #currentmeasure do print(currentmeasure[i].ms) end
                    --start (no need for start, there is barline)
                    --difs[#difs + 1] = (currentmeasure[1].ms - currentmeasure[1].delay) - currentmeasure.startms
                    --end
                    --difs[#difs + 1] = (currentmeasure.startms + currentmeasure[1].mspermeasure) - (currentmeasure[#currentmeasure].ms - currentmeasure[#currentmeasure].delay)
                    difs[#difs + 1] = math.abs((currentmeasure.startms + currentmeasure[1].mspermeasure) - currentmeasure[#currentmeasure].ms)




                    local gcd = difs[1]
                    for i = 2, #difs do
                        gcd = Gcd(gcd, difs[i])
                    end
                    if gcd == nil then
                        error('gcd invalid, probably delay')
                        gcd = currentmeasure[1] and (currentmeasure[1].ms - measurestartms)
                    end


                    --print(gcd)





                    --currentmeasure
                    local startms = currentmeasure.startms
                    local endms = startms + currentmeasure[1].mspermeasure
                    --loop
                    for i2 = 1, #currentmeasure do
                        local n = currentmeasure[i2]


                        for k, v in pairs(current) do
                            if n[k] == v[2] then
                                --they are equal
                            else
                                local o = v[3](n)
                                if o then
                                    v[2] = o
                                    if Out[#Out] ~= '\n' then
                                        Out[#Out + 1] = '\n'
                                    end
                                    Out[#Out + 1] = v[1]
                                    --Out[#Out + 1] = ' '
                                    Out[#Out + 1] = o
                                    Out[#Out + 1] = '\n'
                                end
                            end

                        end

                        --note type
                        if i2 ~= 1 then
                            --note
                            Out[#Out + 1] = tostring(n.type)
                        end

                        if i2 == 1 and #currentmeasure ~= 1 then
                            --include first note
                            Out[#Out + 1] = string.rep('0', ((currentmeasure[i2 + 1] and currentmeasure[i2 + 1].ms or endms) - n.ms) / gcd)
                        else
                            --exclude first note
                            Out[#Out + 1] = string.rep('0', ((currentmeasure[i2 + 1] and currentmeasure[i2 + 1].ms or endms) - n.ms) / gcd - 1)
                        end


                    end

                    Out[#Out + 1] = ','
                    Out[#Out + 1] = '\n'



                    currentmeasure = {}
                end
            end








                



            
        end

        if Out[#Out] ~= '\n' then
            Out[#Out + 1] = '\n'
        end
        Out[#Out + 1] = '\n#END'


        return table.concat(Out)
    end











    --tests

    --[[
    --kita saitama neta
    a = Serialize(Parsed[1])
    print(a)error()
    --]]


    --[[
    --serializetja.tja
    --a = Serialize(Parsed[4]) --easy
    a = Serialize(Parsed[1]) --oni
    --io.open('outtest.tja','w+'):write(a)
    print(a)error()
    --]]


    local Out = {'// Automatically Serialized by Taiko.SerializeTJA'}
    for k, v in pairs(Parsed) do
        Out[#Out + 1] = Serialize(v)
        

        --testing
        return table.concat(Out, '\n\n')
    end
    Out = table.concat(Out, '\n\n')
    return Out
end
--]===]





--[===[
--v2
--Serialize TJA Parsed into TJA
function Taiko.SerializeTJA(Parsed)
    --Config
    --Multiplier for Metadata, kv pairs
    local MetadataMul = {
        OFFSET = 0.001,
        MOVIEOFFSET = 0.001,
        DEMOSTART = 0.001,

        SONGVOL = 100,
        SEVOL = 100,
    }




    
    local Out = {'// Automatically Serialized by Taiko.SerializeTJA\n\n'}





    --Functions

    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

    --[[
        Automatically pushes to out, returns nothing
        Input: note
        Output: nothing
    ]]
    local lastnote = nil
    local exclude = {
        mspermeasure = true,
        startnote = true,
        endnote = true,
        nextnote = true,
        lengthms = true,
        onnotepush = true,
        data = true,
        line = true,
        type = true,
        ms = true,
        scrolly = true,
    }
    local function SerializeNote(note)
        local delayaddms = 0
        local addfirstnewline = true

        for k, v in spairs(note, function(t, a, b)
            return a < b
        end) do
            if (not exclude[k]) and (not lastnote or not (note[k] == lastnote[k])) then
                --[[
                --TODO: Only output when addnewline is true
                --Output change
                if newline == false then
                    Out[#Out + 1] = '\n'
                    newline = true
                end
                --]]
                --DIRTY --TODO: some memory and cpu is wasted since we are adding it later using table.insert
                local beforenewline = #Out + 1

                local addnewline = true
                
                if k == 'bpm' then
                    Out[#Out + 1] = '#BPMCHANGE '
                    Out[#Out + 1] = tostring(v)
                elseif k == 'scrollx' then
                    --scrollx handles both scrollx and scrolly

                    Out[#Out + 1] = '#SCROLL '
                    Out[#Out + 1] = tostring(-v)
                    if note.scrolly ~= 0 then
                        Out[#Out + 1] = '+'
                        Out[#Out + 1] = tostring(-note.scrolly)
                        Out[#Out + 1] = 'i'
                    end
                elseif k == 'gogo' then
                    if v then
                        Out[#Out + 1] = '#GOGOSTART'
                    else
                        Out[#Out + 1] = '#GOGOEND'
                    end
                elseif k == 'senote' then
                    --TODO: Make a proper senote sequence decoder

                    addnewline = false
                elseif k == 'delay' then
                    if v == 0 then
                        --Nothing, default
                        addnewline = false
                    else
                        --STOPSONG is on
                        Out[#Out + 1] = '#DELAY '
                        local changems = note.delay - (lastnote and lastnote.delay or 0)
                        Out[#Out + 1] = tostring(MsToS(changems))

                        delayaddms = delayaddms + changems
                    end


                --GIMMICKS
                elseif k == 'radius' then
                    local n = note.type
                    if (not lastnote or not (v / ((n == 3 or n == 4 or n == 6) and Taiko.Data.BigNoteMul or 1) == lastnote[k] / ((lastnote.type == 3 or lastnote.type == 4 or lastnote.type == 6) and Taiko.Data.BigNoteMul or 1))) then
                        Out[#Out + 1] = '#RADIUS '
                        Out[#Out + 1] = tostring(v)
                    else
                        addnewline = false
                    end
                else
                    print('Invalid attribute, ' .. k)
                    addnewline = false
                end

                if addnewline then
                    if addfirstnewline then
                        table.insert(Out, beforenewline, '\n')
                        addfirstnewline = false
                    end
                    Out[#Out + 1] = '\n'
                end
            end
        end

        Out[#Out + 1] = tostring(note.type)

        lastnote = note

        return delayaddms --the ms that delay removed
    end


    --https://www.geeksforgeeks.org/program-find-gcd-floating-point-numbers/
    --TODO: Modify tolerance
    local tolerance = 1 --was 0.001
    local function Gcd(a, b)
        --negative check
        --[[
        if a < 0 or b < 0 then
            return nil
        end
        --]]

        if a < b then
            return Gcd(b, a)
        end
        if math.abs(b) < tolerance then
            return a
        else
            return Gcd(b, a - math.floor(a / b) * b)
        end
    end
    local function Round(a)
        return math.floor(a + 0.5)
    end
    local function ToFraction(n)
        --[[
        local a = Gcd(n, 1)
        return Round(n / a) .. '/' .. Round(1 / a)
        --]]

        --Don't use Gcd, floating point
        local a, b = n, 1
        while true do
            if not string.find(tostring(a), '%.') then
                break
            end
            a = a * 10
            b = b * 10
        end
        return a .. '/' .. b
    end

    --[[
        Input: measure with at least 2 notes
        Output: subdivision ms
    ]]
    local function Subdivide(currentmeasure)
        local gcd = currentmeasure[1].ms
        for i = 2, #currentmeasure do
            gcd = Gcd(gcd, currentmeasure[i].ms)
        end
        return gcd
    end


    --Main loop
    for k, v in pairs(Parsed) do
        --Reset SerializeNote
        lastnote = nil

        --SerializeTJA for each of these
        local ParsedData = v.Data

        --METADATA
        for k2, v2 in spairs(v.Metadata, function(t, a, b)
            return a < b
        end) do
            if (type(v2) == 'string' or type(v2) == 'number') and k2 ~= 'SONG' then
                Out[#Out + 1] = tostring(k2)
                
                Out[#Out + 1] = ':'
                if k2 == 'COURSE' then
                    Out[#Out + 1] = tostring(Taiko.Data.CourseName[v2])
                elseif MetadataMul[k2] then
                    Out[#Out + 1] = tostring(v2 * MetadataMul[k2])
                else
                    Out[#Out + 1] = tostring(v2)
                end

                Out[#Out + 1] = '\n'
            end
        end
        Out[#Out + 1] = '\n'


        --NMSCROLL / HBSCROLL / BMSCROLL
        --[[
            NOTE: there is no bmscroll since it is just hbscroll with scrolls disabled
            you cannot find from metadata
        ]]
        if v.Metadata.STOPSONG then
            Out[#Out + 1] = '\n#HBSCROLL\n'
        else
            Out[#Out + 1] = '\n#NMSCROLL\n'
        end

        --NOTES
        Out[#Out + 1] = '#START\n'
        local currentmeasure = {}
        local measurestartms = nil
        local lastsign = nil
        local delayedgecase = nil
        for i = 1, #ParsedData do
            --Compare note for attributes (bpm, scroll, etc) against previous and insert after current note

            local note = ParsedData[i]
            local nextnote = ParsedData[i + 1] --CAN BE NIL
            
            measurestartms = measurestartms or note.ms
            --print(note.ms)

            --do stuff with notes
            if (note.data == 'note') then
                currentmeasure[#currentmeasure + 1] = note
            end






            if (nextnote and (nextnote.data == 'event' and nextnote.event == 'barline')) or (i == #ParsedData) then
                local divtotalms = note.ms - measurestartms
                local divms = divtotalms / #currentmeasure

                --Subdivide
                local gcd = nil
                if #currentmeasure >= 2 then
                    gcd = Subdivide(currentmeasure)
                else
                    --DIRTY
                    gcd = note.mspermeasure
                end

                --Determine total measure ms
                local measurems = nil
                if nextnote then
                    measurems = nextnote.ms - measurestartms
                    --Subtract delay dif from total measure ms
                    measurems = measurems - (nextnote.delay - (currentmeasure[1] and currentmeasure[1].delay or nextnote.delay))

                    --Edge case
                    if #currentmeasure > 0 then
                        local futuredelayaddms = nextnote.delay - currentmeasure[#currentmeasure].delay

                        --print((((nextnote and nextnote.ms or (gcd + divtotalms) + measurestartms) - currentmeasure[#currentmeasure].ms) - futuredelayaddms) / gcd - 1)io.read()

                        local a = (((nextnote and nextnote.ms or (gcd + divtotalms) + measurestartms) - currentmeasure[#currentmeasure].ms) - futuredelayaddms) / gcd - 1

                        --Brute force guessing: don't question how I got these values
                        if delayedgecase then
                            if math.floor(math.abs(a)) == 0 then
                                measurems = measurems - gcd * delayedgecase

                                delayedgecase = nil
                                --delayedgecase = -a
                            else
                                --measurems = measurems - gcd * delayedgecase

                                --delayedgecase = nil
                                delayedgecase = -a
                            end
                        else
                            if math.floor(math.abs(a)) == 0 then
                                delayedgecase = nil
                            else
                                --print(a)io.read()
                                measurems = measurems - gcd * a

                                delayedgecase = -a
                            end
                        end
                    else
                        delayedgecase = nil
                    end
                else
                    --Subdivide
                    measurems = gcd + divtotalms
                end

                --Place measure

                --Determine measure sign
                local msperbeat = 60000 / note.bpm
                local signraw = (measurems / msperbeat) / 4
                local sign = tostring(signraw)

                --dont place measure if no measure change
                if sign ~= lastsign then
                    --LAZY --DIRTY (decimal fraction???)
                    --Out[#Out + 1] = '#MEASURE ' .. sign .. '/1\n'
                    Out[#Out + 1] = '\n#MEASURE '
                    Out[#Out + 1] = ToFraction(signraw)
                    Out[#Out + 1] = '\n' --TODO: FIX THIS NOT ADDING SIGNS
                    lastsign = sign
                end
                
                --print(measurems, #currentmeasure, gcd, note.type)

                --Cases
                if #currentmeasure == 0 then
                    Out[#Out + 1] = ',\n'
                elseif #currentmeasure == 1 then
                    local delayaddms = SerializeNote(note)
                    Out[#Out + 1] = ',\n'
                else
                    --Push notes
                    for i = 1, #currentmeasure do
                        local note = currentmeasure[i]
                        local delayaddms = SerializeNote(note)
                        
                        local futuredelayaddms = (currentmeasure[i + 1] and currentmeasure[i + 1].delay or (nextnote and nextnote.delay or note.delay)) - note.delay
                        --futuredelayaddms = 0

                        if i ~= #currentmeasure then
                            Out[#Out + 1] = string.rep('0', ((currentmeasure[i + 1].ms - currentmeasure[i].ms) - futuredelayaddms) / gcd - 1)
                        else
                            --print((((nextnote and nextnote.ms or (gcd + divtotalms) + measurestartms) - currentmeasure[#currentmeasure].ms) - futuredelayaddms) / gcd - 1)io.read()
                            Out[#Out + 1] = string.rep('0', (((nextnote and nextnote.ms or (gcd + divtotalms) + measurestartms) - currentmeasure[#currentmeasure].ms) - futuredelayaddms) / gcd - 1)
                        end
                    end
                    Out[#Out + 1] = ',\n'
                end


                --Set measure
                currentmeasure = {}
                measurestartms = nil --will be set next
            end

        end

        Out[#Out + 1] = '#END\n'




        return table.concat(Out)
    end

    return table.concat(Out)
end
--]===]






















--v3
--Serialize TJA Parsed into TJA
function Taiko.SerializeTJA(Parsed)
    --Config
    --Multiplier for Metadata, kv pairs
    local MetadataMul = {
        OFFSET = 0.001,
        MOVIEOFFSET = 0.001,
        DEMOSTART = 0.001,

        SONGVOL = 100,
        SEVOL = 100,
    }
    local AttributeMul = {
        --jposscroll_lengthms = 0.001,
        --NVM: just use MsToS
    }



    
    local Out = {'// Automatically Serialized by Taiko.SerializeTJA\n'}





    --Functions

    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end

    --https://www.geeksforgeeks.org/program-find-gcd-floating-point-numbers/
    --TODO: Modify tolerance
    local tolerance = 1 --was 0.001
    local function Gcd(a, b)
        --negative check
        -- [[
        if a < 0 or b < 0 then
            error('Negative GCD')
            return nil
        end
        --]]

        if a < b then
            return Gcd(b, a)
        end
        if math.abs(b) < tolerance then
            return a
        else
            return Gcd(b, a - math.floor(a / b) * b)
        end
    end
    local function Round(a)
        return math.floor(a + 0.5)
    end
    local function ToString(n)
        --Format to 13 decimal places and trim right 0's
        local s1 = string.format('%.13f', n)
        local s2 = string.gsub(s1, '^(.-)0*$', '%1')
        if string.sub(s2, -1, -1) == '.' then
            return string.sub(s2, 1, -2)
        else
            return s2
        end
    end
    local function ToFraction(n)
        --[[
        local a = Gcd(n, 1)
        return Round(n / a) .. '/' .. Round(1 / a)
        --]]

        --Don't use Gcd, floating point
        local a, b = n, 1
        while true do
            if not string.find(ToString(a), '%.') then
                break
            end
            a = a * 10
            b = b * 10
        end
        return ToString(a) .. '/' .. ToString(b)
    end
    local floatTolerance = 0.00001
    local function IsEqual(a, b)
        return math.abs(a - b) < floatTolerance
    end












    --[[
        Automatically pushes to out, returns nothing
        Input: note
        Output: nothing
    ]]
    local lastnote = nil
    --exclude: don't question, don't run
    local exclude = {
        mspermeasure = true,
        startnote = true,
        endnote = true,
        nextnote = true,
        lengthms = true,
        onnotepush = true,
        data = true,
        line = true,
        type = true,
        ms = true,
        scrolly = true,
        event = true,
    }
    --include: don't question, just run
    local include = {
        scrollx = true,
    }
    local function SerializeNote(note, addfirstnewline)
        local delayaddms = 0
        -- local addfirstnewline = true
        -- local addfirstnewline = false --adds 1 extra newline, nonoptimal (possibly remove) -- causes errors when mid scroll

        for k, v in spairs(note, function(t, a, b)
            return a < b
        end) do
            if (include[k]) or ((not exclude[k]) and (not lastnote or not (note[k] == lastnote[k]))) then
                --[[
                --TODO: Only output when addnewline is true
                --Output change
                if newline == false then
                    Out[#Out + 1] = '\n'
                    newline = true
                end
                --]]
                --DIRTY --TODO: some memory and cpu is wasted since we are adding it later using table.insert
                local beforenewline = #Out + 1

                local addnewline = true
                
                if k == 'bpm' then
                    Out[#Out + 1] = '#BPMCHANGE '
                    Out[#Out + 1] = ToString(note.bpm)
                elseif k == 'scrollx' then
                    --scrollx handles both scrollx and scrolly
                    --TODO: Check scrolly against lastnote too --DONE

                    if (not lastnote or not (note[k] == lastnote[k] and note.scrolly == lastnote.scrolly)) then
                        Out[#Out + 1] = '#SCROLL '
                        Out[#Out + 1] = ToString(-note.scrollx)
                        if note.scrolly ~= 0 then
                            if -note.scrolly >= 0 then
                                Out[#Out + 1] = '+'
                            end
                            Out[#Out + 1] = ToString(-note.scrolly)
                            Out[#Out + 1] = 'i'
                        end
                    else
                        addnewline = false
                    end
                elseif k == 'gogo' then
                    if note.gogo then
                        Out[#Out + 1] = '#GOGOSTART'
                    else
                        Out[#Out + 1] = '#GOGOEND'
                    end
                elseif k == 'senote' then
                    --TODO: Make a proper senote sequence decoder

                    addnewline = false
                elseif k == 'delay' then
                    --[[
                    if note.delay == 0 then
                        --Nothing, default
                        addnewline = false
                    else
                        --STOPSONG is on
                        Out[#Out + 1] = '#DELAY '
                        local changems = note.delay - (lastnote and lastnote.delay or 0)
                        Out[#Out + 1] = tostring(MsToS(changems))

                        delayaddms = delayaddms + changems
                    end
                    --]]
                elseif k == 'jposscroll' then
                    --require('ppp')(v)
                    --{lengthms=1500,lanep={0.6}}
                    --local lengthms = v.lengthms * AttributeMul.jposscroll_lengthms
                    Out[#Out + 1] = '#JPOSSCROLL '
                    Out[#Out + 1] = ToString(MsToS(v.lengthms))
                    Out[#Out + 1] = ' '
                    if v.p == 'default' then
                        --default
                        Out[#Out + 1] = 'default'
                    else
                        if v.p and v.p[1] then
                            --p
                            Out[#Out + 1] = ToString(v.p[1])
                        else
                            --lanep
                            Out[#Out + 1] = ToFraction(v.lanep[1])
                        end

                        if v.p and v.p[2] and v.p[2] ~= 0 then
                            if v.p[2] >= 0 then
                                Out[#Out + 1] = '+'
                            end
                            Out[#Out + 1] = ToString(v.p[2])
                            Out[#Out + 1] = 'i'
                        elseif v.lanep and v.lanep[2] and v.lanep[2] ~= 0 then
                            if v.lanep[2] >= 0 then
                                Out[#Out + 1] = '+'
                            end
                            Out[#Out + 1] = ToFraction(v.lanep[2])
                            Out[#Out + 1] = 'i'
                        end
                    end
                    Out[#Out + 1] = ' 1'


                --GIMMICKS
                elseif k == 'radius' then
                    local n = note.type
                    if (not lastnote or not (v / ((n == 3 or n == 4 or n == 6) and Taiko.Data.BigNoteMul or 1) == lastnote[k] / ((lastnote.type == 3 or lastnote.type == 4 or lastnote.type == 6) and Taiko.Data.BigNoteMul or 1))) then
                        Out[#Out + 1] = '#RADIUS '
                        Out[#Out + 1] = ToString(v)
                    else
                        addnewline = false
                    end
                else
                    --print('Invalid attribute, ' .. k)
                    addnewline = false
                end

                if addnewline then
                    if addfirstnewline then
                        table.insert(Out, beforenewline, '\n')
                        addfirstnewline = false
                    end
                    Out[#Out + 1] = '\n'
                end
            end
        end




        local beforenewline = #Out + 1
        local addnewline = true
        --note.delay
        --Changed to be after the note
        if not lastnote then
            --Nothing, default
            addnewline = false
        else
            --STOPSONG is on
            local changems = note.delay - (lastnote and lastnote.delay or 0)

            if changems == 0 then
                --Nothing, default
                addnewline = false
            else
                --print(changems)
                Out[#Out + 1] = '#DELAY '
                Out[#Out + 1] = ToString(MsToS(changems))

                delayaddms = delayaddms + changems
            end
        end

        if addnewline then
            if addfirstnewline then
                table.insert(Out, beforenewline, '\n')
                addfirstnewline = false
            end
            Out[#Out + 1] = '\n'
        end

        --print(tostring(note.delay) .. ' | ' .. tostring(lastnote and lastnote.delay) .. ' | ' .. (note.delay - (lastnote and lastnote.delay or 0)) .. ' | ' .. tostring(note.type))



        if note.data == 'note' then
            Out[#Out + 1] = tostring(note.type)

            --Out[#Out + 1] = ' // DEBUG: line: ' .. tostring(note.line) .. '\n' --DEBUG
        end

        lastnote = note

        return delayaddms --the ms that delay removed
    end




    --[[
        Input: measure with at least 2 notes
        Output: subdivision ms

        Rewritten using measurestartms
    ]]
    local function Subdivide(currentmeasure, measurestartms, measureendms)
        local gcd = currentmeasure[1].ms - measurestartms
        for i = 2, #currentmeasure do
            gcd = Gcd(gcd, currentmeasure[i].ms - measurestartms)
        end
        gcd = Gcd(gcd, measureendms - currentmeasure[#currentmeasure].ms)
        return gcd
    end


    --Main loop
    for k, v in pairs(Parsed) do
        --Reset SerializeNote
        -- lastnote = nil
        --defaults to save file size
        lastnote = {
            bpm = v.Metadata.BPM,
            type = 1,
            radius = 1,
        }

        --SerializeTJA for each of these
        local ParsedData = v.Data

        --FLAGS
        for k2, v2 in spairs(v.Flag, function(t, a, b)
            return a < b
        end) do
            if v2 then
                Out[#Out + 1] = '//$'
                Out[#Out + 1] = tostring(k2)
                Out[#Out + 1] = '\n'
            end
        end
        Out[#Out + 1] = '\n'


        --METADATA
        for k2, v2 in spairs(v.Metadata, function(t, a, b)
            return a < b
        end) do
            if (type(v2) == 'string' or type(v2) == 'number') and k2 ~= 'SONG' then
                Out[#Out + 1] = tostring(k2)
                
                Out[#Out + 1] = ':'
                if k2 == 'COURSE' then
                    Out[#Out + 1] = tostring(Taiko.Data.CourseName[v2])
                elseif MetadataMul[k2] then
                    Out[#Out + 1] = ToString(v2 * MetadataMul[k2])
                else
                    if type(v2) == 'number' then
                        Out[#Out + 1] = ToString(v2)
                    else
                        Out[#Out + 1] = tostring(v2)
                    end
                end

                Out[#Out + 1] = '\n'
            end
        end
        Out[#Out + 1] = '\n'


        --NMSCROLL / HBSCROLL / BMSCROLL
        --[[
            NOTE: there is no bmscroll since it is just hbscroll with scrolls disabled
            you cannot find from metadata
        ]]
        if v.Metadata.STOPSONG then
            Out[#Out + 1] = '\n#HBSCROLL\n'
        else
            Out[#Out + 1] = '\n'
            --resets by default? (we don't want other sims to error)
            -- Out[#Out + 1] = '\n#NMSCROLL\n'
        end

        --NOTES

        --Just subtract delay from notes
        for i = 1, #ParsedData do
            local note = ParsedData[i]
            note.ms = note.ms - note.delay
        end


        Out[#Out + 1] = '#START\n'
        local currentmeasure = nil
        local measurestartms = nil
        --local measurestartnote = nil
        local lastsignraw = 4/4
        local lastsign = ToFraction(lastsignraw)
        local stacked = nil --holds ms
        local stackedcondition = nil --holds last stackedcondition
        local nextnobarline = false
        for i = 1, #ParsedData do
            --Compare note for attributes (bpm, scroll, etc) against previous and insert after current note

            local note = ParsedData[i]
            local nextnote = ParsedData[i + 1] --CAN BE NIL
            
            --print(note.ms)
            --if i < 100 then print(note.type, note.ms) end

            --start of measure




            --stacked
            --REMEMBER: UPDATE STACKED BEFORE CHECKING OR MEASURE IS SOMETIMES CLEARED WITHOUT BEING PUSHED
            if (not stacked) and (nextnote and (note.data == 'note' and nextnote.data == 'note') and note.ms == nextnote.ms) then
                stacked = note.ms
            end

            --TODO: simplify to measureendedlast or (i == 1) or ((not stacked) and (nextnote and note.ms == nextnote.ms))
            if (note and (note.data == 'event' and note.event == 'barline')) or (i == 1) or stackedcondition or ((not stacked) and (nextnote and note.ms == nextnote.ms)) then
                --print('clearing measure', (note and (note.data == 'event' and note.event == 'barline')), (i == 1), stackedcondition, ((not stacked) and (nextnote and note.ms == nextnote.ms)))
                currentmeasure = {}
                measurestartms = note.ms
                --measurestartnote = note
            end




            --do stuff with notes
            --[[
            if note.data == 'note' then
                currentmeasure[#currentmeasure + 1] = note
            end
            --]]
            --NVM: Also use barlines!
            currentmeasure[#currentmeasure + 1] = note
            -- print(note.line, #currentmeasure)

            


            stackedcondition = (stacked and not (nextnote and nextnote.ms == stacked))

            --end of measure
            if (nextnote and (nextnote.data == 'event' and nextnote.event == 'barline')) or (i == #ParsedData) or stackedcondition then
                --print('pushing measure', (nextnote and (nextnote.data == 'event' and nextnote.event == 'barline')), (i == #ParsedData), stackedcondition)
                if stackedcondition then
                    Out[#Out + 1] = '\n// DEBUG: Stacked Notes\n'
                    --Out[#Out + 1] = '\n#BARLINEOFF\n'
                    if lastsignraw ~= 0 then
                        Out[#Out + 1] = '#MEASURE 0/1\n'
                    end

                    --Push notes
                    local barline = currentmeasure[1]
                    for i = 1, #currentmeasure do
                        local note = currentmeasure[i]
                        if IsEqual(barline.scrollx, note.scrollx) and IsEqual(barline.scrolly, note.scrolly) then
                            table.remove(currentmeasure, i)
                            table.insert(currentmeasure, 1, note)
                            break
                        end
                    end
                    for i = 1, #currentmeasure do
                        local note = currentmeasure[i]
                        local delayaddms = SerializeNote(note, i ~= 1)
                    end

                    Out[#Out + 1] = ',\n'

                    Out[#Out + 1] = '#BARLINEOFF\n'

                    --Place measure

                    --Determine measure sign
                    local msperbeat = 60000 / note.bpm
                    local signraw = ((nextnote.ms - stacked) / msperbeat) / 4
                    local sign = ToFraction(signraw)

                    --dont place measure if no measure change
                    if sign ~= lastsign then
                        --LAZY --DIRTY (decimal fraction???)
                        --Out[#Out + 1] = '#MEASURE ' .. sign .. '/1\n'
                        Out[#Out + 1] = '#MEASURE '
                        Out[#Out + 1] = ToFraction(signraw)
                        Out[#Out + 1] = '\n' --TODO: FIX THIS NOT ADDING SIGNS
                        Out[#Out + 1] = ',\n'

                        Out[#Out + 1] = '#MEASURE '
                        Out[#Out + 1] = ToFraction(lastsignraw)
                        Out[#Out + 1] = '\n' --TODO: FIX THIS NOT ADDING SIGNS
                    end



                    --Out[#Out + 1] = '#BARLINEON\n'
                    
                    stacked = nil
                    nextnobarline = true

                else


                    local measureendms = (nextnote and nextnote.ms or note.ms)
                    local divtotalms = measureendms - measurestartms

                    --Subdivide
                    local gcd = nil
                    if #currentmeasure >= 2 then
                        gcd = Subdivide(currentmeasure, measurestartms, measureendms)
                    elseif #currentmeasure == 1 then
                        --Same as Subdivide but optimized
                        --Take gcd of before or after note ms
                        gcd = Gcd(note.ms - measurestartms, measureendms - note.ms)
                    else
                        gcd = divtotalms
                    end

                    --Determine total measure ms
                    local measurems = nil
                    if nextnote then
                        measurems = divtotalms
                    else
                        --Subdivide
                        measurems = gcd + divtotalms
                    end

                    --Place measure

                    --Determine measure sign
                    local msperbeat = 60000 / note.bpm
                    local signraw = (measurems / msperbeat) / 4
                    local sign = ToString(signraw)

                    --dont place measure if no measure change
                    if sign ~= lastsign then
                        --LAZY --DIRTY (decimal fraction???)
                        --Out[#Out + 1] = '#MEASURE ' .. sign .. '/1\n'
                        Out[#Out + 1] = '\n#MEASURE '
                        Out[#Out + 1] = ToFraction(signraw)
                        Out[#Out + 1] = '\n' --TODO: FIX THIS NOT ADDING SIGNS
                        lastsign = sign
                        lastsignraw = signraw
                    end
                    
                    --print(measurems, #currentmeasure, gcd, note.type)

                    if nextnobarline then
                        Out[#Out + 1] = '#BARLINEON\n'
                        nextnobarline = false
                    end

                    --Cases
                    if #currentmeasure == 0 then
                        Out[#Out + 1] = ',\n'
                    --[[
                        --There are some weird cases (0's after or before note, so just switch to normal)
                    elseif #currentmeasure == 1 then
                        local delayaddms = SerializeNote(note)
                        Out[#Out + 1] = ',\n'
                    --]]
                    else
                        --Start (barline - first note)
                        Out[#Out + 1] = string.rep('0', ((currentmeasure[1].ms - measurestartms)) / gcd)

                        --Push notes
                        for i = 1, #currentmeasure do
                            local note = currentmeasure[i]
                            local delayaddms = SerializeNote(note, i ~= 1)
                        
                            if i == #currentmeasure then
                                --End (last note - next barline)
                                Out[#Out + 1] = string.rep('0', (((nextnote and nextnote.ms or (measurems) + measurestartms) - currentmeasure[#currentmeasure].ms)) / gcd - 1)
                            else
                                --Middle
                                Out[#Out + 1] = string.rep('0', ((currentmeasure[i + 1].ms - currentmeasure[i].ms)) / gcd - 1)
                            end
                        end


                        Out[#Out + 1] = ',\n'
                    end

                end

            end

        end

        Out[#Out + 1] = '#END\n'


        --Just subtract delay from notes (UNDO)
        for i = 1, #ParsedData do
            local note = ParsedData[i]
            note.ms = note.ms + note.delay
        end



        return table.concat(Out)
    end

    return table.concat(Out)
end


















--[[
--Serialize Test (with donkama neta)
local Parsed, Error = Taiko.ParseTJAFile([=[C:\Users\User\OneDrive\code\Taiko\Versions\Songs\00 Customs\tja\neta\ekiben\serializein2.tja]=])
local ParsedData = Parsed[1]
for i = 1, #ParsedData.Data do
    local note = ParsedData.Data[i]
    --print(note.delay)
end

local out = Taiko.SerializeTJA(Parsed)
--print(out)
io.open('./Songs/00 Customs/tja/neta/ekiben/serializeout.tja', 'wb+'):write(out)
--print(Taiko.SerializeTJA(Taiko.ParseTJA(Taiko.SerializeTJA(Parsed))))
error()
--]]



--[[
--Serialize Test
local Parsed, Error = Taiko.ParseTJAFile('./Songs/00 Customs/tja/neta/ekiben/serializein.tja')
local ParsedData = Parsed[1]
for i = 1, #ParsedData.Data do
    local note = ParsedData.Data[i]
    --print(note.delay)
end

local out = Taiko.SerializeTJA(Parsed)
print(out)
io.open('./Songs/00 Customs/tja/neta/ekiben/serializeout.tja', 'wb+'):write(out)
--print(Taiko.SerializeTJA(Taiko.ParseTJA(Taiko.SerializeTJA(Parsed))))
error()
--]]





--[[
--Compare Test
local Parsed1, Error1 = Taiko.ParseTJAFile('./Songs/00 Customs/tja/neta/ekiben/serializein.tja')
local Parsed2, Error2 = Taiko.ParseTJAFile('./Songs/00 Customs/tja/neta/ekiben/serializein.tja')
local Data1 = Parsed1[1].Data
local Data2 = Parsed2[1].Data

for i = 1, #Data1 do
    local note1 = Data1[i]
    local note2 = Data2[i]
    print(i, note1.type, note1.ms, note2.ms)
    if tostring(note1.ms) ~= tostring(note2.ms) then
        error'MISMATCH'
    end
end
error()
--]]










--[[
local Parsed = Taiko.ParseTJAFile('./Songs/00 Customs/tja/SerializeTest2.tja')
print(Taiko.SerializeTJA(Parsed))
print(Taiko.SerializeTJA(Taiko.ParseTJA(Taiko.SerializeTJA(Parsed))))
error()
--]]











--[[
--print(Taiko.SerializeTJA(Taiko.ParseTJA(io.open('./tja/SerializeTest.tja','r'):read'*all')))
print(Taiko.SerializeTJA(Taiko.ParseTJA(io.open('./tja/neta/kita/kita.tja','r'):read'*all')))

a = Taiko.SerializeTJA(Taiko.ParseTJA(io.open('./tja/neta/kita/kita.tja','r'):read'*all'))
io.open('outtest.tja','w+'):write(a)

error()
--]]


--[[
local a = Taiko.ParseTJA(io.open('./tja/SerializeTest.tja','r'):read'*all')
--]]
--[[
for i = 1, #a do
    local p = a[i]
    for i2 = 1, #p.Data do
        local n = p.Data[i2]

        if i2 == 2 then
            n.delay = 1000
        elseif i2 == 3 then
            n.delay = 2000
        elseif i2 >= 4 then
            n.delay = 3000
        end
        n.ms = n.ms + n.delay
    end
end
--]]

--[[
for i = 1, #a do
    local p = a[i]
    for i2 = 1, #p.Data do
        local n = p.Data[i2]

        n.delay = n.ms - 10
    end
end
--]]
--[[

for i = 1, #a do
    local lastnote = nil
    local lastms = 0
    local totaldelay = 0
    local p = a[i]
    local offset = 0
    for i2 = 1, #p.Data do
        local n = p.Data[i2 + offset]

        if i2 == (#p.Data + offset) or i2 == 1 then

        else
            if n.data ~= 'note' then
                table.remove(p.Data, i2 + offset)
                    offset = offset - 1
            else
                if n.type == 0 and lastms and lastnote then
                    totaldelay = totaldelay + (n.ms - lastms)
                    --lastnote.delay = totaldelay
                    table.remove(p.Data, i2 + offset)
                    offset = offset - 1
                else
                    n.delay = totaldelay
                    lastnote = n
        
                end
                lastms = n.ms
            end
        end

    end
end

--]]
--[[
a = Taiko.SerializeTJA(a)
io.open('outtest.tja','w+'):write(a)
error()
--]]

























--TJA Utils

function Taiko.Score(Parsed, score, combo, status, gogo)
    if status == 0 then
        combo = 0
    else
        combo = combo + 1
    end
    local m = Parsed.Metadata
    return Taiko.Data.ScoreMode.Note[m.SCOREMODE](score, combo, m.SCOREINIT, m.SCOREDIFF, status, gogo), combo
end


function Taiko.Analyze(Parsed)
    local branch = 'M'
    local scoredata = {
        [1] = 2,
        [2] = 2,
        [3] = 3,
        [4] = 3
    }

    local out = {
        notes = {
            n = 0, --N of all notes (including end)
            validn = 0, --N of notes that increase combo
        },
        measures = 0,
        lengthms = 0, --Until last note
        drumrollms = 0,
        drumrollbigms = 0,
        balloonms = 0,
        balloonhit = 0,
        specialms = 0,
        specialhit = 0,
        
        maxcombo = 0,
        maxscore = 0,
    }
    
    local lastnote = nil
    Taiko.ForAll(Parsed.Data, function(note, i, n)
        --local note = Parsed.Data[i]
        if note.data == 'note' then
            out.notes.n = out.notes.n + 1
            out.notes[note.type] = out.notes[note.type] and out.notes[note.type] + 1 or 1

            if scoredata[note.type] then
                out.maxscore, out.maxcombo = Taiko.Score(Parsed, out.maxscore, out.maxcombo, scoredata[note.type], note.gogo)
            end

            local endnote = note.endnote
            if endnote then
                local ms = endnote.ms - note.ms
                if note.type == 5 then
                    out.drumrollms = out.drumrollms + ms
                elseif note.type == 6 then
                    out.drumrollbigms = out.drumrollbigms + ms
                elseif note.type == 7 then
                    out.balloonms = out.balloonms + ms
                    out.balloonhit = out.balloonhit + note.requiredhits
                elseif note.type == 9 then
                    out.specialms = out.specialms + ms
                    out.specialhit = out.specialhit + note.requiredhits
                else
                    --Invalid
                end
            end
            lastnote = note
        elseif note.data == 'event' and note.event == 'barline' then
            out.measures = out.measures + 1
        else
            --Invalid
        end
    end, branch)


    out.lengthms = lastnote.ms - Parsed.Metadata.OFFSET

    --out.notes.validn = (out.notes[1] or 0) + (out.notes[2] or 0) + (out.notes[3] or 0) + (out.notes[4] or 0)
    out.notes.validn = out.maxcombo


    --require'ppp'(out)

    return out
end

function Taiko.GetDifficulty(Parsed, Difficulty)
    local a = Taiko.Data.CourseId[string.lower(Difficulty)] or Difficulty
    for k, v in pairs(Parsed) do
        if v.Metadata.COURSE == a then
            return v
        end
    end
    Error('No difficulty found, ' .. Difficulty)
    return nil
end


function Taiko.ForAll(ParsedData, f, branch)
    --[[
    f(note, relative, absolute)

    for k, v in pairs(ParsedData) do
        if v.branch then

        else
            f(v)
        end
    end
    --]]

    local n = 1 --Absolute
    for i = 1, #ParsedData do --i is relative
        local v = ParsedData[i]
        if v.branch then
            if branch then
                local b = v.branch.paths[branch]
                for i2 = 1, #b do
                    f(b[i2], i2, n)
                    n = n + 1
                end
                n = n - 1
            else
                local n3 = -1
                for k2, v2 in pairs(v.branch.paths) do
                    local n2 = n
                    for i2 = 1, #v2 do
                        f(v2[i2], i2, n2)
                        n2 = n2 + 1
                    end
                    n3 = (n3 < n2) and n2 or n3
                end
                n = n3
            end
        else
            f(v, i, n)
        end
        n = n + 1
    end
    return ParsedData
end


function Taiko.GetAllNotes(ParsedData)
    --Remember, objects are tables
    local t = {}
    for k, v in pairs(ParsedData) do
        if v.branch then
            for k2, v2 in pairs(v.branch.paths) do
                --[[
                local a = Taiko.GetAllNotes(v2)
                for i = 1, #a do
                    table.insert(t, a[i])
                end--]]
                for i = 1, #v2 do
                    table.insert(t, v2[i])
                end
            end
        else
            table.insert(t, v)
        end
    end
    return t
end




function Taiko.ConnectNotes(ParsedData)
    local nextnote = nil
    for i = #ParsedData, 1, -1 do
        local n = ParsedData[i]
        n.nextnote = nextnote
        nextnote = n
    end
    return ParsedData
end

function Taiko.ExtractBranch(branch, path)
    return branch.branch.paths[path]
end

function Taiko.ConnectAll(ParsedData)
    local nextnote = nil
    for i = #ParsedData, 1, -1 do
        local note = ParsedData[i]
        if note.branch then
            for k, v in pairs(note.branch.paths) do
                local path = Taiko.ConnectNotes(v)
                --Remember, tables are objects
                path[#path].nextnote = nextnote
            end
        else
            note.nextnote = nextnote
        end
        nextnote = note
    end
end









--[=[
function Taiko.GetNextNote(Parsed, n)
    while true do
        if n > #Parsed.Data then
            return nil
        end
        --[[
        if n == #Parsed.Data then
            return n
        end
        --]]
        local a = Parsed.Data[n]
        if a.data == 'note' then
            return n
        end
        n = n + 1
    end
end
--]=]



function Taiko.CalculateSpeed(note, noteradius)
    --[[
        distance = n of notes * scroll / 2 * noteradius
        OR
        notedensity = bpm / 
        distance = (200 / ms * noteradius) * (8 / notedensity)

        FINAL

        --original
        bps = bpm / 60
        sign = 4/4
        notedensity = bps * (400 / ms) / sign
        4*noteradius/(bps)*sign, ((200 / ms * noteradius) * (8 / notedensity))
        speed = distance / ms * scroll


        --OPTIMIZED FINAL

        --distance only
        distance = 240*noteradius*sign/bpm

        --speed only (radius / ms)
        speed = 240*noteradius*sign*scroll/(bpm*ms)


        --FINAL FINAL

        speed = distance / time
        speed (r/ms) = distance (dif r) / time (dif ms)




        --extra
        --get sign from measure length

        REVERSE: Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm

        Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm
        bpm * mspermeasure = 60000 * sign * 4
        sign = bpm*mspermeasure/240000

        

        
    ]]

    --print(i, noteradius, note.scroll, note.bpm, note.mspermeasure, 9600*noteradius*note.scroll/(note.bpm*note.mspermeasure), (noteradius * note.scroll / 25))
    --i = i + 1 if i > 50 then error( ) end




    --local speed = 9600*noteradius*note.scroll/(note.bpm*note.mspermeasure)

    --local speed = (noteradius * note.scroll / 25) -- - 0.06




    --local speed = (noteradius * note.scroll / 40) -- - 0.06


    --local speed = (noteradius * note.scroll * note.bpm / 6000) -- - 0.06

    local speedx = (noteradius * note.scrollx * note.bpm / 7500) -- - 0.06
    local speedy = (noteradius * note.scrolly * note.bpm / 7500)
    return {speedx, speedy}
end

function Taiko.CalculateSpeedInterval(note, displayratio)
    --display ratio = screenx / 1280
    --[[
        https://github.com/0auBSQ/OpenTaiko/commit/65922a29abd978aca7d3353a08ce3a45ba8e6cfa
        https://github.com/0auBSQ/OpenTaiko/blob/c25c744cf11bc8ca997c1318eef4893269fd74d2/Test/System/SimpleStyle/GameConfig.ini
    ]]
    local interval = 960
    local speedx = (note.bpm / 240000 * note.scrollx * interval * displayratio)
    local speedy = (note.bpm / 240000 * note.scrolly * interval * displayratio)
    return {speedx, speedy}
end

--[[
--Deprecated
function Taiko.CalculateSpeedAll(ParsedData, noteradius)
    --local t = {}
    for i = 1, #ParsedData do
        ParsedData[i].speed = Taiko.CalculateSpeed(ParsedData[i], noteradius)
        --print(Parsed.Data[i].speed)
        --table.insert(t, Parsed.Data[i].speed)
    end
    return ParsedData
end
--]]











--TJA Simulators

--for testing only
function Taiko.RenderScale(Parsed)


    --[[
        delete decimals
    ]]
    --[[
    for i = 1, #Parsed.Data do
        local a = Parsed.Data[i]
        if math.floor(a.ms) - a.ms ~= 0 then
            Parsed.Data[i] = nil
        end
    end
    --]]

    local t = {}
    local mst = {}
    local dont = {}
    for i = 1, #Parsed.Data do
        local note = Parsed.Data[i]
        if note.data == 'note' then
            local ms = math.floor(note.ms)
            if math.floor(ms) - ms == 0 then
                table.insert(t, {ms, note.type})
                table.insert(mst, ms)
            else
                table.insert(dont, i)
            end
        end
    end

    --gcd
    --https://github.com/ip1981/GCD/blob/master/gcd.lua

    -- SYNOPSIS:
    -- # chmod +x gcd.lua; ./gcd.lua 121 22 33 44
    -- # lua gcd.lua 121 33 22

    -- http://www.lua.org/pil/6.3.html
    function gcd2(a, b)
        if b == 0 then
            return a
        else
            return gcd2(b, a % b)
        end
    end

    function gcdn(ns)
        local r = ns[1]
        for i = 2, #ns do
            r = gcd2(r, ns[i])
        end
        return r
    end

    local gcd = gcdn(mst)

    for i = 1, #dont do
        local d = t[dont[i]]
        --round and mul by gcd
        d[1] = math.floor(d[1] / gcd) * gcd
    end
    local str = ''
    local ms = 0
    for i = 1, #t do
        t[i][1] = t[i][1] / gcd
        str = str .. string.rep(' ', t[i][1] - ms) .. t[i][2]
        ms = t[i][1]
    end
    return str
end







function Taiko.Game()

    --[[
        Notes about Raylib:

        Coordinates:
        x is from left side of screen
        y is from top of screen


        Textures.PlaySong:
        normal don should be 72x72 when
        big don is 108x108


        Skin:
        Every OpenTaiko skin should be compatible



        See also:
            https://github.com/TSnake41/raylib-lua
            https://github.com/kikito/tween.lua



    ]]


    --Init Raylib
    --WARNING: INIT FIRST
    -- Initialization
    --16:9 aspect ratio (1080p)

    --Config:

    --Defined later
    local AssetsPath = nil
    local ConfigPath = 'config.tpd'
    
    local Config

    local Progress = 0
    local ProgressTotal = 138
    local UpdateProgress





    --Clean Up function
    local function CleanUp()
        rl.CloseWindow()
        rl.CloseAudioDevice()
    end



    --Gui

    --Requires OpenGL Context
    --[[
int MeasureText(const char *text, int fontSize)
{
    Vector2 textSize = { 0.0f, 0.0f };

    // Check if default font has been loaded
    if (GetFontDefault().texture.id != 0)
    {
        int defaultFontSize = 10;   // Default Font chars height in pixel
        if (fontSize < defaultFontSize) fontSize = defaultFontSize;
        int spacing = fontSize/defaultFontSize;

        textSize = MeasureTextEx(GetFontDefault(), text, (float)fontSize, (float)spacing);
    }

    return (int)textSize.x;
}
    ]]









    local function GetTextSize(str, fontsize)
        --[[
        return rl.MeasureText(str, fontsize) --only x
        --]]

        -- [[
        local defaultfontsize = 10
        if fontsize < defaultfontsize then
            fontsize = defaultfontsize
        end
        local spacing = fontsize / defaultfontsize

        local v = rl.MeasureTextEx(rl.GetFontDefault(), str, fontsize, spacing)
        return math.floor(v.x), math.floor(v.y)
        --]]
    end

    local GuiConfirmKey = {
        [rl.KEY_Y] = true,
        [rl.KEY_N] = false,
    }
    local fontsize = 50
    local function GuiConfirm(str)
        --local p = rl.new('Vector2', Config.ScreenWidth / 2 - sx / 2, Config.ScreenHeight / 2 - sy / 2)
        local sx, sy = GetTextSize(str, fontsize)
        local out = nil
        while not rl.WindowShouldClose() do
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)
            rl.DrawText(str, Config.ScreenWidth / 2 - sx / 2, Config.ScreenHeight / 2 - sy / 2, fontsize, rl.BLACK)
            rl.EndDrawing()
            
            for k, v in pairs(GuiConfirmKey) do
                if rl.IsKeyPressed(k) then
                    out = v
                    break
                end
            end

            if out ~= nil then
                break
            end
        end
        return out
    end
    local warnenabled = true
    local function GuiWarn(str)
        if warnenabled then
            return GuiConfirm(str .. '\nPress y to confirm\nPress n to reject')
        else
            return true
        end
    end
    local function GuiInput(str)
        local sx, sy = GetTextSize(str, fontsize)
        local out = {}
        str = str .. '\n'
        local displaytext = str
        while not rl.WindowShouldClose() do
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)
            rl.DrawText(displaytext, Config.ScreenWidth / 2 - sx / 2, Config.ScreenHeight / 2 - sy / 2, fontsize, rl.BLACK)
            rl.EndDrawing()

            while true do
                local c = rl.GetCharPressed()
                if c == 0 then
                    break
                else
                    out[#out + 1] = c
                    --Update display
                    displaytext = str .. utf8Encode(out)
                end
            end

            --Remember, GetCharPressed doesn't detect special keys
            if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
                out[#out] = nil
                --Update display
                displaytext = str .. utf8Encode(out)
            end
            if rl.IsKeyPressed(rl.KEY_ENTER) then
                break
            end
        end
        out = utf8Encode(out)
        return out ~= '' and out or nil
    end
    local function GuiMessage(str)
        local sx, sy = GetTextSize(str, fontsize)
        local out = nil
        while not rl.WindowShouldClose() do
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)
            rl.DrawText(str, Config.ScreenWidth / 2 - sx / 2, Config.ScreenHeight / 2 - sy / 2, fontsize, rl.BLACK)
            rl.EndDrawing()
            
            while true do
                local c = rl.GetCharPressed()
                if c == 0 then
                    break
                else
                    out = true
                    break
                end
            end

            if out then
                break
            end
        end
        return out
    end
    local superwarnenabled = true
    local function GuiSuperWarn(str, str2)
        if superwarnenabled then
            local input = GuiInput(str .. '\nType \'' .. str2 .. '\' to confirm')
            if input == str2 then
                return true
            else
                return false
            end
        else
            return true
        end
    end








    
    --Loading / Accessing assets
    local function GetFileType(str)
        return string.reverse(string.match(string.reverse(str), '(.-%.)'))
    end
    local function RemoveLastSlash(str)
        local last = string.sub(str, -1, -1)
        if last == '/' or last == '\\' then
            return string.sub(str, 1, -2)
        else
            return str
        end
    end

    --Raylib functions fixed! (raylib functions suck at unicode paths)
    local function GetFileName(str)
        --INClUDES EXT
        --note: you can use ffi.string(rl.GetFileName(str))
        return string.reverse(string.match(string.reverse(str), '(.-)/'))
    end
    local function GetFileNameWithoutExt(str)
        --note: you can use ffi.string(rl.GetFileNameWithoutExt(str))
        local a = GetFileName(str)
        local b = string.find(a, '%.')
        if b then
            return string.sub(a, 1, b - 1)
        else
            return a
        end
    end
    local function IsPathFile(str)
        local a = GetFileName(str)
        if string.find(a, '%.') then
            return true
        else
            return false
        end
    end

    local function GetAllFilesInDirectory(str)
        local ffi = require('ffi')
        --[[
        --this should work, but it doesn't
        local FilesListC = rl.LoadDirectoryFilesEx(RemoveLastSlash(Config.Paths.Songs), nil, false)

        local FilesList = {}

        for i = 0, FilesListC.count - 1 do
            FilesList[i + 1] = ffi.string(FilesListC.paths[i])
        end

        return FilesList
        --]]

        local FilesListC = rl.LoadDirectoryFiles(RemoveLastSlash(str))

        local FilesList = {}

        for i = 0, FilesListC.count - 1 do
            FilesList[#FilesList + 1] = ffi.string(FilesListC.paths[i])
            if rl.IsPathFile(FilesList[#FilesList]) == false then
                --print(FilesList[#FilesList])
                local t = GetAllFilesInDirectory(FilesList[#FilesList])
                FilesList[#FilesList] = nil
                for i2 = 1, #t do
                    FilesList[#FilesList + 1] = t[i2]
                end
            end
        end
        
        return FilesList
    end

    local function ScanSongsFFI(str)
        local ffi = require('ffi')
        --[[
            basically GetAllFilesInDirectory but does some folder organization
        ]]

        str = str or Config.Paths.Songs
        --pathtree = pathtree or {}
        --songtree = songtree or {}
        local pathtree = {}

        local FilesListC = rl.LoadDirectoryFiles(RemoveLastSlash(str))

        local FilesList = {}

        for i = 0, FilesListC.count - 1 do
            --FilesList[#FilesList + 1] = ffi.string(FilesListC.paths[i])
            
            if rl.IsPathFile(FilesList[#FilesList]) == false then
                --print(FilesList[#FilesList])
                local dir = FilesList[#FilesList]
                local dirname = ffi.string(rl.GetFileNameWithoutExt(FilesList[#FilesList]))
                local t, tp = ScanSongs(FilesList[#FilesList])
                pathtree[dirname] = tp
                FilesList[#FilesList] = nil
                local dirfilenamesame = true
                for i2 = 1, #t do
                    if dirfilenamesame then
                        local fname = rl.GetFileNameWithoutExt(t[i2])
                        if ffi.string(fname) == dirname then

                        else
                            dirfilenamesame = false
                        end
                    end
                    FilesList[#FilesList + 1] = t[i2]
                end

                if dirfilenamesame then
                    --It is a single song folder, put it in above directory
                    --print(ffi.string(rl.GetPrevDirectoryPath(dir)))
                    for i2 = 1, #pathtree[dirname] do
                        pathtree[#pathtree + 1] = pathtree[dirname][i2]
                    end
                    pathtree[dirname] = nil
                else
                    --It is a category
                    
                end
            else
                pathtree[#pathtree + 1] = FilesList[#FilesList]
            end
        end
        
        return FilesList, pathtree
    end

    local function ScanSongs(str)
        -- local lfs = require('lfs.lfs_ffi')
        --[[
            basically GetAllFilesInDirectory but does some folder organization
        ]]

        str = str or Config.Paths.Songs
        --pathtree = pathtree or {}
        --songtree = songtree or {}
        local pathtree = {}

        local toppath = RemoveLastSlash(str)

        local iter, dir_obj = lfs.dir(toppath)

        toppath = toppath .. '/'

        local FilesList = {}

        while true do
            local file = iter(dir_obj)
            if not file then
                break
            end

            if file ~= '.' and file ~= '..' then
                FilesList[#FilesList + 1] = toppath .. file
                if IsPathFile(FilesList[#FilesList]) == false then
                    --print(FilesList[#FilesList])
                    local dir = FilesList[#FilesList]
                    local dirname = GetFileNameWithoutExt(FilesList[#FilesList])
                    local t, tp = ScanSongs(FilesList[#FilesList])
                    pathtree[dirname] = tp
                    FilesList[#FilesList] = nil
                    local dirfilenamesame = true
                    for i2 = 1, #t do
                        if dirfilenamesame then
                            local fname = GetFileNameWithoutExt(t[i2])
                            if fname == dirname then

                            else
                                dirfilenamesame = false
                            end
                        end
                        FilesList[#FilesList + 1] = t[i2]
                    end

                    if dirfilenamesame then
                        --It is a single song folder, put it in above directory
                        --print(ffi.string(rl.GetPrevDirectoryPath(dir)))
                        for i2 = 1, #pathtree[dirname] do
                            pathtree[#pathtree + 1] = pathtree[dirname][i2]
                        end
                        pathtree[dirname] = nil
                    else
                        --It is a category
                        
                    end
                else
                    pathtree[#pathtree + 1] = FilesList[#FilesList]
                end
            end
        end
        
        return FilesList, pathtree
    end

    local function BuildSongTree(pathtree)
        --local ffi = require('ffi')

        local songtree = {}
        for k, v in pairs(pathtree) do
            --print(k, v)
            if type(v) == 'table' then
                songtree[k] = BuildSongTree(v)
            else
                --songtree[ffi.string(rl.GetFileNameWithoutExt(v))] = v
                if GetFileType(v) == '.tja' then
                    --Avoid overwriting when different extentions but same name
                    songtree[GetFileNameWithoutExt(v)] = v
                end
            end
        end

        return songtree
    end

    local function CheckFile(str)
        local file = io.open(str, 'rb')
        if file then
            file:close()
            return true
        else
            return false
        end
    end
    local function LoadFile(str)
        local file = io.open(str, 'rb')
        if file then
            local data = file:read('*all')
            file:close()
            return data
        else
            --error('Unable to find file: ' .. str)
            print('Unable to find file: ' .. str)
        end
    end
    local function LoadAsset(str)
        UpdateProgress(str)
        return LoadFile(AssetsPath .. str)
    end
    local function LoadMusicStreamFromMemory(str)
        --raylib src
        --https://github.com/raysan5/raylib/blob/83ff7b246613c57dd5703d24965b4036332a100f/src/raudio.c#L1272
        --https://github.com/raysan5/raylib/blob/83ff7b246613c57dd5703d24965b4036332a100f/src/raudio.c#L1443

        --raylib lua src compat
        --https://github.com/TSnake41/raylib-lua/blob/master/src/compat.lua#L25
        --local f, err = raylua.loadfile(path)
        local f, err = io.open(str, 'rb')
        
        if f then
            local data = f:read('*all')
            f:close()
            local ffi = require('ffi')

            --[[
                crash when UpdateMusicStream is called

                prob caused by this
                https://github.com/raysan5/raylib/blob/d5a31168ce768ef9c1e11fe4734285770a33aba4/src/raudio.c#L1926
            ]]

            return rl.LoadMusicStreamFromMemory(ffi.new('const char *', GetFileType(str)), ffi.new("const unsigned char *", data), ffi.new('int', #data + 1))
        else
            return nil
        end
    end
    local function LoadSong(str)
        -- [[
        --works ig for (only payload)
        --ALSO NO UNICODE SUPPORT!!
        return rl.LoadMusicStream(str)
        --]]

        --[[
        local data = LoadFile(str)
        return rl.LoadMusicStreamFromMemory(GetFileType(str), data, #data)
        --]]

        --[==[
        local a = rl.LoadMusicStream(str)
        --local data = LoadFile(str)
        local b = LoadMusicStreamFromMemory(str)
--error()
        --ITS ctxData
        --[[
            probably not ending with null, etc
        ]]

        print(a.ctxData)
        print(b.ctxData)

        local ffi = require'ffi'

        local function inspect(cstr)
            local length = 0
            while true do
                length = length + 1
                local a = ffi.string(cstr, length)
                print(a:sub(-1, -1), a:sub(-1, -1):byte())

                io.read()
            end
        end

        --inspect(a.ctxData)

        --[[
        LENGTH = 100
        local as = ffi.string(a.ctxData, LENGTH)
        local bs = ffi.string(b.ctxData, LENGTH)
        io.open('Screenshots/out.txt', 'wb+'):write(as)
        io.open('Screenshots/outMEMORY.txt', 'wb+'):write(bs)
        --]]


        --b.ctxData = a.ctxData
        return b
        --]==]

        --[[
        return LoadMusicStreamFromMemory(str)
        --]]

        --[[
        local b = rl.LoadMusicStream(str)
        
        local a = rl.new('Music')
        a.stream = b.stream
        a.frameCount = b.frameCount
        a.looping = b.looping
        a.ctxType = b.ctxType
        a.ctxData = b.ctxData
        return a
        --]]

    end
    --[=[
    local function LoadImage(str)
        --Loads from payload
        --[[
        return rl.LoadImage(AssetsPath .. str)
        --]]

        --Loads from external file / outside payload
        -- [[
        local file = io.open(AssetsPath .. str, 'rb')
        if file then
            local data = file:read('*all')
            return rl.LoadImageFromMemory('.png', data, #data)
        else
            error('Unable to find file' .. str)
        end
        --]]
    end
    --]=]
    local function LoadImage(str)
        local data = LoadAsset(str)
        if not data then
            return rl.new('Image')
        end
        return rl.LoadImageFromMemory(GetFileType(str), data, #data)
    end
    local function LoadWave(str)
        local data = LoadAsset(str)
        if not data then
            return rl.new('Wave')
        end
        return rl.LoadWaveFromMemory(GetFileType(str), data, #data)
    end
    local function LoadSound(str)
        local wave = LoadWave(str)
        local sound = rl.LoadSoundFromWave(wave)
        rl.UnloadWave(wave)
        return sound
    end
    -- [[
    local function LoadAnimSeperate(str, strappend, nstart)
        local Anim = {}
        local i = nstart
        while true do
            local a = str .. tostring(i) .. strappend
            if CheckFile(AssetsPath .. a) then
                Anim[i] = LoadImage(a)
                i = i + 1
            else
                if i == 0 then
                    Anim[0] = rl.new('Image')
                end
                break
            end
        end
        return Anim
    end
    --]]
    local function LoadAnim(image, map)
        local Anim = {
            image, map
        }
        --Get rectangle of anim (just access map with framen)
        return Anim
    end
    local function CountAnimFrames(Anim)
        local i = 0
        for k, v in pairs(Anim) do
            i = i + 1
        end
        return i
    end
    local function LoadFont(str, fontsize, fontchars, glyphcount)
        fontsize = fontsize or 32
        
        --fontchars={}for i = 12352, 12447 do fontchars[#fontchars + 1] = i end --japanese
        if not fontchars then
            fontchars = {}
            for i = 1, glyphcount do
                fontchars[#fontchars + 1] = i
            end
        end



        fontchars = fontchars and rl.new('int[?]', #fontchars, fontchars)
        glyphcount = glyphcount or 0

        local data = LoadAsset(str)
        if not data then
            return rl.new('Font')
        end
        return rl.LoadFontFromMemory(GetFileType(str), data, #data, fontsize, fontchars, glyphcount)
    end
    local dynamicfontcache = {}
    local function LoadFontDynamic(str, fontsize, unused_fontchars, unused_glyphcount)
        --basically creates a wrapper function that can be called to load a set of codepoints
        --the fonts are cached

        return function(fontchars, tmp)
            if not CheckFile(AssetsPath .. str) then
                print('Font not found, crashing')
            end

            --tmp is dictionary form of fontchars
            if not tmp then
                tmp = {}
                for i = 1, #fontchars do
                    tmp[fontchars[i]] = true
                end
            end

            for k, v in pairs(dynamicfontcache) do
                if #k == #fontchars then
                    local a = true
                    for i = 1, #k do
                        if not tmp[k[i]] then
                            a = false
                            break
                        end
                    end
                    if a then
                        return v
                    end
                end
            end

            --generate
            dynamicfontcache[fontchars] = LoadFont(str, fontsize, fontchars, #fontchars)
            return dynamicfontcache[fontchars]
        end
    end
    --[=[
    local XNAcolor = rl.MAGENTA
    local function GridImage(image, nx, ny)
        --[[
            nx, ny = number of chars in x,y
        ]]
        local spacing = 20

        local sx, sy = image.width / nx, image.height / ny
        local rect = rl.new('Rectangle', 0, 0, sx - 1, sy - 1)
        local rect2 = rl.new('Rectangle', 0, 0, sx - 1, sy - 1)
        --local out = rl.new('Image')
        local out = rl.ImageCopy(image)
        --rl.ImageResize(out, image.width + nx + 1, image.height + ny + 1)
        local newx, newy = image.width + nx + (nx + 1) * spacing, image.height + ny + (ny + 1) * spacing
        rl.ImageResizeCanvas(out, newx, newy, 0, 0, XNAcolor)
        rl.ImageDrawRectangle(out, 0, 0, newx, newy, XNAcolor)
        for ix = 0, nx - 1 do
            local x = ix * sx
            for iy = 0, ny - 1 do
                local y = iy * sy
                rect.x = x
                rect.y = y
                rect2.x = x + ix * spacing + spacing
                rect2.y = y + iy * spacing + spacing
                --void ImageDraw(Image *dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint)
                --print(x, y, out.width, out.height)
                rl.ImageDrawRectangleRec(out, rect2, rl.BLANK)
                rl.ImageDraw(out, image, rect, rect2, rl.WHITE)
            end
        end
        return out
    end
    local function LoadFontFromImage(image, nx, ny)
        local grid = GridImage(image, nx, ny)
        a=rl.LoadTextureFromImage(grid)b=os.clock()repeat rl.BeginDrawing() rl.DrawTexture(a, 10, 700, rl.WHITE) rl.EndDrawing() until os.clock()-b>4
        local firstchar = 48 --(0)
        local font = rl.LoadFontFromImage(grid, XNAcolor, firstchar)
        print(font.glyphs[49])error()
        return font
    end
    local function LoadFontFromImage(image, nx, ny, t)
        --[[
            nx, ny = number of chars in x,y
        ]]
        local font = rl.GetFontDefault()
        t = {
            48,49,50,51,52,53,54,55,56,57
        }

        local sx, sy = image.width / nx, image.height / ny
        local rect = rl.new('Rectangle', 0, 0, sx - 1, sy - 1)
        local i = 1

        font.texture = rl.LoadTextureFromImage(image)
        font.glyphCount = font.glyphCount + #t
        font.glyphPadding = 0
        b = nil
        for ix = 0, nx - 1 do
            local x = ix * sx
            for iy = 0, ny - 1 do
                local y = iy * sy
                rect.x = x
                rect.y = y
                local a = font.glyphs[t[i]]
                a.value = t[i]
                font.recs[t[i]] = rl.new('Rectangle', rect.x, rect.y, rect.width, rect.height)
                a.offsetX = 0
                a.offsetY = 0
                a.advanceX = 0
                a.image = rl.ImageFromImage(image, rect)
                b = not b and rl.LoadTextureFromImage(a.image) or b
                i = i + 1
            end
        end
        c=b
        font.baseSize = font.recs[t[1]].height
        print(font.glyphCount)

        b=os.clock()repeat
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)
            rl.DrawTexture(c, 10, 300, rl.WHITE)
            rl.DrawTextEx(font, '01234', rl.new('Vector2', 100, 700), 50, 1, rl.WHITE)
            rl.EndDrawing()until os.clock()-b>4
            error()
        return font
    end
    local function LoadNumberFontFromImage(image)
    
    end
    --]=]

    local texttexturespacing = -4
    local function MeasureTextTexture(str, osx, osy, sx, sy, scale)
        local texttexturespacing = texttexturespacing * scale[1]
        local outx, outy = 0, 0
        local currentx = 0
        for i = 1, #str do
            local c = string.sub(str, i, i)
            if c == '\n' then
                currentx = currentx - (sx + texttexturespacing)
                outx = currentx > outx and currentx or outx
                outy = outy + (sy + texttexturespacing)
            else
                currentx = currentx + (sx + texttexturespacing)
            end
        end
        currentx = currentx - (sx + texttexturespacing)
        outx = currentx > outx and currentx or outx
        return outx, outy
    end
    local function DrawTextTexture(texture, str, x, y, osx, osy, sx, sy, scale, t)
        --[[
            nx, ny = number of chars in x, y
            t = {
                c = {x, y}
            }
        ]]
        t = t or {
            ['0'] = {0, 0},
            ['1'] = {1, 0},
            ['2'] = {2, 0},
            ['3'] = {3, 0},
            ['4'] = {4, 0},
            ['5'] = {5, 0},
            ['6'] = {6, 0},
            ['7'] = {7, 0},
            ['8'] = {8, 0},
            ['9'] = {9, 0},
        }

        

        --local sx, sy = image.width / nx, image.height / ny
        local line = 0
        local ix = 0
        local rect = rl.new('Rectangle', 0, 0, osx - 1, osy - 1)
        local rect2 = rl.new('Rectangle', 0, 0, sx - 1, sy - 1)
        local origin = rl.new('Vector2', 0, 0)
        local texttexturespacing = texttexturespacing * scale[1]

        for i = 1, #str do
            local c = string.sub(str, i, i)
            if c == '\n' then
                line = line + 1
                ix = 0
            else
                local p = t[c]
                if p then
                    rect.x = p[1] * osx
                    rect.y = p[2] * osy
                    rect2.x = x + (sx + texttexturespacing) * ix
                    rect2.y = y + (sy + texttexturespacing) * line
                    rl.DrawTexturePro(texture, rect, rect2, origin, 0, rl.WHITE)
                    ix = ix + 1
                end
            end
        end


    end


    --Saving
    local function GetTimestampFilename(before, after)
        --Make file name (timestamp)
        --https://www.lua.org/pil/22.1.html
        --based on vlcsnap timestamp
        local timestamp = os.date('%Y-%m-%d-%Hh%Mm%Ss000', os.time())
        local filename = before .. timestamp .. after
        return filename
    end
    local function SaveFileTimestamp(before, after, str)
        local filename = GetTimestampFilename(before, after)

        local file = io.open(filename, 'wb+')
        if file then
            file:write(str)
            file:close()
        else
            --error('Unable to find file: ' .. filename)
            print('Unable to find file: ' .. filename)
        end
    end












    --Load Config
    local generateconfig = false
    if CheckFile(ConfigPath) then
        Config = Persistent.Load(Persistent.Read(ConfigPath))
        --print(Persistent.Save(Config))error()
    else
        --Generate New Config
        Config = {}
        generateconfig = true
    end



















    --Default config so game can start up
    Config = Config or {}

    Config.ScreenWidth = Config.ScreenWidth or 1600 --1600
    Config.ScreenHeight = Config.ScreenHeight or Config.ScreenWidth / 16 * 9 --900
    Config.WindowName = Config.WindowName or 'Taiko'

    Config.Settings = Config.Settings or {}
    Config.Settings.FPS = Config.Settings.FPS or 60
    Config.Settings.VSync = Config.Settings.VSync == nil and true or Config.Settings.VSync --"or" breaks when it may be false





    --INIT RAYLIB

    local function InitWindow()
        if Config.Settings.VSync then
            rl.SetConfigFlags(rl.FLAG_VSYNC_HINT) --limit fps
        end
        rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE)
        --https://github.com/raysan5/raylib/wiki/Frequently-Asked-Questions#how-do-i-remove-the-log
        rl.SetTraceLogLevel(rl.LOG_NONE)
        rl.InitWindow(Config.ScreenWidth, Config.ScreenHeight, Config.WindowName)
    
        if Config.Settings.LimitFPS then
            rl.SetTargetFPS(Config.Settings.FPS)
        end
        rl.SetExitKey(rl.KEY_NULL) --So you can't escape with ESC key used for pausing
        --rl.HideCursor() --Hide cursor
    end

    InitWindow()



    --Regenerate Config if Needed
    if generateconfig then
        local ConfigData = nil
        while true do
            local v = GuiConfirm('Config file not found\nPress y to generate new config\nPress n to use a different config')
            if v == true then
                local warn = GuiWarn('Are you sure you want to overwrite ' .. ConfigPath .. '?')
                if warn then
                    --Generate config
                    ConfigData = Persistent.Read('defaultconfig.tpd')
                else
                    --Loop again
                end
            elseif v == false then
                while true do
                    local v = GuiInput('What is the file path?\n(Relative or Absolute)')
                    if v then
                        if CheckFile(v) then
                            local warn = GuiWarn('Are you sure you want to use ' .. v .. '?')
                            if warn then
                                --Use config
                                ConfigData = Persistent.Read(v)
                                break
                            else
                                --Loop again
                            end
                        else
                            GuiMessage('Invalid file')
                        end
                    --[[
                    elseif v == false then
                        --Loop again
                        GuiMessage('Unable to read input')
                    --]]
                    else
                        --Escape
                        break
                    end
                end
            else
                local warn = GuiWarn('Are you sure you want to continue without config?')
                if warn then
                    break
                else
                    --Loop again
                end
            end

            if ConfigData then
                break
            end
        end

        --Load
        if ConfigData then
            Config = Persistent.Load(ConfigData)
        end
    end





    --Config

    --OriginalConfig
    local OriginalConfig = Table.Clone(Config)


    --Config.Controls
    --Check if a key in a table of keys is pressed
    local function IsKeyPressed(t)
        for k, v in pairs(t) do
            if rl.IsKeyPressed(k) then
                return true
            end
        end
        return false
    end
    local function IsKeyDown(t)
        for k, v in pairs(t) do
            if rl.IsKeyDown(k) then
                return true
            end
        end
        return false
    end
    local function IsKeyPressed2(t)
        for k, v in pairs(t) do
            if rl.IsKeyPressed(k) then
                return k
            end
        end
        return false
    end

    --Config.Fullscreen
    --Ignores Config.ScreenWidth, Config.ScreenHeight, and turns on fullscreen
    local function ToggleFullscreen()
        local OldScreenWidth, OldScreenHeight = Config.ScreenWidth, Config.ScreenHeight
        if Config.Fullscreen then
            rl.ToggleFullscreen()
            Config.ScreenWidth, Config.ScreenHeight = OriginalConfig.ScreenWidth, OriginalConfig.ScreenHeight
            rl.RestoreWindow()
            rl.SetWindowSize(Config.ScreenWidth, Config.ScreenHeight)
        else
            local monitor = rl.GetCurrentMonitor()
            Config.ScreenWidth, Config.ScreenHeight = rl.GetMonitorWidth(monitor), rl.GetMonitorHeight(monitor)
            rl.SetWindowSize(Config.ScreenWidth, Config.ScreenHeight)
            rl.ToggleFullscreen()
        end
        --[[
        print(Config.Fullscreen)
        print(Config.ScreenWidth, Config.ScreenHeight)
        --]]
        Config.Fullscreen = not Config.Fullscreen
        return Config.ScreenWidth / OldScreenWidth, Config.ScreenHeight / OldScreenHeight
    end
    if Config.Fullscreen then
        Config.Fullscreen = false
        ToggleFullscreen()
    end







    local lastconfigupdate = {
        vsync = OriginalConfig.Settings.VSync
    }
    function Taiko.UpdateConfig()
        --[[
            Config.Offsets

            About offsets:

            Config.Offsets.Timing = 50 means 50 ms later is good
            Config.Offsets.Timing = 50 means 50 ms later is music play
        ]]
        --Config.Offsets.Music
        Config.Offsets.Music = MsToS(Config.Offsets.Music)


        --[[
            Config.Paths

            Defined above
        ]]
        AssetsPath = Config.Paths.Assets --'Assets/'
        ConfigPath = Config.Paths.Config --'config.tpd'


        --Convert from ms to s
        Config.Controls.SongSelect.FastScrollTime = MsToS(Config.Controls.SongSelect.FastScrollTime) --http://stereopsis.com/keyrepeat/
        Config.Controls.SongSelect.FastScrollInterval = MsToS(Config.Controls.SongSelect.FastScrollInterval)


        --SETTINGS



        --[[
            FPS
        ]]
        --[[
            about limiting frame rate:

            vsync causes massive cpu usage for some reason
            settargetfps isn't vsynced and doesn't use that much cpu (probably) (may possibly cause screen tearing, but ive never seen that before) (IT MAY CAUSE LAG)

            both of them use around the same amount of gpu, but vsync uses massive cpu
            use targetfps!!!
        ]]

        if lastconfigupdate.vsync ~= Config.Settings.VSync then
            rl.CloseWindow()
            InitWindow()
            lastconfigupdate.vsync = Config.Settings.VSync
        else
            if Config.Settings.LimitFPS then
                rl.SetTargetFPS(Config.Settings.FPS)
            end
        end
    end
    Taiko.UpdateConfig()








--[[
    WARNING:
    Progress Bar SIGNIFICANTLY slows down loading time
    (probably caused by FLAG_VSYNC_HINT)

    POSSIBLE SOLUTION:
    No progress, but loading screen
]]
    --[[
    UpdateProgress = function(str)
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        Progress = Progress + 1
        rl.DrawText(
        '\nPercent: ' .. Progress / ProgressTotal * 100 .. '%' ..
        '\nProgress: ' .. Progress .. '/' .. ProgressTotal ..
        '\nLoading: ' .. str
        , 0, Config.ScreenHeight / 2, fontsize, rl.BLACK)

        rl.EndDrawing()
    end
    --]]
    -- [[
    UpdateProgress = function() end
    --]]


    -- [[
    --Loading screen (no progress fast)
    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawText([[
Taiko v34
Loading assets and config...

WARNING: Sound is very loud, so turn it all
the way down and work your way up.]], 0, Config.ScreenHeight / 2, fontsize, rl.BLACK)

    rl.EndDrawing()
    --]]


















    --[[
    local framerate = nil --Set frame rate, if nil then it is as fast as it can run
    --depracated for vsync
    --]]


    --SETTINGS (map from selectsong)



    --[=[
    --SUS
    local Settings = Settings or {}
    local optionsmap = {
        auto = {
            [1] = false,
            [2] = true,
        },
        notespeedmul = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 0.25,
            [6] = 0.5,
            [7] = 0.75,
        },
        songspeedmul = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 0.25,
            [6] = 0.5,
            [7] = 0.75,
        }
    }


    local auto = optionsmap.auto[Settings[2]] or false --Autoplay
    local autohitnotes = {
        [1] = 1,
        [2] = 2,
        [3] = 1,
        [4] = 2,
    }
    --[[
        About AutoPlay:
        Autoplay now sets the status as good, instead of just emulating the key press. This forces every note hit to be good. However, the timings may not be correct if you are below 60 fps.
    ]]


    --local autoemu = false --Emulate key on auto

    local notespeedmul = optionsmap.notespeedmul[Settings[3]] or 1 --Note Speed multiplier
    local songspeedmul = optionsmap.songspeedmul[Settings[4]] or 1 --Actual speed multiplier

    --local stopsong = true --Stop song enabled?
    local stopsong = Parsed.Metadata.STOPSONG
    local jposscroll = true
    local bpmchange = true --If it exists

    --]=]










    --Controls
    --Hit, Escape, L, R, Select
    --local Controls = Config.Controls.PlaySong
    --[=[
    local Controls = Controls or {}
    Controls = {
        --1 = don, 2 = ka
        Hit = Controls.Hit or {
            [rl.KEY_FOUR] = 2,
            [rl.KEY_V] = 1,
            [rl.KEY_N] = 1,
            [rl.KEY_EIGHT] = 2,
        },
        --Pause
        Escape = Controls.Escape or {
            [rl.KEY_ESCAPE] = true,
        },
        --Scroll
        L = Controls.L or {
            --Left
            [rl.KEY_LEFT] = true,

            --Up
            [rl.KEY_UP] = true,
        },
        R = Controls.R or {
            --Right
            [rl.KEY_RIGHT] = true,

            --Down
            [rl.KEY_DOWN] = true,
        },
        Select = Controls.Select or {
            --[[
            KEY_UP = true,
            KEY_DOWN = true,

            KEY_A2 = true,
            KEY_C2 = true,
            --]]


            [rl.KEY_ENTER] = true,
        }
    }
    --]=]


    --PLAYSONG CONFIG
    local target = {414/1280 * OriginalConfig.ScreenWidth, -(257/720 - 1/2) * OriginalConfig.ScreenHeight}
    local trackstart = 333/1280 * OriginalConfig.ScreenWidth
    local tracky = target[2]




































    --RAYLIB CONFIG






    --Config Options
    local offsetx, offsety = 0, OriginalConfig.ScreenHeight / 2 --Added to rendering

    --[[
    --uses texture
    local barlinecolor = rl.new('Color', 255, 255, 255, 255)
    --]]
    local bignotemul = Taiko.Data.BigNoteMul --Big note is this times bigger than small note
    local bignoteradius = 54 --Actual texture radius of big note


    --Default target: to allow for the saving of target before loading calculations, and offset
    local defaulttarget = {
        target[1],
        target[2]
    }
    local unloadrectchanged = {}

    local textsize = OriginalConfig.ScreenHeight / 45
    --print(textsize)

    local desynctime = 0.1 --Acceptable time for desync until correction (seconds)




























    --SKIN






    local skinresolution = {1280, 720} --Resolution for opentaiko skin
    local skinfps = 60 --Fps for opentaiko skin
    local skinframems = 1000 / skinfps --Ms per frame for opentaiko skin

    --Load skin config
    local SkinConfig = IniParser.LoadFile(AssetsPath .. 'SkinConfig.ini')
    for k, v in pairs(SkinConfig) do
        --SkinConfig[k] = IniParser.ParseCSVN(v)
        local t = IniParser.ParseCSV(v)
        local valid = true
        for i = 1, #t do
            local a = tonumber(t[i])
            if a then
                t[i] = a
            else
                valid = false
                break
            end
        end
        if valid then
            SkinConfig[k] = t
        end
    end
    --TEXTURES


    --Load textures
    --local TextureMap = require('texturemap')

    --Main texture storage
    local Textures = {
        PlaySong = {
            Notes = LoadImage('Graphics/5_Game/Notes.png'),
            SENotes = LoadImage('Graphics/5_Game/SENotes.png'),
            --ChipEffect = LoadImage('Graphics/5_Game/ChipEffect.png'),
            Barlines = {
                bar = LoadImage('Graphics/5_Game/Bar.png'),
                bar_branch = LoadImage('Graphics/5_Game/Bar_Branch.png')
            },
            Judges = LoadImage('Graphics/5_Game/Judge.png'),
            Balloons = {
                --[[
                Anim = {
                    [0] = LoadImage('Graphics/5_Game/11_Balloon/Breaking_0.png'),
                    [1] = LoadImage('Graphics/5_Game/11_Balloon/Breaking_1.png'),
                    [2] = LoadImage('Graphics/5_Game/11_Balloon/Breaking_2.png'),
                    [3] = LoadImage('Graphics/5_Game/11_Balloon/Breaking_3.png'),
                    [4] = LoadImage('Graphics/5_Game/11_Balloon/Breaking_4.png'),
                    [5] = LoadImage('Graphics/5_Game/11_Balloon/Breaking_5.png')
                }
                --]]
                Anim = LoadAnimSeperate('Graphics/5_Game/11_Balloon/Breaking_', '.png', 0, 5)
            },
            Effects = {
                Note = {
                    Hit = {
                        --Small ok
                        [1] = {
                            Anim = LoadAnimSeperate('Graphics/5_Game/10_Effects/Hit/Good/', '.png', 0, 14)
                        },
                        --Small good
                        [2] = {
                            Anim = LoadAnimSeperate('Graphics/5_Game/10_Effects/Hit/Great/', '.png', 0, 14)
                        },
                        --Big ok
                        [3] = {
                            Anim = LoadAnimSeperate('Graphics/5_Game/10_Effects/Hit/Good_Big/', '.png', 0, 14)
                        },
                        --Big good
                        [4] = {
                            Anim = LoadAnimSeperate('Graphics/5_Game/10_Effects/Hit/Great_Big/', '.png', 0, 14)
                        }
                    },
                    Explosion = LoadImage('Graphics/5_Game/10_Effects/Hit/Explosion.png'),
                    ExplosionBig = LoadImage('Graphics/5_Game/10_Effects/Hit/Explosion_Big.png')
                }
            },
            Lanes = {
                Lane = {
                    default = LoadImage('Graphics/5_Game/12_Lane/Background_Main.png'),
                    gogo = LoadImage('Graphics/5_Game/12_Lane/Background_GoGo.png'),
                    [1] = LoadImage('Graphics/5_Game/12_Lane/Red.png'),
                    [2] = LoadImage('Graphics/5_Game/12_Lane/Blue.png'),
                    sub = LoadImage('Graphics/5_Game/12_Lane/Background_Sub.png'),
                    N = LoadImage('Graphics/5_Game/12_Lane/Base_Normal.png'),
                    E = LoadImage('Graphics/5_Game/12_Lane/Base_Expert.png'),
                    M = LoadImage('Graphics/5_Game/12_Lane/Base_Master.png')
                },
                Text = {
                    N = LoadImage('Graphics/5_Game/12_Lane/Text_Normal.png'),
                    E = LoadImage('Graphics/5_Game/12_Lane/Text_Expert.png'),
                    M = LoadImage('Graphics/5_Game/12_Lane/Text_Master.png')
                }
            },
            Backgrounds = {
                Background = {
                    Down = {
                        [0] = LoadImage('Graphics/5_Game/5_Background/0/Down.png')
                    },
                    Footer = {
                        [0] = LoadImage('Graphics/5_Game/8_Footer/0.png')
                    },
                    Up = {
                        --goes down (drawn aligned to the left)
                        [0] = LoadImage('Graphics/5_Game/5_Background/0/1P_Up_2nd.png'),
                        --goes up
                        [1] = LoadImage('Graphics/5_Game/5_Background/0/1P_Up_1st.png'),
                    },
                    InfoBar = {
                        [0] = LoadImage('Graphics/5_Game/6_Taiko/1P_Background.png')
                    },
                    CourseSymbol = {
                        [0] = LoadImage('Graphics/5_Game/4_CourseSymbol/Easy.png'),
                        [1] = LoadImage('Graphics/5_Game/4_CourseSymbol/Normal.png'),
                        [2] = LoadImage('Graphics/5_Game/4_CourseSymbol/Hard.png'),
                        [3] = LoadImage('Graphics/5_Game/4_CourseSymbol/Oni.png'),
                        [4] = LoadImage('Graphics/5_Game/4_CourseSymbol/Edit.png'),
                        [5] = LoadImage('Graphics/5_Game/4_CourseSymbol/Tower.png'),
                        [6] = LoadImage('Graphics/5_Game/4_CourseSymbol/Dan.png')
                    }
                },
                Frame = {
                    [1] = LoadImage('Graphics/5_Game/6_Taiko/1P_Frame.png')
                },
                Taiko = {
                    base = LoadImage('Graphics/5_Game/6_Taiko/Base.png'),
                    [1] = LoadImage('Graphics/5_Game/6_Taiko/Don.png'),
                    [2] = LoadImage('Graphics/5_Game/6_Taiko/Ka.png'),
                    combo = LoadImage('Graphics/5_Game/6_Taiko/Combo_Text.png')
                },
                ComboText = {
                    [0] = LoadImage('Graphics/5_Game/6_Taiko/Combo_Text.png')
                }
            },
            Gauges = {
                Meter = {
                    base = LoadImage('Graphics/5_Game/7_Gauge/1P_Base.png'),
                    full = LoadImage('Graphics/5_Game/7_Gauge/1P.png'),
                    rainbow = {
                        Anim = LoadAnimSeperate('Graphics/5_Game/7_Gauge/rainbow/', '.png', 0, 11)
                    }
                },
                Clear = {

                }
            },
            Fonts = {
                Combo = {
                    [0] = LoadImage('Graphics/5_Game/6_Taiko/Combo.png'),
                    [1] = LoadImage('Graphics/5_Game/6_Taiko/Combo_Midium.png'),
                    [2] = LoadImage('Graphics/5_Game/6_Taiko/Combo_Big.png')
                },
                Score = {
                    [0] = LoadImage('Graphics/5_Game/6_Taiko/Score.png'),
                    [1] = LoadImage('Graphics/5_Game/6_Taiko/Score_1P.png')
                    --[[
                    [2] = LoadImage('Graphics/5_Game/6_Taiko/Score_2P.png')
                    --]]
                }
            },
            Nameplates = LoadImage('Graphics/NamePlate.png')
        },
        SongSelect = {
            --[[
            GenreBar = {
                --INSTEAD OF HARDCODING, PARSE BOX.DEF
                [0] = LoadImage('Graphics/3_SongSelect/Bar_Genre/Bar_Genre_0.png')
            }
            --]]
            --use loadanimseperate
            --keep in mind that these tables will be added to with sizex, sizey, pr, etc
            GenreBar = LoadAnimSeperate('Graphics/3_SongSelect/Bar_Genre/Bar_Genre_', '.png', 0, 9),
            BoxCharacter = LoadAnimSeperate('Graphics/3_SongSelect/Box_Chara/Box_Chara_', '.png', 0, 12),
            Difficulty = {
                Bar = LoadImage('Graphics/3_SongSelect/Difficulty_Select/Difficulty_Bar.png')
            },
            GenreBackground = LoadAnimSeperate('Graphics/3_SongSelect/Genre_Background/GenreBackground_', '.png', 0, 12)
        }
    }


    --Map for everything
    --WARNING: If it is not in image, it crashes
    local Map = {
        PlaySong = {
            --[[
            Notes = {
                target = {
                    0, 0
                },
                don = {
                    1, 0
                },
                ka = {
                    2, 0
                },
                DON = {
                    3, 0
                },
                KA = {
                    4, 0
                },
                drumrollnote = {
                    5, 0
                },
                drumrollrect = {
                    6, 0
                },
                drumrollend = {
                    7, 0
                },
                DRUMROLLnote = {
                    8, 0
                },
                DRUMROLLrect = {
                    9, 0
                },
                DRUMROLLend = {
                    10, 0
                },
                balloon = {
                    11, 0
                }
            }
            --]]
            Notes = {
                target = {
                    0, 0
                },
                [1] = {
                    1, 0
                },
                [2] = {
                    2, 0
                },
                [3] = {
                    3, 0
                },
                [4] = {
                    4, 0
                },
                drumrollnote = {
                    5, 0
                },
                drumrollrect = {
                    6, 0
                },
                drumrollend = {
                    7, 0
                },
                DRUMROLLnote = {
                    8, 0
                },
                DRUMROLLrect = {
                    9, 0
                },
                DRUMROLLend = {
                    10, 0
                },
                --[[
                [7] = {
                    11, 0
                }
                --]]
                balloon = {
                    11, 0
                },
                balloonend = {
                    12, 0
                }
            },
            SENotes = {
                [1] = {
                    0, 0
                },
                [2] = {
                    0, 1
                },
                [3] = {
                    0, 2
                },
                [4] = {
                    0, 3
                },
                [5] = {
                    0, 4
                },
                [6] = {
                    0, 5
                },
                [7] = {
                    0, 6
                },
                [8] = {
                    0, 7
                },
                [9] = {
                    0, 8
                },
                [10] = {
                    0, 9
                },
                [11] = {
                    0, 10
                },
                [12] = {
                    0, 11
                }
            },
            --[[
            Barlines = {
                bar = nil,
                bar_branch = nil
            },
            --]]
            Judges = {
                [2] = {
                    0, 0
                },
                [1] = {
                    0, 1
                },
                [0] = {
                    0, 2
                },
                adlib = {
                    0, 3
                },
                --[[
                mine = {
                    0, 4
                }
                --]]
            },
            Effects = {
                Note = {
                    Explosion = {
                        --Small ok
                        [1] = {
                            Anim = {
                                [0] = {0, 1},
                                [1] = {1, 1},
                                [2] = {2, 1},
                                [3] = {3, 1},
                                [4] = {4, 1},
                                [5] = {5, 1},
                                [6] = {6, 1}
                            }
                        },
                        --Small good
                        [2] = {
                            Anim = {
                                [0] = {0, 0},
                                [1] = {1, 0},
                                [2] = {2, 0},
                                [3] = {3, 0},
                                [4] = {4, 0},
                                [5] = {5, 0},
                                [6] = {6, 0}
                            }
                        },
                        --Big ok
                        [3] = {
                            Anim = {
                                [0] = {0, 3},
                                [1] = {1, 3},
                                [2] = {2, 3},
                                [3] = {3, 3},
                                [4] = {4, 3},
                                [5] = {5, 3},
                                [6] = {6, 3}
                            }
                        },
                        --Big good
                        [4] = {
                            Anim = {
                                [0] = {0, 2},
                                [1] = {1, 2},
                                [2] = {2, 2},
                                [3] = {3, 2},
                                [4] = {4, 2},
                                [5] = {5, 2},
                                [6] = {6, 2}
                            }
                        }
                    }
                }
            },
            Nameplates = {
                [1] = {0, 0}, --1P red
                [3] = {0, 1}, --1P blue
                [2] = {0, 2}, --2P blue
                base = {0, 3},
                edge = {0, 4},
                top = {0, 5},
                rankbase = {0, 7},
                rank = {
                    [1] = {0, 8}, --silver
                    [2] = {0, 9}, --gold
                    [3] = {0, 10}, --rainbow
                }
            }
        }
    }






    --Load!
    UpdateProgress('Splitting into textures')
    





    --PLAYSONG












    --Notes

    local defaultsize = {130, 130}

    local xymul = {130, 130}

    local m = Map.PlaySong.Notes.drumrollend
    local _ = rl.ImageFromImage(Textures.PlaySong.Notes, rl.new('Rectangle', m[1] * defaultsize[1] - 5, m[2] * defaultsize[2], defaultsize[1], defaultsize[2]))

    Textures.PlaySong.Notes = TextureMap.SplitUsingMap(Textures.PlaySong.Notes, Map.PlaySong.Notes, defaultsize, xymul)
    --Textures.PlaySong.ChipEffect = TextureMap.SplitUsingMap(Textures.PlaySong.ChipEffect, Map.Notes, defaultsize, xymul)

    Textures.PlaySong.Notes.drumrollstart = rl.ImageCopy(Textures.PlaySong.Notes.drumrollend)
    rl.ImageFlipHorizontal(Textures.PlaySong.Notes.drumrollstart)
    --[[
    Textures.PlaySong.ChipEffect.drumrollstart = rl.ImageCopy(Textures.PlaySong.ChipEffect.drumrollend)
    rl.ImageFlipHorizontal(Textures.PlaySong.ChipEffect.drumrollstart)
    --]]

    Textures.PlaySong.Notes.DRUMROLLstart = rl.ImageCopy(Textures.PlaySong.Notes.DRUMROLLend)
    rl.ImageFlipHorizontal(Textures.PlaySong.Notes.DRUMROLLstart)
    --[[
    Textures.PlaySong.ChipEffect.DRUMROLLstart = rl.ImageCopy(Textures.PlaySong.ChipEffect.DRUMROLLend)
    rl.ImageFlipHorizontal(Textures.PlaySong.ChipEffect.DRUMROLLstart)
    --]]

    --drumrollbend?
    --[[
    local b = rl.ImageFromImage(Textures.PlaySong.Notes.drumrollend, rl.new('Rectangle', 0, 0, Textures.PlaySong.Notes.drumrollend.width / 2, Textures.PlaySong.Notes.drumrollend.height))
    local a = rl.ImageCopy(b)
    rl.ImageFlipHorizontal(a)
    rl.ImageDraw(a, b, rl.new('Rectangle', 0, 0, b.width, b.height), rl.new('Rectangle', 0, 0, b.width, b.height), rl.WHITE)
    --]]

    --[[
    local a = rl.ImageCopy(Textures.PlaySong.Notes.drumrollend)
    local t = Textures.PlaySong.Notes.drumrollend
    rl.ImageDraw(a, Textures.PlaySong.Notes.drumrollend, rl.new('Rectangle', 0, 0, t.width / 2, t.height), rl.new('Rectangle', t.width / 2, 0, t.width / 2, t.height), rl.WHITE)
    rl.ImageDraw(a, Textures.PlaySong.Notes.drumrollstart, rl.new('Rectangle', t.width / 2, 0, t.width / 2, t.height), rl.new('Rectangle', 0, 0, t.width / 2, t.height), rl.WHITE)
    --]]

    -- [[
    local t = Textures.PlaySong.Notes.drumrollend
    --_ computed above
    local _2 = rl.ImageCopy(_)
    rl.ImageFlipHorizontal(_2)
    local a = rl.ImageFromImage(_2, rl.new('Rectangle', t.width / 2, 0, t.width / 2, t.height))
    rl.ImageResizeCanvas(a, t.width, t.height, 0, 0, rl.WHITE)
    rl.ImageDraw(a, _, rl.new('Rectangle', 0, 0, t.width / 2, t.height), rl.new('Rectangle', t.width / 2, 0, t.width / 2, t.height), rl.WHITE)
    --]]

    --a = rl.ImageCopy(Textures.PlaySong.Notes.drumrollend)

    --rl.ImageDrawRectangleLines(a, rl.new('Rectangle', 0, 0, a.width, a.height), 2, rl.RED)

    Textures.PlaySong.Notes.drumrollbend = a

    rl.UnloadImage(_)
    rl.UnloadImage(_2)

    --Old noteradius resizer
    --local resizefactor = (noteradius * 2) / (bignoteradius * 2 / bignotemul)

    --Assume skin is 720p
    --local resizefactor = Config.ScreenWidth / 1280
    --[[
    local function Resize(t, times)
        times = times or 1
        for k, v in pairs(t) do
            if type(v) == 'table' then
                v = Resize(v, times)
            else
                rl.ImageResize(v, resizefactor * v.width * times, resizefactor * v.height * times)
            end
        end
        return t
    end
    --]]
    local function Resize(t, timesx, timesy)
        timesx = timesx or 1
        timesy = timesy or 1
        if type(t) == 'table' then
            for k, v in pairs(t) do
                Resize(v, timesx, timesy)
            end
        else
            --Assume skin is 720p
            rl.ImageResize(t, (OriginalConfig.ScreenWidth / 1280) * t.width * timesx, (OriginalConfig.ScreenHeight / 720) * t.height * timesy)
        end
        return t
    end
    

    Textures.PlaySong.Notes = Resize(Textures.PlaySong.Notes)
    --Textures.PlaySong.ChipEffect = Resize(Textures.PlaySong.ChipEffect)

    Textures.PlaySong.Notes = TextureMap.ReplaceWithTexture(Textures.PlaySong.Notes)


    local tsizex, tsizey = Textures.PlaySong.Notes.target.width, Textures.PlaySong.Notes.target.height
    local tsourcerect = rl.new('Rectangle', 0, 0, tsizex, tsizey)
    local tcenter = rl.new('Vector2', tsizex / 2, tsizey / 2)
    local toffsetx, toffsety = offsetx - (tsizex / 2), offsety - (tsizey / 2)
    local xmul, ymul = 1, -1

    local targetpr = rl.new('Rectangle', 0, 0, 0, 0)

    --drumrollpr and drumrollpr2
    Textures.PlaySong.Notes.drumrollpr = rl.new('Rectangle', 0, 0, tsizex, tsizey)
    Textures.PlaySong.Notes.drumrollpr2 = rl.new('Rectangle', 0, 0, tsizex, tsizey)


    --needs tcenter
    --Used when toggling fullscreen
    local scale = {1, 1}
    local function ResizeAll(t, timesx, timesy, recursive)
        if not recursive then
            scale[1] = scale[1] * timesx
            scale[2] = scale[2] * timesy
            --print(unpack(scale))

            --[[
            target[1] = (target[1] - offsetx) * timesx + offsetx
            target[2] = (target[2] - offsety) * timesy + offsety
            --]]

            tcenter.x = tcenter.x * timesx
            tcenter.y = tcenter.y * timesy

            --debug
            --textsize = Config.ScreenHeight / 45
            textsize = textsize * timesy
        end
        --timesx, timesy needs to be provided
        for k, v in pairs(t) do
            if type(v) == 'table' then
                ResizeAll(v, timesx, timesy, true)
            elseif type(v) == 'number' then
                if string.find(k, 'sizex') then
                    t[k] = v * timesx
                elseif string.find(k, 'sizey') then
                    t[k] = v * timesy
                end
            elseif type(v) == 'cdata' then
                local a = tostring(v)
                if string.find(a, 'Image') then
                    --Assume skin is 720p
                    --rl.ImageResize(t, t.width * timesx, t.height * timesy)
                elseif string.find(a, 'Texture') then
                    --no need to resize, just resize rects
                elseif string.find(a, 'Vector2') then
                    v.x = v.x * timesx
                    v.y = v.y * timesy
                elseif string.find(a, 'Rectangle') then
                    if string.find(k, 'sourcerect') then

                    else
                        v.x = v.x * timesx
                        v.y = v.y * timesy
                        v.width = v.width * timesx
                        v.height = v.height * timesy
                    end
                end
            end
        end
        return t
    end
    local function ResetResizeAll()
        --ResizeAll(Textures, 1 / scale[1], 1 / scale[2])
    end
    local function SetupResizeAll()
        --ResizeAll(Textures, Config.ScreenWidth / OriginalConfig.ScreenWidth, Config.ScreenHeight / OriginalConfig.ScreenHeight)
    end





    --Apply ChipEffect
    --[[
    for k, v in pairs(Textures.PlaySong.Notes) do
        rl.ImageAlphaMask(v, Textures.PlaySong.ChipEffect[k])
    end
    --]]

    --Textures.PlaySong.Notes = Textures.PlaySong.ChipEffect







    --SENotes

    local defaultsize = {136, 30}

    local xymul = {136, 30}

    Textures.PlaySong.SENotes = TextureMap.SplitUsingMap(Textures.PlaySong.SENotes, Map.PlaySong.SENotes, defaultsize, xymul)
    
    Textures.PlaySong.SENotes = Resize(Textures.PlaySong.SENotes)

    Textures.PlaySong.SENotes = TextureMap.ReplaceWithTexture(Textures.PlaySong.SENotes)

    Textures.PlaySong.SENotes.sizex = Textures.PlaySong.SENotes[1].width
    Textures.PlaySong.SENotes.sizey = Textures.PlaySong.SENotes[1].height
    Textures.PlaySong.SENotes.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.SENotes.sizex, Textures.PlaySong.SENotes.sizey)
    Textures.PlaySong.SENotes.center = rl.new('Vector2', Textures.PlaySong.SENotes.sizex / 2, Textures.PlaySong.SENotes.sizey / 2)

    Textures.PlaySong.SENotes.offsety = 80/720 * OriginalConfig.ScreenHeight --TODO:Config


    --Barlines

    Textures.PlaySong.Barlines = Resize(Textures.PlaySong.Barlines)

    Textures.PlaySong.Barlines = TextureMap.ReplaceWithTexture(Textures.PlaySong.Barlines)
    local barlinesizex, barlinesizey = Textures.PlaySong.Barlines.bar.width, Textures.PlaySong.Barlines.bar.height
    local barlinesourcerect = rl.new('Rectangle', 0, 0, barlinesizex, barlinesizey)
    local barlinecenter = rl.new('Vector2', barlinesizex / 2, barlinesizey / 2)



    --Balloons

    Textures.PlaySong.Balloons = Resize(Textures.PlaySong.Balloons)

    Textures.PlaySong.Balloons = TextureMap.ReplaceWithTexture(Textures.PlaySong.Balloons)

    Textures.PlaySong.Balloons.sizex = Textures.PlaySong.Balloons.Anim[0].width
    Textures.PlaySong.Balloons.sizey = Textures.PlaySong.Balloons.Anim[0].height
    Textures.PlaySong.Balloons.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Balloons.sizex, Textures.PlaySong.Balloons.sizey)
    Textures.PlaySong.Balloons.center = rl.new('Vector2', Textures.PlaySong.Balloons.sizex / 2, Textures.PlaySong.Balloons.sizey / 2)
    Textures.PlaySong.Balloons.pr = rl.new('Rectangle', 0, 0, Textures.PlaySong.Balloons.sizex, Textures.PlaySong.Balloons.sizey)
    Textures.PlaySong.Balloons.pr2 = rl.new('Rectangle', 0, 0, tsizex, tsizey)







    --Judges

    local defaultsize = {90, 60}

    local xymul = {90, 60}


    Textures.PlaySong.Judges = TextureMap.SplitUsingMap(Textures.PlaySong.Judges, Map.PlaySong.Judges, defaultsize, xymul)

    Textures.PlaySong.Judges = Resize(Textures.PlaySong.Judges)

    Textures.PlaySong.Judges = TextureMap.ReplaceWithTexture(Textures.PlaySong.Judges)


    Textures.PlaySong.Judges.sizex = Textures.PlaySong.Judges[0].width
    Textures.PlaySong.Judges.sizey = Textures.PlaySong.Judges[0].height
    Textures.PlaySong.Judges.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Judges.sizex, Textures.PlaySong.Judges.sizey)
    Textures.PlaySong.Judges.center = rl.new('Vector2', Textures.PlaySong.Judges.sizex / 2, Textures.PlaySong.Judges.sizey / 2)
    Textures.PlaySong.Judges.pr = rl.new('Rectangle', 0, 0, Textures.PlaySong.Judges.sizex, Textures.PlaySong.Judges.sizey)



    --Effects

    local effectcolor = rl.new('Color', 255, 255, 255, 255 / 2)

    --Hit

    Textures.PlaySong.Effects.Note.Hit = Resize(Textures.PlaySong.Effects.Note.Hit)

    Textures.PlaySong.Effects.Note.Hit = TextureMap.ReplaceWithTexture(Textures.PlaySong.Effects.Note.Hit)


    Textures.PlaySong.Effects.Note.sizex = Textures.PlaySong.Effects.Note.Hit[1].Anim[0].width
    Textures.PlaySong.Effects.Note.sizey = Textures.PlaySong.Effects.Note.Hit[1].Anim[0].height

    --In case base didn't load
    Textures.PlaySong.Effects.Note.sizex = Textures.PlaySong.Effects.Note.sizex == 0 and 260/1280 * OriginalConfig.ScreenWidth or Textures.PlaySong.Effects.Note.sizex
    Textures.PlaySong.Effects.Note.sizey = Textures.PlaySong.Effects.sizey == 0 and 260/720 * OriginalConfig.ScreenHeight or Textures.PlaySong.Effects.Note.sizey

    Textures.PlaySong.Effects.Note.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Effects.Note.sizex, Textures.PlaySong.Effects.Note.sizey)
    Textures.PlaySong.Effects.Note.center = rl.new('Vector2', Textures.PlaySong.Effects.Note.sizex / 2, Textures.PlaySong.Effects.Note.sizey / 2)

    




    --Explosion

    local defaultsize = {260, 260}

    local xymul = {260, 260}


    Textures.PlaySong.Effects.Note.Explosion = TextureMap.SplitUsingMap(Textures.PlaySong.Effects.Note.Explosion, Map.PlaySong.Effects.Note.Explosion, defaultsize, xymul)

    Textures.PlaySong.Effects.Note.Explosion = Resize(Textures.PlaySong.Effects.Note.Explosion)

    Textures.PlaySong.Effects.Note.Explosion = TextureMap.ReplaceWithTexture(Textures.PlaySong.Effects.Note.Explosion)




    --Explosion Big
    --Textures.PlaySong.Effects.Note.ExplosionBig = Resize(Textures.PlaySong.Effects.Note.ExplosionBig)
    local temp = {Textures.PlaySong.Effects.Note.ExplosionBig}
    Textures.PlaySong.Effects.Note.ExplosionBig = Resize(temp)

    --Textures.PlaySong.Effects.Note.ExplosionBig = TextureMap.ReplaceWithTexture(Textures.PlaySong.Effects.Note.ExplosionBig)

    Textures.PlaySong.Effects.Note.ExplosionBig = {
        Anim = {
            [0] = TextureMap.ReplaceWithTexture(temp)[1]
        }
    }


    --LANE
    Textures.PlaySong.Lanes = Resize(Textures.PlaySong.Lanes)

    Textures.PlaySong.Lanes = TextureMap.ReplaceWithTexture(Textures.PlaySong.Lanes)

    --Lane
    Textures.PlaySong.Lanes.sizex = Textures.PlaySong.Lanes.Lane.default.width
    Textures.PlaySong.Lanes.sizey = Textures.PlaySong.Lanes.Lane.default.height
    Textures.PlaySong.Lanes.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Lanes.sizex, Textures.PlaySong.Lanes.sizey)
    Textures.PlaySong.Lanes.center = rl.new('Vector2', 0, Textures.PlaySong.Lanes.sizey / 2)
    Textures.PlaySong.Lanes.pr = rl.new('Rectangle', trackstart * xmul + offsetx, tracky * ymul + offsety, Textures.PlaySong.Lanes.sizex, Textures.PlaySong.Lanes.sizey)

    --Sub
    Textures.PlaySong.Lanes.ssizex = Textures.PlaySong.Lanes.Lane.sub.width
    Textures.PlaySong.Lanes.ssizey = Textures.PlaySong.Lanes.Lane.sub.height
    Textures.PlaySong.Lanes.ssourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Lanes.ssizex, Textures.PlaySong.Lanes.ssizey)
    Textures.PlaySong.Lanes.scenter = rl.new('Vector2', 0, 0)
    --Textures.PlaySong.Lanes.spr = rl.new('Rectangle', trackstart * xmul + offsetx, (tracky - Textures.PlaySong.Lanes.sizey / 2) * ymul + offsety, Textures.PlaySong.Lanes.ssizex, Textures.PlaySong.Lanes.ssizey)
    Textures.PlaySong.Lanes.spr = rl.new('Rectangle', trackstart * xmul + offsetx, 325/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Lanes.ssizex, Textures.PlaySong.Lanes.ssizey)



    --BACKGROUND

    Textures.PlaySong.Backgrounds = Resize(Textures.PlaySong.Backgrounds)

    Textures.PlaySong.Backgrounds = TextureMap.ReplaceWithTexture(Textures.PlaySong.Backgrounds)

    --Frame
    Textures.PlaySong.Backgrounds.Frame.sizex = Textures.PlaySong.Backgrounds.Frame[1].width
    Textures.PlaySong.Backgrounds.Frame.sizey = Textures.PlaySong.Backgrounds.Frame[1].height
    Textures.PlaySong.Backgrounds.Frame.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Frame.sizex, Textures.PlaySong.Backgrounds.Frame.sizey)
    Textures.PlaySong.Backgrounds.Frame.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.Frame.pr = rl.new('Rectangle', 332/1280 * OriginalConfig.ScreenWidth, 136/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Frame.sizex, Textures.PlaySong.Backgrounds.Frame.sizey)

    --Taiko
    Textures.PlaySong.Backgrounds.Taiko.sizex = Textures.PlaySong.Backgrounds.Taiko.base.width
    Textures.PlaySong.Backgrounds.Taiko.sizey = Textures.PlaySong.Backgrounds.Taiko.base.height
    Textures.PlaySong.Backgrounds.Taiko.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Taiko.sizex, Textures.PlaySong.Backgrounds.Taiko.sizey)
    Textures.PlaySong.Backgrounds.Taiko.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.Taiko.pr = rl.new('Rectangle', 210/1280 * OriginalConfig.ScreenWidth, 206/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Taiko.sizex, Textures.PlaySong.Backgrounds.Taiko.sizey)

    --ComboText (goes with Fonts.Combo)
    Textures.PlaySong.Backgrounds.ComboText.sizex = Textures.PlaySong.Backgrounds.ComboText[0].width
    Textures.PlaySong.Backgrounds.ComboText.sizey = Textures.PlaySong.Backgrounds.ComboText[0].height
    Textures.PlaySong.Backgrounds.ComboText.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.ComboText.sizex, Textures.PlaySong.Backgrounds.ComboText.sizey)
    Textures.PlaySong.Backgrounds.ComboText.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.ComboText.pr = rl.new('Rectangle', 220/1280 * OriginalConfig.ScreenWidth, 198/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.ComboText.sizex, Textures.PlaySong.Backgrounds.ComboText.sizey)

    --Background

    --Bottom






    --Down
    Textures.PlaySong.Backgrounds.Background.Down.sizex = Textures.PlaySong.Backgrounds.Background.Down[0].width
    Textures.PlaySong.Backgrounds.Background.Down.sizey = Textures.PlaySong.Backgrounds.Background.Down[0].height
    Textures.PlaySong.Backgrounds.Background.Down.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Background.Down.sizex, Textures.PlaySong.Backgrounds.Background.Down.sizey)
    Textures.PlaySong.Backgrounds.Background.Down.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.Background.Down.pr = rl.new('Rectangle', 0/1280 * OriginalConfig.ScreenWidth, 360/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Background.Down.sizex, Textures.PlaySong.Backgrounds.Background.Down.sizey)

    --Footer
    Textures.PlaySong.Backgrounds.Background.Footer.sizex = Textures.PlaySong.Backgrounds.Background.Footer[0].width
    Textures.PlaySong.Backgrounds.Background.Footer.sizey = Textures.PlaySong.Backgrounds.Background.Footer[0].height
    Textures.PlaySong.Backgrounds.Background.Footer.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Background.Footer.sizex, Textures.PlaySong.Backgrounds.Background.Footer.sizey)
    Textures.PlaySong.Backgrounds.Background.Footer.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.Background.Footer.pr = rl.new('Rectangle', 0/1280 * OriginalConfig.ScreenWidth, 676/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Background.Footer.sizex, Textures.PlaySong.Backgrounds.Background.Footer.sizey)

    --Up
    Textures.PlaySong.Backgrounds.Background.Up.sizex = Textures.PlaySong.Backgrounds.Background.Up[0].width
    Textures.PlaySong.Backgrounds.Background.Up.sizey = Textures.PlaySong.Backgrounds.Background.Up[0].height
    Textures.PlaySong.Backgrounds.Background.Up.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Background.Up.sizex, Textures.PlaySong.Backgrounds.Background.Up.sizey)
    Textures.PlaySong.Backgrounds.Background.Up.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.Background.Up.pr = rl.new('Rectangle', 0/1280 * OriginalConfig.ScreenWidth, 0/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Background.Up.sizex, Textures.PlaySong.Backgrounds.Background.Up.sizey)

    --InfoBar
    Textures.PlaySong.Backgrounds.Background.InfoBar.sizex = Textures.PlaySong.Backgrounds.Background.InfoBar[0].width
    Textures.PlaySong.Backgrounds.Background.InfoBar.sizey = Textures.PlaySong.Backgrounds.Background.InfoBar[0].height
    Textures.PlaySong.Backgrounds.Background.InfoBar.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Background.InfoBar.sizex, Textures.PlaySong.Backgrounds.Background.InfoBar.sizey)
    Textures.PlaySong.Backgrounds.Background.InfoBar.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Backgrounds.Background.InfoBar.pr = rl.new('Rectangle', 0/1280 * OriginalConfig.ScreenWidth, 184/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Background.InfoBar.sizex, Textures.PlaySong.Backgrounds.Background.InfoBar.sizey)

    --CourseSymbol
    Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizex = Textures.PlaySong.Backgrounds.Background.CourseSymbol[0].width
    Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizey = Textures.PlaySong.Backgrounds.Background.CourseSymbol[0].height
    Textures.PlaySong.Backgrounds.Background.CourseSymbol.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizex, Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizey)
    Textures.PlaySong.Backgrounds.Background.CourseSymbol.center = rl.new('Vector2', 0, 0)
    --(arcade)
    Textures.PlaySong.Backgrounds.Background.CourseSymbol.pr = rl.new('Rectangle', 58/1280 * OriginalConfig.ScreenWidth, 230/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizex, Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizey)
    --(opentaiko)
    Textures.PlaySong.Backgrounds.Background.CourseSymbol.pr = rl.new('Rectangle', 18/1280 * OriginalConfig.ScreenWidth, 230/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizex, Textures.PlaySong.Backgrounds.Background.CourseSymbol.sizey)

















    --GAUGES

    --[[
        Extract clear from base
        x = 0
        y = 44
        w = 58
        h = 24
    ]]

    Textures.PlaySong.Gauges.Clear[true] = rl.ImageFromImage(Textures.PlaySong.Gauges.Meter.base, rl.new('Rectangle', 0, 44, 58, 24))
    Textures.PlaySong.Gauges.Clear[false] = rl.ImageFromImage(Textures.PlaySong.Gauges.Meter.base, rl.new('Rectangle', 58, 44, 58, 24))

    --Meter (gaugeclear)
    Textures.PlaySong.Gauges.Meter.clear = rl.ImageCopy(Textures.PlaySong.Gauges.Meter.full)
    --Tint yellow
    for x = 0, Textures.PlaySong.Gauges.Meter.clear.width - 1 do
        for y = 0, Textures.PlaySong.Gauges.Meter.clear.height - 1 do
            local color = rl.GetImageColor(Textures.PlaySong.Gauges.Meter.clear, x, y)
            color.g = color.r
            rl.ImageDrawPixel(Textures.PlaySong.Gauges.Meter.clear, x, y, color)
        end
    end

    --Convert to textures

    Textures.PlaySong.Gauges = Resize(Textures.PlaySong.Gauges)

    Textures.PlaySong.Gauges = TextureMap.ReplaceWithTexture(Textures.PlaySong.Gauges)

    --Meter
    Textures.PlaySong.Gauges.Meter.sizex = Textures.PlaySong.Gauges.Meter.base.width
    Textures.PlaySong.Gauges.Meter.sizey = Textures.PlaySong.Gauges.Meter.base.height
    Textures.PlaySong.Gauges.Meter.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Gauges.Meter.sizex, Textures.PlaySong.Gauges.Meter.sizey)
    Textures.PlaySong.Gauges.Meter.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Gauges.Meter.pr = rl.new('Rectangle', 494/1280 * OriginalConfig.ScreenWidth, 144/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Gauges.Meter.sizex, Textures.PlaySong.Gauges.Meter.sizey)
    
    --Meter (fill)
    Textures.PlaySong.Gauges.Meter.sourcerect2 = rl.new('Rectangle', 0, 0, Textures.PlaySong.Gauges.Meter.sizex, Textures.PlaySong.Gauges.Meter.sizey)
    Textures.PlaySong.Gauges.Meter.pr2 = rl.new('Rectangle', 494/1280 * OriginalConfig.ScreenWidth, 144/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Gauges.Meter.sizex, Textures.PlaySong.Gauges.Meter.sizey)

    --Clear
    Textures.PlaySong.Gauges.Clear.sizex = Textures.PlaySong.Gauges.Clear[true].width
    Textures.PlaySong.Gauges.Clear.sizey = Textures.PlaySong.Gauges.Clear[true].height
    Textures.PlaySong.Gauges.Clear.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Gauges.Clear.sizex, Textures.PlaySong.Gauges.Clear.sizey)
    Textures.PlaySong.Gauges.Clear.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Gauges.Clear.pr = rl.new('Rectangle', 1038/1280 * OriginalConfig.ScreenWidth, 143/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Gauges.Clear.sizex, Textures.PlaySong.Gauges.Clear.sizey)

    --Meter (gaugeoverflow)
    Textures.PlaySong.Gauges.Meter.rainbow.sizex = Textures.PlaySong.Gauges.Meter.rainbow.Anim[0].width
    Textures.PlaySong.Gauges.Meter.rainbow.sizey = Textures.PlaySong.Gauges.Meter.rainbow.Anim[0].height
    Textures.PlaySong.Gauges.Meter.rainbow.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Gauges.Meter.rainbow.sizex, Textures.PlaySong.Gauges.Meter.rainbow.sizey)
    Textures.PlaySong.Gauges.Meter.rainbow.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Gauges.Meter.rainbow.pr = rl.new('Rectangle', 494/1280 * OriginalConfig.ScreenWidth, 144/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Gauges.Meter.rainbow.sizex, Textures.PlaySong.Gauges.Meter.rainbow.sizey)


    --FONTS (individual)

    --Combo
    Textures.PlaySong.Fonts = Resize(Textures.PlaySong.Fonts)

    Textures.PlaySong.Fonts = TextureMap.ReplaceWithTexture(Textures.PlaySong.Fonts)



    --NAMEPLATE

    local defaultsize = {220, 54}

    local xymul = {220, 54}


    Textures.PlaySong.Nameplates = TextureMap.SplitUsingMap(Textures.PlaySong.Nameplates, Map.PlaySong.Nameplates, defaultsize, xymul)

    Textures.PlaySong.Nameplates = Resize(Textures.PlaySong.Nameplates)

    Textures.PlaySong.Nameplates = TextureMap.ReplaceWithTexture(Textures.PlaySong.Nameplates)


    Textures.PlaySong.Nameplates.sizex = Textures.PlaySong.Nameplates.base.width
    Textures.PlaySong.Nameplates.sizey = Textures.PlaySong.Nameplates.base.height
    Textures.PlaySong.Nameplates.sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Nameplates.sizex, Textures.PlaySong.Nameplates.sizey)
    Textures.PlaySong.Nameplates.center = rl.new('Vector2', 0, 0)
    Textures.PlaySong.Nameplates.pr = rl.new('Rectangle', -5/1280 * OriginalConfig.ScreenWidth, 296/720 * OriginalConfig.ScreenHeight, Textures.PlaySong.Nameplates.sizex, Textures.PlaySong.Nameplates.sizey)








    --SOUND
    --[[
    --put stuff in playsong
    local playmusic = Parsed.Metadata.SONG --Is the song valid?

    rl.InitAudioDevice()
    local song
    local forceresync = false --force resync on next frame
    if playmusic then
        if CheckFile(Parsed.Metadata.SONG) then
            song = LoadSong(Parsed.Metadata.SONG)
            rl.SetMusicVolume(song, Parsed.Metadata.SONGVOL)
        else
            playmusic = false
        end
    end
    --]]
    rl.InitAudioDevice()
    rl.SetMasterVolume(Config.Settings.MasterVolume)



    local Sounds = {
        PlaySong = {
            Combo = (not Config.ComboSoundEnabled) and {} or {
                [50] = LoadSound('Sounds/Combo_1P/50.wav'),
                [100] = LoadSound('Sounds/Combo_1P/100.wav'),
                [200] = LoadSound('Sounds/Combo_1P/200.wav'),
                [300] = LoadSound('Sounds/Combo_1P/300.wav'),
                [400] = LoadSound('Sounds/Combo_1P/400.wav'),
                [500] = LoadSound('Sounds/Combo_1P/500.wav'),
                [600] = LoadSound('Sounds/Combo_1P/600.wav'),
                [700] = LoadSound('Sounds/Combo_1P/700.wav'),
                [800] = LoadSound('Sounds/Combo_1P/800.wav'),
                [900] = LoadSound('Sounds/Combo_1P/900.wav'),
                [1000] = LoadSound('Sounds/Combo_1P/1000.wav'),
                [1100] = LoadSound('Sounds/Combo_1P/1100.wav'),
                [1200] = LoadSound('Sounds/Combo_1P/1200.wav'),
                [1300] = LoadSound('Sounds/Combo_1P/1300.wav'),
                [1400] = LoadSound('Sounds/Combo_1P/1400.wav'),
                [1500] = LoadSound('Sounds/Combo_1P/1500.wav'),
                [1600] = LoadSound('Sounds/Combo_1P/1600.wav'),
                [1700] = LoadSound('Sounds/Combo_1P/1700.wav'),
                [1800] = LoadSound('Sounds/Combo_1P/1800.wav'),
                [1900] = LoadSound('Sounds/Combo_1P/1900.wav'),
                [2000] = LoadSound('Sounds/Combo_1P/2000.wav'),
                [2100] = LoadSound('Sounds/Combo_1P/2100.wav'),
                [2200] = LoadSound('Sounds/Combo_1P/2200.wav'),
                [2300] = LoadSound('Sounds/Combo_1P/2300.wav'),
                [2400] = LoadSound('Sounds/Combo_1P/2400.wav'),
                [2500] = LoadSound('Sounds/Combo_1P/2500.wav'),
                [2600] = LoadSound('Sounds/Combo_1P/2600.wav'),
                [2700] = LoadSound('Sounds/Combo_1P/2700.wav'),
                [2800] = LoadSound('Sounds/Combo_1P/2800.wav'),
                [2900] = LoadSound('Sounds/Combo_1P/2900.wav'),
                [3000] = LoadSound('Sounds/Combo_1P/3000.wav'),
                [3100] = LoadSound('Sounds/Combo_1P/3100.wav'),
                [3200] = LoadSound('Sounds/Combo_1P/3200.wav'),
                [3300] = LoadSound('Sounds/Combo_1P/3300.wav'),
                [3400] = LoadSound('Sounds/Combo_1P/3400.wav'),
                [3500] = LoadSound('Sounds/Combo_1P/3500.wav'),
                [3600] = LoadSound('Sounds/Combo_1P/3600.wav'),
                [3700] = LoadSound('Sounds/Combo_1P/3700.wav'),
                [3800] = LoadSound('Sounds/Combo_1P/3800.wav'),
                [3900] = LoadSound('Sounds/Combo_1P/3900.wav'),
                [4000] = LoadSound('Sounds/Combo_1P/4000.wav'),
                [4100] = LoadSound('Sounds/Combo_1P/4100.wav'),
                [4200] = LoadSound('Sounds/Combo_1P/4200.wav'),
                [4300] = LoadSound('Sounds/Combo_1P/4300.wav'),
                [4400] = LoadSound('Sounds/Combo_1P/4400.wav'),
                [4500] = LoadSound('Sounds/Combo_1P/4500.wav'),
                [4600] = LoadSound('Sounds/Combo_1P/4600.wav'),
                [4700] = LoadSound('Sounds/Combo_1P/4700.wav'),
                [4800] = LoadSound('Sounds/Combo_1P/4800.wav'),
                [4900] = LoadSound('Sounds/Combo_1P/4900.wav'),
                [5000] = LoadSound('Sounds/Combo_1P/5000.wav')
            },
            Notes = {
                [1] = LoadSound('Sounds/Taiko/dong.ogg'),
                [2] = LoadSound('Sounds/Taiko/ka.ogg'),
                adlib = LoadSound('Sounds/Taiko/Adlib.ogg'),
                balloonpop = LoadSound('Sounds/balloon.ogg')
            }
        }
    }

    --[[
    --put in playsong
    for k, v in pairs(Sounds.PlaySong.Combo) do
        rl.SetSoundVolume(v, Parsed.Metadata.SEVOL)
    end
    for k, v in pairs(Sounds.PlaySong.Notes) do
        rl.SetSoundVolume(v, Parsed.Metadata.SEVOL)
    end
    --]]





    local Fonts = {
        PlaySong = {
            --Lyric = LoadFont('Nijiiro Font/Nijiiro font.otf', 32, nil, 0xFFFF)
            --Lyric = rl.GetFontDefault(),
            Lyric = LoadFontDynamic('Fonts/Font.otf', 32, nil, 0xFFFF)
        }
    }





































    --SONGSELECT
    --https://github.com/0auBSQ/OpenTaiko/blob/main/Test/System/SimpleStyle/SongSelectConfig.ini






    Textures.SongSelect.GenreBar = Resize(Textures.SongSelect.GenreBar)

    Textures.SongSelect.GenreBar = TextureMap.ReplaceWithTexture(Textures.SongSelect.GenreBar)

    Textures.SongSelect.GenreBar.sizex = Textures.SongSelect.GenreBar[0].width
    Textures.SongSelect.GenreBar.sizey = Textures.SongSelect.GenreBar[0].height
    Textures.SongSelect.GenreBar.sourcerect = rl.new('Rectangle', 0, 0, Textures.SongSelect.GenreBar.sizex, Textures.SongSelect.GenreBar.sizey)
    Textures.SongSelect.GenreBar.center = rl.new('Vector2', 0, 0)
    Textures.SongSelect.GenreBar.pr = {}
    --rl.new('Rectangle', 0, 0, Textures.SongSelect.GenreBar.sizex, Textures.SongSelect.GenreBar.sizey)
    Textures.SongSelect.GenreBar.p = {
        x = SkinConfig.SongSelect_Bar_X,
        y = SkinConfig.SongSelect_Bar_Y
    }
    local center = math.floor((SkinConfig.SongSelect_Bar_Count[1] + 1) / 2)
    for i = 1, #Textures.SongSelect.GenreBar.p.x do
        --print(i, middle, i - middle)
        Textures.SongSelect.GenreBar.pr[i - center] = rl.new('Rectangle', Textures.SongSelect.GenreBar.p.x[i] * OriginalConfig.ScreenWidth / skinresolution[1], Textures.SongSelect.GenreBar.p.y[i] * OriginalConfig.ScreenHeight / skinresolution[2], Textures.SongSelect.GenreBar.sizex, Textures.SongSelect.GenreBar.sizey)
    end







    Textures.SongSelect.GenreBackground = Resize(Textures.SongSelect.GenreBackground)

    Textures.SongSelect.GenreBackground = TextureMap.ReplaceWithTexture(Textures.SongSelect.GenreBackground)

    Textures.SongSelect.GenreBackground.sizex = Textures.SongSelect.GenreBackground[0].width
    Textures.SongSelect.GenreBackground.sizey = Textures.SongSelect.GenreBackground[0].height
    Textures.SongSelect.GenreBackground.sourcerect = rl.new('Rectangle', 0, 0, Textures.SongSelect.GenreBackground.sizex, Textures.SongSelect.GenreBackground.sizey)
    Textures.SongSelect.GenreBackground.center = rl.new('Vector2', 0, 0)
    Textures.SongSelect.GenreBackground.pr = rl.new('Rectangle', 0, 0, Textures.SongSelect.GenreBackground.sizex, Textures.SongSelect.GenreBackground.sizey)


















    --Display Sound Warning
    --Wait for start
    while not rl.WindowShouldClose() do
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawText([[
WARNING: Sound is very loud, so turn it all
the way down and work your way up.

Press Enter once you have done this.]], 0, Config.ScreenHeight / 3, fontsize, rl.RED)
        rl.EndDrawing()
        if rl.IsKeyPressed(rl.KEY_ENTER) then
            break
        end
    end



    --End of Taiko.Game init



























    













    --MISC GUI FUNCTIONS
    --ALL RAYGUI
    --[[
        rgl files should all be 1280x720
        code autogen should be hand audited

        TODO:
        RayGuiDifficulty
        Gui for editor
            New notes
            Logo
    ]]
    function Taiko.RayGuiTemplate()
        while not rl.WindowShouldClose() do
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)

            

            rl.EndDrawing()
        end
    end
    function Taiko.RayGuiDifficulty()

        local SelectedDifficulty = nil

        --TEMPORARY --TODO
        --choose difficulty
        SelectedDifficulty = string.lower(GuiInput('Type the difficulty and press enter\n\nOptions:\nEasy\nNormal\nHard\nOni\nUra') or '')
        
        while not Taiko.Data.CourseId[SelectedDifficulty] do
            SelectedDifficulty = string.lower(GuiInput('Try again. Type the difficulty and press enter\n\nOptions:\nEasy\nNormal\nHard\nOni\nUra') or '')
        end
        
        return SelectedDifficulty

        --[[
        while not rl.WindowShouldClose() do
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)

            

            rl.EndDrawing()
        end

        --]]
    end








































    --START OF ACTUAL GAME FUNCTIONS



    function Taiko.ParseBoxDef(source)
        --[[
            https://github.com/0auBSQ/OpenTaiko/blob/f47c4df82bc722eec0579ae52efa8dc00569d4df/Test/Documentation/Tja/NewCommands.md

            BOXCOLOR : (Hex) Color filter to apply on the box (Ensou song select screen).

            BGCOLOR : (Hex) Color filter to apply on the background (Ensou song select screen).

            BACKCOLOR : (Hex) Color of the text outline (Ensou song select screen).

            FRONTCOLOR : (Hex) Text color (Ensou song select screen).

            BGTYPE : (Int) Texture to use for the background (3_SongSelect\Genre_Background, Ensou song select screen, Default : Genre id or 0).

            BOXTYPE : (Int) Texture to use for the boxes (3_SongSelect\Bar_Genre and 3_SongSelect\Difficulty_Select\Difficulty_Back, Ensou song select screen, Default : Genre id or 0).

            BOXCHARA : (Int) Texture to use for the boxes' characters (3_SongSelect\Box_Chara, Ensou song select screen, Default : Genre id or 0).

            https://github.com/0auBSQ/OpenTaiko/blob/0e6870b955dabc5412042e48ffcbb84187677684/TJAPlayer3/Songs/CBoxDef.cs#L10

            https://github.com/0auBSQ/OpenTaiko/blob/0e6870b955dabc5412042e48ffcbb84187677684/TJAPlayer3/Songs/CSong%E7%AE%A1%E7%90%86.cs#L713
        ]]

        local out = {}

        --Start
        local lines = String.Split(source, '\n')
        for i = 1, #lines do
            local line = String.Trim(lines[i])

            if string.sub(line, 1, 1) == ';' then
                --Do nothing
            else
                --Check for comments
                local comment = string.find(line, ';')
                if comment then
                    line = string.sub(line, 1, comment - 1)
                end

                local match = {string.match(line, '#(.+):(.*)')}
                if match[1] then
                    out[match[1]] = match[2]
                end
            end
        end

        --Convert / Default

        out.TITLE = tostring(out.TITLE or '')
        out.GENRE = tostring(out.GENRE or '')
        out.FONTCOLOR = {HexToRGB(out.FONTCOLOR or '#000000')}
        out.FORECOLOR = {HexToRGB(out.FORECOLOR or '#000000')}
        out.BACKCOLOR = {HexToRGB(out.BACKCOLOR or '#000000')}
        out.BOXCOLOR = {HexToRGB(out.BOXCOLOR or '#FFFFFF')}
        out.BGCOLOR = {HexToRGB(out.BGCOLOR or '#FFFFFF')}

        --raylib colors
        local a = 255 --transparency
        out.FONTCOLOR = rl.new('Color', out.FONTCOLOR[1], out.FONTCOLOR[2], out.FONTCOLOR[3], a)
        out.FORECOLOR = rl.new('Color', out.FORECOLOR[1], out.FORECOLOR[2], out.FORECOLOR[3], a)
        out.BACKCOLOR = rl.new('Color', out.BACKCOLOR[1], out.BACKCOLOR[2], out.BACKCOLOR[3], a)
        out.BOXCOLOR = rl.new('Color', out.BOXCOLOR[1], out.BOXCOLOR[2], out.BOXCOLOR[3], a)
        out.BGCOLOR = rl.new('Color', out.BGCOLOR[1], out.BGCOLOR[2], out.BGCOLOR[3], a)

        out.BGTYPE = tonumber(out.BGTYPE) or 0
        out.BOXTYPE = tonumber(out.BOXTYPE) or 0
        out.BOXCHARA = tonumber(out.BOXCHARA) or 0

        local i = 1
        out.BOXEXPLANATION = {}
        for i = 0, 3 do
            local k = 'BOXEXPLANATION' .. tostring(i)
            if out[k] then
                out.BOXEXPLANATION[i] = out[k]
            end
        end


        return out
    end


    function Taiko.SongSelect()

        --Only stores displayed ones and a bit of cache
        local Display = {
            Text = {},
            Name = {},
            Config = {}, --parsed box.def (only root dir selection)
            Expanded = {}, --all nils except expanded dir, which has dir length
            --LoadedCheck = {}, --loaded once already?
            Path = {}, --path (parent folder)
            --Loaded = {}, --loaded files list in order (displayed) (completely seperate with other)
        }

        --Songlist
        local FilesList, PathTree = ScanSongs()

        local SongTree = BuildSongTree(PathTree)

        local Path = {} --Path table: empty is root
        local CurrentTree = SongTree --Cache

        local Selected = 1

        local SelectedConfig = nil

        --Background scrolling position
        local BackgroundPosition = 0 --in skinresolution, scaled on render
        local BackgroundScrollSpeed = -40 --in skinresolution, scaled on render / per second (deltatime)

        --local RenderDistance = 5

        --FastScroll
        --[[
            FastScroll:
            It it just like how you can hold a key and it'll start spamming it
        ]]
        local FastScrollTime = 0
        local FastScrollKey = nil
        local FastScrollAdd = nil
        local FastScrollIntervalMod = 0


        --Get File/Directory from Path (Songtree)

        local function GetTree(tree, path)
            local a = tree
            for i = 1, #path do
                a = a[path[i]]
            end
            return a
        end

        local function CopyPath(path)
            local out = {}
            for i = 1, #path do
                out[i] = path[i]
            end
            return out
        end

        local function DisplayPath(path)
            return table.concat(path, '/')
        end



        --Search
        local function Search(t, str)
            local out = {
                {}, --i (sorted)
                {}, --score (unsorted)
            }
            for i = 1, #t do
                out[1][i] = i
                out[2][i] = Compact.Search(t[i], str)
            end

            table.sort(out[1], function(a, b)
                return out[2][a] > out[2][b]
            end)
            return out
        end




        --Directory Expander

        local function ExpandDirectory(songtree, pos, path)

            --Iterator
            local spairs = function(a,b)local c={}for d in pairs(a)do c[#c+1]=d end;if b then table.sort(c,function(e,f)return b(a,e,f)end)else table.sort(c)end;local g=0;return function()g=g+1;if c[g]then return c[g],a[c[g]]end end end
            --Priority
            local function DirectoryPriority(t, a, b)
                if type(t[a]) == 'string' and type(t[b]) == 'string' then
                    return t[a] < t[b]
                elseif type(t[a]) == 'string' then
                    return false
                elseif type(t[b]) == 'string' then
                    return true
                else
                    return a < b
                end
            end

            local i = 0
            for k, v in spairs(songtree, DirectoryPriority) do
                --Display.Text[#Display.Text + 1] = k
                table.insert(Display.Text, pos + i, k)
                table.insert(Display.Name, pos + i, type(v) == 'string' and GetFileNameWithoutExt(v) or k)
                table.insert(Display.Path, pos + i, path) --just insert same parent object path

                --box.def
                if type(v) == 'table' then
                    local boxdefpath = Config.Paths.Songs .. DisplayPath(path) .. '/' .. k .. '/box.def'
                    --local boxdefpath = DisplayPath(path) .. '/' .. k .. '/box.def'
                    --print(boxdefpath)
                    if CheckFile(boxdefpath) then
                        local data = LoadFile(boxdefpath)
                        local parsed = Taiko.ParseBoxDef(data)
                        --Display.Config[pos - 1] = parsed --parent
                        table.insert(Display.Config, pos + i, parsed)
                        --require'ppp'(parsed)
                    else
                        --default
                        table.insert(Display.Config, pos + i,
                            Display.Config[pos - 1] --parent
                            or Taiko.ParseBoxDef('') --default
                        )
                    end
                else
                    --default
                    table.insert(Display.Config, pos + i,
                        Display.Config[pos - 1] --parent
                        or Taiko.ParseBoxDef('') --default
                    )
                end

                i = i + 1
                --TODO: Display.Config
            end
            local length = i

            --Add to all parent directories
            for i = 1, #path - 1 do
                local ep = path[i - 1]
                for i2 = pos - 1, 1, -1 do
                    if Display.Expanded[i2] then
                        local p = Display.Path[i2]
                        if p[#p] == ep and #p == i - 1 then
                            local check = true
                            for i = 1, #p do
                                if p[i] ~= path[i] then
                                    check = false
                                    break
                                end
                            end
                            if check then
                                --[[
                                print(i2)
                                require'ppp'(Display.Expanded)
                                --]]
                                Display.Expanded[i2] = Display.Expanded[i2] + length
                                break
                            end
                        end
                    end
                end
            end

            for k, v in pairs(Display.Expanded) do
                if k >= pos then
                    Display.Expanded[k + i] = v
                    Display.Expanded[k] = nil
                end
            end

            return i --length
        end


        local function CondenseDirectory(pos, length)
            --[[
            --NO: Just add on ExpandDirectory

            --Recalculate Display.Expanded
            --pos - 1 = Selected
            --modify length
            local i = Display.Expanded[pos - 1]
            local i2 = pos
            while true do
                if i == 0 then
                    break
                end

                if Display.Expanded[i2] then
                    length = length + Display.Expanded[i2]
                end
                i2 = i2 + 1

                i = i - 1
            end
            --]]

            --path = folder name
            local path = CopyPath(Display.Path[pos - 1])
            path[#path + 1] = Display.Name[pos - 1]
            --Add to all parent directories
            for i = 1, #path - 1 do
                local ep = path[i - 1]
                for i2 = pos - 1, 1, -1 do
                    if Display.Expanded[i2] then
                        local p = Display.Path[i2]
                        if p[#p] == ep and #p == i - 1 then
                            local check = true
                            for i = 1, #p do
                                if p[i] ~= path[i] then
                                    check = false
                                    break
                                end
                            end
                            if check then
                                --[[
                                print(i2)
                                require'ppp'(Display.Expanded)
                                --]]
                                Display.Expanded[i2] = Display.Expanded[i2] - length
                                break
                            end
                        end
                    end
                end
            end

            --Actual Work
            for k, v in pairs(Display.Expanded) do
                if k >= pos + length then
                    Display.Expanded[k - length] = v
                    Display.Expanded[k] = nil
                elseif k >= pos then
                    Display.Expanded[k] = nil
                end
            end

            for i2 = 1, length do
                table.remove(Display.Text, pos)
                table.remove(Display.Name, pos)
                table.remove(Display.Path, pos)
                table.remove(Display.Config, pos)
            end
        end

        local function ToggleDirectory(nextname, nextdir)
            --Folder
            if Display.Expanded[Selected] then
                --Expanded, Close
                --UnloadDirectory(Selected + 1, Display.Expanded[Selected])
                CondenseDirectory(Selected + 1, Display.Expanded[Selected])

                Display.Expanded[Selected] = nil

            else
                --Not Expanded, Open
                local path = CopyPath(Path)
                path[#path + 1] = nextname
                Display.Expanded[Selected] = ExpandDirectory(nextdir, Selected + 1, path)

            end
        end


        --[[
        local function DisplayPosToLoadedPos(displaypos)
            local pos
            for i = 1, #Display.Loaded do
                local a = Display.Loaded[i]
                if a > displaypos then
                    pos = i
                    break
                end
            end
            
            if pos then

            else
                if #Display.Loaded == 0 then
                    pos = 1
                else
                    pos = #Display.Loaded + 1
                end
            end
            return pos
        end

        local function UnloadDirectory(displaypos, length)
            local pos = DisplayPosToLoadedPos(displaypos - 1)

            for i2 = 1, length do
                table.remove(Display.Loaded, pos)
            end

            for k, v in pairs(Display.Loaded) do print(k, v)end
            for k, v in pairs(Display.Text) do print(k, v )end
        end

        local function LoadDirectory(displaypos, length)
            local pos = DisplayPosToLoadedPos(displaypos - 1)
            --print(pos, displaypos, length, #Display.Loaded)


            local i = pos
            local i3 = displaypos

            print(pos, displaypos, i, i3)
            for i2 = 1, length do
                table.insert(Display.Loaded, i, i3)
                i = i + 1
                i3 = i3 + 1
            end
            for i2 = pos + length, #Display.Loaded do
                Display.Loaded[i2] = i3
                i3 = i3 + 1
            end

            --
            for k, v in pairs(Display.Loaded) do print(k, v)end
            for k, v in pairs(Display.Text) do print(k, v )end
            --
        end
        --]]


        --Put root directory into Display
        local length = ExpandDirectory(SongTree, 1, CopyPath(Path))
        --LoadDirectory(1, length)




        --Main Loop
        while true do

            local deltatime = rl.GetFrameTime() --seconds

            --Make canvas
            rl.BeginDrawing()

            rl.ClearBackground(rl.RAYWHITE)


            --BACKGROUND
            if SelectedConfig then
                --LAZIEST SOLUTION EVER: Just render another one
                Textures.SongSelect.GenreBackground.pr.x = BackgroundPosition * scale[1] + skinresolution[1]
                rl.DrawTexturePro(Textures.SongSelect.GenreBackground[SelectedConfig.BGTYPE], Textures.SongSelect.GenreBackground.sourcerect, Textures.SongSelect.GenreBackground.pr, Textures.SongSelect.GenreBackground.center, 0, SelectedConfig.BGCOLOR)

                --Now render center (main)
                Textures.SongSelect.GenreBackground.pr.x = BackgroundPosition * scale[1]
                rl.DrawTexturePro(Textures.SongSelect.GenreBackground[SelectedConfig.BGTYPE], Textures.SongSelect.GenreBackground.sourcerect, Textures.SongSelect.GenreBackground.pr, Textures.SongSelect.GenreBackground.center, 0, SelectedConfig.BGCOLOR)

                BackgroundPosition = BackgroundPosition + BackgroundScrollSpeed * (deltatime)
                --times 2 added to make room for lag (NVM FILL SCREEN)
                if BackgroundPosition >= skinresolution[1] then
                    BackgroundPosition = BackgroundPosition - skinresolution[1]
                end
            end




            rl.DrawFPS(10, 10)

            --Center on Selected
            local i3 = 0
            --for i = Selected - RenderDistance, Selected + RenderDistance do
            for index, v in pairs(Textures.SongSelect.GenreBar.pr) do
                --i = Relative position (does not matter)
                local i = index + Selected
                --print(i)

                --i2 = Wrapped i for indexing SongTree
                --local i2 = #Display.Text - (i % #Display.Text)
                --local i2 = i > 0 and i % #Display.Text or #Display.Text - (-i % #Display.Text)
                local i2 = nil
                if i > #Display.Text then
                    i2 = i % #Display.Text
                    if i2 == 0 then
                        i2 = #Display.Text
                    end
                elseif i < 1 then
                    i2 = #Display.Text - (-i % #Display.Text)
                else
                    i2 = i
                end

                --print(i, i2, #Display.Text)


                --i3 = Order from the top (top = 1)
                i3 = i3 + 1

                --i4 = Display i (skips hidden)
                --local i4 = Display.Text[i2]
                --print(i4)

                --center bar special
                if i == Selected then
                    --[[
                        easy = 0,
                        normal = 1,
                        hard = 2,
                        oni = 3,
                        edit = 4,
                        tower = 5,
                        dan = 6,
                        ura = 4
                    ]]

                    --TEMPORARY --TODO
                    rl.DrawText('Press enter to play song', v.x, v.y + 80/720 * Config.ScreenHeight, fontsize, rl.BLACK)
                end


                --Draw box
                local config = Display.Config[i2]
                rl.DrawTexturePro(Textures.SongSelect.GenreBar[config.BOXTYPE], Textures.SongSelect.GenreBar.sourcerect, v, Textures.SongSelect.GenreBar.center, 0, config.BOXCOLOR)

                --Draw text
                --rl.DrawText(i == Selected and '> ' .. Display.Text[i2] or Display.Text[i2], 100, i3 * 50, fontsize, rl.BLACK)
                local str = Display.Text[i2]
                local sizex, sizey = GetTextSize(str, fontsize)
                rl.DrawText(str, v.x + v.width / 2 - sizex / 2, v.y + v.height / 2 - sizey / 2, fontsize, rl.BLACK)
            end


            rl.EndDrawing()

            --Handle other special input
            if rl.WindowShouldClose() then
                rl.CloseWindow()
                error() --Don't do more draw calls When closing window
                break
            end

            --L
            if IsKeyPressed(Config.Controls.SongSelect.L) then
                Selected = Selected - 1
            end
            --R
            if IsKeyPressed(Config.Controls.SongSelect.R) then
                Selected = Selected + 1
            end

            --FastScroll
            local key = Config.Controls.SongSelect.L
            if IsKeyDown(key) then
                if FastScrollKey ~= key then
                    --Reset timer and swap
                    FastScrollTime = 0
                    FastScrollKey = key
                    FastScrollAdd = -1
                end
                --Add time
                FastScrollTime = FastScrollTime + rl.GetFrameTime()
            elseif key == FastScrollKey then
                --Reset timer and swap
                FastScrollTime = 0
                FastScrollKey = nil
            end

            local key = Config.Controls.SongSelect.R
            if IsKeyDown(key) then
                if FastScrollKey ~= key then
                    --Reset timer and swap
                    FastScrollTime = 0
                    FastScrollKey = key
                    FastScrollAdd = 1
                end
                --Add time
                FastScrollTime = FastScrollTime + rl.GetFrameTime()
            elseif key == FastScrollKey then
                --Reset timer and swap
                FastScrollTime = 0
                FastScrollKey = nil
            end

            --print(FastScrollTime)
            if FastScrollTime - (FastScrollIntervalMod * Config.Controls.SongSelect.FastScrollInterval) >= Config.Controls.SongSelect.FastScrollTime then
                Selected = Selected + FastScrollAdd
                FastScrollIntervalMod = FastScrollIntervalMod + 1
            else
                --Reset occured probably
                FastScrollIntervalMod = 0
            end

            --Wrap
            --[[
            --can only handle 1 outofbounds
            if Selected > #Display.Text then
                Selected = Selected - #Display.Text
            elseif Selected < 1 then
                Selected = #Display.Text - Selected
            end
            --]]
            if Selected > #Display.Text then
                Selected = Selected % #Display.Text
                if Selected == 0 then
                    Selected = #Display.Text
                end
            elseif Selected < 1 then
                Selected = #Display.Text - (-Selected % #Display.Text)
            else
                --Selected = Selected
            end

            --Update Path
            --Path = Display.Path[Display.Loaded[Selected]]
            Path = Display.Path[Selected]
            rl.DrawText('Path: ' .. DisplayPath(Path), 100, 0, fontsize, rl.BLACK)
            SelectedConfig = Display.Config[Selected]


            --DEBUG
            --Parse all files
            if rl.IsKeyPressed(rl.KEY_P) then

















                
--[[
    Statistics.lua

    Analyze the results of datasets.
]]




Statistics = {}


function Statistics.CalculateAllSet(Set)
    local Stats = {
        Length = #Set, --N
        Sum = 0, --Total
        Minimum = nil,
        Maximum = nil,
        Mean = nil, --Average
        Median = nil, --REQUIRES SORTED ARRAY
        ModeOccurence = {},
        Mode = nil,

        DeviationSquaredSum = 0,
        Variance = nil,
        StandardDeviation = nil,

        --Aliases
        N = nil,
        Total = nil,
        Average = nil,
    }

    --First iteration
    for i = 1, #Set do
        local Element = Set[i]
        Stats.Sum = Stats.Sum + Element
        if (Stats.Minimum and Element < Stats.Minimum) or (not Stats.Minimum) then
            Stats.Minimum = Element
        end
        if (Stats.Maximum and Element > Stats.Maximum) or (not Stats.Maximum) then
            Stats.Maximum = Element
        end
        Stats.ModeOccurence[Element] = Stats.ModeOccurence[Element] and Stats.ModeOccurence[Element] + 1 or 1
    end

    Stats.Mean = Stats.Sum / Stats.Length

    --Second iteration
    for i = 1, #Set do
        local Element = Set[i]
        Stats.DeviationSquaredSum = Stats.DeviationSquaredSum + (Element - Stats.Mean) ^ 2
    end

    Stats.Variance = Stats.DeviationSquaredSum / Stats.Length
    Stats.StandardDeviation = math.sqrt(Stats.Variance)

    return Stats
end

function Statistics.CalculateAllPoints(Points)
    
end

function Statistics.List(Stats)
    local out = {}

    for k, v in pairs(Stats) do
        out[#out + 1] = k
        out[#out + 1] = ': '
        out[#out + 1] = tostring(v)
        out[#out + 1] = '\n'
    end

    return table.concat(out)
end




--return Statistics














                local out = {}
                local times = {} --Parse times
                local function a(t)
                    for k, v in pairs(t) do
                        if type(v) == 'table' then
                            a(v)
                        else
                            --print(v)
                            local starttime = os.clock()
                            local Parsed, Error = Taiko.ParseTJAFile(v)
                            local endtime = os.clock()
                            times[#times + 1] = (endtime - starttime) * 1000
                            print(times[#times])
                            if Parsed then
                                --return Parsed
                                --Good!
                            else
                                out[#out + 1] = v
                                out[#out + 1] = ': '
                                out[#out + 1] = Error
                                out[#out + 1] = '\n\n'
                                --print(v, Error)
                                --Bad!
                            end
                        end
                    end
                end
                a(SongTree)
                io.open('taikov34_parseerror.txt', 'w+'):write(table.concat(out))

                print(Statistics.List(Statistics.CalculateAllSet(times)))
            end





            --Select
            if IsKeyPressed(Config.Controls.SongSelect.Select) then
                --Update CurrentTree
                CurrentTree = GetTree(SongTree, Path)
                --local Selected = Display.Loaded[Selected]

                --if Display.Name[Selected] then
                local nextname = Display.Name[Selected]
                local nextdir = CurrentTree[nextname]
                if type(nextdir) == 'string' then
                    --File
                    --print(nextdir)

                    


                    --Play Song!
                    local Parsed = Taiko.Parse(nextdir)
                    if Parsed then
                        local SelectedDifficulty = Taiko.RayGuiDifficulty()
                        local ParsedData = Taiko.GetDifficulty(Parsed, SelectedDifficulty)
                        --[[
                        --Load Parsed from file
                        local f = io.open('Taikov34_out.lua', 'rb')
                        local str = f:read('*all')
                        f:close()

                        local data = PersistentParsed.Load(str)

                        local ParsedData = data
                        --]]

                        Taiko.Play(ParsedData, nextdir, SelectedDifficulty)
                    end
                else
                    --[[
                    --Folder
                    if Display.Expanded[Selected] then
                        --Expanded, Close
                        --UnloadDirectory(Selected + 1, Display.Expanded[Selected])
                        CondenseDirectory(Selected + 1, Display.Expanded[Selected])

                        Display.Expanded[Selected] = nil
                    else
                        --Not Expanded, Open
                        
                        local path = CopyPath(Path)
                        path[#path + 1] = nextname
                        Display.Expanded[Selected] = ExpandDirectory(nextdir, Selected + 1, path)

                    end
                    --]]
                    ToggleDirectory(nextname, nextdir)


                    CurrentTree = nextdir
                end
            end

            if IsKeyPressed(Config.Controls.SongSelect.Search.Init) then
                --Build fileslist from tree
                local fileslist = {}
                local pathslist = {}
                local tree = nil

                if IsKeyDown(Config.Controls.SongSelect.Search.All) then
                    --All
                    tree = SongTree
                    Path = {}
                    for i = 1, #Display.Path do
                        if #Display.Path[i] == #Path then
                            Selected = i
                            break
                        end
                    end
                else
                    --tree = GetTree(SongTree, Path)
                    CurrentTree = GetTree(SongTree, Path)
                    tree = CurrentTree
                end

                --[[
                    --DIRTY
                    TODO: Remove table creation for paths
                ]]
                local function TreeToList(tree, fileslist, pathslist, path)
                    for k, v in pairs(tree) do
                        if type(v) == 'table' then
                            local a = CopyPath(path)
                            a[#a + 1] = k
                            TreeToList(v, fileslist, pathslist, a)
                        else
                            fileslist[#fileslist + 1] = k
                            pathslist[#pathslist + 1] = path
                        end
                    end
                    return fileslist, pathslist
                end

                fileslist, pathslist = TreeToList(tree, fileslist, pathslist, {})


                --Start
                local escape = nil
                local searchn = 10
                local results = nil
                local max = nil
                local selected = 1

                local lastselected = 1
                local updatecursor = false

                local str = 'Search:\n'
                local out = {}
                local outs = ''
                local lastresults = '\n'
                local lastresultscursor = '\n'
                local displaytext = str
                while true do
                    rl.BeginDrawing()
                    rl.ClearBackground(rl.RAYWHITE)
                    rl.DrawText(displaytext, 0, 0, fontsize, rl.BLACK)
                    rl.EndDrawing()
        
                    while true do
                        local c = rl.GetCharPressed()
                        if c == 0 then
                            break
                        else
                            out[#out + 1] = c
                            --Update display
                            outs = utf8Encode(out)
                            displaytext = str .. outs .. lastresultscursor
                            max = nil
                        end
                    end

        
                    --Remember, GetCharPressed doesn't detect special keys
                    if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
                        out[#out] = nil
                        --Update display
                        outs = utf8Encode(out)
                        displaytext = str .. outs .. lastresultscursor
                        max = nil
                    end
                    
                    if IsKeyPressed(Config.Controls.SongSelect.Search.U) then
                        selected = selected - 1
                    end
                    if IsKeyPressed(Config.Controls.SongSelect.Search.D) then
                        selected = selected + 1
                    end
                    

                    if max == nil and #out > 0 then
                        results = Search(fileslist, outs)

                        --max
                        local temp = {'\n'}
                        max = nil
                        for i = 1, searchn do
                            local index = results[1][i]
                            if not results[2][index] or results[2][index] == -math.huge then
                                max = i - 1
                                break
                            else
                                --good, build lastresults
                                temp[#temp + 1] = tostring(i)
                                temp[#temp + 1] = '. '
                                temp[#temp + 1] = fileslist[index]
                                temp[#temp + 1] = '\n'
                            end
                        end
                        max = max or searchn

                        lastresults = table.concat(temp)
                        --displaytext = str .. outs .. lastresults
                        updatecursor = true
                    end

                    if max then
                        selected = ClipN(selected, 1, max)
                    end

                    if selected ~= lastselected or updatecursor then
                        lastresultscursor = string.gsub(lastresults, '\n' .. selected, '\n>')
                        displaytext = str .. outs .. lastresultscursor
                        updatecursor = false
                    end
                    lastselected = selected


                    if IsKeyPressed(Config.Controls.SongSelect.Search.Select) and max and max ~= 0 then
                        break
                    end

                    if IsKeyPressed(Config.Controls.SongSelect.Search.Escape) then
                        escape = true
                        break
                    end

                    if rl.WindowShouldClose() then
                        rl.CloseWindow()
                        error() --Don't do more draw calls When closing window
                    end
                end

                if not escape then
                    local index = results[1][selected]
                    local dir = CopyPath(pathslist[index])
                    local file = fileslist[index]
                    dir[#dir + 1] = file

                    --print(DisplayPath(dir))
                    

                    CurrentTree = tree
                    Path = CopyPath(Path)


                    --use tree from start
                    for i = 1, #dir do
                        --find folder from select, and expand

                        --find Selected
                        local nextname = nil
                        local nextdir = nil
                        for i2 = 1, #Display.Text do

                            --print(Display.Name[i2], dir[i])
                            if Display.Name[i2] == dir[i] and #Path == #Display.Path[i2] then
                                local pathsame = true
                                for i3 = 1, #Path do
                                    if Path[i3] ~= Display.Path[i2][i3] then
                                        pathsame = false
                                        break
                                    end
                                end

                                if pathsame then
                                    nextname = Display.Name[i2]
                                    nextdir = CurrentTree[nextname]
                                    if type(nextdir) == 'string' then
                                        --File
                                        if i == #dir then
                                            Selected = i2
                                            break
                                        end
                                    else
                                        --Folder
                                        Selected = i2
                                        break
                                    end
                                end
                            end
                        end

                        if i == #dir then
                            break
                        end


                        --print(nextname, nextdir)
                        if not Display.Expanded[Selected] then
                            ToggleDirectory(nextname, nextdir)
                        end
                        CurrentTree = nextdir
                        Path[#Path + 1] = nextname
                    end
                end

                
                --[[
                out = utf8Encode(out)
                return out ~= '' and out or nil
                --]]

            end



        end
    end






























            --popanim
--[[
f	transparency
0	12.5*8
1	12.5*7
2	12.5*6
3	12.5*5
4	12.5*4
5	12.5*3
6	12.5*2
7	12.5*1
8	12.5*0
        ]]
        local popanim = {
            startms = nil,
            framen = CountAnimFrames(Textures.PlaySong.Balloons.Anim),
            anim = {
                [0] = 0.125*8,
                [1] = 0.125*7,
                [2] = 0.125*6,
                [3] = 0.125*5,
                [4] = 0.125*4,
                [5] = 0.125*3,
                [6] = 0.125*2,
                [7] = 0.125*1,
                [8] = 0.125*0,
            },
            color = rl.new('Color', 255, 255, 255, 255)
        }




        --gaugeclearanim
--[[
(white -> yellow -> white)
r, g = 1, 1
        ]]
        local gaugeclearanim = {
            startms = nil,
            framen = 31,
            anim = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 0,
                [5] = 0,
                [6] = 0,
                [7] = 0,
                [8] = 0,
                [9] = 0,
                [10] = 0,
                [11] = 0,
                [12] = 0,
                [13] = 0,
                [14] = 0,
                [15] = 0,
                [16] = 0,
                [17] = 0,
                [18] = 0,
                [19] = 0,
                [20] = 0,
                [21] = 0,
                [22] = 0,
                [23] = 0.2,
                [24] = 0.4,
                [25] = 0.6,
                [26] = 0.8,
                [27] = 1,
                [28] = 0.8,
                [29] = 0.6,
                [30] = 0.4,
                [31] = 0.2,
            },
            color = rl.new('Color', 255, 255, 255, 255)
        }

        local gaugeoverflowanim = {
            startms = nil,
            framen = 12,
            anim = Textures.PlaySong.Gauges.Meter.rainbow.Anim
        }







        --notehitlane
--[[
f	transparency
0	1
1	1
2	1
3	0.75
4	0.5
5	0.25
        ]]
        local notehitlane = {
            anim = {
                [0] = 1,
                [1] = 1,
                [2] = 1,
                [3] = 0.75,
                [4] = 0.5,
                [5] = 0.25,
            },
            [1] = {
                startms = nil,
                color = rl.new('Color', 255, 255, 255, 255)
            },
            [2] = {
                startms = nil,
                color = rl.new('Color', 255, 255, 255, 255)
            }
        }


        --judgeanim
--[[
f	transparency    p
0	1
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20  1
21  1
22  0.75
23  0.5
24  0.25
25  0
        ]]
        local judgeanim = {
            animp = {
                --Estimated using eye
                [0] = 98,
                [1] = 92,
                [2] = 88,
                [3] = 84,
                [4] = 80,
                [5] = 77,
                [6] = 75,
                [7] = 75,
                [8] = 75,
                [9] = 75,
                [10] = 75,
                [11] = 75,
                [12] = 75,
                [13] = 75,
                [14] = 75,
                [15] = 75,
                [16] = 75,
                [17] = 75,
                [18] = 75,
                [19] = 75,
                [20] = 75,
                [21] = 75,
                [22] = 75,
                [23] = 75,
                [24] = 75,
                [25] = 75,
            },
            animt = {
                [0] = 1,
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
                [7] = 1,
                [8] = 1,
                [9] = 1,
                [10] = 1,
                [11] = 1,
                [12] = 1,
                [13] = 1,
                [14] = 1,
                [15] = 1,
                [16] = 1,
                [17] = 1,
                [18] = 1,
                [19] = 1,
                [20] = 1,
                [21] = 1,
                [22] = 0.75,
                [23] = 0.5,
                [24] = 0.25,
                [25] = 0,
            },
            startms = {
                --startms
            },
            judge = {
                --judge
            },
            color = rl.new('Color', 255, 255, 255, 255)
        }















        --[[
f	transparency
0	100
1	100
2	100
3	100
4	100
5	75
6	50
7	25
8	0

sides
left 0-60 (0-Textures.PlaySong.Backgrounds.Taiko.sizex/2)
right 60-120 (Textures.PlaySong.Backgrounds.Taiko.sizex/2-120)
]]

        local taikoanim = {
            anim = {
                [0] = 0.125*8,
                [1] = 0.125*8,
                [2] = 0.125*8,
                [3] = 0.125*8,
                [4] = 0.125*8,
                [5] = 0.125*6,
                [6] = 0.125*4,
                [7] = 0.125*2,
                [8] = 0.125*0,
            },
            --left
            [1] = {
                --don
                [1] = {
                    startms = nil,
                    color = rl.new('Color', 255, 255, 255, 255),
                },
                --ka
                [2] = {
                    startms = nil,
                    color = rl.new('Color', 255, 255, 255, 255)
                },
                sourcerect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Backgrounds.Taiko.sizex / 2, Textures.PlaySong.Backgrounds.Taiko.sizey),
                opr = rl.new('Rectangle', Textures.PlaySong.Backgrounds.Taiko.pr.x, Textures.PlaySong.Backgrounds.Taiko.pr.y, Textures.PlaySong.Backgrounds.Taiko.sizex / 2, Textures.PlaySong.Backgrounds.Taiko.sizey),
                pr = rl.new('Rectangle', 0, 0, 0, 0),
                center = rl.new('Vector2', 0, 0)
            },
            --right
            [2] = {
                --don
                [1] = {
                    startms = nil,
                    color = rl.new('Color', 255, 255, 255, 255),
                },
                --ka
                [2] = {
                    startms = nil,
                    color = rl.new('Color', 255, 255, 255, 255)
                },
                sourcerect = rl.new('Rectangle', Textures.PlaySong.Backgrounds.Taiko.sizex / 2, 0, Textures.PlaySong.Backgrounds.Taiko.sizex / 2, Textures.PlaySong.Backgrounds.Taiko.sizey),
                opr = rl.new('Rectangle', Textures.PlaySong.Backgrounds.Taiko.pr.x + Textures.PlaySong.Backgrounds.Taiko.sizex / 2, Textures.PlaySong.Backgrounds.Taiko.pr.y, Textures.PlaySong.Backgrounds.Taiko.sizex / 2, Textures.PlaySong.Backgrounds.Taiko.sizey),
                pr = rl.new('Rectangle', 0, 0, 0, 0),
                center = rl.new('Vector2', 0, 0)
            }
        }




    
    function Taiko.PlaySong(Parsed, OptionalConfig)
        -- local profiler = require'profiler'
        -- profiler.start()
        SetupResizeAll()




        --INIT
        local oldscale = {scale[1], scale[2]}
        ResizeAll(Textures, 1 / scale[1], 1 / scale[2])







        --OPTIONALCONFIG
        OptionalConfig = OptionalConfig or {}
        local oneveryframe = OptionalConfig.oneveryframe --Called RIGHT before rl.EndDrawing(): oneveryframe(ms)
        local oneveryhit = OptionalConfig.oneveryhit --Called in hit function: oneveryhit(ms, v, side, nearestnote)











        --RESULTS
        local Results = {} --TODO









        --ASSETS


        --SONG
        local playmusic = Parsed.Metadata.SONG --Is the song valid?

        --rl.InitAudioDevice() --initted earlier
        local song
        local forceresync = false --force resync on next frame
        if playmusic then
            if CheckFile(Parsed.Metadata.SONG) then
                song = LoadSong(Parsed.Metadata.SONG)
                local SONGVOL = Parsed.Metadata.SONGVOL * Config.Settings.PlaySong.SONGVOLMultiplier
                rl.SetMusicVolume(song, SONGVOL)
            else
                playmusic = false
            end
        end



        --SOUDEFFECTS
        local SEVOL = Parsed.Metadata.SEVOL * Config.Settings.PlaySong.SEVOLMultiplier
        for k, v in pairs(Sounds.PlaySong.Combo) do
            rl.SetSoundVolume(v, SEVOL)
        end
        for k, v in pairs(Sounds.PlaySong.Notes) do
            rl.SetSoundVolume(v, SEVOL)
        end



















        --SETTINGS
        local auto = true --Autoplay
        local autohitnotes = {
            [1] = 1,
            [2] = 2,
            [3] = 1,
            [4] = 2,
        }
        --[[
            About AutoPlay:
            Autoplay now sets the status as good, instead of just emulating the key press. This forces every note hit to be good. However, the timings may not be correct if you are below 60 fps.
        ]]


        --local autoemu = false --Emulate key on auto

        local notespeedmul = 1 --Note Speed multiplier
        local songspeedmul = 1 --Actual speed multiplier

        --local stopsong = true --Stop song enabled?
        local stopsong = Parsed.Metadata.STOPSONG
        local jposscroll = true --If it exists
        local bpmchange = true --If it exists
        local lyric = true --If it exists
        local sudden = true --If it exists

        if Parsed.Flag.PARSER_FORCE_OLD_BPMCHANGE then
            bpmchange = false
        end
















        --PLAYSONG CONFIG

        --Everything will be in terms of screenx and screeny
        --original tracklength: 40 noteradius (160)
        local tracklength = OriginalConfig.ScreenWidth --2400 max
        --raylib use only




        local bufferlength = 1/16 * OriginalConfig.ScreenWidth
        local unloadbuffer = 5/16 * OriginalConfig.ScreenWidth --NOT added to bufferlength
        local endmsadd = 1000 --Added to last note (ms)
        local noteradius = 72/2/1280 * OriginalConfig.ScreenWidth --Radius of normal (small) notes
        local y = 0 * OriginalConfig.ScreenWidth
        local target = {414/1280 * OriginalConfig.ScreenWidth, -(257/720 - 1/2) * OriginalConfig.ScreenHeight} --(src: taiko-web)
        
        

        if Parsed.Flag.PARSER_FORCE_OLD_TARGET then
            --target = {3/40 * Config.ScreenWidth, 0} --(src: taiko-web)
            target = {1/4 * OriginalConfig.ScreenWidth, 0}
        end

        --REMEMBER, ALL NOTES ARE RELATIVE TO TARGET

        --[[
        local statuslength = 200 --Status length (good/ok/bad) (ms)
        local statusanimationlength = statuslength / 4 --Status animation length (ms) --FIX
        local statusanimationmove = 1/40 * Config.ScreenWidth --Status animation move
        local flashlength = 20 --Flash length (normal/big) (good/ok/bad) (ms)



        --colors: black, red, green, yellow, blue, magenta, cyan, white
        local renderconfig = {
            [1] = {color = 'red'},
            [2] = {color = 'blue'},
            [3] = {color = 'red'},
            [4] = {color = 'blue'},
            [5] = {color = 'yellow'},
            [6] = {color = 'yellow'},
            [7] = {color = 'cyan'},
        }
        --]]


        local trackend = trackstart + tracklength


        local screenrect = {0, -OriginalConfig.ScreenHeight / 2, OriginalConfig.ScreenWidth, OriginalConfig.ScreenHeight / 2}
        --Only factors in screenrect
        -- local loadrect = {screenrect[1] - bufferlength, screenrect[2] - bufferlength, screenrect[3] + bufferlength, screenrect[4] + bufferlength}
        -- local unloadrect = {screenrect[1] - unloadbuffer, screenrect[2] - unloadbuffer, screenrect[3] + unloadbuffer, screenrect[4] + unloadbuffer}
        --Factors in jposscroll (if the target is within screenrect, everything will be correct)
        local loadrect = {-OriginalConfig.ScreenWidth - bufferlength, -OriginalConfig.ScreenHeight - bufferlength, OriginalConfig.ScreenWidth + bufferlength, OriginalConfig.ScreenHeight + bufferlength}
        local unloadrect = {loadrect[1] - unloadbuffer, loadrect[2] - unloadbuffer, loadrect[3] + unloadbuffer, loadrect[4] + unloadbuffer}

















        









        --FUNCTIONS

        local function Round(x)
            --nearest integer
            return math.floor(x + 0.5)
        end
        --From Pixelsv20.lua
        local function NormalizeAngle(deg)
            return deg - (math.floor(deg / 360) * 360)
        end


        --Calculate Functions
        local function IsNote(note)
            return (note.data == 'note') or (note.data == 'event' and note.event == 'barline')
        end
        local function IsPointInRectangle(x, y, x1, y1, x2, y2)
            --print(x, y, x1, y1, x2, y2)
            --[[
                assumptions
                x1 < x2
                y1 < y2
            ]]
            return x1 <= x and x <= x2 and y1 <= y and y <= y2
        end
        local function RayIntersectsRectangle(x, y, sx, sy, x1, y1, x2, y2)
            --[[
                assumptions
                x1 < x2
                y1 < y2
            ]]
            x1, y1, x2, y2 = x1 - x, y1 - y, x2 - x, y2 - y
            --now we are at origin!
        
        
            --[[
                just plug in!
        
                y=mx
                x=y/m
            ]]
        
            local m = sy / sx
        
        
            
            if sy < 0 then
                --d (y = y1)
                local x3, y3 = y1 / m, y1
                if x1 <= x3 and x3 <= x2 then
                    return x3, y3
                end
            else
                --u (y = y2)
                local x3, y3 = y2 / m, y2
                if x1 <= x3 and x3 <= x2 then
                    return x3, y3
                end
            end
        
            
            if sx < 0 then
                --l (x = x1)
                local x3, y3 = x1, x1 * m
                if y1 <= y3 and y3 <= y2 then
                    return x3, y3
                end
            else
                --r (x = x2)
                local x3, y3 = x2, x2 * m
                if y1 <= y3 and y3 <= y2 then
                    return x3, y3
                end
            end
        
            return nil
        end
        local function IsLineOutsideRectangle(x1, y1, x2, y2, rx1, ry1, rx2, ry2)
            --[[
                assumptions
                x1 < x2
                y1 < y2
                rx1 < rx2
                ry1 < ry2
            ]]


            --If all points are in rect
            --IsPointInRectangle()
            if (rx1 <= x1 and x1 <= rx2 and ry1 <= y1 and y1 <= ry2) and (rx1 <= x2 and x2 <= rx2 and ry1 <= y2 and y2 <= ry2) then
                return false
            end



            --Find equation for line
            --y = mx + b

            --m = dy / dx
            local m = (y2 - y1) / (x2 - x1)

            --b = y - mx
            local b = y1 - m * x1

            

            if (x2 - x1) == 0 then
                --Cases: 1 outside 1 in x2, both outside
                if (not (rx1 <= x1 and x1 <= rx2 and ry1 <= y1 and y1 <= ry2)) and (not (rx1 <= x2 and x2 <= rx2 and ry1 <= y2 and y2 <= ry2)) then
                    --both outside
                    return true
                else
                    return false
                end
            else
                --Find intersection y for x
                --y = mx + b
                local iy1, iy2 = m * rx1 + b, m * rx2 + b
                if (x1 <= rx1 and rx1 <= x2) and (ry1 <= iy1 and iy1 <= ry2) then
                    return false
                end
                if (x1 <= rx2 and rx2 <= x2) and (ry1 <= iy2 and iy2 <= ry2) then
                    return false
                end
            end


            if (y2 - y1) == 0 then
                --Cases: 1 outside 1 in x2, both outside
                if (not (rx1 <= x1 and x1 <= rx2 and ry1 <= y1 and y1 <= ry2)) and (not (rx1 <= x2 and x2 <= rx2 and ry1 <= y2 and y2 <= ry2)) then
                    --both outside
                    return true
                else
                    return false
                end
            else
                --Find intersection x for y
                --x = (y - b) / m
                local ix1, ix2 = (ry1 - b) / m, (ry2 - b) / m
                if (y1 <= ry1 and ry1 <= y2) and (rx1 <= ix1 and ix1 <= rx2) then
                    return false
                end
                if (y1 <= ry2 and ry2 <= y2) and (rx1 <= ix2 and ix2 <= rx2) then
                    return false
                end
            end

            return true
        end



        local function CalculatePosition(note, ms, target)
            return target[1] - (note.speed[1] * (note.ms - ms - note.delay)), target[2] - (note.speed[2] * (note.ms - ms - note.delay)) --FlipY
        end
        Taiko.CalculatePosition = CalculatePosition

        local function CalculateLoadMs(note, ms)
            if note.speed[1] == 0 and note.speed[2] == 0 then
                return -math.huge
            end
            --x, y
            -- local x, y = RayIntersectsRectangle(target[1], target[2], -note.scrollx, -note.scrolly, loadrect[1], loadrect[2], loadrect[3], loadrect[4])
            -- return ms - (x ~= 0 and x / -note.speed[1] or y / -note.speed[2])

            --How it works: Split screen into 4 sections, with 4 lines from each corner to the target
            --speed = pixels/ms
            --TODO: Have a cache!!!
            --Remember, y is flipped (up = minus, down = plus)
            --TODO: Cache this, update every time JPOSSCROLL
            local dl = (target[2] - loadrect[2]) / (target[1] - loadrect[1])
            local dr = (target[2] - loadrect[2]) / (target[1] - loadrect[3])
            local ul = (target[2] - loadrect[4]) / (target[1] - loadrect[1])
            local ur = (target[2] - loadrect[4]) / (target[1] - loadrect[3])
            -- print(ul, ur, dl, dr)
            -- print(target[1], target[2])error()
            --TODO: Cache this forever in note
            local m = note.speed[2] / note.speed[1]
            local mst = nil --ms it takes for note to get from target to loading rect
            if -note.speed[1] ~= 0 and ((dr <= m and m <= ur) or (dl <= m and m <= ul)) then
                if -note.speed[1] > 0 then
                    --r
                    mst = (loadrect[3] - target[1]) / -note.speed[1]
                else
                    --l
                    mst = (target[1] - loadrect[1]) / note.speed[1]
                end
            else
                if -note.speed[2] > 0 then
                    --u
                    mst = (target[2] - loadrect[2]) / -note.speed[2]
                else
                    --d
                    mst = (loadrect[4] - target[2]) / note.speed[2]
                end
            end

            return ms - mst
        end

        local function LineIntersectPoint(pms, ps1, ps2, qms, qs1, qs2, x, y)
            --[[
                point slope form with p1, p2, q1, q2
                p1 = (t - pms) * ps1
                p2 = (t - pms) * ps2
                q1 = (t - qms) * qs1
                q2 = (t - qms) * qs2

                y*p1-y*q1+p2*q1-x*p2-x*q2+p1*q2=0
                y * ps1 * (t - pms) - y * qs1 * (t - qms) + ps2 * qs1 * (t - pms) * (t - qms) - x * ps2 * (t - pms) + x * qs2 * (t - qms) - ps1 * qs2 * (t - pms) * (t - qms) = 0

                y*ps1*t - y*qs1*t + ps2*qs1*t^2 - ps2*qs1*t*pms - ps2*qs1*t*qms - x*ps2*t + x*qs2*t - ps1*qs2*t^2 + ps1*qs2*t*pms + ps1*qs2*t*qms - y*ps1*pms + y*qs1*qms + ps2*qs1*pms*qms + x*ps2*pms - x*qs2*qms - ps1*qs2*pms*qms = 0

                (ps2*qs1 - ps1*qs2)t^2 + (y*ps1 - y*qs1 - ps2*qs1*pms - ps2*qs1*qms - x*ps2 + x*qs2 + ps1*qs2*pms + ps1*qs2*qms)t + (- y*ps1*pms + y*qs1*qms + ps2*qs1*pms*qms + x*ps2*pms - x*qs2*qms - ps1*qs2*pms*qms) = 0

                now quadratic formula!
            --]]
            local a = ps2*qs1 - ps1*qs2
            local b = y*ps1 - y*qs1 - ps2*qs1*pms - ps2*qs1*qms - x*ps2 + x*qs2 + ps1*qs2*pms + ps1*qs2*qms
            local c = - y*ps1*pms + y*qs1*qms + ps2*qs1*pms*qms + x*ps2*pms - x*qs2*qms - ps1*qs2*pms*qms
            local t1 = (-b + math.sqrt(b ^ 2 - 4 * a * c)) / (2 * a)
            local t2 = (-b - math.sqrt(b ^ 2 - 4 * a * c)) / (2 * a)
            print(t1, t2)
        end

        --WARNING: CPU Heavy, estimating
        --TODO: FIX LOADMS FOR DRUMROLLS (also fix for normal, esp when jposscroll)
        local function CalculateLoadMsDrumroll(note, loadms)
            --if it is a simple drumroll (both scrolls are the same)
            if note.startnote.drumrollbend == nil or #note.startnote.drumrollbend == 0 then
                if note.scrollx == note.startnote.scrollx and note.scrolly == note.startnote.scrolly then
                    note.drumrollsimple = true
                    return CalculateLoadMs(note.startnote, note.startnote.ms)
                end

                --if it is a linear drumroll (both scrolls have the same slope)
                if note.startnote.scrolly / note.startnote.scrollx == note.scrolly / note.scrollx and (note.startnote.scrolly >= 0 and note.scrolly >= 0 or note.startnote.scrolly < 0 and note.scrolly < 0) then
                    note.drumrollsimple = true
                    return CalculateLoadMs(note.startnote, note.startnote.ms)
                end
            end

            --[[
                TODO: Find out why things like
                #SCROLL 155
                50,
                #SCROLL 1
                8
                bring sim to a screeching halt (60fps -> 13fps after a while)
                prob the drawing of the drumroll body, not being clamped
            ]]


            -- LineIntersectPoint(note.ms, -note.speed[1], -note.speed[2], note.startnote.ms, -note.startnote.speed[1], -note.startnote.speed[2], loadrect[3] - target[1], loadrect[4] - target[2])

            local increment = -10
            local ms = loadms
            while true do
                note.p[1], note.p[2] = note.CalculatePosition(note, ms, target)
                note.p[1], note.p[2] = note.p[1] * xmul, note.p[2] * ymul
                note.startnote.p[1], note.startnote.p[2] = note.CalculatePosition(note.startnote, ms, target)
                note.startnote.p[1], note.startnote.p[2] = note.startnote.p[1] * xmul, note.startnote.p[2] * ymul
                if IsLineOutsideRectangle(
                    note.p[1] < note.startnote.p[1] and note.p[1] or note.startnote.p[2],
                    note.p[2] < note.startnote.p[2] and note.p[2] or note.startnote.p[2],
                    note.p[1] < note.startnote.p[1] and note.startnote.p[1] or note.p[2],
                    note.p[2] < note.startnote.p[2] and note.startnote.p[2] or note.p[2],
                    loadrect[1], loadrect[2], loadrect[3], loadrect[4]
                ) then
                    return ms
                else
                    ms = ms + increment
                end
                --[[
                print(note.p[1], note.p[2])
                print(note.startnote.p[1], note.startnote.p[2])
                print(loadrect[1], loadrect[2], loadrect[3], loadrect[4])
                --]]

                --last case break
                if loadms - ms > 1000 then
                    return loadms
                end
            end
        end
        --[[
        local function CalculateLoadPosition(note, lms)
            return (note.ms - lms) * note.speed + target
        end
        --]]


























        --Do main precalculations





        local notetable = Taiko.GetAllNotes(Parsed.Data)












        --METADATA
        local startms = Parsed.Metadata.OFFSET

        --https://github.com/bui/taiko-web/blob/ba1a6ab3068af8d5f8d3c5e81380957493ebf86b/public/src/js/gamerules.js
        --local framems = 1000 / (framerate or 60) --don't use framerate
        local framems = 1000 / 60
        --local timing = Parsed.Metadata.TIMING(framems / songspeedmul)
        local timing = Taiko.Data.Timing.Level[Parsed.Metadata.TIMING]












        --Precalculate







        --Jposscroll queue
        local jposscrollqueue = {}


        local maxcombo = 0 --needed for gauge calculation
        --notes that affect combo
        local combonote = {
            [1] = true,
            [2] = true,
            [3] = true,
            [4] = true,
        }

        local timet = {}
        local branch = 'M' --Branch to look for when counting notes for max combo
        local speedcalcf, speedcalcarg = nil, nil
        if Parsed.Flag.PARSER_FORCE_OLD_SPEED_CALCULATION then
            speedcalcf = Taiko.CalculateSpeed
            if Parsed.Flag.PARSER_FORCE_OLD_NOTERADIUS then
                noteradius = 1/40 * OriginalConfig.ScreenWidth
            end
            speedcalcarg = noteradius
        else
            speedcalcf = Taiko.CalculateSpeedInterval
            speedcalcarg = OriginalConfig.ScreenWidth / 1280
        end
        for k, v in pairs(notetable) do
            --v.oms is original ms
            --oms
            v.ms = v.oms or v.ms
            v.oms = v.ms

            v.bpm = v.obpm or v.bpm
            v.obpm = v.bpm

            v.ms = (v.ms - startms) / songspeedmul
            --v.s = MsToS(v.ms)
            --odelay
            v.delay = v.odelay or v.delay
            v.odelay = v.delay
            v.p = {}

            v.delay = v.delay / songspeedmul


            --v.speed = Taiko.CalculateSpeed(v, noteradius)
            
            --v.speed = Taiko.CalculateSpeedInterval(v, Config.ScreenWidth / 1280)

            v.speed = speedcalcf(v, speedcalcarg)

            --position override
            v.CalculatePosition = v.positionf or CalculatePosition


            v.speed[1] = v.speed[1] * notespeedmul
            v.speed[2] = v.speed[2] * notespeedmul

            --ojposscroll
            if v.jposscroll then
                v.jposscroll.lengthms = v.jposscroll.olengthms or v.jposscroll.lengthms
                v.jposscroll.olengthms = v.jposscroll.lengthms
                v.jposscroll.lengthms = v.jposscroll.lengthms / songspeedmul
                jposscrollqueue[#jposscrollqueue + 1] = v
            end



            v.loadms = CalculateLoadMs(v, v.ms - v.delay)
            --Assume start is before end
            if v.type == 8 and (v.startnote.type == 5 or v.startnote.type == 6) then
                v.loadms = CalculateLoadMsDrumroll(v, v.startnote.loadms < v.loadms and v.startnote.loadms or v.loadms)

                local drumrollbend = v.startnote.drumrollbend
                for i = 1, #drumrollbend do
                    local a = drumrollbend[i]
                    a.ms = (v.ms - v.startnote.ms) / (#drumrollbend + 1) * i + v.startnote.ms

                    a.speed = speedcalcf(a, speedcalcarg)

                    --position override
                    a.CalculatePosition = a.positionf or CalculatePosition

                    a.p = {}
                end
            end
            --[[
            v.newloadms = v.loadms
            v.loadmscalc = v.ms
            v.loads = MsToS(v.loadms)
            --]]
            --v.loadp = CalculateLoadPosition(v, v.loadms)
            --v.pdelay = 0
            v.done = nil
            v.hit = nil --Reset hit just in case
            v.timeshit = nil
            v.brokecombo = false

            v.setdelay = false
            v.pop = false

            --how much has this note affected score / combo?
            v.addcombo = nil
            v.addscore = nil
            v.addgauge = nil

            --v.n = k --MISTAKE: after sorted
            --table.insert(timet, v.ms)
            timet[#timet + 1] = v.ms
            --print(v.speed, v.loadms, v.loadp)
            v.senotet = v.senote and v.senote - 1 --corresponds to texture

            if (v.currentbranch == nil or v.currentbranch == branch) and combonote[v.type] then
                maxcombo = maxcombo + 1
            end
        end

        if stopsong or bpmchange then
            --sort with ms
            for k, v in pairs(Parsed.Data) do
                if v.branch then
                    for k2, v2 in pairs(v.branch.paths) do
                        table.sort(v2, function(a, b)
                            return a.ms < b.ms
                        end)
                    end
                end
            end
        
        
            --Path doesn't matter, they should all have same loadms
            table.sort(Parsed.Data, function(a, b)
                if a.branch and b.branch then
                    --both branches
                    for k, v in pairs(a.branch.paths) do
                        for k2, v2 in pairs(b.branch.paths) do
                            return v[1].ms < v2[1].ms
                        end
                    end
                elseif a.branch then
                    --a is branch
                    for k, v in pairs(a.branch.paths) do
                        return v[1].ms < b.ms
                    end
                elseif b.branch then
                    --b is branch
                    for k, v in pairs(b.branch.paths) do
                        return a.ms < v[1].ms
                    end
                else
                    --notes
                    return a.ms < b.ms
                end
            end)
        end







        local bpmchangequeue = {}
        if bpmchange then
            local bpm = Parsed.Metadata.BPM
            local bpmchanges = {
                ms = {

                },
                bpmchangemul = {

                },
                offset = 0, --Cumulative offset
            }
            Taiko.ForAll(Parsed.Data, function(note, i, n)
                if note.bpmchange then
                    note.bpmchangemul = note.bpmchange / bpm

                    --Modify ms
                    --[[
                        ex: bpmchangemul = 2
                        note get 2x further
                    ]]

                    bpm = note.bpmchange
                    bpmchanges.ms[#bpmchanges.ms + 1] = note.ms
                    bpmchanges.bpmchangemul[#bpmchanges.bpmchangemul + 1] = note.bpmchangemul


                    bpmchangequeue[#bpmchangequeue + 1] = note


                    --print('BPMCHANGE', note.ms, note.type)
                end

                --[[
                    reverse this

                    --reverse (WRONG)
                    note.ms = (note.ms + bpmchangems) * bpmchangemul - bpmchangems

                    --reverse
                    note.ms = ((note.ms - bpmchangems) * bpmchangemul) + bpmchangems

                    --original
                    note.ms = bpmchangems + (note.ms - bpmchangems) / bpmchangemul
                ]]
                for i = #bpmchanges.ms, 1, -1 do
                    note.ms = ((note.ms - bpmchanges.ms[i]) * bpmchanges.bpmchangemul[i]) + bpmchanges.ms[i]

                    note.speed[1] = note.speed[1] / bpmchanges.bpmchangemul[i]
                    note.speed[2] = note.speed[2] / bpmchanges.bpmchangemul[i]
                end




                --print(note.type, note.oms, note.ms)
                note.bpm = Parsed.Metadata.BPM

                --Somehow Precalculate Loadms?


                note.loadms = CalculateLoadMs(note, note.ms - note.delay)
            end)
        end


        local stopqueue = {}
        if stopsong then
            local lastnote = nil
            local lastdelay = 0
            Taiko.ForAll(Parsed.Data, function(note, i, n)
                --print(note.ms, note.delay)
                if note.delay ~= lastdelay then
                    if lastnote then
                        lastnote.stopms = note.delay - lastnote.delay
                        lastnote.stopstart = lastnote.ms
                        lastnote.stopend = lastnote.stopstart + lastnote.stopms
                    end
                    lastdelay = note.delay
                end

                --[[
                if lastnote and lastnote.delay ~= 0 then
                    lastnote.loadms = CalculateLoadMs(lastnote, lastnote.ms - lastnote.delay)
                end
                --]]
                if lastnote and lastnote.stopstart then
                    stopqueue[#stopqueue + 1] = lastnote
                end


                lastnote = note
            end)
            --print(#stopqueue)
        end


        if sudden then
            --[[
            how to implement
        
            for each note
                if ms < note.appearancemsa then
                    --hide note
                else
                    --show note
                end
                if ms < note.movemsa then
                    --NO: place note into precalculated static position
                    --YES: calc position using note.movemsa
                else
                    --calc position and move it
                end
            ]]
            Taiko.ForAll(Parsed.Data, function(note, i, n)
                if note.appearancems then
                    --if ms < note.appearancemsa then hide else show end
                    note.appearancemsa = note.ms + note.appearancems
                    
                    --sudden override
                    --print(note.appearancemsa, note.loadms)
                    if note.appearancemsa < note.loadms then
                        note.loadms = note.appearancemsa
                    end
                end
                if note.movems then
                    --uses this ms instead of current ms
                    note.movemsa = note.ms + note.movems
                end
            end)
        end

        --TJAP3: Vertical component is not affected by SUDDEN at all
        if Parsed.Flag.PARSER_TJAP3_SUDDEN_COMPAT then
            Taiko.ForAll(Parsed.Data, function(note, i, n)
                --reverse all complex scrolls (tjap3, add compat)
                note.speed[2] = -note.speed[2]

                if note.type == 5 or note.type == 6 then
                    --remove infinite drumrolls (tjap3, add compat)
                    if Parsed.Flag.PARSER_TJAP3_INFINITE_DRUMROLL_COMPAT then
                        if (note.endnote.speed[1] < 0 and note.speed[1] > 0) or (note.endnote.speed[1] > 0 and note.speed[1] < 0) then
                            note.endnote.speed[1] = note.speed[1]
                        end
                    end

                    if Parsed.Flag.PARSER_TJAP3_DRUMROLL_SUDDEN_COMPAT then
                        if note.endnote.movemsa then
                            note.endnote.movemsa = note.endnote.movemsa - (note.endnote.ms - note.ms)
                        end
                        if note.appearancemsa and note.endnote.appearancemsa then
                            note.endnote.appearancemsa = note.appearancemsa
                            if note.endnote.appearancemsa < note.endnote.loadms then
                                note.endnote.loadms = note.endnote.appearancemsa
                            end
                        end
                    end
                end

                -- if note.type == 5 or note.type == 6 or note.type == 8 then
                --     note.movemsa = nil
                -- end

                if note.movemsa then
                    local movemsa = note.movemsa
                    note.CalculatePosition = function(note, ms, target)
                        local msm = (ms >= movemsa and ms or movemsa)
                        return target[1] - (note.speed[1] * (note.ms - msm - note.delay)), target[2] - (note.speed[2] * (note.ms - ms - note.delay)) --FlipY
                    end
                    note.movemsa = nil
                end
            end)
        end










        --Sort by loadms
        --Sort all branches firt
        for k, v in pairs(Parsed.Data) do
            if v.branch then
                for k2, v2 in pairs(v.branch.paths) do
                    table.sort(v2, function(a, b)
                        return a.loadms < b.loadms
                    end)
                end
            end
        end


        --Path doesn't matter, they should all have same loadms
        table.sort(Parsed.Data, function(a, b)
            if a.branch and b.branch then
                --both branches
                for k, v in pairs(a.branch.paths) do
                    for k2, v2 in pairs(b.branch.paths) do
                        return v[1].loadms < v2[1].loadms
                    end
                end
            elseif a.branch then
                --a is branch
                for k, v in pairs(a.branch.paths) do
                    return v[1].loadms < b.loadms
                end
            elseif b.branch then
                --b is branch
                for k, v in pairs(b.branch.paths) do
                    return a.loadms < v[1].loadms
                end
            else
                --notes
                return a.loadms < b.loadms
            end
        end)

        --Relink and reindex after sorting
        Taiko.ConnectAll(Parsed.Data)
        Taiko.ForAll(Parsed.Data, function(note, i, n)
            --print(note.loadms)
            note.n = n
        end)



        local endms = timet[1]
        for i = 1, #timet do
            if timet[i] > endms then
                endms = timet[i]
            end
        end
        endms = endms + endmsadd / songspeedmul



        --Check for spawns before game starts

        --[[
        local loaded = {
            s = 1, --Start
            e = 0, --End
            n = 0, --Number of loaded notes
            --nearestnote = {} --Table of nearest notes
        }
        --]]
        local loaded = {}
        local loadedr = {
            barline = {

            },
            drumroll = {

            },
            notes = {
                
            }
        }
        local loadedrfinal = {

        }
        local done = {} --table of done (notes and queues) to support rewinding



        local nextnote = Parsed.Data[1]








        --Branching
        local branch = 'M'




        --score, combo, init, diff, status, gogo

        --Score
        --don't use Taiko.Score because it is inefficient
        local score = 0
        local scoreinit, scorediff, scoref = Parsed.Metadata.SCOREINIT, Parsed.Metadata.SCOREDIFF, Taiko.Data.ScoreMode.Note[Parsed.Metadata.SCOREMODE]
        
        --Combo
        local combo = 0

        --Gogo
        local gogo = false

        --Soul
        local gauge = 0
        local gaugep = 0
        local gaugeclear = false
        local gaugeoverflow = false
        local gauget = Taiko.Data.Gauge.Soul[Parsed.Metadata.COURSE](maxcombo)
        local gaugepercentf = Taiko.Data.Gauge.Percent



        --Balloon
        local balloon = nil
        local balloonstart = nil
        local balloonend = nil
        local balloonscoref = Taiko.Data.ScoreMode.Balloon[Parsed.Metadata.SCOREMODE]
        local balloonpopscoref = Taiko.Data.ScoreMode.BalloonPop[Parsed.Metadata.SCOREMODE]

        --Drumroll
        local drumroll = nil
        local drumrollstart = nil
        local drumrollend = nil
        local drumrollqueue = {} --startnotes
        local drumrollscoref = Taiko.Data.ScoreMode.Drumroll[Parsed.Metadata.SCOREMODE]




        
        --For rendering status
        local laststatus = {
            startms = nil,
            status = nil
        }










        --Gimmicks


        --Stop (delay) (DELAY)
        local stopfreezems = nil
        local stopstart = nil
        local stopend = nil
        --local stopqueue = {} --DEFINED ABOVE
        --local adddelay = false
        local totaldelay = 0


        --Jposscroll
        local jposscrollstart = nil
        local jposscrollend = nil
        local jposscrollspeed = {nil, nil}
        local jposscrollstartp = {nil, nil}
        --local jposscrollqueue = {} --DEFINED ABOVE
        --local recalculateloadms = false --opt

        --Bpmchange
        --local bpmchangequeue = {} --DEFINED ABOVE
        --local bpmchangemul = 1


        --Lyric
        local lyricqueue = {}
        local lyriccodepointsd = {} --every codepoint that is used for lyrics (dictionary)
        local currentlyric = nil --Current lyric object

        for i = 1, #Parsed.Lyric do
            local lyric = Parsed.Lyric[i]

            --Precompute data so we don't have to recompute every frame
            --lyric.font = Fonts.PlaySong.Lyric
            lyric.x = 0
            lyric.y = 600
            lyric.p = rl.new('Vector2', lyric.x, lyric.y)
            lyric.spacing = 5
            lyric.size = 45 --https://discord.com/channels/722513061419810946/960330807459868743/1077990340398686328

            --wrap text / split it into multiple lines

            --TODO

            --centering
            lyric.textrect = rl.new('Rectangle',
            0 + ((Config.ScreenWidth - 1280/720 * Config.ScreenHeight) / 2 + 100 * scale[1]),
            0,
            Config.ScreenWidth - 2 * ((Config.ScreenWidth - 1280/720 * Config.ScreenHeight) / 2 + 100 * scale[1]),
            0
            )

            --scale lyric
            lyric.p2 = rl.new('Vector2', 0, 0)

            lyric.odata = lyric.odata or lyric.data
            lyric.data = lyric.odata
            if lyric.data then
                if Config.Settings.PlaySong.LyricRomajiToHiragana then
                    lyric.data = Romaji.ToHiragana(lyric.data)
                end
                lyric.data = utf8Decode(lyric.data)

                --add codepoint to lyriccodepointsd so it can be loaded in the font
                for i = 1, #lyric.data do
                    lyriccodepointsd[lyric.data[i]] = true
                end

                --encode to c int codepoint array
                lyric.datac = rl.new('int[?]', #lyric.data, lyric.data)
            else
                lyric.data = nil
                lyric.datac = nil
            end

            lyricqueue[#lyricqueue + 1] = lyric
        end

        --generate lyriccodepoints (array)
        local lyriccodepoints = {}
        for k, v in pairs(lyriccodepointsd) do
            lyriccodepoints[#lyriccodepoints + 1] = k
            --print(k, k<256 and string.char(k) or '')
        end

        --Dynamic font
        local tempfont = Fonts.PlaySong.Lyric(lyriccodepoints, lyriccodepointsd)
        for i = 1, #Parsed.Lyric do
            Parsed.Lyric[i].font = tempfont
        end

























        --REPLAY
        local recording = false
        local record
        local recordfile = 'test.trp'

        local replaying = false
        local replay
        local replayfile = 'test.trp'
        local replaymetadata
        local replaymst
        local replaynextms
        local replayi

        if recording then
            record = {
                [1] = {
                    [false] = {},
                    [true] = {},
                },
                [2] = {
                    [false] = {},
                    [true] = {}, 
                },
            }
        end
        if replaying then
            replay, replaymetadata = Replay.Load(Replay.Read(replayfile))

            --Safety checks / Verify
            local function check(b, err)
                if b then

                else
                    error(err .. ' does not match')
                end
            end
            check(Replay.Version == replaymetadata.version, 'Version')
            check(Parsed.Metadata.TITLE == replaymetadata.title, 'Title')




            --Precalculate mst
            replaymst = {}
            for k, v in pairs(replay) do
                replaymst[#replaymst + 1] = k
            end
            table.sort(replaymst)
            replayi = 1
            replaynextms = replaymst[replayi]
        end











        --Editor
        local editortemp = {
            data = {
                DrawTexturePro = rl.DrawTexturePro,
                --DrawTexture = rl.DrawTexture
            },
            offset = {
                x = 0,
                y = 0
            },
            scale = {
                x = 1,
                y = 1,
            }
        } --moving temp

        
        local editor = {
            on = false, --enabled?
            changingscroll = true, --changing note.scroll for dragging notes?
            currentdragging = {}, --table of current notes that are being dragged
            currentdragginglinethickness = 5, --thickness of currentdragging selection rectangle
            currentdragginglinecolor = rl.new('Color', 13, 150, 241, 255 / 2), --color of currentdragging selection rectangle
            currentdraggingr = rl.new('Rectangle'), --rectangle used for currentdragging selection rectangle
            info = {
                hovernote = nil,
                backgroundcolor = rl.new('Color', 128, 128, 128, 128), --background color of info box
                textsize = 20, --text size for info text
                backgroundpadding = 10, --background padding border
                offset = rl.new('Vector2', 50, 50) --offset of info box
            },
            clipboard = {},
            overlay = {
                on = true, --enabled?
                editortextp = rl.new('Vector2', 10, 10), --editor logo text pr
                editortextsize = 25 --text size for editor logo text
            },
            boxselection = false, --box selection happening?
            boxselectionpr = rl.new('Rectangle'), --pr for box selection
            boxselectionpr2 = rl.new('Rectangle'), --pr for box selection
            grid = {
                on = false, --enabled?
                isrect = true, --rectangle? or ellipse?
                pr = rl.new('Rectangle', 0, 0, tsizex, tsizey), --pr for grid (x, y are intersection / starting points), (width, height are grid width height per)
                v = rl.new('Vector2'), --v used for drawing
                v2 = rl.new('Vector2'), --v2 used for drawing
                scrollincrement = 0.1, --scroll increment
                msincrement = 100, --ms increment
                selected = nil, --note selected (a single note)
                smallest = 10, --smallest grid increment that is rendered (enforced by selected)
            },
            movingnotes = true, --moving notes? or editor (camera) itself?
            moving = {
                tempf = function() end, --function that temporarily replaces DrawTexture so textures aren't drawn
                data = editortemp.data, --functions that are overwritten
                offset = {
                    tempf = {
                        DrawTexturePro = function(texture, source, dest, origin, rotation, tint)
                            local dest2 = rl.new('Rectangle', dest.x * editortemp.scale.x + editortemp.offset.x, dest.y * editortemp.scale.y + editortemp.offset.y, dest.width * editortemp.scale.x, dest.height * editortemp.scale.y)
                            editortemp.data.DrawTexturePro(texture, source, dest2, origin, rotation, tint)
                        end,
                        --[[
                        DrawTexture = function(texture, posX, posY, tint)

                        end
                        --]]
                    },
                    data = editortemp.data, --functions that are overwritten
                } --data used for offsetting when moving
            },
        }
        local runtimespeed = 1 --speed in which second gets incremented (multiplier)
        local pastruntimespeed = runtimespeed --variable to keep track of pastruntimespeed


        --Freeze (freezems) --makes s increment by 0. all controls work, just everything is stuck on the same frame. aka same frame is rendered over and over
        --Pausing basically (LOL WHY DIDN'T I USE THIS FOR PAUSING) but allows input to pass (allows for toggling auto, fullscreen, and EVERYTHING works)
        local freezems = false
        local freezemstemp = nil





















        local function calculaterotationr(note)
            --[[
                coming from -> degree
                r -> 0
                ru -> 360 - 45 = 315
                rd -> 180 - 45 = 135

                l -> 0
                lu -> 45
                ld -> 315

            ]]
            --https://en.wikipedia.org/wiki/Atan2
            local r = NormalizeAngle(math.deg(math.atan2(-note.scrollx, -note.scrolly)) - 90)
            --print(note.type, r, math.deg(math.atan2(-note.scrollx, -note.scrolly)) - 90)
            --Just mess around with equals sign lmao to tweak vertical note behavior
            if r < 90 or r >= 270 then
                --coming from right or (0, 0)
                note.rotationr = r
            else
                --coming from left
                note.rotationr = 180 + r
            end


            --[[
                degree -> facing
                0 -> up
                90 -> right
                180 -> down
                270 -> left
            ]]
        end

        --Precalculate some more stuff
        Taiko.ForAll(Parsed.Data, function(note, i, n)
            calculaterotationr(note)


            --remove bignotemul from parser
            if note.type == 3 or note.type == 4 or note.type == 6 then
                note.radiusr = note.radius / bignotemul
            else
                --might be barline, so add or 1
                note.radiusr = note.radius or 1
            end

            if note.data == 'event' and note.event == 'barline' then
                note.type = 'bar' --FIX: BRANCH BARLINE
                note.pr = rl.new('Rectangle', 0, 0, barlinesizex, barlinesizey)
                note.tcentero = rl.new('Vector2', barlinecenter.x * note.radiusr, barlinecenter.y * note.radiusr)
            else
                --note.pr = rl.new('Vector2', 0, 0)
                note.pr = rl.new('Rectangle', 0, 0, tsizex, tsizey)
                note.tcentero = rl.new('Vector2', tcenter.x * note.radiusr, tcenter.y * note.radiusr)
            end
            note.tcenter = rl.new('Vector2', 0, 0)

            note.pr.width = note.pr.width * note.radiusr
            note.pr.height = note.pr.height * note.radiusr

            
            if note.senote then
                note.osenotepr = rl.new('Rectangle', 0, 0, Textures.PlaySong.SENotes.sizex, Textures.PlaySong.SENotes.sizey)
                note.senotepr = rl.new('Rectangle', 0, 0, 0, 0)
            end


            --drumroll
            if note.startnote then
                local a = note.startnote
                if a.type == 5 or a.type == 6 then
                    note.rotationr = r
                    --[[
                    note.drumrollrect = rl.new('Rectangle', 0, 0, 0, 0)
                    note.drumrollrect2 = rl.new('Rectangle', 0, 0, 0, 0)
                    --]]

                    --note.drumrollrect2 = rl.new('Vector2', 0, 0)
                    if a.type == 5 then
                        a.notetype = 'drumrollnote'
                        a.recttype = 'drumrollrect'
                        a.endtype = 'drumrollend'
                    elseif a.type == 6 then
                        a.notetype = 'DRUMROLLnote'
                        a.recttype = 'DRUMROLLrect'
                        a.endtype = 'DRUMROLLend'
                    end

                    --drumrollbend?
                    for i = 1, #a.drumrollbend do
                        local v = a.drumrollbend[i]
                        v.pr = rl.new('Rectangle', 0, 0, tsizex, tsizey)
                        v.notetype = 'drumrollbend'
                    end

                    drumrollqueue[#drumrollqueue + 1] = a
                elseif a.type == 7 then
                    --note.balloonrect = rl.new('Rectangle', 0, 0, Textures.PlaySong.Balloons.sourcerect.width, Textures.PlaySong.Balloons.sourcerect.height)
                end
            end


            --queues

            --[[
            --queues are ordered by ms due to alignment issues
            if note.jposscroll then
                jposscrollqueue[#jposscrollqueue + 1] = note
            end
            if note.stopstart then
                stopqueue[#stopqueue + 1] = note
            end
            if note.bpmchange then
                bpmchangequeue[#bpmchangequeue + 1] = note
            end
            --]]
        end)



































        --Game functions

        --Hit: Hit the drum with a 1 (don) or 2 (ka)
        local s = 0
        local lasts = nil
        local ms = nil
        local dontincrements = false --flag to not increment s in case of freeze (file save dialog or pause)

        local nearest, nearestnote = {}, {}
        local autoside = false --false -> left, true = right





--[[
taiko notehitgauge animation (note flying towards soul)
]]

local notehitgauge = {
    notes = {
        --Notes are inserted into here
    },
    startms = {
        --Startms of notes are inserted into here, with same index
    },
    currenttarget = {
        --Current target of notes are inserted into here, with same index
        --Avoid table creation
        [1] = {},
        [2] = {}
    },
    anim = {
        --Anim references are inserted into here, with same index
    },
    animcache = {
        --Cache of all anims
    }
}

local drumrollhitnote = {
    type = 1,
    pr = rl.new('Rectangle', 0, 0, 0, 0),
    tcentero = rl.new('Vector2', tsizex / 2, tsizey / 2),
    tcenter = rl.new('Vector2', 0, 0),
    rotationr = 0 --TODO: determine it from drumroll rotation?
}
--[[
    TODO:
    Reduce table creation
]]




--[[
    Credit to KatieFrogs
    Faithful translation to lua from js
]]
local CalculateNoteHitGauge
do
    local dest = {
        {},
        {},
        {},
        {},
    }
    local animFrames = 25 * (skinfps / 60)


    --PASS IN AN UNSCALED TARGET tx, ty
    CalculateNoteHitGauge = function(txr, tyr)
        --print(txr, tyr)
        local tx, ty = txr * xmul + offsetx, tyr * ymul + offsety

        local function calcBezierPoint(t, data, dest)
            local at = 1 - t
            --for k, v in pairs(data) do dest[k] = {v[1], v[2]} end--data2 --data = data.slice() --copy array
            for k, v in pairs(data) do dest[k][1] = v[1] dest[k][2] = v[2] end--opt
            
            for i = 2, #dest do --for(var i = 1; i < data.length; i++){
                for k = 1, #dest - i + 1 do --for(var k = 0; k < data.length - i; k++){
                    --dest[k] = dest[k] or {}
                    dest[k][1] = dest[k][1] * at + dest[k + 1][1] * t
                    dest[k][2] = dest[k][2] * at + dest[k + 1][2] * t
                    
                end
            end
            return dest[1][1], dest[1][2] --copy opt
        end
        local function easeOut(pos)
            return math.sin(math.pi / 2 * pos)
        end


        local frameTop = 0
        
        --[[
        local target = {
            [1] = 413,
            [2] = frameTop + 257
        }
        print(unpack(target))error()
        --]]
        --slotPos.x = target[1]+offsetx slotPos.y = target[2]+offsety

        --[[
        local animPos = {
            x1 = target[1] + 14,
            y1 = target[2] - 29,
            x2 = Config.ScreenWidth - 55,
            y2 = frameTop + 165
        }
        --]]
        
        local animPos = {
            x1 = tx + (14 / 1280 * (OriginalConfig.ScreenWidth)),
            y1 = ty - (29 / 720 * (OriginalConfig.ScreenHeight)),
            x2 = (OriginalConfig.ScreenWidth) - (55 / 1280 * (OriginalConfig.ScreenWidth)),
            y2 = frameTop + (165 / 720 * (OriginalConfig.ScreenHeight))
        }


        animPos.w = animPos.x2 - animPos.x1
        --[[
        --variable height
        animPos.h = animPos.y1 - animPos.y2
        --]]

        --don't let height change
        --animPos.h = ((defaulttarget[2] * ymul + offsety) - 29) - (animPos.y2) --CONSTANT
        animPos.h = (63 / 720 * (OriginalConfig.ScreenHeight))

        local animateBezier = {{
            -- 427, 228
            animPos.x1,
            animPos.y1
        }, {
            -- 560, 10
            animPos.x1 + animPos.w / 6,
            animPos.y1 - animPos.h * 3.5
        }, {
            -- 940, -150
            animPos.x2 - animPos.w / 3,
            animPos.y2 - animPos.h * 5
        }, {
            -- 1225, 165
            animPos.x2,
            animPos.y2
        }}




        
        notehitgauge.animcache[txr] = notehitgauge.animcache[txr] or {}
        notehitgauge.animcache[txr][tyr] = {}
        local anim = notehitgauge.animcache[txr][tyr]
        --anim[0] = {nil, nil}
        anim[1] = {false}
        anim[2] = {false}
        for i = 1, animFrames do
            local animPoint = (i - 1) / (animFrames - 1)
            local bezierPointx, bezierPointy = calcBezierPoint(easeOut(animPoint), animateBezier, dest)
            anim[1][i - 1] = bezierPointx
            anim[2][i - 1] = bezierPointy
        end
    end
end

CalculateNoteHitGauge(target[1], target[2])





















        local function Hit(v, side)
            if oneveryhit then
                oneveryhit(ms, v, side, nearestnote)
            end


            --Play Sound
            rl.PlaySound(Sounds.PlaySong.Notes[v]) --PlaySound vs PlaySoundMulti?
            
            --Play Anim
            local taikoanim = taikoanim[side == false and 1 or side == true and 2]
            taikoanim[v].startms = ms
            taikoanim[v].color.a = 255

            --Play notehitlane
            notehitlane[v].startms = ms
            notehitlane[v].color.a = 255



            --Record
            if recording then
                record[v][side][#record[v][side] + 1] = ms
            end

            --Process hit

            --if nearest[v] and (not nearestnote[v].hit) then
            if nearestnote[v] and (not nearestnote[v].hit) then
                local note = nearestnote[v]
                local notetype = note.type
            --local notegogo = note.gogo

                local n = nearest[v]
                local status
                local gaugestatus
                --No leniency for good
                local leniency = ((notetype == 3 or notetype == 4) and Taiko.Data.BigLeniency) or 1
                local hiteffect = nil --Different than status
                --[[
                    hiteffect:
                    0 -> bad
                    1 -> smallok
                    2 -> smallgood
                    3 -> bigok
                    4 -> biggood
                ]]
                local isbignote = (notetype == 3 or notetype == 4)
                local oldcombo = combo
                if n < (timing.good) then
                    --good
                    --local a = nearestnote[v].type
                    --TODO: Easy big notes config
                    status = (isbignote and 3) or 2 --2 or 3?
                    combo = combo + 1
                    hiteffect = (isbignote and 4) or 2
                    gaugestatus = 2
                elseif n < (timing.ok * leniency) then
                    --ok
                    --status = 1
                    status = (isbignote and 2) or 1
                    combo = combo + 1
                    hiteffect = (isbignote and 3) or 1
                    gaugestatus = 1
                elseif n < (timing.bad * leniency) then
                    --bad
                    status = 0
                    combo = 0
                    hiteffect = 0
                    gaugestatus = 0
                else
                    --complete miss
                    status = nil
                end
                note.addcombo = combo - oldcombo

                if status then
                    --Calculate Score
                    local oldscore = score
                    score = scoref(score, combo, scoreinit, scorediff, status, note.gogo)
                    note.addscore = score - oldscore

                    --Calculate Gauge
                    local oldgauge = gauge
                    gauge = gauge + gauget[gaugestatus]
                    note.addgauge = gauge - oldgauge
                    gaugep = gaugepercentf(gauge)
                    gaugeclear = gaugep >= Taiko.Data.Gauge.ClearPercent
                    local oldgaugeoverflow = gaugeoverflow
                    gaugeoverflow = gaugep >= Taiko.Data.Gauge.OverflowPercent
                    if gaugeoverflow and (not oldgaugeoverflow) then
                        --just turned on
                        gaugeoverflowanim.startms = ms
                    end

                    --Effects
                    --[[
                        Effects:

                        Judge: https://github.com/0auBSQ/OpenTaiko/blob/c25c744cf11bc8ca997c1318eef4893269fd74d2/TJAPlayer3/Stages/07.Game/Taiko/CAct%E6%BC%94%E5%A5%8FDrums%E5%88%A4%E5%AE%9A%E6%96%87%E5%AD%97%E5%88%97.cs
                    ]]
                    nearestnote[v].hit = true
                    --[[
                    laststatus = {
                        startms = ms,
                        status = hiteffect,
                        statusanim = hiteffect ~= 0 and Textures.PlaySong.Effects.Note.Hit[hiteffect].Anim,
                        explosionanim = hiteffect ~= 0 and Textures.PlaySong.Effects.Note.Explosion[hiteffect].Anim,
                        explosionbiganim = (isbignote and Textures.PlaySong.Effects.Note.ExplosionBig.Anim) or nil
                    }
                    --]]
                    --avoid table creation
                    laststatus.startms = ms
                    laststatus.status = hiteffect
                    laststatus.statusanim = hiteffect ~= 0 and Textures.PlaySong.Effects.Note.Hit[hiteffect].Anim
                    laststatus.explosionanim = hiteffect ~= 0 and Textures.PlaySong.Effects.Note.Explosion[hiteffect].Anim
                    laststatus.explosionbiganim = (isbignote and Textures.PlaySong.Effects.Note.ExplosionBig.Anim) or nil

                    --notehitgauge animation
                    local i = #notehitgauge.notes + 1
                    notehitgauge.notes[i] = nearestnote[v]
                    notehitgauge.startms[i] = ms
                    local t1, t2 = target[1], target[2]
                    notehitgauge.currenttarget[1][i] = t1
                    notehitgauge.currenttarget[2][i] = t2
                    if notehitgauge.animcache[t1] and notehitgauge.animcache[t1][t2] then
                        --target already calced
                    else
                        --target needs to be calced
                        CalculateNoteHitGauge(t1, t2)
                    end
                    notehitgauge.anim[i] = notehitgauge.animcache[t1][t2]

                    --judgeanim
                    judgeanim.startms[#judgeanim.startms + 1] = ms
                    judgeanim.judge[#judgeanim.judge + 1] = gaugestatus

                    --combo sound
                    if Sounds.PlaySong.Combo[combo] then
                        rl.PlaySound(Sounds.PlaySong.Combo[combo])
                    end
                end
            end


            --Check again (one at a time)
            if (v == 1) and balloonstart and (ms > balloonstart and ms < balloonend) and (not balloon.pop) then
                --balloon = hit don or ka
                balloon.timeshit = balloon.timeshit and balloon.timeshit + 1 or 1
                local oldscore = score
                score = balloonscoref(score, balloon.type, balloon.gogo)
                balloon.addscore = (balloon.addscore or 0) + score - oldscore
                if balloon.timeshit >= balloon.requiredhits then
                    balloon.pop = true
                    popanim.startms = ms
                    popanim.color.a = 255
                    rl.PlaySound(Sounds.PlaySong.Notes.balloonpop)
                end
            end
            if (v == 1 or v == 2) and drumrollstart and (ms > drumrollstart and ms < drumrollend) then
                --drumroll = hit don or ka
                drumroll.timeshit = drumroll.timeshit and drumroll.timeshit + 1 or 1
                local oldscore = score
                score = drumrollscoref(score, drumroll.type, drumroll.gogo)
                drumroll.addscore = (drumroll.addscore or 0) + score - oldscore

                --notehitgauge animation
                local i = #notehitgauge.notes + 1
                notehitgauge.notes[i] = drumrollhitnote
                notehitgauge.startms[i] = ms
                local t1, t2 = target[1], target[2]
                notehitgauge.currenttarget[1][i] = t1
                notehitgauge.currenttarget[2][i] = t2
                if notehitgauge.animcache[t1] and notehitgauge.animcache[t1][t2] then
                    --target already calced
                else
                    --target needs to be calced
                    CalculateNoteHitGauge(t1, t2)
                end
                notehitgauge.anim[i] = notehitgauge.animcache[t1][t2]
            end
        end




        local function HitAuto(note)
            local v = autohitnotes[note.type] --Assume it is called with a valid note

            --DIRTY
            --local temp1, temp2 = nearest, nearestnote
            -- [[
            nearest[v] = 0
            nearestnote[v] = note
            --]]
            Hit(v, autoside)
            autoside = not autoside
            --nearest, nearestnote = temp1, temp2
        end
        local function HitAutoNow(v)
            Hit(v, autoside)
            autoside = not autoside
        end

        --[[
        --OLD VERSION: Based on position
        local function priority(a, b)
            --TODO: possibly render from closest to target
            --Rendering from left to right, down to up
            return
            (a.p[1] == b.p[1]) --is x equal?
            and (a.p[2] < b.p[2]) --if x equal then use y
            or (a.p[1] > b.p[1]) --if x not equal then just use x
        end
        --]]

        -- [[
        --NEW VERSION: Based on ms
        local function priority(a, b)
            --when ms is bigger, it is further away
            --render from far to in
            return a.ms > b.ms
        end
        --]]


        --Message (GUI message to users)
        --ACTUALLY GUIMESSAGE DOES THE SAME THING
        --local MessageLog = {}

        --Blocking
        --[[
        local function Message(str)
            while true do
                while not rl.WindowShouldClose() do
                    rl.BeginDrawing()
                    rl.ClearBackground(rl.RAYWHITE)
                    rl.DrawText('Press SPACE to start', Config.ScreenWidth / 2, Config.ScreenHeight / 2, fontsize, rl.BLACK)
                    rl.EndDrawing()
                    if rl.IsKeyPressed(32) then
                        break
                    end
                end
            end
        end
        --]]












        ResizeAll(Textures, oldscale[1], oldscale[2])









        --Generate Text Metadata
        local TextMetadata = table.concat(
            {
                -- 'Title: ', Parsed.Metadata.TITLE,
                -- '\nSubtitle: ', Parsed.Metadata.SUBTITLE,
                -- '\nDifficulty: ', Taiko.Data.CourseName[Parsed.Metadata.COURSE],
                -- '\nStars: ', tostring(Parsed.Metadata.LEVEL),
                -- '\n\nAuto: ', tostring(auto),
                -- '\nRecording: ', tostring(recording),
                -- '\nReplaying: ', tostring(replaying)
            }
        )


        --Wait for start
        if Config.Settings.PlaySong.WaitForStart then
            while not rl.WindowShouldClose() do
                rl.BeginDrawing()
                rl.ClearBackground(rl.RAYWHITE)
                rl.DrawText('Press SPACE to start', Config.ScreenWidth / 2, Config.ScreenHeight / 2, fontsize, rl.BLACK)
                rl.EndDrawing()
                if rl.IsKeyPressed(32) then
                    break
                end
            end
        end




        --Play music (before or after?)
        if playmusic then
            rl.SetMusicPitch(song, songspeedmul)
            rl.PlayMusicStream(song)

            if Config.Offsets.Music < 0 then
                rl.SeekMusicStream(song, -Config.Offsets.Music)
            end
        end

        --Main loop
        local framen = 0
        local startt = os.clock()





        while true do
                        --[[
            --debug
            DrawRectangleLines = function(a, b, c, d, e)
                rl.DrawRectangleLines(a * 0.5, b * 0.5, c * 0.5, d * 0.5, e)
            end
            DrawRectangleLines(screenrect[1] + offsetx, screenrect[2] + offsety, screenrect[3] - screenrect[1], screenrect[4] - screenrect[2], rl.RED)
            DrawRectangleLines(loadrect[1] + offsetx, loadrect[2] + offsety, loadrect[3] - loadrect[1], loadrect[4] - loadrect[2], rl.GREEN)
            DrawRectangleLines(unloadrect[1] + offsetx, unloadrect[2] + offsety, unloadrect[3] - unloadrect[1], unloadrect[4] - unloadrect[2], rl.PURPLE)
            --]]









            --[[
            --old: less precision
            local raws = os.clock()

            local s = raws - startt
            ms = s * 1000
            --]]

            -- [[
            --new: more precision
            --don't add frametime on first frame?
            --s = s + ((framen ~= 0 and (rl.GetFrameTime()) or 0) * runtimespeed)
            --don't use rl.GetFrameTime since it doesn't track time outside of rl.BeginDrawing and rl.EndDrawing
            --new2: instead generate deltatime ourselves
            local news = rl.GetTime()

            --[[
                multiplier from 60fps to whatever fps
            ]]
            local deltamultiplier = nil
            if lasts then
                deltamultiplier = (news - lasts) / (1 / 60)
            else
                deltamultiplier = 1
            end
            --print(deltamultiplier)

            if dontincrements then
                dontincrements = false
            else
                s = s + ((framen ~= 0 and (news - lasts) or 0) * runtimespeed)
            end
            lasts = news
            --s = s + rl.GetFrameTime()
            ms = s * 1000
            framen = framen + 1
            --forceresync = true --Alternately enable forceresync for extra precision? (???)
            --]]






            --Make canvas
            rl.BeginDrawing()

            rl.ClearBackground(rl.RAYWHITE)















            --rendering





            --check if editor is in move
            if editor.on and (not editor.movingnotes) then
                for k, v in pairs(editor.moving.data) do
                    rl[k] = editor.moving.tempf
                end
            end






            --draw bottom
            --TODO: Find skin and details

            --Actual backgrounds (non clean)
            --Down
            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Down[0], Textures.PlaySong.Backgrounds.Background.Down.sourcerect, Textures.PlaySong.Backgrounds.Background.Down.pr, Textures.PlaySong.Backgrounds.Background.Down.center, 0, rl.WHITE)

            --Footer
            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Footer[0], Textures.PlaySong.Backgrounds.Background.Footer.sourcerect, Textures.PlaySong.Backgrounds.Background.Footer.pr, Textures.PlaySong.Backgrounds.Background.Footer.center, 0, rl.WHITE)

            --Up
            local backgroundupy = math.floor(ms / 1000 * Textures.PlaySong.Backgrounds.Background.Up.sizey / 10) % Textures.PlaySong.Backgrounds.Background.Up.sizey
            local backgroundupx = -(math.floor(ms / 1000 * Textures.PlaySong.Backgrounds.Background.Up.sizex / 5) % Textures.PlaySong.Backgrounds.Background.Up.sizex)
            Textures.PlaySong.Backgrounds.Background.Up.pr.x = backgroundupx * scale[1]


            for i = 1, 5 do
                --LAZIEST SOLUTION EVER: Just render another one
                Textures.PlaySong.Backgrounds.Background.Up.pr.y = backgroundupy * scale[1] - Textures.PlaySong.Backgrounds.Background.Up.sizey
                rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Up[0], Textures.PlaySong.Backgrounds.Background.Up.sourcerect, Textures.PlaySong.Backgrounds.Background.Up.pr, Textures.PlaySong.Backgrounds.Background.Up.center, 0, rl.WHITE)

                --Now render center (main)
                Textures.PlaySong.Backgrounds.Background.Up.pr.y = backgroundupy * scale[1]
                rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Up[0], Textures.PlaySong.Backgrounds.Background.Up.sourcerect, Textures.PlaySong.Backgrounds.Background.Up.pr, Textures.PlaySong.Backgrounds.Background.Up.center, 0, rl.WHITE)

                --down
                if backgroundupy < Textures.PlaySong.Backgrounds.Background.Up.sizey * 0.2 then
                    Textures.PlaySong.Backgrounds.Background.Up.pr.y = backgroundupy * scale[1] + Textures.PlaySong.Backgrounds.Background.Up.sizey
                    rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Up[0], Textures.PlaySong.Backgrounds.Background.Up.sourcerect, Textures.PlaySong.Backgrounds.Background.Up.pr, Textures.PlaySong.Backgrounds.Background.Up.center, 0, rl.WHITE)
                end
                
                Textures.PlaySong.Backgrounds.Background.Up.pr.y = -backgroundupy * scale[1]
                rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Up[1], Textures.PlaySong.Backgrounds.Background.Up.sourcerect, Textures.PlaySong.Backgrounds.Background.Up.pr, Textures.PlaySong.Backgrounds.Background.Up.center, 0, rl.WHITE)

                Textures.PlaySong.Backgrounds.Background.Up.pr.y = -backgroundupy * scale[1] + Textures.PlaySong.Backgrounds.Background.Up.sizey
                rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Up[1], Textures.PlaySong.Backgrounds.Background.Up.sourcerect, Textures.PlaySong.Backgrounds.Background.Up.pr, Textures.PlaySong.Backgrounds.Background.Up.center, 0, rl.WHITE)

                if backgroundupy > Textures.PlaySong.Backgrounds.Background.Up.sizey * 0.8 then
                    Textures.PlaySong.Backgrounds.Background.Up.pr.y = -backgroundupy * scale[1] + 2 * Textures.PlaySong.Backgrounds.Background.Up.sizey
                    rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.Up[1], Textures.PlaySong.Backgrounds.Background.Up.sourcerect, Textures.PlaySong.Backgrounds.Background.Up.pr, Textures.PlaySong.Backgrounds.Background.Up.center, 0, rl.WHITE)
                end
                
                Textures.PlaySong.Backgrounds.Background.Up.pr.x = Textures.PlaySong.Backgrounds.Background.Up.pr.x + Textures.PlaySong.Backgrounds.Background.Up.sizex
            end









            --Clean stuff (necessary)

            --draw infobar
            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.InfoBar[0], Textures.PlaySong.Backgrounds.Background.InfoBar.sourcerect, Textures.PlaySong.Backgrounds.Background.InfoBar.pr, Textures.PlaySong.Backgrounds.Background.InfoBar.center, 0, rl.WHITE)

            --draw coursesymbol
            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Background.CourseSymbol[Parsed.Metadata.COURSE], Textures.PlaySong.Backgrounds.Background.CourseSymbol.sourcerect, Textures.PlaySong.Backgrounds.Background.CourseSymbol.pr, Textures.PlaySong.Backgrounds.Background.CourseSymbol.center, 0, rl.WHITE)
            
            --draw nameplate

            --base
            rl.DrawTexturePro(Textures.PlaySong.Nameplates.base, Textures.PlaySong.Nameplates.sourcerect, Textures.PlaySong.Nameplates.pr, Textures.PlaySong.Nameplates.center, 0, rl.WHITE)

            --edge
            rl.DrawTexturePro(Textures.PlaySong.Nameplates.edge, Textures.PlaySong.Nameplates.sourcerect, Textures.PlaySong.Nameplates.pr, Textures.PlaySong.Nameplates.center, 0, rl.WHITE)

            --top
            rl.DrawTexturePro(Textures.PlaySong.Nameplates.top, Textures.PlaySong.Nameplates.sourcerect, Textures.PlaySong.Nameplates.pr, Textures.PlaySong.Nameplates.center, 0, rl.WHITE)

            --rankbase
            rl.DrawTexturePro(Textures.PlaySong.Nameplates.rankbase, Textures.PlaySong.Nameplates.sourcerect, Textures.PlaySong.Nameplates.pr, Textures.PlaySong.Nameplates.center, 0, rl.WHITE)

            --rank
            rl.DrawTexturePro(Textures.PlaySong.Nameplates.rank[3], Textures.PlaySong.Nameplates.sourcerect, Textures.PlaySong.Nameplates.pr, Textures.PlaySong.Nameplates.center, 0, rl.WHITE)

            --1P
            rl.DrawTexturePro(Textures.PlaySong.Nameplates[1], Textures.PlaySong.Nameplates.sourcerect, Textures.PlaySong.Nameplates.pr, Textures.PlaySong.Nameplates.center, 0, rl.WHITE)








            --TODO: Draw before / after rendering?
            -- rl.DrawFPS(10, 10)
            rl.DrawText(TextMetadata, 10, 40, textsize, rl.BLACK)







            --MUSIC
            if playmusic then
                --Account for runtimespeed
                if runtimespeed ~= pastruntimespeed then
                    rl.SetMusicPitch(song, songspeedmul * runtimespeed) 
                    pastruntimespeed = runtimespeed
                end

                local offsets = s - Config.Offsets.Music

                if offsets >= 0 and not freezems then
                    --Prevent music desync
                    local desync = offsets - (rl.GetMusicTimePlayed(song) / songspeedmul)
                    --print(desync)
                    if forceresync or desync > desynctime or desync < -desynctime then --basically abs function
                        --Resync music to notes
                        -- print('RESYNC', desync)
                        rl.SeekMusicStream(song, offsets * songspeedmul)
                        forceresync = false
                    end

                    --Update Music

                    rl.UpdateMusicStream(song)
                end
            end



            --REPLAY
            if replaying and replaynextms and ms >= replaynextms then
                local t = replay[replaynextms]
                --[[
                for i = 1, #t do
                    --TODO: Fix replay side taiko
                    Hit(tonumber(t[i]), false)
                end
                --]]
                for i = 1, #t do
                    local a = Replay.Notes[t[i]]
                    Hit(a[1], a[2])
                end
                

                replayi = replayi + 1
                replaynextms = replaymst[replayi]
            end







            --Event checking
            if stopend and ms > stopend then
                stopfreezems, stopstart, stopend = nil, nil, nil
            end
            if balloonend and ms > balloonend then
                balloon, balloonstart, balloonend = nil, nil, nil
            end
            if drumrollend and ms > drumrollend then
                drumroll, drumrollstart, drumrollend = nil, nil, nil
            end



            --[[
                Both stop and jposscroll queues assume no 2 activate on same frame (break)
            ]]
            --stop
            if stopsong then
                for i = 1, #stopqueue do
                    local note = stopqueue[i]
                    if ms >= note.stopstart then
                        stopfreezems = totaldelay + note.stopstart
                        stopms = note.stopms
                        totaldelay = totaldelay - note.stopms
                        stopstart = note.stopstart
                        stopend = note.stopend

                        note.queue = stopqueue
                        note.done = s
                        done[#done + 1] = note
                        table.remove(stopqueue, i)
                        break
                    end
                end
            end

            --jposscroll
            --local offseti = 0
            if jposscroll then
                for i = 1, #jposscrollqueue do
                    --local i2 = i + offseti
                    local note = jposscrollqueue[i]
                    --if (note.jposscroll and (ms >= note.ms)) then
                    if ms >= note.ms then
                        --Previous jposscroll hasn't ended yet, so make sure it didn't skip over
                        if jposscrollstart then
                            local d = note.ms - jposscrollstart
                            target[1] = jposscrollstartp[1] + (jposscrollspeed[1] * d)
                            target[2] = jposscrollstartp[2] + (jposscrollspeed[2] * d)
                        end
                        
                        jposscrollstart = note.ms
                        jposscrollend = note.ms + note.jposscroll.lengthms
                        if note.jposscroll.p == 'default' then
                            jposscrollspeed[1] = (defaulttarget[1] - target[1]) / note.jposscroll.lengthms
                            jposscrollspeed[2] = (defaulttarget[2] - target[2]) / note.jposscroll.lengthms
                        else
                            jposscrollspeed[1] = ((note.jposscroll.p and note.jposscroll.p[1]) and note.jposscroll.p[1] or (note.jposscroll.lanep and note.jposscroll.lanep[1]) and (note.jposscroll.lanep[1] * tracklength) or 0) / note.jposscroll.lengthms
                            jposscrollspeed[2] = ((note.jposscroll.p and note.jposscroll.p[2]) and note.jposscroll.p[2] or (note.jposscroll.lanep and note.jposscroll.lanep[2]) and (note.jposscroll.lanep[2] * tracklength) or 0) / note.jposscroll.lengthms
                        end
                        jposscrollstartp[1] = target[1]
                        jposscrollstartp[2] = target[2]

                        note.queue = jposscrollqueue
                        note.done = s
                        done[#done + 1] = note
                        table.remove(jposscrollqueue, i)
                        break
                        --offseti = offseti - 1
                    end
                end

                --why not nest in loop!
                if jposscrollend and ms > jposscrollend then
                    --Add more preciseness and end at endposition!
                    local length = jposscrollend - jposscrollstart
                    target[1] = jposscrollstartp[1] + (jposscrollspeed[1] * length)
                    target[2] = jposscrollstartp[2] + (jposscrollspeed[2] * length)


                    jposscrollstart, jposscrollend = nil, nil
                    --[[
                    --Don't bother setting to nil, it won't be used anyways
                    jposscrollspeed[1] = nil
                    jposscrollspeed[2] = nil
                    jposscrollstartp[1] = nil
                    jposscrollstartp[2] = nil
                    --]]
                end
            end

            if bpmchange then
                for i = 1, #bpmchangequeue do
                    local note = bpmchangequeue[i]
                    if ms >= note.ms then
                        --bpmchangemul = note.bpmchangemul
                        local bpmchangems = note.ms
                        local bpmchangemul = note.bpmchangemul

                        --Modify ALL Notes
                        Taiko.ForAll(Parsed.Data, function(note, i, n)
                            --Modify ms
                            --[[
                                ex: bpmchangemul = 2
                                note get 2x faster
                                note get 2x further
                            ]]
                            --[[
                            --original
                            local dif = note.ms - bpmchangems
                            note.ms = note.ms - dif + dif / bpmchangemul
                            --]]

                            -- [[
                            note.ms = bpmchangems + (note.ms - bpmchangems) / bpmchangemul
                            --]]
                            




                            --Modify loadms (recalculate)
                            --[[
                                --SCALE ACCORDINGLY
                                --x, y
                                local x, y = RayIntersectsRectangle(target[1], target[2], -note.scrollx, -note.scrolly, loadrect[1], loadrect[2], loadrect[3], loadrect[4])
                                return ms - (x ~= 0 and x / -note.speed[1] or y / -note.speed[2])
                            ]]

                            --note.loadms = note.loadms + (note.loadms - note.ms) / bpmchangemul
                            --[[

                            
                            local ms = note.oms2 - note.delay
                            --[[
                                note.loadms = note.ms - (x / -note.speed[1])
                                -note.loadms + note.ms = x / -note.speed[1]
                                x = (-note.loadms + note.ms) * -note.speed
                            --]]
                            --[[
                            loadms = ms - (x / -note.speed[1])
                            loadms - ms = -(x/-note.speed[1])
                            --]]
                            --[[
                            local x = (-note.loadms + ms) * -note.ospeed2[1]
                            print(x)
                            note.loadms = ms - (x / -(note.speed[1] * bpmchangemul))
                            --]]
                            --print(x)
                            --note.loadms = ms + (note.loadms - ms) / (bpmchangemul)
                            --note.loadms = ms + (((note.loadms - ms)) / (bpmchangemul))

                            --]]
                            --print((note.ms - note.delay) - (((note.loadms - (note.ms - note.delay)) * note.speed[1]) / -(note.speed[1])), (note.ms - note.delay) - (((note.loadms - (note.ms - note.delay)) * note.speed[1]) / -(note.speed[1] * bpmchangemul)))
                            --note.loadms = (note.ms - note.delay) + (((note.loadms - (note.ms - note.delay))) / (bpmchangemul))

                            --[[
                            note.loadms = note.ms - (note.loadms * -note.speed[1] / (-note.speed[1] * bpmchangemul))
                            note.loadms = note.ms - (note.loadms / bpmchangemul)
                            --]]

                            --LAZY, DIRTY (DO THIS AFTER SPEEDCHANGE)
                            --note.loadms = CalculateLoadMs(note, note.ms - note.delay)







                            --Finally modify scroll or bpm, but I'll modify bpm (it doesn't matter which one you modify, they are both the same in speedcalculations)
                            --NVM: Modify speed only
                            note.speed[1] = note.speed[1] * bpmchangemul
                            note.speed[2] = note.speed[2] * bpmchangemul

                            --LAZY, DIRTY (DO THIS AFTER SPEEDCHANGE)
                            note.loadms = CalculateLoadMs(note, note.ms - note.delay)

                        end)
                        --print(bpmchangemul)

                        note.queue = bpmchangequeue
                        note.done = s
                        done[#done + 1] = note
                        table.remove(bpmchangequeue, i)
                        break
                    end
                end
            end

            if lyric then
                for i = 1, #lyricqueue do
                    local lyric = lyricqueue[i]
                    if ms >= lyric.ms then
                        currentlyric = lyric

                        --check for empty lyric
                        if not lyric.data then
                            currentlyric = nil
                        end

                        lyric.queue = lyricqueue
                        lyric.done = s
                        done[#done + 1] = lyric
                        table.remove(lyricqueue, i)
                        break
                    end
                end

                if currentlyric and (currentlyric.lengthms and ms >= (currentlyric.ms + currentlyric.lengthms)) then
                    currentlyric = nil
                end
            end

            for i = 1, #drumrollqueue do
                local startnote = drumrollqueue[i]
                if ms >= startnote.ms then
                    drumroll = startnote
                    drumrollstart = startnote.ms
                    drumrollend = startnote.ms + startnote.lengthms

                    startnote.queue = drumrollqueue
                    startnote.done = s
                    done[#done + 1] = startnote
                    table.remove(drumrollqueue, i)
                    break
                end
            end









            --See if next note is ready to be loaded
            if nextnote then
                while true do
                    if nextnote and (nextnote.loadms < ms + totaldelay) then
                        loaded[#loaded + 1] = nextnote

                        if nextnote.endnote then
                            loaded[#loaded + 1] = nextnote.endnote
                        end


                        nextnote = nextnote.nextnote
                        
                        if nextnote then
                            if nextnote.startnote then
                                --end note
                                nextnote = nextnote.nextnote
                            end


                            if nextnote and nextnote.branch then
                                nextnote = nextnote.branch.paths[branch][1]
                            end

                            --logically, branch should not start with endnote

                        end
                    else
                        break
                    end
                end
            else
                if ms > endms then
                    break
                end
            end






















            --rendering













            --draw frame

            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Frame[1], Textures.PlaySong.Backgrounds.Frame.sourcerect, Textures.PlaySong.Backgrounds.Frame.pr, Textures.PlaySong.Backgrounds.Frame.center, 0, rl.WHITE)



            --draw gauge (meter)

            --draw base
            rl.DrawTexturePro(Textures.PlaySong.Gauges.Meter.base, Textures.PlaySong.Gauges.Meter.sourcerect, Textures.PlaySong.Gauges.Meter.pr, Textures.PlaySong.Gauges.Meter.center, 0, rl.WHITE)

            --draw filled
            --[[
                width 14 for 1

                1 -> 0 - 13
                2 -> 14 - 27
                3 -> 28 - 41
                formula
                x = 14 * x - 1


                fill
                0 -> nothing
                39 -> all red
                49 -> all read 1 yellow
                50 -> all
            ]]
            local fill = math.floor(50 * gaugep)
            fill = ClipN(fill, 0, 50)
            local x = 14 * fill - 1
            if x > 0 then
                Textures.PlaySong.Gauges.Meter.sourcerect2.width = x/1280 * (Config.ScreenWidth / scale[1])
                Textures.PlaySong.Gauges.Meter.pr2.width = x/1280 * Config.ScreenWidth
                rl.DrawTexturePro(Textures.PlaySong.Gauges.Meter.full, Textures.PlaySong.Gauges.Meter.sourcerect2, Textures.PlaySong.Gauges.Meter.pr2, Textures.PlaySong.Gauges.Meter.center, 0, rl.WHITE)
            end



            --draw gauge modifiers

            if gaugeoverflow then
                --draw gaugeoverflow
                local difms = ms - gaugeoverflowanim.startms
                local animn = math.floor(difms / skinframems) % (gaugeoverflowanim.framen - 1)
                --Anim ended?
                local frame = gaugeoverflowanim.anim[animn]
                rl.DrawTexturePro(frame, Textures.PlaySong.Gauges.Meter.rainbow.sourcerect, Textures.PlaySong.Gauges.Meter.rainbow.pr, Textures.PlaySong.Gauges.Meter.rainbow.center, 0, rl.WHITE)
            elseif gaugeclear then
                --draw gaugeclear
                gaugeclearanim.startms = gaugeclearanim.startms or ms
                local difms = ms - gaugeclearanim.startms
                local animn = math.floor(difms / skinframems)
                --Anim ended?
                local frame = gaugeclearanim.anim[animn]
                if frame then
                    gaugeclearanim.color.a = 255 * frame
                else
                    --Anim ended, repeat
                    gaugeclearanim.startms = gaugeclearanim.startms + gaugeclearanim.framen * (1000 / skinfps)
                end

                --draw over
                local fill = 39
                local x = 14 * fill - 1
                Textures.PlaySong.Gauges.Meter.sourcerect2.width = x/1280 * (Config.ScreenWidth / scale[1])
                Textures.PlaySong.Gauges.Meter.pr2.width = x/1280 * Config.ScreenWidth
                rl.DrawTexturePro(Textures.PlaySong.Gauges.Meter.clear, Textures.PlaySong.Gauges.Meter.sourcerect2, Textures.PlaySong.Gauges.Meter.pr2, Textures.PlaySong.Gauges.Meter.center, 0, gaugeclearanim.color)
            end



            --draw clear symbol
            
            rl.DrawTexturePro(Textures.PlaySong.Gauges.Clear[gaugeclear], Textures.PlaySong.Gauges.Clear.sourcerect, Textures.PlaySong.Gauges.Clear.pr, Textures.PlaySong.Gauges.Clear.center, 0, rl.WHITE)





            

            --draw lane

            rl.DrawTexturePro(Textures.PlaySong.Lanes.Lane.default, Textures.PlaySong.Lanes.sourcerect, Textures.PlaySong.Lanes.pr, Textures.PlaySong.Lanes.center, 0, rl.WHITE)

            --draw lane sub

            rl.DrawTexturePro(Textures.PlaySong.Lanes.Lane.sub, Textures.PlaySong.Lanes.ssourcerect, Textures.PlaySong.Lanes.spr, Textures.PlaySong.Lanes.scenter, 0, rl.WHITE)

            --draw taiko
            
            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Taiko.base, Textures.PlaySong.Backgrounds.Taiko.sourcerect, Textures.PlaySong.Backgrounds.Taiko.pr, Textures.PlaySong.Backgrounds.Taiko.center, 0, rl.WHITE)

            for i = 1, 2 do
                local sideanim = taikoanim[i]
                for i2 = 1, 2 do
                    local taikoanim2 = sideanim[i2]
                    if taikoanim2.startms then
                        --draw taiko side hit indicator

                        local difms = ms - taikoanim2.startms
                        local animn = math.floor(difms / skinframems)
                        --local transparency = 255 - (animn / framen * 255)
                        local transparency = taikoanim.anim[animn]

                        if transparency then
                            taikoanim2.color.a = 255 * transparency

                            if transparency > 0 then
                                --if visible

                                --taikoanim.side
                                sideanim.pr.x = sideanim.opr.x * scale[1]
                                sideanim.pr.y = sideanim.opr.y * scale[2]
                                sideanim.pr.width = sideanim.opr.width * scale[1]
                                sideanim.pr.height = sideanim.opr.height * scale[2]
                                rl.DrawTexturePro(Textures.PlaySong.Backgrounds.Taiko[i2], sideanim.sourcerect, sideanim.pr, sideanim.center, 0, rl.WHITE)
                            end
                        else
                            taikoanim.startms = nil
                        end
                    end
                end
            end

            --draw notehitlane
            for i = 1, 2 do
                local notehitlane2 = notehitlane[i]
                if notehitlane2.startms then
                    --draw taiko side hit indicator

                    local difms = ms - notehitlane2.startms
                    local animn = math.floor(difms / skinframems)
                    --local transparency = 255 - (animn / framen * 255)
                    local transparency = notehitlane.anim[animn]

                    if transparency then
                        notehitlane2.color.a = 255 * transparency

                        if transparency > 0 then
                            --if visible

                            --notehitlane
                            rl.DrawTexturePro(Textures.PlaySong.Lanes.Lane[i], Textures.PlaySong.Lanes.sourcerect, Textures.PlaySong.Lanes.pr, Textures.PlaySong.Lanes.center, 0, rl.WHITE)
                        end
                    else
                        notehitlane2.startms = nil
                    end
                end
            end

            --draw combotext

            rl.DrawTexturePro(Textures.PlaySong.Backgrounds.ComboText[0], Textures.PlaySong.Backgrounds.ComboText.sourcerect, Textures.PlaySong.Backgrounds.ComboText.pr, Textures.PlaySong.Backgrounds.ComboText.center, 0, rl.WHITE)

            --draw combo (center align)

            --[[
                combo
                0-9     invis
                10-49    0
                50-99   1
                100-inf 2
            ]]
            if combo >= 10 then
                local osx, osy = 40/1280 * (Config.ScreenWidth / scale[1]), 48/720 * (Config.ScreenHeight / scale[2])
                local sx, sy = osx * scale[1], osy * scale[2]
                local str = tostring(combo)
                local a = combo < 50 and 0 or combo < 100 and 1 or 2
                local measurex = MeasureTextTexture(str, osx, osy, sx, sy, scale)
                DrawTextTexture(Textures.PlaySong.Fonts.Combo[a], str, 250/1280 * Config.ScreenWidth - (measurex / 2), 220/720 * Config.ScreenHeight, osx, osy, sx, sy, scale)
            end








            --draw score (right align)
            local osx, osy = 26/1280 * (Config.ScreenWidth / scale[1]), 34/720 * (Config.ScreenHeight / scale[2])
            local sx, sy = osx * scale[1], osy * scale[2]
            local str = tostring(score)
            local measurex = MeasureTextTexture(str, osx, osy, sx, sy, scale)
            DrawTextTexture(Textures.PlaySong.Fonts.Score[0], str, 160/1280 * Config.ScreenWidth - measurex, 194/720 * Config.ScreenHeight, osx, osy, sx, sy, scale)




            --draw lyric
            if currentlyric then
                --rl.DrawText(currentlyric.data, currentlyric.x, currentlyric.y, currentlyric.size, rl.BLACK)
                currentlyric.p2.x = currentlyric.p.x * scale[1]
                currentlyric.p2.y = currentlyric.p.y * scale[2]

                rl.DrawTextCodepoints(currentlyric.font, currentlyric.datac, #currentlyric.data, currentlyric.p2, currentlyric.size * scale[2], currentlyric.spacing, rl.BLACK)
                --rl.DrawTextCodepoint(currentlyric.font, 12354, currentlyric.p, currentlyric.size, rl.BLACK)
            end











            --draw notehitgauge (below title, status, explosion, (notes?)) (above background, gauge, lane)
            local offseti = 0
            for i = 1, #notehitgauge.notes do
                local i2 = i + offseti
                local note = notehitgauge.notes[i2]
                local startms = notehitgauge.startms[i2]
                local difms = ms - startms
                local animn = math.floor(difms / skinframems)
                --Anim ended?
                --local frame = notehitgauge.animcache[animn]
                local currenttarget = notehitgauge.currenttarget
                --local frame = notehitgauge.animcache[currenttarget[1][i2]][currenttarget[2][i2]][animn] --LEGACY --DIRTY
                local frame = notehitgauge.anim[i2]
                if frame[1][animn] ~= nil then
                    if frame[1][animn] then
                        --scale
                        note.pr.width = tsizex * scale[1]
                        note.pr.height = tsizey * scale[2]
                        note.tcenter.x = note.tcentero.x * scale[1]
                        note.tcenter.y = note.tcentero.y * scale[2]

                        --draw note
                        note.pr.x = frame[1][animn] * scale[1]
                        note.pr.y = frame[2][animn] * scale[2]
                        rl.DrawTexturePro(Textures.PlaySong.Notes[note.type], tsourcerect, note.pr, note.tcenter, note.rotationr, rl.WHITE) --For drawtexturepro, no need to draw with offset TEXTURE
                    else
                        --invis
                    end
                else
                    --Anim ended, remove status
                    table.remove(notehitgauge.notes, i2)
                    table.remove(notehitgauge.startms, i2)
                    table.remove(notehitgauge.currenttarget[1], i2)
                    table.remove(notehitgauge.currenttarget[2], i2)
                    table.remove(notehitgauge.anim, i2)
                    offseti = offseti - 1
                end
            end







            --check if editor is in move
            if editor.on and (not editor.movingnotes) then
                for k, v in pairs(editor.moving.data) do
                    rl[k] = v
                end
            end


            --check if editor is in move
            if editor.on and (not editor.movingnotes) then
                for k, v in pairs(editor.moving.offset.tempf) do
                    rl[k] = v
                end
            end
























            --draw target

            if jposscrollstart and ms >= jposscrollstart then
                target[1] = jposscrollstartp[1] + (jposscrollspeed[1] * (ms - jposscrollstart))
                target[2] = jposscrollstartp[2] + (jposscrollspeed[2] * (ms - jposscrollstart))
            end


            local targetoffsetx = target[1] - defaulttarget[1]
            local targetoffsety = target[2] - defaulttarget[2]
            
            unloadrectchanged[1] = unloadrect[1] + targetoffsetx
            unloadrectchanged[2] = unloadrect[2] + targetoffsety
            unloadrectchanged[3] = unloadrect[3] + targetoffsetx
            unloadrectchanged[4] = unloadrect[4] + targetoffsety





            --normal

            --scale
            --[[
            targetpr.x = (Round(target[1] * xmul) + offsetx) * scale[1]
            targetpr.y = (Round(target[2] * ymul) + offsety) * scale[2]
            --]]
            targetpr.x = (target[1] * xmul + offsetx) * scale[1]
            targetpr.y = (target[2] * ymul + offsety) * scale[2]
            targetpr.width = tsizex * scale[1]
            targetpr.height = tsizey * scale[2]
            rl.DrawTexturePro(Textures.PlaySong.Notes.target, tsourcerect, targetpr, tcenter, 0, rl.WHITE)























            --notes

            --nearest (IF THERE IS NOTHING LOADED IT WILL BE NIL)
            --[[
                notes:
                nearest is [1] = ms, [2] = ms
                nearestnote is [1] = note, [2] = note
            ]]
            nearest = {
                
            }
            nearestnote = {

            }

            loadedr = {
                barline = {

                },
                drumroll = {

                },
                balloon  = {

                },
                notes = {

                }
            }






            --First pass: Calculate
            --for i = loaded.s, loaded.e do
            local offsetms = ms - Config.Offsets.Timing
            --local offsetmsminus = ms + Config.Offsets.Timing --why tf is it different???
            local offseti = 0
            for i = 1, #loaded do
                local i2 = i + offseti
                local note = loaded[i2]
                if note then
                    --nearest
                    if not (note.hit) and note.data == 'note' then
                        local d = math.abs(offsetms - note.ms)
                        if (note.type == 1 or note.type == 3) and (not nearest[1] or d < nearest[1]) then
                            nearest[1] = d
                            nearestnote[1] = note
                        elseif (note.type == 2 or note.type == 4) and (not nearest[2] or d < nearest[2]) then
                            nearest[2] = d
                            nearestnote[2] = note
                        end
                    end


                    --local px, py = CalculatePosition(note, stopfreezems or (ms + totaldelay))
                    local px, py = note.CalculatePosition(note, stopfreezems or ((note.movemsa and (ms >= note.movemsa and ms or note.movemsa) or ms) + totaldelay), target)
                    note.p[1] = px * xmul
                    note.p[2] = py * ymul



                    --after target pass
                    if ms > note.ms then
                        --gogo
                        gogo = note.gogo

                        --balloon
                        if note.type == 7 then
                            if balloon then
                                note.hit = false
                                if balloon.n == note.n then
                                    --Same balloon
                                    note.p[1] = target[1] * xmul
                                    note.p[2] = target[2] * ymul

                                    if not balloon.setdelay then
                                        --make it go from target after ending, smooth
                                        balloon.delay = balloon.delay - balloon.lengthms
                                        balloon.setdelay = true
                                    end
                                else
                                    --Previous balloon hasn't ended yet
                                    --Replace
                                end
                            end
                            balloon = note
                            balloonstart = note.ms
                            balloonend = note.ms + note.lengthms
                        end
                    end









                    --pr: rendering
                    --[[
                    --rendering using DrawTextureEx
                    note.pr.x = Round(note.p[1]) + toffsetx
                    note.pr.y = Round(note.p[2]) + toffsety
                    --]]
                    --[[
                    --rendering using DrawTexturePro
                    note.pr.x = (Round(note.p[1]) + offsetx) * scale[1]
                    note.pr.y = (Round(note.p[2]) + offsety) * scale[2]
                    --]]
                    note.pr.x = (note.p[1] + offsetx) * scale[1]
                    note.pr.y = (note.p[2] + offsety) * scale[2]














                    --Auto
                    --I put this here so that even if note is going to be unloaded on this frame, we can hit it
                    if auto then
                        if not note.hit and autohitnotes[note.type] and offsetms >= note.ms then
                            HitAuto(note)
                        end
                    end









                    --rewrite condition
                    if (note.hit and not (stopsong and note.stopstart and not (ms > note.stopstart))) or (ms > note.ms and IsPointInRectangle(note.p[1], note.p[2], unloadrectchanged[1], unloadrectchanged[2], unloadrectchanged[3], unloadrectchanged[4]) == false)
                    --drumroll code
                    --startnote
                    and ((not note.endnote) or (note.endnote.done))
                    --endnote
                    --TODO: https://gist.github.com/ChickenProp/3194723
                    --[[
                    and ((not note.startnote) or (IsLineOutsideRectangle(
                        note.p[1] < note.startnote.p[1] and note.p[1] or note.startnote.p[2],
                        note.p[2] < note.startnote.p[2] and note.p[2] or note.startnote.p[2],
                        note.p[1] < note.startnote.p[1] and note.startnote.p[1] or note.p[2],
                        note.p[2] < note.startnote.p[2] and note.startnote.p[2] or note.p[2],
                        unloadrectchanged[1], unloadrectchanged[2], unloadrectchanged[3], unloadrectchanged[4]
                    ))) then
                    --]]
                    and ((not note.startnote) or (note.drumrollsimple)) then

                        
                        -- print('UNLOAD')
                        note.done = s
                        table.remove(loaded, i2)
                        done[#done + 1] = note
                        offseti = offseti - 1

                    --just connect with else
                    else
                        if note.data == 'event' then
                            if note.event == 'barline' then
                                loadedr.barline[#loadedr.barline + 1] = note
                            end
                        else
                            if note.type == 8 then
                                loadedr.drumroll[#loadedr.drumroll + 1] = note
                            elseif note.type == 7 then
                                loadedr.balloon[#loadedr.balloon + 1] = note
                            else
                                loadedr.notes[#loadedr.notes + 1] = note
                            end
                        end

                    end
                end
            end







            --Moved input here so it can be rendered instantly, no input delay


            --Raylib Input

            --Take auto first
            if auto then
                local n1 = nearest[1]
                local n2 = nearest[2]
                --local testv = (nearest[1] and nearest[2]) and ((nearest[1] < nearest[2]) and 1 or 2) or (nearest[1] and 1 or 2)
                local testv =
                (n1 and n2)
                and (
                    (n1 < n2)
                    and 1 or 2
                )
                or (n1 and 1 or 2)
                local n = nearest[testv]
                local note = nearestnote[testv]

                if not n or (n and n > (timing.bad * (((note.type == 3 or note.type == 4) and Taiko.Data.BigLeniency) or 1))) then
                    --make sure we can't hit note as bad
                    if balloonstart and (ms > balloonstart and ms < balloonend) and not balloon.pop then
                        HitAutoNow(1)
                    elseif drumrollstart and (ms > drumrollstart and ms < drumrollend) then
                        HitAutoNow(1)
                    end
                end
            end

            --[[
            while true do
                local key = rl.GetCharPressed() --or rl.GetKeyPressed()
                if key == 0 then
                    break
                else
                    --Process
                    --local a = Controls.Hit[key]
                end
            end
            --]]

            --Use controls to look for keys because GetCharPressed / GetKeyPressed doesn't capture special keys
            -- + more efficient
            --Editor takes priority
            --TODO: Fix keybinds (conflicts) for EVERYTHING
            if editor.on then
                for k, v in pairs(Config.Controls.PlaySong.Hit) do
                    if not (Config.Controls.PlaySong.Editor.Shortcut.New[k]) and rl.IsKeyPressed(k) then
                        Hit(v[1], v[2])
                    end
                end
            else
                for k, v in pairs(Config.Controls.PlaySong.Hit) do
                    if rl.IsKeyPressed(k) then
                        Hit(v[1], v[2])
                    end
                end
            end






















            loadedrfinal = loadedr.barline




            table.sort(loadedr.drumroll, priority)
            table.sort(loadedr.notes, priority)
            table.sort(loadedr.balloon, priority)


            for i = 1, #loadedr.drumroll do
                loadedrfinal[#loadedrfinal + 1] = loadedr.drumroll[i]
            end
            for i = 1, #loadedr.notes do
                loadedrfinal[#loadedrfinal + 1] = loadedr.notes[i]
            end
            for i = 1, #loadedr.balloon do
                loadedrfinal[#loadedrfinal + 1] = loadedr.balloon[i]
            end






            targetpr.width = targetpr.width * 2
            targetpr.height = targetpr.height * 2
            --Render status on bottom of notes
            if laststatus.statusanim then
                local difms = ms - laststatus.startms
                local animn = math.floor(difms / skinframems)
                --Anim ended?
                local frame = laststatus.statusanim[animn]
                if frame then
                    --Draw on target
                    --rl.DrawTexture(frame, Round(target[1] * xmul) + statusoffsetx, Round(target[2] * ymul) + statusoffsety, effectcolor)

                    --scale
                    rl.DrawTexturePro(frame, Textures.PlaySong.Effects.Note.sourcerect, targetpr, Textures.PlaySong.Effects.Note.center, 0, effectcolor)
                else
                    --Anim ended, remove status
                    laststatus.statusanim = nil
                end
            end










            --Second pass: Rendering

            for i = 1, #loadedrfinal do
                local note = loadedrfinal[i]
                if note then
                    --Draw note on canvas

                    --if not note.hit and not (note.appearancemsa and (ms < note.appearancemsa)) then
                    if not note.hit then

                        --Break combo if too late
                        local leniency = ((note.type == 3 or note.type == 4) and Taiko.Data.BigLeniency) or 1
                        if (not note.brokecombo) and (note.type == 1 or note.type == 2 or note.type == 3 or note.type == 4) and ms - note.ms > (timing.bad * leniency) then
                            --bad
                            --status = 0
                            combo = 0
                            --prevent retriggering
                            note.brokecombo = true
                        end

                        --if dorender then
                        if not (note.appearancemsa and (ms < note.appearancemsa)) then
                            if note.data == 'event' then
                                if note.event == 'barline' then
                                    --scale
                                    note.pr.width = barlinesizex * scale[1]
                                    note.pr.height = barlinesizey * scale[2]
                                    note.tcenter.x = note.tcentero.x * scale[1]
                                    note.tcenter.y = note.tcentero.y * scale[2]

                                    --RAYLIB: RENDERING BARLNE
                                    --rl.DrawLine(Round(note.p[1]) + offsetx, Round(note.p[2]) - tracky + offsety, Round(note.p[1]) + offsetx, Round(note.p[2]) + offsety, barlinecolor)
                                    rl.DrawTexturePro(Textures.PlaySong.Barlines[note.type], barlinesourcerect, note.pr, note.tcenter, note.rotationr, rl.WHITE)
                                end
                            elseif note.data == 'note' then
                                --scale
                                note.pr.width = tsizex * scale[1]
                                note.pr.height = tsizey * scale[2]
                                note.tcenter.x = note.tcentero.x * scale[1]
                                note.tcenter.y = note.tcentero.y * scale[2]

                                --SENotes
                                if note.senote then
                                    note.senotepr.x = note.pr.x
                                    note.senotepr.y = note.pr.y + (Textures.PlaySong.SENotes.offsety) * scale[2]
                                    note.senotepr.width = note.osenotepr.width * scale[1]
                                    note.senotepr.height = note.osenotepr.height * scale[2]
                                    rl.DrawTexturePro(Textures.PlaySong.SENotes[note.senote], Textures.PlaySong.SENotes.sourcerect, note.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)
                                end


                                --RAYLIB: RENDERING NOTE
                                if Textures.PlaySong.Notes[note.type] then
                                    --rl.DrawTexture(Textures.PlaySong.Notes[note.type], Round(note.p[1]) + toffsetx, Round(note.p[2]) + toffsety, rl.WHITE)
                                    --rl.DrawTextureEx(Textures.PlaySong.Notes[note.type], note.pr, note.rotationr, note.radius, rl.WHITE)

                                    rl.DrawTexturePro(Textures.PlaySong.Notes[note.type], tsourcerect, note.pr, note.tcenter, note.rotationr, rl.WHITE) --For drawtexturepro, no need to draw with offset TEXTURE

                                elseif note.type == 8 then
                                    local startnote = note.startnote
                                    
                                    if startnote.type == 5 or startnote.type == 6 then

                                        if #startnote.drumrollbend == 0 then
                                            --LEGACY / NO DRUMROLLBEND (WORKS 100%)


                                            --LEGACY START



                                            local r = noteradius * note.radius
                                            --recalc startnote p if it is loaded later
                                            local x1, x2 = startnote.p[1], note.p[1]
                                            local y1, y2 = startnote.p[2], note.p[2]





                                            --New code (12/8/22)
                                            if Round(x2 - x1) ~= 0 or Round(y2 - y1) ~= 0 then




                                                --FINAL: Use atan2!
                                                --note.rotationr = NormalizeAngle(math.deg(math.atan2(x2 - x1, y1 - y2)) - 90) --WORKS BUT --DIRTY
                                                note.rotationr = NormalizeAngle(0 - math.deg(math.atan2((y2 - y1) * ymul / scale[1], (x2 - x1) * xmul / scale[2])))


                                                





                                                --Draw rect + endnote


                                                local d = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)

                                                local mulx = (x2 - x1) / d
                                                local muly = (y2 - y1) / d
                                                --mulx, muly = 1, -1
                                                local incrementx = tsizex * mulx
                                                local incrementy = tsizey * muly






                                                --1
                                                local div = math.floor(d / tsizex)
                                                local mod = d - (div * tsizex)









                                                Textures.PlaySong.Notes.drumrollpr.width = tsizex * scale[1]
                                                Textures.PlaySong.Notes.drumrollpr.height = tsizey * scale[2]



                                                --Just modify rect in loop
                                                local x = x1 + offsetx + (tsizex / 2 * mulx)
                                                local y = y1 + offsety + (tsizey / 2 * muly)
                                                local subdiv = 4
                                                local subdivoff = -0.5
                                                --print(div)
                                                for i = 1, div do
                                                    Textures.PlaySong.Notes.drumrollpr.x = x * scale[1]
                                                    Textures.PlaySong.Notes.drumrollpr.y = y * scale[2]
                                                    rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.recttype], tsourcerect, Textures.PlaySong.Notes.drumrollpr, note.tcenter, note.rotationr, rl.WHITE)

                                                    --draw drumroll line senote
                                                    for i2 = 0, subdiv - 1 do
                                                        if startnote.senote then
                                                            startnote.senotepr.x = (x + (incrementx * (i2 / subdiv + subdivoff))) * scale[1]
                                                            startnote.senotepr.y = (y + (incrementy * (i2 / subdiv + subdivoff)) + Textures.PlaySong.SENotes.offsety) * scale[2]
                                                            rl.DrawTexturePro(Textures.PlaySong.SENotes[9], Textures.PlaySong.SENotes.sourcerect, startnote.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)
                                                        end
                                                    end

                                                    x = x + incrementx
                                                    y = y + incrementy
                                                end

                                                Textures.PlaySong.Notes.drumrollpr.width = mod * scale[1]
                                                



                                                Textures.PlaySong.Notes.drumrollpr.x = x * scale[1]
                                                Textures.PlaySong.Notes.drumrollpr.y = y * scale[2]


                                                Textures.PlaySong.Notes.drumrollpr2.width = mod
                                                Textures.PlaySong.Notes.drumrollpr2.height = tsizey


                                                rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.recttype], Textures.PlaySong.Notes.drumrollpr2, Textures.PlaySong.Notes.drumrollpr, note.tcenter, note.rotationr, rl.WHITE)

                                                --draw drumroll line senote
                                                local a = math.floor(Textures.PlaySong.Notes.drumrollpr.width / tsizex)
                                                subdivoff = subdivoff + 17/136
                                                for i2 = 0, a - 1 do
                                                    if startnote.senote then
                                                        startnote.senotepr.x = (x + (incrementx * (i2 / subdiv + subdivoff))) * scale[1]
                                                        startnote.senotepr.y = (y + (incrementy * (i2 / subdiv + subdivoff)) + Textures.PlaySong.SENotes.offsety) * scale[2]
                                                        rl.DrawTexturePro(Textures.PlaySong.SENotes[9], Textures.PlaySong.SENotes.sourcerect, startnote.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)
                                                    end
                                                end

                                                startnote.senotepr.x = (x + (incrementx * (a / subdiv + subdivoff))) * scale[1]
                                                startnote.senotepr.y = (y + (incrementy * (a / subdiv + subdivoff)) + Textures.PlaySong.SENotes.offsety) * scale[2]
                                                rl.DrawTexturePro(Textures.PlaySong.SENotes[10], Textures.PlaySong.SENotes.sourcerect, startnote.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)

                                                --[[
                                                x = x + incrementmodx
                                                y = y + incrementmody
                                                --]]
                                                x = x + mod * mulx
                                                y = y + mod * muly


                                                --[[
                                                    rotation:
                                                    0 -> 0

                                                    270 -> 270
                                                    360 -> 180

                                                ]]
                                                note.pr.x = x * scale[1]
                                                note.pr.y = y * scale[2]
                                                rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.endtype], tsourcerect, note.pr, note.tcenter, note.rotationr, rl.WHITE)


                                            end

                                            --Draw startnote
                                            rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.notetype], tsourcerect, startnote.pr, startnote.tcenter, startnote.rotationr, rl.WHITE)
                                        


                                            --LEGACY END





























                                        else
                                            --NEW / IMPLEMENTED DRUMROLLBEND (WORKS PROBABLY)


                                            --NEW START

                                            local endnote = note
                                            local drumrollbend = endnote.startnote.drumrollbend

                                            for i = 1, #drumrollbend + 1 do
                                                local startnote, note

                                                --NOTE: Position calculation formulas taken from Calculate phase
                                                if i == 1 then
                                                    startnote = endnote.startnote
                                                    note = drumrollbend[i]

                                                    --Positions
                                                    --calculate note
                                                    local px, py = note.CalculatePosition(note, stopfreezems or ((note.movemsa and (ms >= note.movemsa and ms or note.movemsa) or ms) + totaldelay), target)
                                                    note.p[1] = px * xmul
                                                    note.p[2] = py * ymul
                                                    
                                                    note.pr.x = (note.p[1] + offsetx) * scale[1]
                                                    note.pr.y = (note.p[2] + offsety) * scale[2]
                                                elseif i == #drumrollbend + 1 then
                                                    startnote = drumrollbend[i - 1]
                                                    note = endnote

                                                    --Positions
                                                    --calculate startnote
                                                    local px, py = startnote.CalculatePosition(startnote, stopfreezems or ((startnote.movemsa and (ms >= startnote.movemsa and ms or startnote.movemsa) or ms) + totaldelay), target)
                                                    startnote.p[1] = px * xmul
                                                    startnote.p[2] = py * ymul

                                                    startnote.pr.x = (startnote.p[1] + offsetx) * scale[1]
                                                    startnote.pr.y = (startnote.p[2] + offsety) * scale[2]

                                                    --scale
                                                    startnote.pr.width = tsizex * scale[1]
                                                    startnote.pr.height = tsizey * scale[2]
                                                    -- startnote.tcenter.x = startnote.tcentero.x * scale[1]
                                                    -- startnote.tcenter.y = startnote.tcentero.y * scale[2]
                                                else
                                                    startnote = drumrollbend[i - 1]
                                                    note = drumrollbend[i]

                                                    --Positions
                                                    --calculate startnote, note
                                                    local px, py = startnote.CalculatePosition(startnote, stopfreezems or ((startnote.movemsa and (ms >= startnote.movemsa and ms or startnote.movemsa) or ms) + totaldelay), target)
                                                    startnote.p[1] = px * xmul
                                                    startnote.p[2] = py * ymul

                                                    startnote.pr.x = (startnote.p[1] + offsetx) * scale[1]
                                                    startnote.pr.y = (startnote.p[2] + offsety) * scale[2]

                                                    --scale
                                                    startnote.pr.width = tsizex * scale[1]
                                                    startnote.pr.height = tsizey * scale[2]
                                                    -- startnote.tcenter.x = startnote.tcentero.x * scale[1]
                                                    -- startnote.tcenter.y = startnote.tcentero.y * scale[2]


                                                    local px, py = note.CalculatePosition(note, stopfreezems or ((note.movemsa and (ms >= note.movemsa and ms or note.movemsa) or ms) + totaldelay), target)
                                                    note.p[1] = px * xmul
                                                    note.p[2] = py * ymul

                                                    note.pr.x = (note.p[1] + offsetx) * scale[1]
                                                    note.pr.y = (note.p[2] + offsety) * scale[2]
                                                end




                                                local r = noteradius * note.radius
                                                --recalc startnote p if it is loaded later
                                                local x1, x2 = startnote.p[1], note.p[1]
                                                local y1, y2 = startnote.p[2], note.p[2]





                                                --New code (12/8/22)
                                                if Round(x2 - x1) ~= 0 or Round(y2 - y1) ~= 0 then




                                                    --FINAL: Use atan2!
                                                    --note.rotationr = NormalizeAngle(math.deg(math.atan2(x2 - x1, y1 - y2)) - 90) --WORKS BUT --DIRTY
                                                    note.rotationr = NormalizeAngle(0 - math.deg(math.atan2((y2 - y1) * ymul / scale[1], (x2 - x1) * xmul / scale[2])))

                                                    --copying some attributes over
                                                    --[[
                                                    --MOVED to notetable
                                                    if i == 1 then
                                                        --startnote.notetype = endnote.startnote.notetype
                                                        --should be normal startnote
                                                    else
                                                        startnote.notetype = 'drumrollbend'
                                                    end
                                                    --]]
                                                    startnote.recttype = endnote.startnote.recttype
                                                    startnote.endtype = endnote.startnote.endtype
                                                    startnote.senotepr = endnote.startnote.senotepr
                                                    note.tcenter = endnote.tcenter --DIRTY


                                                    





                                                    --Draw rect + endnote


                                                    local d = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)

                                                    local mulx = (x2 - x1) / d
                                                    local muly = (y2 - y1) / d
                                                    --mulx, muly = 1, -1
                                                    local incrementx = tsizex * mulx
                                                    local incrementy = tsizey * muly






                                                    --1
                                                    local div = math.floor(d / tsizex)
                                                    local mod = d - (div * tsizex)









                                                    Textures.PlaySong.Notes.drumrollpr.width = tsizex * scale[1]
                                                    Textures.PlaySong.Notes.drumrollpr.height = tsizey * scale[2]



                                                    --Just modify rect in loop
                                                    local x = x1 + offsetx + (tsizex / 2 * mulx)
                                                    local y = y1 + offsety + (tsizey / 2 * muly)
                                                    local subdiv = 4
                                                    local subdivoff = -0.5
                                                    --print(div)
                                                    for i = 1, div do
                                                        Textures.PlaySong.Notes.drumrollpr.x = x * scale[1]
                                                        Textures.PlaySong.Notes.drumrollpr.y = y * scale[2]
                                                        rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.recttype], tsourcerect, Textures.PlaySong.Notes.drumrollpr, note.tcenter, note.rotationr, rl.WHITE)

                                                        --draw drumroll line senote
                                                        for i2 = 0, subdiv - 1 do
                                                            if startnote.senote then
                                                                startnote.senotepr.x = (x + (incrementx * (i2 / subdiv + subdivoff))) * scale[1]
                                                                startnote.senotepr.y = (y + (incrementy * (i2 / subdiv + subdivoff)) + Textures.PlaySong.SENotes.offsety) * scale[2]
                                                                rl.DrawTexturePro(Textures.PlaySong.SENotes[9], Textures.PlaySong.SENotes.sourcerect, startnote.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)
                                                            end
                                                        end

                                                        x = x + incrementx
                                                        y = y + incrementy
                                                    end

                                                    Textures.PlaySong.Notes.drumrollpr.width = mod * scale[1]
                                                    



                                                    Textures.PlaySong.Notes.drumrollpr.x = x * scale[1]
                                                    Textures.PlaySong.Notes.drumrollpr.y = y * scale[2]


                                                    Textures.PlaySong.Notes.drumrollpr2.width = mod
                                                    Textures.PlaySong.Notes.drumrollpr2.height = tsizey


                                                    rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.recttype], Textures.PlaySong.Notes.drumrollpr2, Textures.PlaySong.Notes.drumrollpr, note.tcenter, note.rotationr, rl.WHITE)

                                                    --draw drumroll line senote
                                                    local a = math.floor(Textures.PlaySong.Notes.drumrollpr.width / tsizex)
                                                    subdivoff = subdivoff + 17/136
                                                    for i2 = 0, a - 1 do
                                                        if startnote.senote then
                                                            startnote.senotepr.x = (x + (incrementx * (i2 / subdiv + subdivoff))) * scale[1]
                                                            startnote.senotepr.y = (y + (incrementy * (i2 / subdiv + subdivoff)) + Textures.PlaySong.SENotes.offsety) * scale[2]
                                                            rl.DrawTexturePro(Textures.PlaySong.SENotes[9], Textures.PlaySong.SENotes.sourcerect, startnote.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)
                                                        end
                                                    end

                                                    startnote.senotepr.x = (x + (incrementx * (a / subdiv + subdivoff))) * scale[1]
                                                    startnote.senotepr.y = (y + (incrementy * (a / subdiv + subdivoff)) + Textures.PlaySong.SENotes.offsety) * scale[2]
                                                    rl.DrawTexturePro(Textures.PlaySong.SENotes[10], Textures.PlaySong.SENotes.sourcerect, startnote.senotepr, Textures.PlaySong.SENotes.center, 0, rl.WHITE)

                                                    --[[
                                                    x = x + incrementmodx
                                                    y = y + incrementmody
                                                    --]]
                                                    x = x + mod * mulx
                                                    y = y + mod * muly


                                                    --[[
                                                        rotation:
                                                        0 -> 0

                                                        270 -> 270
                                                        360 -> 180

                                                    ]]
                                                    note.pr.x = x * scale[1]
                                                    note.pr.y = y * scale[2]
                                                    rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.endtype], tsourcerect, note.pr, note.tcenter, note.rotationr, rl.WHITE)


                                                end

                                                --Draw startnote
                                                --rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.notetype], tsourcerect, startnote.pr, startnote.tcenter, startnote.rotationr, rl.WHITE)
                                                --draw after all is done
                                            end

                                            --Draw startnote
                                            rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.notetype], tsourcerect, startnote.pr, startnote.tcenter, startnote.rotationr, rl.WHITE)
                                            for i = 1, #drumrollbend do
                                                local startnote = drumrollbend[i]

                                                --Draw startnote
                                                --EDITED SO rotationr is replaced with 0 (it shouldn't matter anyways)
                                                rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.notetype], tsourcerect, startnote.pr, endnote.tcenter, 0, rl.WHITE)

                                                --test if circle drawing properly
                                                --[[
                                                startnote.pr.x = Config.ScreenWidth / 2
                                                startnote.pr.y = Config.ScreenHeight / 2
                                                rl.DrawTexturePro(Textures.PlaySong.Notes[startnote.notetype], tsourcerect, startnote.pr, startnote.tcenter, 0, rl.WHITE)
                                                --]]
                                            end
                                        


                                            --NEW END
                                        end












                                        --[[
                                            BALLOON RENDERING

                                            OpenTaiko:

                                            Saitama 2000 (50)
                                            49-41 -> 0
                                            40-31 -> 1
                                            30-21 -> 2
                                            20-11 -> 3
                                            10-1 -> 4
                                            0 -> 5

                                            (60)
                                            59-49 -> 0
                                            48-37 -> 1
                                            36-25 -> 2
                                            24-13 -> 3
                                            12-1 -> 4
                                            0 -> 5

                                            (57)
                                            56-45 -> 0
                                            44-34 -> 1
                                            33-23 -> 2
                                            22-12 -> 3
                                            11-1 -> 4
                                            0 -> 5

                                            (58)
                                            57-45 -> 0
                                            44-34 -> 1
                                            33-23 -> 2
                                            22-12 -> 3
                                            11-1 -> 4
                                            0 -> 5


                                            Consensus:
                                            (Hits/5) Round down
                                            Extra gets put in front

                                            source: https://youtu.be/scZs6yBcIEw?t=17
                                        --]]
                                    elseif startnote.type == 7 then
                                        
                                        --if startnote.timeshit == nil or startnote.timeshit == 0 then
                                        if startnote.timeshit == nil then
                                            --Not hit yet

                                            --draw note
                                            rl.DrawTexturePro(Textures.PlaySong.Notes.balloon, tsourcerect, startnote.pr, startnote.tcenter, startnote.rotationr, rl.WHITE)
                                            
                                            --draw balloon
                                            Textures.PlaySong.Balloons.pr2.x = startnote.pr.x + startnote.pr.width --DIRTY
                                            Textures.PlaySong.Balloons.pr2.y = startnote.pr.y
                                            rl.DrawTexturePro(Textures.PlaySong.Notes.balloonend, tsourcerect, Textures.PlaySong.Balloons.pr2, startnote.tcenter, startnote.rotationr, rl.WHITE)
                                        else
                                            --Hit at least 1 time

                                            --draw donchan



                                            --how much more hits
                                            local morehits = startnote.requiredhits - startnote.timeshit

                                            --formula for framen
                                            --local framen = (popanim.framen - 1) - math.ceil(morehits / math.floor(startnote.requiredhits / (popanim.framen - 1)))
                                            local framen = (popanim.framen - 1) - math.ceil(morehits / (startnote.requiredhits / (popanim.framen - 1)))
                                            framen = framen < 0 and 0 or framen

                                            if framen == 5 then
                                                --Pop

                                                --assume popanim exists
                                                --local popanim = startnote.popanim
                                                local difms = ms - popanim.startms
                                                local animn = math.floor(difms / skinframems)
                                                --local transparency = 255 - (animn / framen * 255)
                                                local transparency = popanim.anim[animn]

                                                if transparency then
                                                    popanim.color.a = 255 * transparency

                                                    if transparency > 0 then
                                                        --if visible
                                                        rl.DrawTexturePro(Textures.PlaySong.Balloons.Anim[framen], Textures.PlaySong.Balloons.sourcerect, Textures.PlaySong.Balloons.pr, Textures.PlaySong.Balloons.center, startnote.rotationr, popanim.color)
                                                    end
                                                else
                                                    startnote.hit = true
                                                end
                                            else
                                                --Trying to blow

                                                --draw balloon at same position as non-hit above donchan
                                                Textures.PlaySong.Balloons.pr.x = startnote.pr.x + startnote.pr.width --DIRTY
                                                Textures.PlaySong.Balloons.pr.y = startnote.pr.y
                                                rl.DrawTexturePro(Textures.PlaySong.Balloons.Anim[framen], Textures.PlaySong.Balloons.sourcerect, Textures.PlaySong.Balloons.pr, Textures.PlaySong.Balloons.center, startnote.rotationr, rl.WHITE)
                                            end
                                        end

                                        
                                    end



                                end
                            else
                                error('Invalid note.data')
                            end
                        end

                    end
                end
                
                
            end






            --Render flash above notes
            if laststatus.explosionanim then
                local difms = ms - laststatus.startms
                local animn = math.floor(difms / skinframems)
                --Anim ended?
                local frame = laststatus.explosionanim[animn]
                if frame then
                    --Draw on target
                    --rl.DrawTexture(frame, Round(target[1] * xmul) + statusoffsetx, Round(target[2] * ymul) + statusoffsety, effectcolor)

                    --scale
                    rl.DrawTexturePro(frame, Textures.PlaySong.Effects.Note.sourcerect, targetpr, Textures.PlaySong.Effects.Note.center, 0, effectcolor)
                else
                    --Anim ended, remove status
                    laststatus.explosionanim = nil
                end
            end

            --Render explosion (big) above flash
            if laststatus.explosionbiganim then
                local difms = ms - laststatus.startms
                local animn = math.floor(difms / skinframems)
                --Anim ended?
                local frame = laststatus.explosionbiganim[animn]
                if frame then
                    --Draw on target
                    --rl.DrawTexture(frame, Round(target[1] * xmul) + statusoffsetx, Round(target[2] * ymul) + statusoffsety, effectcolor)

                    --scale
                    rl.DrawTexturePro(frame, Textures.PlaySong.Effects.Note.sourcerect, targetpr, Textures.PlaySong.Effects.Note.center, 0, effectcolor)
                else
                    --Anim ended, remove status
                    laststatus.explosionbiganim = nil
                end
            end

            --Render judge above all
            local offseti = 0
            for i = 1, #judgeanim.startms do
                local i2 = i + offseti
                local difms = ms - judgeanim.startms[i2]
                local animn = math.floor(difms / skinframems)
                --Anim ended?
                local p = judgeanim.animp[animn]
                if p then
                    local t = judgeanim.animt[animn]
                    local j = judgeanim.judge[i2]
                    
                    --Draw
                    judgeanim.color.a = 255 * t
                    Textures.PlaySong.Judges.pr.x = targetpr.x
                    Textures.PlaySong.Judges.pr.y = targetpr.y - (p/720 * Config.ScreenHeight)
                    rl.DrawTexturePro(Textures.PlaySong.Judges[j], Textures.PlaySong.Judges.sourcerect, Textures.PlaySong.Judges.pr, Textures.PlaySong.Judges.center, 0, judgeanim.color)
                else
                    --Anim ended, remove status
                    table.remove(judgeanim.startms, i2)
                    table.remove(judgeanim.judge, i2)
                    offseti = offseti - 1
                end
            end



















            --check if editor is in move
            if editor.on and (not editor.movingnotes) then
                for k, v in pairs(editor.moving.offset.data) do
                    rl[k] = v
                end
            end









            --EDITOR

            if editor.on then
                local mouseposition = rl.GetMousePosition()

                --Grid
                if editor.grid.on then

                    --ALL CALCULATED BELOW
                    --[=[
                    if editor.grid.selected then
                        local note = editor.grid.selected

                        --Center on note
                        --[[
                        editor.grid.pr.x = note.pr.x
                        editor.grid.pr.y = note.pr.y
                        --]]

                        --Just center on target
                        editor.grid.pr.x = targetpr.x
                        editor.grid.pr.y = targetpr.y

                        --Width and Height are determined when selected is determined
                    else
                        --Just center on target
                        editor.grid.pr.x = targetpr.x
                        editor.grid.pr.y = targetpr.y

                        --Default Width and Height
                        editor.grid.pr.width = tsizex / 4
                        editor.grid.pr.height = tsizey / 4
                    end
                    --]=]


                    --Rectangle
                    if editor.grid.isrect then
                        local w, h = editor.grid.pr.width * scale[1], editor.grid.pr.height * scale[2]
                        local v, v2 = editor.grid.v, editor.grid.v2
                        local pr = editor.grid.pr
                        local prx, pry = pr.x + (editortemp.offset.x % w), pr.y + (editortemp.offset.y % h)
                        local linethickness = editor.currentdragginglinethickness
                        local color = editor.currentdragginglinecolor

                        --Horizontal lines
                        v.x = 0
                        v2.x = Config.ScreenWidth

                        --Current + Up
                        local y = pry
                        while true do
                            if y < 0 then
                                break
                            else
                                v.y = y
                                v2.y = y
                                rl.DrawLineEx(v, v2, linethickness, color)
                                y = y - h
                            end
                        end

                        --Down
                        local y = pry + h
                        while true do
                            if y > Config.ScreenHeight then
                                break
                            else
                                v.y = y
                                v2.y = y
                                rl.DrawLineEx(v, v2, linethickness, color)
                                y = y + h
                            end
                        end


                        --Vertical lines
                        v.y = 0
                        v2.y = Config.ScreenHeight

                        --Current + Left
                        local x = prx
                        while true do
                            if x < 0 then
                                break
                            else
                                v.x = x
                                v2.x = x
                                rl.DrawLineEx(v, v2, linethickness, color)
                                x = x - w
                            end
                        end

                        --Right
                        local x = prx + w
                        while true do
                            if x > Config.ScreenWidth then
                                break
                            else
                                v.x = x
                                v2.x = x
                                rl.DrawLineEx(v, v2, linethickness, color)
                                x = x + w
                            end
                        end



                    --Circular
                    else
                        local x, y = editor.grid.pr.x + editortemp.offset.x, editor.grid.pr.y + editortemp.offset.y
                        local ow, oh = editor.grid.pr.width * scale[1], editor.grid.pr.height * scale[2]
                        local v, v2 = editor.grid.v, editor.grid.v2
                        local pr = editor.grid.pr
                        local linethickness = editor.currentdragginglinethickness
                        local color = editor.currentdragginglinecolor

                        local i = 1
                        local w, h = nil, nil
                        while true do
                            w = ow * i
                            h = oh * i

                            --https://math.stackexchange.com/questions/76457/check-if-a-point-is-within-an-ellipse
                            local condition = ((0 - x) ^ 2 / (w) ^ 2 + (0 - y) ^ 2 / (h) ^ 2 <= 1)
                            and ((Config.ScreenWidth - x) ^ 2 / (w) ^ 2 + (0 - y) ^ 2 / (h) ^ 2 <= 1)
                            and ((0 - x) ^ 2 / (w) ^ 2 + (Config.ScreenHeight - y) ^ 2 / (h) ^ 2 <= 1)
                            and ((Config.ScreenWidth - x) ^ 2 / (w) ^ 2 + (Config.ScreenHeight - y) ^ 2 / (h) ^ 2 <= 1)
                            if condition then
                                break
                            else
                                rl.DrawEllipseLines(x, y, w, h, color)
                                i = i + 1
                            end
                        end


                        --Handle line thickness (since raylib doesn't have a linethickness option)
                        for i2 = 1, linethickness - 1 do
                            for i3 = 1, i do
                                w = ow * i3 + i2
                                h = oh * i3 + i2
                                rl.DrawEllipseLines(x, y, w, h, color)
                            end
                        end



                    end



                end












                --Box selection (leftpressed)
                if editor.boxselection then
                    --Rectangle logic is handled below rl.EndDrawing

                    rl.DrawRectangleLinesEx(editor.boxselectionpr2, editor.currentdragginglinethickness, editor.currentdragginglinecolor)
                end









                --Note info
                if editor.info.hovernote then
                    local note = editor.info.hovernote

                    local str = 'ms: ' .. note.ms
                    .. '\ntype: ' .. note.type
                    .. '\nscroll: {' .. note.scrollx .. ', ' .. note.scrolly .. '}'
                    .. '\nspeed: {' .. note.speed[1] .. ', ' .. note.speed[2] .. '}'
                    .. '\nbpm: ' .. note.bpm
                    .. '\nn: ' .. (note.n or '')
                    .. '\nline: ' .. (note.line or '')

                    --render based on note pr --DEPRACATED
                    --local x, y = note.pr.x + editor.info.offset.x, note.pr.y + editor.info.offset.y

                    --render based on mouseposition
                    local x, y = mouseposition.x + editor.info.offset.x, mouseposition.y + editor.info.offset.y

                    local width, height = GetTextSize(str, editor.info.textsize)
        

                    local padding = editor.info.backgroundpadding
        

                    rl.DrawRectangle(x - padding, y - padding, width + 2 * padding, height + 2 * padding, editor.info.backgroundcolor)

                    rl.DrawText(str, x, y, editor.info.textsize, rl.RAYWHITE)


                    editor.info.hovernote = nil
                end

                --Selection box
                local offseti = 0
                for i = 1, #editor.currentdragging do
                    local i2 = i + offseti
                    local note = editor.currentdragging[i2]

                    if note.hit then
                        table.remove(editor.currentdragging, i2)
                        offseti = offseti - 1
                    else
                        local r = editor.currentdraggingr
                        r.x = note.pr.x - note.tcenter.x + editortemp.offset.x
                        r.y = note.pr.y - note.tcenter.y + editortemp.offset.y
                        r.width = note.pr.width
                        r.height = note.pr.height
                        
                        rl.DrawRectangleLinesEx(r, editor.currentdragginglinethickness, editor.currentdragginglinecolor)
                    end
                end


                --Overlay
                if editor.overlay.on then
                    --Logo text and ms
                    rl.DrawText(
                        'Editor'
                        .. '   Selected: ' .. #editor.currentdragging .. ' notes'
                        .. '   Runtime speed: ' .. (freezems and freezemstemp or runtimespeed)
                        .. '   ms: ' .. ms
                        .. '   fps: ' .. rl.GetFPS()
                        .. '   loaded: ' .. #loadedrfinal
                        .. '\nEditor   DragMode: Changing ' .. (editor.changingscroll and 'scroll' or 'ms')
                        .. '   DragMode increment: ' .. (editor.grid.on and ((editor.changingscroll and (editor.grid.scrollincrement .. ' scroll') or (editor.grid.msincrement .. ' ms'))) or 'Off')
                        .. '   Grid: ' .. (editor.grid.on and 'On' or 'Off')
                        .. '\nEditor   MoveMode: Moving ' .. (editor.movingnotes and 'notes' or 'editor')
                        , editor.overlay.editortextp.x, editor.overlay.editortextp.y, editor.overlay.editortextsize * scale[2], rl.BLACK)
                end
            end

















            if oneveryframe then
                oneveryframe(ms)
            end



            rl.EndDrawing()













            --Editor
            --Toggle Editor?
            if IsKeyPressed(Config.Controls.PlaySong.Editor.Toggle) then
                editor.on = not editor.on
            end

            if editor.on then
                --[[
                    TODO:
                    Left click on notes to move and stuff --DONE
                    Right click on notes to set properties
                    Middle click?
                    Draw ms under notes --DONE
                    Drag notes (ms and possibly scroll (target)) --DONE
                    Edit drum rolls (copy paste, ms, drumrollbend)
                    Edit note ms --DONE
                    Screenshot key is the same as snap key --DONE
                    Configure keys --DONE
                    Ctrl z
                    Cursor selection box --DONE
                    note.incurrentdragging -> so we don't have to search currentdragging every time
                    Snap to ms / scroll (grid)
                    History!!
                    Change ellipse grid to diagonal lines (bc we need to change scroll to utilize)
                    Move editor (freecam) --DONE
                    Make everything work with freecam --DONE
                    Add zoom for freecam
                    Check for nils on noteinfo
                    Fix changems grid (grid + snap)
                    Jump to ms
                    Command?
                        jump to ms
                        reset all
                        bulk set
                    incrementms with measure 1/4 etc

                    NOTES:
                    Modify oms so it doesn't get reverted
                    This is before enddrawing so that it can draw on the frame last minute, however it uses previous frame input
                    Dragging of multiple notes is planned, so each note is modified with some tags (aka garbage)
                ]]


                --Input

                local mouseposition = rl.GetMousePosition()
                
                local leftdown = rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT)
                local leftpressed = rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT)
                local leftreleased = rl.IsMouseButtonReleased(rl.MOUSE_BUTTON_LEFT)

                local rightdown = rl.IsMouseButtonDown(rl.MOUSE_BUTTON_RIGHT)
                local rightpressed = rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_RIGHT)
                local rightreleased = rl.IsMouseButtonReleased(rl.MOUSE_BUTTON_RIGHT)

                --See if we are hovering over any notes
                local x, y = mouseposition.x - editortemp.offset.x, mouseposition.y - editortemp.offset.y
                local hovernote = nil
                for i = 1, #loaded do
                    local note = loaded[i]
                    if note.data == 'note' then
                        if note.type == 8 then
                            --WARNING: pr for drumroll is modified
                            note.pr.x = (note.p[1] + offsetx) * scale[1]
                            note.pr.y = (note.p[2] + offsety) * scale[2]

                            --https://math.stackexchange.com/questions/76457/check-if-a-point-is-within-an-ellipse
                            local condition = ((x - note.pr.x) ^ 2 / (note.pr.width / 4) ^ 2 + (y - note.pr.y) ^ 2 / (note.pr.height / 4) ^ 2 <= 1)
                            if condition then
                                hovernote = note
                                break
                            end
                        elseif note.type == 5 or note.type == 6 then
                            local startnote = note
                            for i = 1, #startnote.drumrollbend do
                                local note = startnote.drumrollbend[i]

                                --https://math.stackexchange.com/questions/76457/check-if-a-point-is-within-an-ellipse
                                local condition = ((x - note.pr.x) ^ 2 / (note.pr.width / 4) ^ 2 + (y - note.pr.y) ^ 2 / (note.pr.height / 4) ^ 2 <= 1)
                                if condition then
                                    hovernote = note
                                    break
                                end
                            end

                            --https://math.stackexchange.com/questions/76457/check-if-a-point-is-within-an-ellipse
                            local condition = ((x - note.pr.x) ^ 2 / (note.pr.width / 4) ^ 2 + (y - note.pr.y) ^ 2 / (note.pr.height / 4) ^ 2 <= 1)
                            if condition then
                                hovernote = note
                                break
                            end
                        else
                            --https://math.stackexchange.com/questions/76457/check-if-a-point-is-within-an-ellipse
                            local condition = ((x - note.pr.x) ^ 2 / (note.pr.width / 4) ^ 2 + (y - note.pr.y) ^ 2 / (note.pr.height / 4) ^ 2 <= 1)
                            if condition then
                                hovernote = note
                                break
                            end
                        end
                    end
                end
                





                --leftpressed
                if leftpressed then
                    if hovernote == nil then
                        --box selection

                        editor.boxselection = true
                        editor.boxselectionpr.x = mouseposition.x
                        editor.boxselectionpr.y = mouseposition.y
                    else
                        editor.boxselection = false
                    end
                end

                --leftdown
                if leftdown then
                    if editor.boxselection then
                        editor.boxselectionpr.width = mouseposition.x - editor.boxselectionpr.x
                        editor.boxselectionpr.height = mouseposition.y - editor.boxselectionpr.y


                        --Handle rectangle logic

                        --Make sure width > 0 and height > 0
                        if editor.boxselectionpr.width < 0 then
                            editor.boxselectionpr2.x = editor.boxselectionpr.x + editor.boxselectionpr.width
                            editor.boxselectionpr2.width = -editor.boxselectionpr.width
                        else
                            editor.boxselectionpr2.x = editor.boxselectionpr.x
                            editor.boxselectionpr2.width = editor.boxselectionpr.width
                        end
                        if editor.boxselectionpr.height < 0 then
                            editor.boxselectionpr2.y = editor.boxselectionpr.y + editor.boxselectionpr.height
                            editor.boxselectionpr2.height = -editor.boxselectionpr.height
                        else
                            editor.boxselectionpr2.y = editor.boxselectionpr.y
                            editor.boxselectionpr2.height = editor.boxselectionpr.height
                        end


                        --Handle selection logic
                        local x1, x2 = editor.boxselectionpr2.x - editortemp.offset.x, editor.boxselectionpr2.x + editor.boxselectionpr2.width - editortemp.offset.x
                        local y1, y2 = editor.boxselectionpr2.y - editortemp.offset.y, editor.boxselectionpr2.y + editor.boxselectionpr2.height - editortemp.offset.y

                        --REINDEX EACH TIME
                        editor.currentdragging = {}
                        for i = 1, #loaded do
                            local note = loaded[i]
                            if (x1 < note.pr.x and note.pr.x < x2) and (y1 < note.pr.y and note.pr.y < y2) then
                                editor.currentdragging[#editor.currentdragging + 1] = note
                            end
                        end

                        --So the selected notes don't move
                        leftdown = false
                    end
                else
                    editor.boxselection = false
                end








                --Shortcuts

                if IsKeyDown(Config.Controls.PlaySong.Editor.Shortcut.Hold) then
                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.SelectAll) then
                        --Select all

                        editor.currentdragging = {}

                        for i = 1, #loaded do
                            local note = loaded[i]
                            if note.data == 'note' then
                                editor.currentdragging[#editor.currentdragging + 1] = note
                            end
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Copy) then
                        editor.clipboard = {}

                        for i = 1, #editor.currentdragging do
                            local note = editor.currentdragging[i]
                            editor.clipboard[#editor.clipboard + 1] = note
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Paste) then
                        --Clear selection
                        editor.currentdragging = {}

                        local note = editor.clipboard[1]
                        if not note then
                            GuiMessage('Nothing in clipboard')
                        else
                            local offsetx = mouseposition.x - note.pr.x - editortemp.offset.x
                            local offsety = mouseposition.y - note.pr.y - editortemp.offset.y


                            for i = 1, #editor.clipboard do
                                local note = editor.clipboard[i]

                                if note.data == 'event' and note.event == 'barline' then

                                else
                                    --Copy note
                                    local copy = {}
                                    for k, v in pairs(note) do
                                        local v2 = nil
                                        if k == 'pr' or k == 'osenotepr' or k == 'senotepr' then
                                            v2 = rl.new('Rectangle')
                                            v2.x = v.x
                                            v2.y = v.y
                                            v2.width = v.width
                                            v2.height = v.height
                                        elseif k == 'tcentero' or k == 'tcenter' then
                                            v2 = rl.new('Vector2')
                                            v2.x = v.x
                                            v2.y = v.y
                                        elseif k == 'speed' or k == 'p' then
                                            v2 = {}
                                            v2[1] = v[1]
                                            v2[2] = v[2]
                                        elseif k == 'editor' then
                                            v2 = nil
                                        else
                                            v2 = v
                                        end

                                        --[[
                                        if type(v) == 'cdata' then
                                            print(k, v)
                                        end
                                        --]]

                                        copy[k] = v2
                                    end


                                    do
                                        local note = copy

                                        note.editor = note.editor or {}

                                        --pr
                                        --WARNING: DEPRACATED SINCE PR FOR DRUMROLLEND IS MODIFIED --NVM
                                        -- [[
                                        note.editor.dragstartpr = note.editor.dragstartpr or rl.new('Vector2')
                                        note.editor.dragstartpr.x = note.pr.x
                                        note.editor.dragstartpr.y = note.pr.y
                                        --]]
                
                                        --p
                                        --WARNING: DEPRACATED SINCE P DOESNT SCALE
                                        --[[
                                        note.editor.dragstartp = note.editor.dragstartp or {}
                                        note.editor.dragstartp[1] = note.p[1]
                                        note.editor.dragstartp[2] = note.p[2]
                                        --]]
                
                                        note.editor.dragstartmousepr = note.editor.dragstartmousepr or rl.new('Vector2')
                                        note.editor.dragstartmousepr.x = mouseposition.x - offsetx
                                        note.editor.dragstartmousepr.y = mouseposition.y - offsety
                                    end

                                    calculaterotationr(copy)


                                    loaded[#loaded + 1] = copy
                                    Parsed.Data[#Parsed.Data + 1] = copy
                                    editor.currentdragging[#editor.currentdragging + 1] = copy
                                end
                            end

                            leftdown = true
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Cut) then
                        --TODO: Fully delete note
                        editor.clipboard = {}

                        for i = 1, #editor.currentdragging do
                            local note = editor.currentdragging[i]

                            editor.clipboard[#editor.clipboard + 1] = note

                            --Delete note
                            local offseti = 0
                            for i2raw = 1, #loaded do
                                local i2 = i2raw + offseti
                                local c = loaded[i2]
                                if c == note then
                                    table.remove(loaded, i2)
                                    offseti = offseti - 1
                                end
                            end

                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Save) then
                        dontincrements = true
                        --[[
                        local data = Taiko.ParseTJAFile('./Songs/00 Customs/taikobuipm/Ekiben 2000.tja')

                        local str = PersistentParsed.Save(data)
                        print(str, #str)
                        --]]


                        local path = FileDialog.Save('Save: Select editor save data location', nil, {'*.ppdc'}, nil, false)

                        if path then
                            --print(path)
                            local data = Parsed

                            --Header is also added here
                            local str = PersistentParsed.Save(data)

                            local f = io.open(path, 'wb+')
                            f:write(str)
                            f:close()

                            --Undo index
                            for i = 1, #Parsed.Data do
                                local note = Parsed.Data[i]
                                

                                --change nextnote, startnote, endnote into numbers
                                if note.nextnote then
                                    note.nextnote = Parsed.Data[note.nextnote]
                                end
                                if note.startnote then
                                    note.startnote = Parsed.Data[note.startnote]
                                end
                                if note.endnote then
                                    note.endnote = Parsed.Data[note.endnote]
                                end
                            end





                            --Reset rl.GetFrameTime (prevent weird jump)
                            --[[
                            rl.EndDrawing()
                            rl.BeginDrawing()
                            --]]
                            --WE NOW USE os.clock
                            --dontincrements = true

                            GuiMessage('Save: Success')
                        else
                            --TODO: Handle error
                            GuiMessage('Save: File not selected')
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Load) then
                        dontincrements = true

                        local path = FileDialog.Open('Load: Select editor save data location', nil, {'*.ppdc'}, nil, false)

                        if path then
                            --print(path)
                            local f = io.open(path, 'rb')
                            local str = f:read('*all')
                            f:close()

                            local data = PersistentParsed.Load(str)

                            if data then

                                --[[
                                --Set current parsed to loaded parsed
                                
                                --Parsed = data (doesn't work, notes are still linked through nextnote)
                                
                                Parsed = data
                                loaded = {}
                                nextnote = data[1]


                                --REMEMBER: Set endtime so song would end at the right time

                                --]]



                                --Reset rl.GetFrameTime (prevent weird jump)
                                --[[
                                rl.EndDrawing()
                                rl.BeginDrawing()
                                --]]
                                --WE NOW USE os.clock
                                --dontincrements = true


                                --NVM: Just open new window (instance)
                                --Then return what it returns, effectively ending this session (replace window basically)
                                --TODO: Accept retry
                                GuiMessage('Load: Success')

                                return Taiko.Play(data)

                            else
                                GuiMessage('Load: Invalid file data')
                            end
                        else
                            --TODO: Handle error
                            GuiMessage('Load: File not selected')
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Export) then
                        dontincrements = true
                        --[[
                        local data = Taiko.ParseTJAFile('./Songs/00 Customs/taikobuipm/Ekiben 2000.tja')

                        local str = PersistentParsed.Save(data)
                        print(str, #str)
                        --]]


                        local path = FileDialog.Save('Export: Select editor save data location', nil, {'*.tja'}, nil, false)

                        if path then



                            --Sort by ms + barline first always
                            --Sort all branches firt
                            for k, v in pairs(Parsed.Data) do
                                if v.branch then
                                    for k2, v2 in pairs(v.branch.paths) do
                                        table.sort(v2, function(a, b)
                                            --return a.ms < b.ms

                                            --switch to branches, this is too complex
                                            --[[
                                            if a.ms == b.ms then
                                                return a.data == 'event' and a.event == 'barline'
                                            else
                                                return a.ms < b.ms
                                            end
                                            --]]
                                            --nvm i can handle this
                                            --return (a.ms == b.ms) and (a.data == 'event' and a.event == 'barline') or (a.ms < b.ms)

                                            --v3 handles the case when 2 barlines have same ms
                                            return (a.ms == b.ms) and (a.data == 'event' and a.event == 'barline' and not (b.data == 'event' and b.event == 'barline')) or (a.ms < b.ms)
                                        end)
                                    end
                                end
                            end


                            --Path doesn't matter, they should all have same loadms
                            table.sort(Parsed.Data, function(a, b)
                                if a.branch and b.branch then
                                    --both branches
                                    for k, v in pairs(a.branch.paths) do
                                        for k2, v2 in pairs(b.branch.paths) do
                                            return v[1].ms < v2[1].ms
                                        end
                                    end
                                elseif a.branch then
                                    --a is branch
                                    for k, v in pairs(a.branch.paths) do
                                        return v[1].ms < b.ms
                                    end
                                elseif b.branch then
                                    --b is branch
                                    for k, v in pairs(b.branch.paths) do
                                        return a.ms < v[1].ms
                                    end
                                else
                                    --notes
                                    --return a.ms < b.ms

                                    --switch to branches, this is too complex
                                    --[[
                                    if a.ms == b.ms then
                                        return a.data == 'event' and a.event == 'barline'
                                    else
                                        return a.ms < b.ms
                                    end
                                    --]]
                                    --nvm i can handle this
                                    --return (a.ms == b.ms) and (a.data == 'event' and a.event == 'barline') or (a.ms < b.ms)

                                    --v3 handles the case when 2 barlines have same ms
                                    return (a.ms == b.ms) and (a.data == 'event' and a.event == 'barline' and not (b.data == 'event' and b.event == 'barline')) or (a.ms < b.ms)
                                end
                            end)







                            --print(path)
                            local data = Parsed

                            --tja
                            --Note: We are encapsulating Parsed in a table since it wants all difficulties
                            local str = Taiko.SerializeTJA({data})

                            local f = io.open(path, 'wb+')
                            f:write(str)
                            f:close()






                            --Reset rl.GetFrameTime (prevent weird jump)
                            --[[
                            rl.EndDrawing()
                            rl.BeginDrawing()
                            --]]
                            --WE NOW USE os.clock
                            --dontincrements = true

                            GuiMessage('Export: Success')
                        else
                            --TODO: Handle error
                            GuiMessage('Export: File not selected')
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Import) then
                        dontincrements = true

                        local path = FileDialog.Open('Import: Select editor save data location', nil, {'*.tja'}, nil, false)

                        if path then
                            --print(path)
                            local Parsed, Error = Taiko.ParseTJAFile(path)

                            if Parsed then
                                local SelectedDifficulty = Taiko.RayGuiDifficulty()
                                local data = Taiko.GetDifficulty(Parsed, SelectedDifficulty)

                                --[[
                                --Set current parsed to loaded parsed
                                
                                --Parsed = data (doesn't work, notes are still linked through nextnote)
                                
                                Parsed = data
                                loaded = {}
                                nextnote = data[1]


                                --REMEMBER: Set endtime so song would end at the right time

                                --]]



                                --Reset rl.GetFrameTime (prevent weird jump)
                                --[[
                                rl.EndDrawing()
                                rl.BeginDrawing()
                                --]]
                                --WE NOW USE os.clock
                                --dontincrements = true


                                --NVM: Just open new window (instance)
                                --Then return what it returns, effectively ending this session (replace window basically)
                                --TODO: Accept retry
                                GuiMessage('Import: Success')

                                return Taiko.Play(data)
                            else
                                --Handle Parsed Error
                                error(Error)
                            end
                        else
                            --TODO: Handle error
                            GuiMessage('Import: File not selected')
                        end
                    end

                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.ClearAll) then
                        dontincrements = true

                        --ACTUALLY CONFIRM, THIS WILL DELETE EVERYTHING
                        local v = GuiSuperWarn('Are you sure you want to delete this chart?\nTHIS ACTION CANNOT BE DONE,\nAND EVERYTHING WILL BE DELETED', tostring(math.random(0, 1000000000)))
                        if v then
                            --TODO: Delete chart
                            --Just import a blank chart
                            --Also TODO: new note


                            --Import default tja
                            local path = Config.Settings.Defaults.ClearAllPath

                            if path then
                                --print(path)
                                local Parsed, Error = Taiko.ParseTJAFile(path)
    
                                if Parsed then
                                    local SelectedDifficulty = Taiko.RayGuiDifficulty()
                                    local data = Taiko.GetDifficulty(Parsed, SelectedDifficulty)
    
                                    --[[
                                    --Set current parsed to loaded parsed
                                    
                                    --Parsed = data (doesn't work, notes are still linked through nextnote)
                                    
                                    Parsed = data
                                    loaded = {}
                                    nextnote = data[1]
    
    
                                    --REMEMBER: Set endtime so song would end at the right time
    
                                    --]]
    
    
    
                                    --Reset rl.GetFrameTime (prevent weird jump)
                                    --[[
                                    rl.EndDrawing()
                                    rl.BeginDrawing()
                                    --]]
                                    --WE NOW USE os.clock
                                    --dontincrements = true
    
    
                                    --NVM: Just open new window (instance)
                                    --Then return what it returns, effectively ending this session (replace window basically)
                                    --TODO: Accept retry
                                    GuiMessage('ClearAll: Success')
    
                                    return Taiko.Play(data)
                                else
                                    --Handle Parsed Error
                                    error(Error)
                                end
                            else
                                --TODO: Handle error
                                GuiMessage('ClearAll: File not selected')
                            end


                            --GuiMessage('ClearAll: Chart deleted')
                        else
                            GuiMessage('ClearAll: Action cancelled')
                        end
                    end
                end





                if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Delete) then
                    --TODO: Fully delete note
                    for i = 1, #editor.currentdragging do
                        local note = editor.currentdragging[i]

                        --Delete note
                        local offseti = 0
                        for i2raw = 1, #loaded do
                            local i2 = i2raw + offseti
                            local c = loaded[i2]
                            if c == note then
                                table.remove(loaded, i2)
                                offseti = offseti - 1
                            end
                        end
                    
                    end
                end
                
                if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.Snap) then
                    --Snap selection on mouseposition
                    leftdown = true
                end

                if IsKeyPressed(Config.Controls.PlaySong.Editor.ToggleDragMode) then
                    --Toggle dragging mode (changingscroll: false <-> true)
                    editor.changingscroll = not editor.changingscroll
                end

                if IsKeyPressed(Config.Controls.PlaySong.Editor.ToggleGrid) then
                    --Toggle dragging mode (changingscroll: false <-> true)
                    editor.grid.on = not editor.grid.on
                end

                --Move selection with arrow keys
                local useiskeydown = not editor.movingnotes
                local addmove = false
                local movex = 0
                local movey = 0
                if (useiskeydown and IsKeyDown or IsKeyPressed)(Config.Controls.PlaySong.Editor.Move.Left) then
                    movex = movex - Config.Controls.PlaySong.Editor.Move.MoveIncrement
                end
                if (useiskeydown and IsKeyDown or IsKeyPressed)(Config.Controls.PlaySong.Editor.Move.Right) then
                    movex = movex + Config.Controls.PlaySong.Editor.Move.MoveIncrement
                end
                if (useiskeydown and IsKeyDown or IsKeyPressed)(Config.Controls.PlaySong.Editor.Move.Up) then
                    movey = movey - Config.Controls.PlaySong.Editor.Move.MoveIncrement
                end
                if (useiskeydown and IsKeyDown or IsKeyPressed)(Config.Controls.PlaySong.Editor.Move.Down) then
                    movey = movey + Config.Controls.PlaySong.Editor.Move.MoveIncrement
                end
                if not editor.movingnotes then
                    --Zoom in, zoom out
                    if IsKeyDown(Config.Controls.PlaySong.Editor.Move.ZoomIn) then
                        --Move editor around
                        local zoommul = Config.Controls.PlaySong.Editor.Move.ZoomMultiplier
                        editortemp.scale.x = editortemp.scale.x * zoommul
                        editortemp.scale.y = editortemp.scale.y * zoommul
                    end
                    
                    if IsKeyDown(Config.Controls.PlaySong.Editor.Move.ZoomOut) then
                        --Move editor around
                        local zoommul = Config.Controls.PlaySong.Editor.Move.ZoomMultiplier
                        editortemp.scale.x = editortemp.scale.x / zoommul
                        editortemp.scale.y = editortemp.scale.y / zoommul
                    end

                    if leftpressed then

                    end
                    if leftdown then

                    end

                    local scroll = rl.GetMouseWheelMoveV().y
                    if scroll ~= 0 then
                        -- Config.Controls.PlaySong.Editor.Move.ZoomMultiplier = 1.01
                        local zoommul = scroll > 0 and Config.Controls.PlaySong.Editor.Move.ZoomMultiplier or 1/Config.Controls.PlaySong.Editor.Move.ZoomMultiplier
                        local beforex, beforey = mouseposition.x * editortemp.scale.x + editortemp.offset.x, mouseposition.y * editortemp.scale.y + editortemp.offset.y
                        editortemp.scale.x = editortemp.scale.x * zoommul
                        editortemp.scale.y = editortemp.scale.y * zoommul
                        local afterx, aftery = mouseposition.x * editortemp.scale.x + editortemp.offset.x, mouseposition.y * editortemp.scale.y + editortemp.offset.y
                        print(afterx - beforex, aftery - beforey)
                        editortemp.offset.x = editortemp.offset.x - (afterx - beforex)
                        editortemp.offset.y = editortemp.offset.y - (aftery - beforey)
                    end

                else
                    --TODO: Enlarge, shrink note radius?
                end

                if IsKeyPressed(Config.Controls.PlaySong.Editor.Move.Toggle) then
                    --Toggle moving mode (movingnotes: true <-> false)
                    --if not moving notes then we are moving the camera
                    editor.movingnotes = not editor.movingnotes
                    if not editor.movingnotes then
                        --Load ALL notes
                        --DIRTY
                        local c = nextnote
                        while true do
                            if c then
                                c.loadms = 0
                                c = c.nextnote
                            else
                                break
                            end
                        end
                    end
                end

                if IsKeyDown(Config.Controls.PlaySong.Editor.Move.SpeedUpHold) then
                    movex = movex * Config.Controls.PlaySong.Editor.Move.SpeedUpMultiplier
                    movey = movey * Config.Controls.PlaySong.Editor.Move.SpeedUpMultiplier
                end

                if IsKeyPressed(Config.Controls.PlaySong.Editor.Move.MoveEditor.Reset) then
                    --Move editor around
                    local v = editortemp.offset

                    --REMEMBER, REVERSED since this offset is just added
                    v.x = 0
                    v.y = 0
                end


                if not (movex == 0 and movey == 0) then
                    movex = movex * deltamultiplier * scale[1]
                    movey = movey * deltamultiplier * scale[2]

                    --print(movex, movey)
                    if editor.movingnotes then
                        --Move all selected

                        --The movex, movey will be added later (right before pr)
                        addmove = true
                    else
                        --Move editor around
                        local v = editortemp.offset

                        --REMEMBER, REVERSED since this offset is just added
                        v.x = v.x - movex
                        v.y = v.y - movey

                    end
                end



                


                --Shortcuts (Originally from Debug) (Modified to fit with editor shortcuts and be without debug hold key)

                --Shortcuts (Editor) key not active

                if not IsKeyDown(Config.Controls.PlaySong.Editor.Shortcut.Hold) then

                    --New note
                    if IsKeyPressed(Config.Controls.PlaySong.Editor.Shortcut.New) then
                        
                    end


                    --Toggle auto
                    if IsKeyPressed(Config.Controls.PlaySong.Debug.ToggleAuto) then
                        auto = not auto
                    end
                    --Retry
                    if IsKeyPressed(Config.Controls.PlaySong.Debug.Retry) then
                        return false
                    end


                end


                --Not moving editor and no notes selected
                if editor.movingnotes and #editor.currentdragging == 0 then
                   
                    --Time
                    if IsKeyDown(Config.Controls.PlaySong.Debug.Backward) then
                        s = s - (Config.Controls.PlaySong.Debug.BackwardIncrement * deltamultiplier)

                        --respawn notes


                        --loop over loaded (possibility of drumroll rewind)
                        --NOPE: drumroll is stored in drumrollqueue
                        --[[
                        for i = 1, #loaded do
                            local note = loaded[i]
                            --rewind combo and score
                            if note.addcombo then
                                combo = combo - note.addcombo
                                note.addcombo = nil
                            end
                            if note.addscore then
                                score = score - note.addscore
                                note.addscore = nil
                            end
                            if note.addgauge then
                                gauge = gauge - note.addgauge
                                note.addgauge = nil
                            end
                        end
                        --]]

                        --loop over done
                        local offseti = 0
                        for i = 1, #done do
                            local i2 = i + offseti
                            local note = done[i2]
                            if note.done and note.done >= s then
                                --note
                                --rewind combo and score
                                if note.addcombo then
                                    combo = combo - note.addcombo
                                    note.addcombo = nil
                                end
                                if note.addscore then
                                    score = score - note.addscore
                                    note.addscore = nil
                                end
                                if note.addgauge then
                                    gauge = gauge - note.addgauge
                                    note.addgauge = nil
                                end

                                --now queue and note branch out
                                if note.queue then
                                    --queue
                                    --readd to queue
                                    note.done = nil
                                    note.queue[#note.queue + 1] = note
                                else
                                    note.done = nil
                                    note.hit = nil
                                    note.addcombo = nil
                                    note.addscore = nil
                                    loaded[#loaded + 1] = note
                                end
                                table.remove(done, i2)
                                offseti = offseti - 1
                            end
                        end
                        
                        forceresync = true
                    end
                    if IsKeyDown(Config.Controls.PlaySong.Debug.Forward) then
                        s = s + (Config.Controls.PlaySong.Debug.ForwardIncrement * deltamultiplier)
                        
                        forceresync = true
                    end
                    
                    
                    
                    
                    
                    
                    
                    --runtimespeed
                    if IsKeyPressed(Config.Controls.PlaySong.Debug.RunTimeSpeed.Slower) then
                        if freezems then
                            freezemstemp = freezemstemp / Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                        else
                            runtimespeed = runtimespeed / Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                        end
                    end
                    if IsKeyPressed(Config.Controls.PlaySong.Debug.RunTimeSpeed.Faster) then
                        if freezems then
                            freezemstemp = freezemstemp * Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                        else
                            runtimespeed = runtimespeed * Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                        end
                    end
                end



                --freezems
                if IsKeyPressed(Config.Controls.PlaySong.Debug.Freeze) then
                    freezems = not freezems

                    --Force resync if unfroze
                    if freezems == false then
                        forceresync = true
                    end
                end

                --Savestates
                --[[
                    Notes:
                    For function keys, here is the mapping:
                        f1: command
                        f2-f10: slots
                        f11: fullscreen
                        f12: raylib screenshot / gif (can't disable)
                ]]
                --TODO USE Fn keys
                --TODO: Error handling for loading: when loading nonexistant slot
                --TODO: Text feedback: ex: you loaded slot 2, you saved to slot 2
                if IsKeyDown(Config.Controls.PlaySong.Debug.SaveState.Save.Hold) then
                    local a = IsKeyPressed2(Config.Controls.PlaySong.Debug.SaveState.Save.Slot)
                    if a then
                        dontincrements = true
                        
                        local success, out = SaveState.SaveSlot(a)
                        --success should always be true, there is no way that saving can fail
                        if success then
                            --io.open('taikov34_serialized.lua','w+'):write(Serialize.Save(out))
                            print('SaveSlot: Saved to slot ' .. a)
                        end
                    end
                else
                    local a = IsKeyPressed2(Config.Controls.PlaySong.Debug.SaveState.Load.Slot)
                    if a then
                        local success = SaveState.LoadSlot(a)
                        if success then
                            print('SaveSlot: Loaded from slot ' .. a)
                        else
                            print('SaveSlot: Unable to find slot ' .. a)
                        end
                    end
                end

                --Jump to ms
                if rl.IsKeyPressed(83) then
                    --TODO: Also add jump to line in tja
                    local a = GuiInput('Enter where you want to jump to\n(seconds) (ONLY GO FORWARDS)')
                    if a then
                        s = a
                        ms = s * 1000
                    end
                end






















                --Note info

                --Display note statistics
                if hovernote then
                    --Draw over everything (next frame)
                    editor.info.hovernote = hovernote
                end







                --Note editing



                --Set current dragging note
                if leftpressed then
                    if hovernote then
                        local found = nil
                        for i = 1, #editor.currentdragging do
                            if editor.currentdragging[i] == hovernote then
                                found = i
                                break
                            end
                        end

                        if IsKeyDown(Config.Controls.PlaySong.Editor.ModifySelectionHold) then
                            --Modifying selection

                            if found then
                                --Remove from selection
                                table.remove(editor.currentdragging, i)
                            else
                                --Add to selection
                                editor.currentdragging[#editor.currentdragging + 1] = hovernote
                            end
                        else
                            --Dragging selection

                            if found then

                            else
                                --Clear selection
                                editor.currentdragging = {}

                                --Add to selection
                                editor.currentdragging[#editor.currentdragging + 1] = hovernote
                            end
                        end
                    else
                        --Clear selection
                        editor.currentdragging = {}
                    end
                end




                --Grid selection
                if #editor.currentdragging == 1 then
                    local note = editor.currentdragging[1]
                    if editor.grid.selected == nil or (editor.changingscroll == not editor.grid.isrect) or (editor.grid.selected ~= note) or editor.changingscroll then
                        editor.grid.selected = note

                        --Determine width and height
                        if editor.changingscroll then
                            editor.grid.isrect = true

                            local ms = stopfreezems or ((note.movemsa and (ms >= note.movemsa and ms or note.movemsa) or ms) + totaldelay)

                            --Get scroll from speed (REVERSED)
                            --AKA Get speed from scroll

                            local displayratio = OriginalConfig.ScreenWidth / 1280

                            --Taken from Taiko.CalculateSpeedInterval
                            local interval = 960
                            local speed1 = (note.bpm / 240000 * (editor.grid.scrollincrement) * interval * displayratio)
                            local speed2 = (note.bpm / 240000 * (editor.grid.scrollincrement) * interval * displayratio)

                            editor.grid.pr.width = speed1 * (note.ms - ms)
                            editor.grid.pr.height = speed2 * (note.ms - ms)

                            --Center on target
                            editor.grid.pr.x = targetpr.x
                            editor.grid.pr.y = targetpr.y
                        else
                            --[=[
                            editor.grid.isrect = false

                            --d = st
                            local d1 = (editor.grid.msincrement) * note.speed[1]
                            local d2 = (editor.grid.msincrement) * note.speed[2]

                            --Account for diagonal distance

                            editor.grid.pr.width = d1
                            editor.grid.pr.height = d2

                            --]=]

                            editor.grid.isrect = true


                            --v2
                            local d1 = (editor.grid.msincrement) * note.speed[1]
                            local d2 = (editor.grid.msincrement) * note.speed[2]

                            --Account for diagonal distance

                            editor.grid.pr.width = math.sqrt(d1 ^ 2 + d2 ^ 2)
                            editor.grid.pr.height = Config.ScreenHeight










                            --Center on note
                            --[[
                            editor.grid.pr.x = note.pr.x
                            editor.grid.pr.y = note.pr.y
                            --]]

                            --Center on target
                            editor.grid.pr.x = targetpr.x
                            editor.grid.pr.y = targetpr.y
                        end

                        --Absolute value
                        editor.grid.pr.width = math.abs(editor.grid.pr.width)
                        editor.grid.pr.height = math.abs(editor.grid.pr.height)
                        --print(editor.grid.pr.width)

                        --Safety checks
                        if editor.grid.pr.width < editor.grid.smallest then
                            editor.grid.pr.width = Config.ScreenWidth * 2
                        end
                        if editor.grid.pr.height < editor.grid.smallest then
                            editor.grid.pr.height = Config.ScreenHeight * 2
                        end
                    end
                else
                    editor.grid.isrect = true

                    editor.grid.selected = nil

                    --Center on target
                    editor.grid.pr.x = targetpr.x
                    editor.grid.pr.y = targetpr.y

                    --Default Width and Height
                    editor.grid.pr.width = tsizex / 4
                    editor.grid.pr.height = tsizey / 4
                end






                for i = 1, #editor.currentdragging do
                    local note = editor.currentdragging[i]


                    --Dragging of notes
                    if leftpressed or (not note.editor) then
                        note.editor = note.editor or {}

                        --pr
                        --WARNING: DEPRACATED SINCE PR FOR DRUMROLLEND IS MODIFIED --NVM
                        note.editor.dragstartpr = note.editor.dragstartpr or rl.new('Vector2')
                        note.editor.dragstartpr.x = note.pr.x
                        note.editor.dragstartpr.y = note.pr.y


                        note.editor.dragstartmousepr = note.editor.dragstartmousepr or rl.new('Vector2')
                        note.editor.dragstartmousepr.x = mouseposition.x
                        note.editor.dragstartmousepr.y = mouseposition.y
                    end
                    if leftdown or addmove then
                        if addmove then
                            note.pr.x = note.pr.x + movex
                            note.pr.y = note.pr.y + movey
                        else
                            --pr
                            --WARNING: DEPRACATED SINCE PR FOR DRUMROLLEND IS MODIFIED --NVM
                            note.pr.x = note.editor.dragstartpr.x + (mouseposition.x - note.editor.dragstartmousepr.x)
                            note.pr.y = note.editor.dragstartpr.y + (mouseposition.y - note.editor.dragstartmousepr.y)


                            if editor.grid.on and editor.grid.selected then
                                --Snap to grid
                                local pr = editor.grid.pr
                                local prw, prh = pr.width * scale[1], pr.height * scale[2]
                                local x = (note.pr.x - pr.x) / (prw)
                                local y = (note.pr.y - pr.y) / (prh)
    
                                --Round to nearest grid line (integer) and multiply back with grid width and height and add back pr.x, pr.y
                                note.pr.x = math.floor(x + 0.5) * prw + pr.x
                                note.pr.y = math.floor(y + 0.5) * prh + pr.y
                            end
                        end




                        if editor.changingscroll then

                            --Get speed from position

                            local ms = stopfreezems or ((note.movemsa and (ms >= note.movemsa and ms or note.movemsa) or ms) + totaldelay)

                            --s = d / t
                            --pr
                            --WARNING: DEPRACATED SINCE PR FOR DRUMROLLEND IS MODIFIED --NVM
                            --Taken from CalculatePosition
                            note.speed[1] = (target[1] - ((note.pr.x / scale[1] - offsetx) / xmul)) / (note.ms - ms - note.delay)
                            note.speed[2] = (target[2] - ((note.pr.y / scale[2] - offsety) / ymul)) / (note.ms - ms - note.delay)



                            --Convert into scroll so it doesn't get reverted

                            --Get scroll from speed

                            local displayratio = OriginalConfig.ScreenWidth / 1280

                            --Taken from Taiko.CalculateSpeedInterval
                            local interval = 960
                            note.scrollx = note.speed[1] / note.bpm * 240000 / interval / displayratio
                            note.scrolly = note.speed[2] / note.bpm * 240000 / interval / displayratio
                            calculaterotationr(note)
                        else

                            --Get speed from position (copied from editor.changingscroll) (MODIFIED to not modify speed)

                            local ms = stopfreezems or ((note.movemsa and (ms >= note.movemsa and ms or note.movemsa) or ms) + totaldelay)

                            --pr
                            --WARNING: DEPRACATED SINCE PR FOR DRUMROLLEND IS MODIFIED --NVM
                            --Taken from CalculatePosition
                            --if note.speed[1] ~= 0 then
                            if math.abs(note.speed[1]) >= math.abs(note.speed[2]) then
                                note.ms = ((target[1] - ((note.pr.x / scale[1] - offsetx) / xmul)) / (note.speed[1])) + ms + note.delay
                            else
                                note.ms = ((target[2] - ((note.pr.y / scale[2] - offsety) / ymul)) / (note.speed[2])) + ms + note.delay
                            end

                            --Convert into oms so it doesn't get reverted
                            --v.ms = (v.ms - startms) / songspeedmul
                            note.oms = note.ms * songspeedmul + startms
                            
                            
                        end
                    end
                end

                

            end






















            --DEBUG
            if IsKeyDown(Config.Controls.PlaySong.Debug.Hold) then

                --Toggle auto
                if IsKeyPressed(Config.Controls.PlaySong.Debug.ToggleAuto) then
                    auto = not auto
                end
                --Retry
                if IsKeyPressed(Config.Controls.PlaySong.Debug.Retry) then
                    return false
                end
                
                --Time
                if IsKeyDown(Config.Controls.PlaySong.Debug.Backward) then
                    s = s - (Config.Controls.PlaySong.Debug.BackwardIncrement * deltamultiplier)

                    --respawn notes


                    --loop over loaded (possibility of drumroll rewind)
                    --NOPE: drumroll is stored in drumrollqueue
                    --[[
                    for i = 1, #loaded do
                        local note = loaded[i]
                        --rewind combo and score
                        if note.addcombo then
                            combo = combo - note.addcombo
                            note.addcombo = nil
                        end
                        if note.addscore then
                            score = score - note.addscore
                            note.addscore = nil
                        end
                        if note.addgauge then
                            gauge = gauge - note.addgauge
                            note.addgauge = nil
                        end
                    end
                    --]]

                    --loop over done
                    local offseti = 0
                    for i = 1, #done do
                        local i2 = i + offseti
                        local note = done[i2]
                        if note.done and note.done >= s then
                            --note
                            --rewind combo and score
                            if note.addcombo then
                                combo = combo - note.addcombo
                                note.addcombo = nil
                            end
                            if note.addscore then
                                score = score - note.addscore
                                note.addscore = nil
                            end
                            if note.addgauge then
                                gauge = gauge - note.addgauge
                                note.addgauge = nil
                            end

                            --now queue and note branch out
                            if note.queue then
                                --queue
                                --readd to queue
                                note.done = nil
                                note.queue[#note.queue + 1] = note
                            else
                                note.done = nil
                                note.hit = nil
                                note.addcombo = nil
                                note.addscore = nil
                                loaded[#loaded + 1] = note
                            end
                            table.remove(done, i2)
                            offseti = offseti - 1
                        end
                    end
                    
                    forceresync = true
                end
                if IsKeyDown(Config.Controls.PlaySong.Debug.Forward) then
                    s = s + (Config.Controls.PlaySong.Debug.ForwardIncrement * deltamultiplier)
                    
                    forceresync = true
                end

                --Savestates
                --[[
                    Notes:
                    For function keys, here is the mapping:
                        f1: command
                        f2-f10: slots
                        f11: fullscreen
                        f12: raylib screenshot / gif (can't disable)
                ]]
                --TODO USE Fn keys
                --TODO: Error handling for loading: when loading nonexistant slot
                --TODO: Text feedback: ex: you loaded slot 2, you saved to slot 2
                if IsKeyDown(Config.Controls.PlaySong.Debug.SaveState.Save.Hold) then
                    local a = IsKeyPressed2(Config.Controls.PlaySong.Debug.SaveState.Save.Slot)
                    if a then
                        local success, out = SaveState.SaveSlot(a)
                        --success should always be true, there is no way that saving can fail
                        if success then
                            --io.open('taikov34_serialized.lua','w+'):write(Serialize.Save(out))
                            print('SaveSlot: Saved to slot ' .. a)
                        end
                    end
                else
                    local a = IsKeyPressed2(Config.Controls.PlaySong.Debug.SaveState.Load.Slot)
                    if a then
                        local success = SaveState.LoadSlot(a)
                        if success then
                            print('SaveSlot: Loaded from slot ' .. a)
                        else
                            print('SaveSlot: Unable to find slot ' .. a)
                        end
                    end
                end


                --runtimespeed
                if IsKeyPressed(Config.Controls.PlaySong.Debug.RunTimeSpeed.Slower) then
                    if freezems then
                        freezemstemp = freezemstemp / Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                    else
                        runtimespeed = runtimespeed / Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                    end
                end
                if IsKeyPressed(Config.Controls.PlaySong.Debug.RunTimeSpeed.Faster) then
                    if freezems then
                        freezemstemp = freezemstemp * Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                    else
                        runtimespeed = runtimespeed * Config.Controls.PlaySong.Debug.RunTimeSpeed.FasterMultiplier
                    end
                end

                --freezems
                if IsKeyPressed(Config.Controls.PlaySong.Debug.Freeze) then
                    freezems = not freezems

                    --Force resync if unfroze
                    if freezems == false then
                        forceresync = true
                    end
                end

            end







            



            --Handle other special input
            if rl.WindowShouldClose() then
                rl.CloseWindow()
                error() --Don't do more draw calls When closing window
                break
            end

            --Resizable window
            --if sizex ~= Config.ScreenWidth or sizey ~= Config.ScreenHeight then
            if rl.IsWindowResized() and (not Config.Fullscreen) then
                local sizex, sizey = rl.GetScreenWidth(), rl.GetScreenHeight()
                if sizex ~= Config.ScreenWidth or sizey ~= Config.ScreenHeight then
                    --print(Config.ScreenWidth, Config.ScreenHeight, sizex, sizey)
                    ResizeAll(Textures, sizex / Config.ScreenWidth, sizey / Config.ScreenHeight)
                    Config.ScreenWidth, Config.ScreenHeight = sizex, sizey
                end
            end

            --Fullscreen
            if IsKeyPressed(Config.Controls.PlaySong.Fullscreen) then
                local rx, ry = ToggleFullscreen()

                --RESCALE EVERYTHING
                ResizeAll(Textures, rx, ry)

                forceresync = true
            end

            --Screenshot
            if IsKeyPressed(Config.Controls.PlaySong.Screenshot) then
                --[[
                --might produce a screenshot with black waste parts due to gpu
                rl.TakeScreenshot(ScreenshotPath)
                --]]

                -- [[
                --reliable
                local image = rl.LoadImageFromScreen()
                rl.ExportImage(image, GetTimestampFilename(Config.Paths.Screenshots, Config.Formats.Screenshot))
                rl.UnloadImage(image)
                --]]

                forceresync = true
            end
            --[[
            if IsKeyPressed(Config.Controls.PlaySong.R) then
                s = s + 1
            end
            --]]

            --Pause / Command
            local commandactivated = IsKeyPressed(Config.Controls.PlaySong.Command.Init)
            if IsKeyPressed(Config.Controls.PlaySong.Pause.Init) or commandactivated then
                -- profiler.report('profiler2.log')error()

                dontincrements = true

                local before = os.clock()

                rl.EndDrawing()

                local stillimage = rl.LoadImageFromScreen()
                local stilltexture = rl.LoadTextureFromImage(stillimage)

                --Pause Menu
                local Selected = 1 --option selected
                local Options = {
                    'Back to game',
                    'Retry',
                    'Quit',
                }

                --Command
                local str, x, y, move, moving, out, consoletext, log, prompt, logtext, textbackground, textbackgroundt, textbackgroundrect, textbackgroundcenter, textbackgroundsourcerect
                if commandactivated then
                    str = {
                        'Console',
                        '\nS: ', tostring(s),
                        '\nMs: ', tostring(ms),
                        '\nGogo: ', tostring(gogo),
                        '\nLoaded: ', tostring(#loadedrfinal),
                        '\nFramen: ', framen,
                        '\nnextnote.loadms: ', tostring(nextnote and nextnote.loadms),
                        '\nnextnote.n: ', tostring(nextnote and nextnote.n),
                        '\nballoonstart: ', tostring(balloonstart),
                        '\nballoonend: ', tostring(balloonend),
                        '\n\nMemory usage (mb): ', collectgarbage('count') / 1000,
                        '\nFinished (%): ', ms / (endms) * 100,
                        '\n\n'
                    }
                    strtext = table.concat(str)
                    x, y = 0, 360/720 * Config.ScreenHeight
                    move = 1
                    moving = false

                    out = {}
                    consoletext = ''
                    log = {

                    }
                    logtext = ''
                    prompt = 'Console: '
                    
                    textbackground = rl.ImageFromImage(stillimage, rl.new('Rectangle', 0, 0, 1, 1))
                    rl.ImageDrawPixel(textbackground, 0, 0, rl.new('Color', 0, 0, 0, 255 / 2))
                    textbackgroundt = rl.LoadTextureFromImage(textbackground)
                    rl.UnloadImage(textbackground)
                    textbackgroundsourcerect = rl.new('Rectangle', 0, 0, 1, 1)
                    textbackgroundrect = rl.new('Rectangle', 0, 0, 1, 1)
                    textbackgroundcenter = rl.new('Vector2', 0, 0)
                end
                
                rl.UnloadImage(stillimage)


                --loop for input
                while true do
                    rl.BeginDrawing()

                    rl.ClearBackground(rl.RAYWHITE)

                    --draw stilltexture
                    rl.DrawTexture(stilltexture, 0, 0, rl.WHITE)

                    if commandactivated then
                        --draw textbackground
                        local textfinal = strtext .. logtext .. prompt .. consoletext
                        textbackgroundrect.x, textbackgroundrect.y = x, y
                        textbackgroundrect.width, textbackgroundrect.height = GetTextSize(textfinal, textsize)
                        rl.DrawTexturePro(textbackgroundt, textbackgroundsourcerect, textbackgroundrect, textbackgroundcenter, 0, rl.WHITE)

                        --draw text
                        rl.DrawText(textfinal, x, y, textsize, rl.RAYWHITE)
                    end


                    --Draw options
                    for i = 1, #Options do
                        rl.DrawText((i == Selected and '> ' or '') .. Options[i], Config.ScreenWidth / 2, Config.ScreenHeight / 2 + (
                            (
                                i - --subtract
                                (#Options + 1) / 2 --get middle of Options
                            ) * fontsize --multiply
                        ), fontsize, rl.BLACK)
                    end

                    rl.EndDrawing()

                    --Command
                    if commandactivated then
                        if IsKeyPressed(Config.Controls.PlaySong.Command.Move.Toggle) then
                            moving = not moving
                        end

                        if moving then
                            if IsKeyDown(Config.Controls.PlaySong.Command.Move.Left) then
                                x = x - move
                            end
                            if IsKeyDown(Config.Controls.PlaySong.Command.Move.Right) then
                                x = x + move
                            end
                            if IsKeyDown(Config.Controls.PlaySong.Command.Move.Up) then
                                y = y - move
                            end
                            if IsKeyDown(Config.Controls.PlaySong.Command.Move.Down) then
                                y = y + move
                            end
                        end



                        --Console
                        while true do
                            local c = rl.GetCharPressed()
                            if c == 0 then
                                break
                            else
                                out[#out + 1] = c
                                --Update display
                                consoletext = utf8Encode(out)
                            end
                        end
            
                        --Remember, GetCharPressed doesn't detect special keys
                        if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
                            out[#out] = nil
                            --Update display
                            consoletext = utf8Encode(out)
                        end
                        if rl.IsKeyPressed(rl.KEY_ENTER) then
                            --out = utf8Encode(out)
                        end


                    end
                    


                    --Input
                    if IsKeyPressed(Config.Controls.PlaySong.Pause.Escape) then
                        break
                    end
                    if IsKeyPressed(Config.Controls.PlaySong.Pause.U) then
                        Selected = Selected - 1
                    end
                    if IsKeyPressed(Config.Controls.PlaySong.Pause.D) then
                        Selected = Selected + 1
                    end
                    Selected = ClipN(Selected, 1, #Options)
                    if IsKeyPressed(Config.Controls.PlaySong.Pause.Select) then
                        if Selected == 1 then
                            --Back to game
                            break
                        elseif Selected == 2 then
                            --Retry
                            ResetResizeAll()
                            return false
                        elseif Selected == 3 then
                            --Quit
                            ResetResizeAll()
                            return nil
                        else

                        end
                    end


                    
                    if rl.WindowShouldClose() then
                        --rl.CloseWindow()
                        break
                    end
                    
                end

                rl.EndDrawing()

                rl.UnloadTexture(stilltexture)

                forceresync = true --force music resync on next frame

                startt = startt + (os.clock() - before)
            end









            --Freeze (freezems)
            if freezems then
                if not freezemstemp then
                    freezemstemp = runtimespeed
                    runtimespeed = 0
                end
            elseif freezemstemp then
                runtimespeed = freezemstemp
                freezemstemp = nil
            end








































            --[=====[]



            --Pause menu
            if Controls.Escape[key] then
                local before = os.clock()

                Ansi.ClearScreen()
                curses.nodelay(window, false)
                --Back, Retry, Song Select
                local Menu = {'Back', 'Retry', 'Back to Select'}
                while true do
                    Ansi.SetCursor(1, 1)
                    local o = {}
                    for i = 1, #Menu do
                        --Can't Use Select :(
                        o[i] = ((i == Selected) and (SelectedChar .. string.rep(' ', SelectedPadding - #SelectedChar)) or string.rep(' ', SelectedPadding)) .. Menu[i]
                    end
                    print(table.concat(o, MenuConcat))

                    --local input = Input()
                    local input = curses.getch(window)
                    local key = curses.getkeyname(input)
                    if Controls.L[key] then
                        Selected = Selected == 1 and 1 or Selected - 1
                    elseif Controls.R[key] then
                        Selected = Selected == 3 and 3 or Selected + 1
                    elseif Controls.Select[key] then
                        --Dirty
                        if Selected == 1 then
                            --Back
                        elseif Selected == 2 then
                            --Retry
                            return 'Retry'
                        elseif Selected == 3 then
                            --Back to Select
                            return nil
                        end
                        break
                    elseif Controls.Escape[key] then
                        break
                    end
                end
                curses.nodelay(window, true)
                startt = startt + (os.clock() - before)
            end















            --Statistics




            if input ~= -1 then
                lastinput = {input, key}
            end
            --input statistics
            Statistic('Input (ascii)', lastinput[1])
            Statistic('Input (key)', lastinput[2])




            --statistics






            --DEBUG
            Statistic('S', s)
            Statistic('Ms', ms)
            Statistic('Loaded', #loaded)
            Statistic('Frames Rendered', framen)
            --Statistic('Last Frame Render (s)', framerenders)
            Statistic('Last Frame Render (ms)', framerenders * 1000)
            --Statistic('Frame Render Total (s)', framerenderstotal)
            Statistic('Frame Render Total (ms)', framerenderstotal * 1000)
            Statistic('Frame Render Total (%)', framerenderstotal / s * 100)
            Statistic('FPS (Frame)', framen / s)

            --[=[
            Statistic('nextloadms', nextnote and nextnote.loadms)
            Statistic('nextms', nextnote and nextnote.ms)
            Statistic('nextn', nextnote and nextnote.n)
            --]=]


            --[[ --temp 11/12/2022

            Statistic('Memory Usage (mb)', collectgarbage('count') / 1000)
            Statistic('Finished (%)', ms / (endms) * 100)


            Statistic('Nearest1 (ms)', nearest[1])
            --Statistic('NearestHIT', (nearestnote[1] and ((nearestnote[1].ms > ms) and (not nearestnote[1].hit))))
            Statistic('Nearest2 (ms)', nearest[2])
            --]]
            --Delay
            Statistic('Stop Start', stopstart or '')
            Statistic('Stop End', stopend or '')
            Statistic('Total Delay', totaldelay)

            --]]


            --Score
            Statistic('Score', score)
            Statistic('Combo', combo)
            Statistic('Gogo', gogo)
            





            --Drumroll
            Statistic('Drumroll Start', drumrollstart)
            Statistic('Drumroll End', drumrollend)




            --GAME

            --[[
            --Song info

            Statistic('Song Name', Parsed.Metadata.TITLE)
            Statistic('Difficulty (id)', Parsed.Metadata.COURSE)
            Statistic('Stars', Parsed.Metadata.LEVEL)
            


            --]]


            RenderStatistic()
            RenderLog()
            
            --]=====]


        end

        --[[
        profiler.report('profiler.log')
        --]]


        --REPLAY
        if recording then
            local temp = {}
            for i = 1, 2 do
                temp[i] = record[i][false]
                temp[i + 2] = record[i][false]
            end
            record = temp
            record = Replay.Save(Replay.TranscodeRawKey(record), {
                '\ntitle ', Parsed.Metadata.TITLE,
                '\nsubtitle ', '',
                '\ndifficulty ', Taiko.Data.CourseName[Parsed.Metadata.COURSE],
                '\nstars ', tostring(Parsed.Metadata.LEVEL),
                '\ntime ', tostring(os.time()),
            })


            Replay.Write(recordfile, record)
        end


        ResetResizeAll()
        if''then return false end --TODO: REMOVE AUTORETRY
        return true, Results


    end




























    --Helper function for Taiko.Calibrate
    function Taiko.CalibrateParsed(Parsed)
        --[[
            HELPER FUNCTION FOR Taiko.Calibrate (Calibrate handles timing shit)

            Parsed is just an optional score to calibrate against

            Returns:
            Offsets = {
                Timing = 0,
                Music = 0
            }
            return Offsets


            Notes:
            Hit Calibration isn't counted if you miss (toggle ignoremiss)

            TODO:
            Default parsed score
        ]]
        --[[
        if not Parsed then
            Parsed = Taiko.GetDifficulty(Taiko.ParseTJAFile('./defaultcalibrate.tja'), 'Oni') --Possibly add this to config?
        end
        --]]

        local ignoremiss = false





        local timing = Taiko.Data.Timing.Level[Parsed.Metadata.TIMING]



        --[[
        --Offset data
        local Offsets = {
            Timing = nil,
            Music = nil
        }
        --]]


        local hitdata = {
            ms = {},
            n = {}
        }



        local OptionalConfig = {
            oneveryframe = function(ms)
                --Display stats


                --Detect input (ex: exit)
            end,
            oneveryhit = function(ms, v, side, nearestnote)
                hitdata.ms[#hitdata.ms + 1] = ms
                hitdata.n[#hitdata.n + 1] = nearestnote[v]
            end
        }



        --PlaySong

        Taiko.PlaySong(Parsed, OptionalConfig)

        
        --list of all offsets (that aren't ignoredmiss) (- is early, + is late)
        local offsets = {}

        --Process data
        for i = 1, #hitdata.ms do
            local ms = hitdata.ms[i]
            local n = hitdata.n[i]

            --If not n then its a complete (COMPLETE (since its not loaded)) miss
            if n then

                
                --No leniency for good
                local leniency = ((n.type == 3 or n.type == 4) and Taiko.Data.BigLeniency) or 1

                if (not ignoremiss) or (math.abs(ms - n.ms) < (timing.bad * leniency)) then
                    offsets[#offsets + 1] = ms - n.ms
                end


            end
        end


        --Statistics!
        local offsetanalyzed = {
            sum = 0,
            average = nil,
            min = nil,
            max = nil
        }
        for i = 1, #offsets do
            local o = offsets[i]

            --print(o)

            --Calculate some stats
            offsetanalyzed.sum = offsetanalyzed.sum + o
            offsetanalyzed.min = (not offsetanalyzed.min or o < offsetanalyzed.min) and o or offsetanalyzed.min
            offsetanalyzed.max = (not offsetanalyzed.max or o > offsetanalyzed.max) and o or offsetanalyzed.max
        end

        --Calculate some stats
        offsetanalyzed.average = offsetanalyzed.sum / #offsets
        -- print(offsetanalyzed.average, offsetanalyzed.sum, #offsets)


        return offsetanalyzed
    end



    --Entry point for calibration
    function Taiko.Calibrate(Parsed)
        --[[
            Parsed is just an optional score to calibrate against

            Returns:
            Offsets = {
                Timing = 0,
                Music = 0
            }
            return Offsets


            Notes:
            Hit Calibration isn't counted if you miss (toggle ignoremiss)

            TODO:
            Default parsed score


            Values for myself:
            Desktop-KTP: {Music=-59.810474468085,Timing=5.0134218750001}
        ]]
        if not Parsed then
            Parsed = Taiko.GetDifficulty(Taiko.ParseTJAFile(Config.Settings.Defaults.CalibratePath), Config.Settings.Defaults.CalibrateDifficulty)
        end


        --Offset data
        local Offsets = {
            Timing = nil,
            Music = nil
        }

        --Do without music (Timing) (Visual)
        local temp = Parsed.Metadata.SONG
        Parsed.Metadata.SONG = nil

        local offsetanalyzedvisual = Taiko.CalibrateParsed(Parsed)

        Parsed.Metadata.SONG = temp
        temp = nil

        --Do without notes (Music) (Audio)
        local scroll = 0.00001
        for i = 1, #Parsed.Data do
            local note = Parsed.Data[i]
            --Make note scroll like 0.00001
            note.oscrollx = note.scrollx
            note.oscrolly = note.scrolly

            note.scrollx = scroll
            note.scrolly = scroll
        end

        local offsetanalyzedaudio = Taiko.CalibrateParsed(Parsed)
        for i = 1, #Parsed.Data do
            local note = Parsed.Data[i]
            --Undo
            note.scrollx = note.oscrollx
            note.scrolly = note.oscrolly

            note.oscrollx = nil
            note.oscrolly = nil
        end


        --Set values
        Offsets.Timing = offsetanalyzedvisual.average
        Offsets.Music = offsetanalyzedaudio.average

        require'ppp'(Offsets)

        return Offsets
    end
























    --Wrapper for Taiko.PlaySong that handles everything (except difficulty selection and parsing)
    function Taiko.Play(Parsed, path, difficulty)
        while true do
            local Status, Result = Taiko.PlaySong(Parsed)
            if Status == true then
                --Song ended

                --Show Results

                break
            elseif Status == false then
                --Retry

                --Reload file from disc
                if path then
                    local Parsed2 = Taiko.Parse(path)
                    local ParsedData2 = Taiko.GetDifficulty(Parsed2, difficulty)
                    Parsed = ParsedData2
                end
            elseif Status == nil then
                --Quit
                break
            else
                
            end
        end
    end










    --Wrapper for Taiko.ParseTJAFile that handles errors
    function Taiko.Parse(path)
        local Parsed, Error = Taiko.ParseTJAFile(path)
        if Parsed then
            return Parsed
        else
            print(Error)
            GuiMessage('Taiko.ParseTJA Error: ' .. Error)
            return nil
        end
    end









    --TODO: Config editor
    function Taiko.Config()
        local str = 'amogus'
        local out = {}
        local displaytext = str
        while not rl.WindowShouldClose() do
            rl.BeginDrawing()
            rl.ClearBackground(rl.RAYWHITE)
            rl.DrawText(displaytext, fontsize, fontsize, fontsize, rl.BLACK)
            rl.EndDrawing()

            while true do
                local c = rl.GetCharPressed()
                if c == 0 then
                    break
                else
                    out[#out + 1] = c
                    --Update display
                    displaytext = str .. utf8Encode(out)
                end
            end

            --Remember, GetCharPressed doesn't detect special keys
            if rl.IsKeyPressed(rl.KEY_BACKSPACE) then
                out[#out] = nil
                --Update display
                displaytext = str .. utf8Encode(out)
            end
            if rl.IsKeyPressed(rl.KEY_ENTER) then
                break
            end
        end
    end

























    -- return Taiko.Calibrate()
    return Taiko.SongSelect()
    -- return Taiko.Config()
    --return Taiko.PlaySong(Parsed)






end




















Taiko.Game()



















































































--[==[




--a = 'tja/neta/donkama/neta.tja'
--a = 'tja/neta/ekiben/delay.tja'
--a = 'tja/neta/overdead.tja'
--a = 'tja/neta/ekiben/neta.tja'
a = 'Songs/taikobuipm/Saitama 2000.tja'
a = 'tja/neta/donkama/neta.tja'
--a = 'tja/neta/ekiben/notehitgauge.tja'
--a = 'tja/neta/ekiben/spiraltest.tja'
a = 'Songs/taikobuipm/Yuugen no Ran/Yuugen no Ran.tja'

--a = 'Songs/BakemonoFriends/ようこそジャパリパークへ.tja'
--a = 'Songs/Bakemono2/test.tja'
--a = 'Songs/taikobuipm/Ekiben 2000.tja'
--a = 'tja/neta/ekiben/drumrolltest.tja'
--a = 'tja/neta/Bakemono/bpmchange.tja'
--a = 'tja/neta/ekiben/neta.tja'
--a = 'taikobuipm/Ekiben 2000.tja'
--a = 'tja/neta/ekiben/scrolldrumroll.tja'

--https://www.youtube.com/watch?v=7cCTaJtSIew
--a = 'taikobuipm/Ekiben 2000.tja'


--File
local function CheckFile(str)
    local file = io.open(str, 'rb')
    if file then
        file:close()
        return true
    else
        return false
    end
end

local p = Taiko.ParseTJAFile(a)
--local song = 'taikobuipm/EkiBEN 2000.ogg'
song = 'Songs/taikobuipm/Donkama 2000.ogg'
--[[
        local optionsmap = {
        auto = {
            [1] = false,
            [2] = true,
        },
        notespeedmul = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 0.25,
            [6] = 0.5,
            [7] = 0.75,
        },
        songspeedmul = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 0.25,
            [6] = 0.5,
            [7] = 0.75,
        }
    }

]]
local s = {
    [2] = 2,
    [3] = 1,
    [4] = 1
}
-- [[
    --print(p[1].Metadata.SONG)
if not CheckFile(p[1].Metadata.SONG) then
    for k, v in pairs(p) do
        v.Metadata.SONG = song
        --v.Metadata.SEVOL = 0.5
    end
end
--]]
Taiko.Game(Taiko.GetDifficulty(p, 'Oni'), nil, s)error()


--]==]











--[======[
--ParseTJA test
-- [[
local file = './CompactTJA/ESE/ESE.tjac' --ALL ESE

local t, header = Compact.Decompress(Compact.Read(file))

local errorn = 0
local successn = 0
local times = {}
local errors = {}
local t1 = os.clock()
for i = 1, #t do
    print(i)
    local status, out = pcall(Taiko.ParseTJA, t[i]) --out will be ms for our test
    if status then
        times[#times + 1] = out
        successn = successn + 1
    else
        errorn = errorn + 1
        errors[#errors + 1] = out
    end
end

print('Total Time (s): ', os.clock() - t1)

table.sort(times)
print('Shortest Time (ms): ', times[1])
print('Longest Time (ms): ', times[#times])
local total = 0
for i = 1, #times do
    total = total + times[i]
end
print('Total Time Parsing (ms): ', total)
print('Average Time (ms): ', total / #times)


print('Total Successes (n): ', successn)
print('Total Errors (n): ', errorn)


error()
--]]





--FLAG
--a = 'tja/ekiben.tja'
a = 'tja/neta/ekiben/neta.tja'
a = 'tja/neta/ekiben/loadingtest2.tja'
a = 'tja/neta/ekiben/updowntest.tja'
--a = 'tja/neta/ekiben/directiontest.tja'
a = 'tja/neta/ekiben/drumrolltest.tja'
--a = 'tja/neta/ekiben/neta.tja'
--a = 'tja/neta/kita/kita.tja'
--a = 'tja/neta/ekiben/loadingtest2.tja'
a = 'tja/saitama.tja'
a = 'tja/neta/ekiben/neta.tja'
a = 'tja/neta/ekiben/jposscrolltest.tja'
a = 'taikobuipm/Ekiben 2000.tja'
a = 'taikobuipm/Donkama 2000.tja'
--a = 'tja/neta/ekiben/notedrumtest.tja'
a = 'tja/neta/ekiben/jposscrolltest.tja'
a = 'tja/neta/ekiben/neta.tja'
--a = 'tja/neta/overdead.tja'
--a = 'tja/neta/ekiben/notedrumtest.tja'
a = 'taikobuipm/Donkama 2000.tja'
--a = 'tja/ekiben.tja'
a = 'tja/neta/ekiben/neta.tja'
a = 'tja/neta/donkama/neta.tja'
--a = 'taikobuipm/Saitama 2000.tja'

--[[
--diff
b = Taiko.GetDifficulty(Taiko.ParseTJA(io.open('taikobuipm/Ekiben 2000.tja','r'):read('*all')), 'Oni')
a=Taiko.GetDifficulty(Taiko.ParseTJA(io.open(a,'r'):read('*all')), 'Oni')
for i = 1, #b.Data do
    a.Data[#a.Data + 1] = b.Data[i]
end
for i = 1, #a.Data do
    a.Data[i].delay = 0
end
Taiko.PlaySong(a)error()
--]]


--[[
--scroll
a=Taiko.GetDifficulty(Taiko.ParseTJA(io.open(a,'r'):read('*all')), 'Oni')
for i = 1, #a.Data do
    a.Data[i].scrollx = -1
end
Taiko.PlaySong(a)error()
--]]

--File
local function CheckFile(str)
    local file = io.open(str, 'rb')
    if file then
        file:close()
        return true
    else
        return false
    end
end

local p = Taiko.ParseTJAFile(a)
local song = 'taikobuipm/EkiBEN 2000.ogg'
song = 'taikobuipm/Donkama 2000.ogg'
--[[
        local optionsmap = {
        auto = {
            [1] = false,
            [2] = true,
        },
        notespeedmul = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 0.25,
            [6] = 0.5,
            [7] = 0.75,
        },
        songspeedmul = {
            [1] = 1,
            [2] = 2,
            [3] = 3,
            [4] = 4,
            [5] = 0.25,
            [6] = 0.5,
            [7] = 0.75,
        }
    }

]]
local s = {
    [2] = 1,
    [3] = 1,
    [4] = 1
}
-- [[
if not CheckFile(p[1].Metadata.SONG) then
    for k, v in pairs(p) do
        v.Metadata.SONG = song
        --v.Metadata.SEVOL = 0.5
    end
end
--]]
Taiko.PlaySong(Taiko.GetDifficulty(p, 'Oni'), nil, s)error()

--Normal (Ono)
Taiko.PlaySong(Taiko.GetDifficulty(Taiko.ParseTJA(io.open(a,'r'):read('*all')), 'Oni'), nil, s)error()

--Overdead (Ura)
Taiko.PlaySong(Taiko.GetDifficulty(Taiko.ParseTJA(io.open(a,'r'):read('*all')), 'Edit'), nil, s)error()

--]======]





































--[=====[
--works best with compact
function Taiko.SongSelectOld(header, data, FilesSources)
    local Display = {} --2d array starting at {0, 0} (Left, up)
    local dx, dy = 10, 10
    local dminx, dmaxx, dminy, dmaxy = -dx, dx, -dy, dy




    local Vertical = true --Vertical mode

    local Selected = 1 --Where selection starts
    local SelectedOption = 1 --Selected option
    local SelectedOptionIndex = 4 --Selected option index
    --local DifficultyMax = 3 --Max difficulty able to be selected --NOW DETECTED
    local DisplayN = 5 --How much songs to display (per each side)
    local Spacing = 5 --Spacing
    local TopSpacing = 2 --Top Spacing
    local SelectedChar = 'V' --Selected Char
    local SelectedCharVertical = '>' --Selected Char Vertical


    local SearchN = 10 --Number of search results to show
    local Padding = nil --Padding to erase (nil = cols - 2)
    local SearchSelected = '>' --Selected Char
    local OptionSelected = '>' --Selected Char
    local OptionSpacing = 2 --Option Spacing

    local ParsedCacheOn = true --Parsed Cache On
    local ModifyStorage = '_Original_' --Prefix for storage of modified properties

    local FilesSources = FilesSources or {} --Table of file sources, so we can reload
    local ReloadName = false --Reload file name (header)





    local Options = {
        --https://taikotime.blogspot.com/2010/08/advanced-rules.html
        [2] = {
            'Normal', 'Auto'
        },
        [3] = {
            'Normal', '2x Speed', '3x Speed', '4x Speed', '0.25x Speed', '0.5x Speed', '0.75x Speed'
        },
        [4] = {
            'Normal', '2x Speed', '3x Speed', '4x Speed', '0.25x Speed', '0.5x Speed', '0.75x Speed'
        },
        [5] = {
            'Normal',
            'Reverse', --Abekobe
            'Invisible', --Doron
            'Messy', --Detarame
        }
    }
    local OptionsConfig = {
        4,
        1,
        1,
        1,
        1,
        1,
    }
    local OptionsLimit = {
        --{min, max, map}
        nil --Will be recalculated
    }
    for k, v in pairs(Options) do
        OptionsLimit[k] = {1, #v, v}
    end




    local ModifyFunctions = {
        --[[
            First value is passed to:
                ModifyNoteData(note, index, set)
            Second value is passed to:
                RestoreNoteData(note, index)

            It is called for every note

            'Normal',
            'Reverse', --Abekobe
            'Invisible', --Doron
            'Messy', --Detarame
        ]]
        --Normal
        [1] = nil,

        --Reverse
        [2] = {
            function(note)
                return note, 'type', note.type and (Taiko.Data.Notes.ReverseNotes[note.type] or note.type) or note.type
            end,
            function(note)
                return note, 'type'
            end
        },

        --Invisible
        --dirty, temporary
        [3] = {
            function(note)
                return note, 'scrollx', 10000
            end,
            function(note)
                return note, 'scrollx'
            end
        },

        --Messy
        [4] = {
            function(note)
                return note, 'type', note.type and (
                    note.type == 1 and math.random(1, 2) or
                    note.type == 2 and math.random(1, 2) or
                    note.type == 3 and math.random(3, 4) or
                    note.type == 4 and math.random(3, 4) or
                    note.type
                )
            end,
            function(note)
                return note, 'type'
            end
        },
    }








    --local Compact = require('./CompactTJA/compactv4')




    --local curses = require('taikocurses')




    local window = {
        window = curses.initscr()
    }

    curses.keypad(window, true)
    curses.echo(false)
    curses.raw(true)
    curses.nl(false)
    curses.cbreak(true)

    --To display first frame
    curses.nodelay(window, true)
    curses.getch(window)
    curses.nodelay(window, false)



    --ASSUMES NO WINDOW RESIZE
    local cols, lines = curses.cols(), curses.lines()
    Padding = Padding or cols - 2
    --print(curses.cols(), curses.lines())
    
    --curses.nodelay(window, true)







    --Data













    local Controls = {
        Escape = {
            ['\27'] = true,
            ALT_ESC = true,
        },
        Scroll = {
            L = {
                --Left
                KEY_LEFT = true,
                KEY_SLEFT = true,
                CTL_LEFT = true,
                KEY_B1 = true,
                ALT_LEFT = true,

                KEY_SHIFT_L = true,


                --Up
                KEY_UP = true,
                KEY_A2 = true,
            },
            R = {
                --Right
                KEY_RIGHT = true,
                KEY_SRIGHT = true,
                CTL_RIGHT = true,
                KEY_B3 = true,
                ALT_RIGHT = true,

                KEY_SHIFT_R = true,


                --Down
                KEY_DOWN = true,
                KEY_C2 = true,
            }
        },
        Select = {
            Init = {
                --[[
                KEY_UP = true,
                KEY_DOWN = true,

                KEY_A2 = true,
                KEY_C2 = true,
                --]]


                KEY_ENTER = true,
                PADENTER = true,
                CTL_PADENTER = true,
                ALT_PADENTER = true,
                CTL_PADCENTER = true,
                ALT_ENTER = true,
                CTL_ENTER = true,
                SHF_PADENTER = true,

                ['\n'] = true,
                ['\r'] = true,
            },
            Select = {
                --[[
                KEY_UP = true,
                KEY_DOWN = true,

                KEY_A2 = true,
                KEY_C2 = true,
                --]]


                KEY_ENTER = true,
                PADENTER = true,
                CTL_PADENTER = true,
                ALT_PADENTER = true,
                CTL_PADCENTER = true,
                ALT_ENTER = true,
                CTL_ENTER = true,
                SHF_PADENTER = true,

                ['\n'] = true,
                ['\r'] = true,
            },
            Escape = {
                ['\27'] = true,
                ALT_ESC = true,
            },
            L = {
                --Left
                KEY_LEFT = true,
                KEY_SLEFT = true,
                CTL_LEFT = true,
                KEY_B1 = true,
                ALT_LEFT = true,

                KEY_SHIFT_L = true,
            },
            R = {
                --Right
                KEY_RIGHT = true,
                KEY_SRIGHT = true,
                CTL_RIGHT = true,
                KEY_B3 = true,
                ALT_RIGHT = true,

                KEY_SHIFT_R = true,
            },
            U = {
                --Up
                KEY_UP = true,
                KEY_A2 = true,
            },
            D = {
                --Down
                KEY_DOWN = true,
                KEY_C2 = true,
            },
            Play = {
                --1 = don, 2 = ka
                Hit = {
                    ['4'] = 2,
                    ['v'] = 1,
                    ['n'] = 1,
                    ['8'] = 2,
                },
                --Pause
                Escape = {
                    ['\27'] = true,
                    ALT_ESC = true,
                },
                --Scroll
                L = {
                    --Left
                    KEY_LEFT = true,
                    KEY_SLEFT = true,
                    CTL_LEFT = true,
                    KEY_B1 = true,
                    ALT_LEFT = true,
        
                    KEY_SHIFT_L = true,
        
        
                    --Up
                    KEY_UP = true,
                    KEY_DOWN = true,
                },
                R = {
                    --Right
                    KEY_RIGHT = true,
                    KEY_SRIGHT = true,
                    CTL_RIGHT = true,
                    KEY_B3 = true,
                    ALT_RIGHT = true,
        
                    KEY_SHIFT_R = true,
        
        
                    --Down
                    KEY_DOWN = true,
                    KEY_C2 = true,
                },
                Select = {
                    --[[
                    KEY_UP = true,
                    KEY_DOWN = true,
        
                    KEY_A2 = true,
                    KEY_C2 = true,
                    --]]
        
        
                    KEY_ENTER = true,
                    PADENTER = true,
                    CTL_PADENTER = true,
                    ALT_PADENTER = true,
                    CTL_PADCENTER = true,
                    ALT_ENTER = true,
                    CTL_ENTER = true,
                    SHF_PADENTER = true,
        
                    ['\n'] = true,
                    ['\r'] = true,
                }
            }
        },
        Search = {
            Init = {
                ALT_F = true,
                f = true,
                F = true,
            },
            Backspace = {
                ['\8'] = true,
                KEY_BACKSPACE = true,
                ALT_BKSP,
                CTL_BKSP,
            },
            FirstResult = {
                KEY_ENTER = true,
                PADENTER = true,
                CTL_PADENTER = true,
                ALT_PADENTER = true,
                CTL_PADCENTER = true,
                ALT_ENTER = true,
                CTL_ENTER = true,
                SHF_PADENTER = true,

                ['\n'] = true,
                ['\r'] = true,
            },
            Select = {
                KEY_RIGHT = true,
                KEY_SRIGHT = true,
                CTL_RIGHT = true,
                KEY_B3 = true,
                ALT_RIGHT = true,

                KEY_SHIFT_R = true,
            },
            Up = {
                KEY_A2 = true,
                KEY_UP = true,
            },
            Down = {
                KEY_C2 = true,
                KEY_DOWN = true,
            },
            Escape = {
                ['\27'] = true,
                ALT_ESC = true,
            }
        },
        Add = {
            Init = {
                ALT_N = true,
                n = true,
                N = true,
            },
            Backspace = {
                ['\8'] = true,
                KEY_BACKSPACE = true,
                ALT_BKSP,
                CTL_BKSP,
            },
            Select = {
                --[[
                KEY_UP = true,
                KEY_DOWN = true,

                KEY_A2 = true,
                KEY_C2 = true,
                --]]


                KEY_ENTER = true,
                PADENTER = true,
                CTL_PADENTER = true,
                ALT_PADENTER = true,
                CTL_PADCENTER = true,
                ALT_ENTER = true,
                CTL_ENTER = true,
                SHF_PADENTER = true,

                ['\n'] = true,
                ['\r'] = true,
            },
        },
        StandardInput = {
            Backspace = {
                ['\8'] = true,
                KEY_BACKSPACE = true,
                ALT_BKSP,
                CTL_BKSP,
            },
            Escape = {
                KEY_ENTER = true,
                PADENTER = true,
                CTL_PADENTER = true,
                ALT_PADENTER = true,
                CTL_PADCENTER = true,
                ALT_ENTER = true,
                CTL_ENTER = true,
                SHF_PADENTER = true,

                ['\n'] = true,
                ['\r'] = true,
            },
            --Scroll
            L = {
                --Left
                KEY_LEFT = true,
                KEY_SLEFT = true,
                CTL_LEFT = true,
                KEY_B1 = true,
                ALT_LEFT = true,
    
                KEY_SHIFT_L = true,
    
    
                --Up
                KEY_UP = true,
                KEY_DOWN = true,
            },
            R = {
                --Right
                KEY_RIGHT = true,
                KEY_SRIGHT = true,
                CTL_RIGHT = true,
                KEY_B3 = true,
                ALT_RIGHT = true,
    
                KEY_SHIFT_R = true,
    
    
                --Down
                KEY_DOWN = true,
                KEY_C2 = true,
            },
        },
        Reload = {
            Init = {
                r = true,
            },
        },
        ReloadAll = {
            Init = {
                R = true,
            },
        },
        Rename = {
            Init = {
                KEY_F2 = true,
            },
        }
    }


    


    --local Pixel = require('Pixels')


    local Ansi = {
        ClearScreen = function()
            io.write("\27[2J")
        end,
        SetCursor = function(x, y)
            io.write(string.format("\27[%d;%dH", y, x))
        end,

        --Extras
        ClearLine = function()
            io.write("\27[2K")
        end,
        CursorLeft = function(amount)
            io.write(string.format("\27[%dD", amount))
        end,
        CursorRight = function(amount)
            io.write(string.format("\27[%dC", amount))
        end,
        SaveCursor = function()
            io.write("\27[s")
        end,
        RestoreCursor = function()
            io.write("\27[u")
        end
    }








    local function Pad(str)
        return str .. string.rep(' ', Padding - #str)
    end
    local function Input()
        local input = curses.getch(window)
        local key = curses.getkeyname(input)
        return input, key
    end
    local function StandardInput()
        --same as io.read()
        local str = ''
        local pos = 0
        local oldpos = pos
        while true do
            local input, key = Input()
            --print(input, key)error()
            if Controls.StandardInput.Backspace[key] then
                str = string.sub(str, 1, pos - 1) .. string.sub(str, pos + 1, -1)
                pos = pos - 1
            elseif Controls.StandardInput.Escape[key] then
                io.write('\n')
                return str
            elseif Controls.StandardInput.L[key] then
                pos = pos - 1
            elseif Controls.StandardInput.R[key] then
                pos = pos + 1
            else
                str = string.sub(str, 1, pos) .. key .. string.sub(str, pos + 1, -1)
                pos = pos + 1
            end
            pos = ClipN(pos, 0, #str)
            local dif = pos - oldpos
            if dif < 0 then
                Ansi.CursorLeft(-dif)
            elseif dif > 0 then
                Ansi.CursorRight(dif)
            end

            Ansi.SaveCursor()
            Ansi.ClearLine()
            io.write('\r')
            --print('DATA', dif, oldpos, pos, str)
            io.write(str)
            Ansi.RestoreCursor()

            oldpos = pos
        end
    end
    local function IsValid(byte)
        return byte >= 32 and byte <= 126
    end
    local function Select(on, char, pad, str)
        --return (on and (char .. string.rep(' ', pad - #char)) or pad) .. str
        return (on and (char .. string.sub(pad, #char + 1, -1)) or pad) .. str
    end
    local function Wrap(n, min, max)
        return n > max and min or n < min and max or n
    end

    local Bool = {
        [0] = 'No',
        [1] = 'Yes'
    }
    local function ConvertBool(bool)
        return bool and Bool[1] or Bool[0]
    end
    local function ConvertPercent(percent)
        return percent * 100 .. '%'
    end
    local function ConvertMs(ms)
        return MsToS(ms) .. 's'
    end
    local function ConvertS(s)
        return ConvertMs(SToMs(s))
    end
    local function ConvertN(n)
        return tonumber(n) and tonumber(n) or 0
    end



    --Parsed functions
    local function ModifyNoteData(note, index, set)
        note[ModifyStorage .. index] = note[index]
        note[index] = set
    end
    local function RestoreNoteData(note, index)
        note[index] = note[ModifyStorage .. index]
    end






    local ParsedCache = {}



    Ansi.ClearScreen()
    
    while true do







        --Render

        --[[
        if Selected == 0 then
            Selected = #header
        elseif Selected == (#header + 1) then
            Selected = 0
        end
        --]]



        Display = {}
        

        if Vertical then
            Display[dminx] = {}
            for i = Selected - DisplayN, Selected + DisplayN do
                local index = nil
                if i < 1 then
                    index = #header + i
                elseif i > #header then
                    index = i - #header
                else
                    index = i
                end
                local song = header[index]
                if song then
                    --[[
                    local y = (i - Selected) * Spacing
                    local x = 0
                    --]]
                    Display[0] = Display[0] or {}
                    Display[0][(i - Selected) * Spacing] = song
                end
            end

            local out = {}
            local ts = string.rep(' ', TopSpacing)
            for y = dminy, dmaxy do
                --out[#out + 1] = y == 0 and (SelectedCharVertical .. string.rep(' ', #ts - #SelectedCharVertical)) or ts
                out[#out + 1] = Select(y == 0, SelectedCharVertical, ts, '')
                out[#out + 1] = Pad(Display[0] and Display[0][y] or '')
                out[#out + 1] = '\n'
            end

            Ansi.SetCursor(1, 1)
            print(table.concat(out))







        else
            Display[0] = {}
            Display[0][dminy] = SelectedChar
            for i = Selected - DisplayN, Selected + DisplayN do
                local index = nil
                if i < 1 then
                    index = #header + i
                elseif i > #header then
                    index = i - #header
                else
                    index = i
                end
                local song = header[index]
                if song then
                    local x = (i - Selected) * Spacing
                    Display[x] = Display[x] or {}
                    local y = dminy + TopSpacing
                    for i2 = 1, #song do
                        Display[x][y] = string.sub(song, i2, i2)
                        y = y + 1
                    end
                end
            end

            local out = {}
            for y = dminy, dmaxy do
                for x = dminx, dmaxx do
                    if Display[x] and Display[x][y] then
                        local a = Display[x][y]
                        if IsValid(string.byte(a)) then
                            out[#out + 1] = a
                        else
                            --Probably a unicode character, temp solution
                            out[#out + 1] = ' '
                        end
                    else
                        out[#out + 1] = ' '
                    end
                end
                out[#out + 1] = '\n'
            end

            Ansi.SetCursor(1, 1)
            print(table.concat(out))
            --]]
        end

        --Input
        local input, key = Input()
        if Controls.Scroll.L[key] then
            --Selected = Selected == 1 and #header or Selected - 1
            Selected = Selected - 1
        elseif Controls.Scroll.R[key] then
            --Selected = Selected == #header and 1 or Selected + 1
            Selected = Selected + 1
        elseif Controls.Select.Init[key] then
            local Parsed
            if ParsedCacheOn then
                if ParsedCache[Selected] then
                    Parsed = ParsedCache[Selected]
                else
                    Parsed = Taiko.ParseTJA(data[Selected])
                    ParsedCache[Selected] = Parsed
                end
            else
                Parsed = Taiko.ParseTJA(data[Selected])
            end


            --Find difficulties

            
            local map = {}
            for k, v in pairs(Parsed) do
                map[#map + 1] = {k, v.Metadata.COURSE}
            end
            table.sort(map, function(a, b)
                return a[2] < b[2]
            end)
            min = 1
            max = #map
            OptionsLimit[1] = {min, max, map}
            DifficultyMap = map

            --clip
            OptionsConfig[1] = ClipN(OptionsConfig[1], min, max)


            --[=[
            local min, max
            local map
            --2 or 3
            --[[
            min = 1
            map = Options[SelectedOption]
            max = #map
            
            --]]
            --No need to calculate
            local a = OptionsLimit[SelectedOption]
            min, max, map = a[1], a[2], a[3]
            --]=]
            
            --SelectedOptionIndex = ClipN(SelectedOptionIndex, min, max)



            

            local pad = string.rep(' ', OptionSpacing)


            Ansi.ClearScreen()
            Ansi.SetCursor(1, 1)


            local ParsedData = nil
            local lastoption = SelectedOption
            while true do
                --Clip (moved to start)
                SelectedOption = ClipN(SelectedOption, 1, 5)

                if SelectedOption ~= lastoption then
                    SelectedOptionIndex = OptionsConfig[SelectedOption]
                    lastoption = SelectedOption
                end
                
                local a = OptionsLimit[SelectedOption]
                min, max = a[1], a[2]

                --SelectedOptionIndex = ClipN(SelectedOptionIndex, min, max)
                SelectedOptionIndex = Wrap(SelectedOptionIndex, min, max)

                OptionsConfig[SelectedOption] = SelectedOptionIndex














                Ansi.SetCursor(1, 1)
                local SelectedDifficulty = DifficultyMap[OptionsConfig[1]][2]
                ParsedData = Taiko.GetDifficulty(Parsed, SelectedDifficulty)
                local m = ParsedData.Metadata
                local a = Taiko.Analyze(ParsedData)
                local t = {
                    {'', m.TITLE},
                    {'\t', m.SUBTITLE},
                    {'', ''},
                    {'', 'Select Options:'},
                    {Select(SelectedOption == 1, OptionSelected, pad, 'Difficulty: '), Taiko.Data.CourseName[m.COURSE]},
                    {Select(SelectedOption == 2, OptionSelected, pad, 'Mode: '), Options[2][OptionsConfig[2]]},
                    {Select(SelectedOption == 3, OptionSelected, pad, 'Note Speed: '), Options[3][OptionsConfig[3]]},
                    {Select(SelectedOption == 4, OptionSelected, pad, 'Song Speed: '), Options[4][OptionsConfig[4]]},
                    {Select(SelectedOption == 5, OptionSelected, pad, 'Modifiers: '), Options[5][OptionsConfig[5]]},
                    {'', ''},
                    {'Difficulty: ', Taiko.Data.CourseName[m.COURSE]},
                    {'Stars: ', m.LEVEL},
                    {'Diverge Notes: ', ConvertBool(m.DIVERGENOTES)},
                    {'', ''},
                    {'', 'Statistics:'},
                    {'Length: ', ConvertMs(a.lengthms)},
                    {'Don (DON) / Ka (KA): ', ConvertN(a.notes[1]) .. ' + (' .. ConvertN(a.notes[3]) .. ') / ' .. ConvertN(a.notes[2]) .. ' + (' .. ConvertN(a.notes[4]) .. ') = ' .. ConvertPercent((ConvertN(a.notes[1]) + ConvertN(a.notes[3])) / a.notes.validn) .. ' / ' .. ConvertPercent((ConvertN(a.notes[2]) + ConvertN(a.notes[4])) / a.notes.validn)},
                    {'Max Score (without drumroll): ', a.maxscore},
                    {'Max Combo: ', a.maxcombo},
                    {'Drumroll Time (total): ', ConvertMs(a.drumrollms + a.drumrollbigms)},
                    {'Balloon Time: ', ConvertMs(a.balloonms)},
                    {'Balloon Hits: ', a.balloonhit},
                    {'Special Time: ', ConvertMs(a.specialms)},
                    {'Special Hits: ', a.specialhit},
                    {'', ''},
                    {'', 'Press Enter to Play!'}
                }
                for i = 1, #t do
                    local d = t[i]
                    print(Pad(d[1] .. tostring(d[2])))
                end

                --Input
                local input, key = Input()

                if Controls.Select.L[key] then
                    --SelectedOptionIndex = SelectedOptionIndex == min and min or SelectedOptionIndex - 1
                    SelectedOptionIndex = SelectedOptionIndex - 1
                elseif Controls.Select.R[key] then
                    --SelectedOptionIndex = SelectedOptionIndex == max and max or SelectedOptionIndex + 1
                    SelectedOptionIndex = SelectedOptionIndex + 1
                elseif Controls.Select.U[key] then
                    SelectedOption = SelectedOption - 1
                elseif Controls.Select.D[key] then
                    SelectedOption = SelectedOption + 1
                elseif Controls.Select.Select[key] then
                    --Apply modifiers
                    local mod = ModifyFunctions[OptionsConfig[5]]
                    if mod and mod[1] then
                        local f = mod[1]
                        Taiko.ForAll(ParsedData.Data, function(note, i, n)
                            ModifyNoteData(f(note))
                        end)
                    end


                    while true do
                        --No need to endwin since playsong is using window
                        --curses.endwin()
                        local success, out = Taiko.PlaySong(ParsedData, window, OptionsConfig, Controls.Select.Play)
                        if success and out then
                            --Show results




                            break
                        elseif success == 'Retry' then
                            --Retry
                        else
                            --Quit
                            break
                        end
                    end
                    curses.nodelay(window, false)
                    Ansi.ClearScreen()


                    --Clear modifiers
                    if mod and mod[2] then
                        local f = mod[2]
                        Taiko.ForAll(ParsedData.Data, function(note, i, n)
                            RestoreNoteData(f(note))
                        end)
                    end
                elseif Controls.Select.Escape[key] then
                    break
                end

                --Now moved to start
                


            end


        elseif Controls.Search.Init[key] then
            local str = ''
            local results = {}
            local max = 1
            local result = nil
            local selected = 1
            Ansi.ClearScreen()
            Ansi.SetCursor(1, 1)
            print('Searching...')
            while true do
                Ansi.SetCursor(#str + 1, 2)
                --Input
                local input, key = Input()
                Ansi.SetCursor(1, 2)
                if Controls.Search.Backspace[key] then
                    str = string.sub(str, 1, -2)
                elseif Controls.Search.FirstResult[key] then
                    result = results[1]
                    break
                elseif Controls.Search.Select[key] then
                    result = results[selected]
                    break
                elseif Controls.Search.Down[key] then
                    --selected = selected < #results and selected + 1 or selected
                    selected = selected + 1
                elseif Controls.Search.Up[key] then
                    --selected = selected > 1 and selected - 1 or selected
                    selected = selected - 1
                elseif Controls.Search.Escape[key] then
                    break
                else
                    str = str .. key
                end

                print(Pad(str))
                --Compute
                local t = Compact.SearchHeaderAll(header, str)
                --Find max
                for i = 1, SearchN do
                    if t[i] and t[i][2] == -math.huge then
                        max = i - 1
                        break
                    elseif i == SearchN then
                        max = i
                    end
                end
                
                selected = ClipN(selected, 1, max)

                --Render
                local padmode = false
                for i = 1, SearchN do
                    local a = t[i]
                    if padmode then
                        print(Pad(''))
                    else
                        if a then
                            if a[2] == -math.huge then
                                padmode = true
                                print(Pad(''))
                            else
                                print(Pad((i == selected and SearchSelected or i) .. '. ' .. t[i][3]))
                                --Dirty
                                --print(Pad(Select(i == selected, i == SearchSelected and SearchSelected or tostring(i), ' . ', t[i][3])))
                                results[i] = a
                            end
                        end
                    end
                end
            end
            Selected = (result and result[1] or Selected) or Selected
        elseif Controls.Add.Init[key] then
            print('Import a Custom Song')
            while true do
                print('Enter a .tja or .tjac file path (with the file extention)')
                local input = StandardInput()
                local file = io.open(input, 'rb')
                if file then
                    --local data2 = io.read(file, '*all')
                    local data2 = file:read('*all')
                    if String.EndsWith(input, '.tja') then
                        print('Enter a song name')
                        local input2 = StandardInput()
                        local index = #header + 1
                        header[index] = input2
                        data[index] = data2
                        FilesSources[index] = {input}
                        break
                    elseif String.EndsWith(input, '.tjac') then
                        local t, h = Compact.Decompress(data2)
                        for i = 1, #t do
                            local index = #header + 1
                            header[index] = h[i]
                            data[index] = t[i]
                            FilesSources[index] = {input, t}
                        end
                        break
                    else
                        print('Invalid file type')
                    end
                    file:close()
                else
                    print('Unable to read file')
                end
            end
        elseif Controls.Reload.Init[key] then
            print('Reloading selected file...')
            if FilesSources[Selected] then
                --print('File source found')
                local a = FilesSources[Selected]
                local file = io.open(a[1], 'rb')
                if file then
                    local data2 = file:read('*all')
                    local index = Selected
                    --print('\n', index, a[1])
                    if a[2] then
                        --.tjac
                        local t, h = Compact.Decompress(data2)
                        if ReloadName then
                            header[index] = h[i]
                        end
                        data[index] = t[i]
                        --FilesSources[index] = {input, t}
                    else
                        --.tja
                        --[[
                        if ReloadName then
                            header[index] = input2
                        end
                        --]]
                        data[index] = data2
                    end
                    if ParsedCacheOn then
                        ParsedCache[index] = nil
                    end
                    file:close()
                else
                    print('Unable to read file')
                end
            else
                print('File source not found')
            end
        elseif Controls.ReloadAll.Init[key] then
            print('Reloading all files...')
            local reloadlist = {}
            for k, v in pairs(FilesSources) do
                reloadlist[v[1]] = reloadlist[v[1]] and reloadlist[v[1]] or {}
                reloadlist[v[1]][#reloadlist[v[1]] + 1] = {k, v[2]}
            end
            for k, v in pairs(reloadlist) do
                local file = io.open(k, 'rb')
                if file then
                    local data2 = file:read('*all')
                    --local index = Selected
                    if v[1][2] then
                        --.tjac
                        local t, h = Compact.Decompress(data2)
                        for i = 1, #v do
                            local a = v[i]
                            if ReloadName then
                                header[a[1]] = h[a[2]]
                            end
                            data[a[1]] = t[a[2]]
                            if ParsedCacheOn then
                                ParsedCache[a[1]] = nil
                            end
                            --FilesSources[index] = {input, t}
                        end
                    else
                        --.tja
                        for i = 1, #v do
                            local a = v[i]
                            --[=[
                            if ReloadName then
                                header[v[1]] = input2
                            end
                            --]=]
                            data[a[1]] = data2
                            if ParsedCacheOn then
                                ParsedCache[a[1]] = nil
                            end
                        end
                    end
                    file:close()
                else
                    print('Unable to read file')
                end
            end
        elseif Controls.Rename.Init[key] then
            print('Enter a song name')
            local input2 = StandardInput()
            header[Selected] = input2
            
        elseif Controls.Escape[key] then
            return
        end
        Selected = Wrap(Selected, 1, #header)
    end
end






--]=====]































--[======[

--Parse Testing


--[=[
--https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
-- Lua implementation of PHP scandir function
function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local dir = [[C:\Users\User\OneDrive\code\Taiko\Versions\taikobuipm]]
local t = scandir(dir)
local exclude = {
    ['Koibumi 2000.tja'] = true --weird balloon
}
for i = 1, #t do
    local file = t[i]
    if (not exclude[file]) and String.EndsWith(file, 'tja') then
        print(file)
        Taiko.ParseTJA(io.open(dir .. '\\'.. file,'r'):read('*all'))
    end
end
--error()
--]=]




--[[
    Funny / Notable Songs list
donkama.tja weird note scroll
waraeru.tja weird barline + 938 balloon
]]







--[[
file = './tja/donkama.tja'
--file = './tja/test.tja'
file = './tja/ekiben.tja'
--file = './tja/lag.tja'
--file = './tja/drumroll2.tja'
--file = './tja/branchtest.tja'
file = './tja/saitama.tja'
--file = './tja/donkama.tja'
file = './tja/funny2000.tja'
file = './tja/waraeru.tja' --somehow unload doesnt work




file = './tja/ekiben.tja'
--file = './tja/_mc08.tja'
--file = './tja/scrolltest.tja'


--file = './tja/ekiben.tja'

--file = './tja/biglongtest.tja'

Taiko.PlaySong(Taiko.ParseTJA(io.open(file,'r'):read('*all')), 'Oni')
--]]













--[[
Taiko.SongSelect({
    'ekiben',
    'saitama',
    'taiko'
})
error()
--]]



















local file = './CompactTJA/taikobuipm.tjac'

--ESE
file = './CompactTJA/ESE/06 Classical.tjac' --Classical

file = './CompactTJA/ESE/ESE.tjac' --ALL ESE



--file = './CompactTJA/all.tjac' --All 2000 / test songs















--local Compact = require('./CompactTJA/compactv4')



--local t, header = Compact.Decompress(Compact.Read(file))



-- [[
--Taiko.SongSelect(header, t)
--Taiko.SongSelect({}, {})

--[[
local _='./tja/neta/ekiben/spiraltest.tja'local a=io.open(_,'r')local b=a:read('*all')a:close()
Taiko.SongSelect({'neta'}, {b}, {{_}})
--]]

local function list(t) --t = table of files
    local a, b, c = {}, {}, {}
    for i = 1, #t do
        local _ = t[i]
        a[#a + 1] = _:gsub('(.-)/', '')
        local ca=io.open(_,'r')local cb=ca:read('*all')ca:close()
        b[#b + 1] = cb
        c[#c + 1] = _
    end
    return a, b, c
end

Taiko.SongSelect(list(
    {
        './tja/neta/ekiben/spiraltest.tja',
        './tja/neta/ekiben/delay.tja',
        './tja/neta/ekiben/neta.tja',
        './tja/neta/kita/kita.tja',
        './taikobuipm/Kita Saitama 2000.tja'
    }
))

error()
--]]












--[=[

--[[
--print emulation

local pf = io.open('_stdout.txt','w+')

print = function(...)
    local t = {...}
    for i = 1, #t do
        t[i] = tostring(t[i])
    end
    pf:write(table.concat(t, '\t') .. '\n')
end

--]]


local t, header = Compact.Decompress(Compact.Read(file))

local exclude = {
}



--[[
local profiler = require'profiler'
profiler.start()
--]]





for k, v in pairs(t) do
    print(k, header[k])
    --SongName = header[k]
    if exclude[k] then
        print('EXCLUDE')
    else
        local a = Taiko.ParseTJA(v)
    end
end

--[[
profiler.report('profiler.log')
--]]

error()
--]=]



--Taiko.PlaySong(Taiko.GetDifficulty(Taiko.ParseTJA(Compact.InputFile(file)), 'Ura'))


--]]

--[=[

print(RenderScale(ParseTJA([[
#START
200
#SCROLL 1.33
2
#SCROLL 1
20
#SCROLL 1.33
20
#SCROLL 1
2
#SCROLL 1.33
200
#SCROLL 1
200
#SCROLL 1.33
2,
#END
]])))

--]=]

--[=[
print(RenderScale(ParseTJA([[
//TJADB Project 
TITLE:test
SUBTITLE:--Linda AI-CUE
BPM:60
WAVE:Donkama 2000.ogg
OFFSET:-4.101
DEMOSTART:75.871

COURSE:Oni
LEVEL:10
BALLOON:
SCOREINIT:440
SCOREDIFF:120


#START
1111

#BPMCHANGE 120
#SCROLL 2

1111,

#END
]])))
--]=]
--]======]