--[[
Taikov25.lua


Changes: Taiko.PlaySong improved!

Made notes disappear after hitting!
Cleaned up requires, and bundle them to start of code!


TODO: Add Gimmicks
    Complex Scroll
    Negative Measures

TODO: Remove OptimizedPixel, just generate it every time
TODO: Refactor Code
    Case Consistency
    Optimize Parser

TODO: Check for match[2] so no error
TODO: Note lyrics
TODO: Docs
TODO: Use io.write instead of print in PlaySong
TODO: Fix delay + barline issue
TODO: Fix serializetja




TODO: FIX rounding
    PlaySong
TODO: Song select screen
    Select Song
    Scroll Animation
    URA SUPPORT --Done
    UNHARDCODE OPTIONS --Done
    CACHED OPTION LIMITS --Done

TODO: Scoreinit
TODO: Lyrics
TODO: SCORE SYSTEM
    balloon
    drumroll?


TODO: PlaySong
    Add drumrolls / balloons
    Combo
    Score
    Display
    BigLeniency --Half Done
    2P SUPPORT!


WIP: FIX statusanimationlength
WIP: Remove Pixels Dependancy


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
local OptimizedPixel = nil --Will be generated later





--Requires
local curses = require('taikocurses')
local Compact = require('./CompactTJA/compactv4')





















































--Utils



--string

Split=function(a,b)local c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end
Trim=function(s)local a=s:gsub("^%s*(.-)%s*$", "%1")return a end
TrimLeft=function(s)local a=s:gsub("^%s*(.-)$", "%1")return a end
TrimRight=function(s)local a=s:gsub("^(.-)%s*$", "%1")return a end
StartsWith=function(a,b)return a:sub(1,#b)==b end
EndsWith=function(a,b)return a:sub(-#b,-1)==b end








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
    error(msg)
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
    GenreName = {
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


                return score + (((combo < 200) and (init or 1000) or ((init or 1000) + (diff or 1000))) * Taiko.Data.RatingMultiplier[status] * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [1] = function(score, combo, init, diff, status, gogo)
                --https://github.com/bui/taiko-web/wiki/TJA-format#scoremode
                --INIT + max(0, DIFF * floor((min(COMBO, 100) - 1) / 10))
                return score + ((init + math.max(0, diff * math.floor((math.min(combo, 100) - 1) / 10))) * Taiko.Data.RatingMultiplier[status] * (gogo and Taiko.Data.GogoMultiplier or 1))
            end,
            [2] = function(score, combo, init, diff, status, gogo)
                --https://github.com/bui/taiko-web/wiki/TJA-format#scoremode
                --INIT + DIFF * {100<=COMBO: 8, 50<=COMBO: 4, 30<=COMBO: 2, 10<=COMBO: 1, 0}
                return math.floor(score + ((init + diff * ((combo >= 100) and 8 or (combo >= 50) and 4 or (combo >= 30) and 2 or (combo >= 10) and 1 or 0)) * Taiko.Data.RatingMultiplier[status] * (gogo and Taiko.Data.GogoMultiplier or 1)) / 10) * 10
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
        GetFunction = function(course)
            return function(framems)
                --https://github.com/bui/taiko-web/blob/ba1a6ab3068af8d5f8d3c5e81380957493ebf86b/public/src/js/gamerules.js
                if course == 1 then
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
        P1,
        P2
    },
    Combo = { --Notes that affect combo
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    },
    BigLeniency = 2, --How much times easier to hit (x Timing)











    --Strings
    --https://github.com/bui/taiko-web/blob/master/public/src/js/strings.js
    Strings = {
        Notes = {
            --TODO
        }
    }
}



--Wrap scoring
--[[
for k, v in pairs(Taiko.Data.ScoreMode.Note) do
    Taiko.Data.ScoreMode.Note[k] = function(...)
        return math.floor(v(...) / 10) * 10
    end
end
--]]





















--TJA Parser

function Taiko.ParseTJA(source)
    local time = os.clock()

    --Parsing settings
    local zeroopt = flashpixel --Don't parse zeros


    local Out = {}
    local Parsed = {
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
            SCOREINIT,
            SCOREDIFF,
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



            --temprary values
            SCOREINIT = 0,
            SCOREDIFF = 0
        },
        Data = {}
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
    }












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
    --print(unpack(ParseComplexNumber(source)))error()







    local Parser = {}

    local function GetParser()
        local Parser = {
            settings = {
                noteparse = {
                    notealias = {
                        A = 3,
                        B = 4
                    },
                    noteexceptions = {
                        [','] = true,
                        [' '] = true,
                        ['\t'] = true
                    }
                },
                command = {
                    matchexceptions = {
                        --scrapped
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
            scroll = 1,
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
            stopsong = false,
            delay = 0,






            --note chain
            notechain = {}


            
        }






        --Parser functions
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


                local note = {
                    ms = nil,
                    data = nil, --'note'
                    type = n,
                    txt = nil,
                    gogo = Parser.gogo,
                    --speed = (Parser.bpm) / 60 * (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    scroll = (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    mspermeasure = Parser.mspermeasure,
                    bpm = Parser.bpm,
                    --measuredensity = nil,
                    nextnote = nil,
                    radius = 1, --multiplier
                    requiredhits = nil,
                    length = nil,
                    endnote = nil,
                    section = nil,
                    text = nil,
                    delay = Parser.delay,
                    




                    onnotepush = nil
                }
                note.type = n

                --Big note
                if n == 3 or n == 4 or n == 6 then
                    note.radius = note.radius * 1.6
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
                            lastlong.length = note.ms - lastlong.ms
                            lastlong.endnote = note
                            --Parser.lastlong = nil
                            --note.type = 0 --to delete note
                        end
                    else
                        --ParseError('parser.noteparse', 'Last long note has ended')
                    end
                end


                if Parser.section then
                    note.section = true
                    Parser.section = false
                end

                return note
            else
                return {
                    ms = nil,
                    data = nil, --'note'
                    type = nil,
                    txt = nil,
                    gogo = Parser.gogo,
                    --speed = (Parser.bpm) / 60 * (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    scroll = (Parser.scroll * Parsed.Metadata.HEADSCROLL),
                    mspermeasure = Parser.mspermeasure,
                    bpm = Parser.bpm,
                    --measuredensity = nil,
                    nextnote = nil,

                    delay = Parser.delay,

                    --outdated
                }
            end
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
    local lines = Split(source, '\n')
    for i = 1, #lines do
        LineN = i

        --local line = TrimLeft(lines[i])
        local line = Trim(lines[i])
        if StartsWith(line, '//') or line == '' then
            --Do nothing
        else
            --Check for comments
            local comment = string.find(line, '//')
            if comment then
                line = string.sub(line, 1, comment - 1)
            end








            local done = false

            
            --Metadata
            if Parser.songstarted == false and done == false then
                local match = {string.match(line, '(%u+):(.*)')}
                if match[1] then
                    local a = Trim(match[2])
                    if a ~= '' then
                        Parsed.Metadata[Trim(match[1])] = a
                    end
                    
                    done = true
                    --[[
                    local a = Trim(match[2])
                    if a ~= '' then
                        Parsed.Metadata[Trim(match[1])] = a
                    end
                    done = true
                    ]]
                end
            end

            --Command
            if (Parser.songstarted or StartsWith(line, '#START') or StartsWith(line, '#BMSCROLL') or StartsWith(line, '#HBSCROLL')) and done == false then
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
                            for k, v in pairs(Taiko.Data.GenreName) do
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
                                Parsed.Metadata.CREATOR = Trim(string.gsub(Parsed.Metadata.MAKER, '(<.->)', function(url)
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
                            Parsed.Metadata.TIMING = Taiko.Data.Timing.GetFunction(Parsed.Metadata.COURSE)


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
                                Metadata = Table.Clone(Parsed.OriginalMetadata),
                                Data = {}
                            }
                            --reset parser?
                            Parser = GetParser()
                            --reset parser?
                            Parser.songstarted = false
                            Parser.measurepushto = Parsed.Data --Very important
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
                        local a, b = string.match(match[2], '(%d+)/(%d+)')
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

                        Parser.delay = Parser.delay + a
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
                            Parser.scroll = CheckN(match[1], match[2], 'Invalid scroll') or Parser.scroll --UNSAFE
                            if Parser.scroll == 0 then
                                ParseError(match[1], 'Scroll cannot be 0')
                            end
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
                        Parser.stopsong = true
                    elseif match[1] == 'HBSCROLL' then
                        --[[
                        https://wikiwiki.jp/jiro/%E5%A4%AA%E9%BC%93%E3%81%95%E3%82%93%E6%AC%A1%E9%83%8E
                            - Please describe before #START.
                            - If this instruction is present, the scroll method will include the effect of #SCROLL in BMSCROLL.
                        ]]
                        Parser.stopsong = true
                    elseif match[1] == 'SENOTECHANGE' then
                        --[[
                            - Force note lyrics with a specific value, which is an integer index for the following lookup table:
                                - 1: ドン, 2: ド, 3: コ, 4: カッ, 5: カ, 6: ドン(大), 7: カッ(大), 8: 連打, 9: ー, 10: ーっ!!, 11: 連打(大), 12: ふうせん
                            - The lyrics are replaced only if the next note is Don (1) or Ka (2).
                            - Can be placed in the middle of a measure.
                            - Ignored in taiko-web.
                        ]]
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
                    elseif match[1] == 'SUDDEN' then
                        --[[
                            - Delays notes from appearing, starting their movement in the middle of the screen instead of off-screen.
                            - The value is two floating point numbers separated with a space.
                            - First value is appearance time, marking the note appearance this many seconds in advance.
                            - Second value is movement wait time, notes stay in place and start moving when this many seconds are left.
                            - Can be placed in the middle of a measure.
                            - Ignored in taiko-web.
                        ]]
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
                    else
                        
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
                    local note = Parser.createnote()
                    note.ms = Parser.ms
                    note.data = 'event'
                    note.event = 'barline'
                    --table.insert(Parser.currentmeasure, 1, note)
                    --table.insert(Parser.measurepushto, 1, note)
                    table.insert(Parser.measurepushto, note)
                    Parser.insertbarline = false
                end











                --Could not recognize command, probably just raw data
                --example: 11,
                --get raw data
                --local data = {}

                for i = 1, #line do
                    local s = string.sub(line, i, i)
                    if Parser.settings.noteparse.noteexceptions[s] then
                        --Do nothing
                    else
                        local n = CheckN('parser.noteparse', tonumber(s) or Parser.settings.noteparse.notealias[s] or s, 'Invalid note')
                        if n then
                            local note = Parser.createnote(n)
                            note.data = 'note'
                            --note.type = n
                            table.insert(Parser.currentmeasure, note)
                        end
                    end
                end

                if EndsWith(TrimRight(line), ',') then
                    -- [[
                    --Recalculate --FIX
                    Parser.mpm = Parser.bpm * Parser.sign / 4
                    Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm
                    --]]








                    --add notes
                    if #Parser.currentmeasure == 0 then
                        Parser.ms = Parser.ms + Parser.mspermeasure
                    elseif #Parser.currentmeasure == 1 and Parser.currentmeasure[1].data == 'event' and Parser.currentmeasure[1].event == 'barline' then
                        Parsed.Data[#Parsed.Data + 1] = Parser.currentmeasure[1]
                        Parser.ms = Parser.ms + Parser.mspermeasure
                    else
                        --count notes
                        local notes = 0
                        local firstmspermeasure = nil
                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]
                            if c.data == 'note' then
                                firstmspermeasure = firstmspermeasure or c.mspermeasure
                                notes = notes + 1
                            end
                        end
                        firstmspermeasure = firstmspermeasure or Parser.mspermeasure
                        --loop
                        local increment = firstmspermeasure / notes
                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]

                            if c[1] == 'DELAY' then
                                Parser.ms = Parser.ms + c[2]
                            else

                                --if it is not air
                                if not zeroopt or c.type ~= 0 then --zeroopt
                                    c.ms = Parser.ms
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
                                    table.insert(Parser.measurepushto, c)
                                    --onnotepush --balloon
                                    if c.onnotepush then
                                        c.onnotepush()
                                    end
                                    --increment = (c.mspermeasure / notes) / c.speed
                                    increment = c.mspermeasure / notes
                                end

                                if c.data == 'note' then
                                    --not barline
                                    Parser.ms = Parser.ms + increment
                                end
                            end
                        end
                    end
                    Parser.measuredone = true
                    Parser.currentmeasure = {}
                    Parser.insertbarline = true
                else
                    Parser.measuredone = false
                end
            end


        end
    end



    print('Parsing Took: '.. SToMs(os.clock() - time) .. 'ms')


    return Out
end







--Taiko.ParseTJA(io.open('./tja/imaginarytest.tja','r'):read('*all'))error()















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

    local speed = (noteradius * note.scroll * note.bpm / 7500) -- - 0.06
    return speed
end

function Taiko.CalculateSpeedAll(ParsedData, noteradius)
    --local t = {}
    for i = 1, #ParsedData do
        ParsedData[i].speed = Taiko.CalculateSpeed(ParsedData[i], noteradius)
        --print(Parsed.Data[i].speed)
        --table.insert(t, Parsed.Data[i].speed)
    end
    return ParsedData
end











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












--Make sure to endwin first
--function Taiko.PlaySong(Parsed, Difficulty, Controls, Window)
function Taiko.PlaySong(Parsed, Window, Settings, Controls)

    --[[
    local profiler = require'profiler'
    profiler.start()
    --]]

    --collectgarbage('stop')

    --[[
    local i = 0
    for k, v in pairs(Taiko.GetDifficulty(Parsed, Difficulty).Data) do
        if v.data == 'note' then
            i = i + 1
        end
        print(k, v, v.data)
    end
    print(i)
    error()
    --]]














    --[[
        noteradius coordinates
        123456789
    ]]


    --[[
    --Discontinued, most of performance is renderering
    local precalculate = true --Biggest modifier
    --]]

    --Really dumb idea, memory intensive, trading memory with performance
    --WARNING: OUTDATED!!!
    local prerender = {
        on = false, --Biggest modifier
        fps = 60, --Desired fps
        frames = {} --Internal frame storage
    } --Biggest modifier




    local framerate = nil --Set frame rate, if nil then it is as fast as it can run



    --SETTINGS (map from selectsong)



    
    --SUS
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
    --local autoemu = false --Emulate key on auto

    local notespeedmul = optionsmap.notespeedmul[Settings[3]] or 1 --Note Speed multiplier
    local songspeedmul = optionsmap.songspeedmul[Settings[4]] or 1 --Actual speed multiplier

    local stopsong = true --Stop song enabled?



    --Controls
    --Hit, Escape, L, R, Select
    local Controls = Controls or {}
    Controls = {
        --1 = don, 2 = ka
        Hit = Controls.Hit or {
            ['4'] = 2,
            ['v'] = 1,
            ['n'] = 1,
            ['8'] = 2,
        },
        --Pause
        Escape = Controls.Escape or {
            ['\27'] = true,
            ALT_ESC = true,
        },
        --Scroll
        L = Controls.L or {
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
        R = Controls.R or {
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
        Select = Controls.Select or {
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

    local Selected = 1
    local SelectedPadding = 2
    local SelectedChar = '>'
    local MenuConcat = '\n\n\n'



    
    

    --local buffer = 100 --Buffer (ms)
    local bufferlength = 10 --Pixels
    local unloadbuffer = 10 --Pixels (added to bufferlength)

    --[[ Extracted from metadata
    local startms = 0 --Subtracted from all notes (ms)
    --]]
    local endms = 1000 --Added to last note (ms)

    local noteradius = 4 --Default: 2


    local y = 0 --Pixels, y render center
    local tracky = 10 --Pixels, radius of track width
    local trackstart = 0 --Pixels, start of track


    local tracklength = 40  --In noteradius from left (taiko-web)
    local target = 3 --In noteradius from left, representing center (taiko-web)
    local factor = 1 --Zoom factor / Size Multiplier


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
    local statuslength = 200 --Status length (good/ok/bad) (ms)
    --local statusflicker = 50 --Status flicker (Delay from startms render) (good/ok/bad) (ms) --Depracated
    local statusanimationlength = statuslength / 4 --Status animation length (ms) --FIX
    local statusanimationmove = 4 --Status animation move (pixels)

    local flashlength = 20 --Flash length (normal/big) (good/ok/bad) (ms)

    --statuslength = statuslength + statusflicker






    --Multiply noteradius
    tracklength = math.floor(tracklength * noteradius)
    local trackend = trackstart + tracklength
    target = math.floor(target * noteradius)





    --local curses = require('taikocurses')




    local window = Window or {
        window = curses.initscr()
    }

    curses.keypad(window, true)
    curses.echo(false)
    curses.raw(true)
    curses.nl(false)
    curses.cbreak(true)
    
    curses.nodelay(window, true)






    --local Pixel = require('Pixels')


    --pixeltest.lua
    --PixelToTable.lua
    local timingpixel = {
        --BAD ()
        [0] = {Data={[1]={'0','1','1','1','1','1','1','1'},[2]={[2]='1',[5]='1',[8]='1'},[3]={[2]='1',[5]='1',[8]='1'},[4]={[2]='1',[5]='1',[8]='1'},[5]={[2]='1',[5]='1',[8]='1'},[6]={[3]='1',[4]='1',[6]='1',[7]='1'},[8]={'0','0','1','1','1','1','1','1'},[9]={[2]='1',[5]='1'},[10]={[2]='1',[5]='1'},[11]={[2]='1',[5]='1'},[12]={[2]='1',[5]='1'},[13]={'0','0','1','1','1','1','1','1'},[15]={'0','1','1','1','1','1','1','1'},[16]={[2]='1',[8]='1'},[17]={[2]='1',[8]='1'},[18]={[2]='1',[8]='1'},[19]={[2]='1',[8]='1'},[20]={'0','0','1','1','1','1','1','0'}},Color={All='blue'},Offset={-1,0}},
        --OK
        [1] = {Data={[1]={'0','0','1','1','1','1','1','0'},[2]={[2]='1',[8]='1'},[3]={[2]='1',[8]='1'},[4]={[2]='1',[8]='1'},[5]={[2]='1',[8]='1'},[6]={'0','0','1','1','1','1','1','0'},[8]={'0','1','1','1','1','1','1','1'},[9]={[5]='1'},[10]={[4]='1',[6]='1'},[11]={[3]='1',[7]='1'},[12]={[2]='1',[8]='1'}},Color={All='white'},Offset={-1,0}},
        --GOOD
        [2] = {Data={[1]={'0','0','1','1','1','1','1','0'},[2]={[2]='1',[8]='1'},[3]={[2]='1',[8]='1'},[4]={[2]='1',[5]='1',[8]='1'},[5]={[2]='1',[5]='1',[8]='1'},[6]={'0','1','0','0','1','1','1','1'},[8]={'0','0','1','1','1','1','1','0'},[9]={[2]='1',[8]='1'},[10]={[2]='1',[8]='1'},[11]={[2]='1',[8]='1'},[12]={[2]='1',[8]='1'},[13]={'0','0','1','1','1','1','1','0'},[15]={'0','0','1','1','1','1','1','0'},[16]={[2]='1',[8]='1'},[17]={[2]='1',[8]='1'},[18]={[2]='1',[8]='1'},[19]={[2]='1',[8]='1'},[20]={'0','0','1','1','1','1','1','0'},[22]={'0','1','1','1','1','1','1','1'},[23]={[2]='1',[8]='1'},[24]={[2]='1',[8]='1'},[25]={[2]='1',[8]='1'},[26]={[2]='1',[8]='1'},[27]={'0','0','1','1','1','1','1','0'}},Color={All='yellow'},Offset={-1,0}},
        Size = {27, 8}
    }
    --[[
    for k, v in pairs(timingpixel) do
        local c = {}
        for x, v2 in pairs(v.Data) do
            for y, v3 in pairs(v2) do
                c[x] = c[x] or {}
                c[x][y] = v.Color
            end
        end
        timingpixel[k].Color = c
    end
    --]]
    timingpixel[3] = timingpixel[2] --BIGGOOD



    local flashpixel = {
        [0] = nil,
        [1] = {},
        [2] = {}
    }

















    --Pixel starts here

    local Pixel

    if OptimizedPixel then
        Pixel = OptimizedPixel
    else





    os.execute('chcp 65001') --Makes your terminal support unicode. If it is buggy, turn it off
    Pixel = {}




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
            --newt[ToBinary(i - 1)] = format(t[i])
            newt[i - 1] = format(t[i])
            --[[
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
            --]]
        end
        --[[
        if inputa then
            print(str)
            io.open('Data.lua', 'a+'):write(str)
        end
        --]]
        return newt
    end
    Pixel.Data = {}
    Pixel.Data.Dot = GenerateDotData()
    --Order: LU, RU, LD, RD























    --Pixel.ColorData = Pixel.Color.Data
    Pixel.ColorData = {
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
    Pixel.Color = {}
    for k, v in pairs(Pixel.ColorData) do
        Pixel.Color[k] = '\27[' .. v .. 'm'
    end

    --min, max, to prevent screen bobbing
    local minx, maxx = trackstart, tracklength
    local miny, maxy = -tracky, tracky
    miny, maxy = -20, 20

    --minx and maxx not needed, modified, OPTIMIZED
    --write to str, row scanning removed
    --Pixel.Color removed
    Pixel.Convert = {}
    Pixel.Convert.ToDots = function(str, outoffsetx) --converts a given data table
        outoffsetx = outoffsetx or 0
        local minx, maxx = minx + outoffsetx, maxx + outoffsetx
        --[[
        if nomax then
            local min, max = nil, nil
            for x, v in pairs(str.Data) do
                min = min and (x < min and x or min) or x
                max = max and (x > max and x or max) or x
            end
            minx, maxx = min, max
        end
        --]]

        --The pixels might look off, but they are not
        --[[
        Format:
        t[x][y]
    
        ]]
        --Data
        --str = GetPixelData(str) --Read Only
        local data, colordata = str.Data, str.Color
        
        --local data, color = str.Data, str.Color
        --[[
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
        --]]
        --Make sure to not write to str
        --[[
        str = {
            Data = data,
            Color = color
        }
        --]]
        --Stats
        --[[
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
        --]]
        --print(minx, maxx, miny, maxy)
        --Optimizations
        local out = {}
        --local zerostring = string.rep('0', 8)
        local zerostring = 0
        local zerodot = Pixel.Data.Dot[zerostring]
        local currentcolor = nil
        local allcolor = nil
        --local resetcolor = tostring(Pixel.Color('reset'))
        local resetcolor = Pixel.Color['reset']
        if str.Color.All then
            --local c = tostring(Pixel.Color(str.Color.All))
            local c = Pixel.Color[str.Color.All]
            --table.insert(out, c)
            out[#out + 1] = c
            allcolor = c
        end
        --[[
        local rows = {}
        for x, v in pairs(data) do
            for y, v2 in pairs(v) do
                rows[y] = rows[y] or {}
                rows[y][x] = v2
            end
        end
        --]]
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
                --[[
                local pixel = ''
                local c = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}}
                for i = 1, 8 do
                    local x, y = x + c[i][1], y + c[i][2]
                    pixel = pixel .. ((data[x] and data[x][y] or false) and data[x][y] or Pixel.Data.Empty)
                end
                --]]






                --ugly formula

                --v1
                --[[
                local dx = data[x]
                local dx2 = data[x + 1]
                local pixel = ((dx) and ((dx[y] or '0') .. (dx[y + 1] or '0') .. (dx[y + 2] or '0') .. (dx[y + 3] or '0')) or '0000') .. ((dx2) and ((dx2[y] or '0') .. (dx2[y + 1] or '0') .. (dx2[y + 2] or '0') .. (dx2[y + 3] or '0')) or '0000')
                --]]


                --v2 (SLOW)
                --[[
                local dx = data[x]
                local dx2 = data[x + 1]
                local pixel = ((dx) and (table.concat{(dx[y] or '0'), (dx[y + 1] or '0'), (dx[y + 2] or '0'), (dx[y + 3] or '0')}) or '0000') .. ((dx2) and (table.concat{(dx2[y] or '0'), (dx2[y + 1] or '0'), (dx2[y + 2] or '0'), (dx2[y + 3] or '0')}) or '0000')
                --]]

                --v3
                --[[
                local dx = data[x]
                local dx2 = data[x + 1]
                local pixel = 
                (dx and (
                    (dx[y] or 0) + 
                    (dx[y + 1] or 0) * 2 + 
                    (dx[y + 2] or 0) * 4 + 
                    (dx[y + 3] or 0) * 8
                ) or 0) + 
                (dx2 and (
                    (dx2[y] or 0) * 16 + 
                    (dx2[y + 1] or 0) * 32 + 
                    (dx2[y + 2] or 0) * 64 + 
                    (dx2[y + 3] or 0) * 128
                ) or 0)
                --]]

                --v4
                -- [[
                local dx = data[x]
                local dx2 = data[x + 1]
                local pixel = 
                (dx and (
                    (dx[y] or 0) * 128 + 
                    (dx[y + 1] or 0) * 64 + 
                    (dx[y + 2] or 0) * 32 + 
                    (dx[y + 3] or 0) * 16
                ) or 0) + 
                (dx2 and (
                    (dx2[y] or 0) * 8 + 
                    (dx2[y + 1] or 0) * 4 + 
                    (dx2[y + 2] or 0) * 2 + 
                    (dx2[y + 3] or 0)
                ) or 0)
                --]]


                --print(pixel, x, y, color)
                if pixel ~= zerostring then
                    pixel = Pixel.Data.Dot[pixel]
                    --local x, y = Pixel.PushColor(x, y)
                    if not allcolor then
                        --local color = Pixel.GetColor(str, x, y)
                        --local color = color[x] and color[x][y]

                        --if color==nil then print(x, y, color) end
                        --if not allcolor and color then
                        --find all 8 pixels

                        --[[
                        if not color then
                            local c = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}}
                            for i = 1, 8 do
                                color = Pixel.GetColor(str, x + c[i][1], y + c[i][2])
                                if color then
                                    break
                                end
                            end
                        end
                        --]]



                        --Ugly formula time!
                        --v1
                        local dx = colordata[x]
                        local dx2 = colordata[x + 1]
                        local color = ((dx) and (dx[y] or dx[y + 1] or dx[y + 2] or dx[y + 3])) or ((dx2) and (dx2[y] or dx2[y + 1] or dx2[y + 2] or dx2[y + 3]))












                        if color then
                            --color = tostring(Pixel.Color(color))
                            color = Pixel.Color[color]

                        else
                            color = resetcolor
                        end
                        if currentcolor == color then
                            --Do Nothing
                        else
                            --table.insert(out, color)
                            out[#out + 1] = color
                            currentcolor = color
                        end
                    end
                    --table.insert(out, string.rep(zerodot, (x - minx - 1) / 2))
                    --table.insert(out, pixel)
                    out[#out + 1] = pixel
                else
                    --table.insert(out, zerodot)
                    out[#out + 1] = zerodot
                end
            end
            --table.insert(out, Pixel.Data.NewLine)
            --table.insert(out, '\n')
            out[#out + 1] = '\n'
        end
        --table.insert(out, resetcolor)
        out[#out + 1] = resetcolor
        --ppp(out)
        return table.concat(out)
    end










    Pixel.ToDotsParallel = function(str, str2, outoffsetx) --converts a given data table
        outoffsetx = outoffsetx or 0
        local minx, maxx = minx + outoffsetx, maxx + outoffsetx
        --[[
        if nomax then
            local min, max = nil, nil
            for x, v in pairs(str.Data) do
                min = min and (x < min and x or min) or x
                max = max and (x > max and x or max) or x
            end
            minx, maxx = min, max
        end
        --]]

        --The pixels might look off, but they are not
        --[[
        Format:
        t[x][y]
    
        ]]
        --Data
        --str = GetPixelData(str) --Read Only
        local data, colordata = str.Data, str.Color
        local data2, colordata2 = str2.Data, str2.Color
        --local data, color = str.Data, str.Color
        --[[
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
        --]]
        --Make sure to not write to str
        --[[
        str = {
            Data = data,
            Color = color
        }
        --]]
        --Stats
        --[[
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
        --]]
        --print(minx, maxx, miny, maxy)
        --Optimizations
        local out = {}
        --local zerostring = string.rep('0', 8)
        local zerostring = 0
        local zerodot = Pixel.Data.Dot[zerostring]
        local currentcolor = nil
        local allcolor = nil
        --local resetcolor = tostring(Pixel.Color('reset'))
        local resetcolor = Pixel.Color['reset']
        if str.Color.All then
            --local c = tostring(Pixel.Color(str.Color.All))
            local c = Pixel.Color[str.Color.All]
            --table.insert(out, c)
            out[#out + 1] = c
            allcolor = c
        end
        --[[
        local rows = {}
        for x, v in pairs(data) do
            for y, v2 in pairs(v) do
                rows[y] = rows[y] or {}
                rows[y][x] = v2
            end
        end
        --]]
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
                --[[
                local pixel = ''
                local c = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}}
                for i = 1, 8 do
                    local x, y = x + c[i][1], y + c[i][2]
                    pixel = pixel .. ((data[x] and data[x][y] or false) and data[x][y] or Pixel.Data.Empty)
                end
                --]]






                --ugly formula

                --v1
                --[[
                local dx21 = data2[x]
                local dx22 = data2[x + 1]
                local dx = data[x]
                local dx2 = data[x + 1]
                local pixel = ((dx or dx21) and ((dx[y] or dx21[y] or '0') .. (dx[y + 1] or dx21[y + 1] or '0') .. (dx[y + 2] or dx21[y + 2] or '0') .. (dx[y + 3] or dx21[y + 3] or '0')) or '0000') .. ((dx2 or dx22) and ((dx2[y] or dx22[y] or '0') .. (dx2[y + 1] or dx22[y + 1] or '0') .. (dx2[y + 2] or dx22[y + 2] or '0') .. (dx2[y + 3] or dx22[y + 3] or '0')) or '0000')
                --]]


                --v2
                --[[
                local dx = data[x]
                local dx2 = data[x + 1]
                local pixel = ((dx) and (table.concat{(dx[y] or '0'), (dx[y + 1] or '0'), (dx[y + 2] or '0'), (dx[y + 3] or '0')}) or '0000') .. ((dx2) and (table.concat{(dx2[y] or '0'), (dx2[y + 1] or '0'), (dx2[y + 2] or '0'), (dx2[y + 3] or '0')}) or '0000')
                --]]

                --v4
                --[[
                local dx = data[x]
                local dx2 = data[x + 1]
                local dx21 = data2[x]
                local dx22 = data2[x + 1]
                local pixel = 
                ((dx or dx21) and (
                    (dx[y] or dx21[y] or 0) * 128 + 
                    (dx[y + 1] or dx21[y + 1] or 0) * 64 + 
                    (dx[y + 2] or dx21[y + 2] or 0) * 32 + 
                    (dx[y + 3] or dx21[y + 3] or 0) * 16
                ) or 0) + 
                ((dx2 or dx22) and (
                    (dx2[y] or dx22[y] or 0) * 8 + 
                    (dx2[y + 1] or dx22[y + 1] or 0) * 4 + 
                    (dx2[y + 2] or dx22[y + 2] or 0) * 2 + 
                    (dx2[y + 3] or dx22[y + 3] or 0)
                ) or 0)
                --]]

                --v4
                -- [[
                local dx = data[x]
                local dx2 = data[x + 1]
                local dx21 = data2[x]
                local dx22 = data2[x + 1]
                local pixel = 
                ((dx and dx21) and (
                    (dx[y] or dx21[y] or 0) * 128 + 
                    (dx[y + 1] or dx21[y + 1] or 0) * 64 + 
                    (dx[y + 2] or dx21[y + 2] or 0) * 32 + 
                    (dx[y + 3] or dx21[y + 3] or 0) * 16
                ) or
                (dx) and (
                    (dx[y] or 0) * 128 + 
                    (dx[y + 1] or 0) * 64 + 
                    (dx[y + 2] or 0) * 32 + 
                    (dx[y + 3] or 0) * 16
                ) or
                (dx21) and (
                    (dx21[y] or 0) * 128 + 
                    (dx21[y + 1] or 0) * 64 + 
                    (dx21[y + 2] or 0) * 32 + 
                    (dx21[y + 3] or 0) * 16
                )
                
                or 0) + 
                ((dx2 and dx22) and (
                    (dx2[y] or dx22[y] or 0) * 8 + 
                    (dx2[y + 1] or dx22[y + 1] or 0) * 4 + 
                    (dx2[y + 2] or dx22[y + 2] or 0) * 2 + 
                    (dx2[y + 3] or dx22[y + 3] or 0)
                ) or
                (dx2) and (
                    (dx2[y] or 0) * 8 + 
                    (dx2[y + 1] or 0) * 4 + 
                    (dx2[y + 2] or 0) * 2 + 
                    (dx2[y + 3] or 0)
                ) or
                (dx22) and (
                    (dx22[y] or 0) * 8 + 
                    (dx22[y + 1] or 0) * 4 + 
                    (dx22[y + 2] or 0) * 2 + 
                    (dx22[y + 3] or 0)
                )
                
                or 0)
                --]]
























                --print(pixel, x, y, color)
                if pixel ~= zerostring then
                    pixel = Pixel.Data.Dot[pixel]
                    --local x, y = Pixel.PushColor(x, y)
                    if not allcolor then
                        --local color = Pixel.GetColor(str, x, y)
                        --local color = color[x] and color[x][y]

                        --if color==nil then print(x, y, color) end
                        --if not allcolor and color then
                        --find all 8 pixels

                        --[[
                        if not color then
                            local c = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}}
                            for i = 1, 8 do
                                color = Pixel.GetColor(str, x + c[i][1], y + c[i][2])
                                if color then
                                    break
                                end
                            end
                        end
                        --]]



                        --Ugly formula time!
                        --v1
                        --[[
                        local dx21 = data2[x]
                        local dx22 = data2[x + 1]
                        local dx = data[x]
                        local dx2 = data[x + 1]
                        local pixel = ((dx or dx21) and ((dx[y] or dx21[y]) or (dx[y + 1] or dx21[y + 1]) or (dx[y + 2] or dx21[y + 2]) or (dx[y + 3] or dx21[y + 3]))) or ((dx2 or dx22) and ((dx2[y] or dx22[y]) or (dx2[y + 1] or dx22[y + 1]) or (dx2[y + 2] or dx22[y + 2]) or (dx2[y + 3] or dx22[y + 3])))
                        --]]
                        --v2 
                        local dx21 = colordata2[x]
                        local dx22 = colordata2[x + 1]
                        local dx = colordata[x]
                        local dx2 = colordata[x + 1]
                        local color = 
                        dx and (dx[y] or dx[y + 1] or dx[y + 2] or dx[y + 3]) or
                        dx2 and (dx2[y] or dx2[y + 1] or dx2[y + 2] or dx2[y + 3]) or 
                        dx21 and (dx21[y] or dx21[y + 1] or dx21[y + 2] or dx21[y + 3]) or 
                        dx22 and (dx22[y] or dx22[y + 1] or dx22[y + 2] or dx22[y + 3])












                        if color then
                            --color = tostring(Pixel.Color(color))
                            color = Pixel.Color[color]

                        else
                            color = resetcolor
                        end
                        if currentcolor == color then
                            --Do Nothing
                        else
                            --table.insert(out, color)
                            out[#out + 1] = color
                            currentcolor = color
                        end
                    end
                    --table.insert(out, string.rep(zerodot, (x - minx - 1) / 2))
                    --table.insert(out, pixel)
                    out[#out + 1] = pixel
                else
                    --table.insert(out, zerodot)
                    out[#out + 1] = zerodot
                end
            end
            --table.insert(out, Pixel.Data.NewLine)
            --table.insert(out, '\n')
            out[#out + 1] = '\n'
        end
        --table.insert(out, resetcolor)
        out[#out + 1] = resetcolor
        --ppp(out)
        return table.concat(out)
    end








    --Optimize!
    --Pixel.CircleGen = function(self, cx, cy, r, options)
    Pixel.CircleGen = function(str, cx, cy, r, options)
        --str = GetPixelData(self)
        options = options or {}
        local color = options.color
        --[[
        Scanline Algorithm
        https://stackoverflow.com/questions/10322341/simple-algorithm-for-drawing-filled-ellipse-in-c-c
        Do a quarter, then mirror
        Region is: Right Down
        --]]

        --[[
        local function check(x, y)
            --if r can be negative
            --return x * x * r * r + y * y * r * r <= r * r * r * r
            --if r is positive
            return x * x + y * y <= r * r
        end
        --]]



        --precompute
        local r2 = r * r

        local x = r
        for y = 0, r do
            --[[
            local a = false
            repeat
                a = x * x + y * y <= r2
                x = x - 1
            until a
            x = x + 1
            --]]
            -- [[
            x = x + 1
            repeat
                x = x - 1
            until x * x + y * y <= r2
            --]]
           
            
            for x2 = 0, x do
                --[[
                Pixel.SetPixel(str, cx + x2, cy + y, '1', options)
                Pixel.SetPixel(str, cx - x2, cy + y, '1', options)
                Pixel.SetPixel(str, cx + x2, cy - y, '1', options)
                Pixel.SetPixel(str, cx - x2, cy - y, '1', options)
                --]]
                str.Data[cx + x2] = str.Data[cx + x2] or {}
                str.Data[cx - x2] = str.Data[cx - x2] or {}
                str.Data[cx + x2][cy + y] = '1'
                str.Data[cx - x2][cy + y] = '1'
                str.Data[cx + x2][cy - y] = '1'
                str.Data[cx - x2][cy - y] = '1'
    
    
                --color --FIX
                --if true then
                    str.Color[cx + x2] = str.Color[cx + x2] or {}
                    str.Color[cx - x2] = str.Color[cx - x2] or {}
                    str.Color[cx + x2][cy + y] = color
                    str.Color[cx - x2][cy + y] = color
                    str.Color[cx + x2][cy - y] = color
                    str.Color[cx - x2][cy - y] = color
                --end
            end
    
        end
        return str
    end

    local circlecache = {}
    --Pixel.Circle = function(self, cx, cy, r, options)
    Pixel.Circle = function(str, cx, cy, r, options)
        --local str = GetPixelData(self)
        local circle = nil
        if circlecache[r] then
            
        else
            circlecache[r] = Pixel.CircleGen(Pixel.New(), 0, 0, r)
        end
        local c = options and options.color
        circle = circlecache[r]
        for x, v in pairs(circle.Data) do
            for y, v2 in pairs(v) do
                local x, y = x + cx, y + cy
                str.Data[x] = str.Data[x] or {}
                str.Data[x][y] = v2

                --color
                str.Color[x] = str.Color[x] or {}
                str.Color[x][y] = c
            end
        end
        return str
    end

    Pixel.New = function()
        return {
            Data = {},
            Color = {}
        }
    end


    OptimizedPixel = Pixel
    end






























    local function RenderBarline(out, note)
        local x = math.floor(note.p)
        local y1, y2 = y - tracky, y + tracky
        for y = y1, y2 do
            --[[
            --local a = Pixel.GetPixel(out, x, y)
            local a = out.Data[x] and out.Data[x][y]
            if a == '0' or a == nil then
                --Pixel.SetPixel(out, x, y, '1')
                out.Data[x] = out.Data[x] or {}
                out.Data[x][y] = '1'
            end
            --]]
            out.Data[x] = out.Data[x] or {}
            out.Data[x][y] = '1'
        end
    end

    local function RenderCircle(out, note, p)     
        --Pixel.Circle(out, math.floor(note.p), y, noteradius * note.radius, renderconfig[note.type])
        --add support for ends (faster)
        p = p or note.p
        Pixel.Circle(out, math.floor(p), y, noteradius * note.radius, renderconfig[note.type])
    end

    local function RenderRect(out, x1, x2, y1, y2, options)
        local options = options or {}
        color = options.color
        --clipping moved
        --Actual rendering
        for y = y1, y2 do
            for x = x1, x2 do
                --Pixel.SetPixel(out, x, y, '1')
                out.Data[x] = out.Data[x] or {}
                out.Data[x][y] = '1'
                if color then
                    --Pixel.SetColor(out, x, y, color)
                    out.Color[x] = out.Color[x] or {}
                    out.Color[x][y] = color
                end
            end
        end
    end

    local clipx1 = (trackstart - bufferlength)
    local clipx2 = (tracklength + bufferlength)
    local function RenderNote(out, note, speedopt)
        local n = note.type
        if n == 1 or n == 2 or n == 3 or n == 4 then
            RenderCircle(out, note)
        elseif n == 5 or n == 6 then
            RenderCircle(out, note)
            local endnote = note.endnote
            --Distance = speed * time
            local length = (endnote.ms - note.ms) * note.speed
            --Render start and end, and rect
            --RenderCircle(out, note)
            --RenderCircle(out, endnote)
            local r = noteradius * note.radius
            local x1, x2 = math.floor(note.p), math.floor(note.p + length)
            local y1 = math.floor(y - r)
            local y2 = math.floor(y + r)
        
            RenderCircle(out, endnote, x2)

            if speedopt then
                
            else
                --x reverse (x only (y is irrelevant right now))
                if x1 > x2 then
                    x1, x2 = x2, x1
                end


                --Clip!
                --Don't use ClipN since function overhead
                if x1 < clipx1 then
                    x1 = clipx1
                end

                if x2 > clipx2 then
                    x2 = clipx2
                end


                --[[
                if y1 > y2 then
                    y1, y2 = y2, y1
                end
                --]]
            end
            RenderRect(out, x1, x2, y1, y2, renderconfig[note.type])
        elseif n == 7 then

            --DEBUG
            note.radius = 0.8
            RenderCircle(out, note)
        elseif n == 8 then
            --RenderCircle(out, note.startnote, note.p)
            --[=[
            --lazy, do this faster
            if note.renderproxy then
                note.renderproxy.p = note.p
            else
                local startnote = note.startnote
                note.renderproxy = {}
                for k, v in pairs(startnote) do
                    --[[
                    if k ~= 'type' then
                        note.renderproxy[k] = v
                    end
                    --]]
                    --color
                    note.renderproxy[k] = v
                end
            end
            note.renderproxy.p = note.p
            RenderCircle(out, note.renderproxy)
            --]=]
        end
    end

    local function RenderStatus(out, status, ms, outoffsetx)
        --[[
        local slope = statusanimationmove / (statusanimationlength / 2)
        local anim = -slope * math.abs((ms - status.startms) - (statuslength / ))
        --]]
        local slope = statusanimationmove / (statusanimationlength / 2)
        local anim = -slope * math.abs(((ms - status.startms) / (statuslength / statusanimationlength)) - (statusanimationmove / slope)) + statusanimationmove

        --print(statusanimationlength, statusanimationmove, anim, ms - status.startms)io.read()
        local t = timingpixel[status.status]
        local o = t.Offset
        local c = t.Color.All --Color for all
        local ox, oy = 0, -math.floor(noteradius * 1.6) - 8 - math.floor(anim)
        local tox, toy = o[1] + ox + outoffsetx, o[2] + oy
        --print(tox, toy)

        for x = 1, timingpixel.Size[1] do
            for y = 1, timingpixel.Size[2] do
                local px, py = x + tox, y + toy
                out.Data[px] = out.Data[px] or {}
                out.Data[px][py] = t.Data[x] and t.Data[x][y]


                out.Color[px] = out.Color[px] or {}
                out.Color[px][py] = c
            end
        end
        --print(Pixel.Convert.ToDots(out, nil, true))io.read()
        --[=[
        for x, v in pairs(t.Data) do
            for y, v2 in pairs(v) do
                if v2 == '1' then
                    local x, y = x + tox, y + toy
                    out.Data[x] = out.Data[x] or {}
                    out.Data[x][y] = v2


                    out.Color[x] = out.Color[x] or {}
                    out.Color[x][y] = c
                    --[[
                    if c[x] and c[x][y] then
                        out.Color[x] = out.Color[x] or {}
                        out.Color[x][y] = c[x][y]
                    end
                    --]]
                end
            end
        end
        --]=]
    end

    --Render OVER! the note
    --TODO
    local function RenderFlash(out, status)
        local t = flashpixel[status.status]
        local o = t.Offset
        local c = t.Color.All --Color for all
        local ox, oy = 0, 0
        for x, v in pairs(t.Data) do
            for y, v2 in pairs(v) do
                if v2 == '1' then
                    local x, y = x + o[1] + ox, y + o[2] + oy
                    out.Data[x] = out.Data[x] or {}
                    out.Data[x][y] = v2


                    
                    out.Color[x] = out.Color[x] or {}
                    out.Color[x][y] = c
                    --[[
                    if c[x] and c[x][y] then
                        out.Color[x] = out.Color[x] or {}
                        out.Color[x][y] = c[x][y]
                    end
                    --]]
                end
            end
        end
    end





    --local Pixels = require([[C:\Users\User\OneDrive\code\Obfuscator\Utils\Graphics\Pixels\Versions\Pixelsv20]])
    --local Pixels = require[[C:/Users/User/OneDrive/code/Obfuscator/Utils/Graphics/Pixels/Versions/Pixelsv20]]


    local Ansi = {
        ClearScreen = function()
            io.write("\27[2J")
        end,
        SetCursor = function(x, y)
            io.write(string.format("\27[%d;%dH", y, x))
        end
    }








    --Parsed = Taiko.GetDifficulty(Parsed, Difficulty)


    local notetable = Taiko.GetAllNotes(Parsed.Data)



    --Parsed = Taiko.CalculateSpeedAll(Parsed, noteradius)











    --METADATA
    local startms = Parsed.Metadata.OFFSET

    --https://github.com/bui/taiko-web/blob/ba1a6ab3068af8d5f8d3c5e81380957493ebf86b/public/src/js/gamerules.js
    --local framems = 1000 / (framerate or 60) --don't use framerate
    local framems = 1000 / 60
    local timing = Parsed.Metadata.TIMING(framems / songspeedmul)











    --require'ppp'(Taiko.CalculateSpeedAll(Parsed, 1).Data[1])



    --Precalculate

    local function IsNote(note)
        return (note.data == 'note') or (note.data == 'event' and note.event == 'barline')
    end

    local function CalculateLoadMs(note, ms)
        --return ms - ((tracklength / note.speed) + buffer)
        --support negative speed
        --return ms - ((tracklength / math.abs(note.speed)) + buffer)
        --bufferlength
        return ms - (((tracklength + bufferlength) / math.abs(note.speed)))
    end
    local function CalculateLoadPosition(note, lms)
        return (note.ms - lms) * note.speed + target
    end
    local function CalculatePosition(note, ms, d)
        return note.loadp - (note.speed * (ms - note.loadms))
        --[[
        if d then
            --disable delay
            return note.loadp - (note.speed * (ms - note.loadms))
        else
            return note.loadp - (note.speed * (ms - note.loadms + (note.pdelay)))
        end
        --]]
    end









    --Convert everything to seconds + fill up timet
    --[[
    local timet = {}
    for k, v in pairs(Parsed.Data) do
        table.insert(timet, v.ms)
        v.ms = v.ms - startms
        v.s = MsToS(v.ms)
        v.loadms = CalculateLoadMs(v, v.ms)
        v.loads = MsToS(v.loadms)
        v.loadp = CalculateLoadPosition(v, v.loadms)
        --v.n = k --MISTAKE: after sorted
    end
    --]]
    local timet = {}
    for k, v in pairs(notetable) do
        --v.oms is original ms
        --oms
        v.ms = v.oms or v.ms
        v.oms = v.ms

        v.ms = (v.ms - startms) / songspeedmul
        v.s = MsToS(v.ms)
        --odelay
        v.delay = v.odelay or v.delay
        v.odelay = v.delay

        v.delay = v.delay / songspeedmul
        v.speed = (Taiko.CalculateSpeed(v, noteradius)) * notespeedmul
        v.loadms = CalculateLoadMs(v, v.ms)
        v.loads = MsToS(v.loadms)
        v.loadp = CalculateLoadPosition(v, v.loadms)
        --v.pdelay = 0
        v.hit = nil --Reset hit just in case
        --v.n = k --MISTAKE: after sorted
        --table.insert(timet, v.ms)
        timet[#timet + 1] = v.ms
        --print(v.speed, v.loadms, v.loadp)
    end

    if stopsong then
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

            if lastnote and lastnote.delay ~= 0 then
                --recalculate
                lastnote.ms = lastnote.ms - lastnote.delay
                lastnote.s = MsToS(lastnote.ms)
                lastnote.loadms = CalculateLoadMs(lastnote, lastnote.ms)
                lastnote.loads = MsToS(lastnote.loadms)
                lastnote.loadp = CalculateLoadPosition(lastnote, lastnote.loadms)
                lastnote.ms = lastnote.ms + lastnote.delay
                lastnote.s = MsToS(lastnote.ms)
            end


            lastnote = note
        end)

        --error()

        --[=[

        local lastnote
        local zerodelay = true
        Taiko.ForAll(Parsed.Data, function(note, i, n)
            --print(note.ms, note.delay, i, n)
            if note.delay ~= 0 then
                --recalculate time related
                --[[
                print(i)
                print('ms\tloadms\tloads\tloadp')
                print(note.ms, note.loadms, note.loads, note.loadp)
                --]]


                note.ms = note.ms - note.delay
                note.s = MsToS(note.ms)
                note.loadms = CalculateLoadMs(note, note.ms)
                note.loads = MsToS(note.loadms)
                note.loadp = CalculateLoadPosition(note, note.loadms)
                note.ms = note.ms + note.delay
                note.s = MsToS(note.ms)

                --[[
                note.ms = note.ms - (note.delay / songspeedmul)
                note.s = MsToS(note.ms)
                note.loadms = CalculateLoadMs(note, note.ms)
                note.loads = MsToS(note.loadms)
                note.loadp = CalculateLoadPosition(note, note.loadms)
                --]]






                --[[
                print(note.ms, note.loadms, note.loads, note.loadp)
                io.read()
                --]]
                --print(note.delay)
                --[[
                note.ms = note.ms - (note.delay / songspeedmul)
                note.s = MsToS(note.ms)
                note.loadms = CalculateLoadMs(note, note.ms)
                note.loads = MsToS(note.loadms)
                note.loadp = CalculateLoadPosition(note, note.loadms)
                --]]
                if zerodelay and lastnote then
                    lastnote.stopms = note.delay - lastnote.delay
                    lastnote.stopstart = lastnote.ms
                    lastnote.stopend = lastnote.stopstart + lastnote.stopms
                    
                    zerodelay = false
                end

                if note.nextnote and note.nextnote.delay ~= note.delay then
                    note.stopms = note.nextnote.delay - note.delay
                    note.stopstart = note.ms
                    note.stopend = note.stopstart + note.stopms
                end
            end
            lastnote = note

        end)

        --]=]

        --[[
        Taiko.ForAll(Parsed.Data, function(note, i, n)
            print(note.ms, note.delay, note.stopms, note.stopstart, note.stopend)
        end)

        io.read()

        stopsong = true --error()
        --]]
    end
    --error()
    --print(Parsed.Data[68].ms)error()

    --error()
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
        --delay
        -- [[
        --moved
        --]]
        --print(note.ms)
        --print(note.loadms, note.ms)
    end)
    --if''then return end
    --error()
    --]]

    --[[
    local nextnote = nil
    for i = #Parsed.Data, 1, -1 do
        local v = Parsed.Data[i]
        if IsNote(v) then
            v.n = i
            v.nextnote = nextnote
            nextnote = v
        end
    end
    --]]

    --[[
    --ppp
    for i = 1, #Parsed.Data do
        print(Parsed.Data[i].loads)
    end
    --]]

    --Calculate end time
    --local endms = math.max(unpack(timet)) + (endms / songspeedmul)

    local temp = endms / songspeedmul
    local endms = timet[1]
    for i = 1, #timet do
        if timet[i] > endms then
            endms = timet[i]
        end
    end
    endms = endms + temp



    --Check for spawns before game starts

    --[[
    local loaded = {
        s = 1, --Start
        e = 0, --End
        n = 0, --Number of loaded notes
        --nearestnote = {} --Table of nearest notes
    }
    --]]
    loaded = {}

    --Generate nearestnote
    --[[
    local lastms = nil
    for i = 1, #timet do
        if i ~= 1 then
            table.insert(loaded.nearestnote, {})
        end
        lastms = timet[i]
    end
    loaded.nearestnote = {}
    --]]





    local nextnote = Parsed.Data[1]
    local nextnotel = nextnote.loads

    --[[
    --redesign
    while true do
        if nextnote then
            nextnotel = nextnote.loads
            if nextnotel < 0 then
                --nextnote.p = CalculatePosition(nextnote, nextnotel)

                loaded.n = loaded.n + 1
                loaded[loaded.n] = nextnote
            else
                break
            end
        else
            break
        end
        nextnote = nextnote.nextnote
    end
    --]]

    --loaded.e = loaded.n






    --Statistics
    local padding = 10
    local paddingstr = string.rep(' ', padding)
    local statistics = {}
    local function Statistic(k, v)
        --[[
        table.insert(statistics, k)
        table.insert(statistics, ': ')
        table.insert(statistics, tostring(v))
        table.insert(statistics, paddingstr)
        table.insert(statistics, '\n')
        --]]
        statistics[#statistics + 1] = k
        statistics[#statistics + 1] = ': '
        statistics[#statistics + 1] = tostring(v)
        statistics[#statistics + 1] = paddingstr
        statistics[#statistics + 1] = '\n'
    end
    local function RenderStatistic()
        print(table.concat(statistics))
        statistics = {}
    end
    --Log (Debug system)
    local logs = {}
    local function Log(s)
        logs[#logs + 1] = s
    end
    local function RenderLog()
        print(table.concat(logs, '\n'))
        logs = {}
    end






    --error()
    Ansi.ClearScreen()

    --[[
    local firstpixel = math.floor(0 - noteradius - 1)
    local lastpixel = math.floor(tracklength * noteradius + noteradius + 1)
    --]]



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
    --local adddelay = false
    local totaldelay = 0





    --Statistics
    local lastinput = {-1, nil}
    local framen = 0
    local framerenderstotal = 0

    local dorender = true
    
    --Optimizations
    local dospeedopt = false

    local speedopt = false
    local speedoptspeed = nil
    local speedoptoldpos = nil
    local speedoptout = nil
    local speedoptfirstnote = nil
    local speedoptstartms = nil
    local speedoptstatus = nil



    --Main loop
    local startt = os.clock()


    --Frame Rate
    local frames, nextframes
    if framerate then
        frames = 1 / framerate
        nextframes = startt + frames
    end


    if not prerender.on then

        while true do
            --Make canvas
            local out = Pixel.New()

            local raws = os.clock()

            local s = raws - startt
            local ms = s * 1000


            --Event checking
            if stopend and ms > stopend then
                stopfreezems, stopstart, stopend = nil, nil, nil
            end
            if balloon and ms > balloonend then
                balloon, balloonstart, balloonend = nil, nil, nil
            end
            if drumroll and ms > drumrollend then
                drumroll, drumrollstart, drumrollend = nil, nil, nil
            end





            --See if next note is ready to be loaded
            if nextnote then
                if nextnote.loadms < ms then
                    --load
                    --print('load i'..nextnote.n ..' s'.. loaded.s .. ' e' .. loaded.e .. ' n' .. loaded.n)


                    --loaded.n = loaded.n + 1
                    --loaded.e = loaded.n
                    --loaded.e = nextnote.n

                    --loaded[nextnote.n] = nextnote
                    loaded[#loaded + 1] = nextnote






                    --speedopt
                    if speedopt and nextnote.speed ~= speedoptspeed then
                        speedopt = false
                    end
                    if speedopt then
                        --nextnote.p = CalculatePosition(nextnote, ms)
                        --nextnote.p = nextnote.loadp
                        nextnote.p = CalculatePosition(nextnote, speedoptstartms)
                        --Log(nextnote.p)
                        --print(nextnote.p, io.read())
                        if nextnote.data == 'event' then
                            if nextnote.event == 'barline' then
                                RenderBarline(speedoptout, nextnote, speedopt)
                            end
                        elseif nextnote.data == 'note' then
                            RenderNote(speedoptout, nextnote, speedopt)
                        else
                            error('Invalid note.data')
                        end
                    end








                    --nextnote

                    nextnote = nextnote.nextnote
                    
                    if nextnote and nextnote.branch then
                        --Log('branch')
                        --[[
                        Taiko.ForAll(nextnote.branch.paths[branch], function(note, i, n)
                            print(note.ms)
                        end)
                        error()
                        --]]

                        nextnote = nextnote.branch.paths[branch][1]

                    end



                    


                    --[[
                    if loaded.s == 0 then
                        loaded.s = 1
                    end
                    loaded.e = loaded.n
                    loaded.n = loaded.n + 1
                    loaded[loaded.n + 1] = nextnote
                    nextnote = nextnote.nextnote
                    --]]





                    --[[
                    local breaker = false
                    if not nextnote then
                        while true do
                            local s = os.clock() - startt
                            if s > ends then
                                breaker = true
                                break
                            end
                        end
                        if breaker then
                            break
                        end
                    end
                    --]]
                end
            else
                if ms > endms then
                    break
                end
            end

            --[[
            print(loaded.s, loaded.e, loaded.n)
            io.read()
            --]]









            --SPEEDOPT
            if dospeedopt and speedopt == false then

                --Check if we can use optimization
                local s = nil
                for i = 1, #loaded do
                    if s then
                        if loaded[i] and s ~= loaded[i].speed then
                            s = false
                            break
                        end
                    else
                        s = loaded[i].speed
                    end
                end
                if s then
                    speedoptstartms = ms
                    speedoptspeed = s
                    speedoptout = false
                    --speedoptfirstnote = loaded[loaded.s] or loaded[loaded.s + 1] --shitty way, dirty
                    speedoptfirstnote = loaded[1]
                    speedopt = true
                else
                    speedopt = false
                end
            end

            local outoffsetx = 0
            if speedopt and speedoptout then
                dorender = false

                --local firstnote = loaded[loaded.s] or loaded[loaded.s + 1] --shitty fix, --dirty
                local firstnote = loaded[1]
                local oldpos = speedoptoldpos or firstnote.p
                speedoptoldpos = oldpos
                local newpos = CalculatePosition(speedoptfirstnote, ms)
                oldpos = oldpos or newpos


                local dif = math.floor(oldpos - newpos + 0.5)

                if dif >= 1 then
                    --[[
                    --move canvas left by dif
                    local newout = Pixel.New()

                    --draw target
                    Pixel.Circle(newout, math.floor(target), y, noteradius, {color = 'purple'})


                    for x, v in pairs(speedoptout.Data) do
                        newout.Data[x - dif] = v
                    end

                    for x, v in pairs(speedoptout.Color) do
                        newout.Color[x - dif] = v
                    end
                    out = newout
                    --]]
                    outoffsetx = dif
                    --out = speedoptout
                    --[[
                    speedoptout = newout
                    speedoptoldpos = speedoptoldpos - (oldpos - newpos)
                    --]]
                else
                    --do nothing
                    
                end
                out = speedoptout
            else
                speedoptoldpos = nil
                dorender = true
            end

            















            --rendering




            --draw target

            --normal
            if dorender and speedoptout ~= false then
                Pixel.Circle(out, math.floor(target), y, noteradius, {color = 'purple'})
            end
            if speedopt then
                speedoptstatus = Pixel.New()
                Pixel.Circle(speedoptstatus, math.floor(target) + outoffsetx, y, noteradius, {color = 'purple'})
            end
            --big note (1.6x)
            --Pixel.Circle(out, math.floor(target), y, noteradius * 1.6, {color = 'purple'})



            --notes

            --nearest (IF THERE IS NOTHING LOADED IT WILL BE NIL)
            local nearest = {
                
            }
            local nearestnote = {

            }
            --[[
            --ugly
            local nearest1 = nil
            local nearestnote1 = nil
            local nearest2 = nil
            local nearestnote2 = nil
            --]]

            --for i = loaded.s, loaded.e do
            local offseti = 0
            for i = 1, #loaded do
                local i2 = i + offseti
                local note = loaded[i2]
                if note then
                    --nearest
                    --if not nearest or (ms - note.ms > 0 and ms - note.ms < nearest) or (note.ms - ms > 0 and note.ms - ms < nearest)
                    if note.data == 'note' then
                        if (note.type == 1 or note.type == 3) and (not nearest[1] or math.abs(ms - note.ms) < nearest[1]) then
                            nearest[1] = math.abs(ms - note.ms)
                            nearestnote[1] = note
                        elseif (note.type == 2 or note.type == 4) and (not nearest[2] or math.abs(ms - note.ms) < nearest[2]) then
                            nearest[2] = math.abs(ms - note.ms)
                            nearestnote[2] = note
                        end
                    end


                    --[[
                    if stopsong and (not stopstart) and note.stopstart and ms > note.stopstart then
                        stopfreezems = totaldelay + note.stopstart
                        stopms = note.stopms
                        totaldelay = totaldelay - note.stopms
                        stopstart = note.stopstart
                        stopend = note.stopend

                        --to prevent retriggering
                        note.stopstart = nil
                    end
                    --]]

                    --print(ms, loaded.s, loaded.e, loaded.n)
                    note.p = CalculatePosition(note, stopfreezems or (ms + totaldelay))




                    --after target pass
                    if ms > note.ms then
                        --gogo
                        gogo = note.gogo
                        if note.type == 7 then
                            if balloon then
                                if balloon.n == note.n then
                                    --Same balloon
                                    note.p = target
                                else
                                    --Previous balloon hasn't ended yet
                                    --Replace
                                end
                            end
                            balloon = note
                            balloonstart = note.ms
                            balloonend = note.ms + note.length
                        elseif note.type == 5 or note.type == 6 then
                            --Drumroll
                            drumroll = note
                            drumrollstart = note.ms
                            drumrollend = note.ms + note.length
                        end
                    end





                    -- [[
                    --if stopsong and note.stopstart and note.p < target then
                    --if stopsong and (not stopstart) and note.stopstart and ms > note.stopstart then
                    if stopsong and note.stopstart and ms > note.stopstart then
                        stopfreezems = totaldelay + note.stopstart
                        stopms = note.stopms
                        totaldelay = totaldelay - note.stopms
                        stopstart = note.stopstart
                        stopend = note.stopend

                        --to prevent retriggering
                        note.stopstart = nil
                    end
                    --]]



                    --if (note.p < (trackstart - bufferlength)) and (note.endnote == nil) then


                    --[[
                        Check if it is ready to be unloaded
                        If it is, check if endnote is not valid
                        Warning: note.endnote yields false results

                        if note.endnote then
                            if loaded[note.endnote.n] == nil then
                                --delete

                            else

                            end
                        else
                            --delete
                        end
                    --]]
                    --if (note.p < (trackstart - bufferlength)) and (note.endnote and (loaded[note.endnote.n] == nil)) then




                    

                    --unload after track
                    --if (note.p < (trackstart - bufferlength)) then


                    --auto
                    --if (note.p < target) then


                    
                    --do not unload
                    --if false then


                    --distance unload (slow)
                    --formula before delay
                    --if math.abs(note.p - target) > (tracklength + unloadbuffer) then
                    --100 is extra buffer so it doesnt unload asap
                    if (note.hit or math.abs(note.p - target) > ((note.delay * math.abs(note.speed)) + tracklength + unloadbuffer)) --is note ready to be unloaded?
                    and (not (note.endnote and note.endnote.done ~= true and (not note.hit))) --check if endnote unloaded
                    then

                        note.done = true
                        table.remove(loaded, i2)
                        offseti = offseti - 1

                    --just connect with else
                    else
                        --Draw note on canvas



                        if dorender then
                            if note.data == 'event' then
                                if note.event == 'barline' then
                                    RenderBarline(out, note)
                                end
                            elseif note.data == 'note' then
                                RenderNote(out, note)
                            else
                                error('Invalid note.data')
                            end
                        end



                    end
                end
            end

            --[[
            if adddelay then
                for i = loaded.s, loaded.e do
                    local note = loaded[i]
                    if note then
                        note.pdelay = note.pdelay + adddelay
                    end
                end
                adddelay = false
            end
            --]]


            if speedoptout == false then
                speedoptout = out
            end



            --Status
            if laststatus.status then
                --Log('STATUS')
                if ms > laststatus.startms + statuslength then
                    laststatus = {}
                else
                    --[[
                    if ms > laststatus.startms + statusflicker then
                        RenderStatus(out, laststatus, ms)
                    end
                    --]]
                    if speedopt then
                        RenderStatus(speedoptstatus, laststatus, ms, outoffsetx)
                        --
                    else
                        RenderStatus(out, laststatus, ms, outoffsetx)
                    end
                    --print(outoffsetx)io.read()
                end
            end




















            -- [=[

            Ansi.SetCursor(1, 1)
            --[[
            --Set boundaries
            Pixel.SetPixel(out, firstpixel, 0, '1')
            Pixel.SetPixel(out, lastpixel, 0, '1')
            --]]


            -- [[
            --Legacy renderer (Fast)


            if speedopt then
                if speedoptstatus then
                    print(Pixel.ToDotsParallel(out, speedoptstatus, outoffsetx))
                else
                    print(Pixel.Convert.ToDots(out, outoffsetx))
                end
            else
                --Frame Limiting
                if framerate then
                    local dots = Pixel.Convert.ToDots(out, outoffsetx)
                    repeat

                    until os.clock() >= nextframes
                    --nextframes = startt + (framen + 2) * frames
                    nextframes = nextframes + frames
                    print(dots)
                else
                    --Legacy renderer
                    print(Pixel.Convert.ToDots(out, outoffsetx))
                end
            end






            
            framen = framen + 1
            local framerenders = os.clock() - raws
            framerenderstotal = framerenderstotal + framerenders
            --]]









            --Now Input
            local input = curses.getch(window) --Ascii / raw
            local key = curses.getkeyname(input) --Char

            local v = Controls.Hit[key] --Controls are referenced by keys
            --Statistic('v', v)

            --Auto
            if auto then
                local n1 = nearest[1]
                local n2 = nearest[2]
                local testv = (nearest[1] and nearest[2]) and ((nearest[1] < nearest[2]) and 1 or 2) or (nearest[1] and 1 or 2)
                local n = nearest[testv]
                local note = nearestnote[testv]
                --if n and n < (timing.good) then
                --if n and n < 10 then
                --if n and ms > note.ms and (not note.hit) then
                if n and ms >= note.ms and (not note.hit) then
                    --[[
                    if autoemu then
                        v = testv
                    else
                        --good
                        note.hit = true
                        local a = note.type
                        local status = ((a == 3 or a == 4) and 3) or 2 --2 or 3?
                        laststatus = {
                            startms = ms,
                            status = status
                        }
                    end
                    --]]
                    v = testv
                elseif not n or (n and n > (timing.bad * (((note.type == 3 or note.type == 4) and Taiko.Data.BigLeniency) or 1))) then
                    --make sure we can't hit note as bad
                    if balloonstart and (ms > balloonstart and ms < balloonend) then
                        v = 1
                    elseif drumrollstart and (ms > drumrollstart and ms < drumrollend) then
                        v = 1
                    end
                end
            end




            if v then
                if nearest[v] and (not nearestnote[v].hit) then
                    local note = nearestnote[v]
                    local notetype = note.type
                    local notegogo = note.gogo

                    local n = nearest[v]
                    local status
                    --No leniency for good
                    local leniency = ((notetype == 3 or notetype == 4) and Taiko.Data.BigLeniency) or 1
                    if n < (timing.good) then
                        --good
                        --local a = nearestnote[v].type
                        --TODO: Easy big notes config
                        status = ((notetype == 3 or notetype == 4) and 3) or 2 --2 or 3?
                        combo = combo + 1
                    elseif n < (timing.ok * leniency) then
                        --ok
                        status = 1
                        combo = combo + 1
                    elseif n < (timing.bad * leniency) then
                        --bad
                        status = 0
                        combo = 0
                    else
                        --complete miss
                        status = nil
                    end
                    if status then
                        --Calculate Score
                        score = scoref(score, combo, scoreinit, scorediff, status, notegogo)

                        --Effects
                        nearestnote[v].hit = true
                        laststatus = {
                            startms = ms,
                            status = status
                        }
                    end
                end


                --Check again (one at a time)
                if (v == 1) and balloonstart and (ms > balloonstart and ms < balloonend) then
                    --balloon = hit don or ka
                    score = balloonscoref(score, balloon.type, notegogo)
                end
                if (v == 1 or v == 2) and drumrollstart and (ms > drumrollstart and ms < drumrollend) then
                    --drumroll = hit don or ka
                    score = drumrollscoref(score, drumroll.type, notegogo)
                end
            end




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
            
            


        end

        --[[
        profiler.report('profiler.log')
        --]]















































































    else


        error('Prerendering has been removed')

    end








    --curses.nodelay(window, false)
    return true

















































    --[[
    while true do
        local s = os.clock() - startt
        local ms = s * 1000
        if s > nextnotet then
            --Display ASAP
            --io.write(nextnote.type)


            print(nextnotet, s)
            print(nextnote.speed)
            --print(nextnote.type)


            --delay in seconds
            --print(os.clock() - t - startt)

            --Now bit of Downtime
            --ppp(nextnote.nextnote)
            nextnote, nextnotet, nextnoten = GetNextNote(nextnoten + 1)
        end

        --Render

        
        if s > ends then
            break
        end
    end
    --]]
end


















--works best with compact
function Taiko.SongSelect(header, data)
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
                out[#out + 1] = Pad(Display[0][y] or '')
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
                    while true do
                        --No need to endwin since playsong is using window
                        --curses.endwin()
                        local success, out = Taiko.PlaySong(Taiko.GetDifficulty(Parsed, SelectedDifficulty), window, OptionsConfig, Controls.Select.Play)
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
                    if t[i][2] == -math.huge then
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
                    if EndsWith(input, '.tja') then
                        print('Enter a song name')
                        local input2 = StandardInput()
                        header[#header + 1] = input2
                        data[#data + 1] = data2
                        break
                    elseif EndsWith(input, '.tjac') then
                        local t, h = Compact.Decompress(data2)
                        for i = 1, #t do
                            data[#data + 1] = t[i]
                            header[#header + 1] = h[i]
                        end
                        break
                    else
                        print('Invalid file type')
                    end
                    io.close(file)
                else
                    print('Unable to read file')
                end
            end
        elseif Controls.Escape[key] then
            return
        end
        Selected = Wrap(Selected, 1, #header)
    end
end














--full taiko game
function Taiko.Game()
    --TODO
end



























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
    if (not exclude[file]) and EndsWith(file, 'tja') then
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



local t, header = Compact.Decompress(Compact.Read(file))



-- [[
Taiko.SongSelect(header, t)
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



Taiko.PlaySong(Taiko.GetDifficulty(Taiko.ParseTJA(Compact.InputFile(file)), 'Ura'))


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