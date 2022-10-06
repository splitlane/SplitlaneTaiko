--[[
Taikov4.lua


Changes: Taiko.PlaySong improved!
MAJOR BREAKING CHANGES: Pass along a notetable to most functions


Objectives:
O: Parse TJA
NEVER: Play frame
O: Play entire song

Tags: --WIP, --FIX, --TODO, --PERFORMANCE

TODO:
modes



How resizing works:
5 wide
1 speed

X = goal / outline, O = note
X   0
X  0
X 0
X0
0
]]





--[[
How to run on powershell

cd C:\Users\User\OneDrive\code\Taiko\Versions\
lua C:\Users\User\OneDrive\code\Taiko\Versions\Taikov4.lua
]]





























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
end

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
    ScoreMode = {
        --combo: current combo, added note
        --status: 0 = bad, 1 = ok, 2 = good, 3 = biggood
        [0] = function(score, combo, init, diff, status)
            --[[
            local a = nil
            if combo < 200 then
                a = (init or 1000)
            else
                a = (init or 1000) + (diff or 1000)
            end
            score = score + (a * Taiko.Data.RatingMultiplier[status])
            --]]


            return score + (((combo < 200) and (init or 1000) or ((init or 1000) + (diff or 1000))) * Taiko.Data.RatingMultiplier[status])
        end,
        [1] = function(score, combo, init, diff, status)
            --INIT + max(0, DIFF * floor((min(COMBO, 100) - 1) / 10))
            return score + (init + math.max(0, diff * math.floor((math.min(combo, 100) - 1) / 10))) * Taiko.Data.RatingMultiplier[status]
        end,
        [2] = function(score, combo, init, diff, status)
            --INIT + DIFF * {100<=COMBO: 8, 50<=COMBO: 4, 30<=COMBO: 2, 10<=COMBO: 1, 0}
            return score + (init + diff * ((combo >= 100) and 8 or (combo >= 50) and 4 or (combo >= 30) and 2 or (combo >= 10) and 1 or 0)) * Taiko.Data.RatingMultiplier[status]
        end
    },
    Autoscore = {
        [0] = function(Parsed)

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

            end,
            p = function()

            end
        }
    }
}



--Wrap scoring
for k, v in pairs(Taiko.Data.ScoreMode) do
    Taiko.Data.ScoreMode[k] = function(...)
        return math.floor(v(...) / 10) * 10
    end
end






















--TJA Parser

function Taiko.ParseTJA(source)
    local time = os.clock()

    local Out = {}
    local Parsed = {
        Metadata = {
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
            DIVERGENOTES = false
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




                onnotepush = nil
            }
            note.type = n

            --Big note
            if n == 3 or n == 4 or n == 6 then
                note.radius = note.radius * 1.6
            end

            if n == 5 or n == 6 or n == 7 or n == 9 then
                if Parser.lastlong then
                    ParseError('parser.noteparse', 'Last long note has not ended')
                else
                    Parser.lastlong = note
                    if n == 7 or n == 9 then
                        note.requiredhits = Check('parser.noteparse', Parsed.Metadata.BALLOON[Parser.balloonn], 'Invalid number of balloons', Parser.balloonn)
                        Parser.balloonn = Parser.balloonn + 1
                    end
                end
            end

            if n == 8 then
                local lastlong = Parser.lastlong
                note.startnote = lastlong
                if lastlong then
                    note.onnotepush = function()
                        lastlong.length = note.ms - lastlong.ms
                        lastlong.endnote = note
                        Parser.lastlong = nil
                        --note.type = 0 --to delete note
                    end
                else
                    ParseError('parser.noteparse', 'Last long note has ended')
                end
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
                nextnote = nil
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

































    --Start
    local lines = Split(source, '\n')
    for i = 1, #lines do
        LineN = i

        local line = TrimLeft(lines[i])
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
            if (Parser.songstarted or StartsWith(line, '#START')) and done == false then
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
                            Check(match[1], Taiko.Data.ScoreMode[Parsed.Metadata.SCOREMODE], 'Invalid scoremode', Parsed.Metadata.SCOREMODE)
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
                                Check(match[1], Taiko.Data.StyleName[a], 'Invalid course id', Taiko.Data.STYLE)
                                Parsed.Metadata.STYLE = a
                            else
                                Parsed.Metadata.STYLE = Check(match[1], Taiko.Data.CourseId[string.lower(Parsed.Metadata.STYLE)], 'Invalid course name', Parsed.Metadata.STYLE)
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
                        table.insert(Parser.currentmeasure, {
                            match[1],
                            SToMs((CheckN(match[1], match[2], 'Invalid delay') or 0)) --UNSAFE
                        })
                    elseif match[1] == 'SCROLL' then
                        --[[
                            - Multiplies the default scrolling speed by this value
                            - Changes how the notes appear on the screen, values above 1 will make them scroll faster and below 1 scroll slower.
                            - Negative values will scroll notes from the left instead of the right. This behaviour is not supported in taiko-web.
                            - The value cannot be 0.
                            - Can be placed in the middle of a measure.
                        ]]
                        Parser.scroll = CheckN(match[1], match[2], 'Invalid scroll') or Parser.scroll --UNSAFE
                        if Parser.scroll == 0 then
                            ParseError(match[1], 'Scroll cannot be 0')
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
                    elseif match[1] == 'HBSCROLL' then
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

                --Could not recognize command, probably just raw data
                --example: 11,
                --get raw data
                local data = {}

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

                if EndsWith(line, ',') then
                    -- [[
                    --Recalculate --FIX
                    Parser.mpm = Parser.bpm * Parser.sign / 4
                    Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm
                    --]]




                    --BARLINE
                    if Parser.barline then
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
                        table.insert(Parser.measurepushto, 1, note)
                    end



                    --add notes
                    if #Parser.currentmeasure == 0 then
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
                        --loop
                        local increment = firstmspermeasure / notes
                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]
                            if c[1] == 'DELAY' then
                                Parser.ms = Parser.ms + c[2]
                            else
                                --assume it is a note


                                --if it is not air
                                if c.type ~= 0 then
                                    c.ms = Parser.ms
                                    --c.measuredensity = notes
                                    local lastnote = Parsed.Data[#Parsed.Data]
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
                            end
                            Parser.ms = Parser.ms + increment
                        end
                    end
                    Parser.measuredone = true
                    Parser.currentmeasure = {}
                else
                    Parser.measuredone = false
                end
            end


        end
    end



    print('Parsing Took: '.. SToMs(os.clock() - time) .. 'ms')


    return Out
end

--TJA Utils




function Taiko.Analyze(Parsed)
    for i = 1, #Parsed.Data do
        --WIP
    end
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


function Taiko.ForAll(ParsedData, f)
    --[[
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













function Taiko.PlaySong(Parsed, Difficulty)





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
    
    

    local buffer = 100 --Buffer (ms)
    local bufferlength = 10 --Pixels

    --[[ Extracted from metadata
    local startms = 0 --Subtracted from all notes (ms)
    --]]
    local endms = 100 --Added to last note (ms)

    local noteradius = 4 --Default: 2


    local y = 0 --Pixels, y render center
    local tracky = 10 --Pixels, radius of track width
    local trackstart = 0 --Pixels, start of track


    local tracklength = 40  --In noteradius from left (taiko-web)
    local target = 3 --In noteradius from left, representing center (taiko-web)
    local factor = 1 --Zoom factor / Size Multiplier
    local renderconfig = {
        [1] = {color = 'red'},
        [2] = {color = 'blue'},
        [3] = {color = 'red'},
        [4] = {color = 'blue'},
        [5] = {color = 'yellow'},
        [6] = {color = 'yellow'},
    }






    --Multiply noteradius
    tracklength = math.floor(tracklength * noteradius)
    local trackend = trackstart + tracklength
    target = math.floor(target * noteradius)




    local Pixel = require('Pixels')

    --min, max, to prevent screen bobbing
    local minx, maxx = trackstart, tracklength
    local miny, maxy = -tracky, tracky

    --minx and maxx not needed, modified
    Pixel.Convert.ToDots = function(str) --converts a given data table
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

    local function RenderBarline(out, note)
        local x = math.floor(note.p)
        local y1, y2 = y - tracky, y + tracky
        for y = y1, y2 do
            local a = Pixel.GetPixel(out, x, y)
            if a == '0' or a == nil then
                Pixel.SetPixel(out, x, y, '1')
            end
        end
    end

    local function RenderCircle(out, note)
        Pixel.Circle(out, math.floor(note.p), y, noteradius * note.radius, renderconfig[note.type])
    end

    local function RenderRect(out, x1, x2, y1, y2, options)
        local options = options or {}
        color = options.color
        --Clip
        local a1 = (trackstart - bufferlength)
        if x1 < a1 then
            x1 = a1
        end
        local a2 = (tracklength + bufferlength)
        if x2 > a2 then
            x2 = a2
        end
        --Actual rendering
        for y = y1, y2 do
            for x = x1, x2 do
                Pixel.SetPixel(out, x, y, '1')
                if color then
                    Pixel.SetColor(out, x, y, color)
                end
            end
        end
    end

    local function RenderNote(out, note)
        local n = note.type
        if n == 1 or n == 2 or n == 3 or n == 4 then
            RenderCircle(out, note)
        elseif n == 5 or n == 6 then
            RenderCircle(out, note)
            local endnote = note.endnote
            --Distance = speed * time
            local length = (endnote.ms - note.ms) * note.speed
            --Render start and end, and rect
            RenderCircle(out, note)
            --RenderCircle(out, endnote)
            local r = noteradius * note.radius
            local x1, x2 = math.floor(note.p), math.floor(note.p + length)
            local y1 = y - r
            local y2 = y + r
            RenderRect(out, x1, x2, y1, y2, renderconfig[note.type])
        elseif n == 8 then
            if note.renderproxy then
                note.renderproxy.p = note.p
            else
                local startnote = note.startnote
                note.renderproxy = {}
                for k, v in pairs(startnote) do
                    if k ~= 'type' then
                        note.renderproxy[k] = v
                    end
                end
            end
            note.renderproxy.p = note.p
            RenderCircle(out, note.renderproxy)
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








    Parsed = Taiko.GetDifficulty(Parsed, Difficulty)


    local notetable = Taiko.GetAllNotes(Parsed.Data)



    --Parsed = Taiko.CalculateSpeedAll(Parsed, noteradius)











    --METADATA
    local startms = Parsed.Metadata.OFFSET











    --require'ppp'(Taiko.CalculateSpeedAll(Parsed, 1).Data[1])



    --Precalculate

    local function IsNote(note)
        return (note.data == 'note') or (note.data == 'event' and note.event == 'barline')
    end

    local function CalculateLoadMs(note, ms)
        return ms - ((tracklength / note.speed) + buffer)
    end
    local function CalculateLoadPosition(note, lms)
        return (note.ms - lms) * note.speed + target
    end
    local function CalculatePosition(note, ms)
        return note.loadp - (note.speed * (ms - note.loadms))
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
        v.ms = v.ms - startms
        v.s = MsToS(v.ms)
        v.speed = Taiko.CalculateSpeed(v, noteradius)
        v.loadms = CalculateLoadMs(v, v.ms)
        v.loads = MsToS(v.loadms)
        v.loadp = CalculateLoadPosition(v, v.loadms)
        --v.n = k --MISTAKE: after sorted
        table.insert(timet, v.ms)
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
    local endms = math.max(unpack(timet)) + endms



    --Check for spawns before game starts

    local loaded = {
        s = 1, --Start
        e = 0, --End
        n = 0 --Number of loaded notes
    }
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

    loaded.e = loaded.n






    --Statistics
    local padding = 10
    local function Statistic(k, v)
        print(k .. ': ' .. tostring(v) .. string.rep(' ', padding))
    end
    --Log (Debug system)
    local logs = ''
    local function Log(s)
        logs = logs .. '\n' .. s
    end
    local function RenderLog()
        print(logs)
    end






    
    Ansi.ClearScreen()

    --[[
    local firstpixel = math.floor(0 - noteradius - 1)
    local lastpixel = math.floor(tracklength * noteradius + noteradius + 1)
    --]]

    local branch = 'M'



    --Statistics
    local framen = 0
    local framerenderstotal = 0



    --Main loop
    local startt = os.clock()




    while true do
        --Make canvas
        local out = Pixel.New()

        local raws = os.clock()

        local s = raws - startt
        local ms = s * 1000

        --See if next note is ready to be loaded
        if nextnote then
            if nextnote and nextnote.loadms < ms then
                --load
                --print('load i'..nextnote.n ..' s'.. loaded.s .. ' e' .. loaded.e .. ' n' .. loaded.n)


                loaded.n = loaded.n + 1
                --loaded.e = loaded.n
                loaded.e = nextnote.n

                loaded[nextnote.n] = nextnote

                

                nextnote = nextnote.nextnote
                
                if nextnote.branch then
                    Log('branch')
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


        for i = loaded.s, loaded.e do
            local note = loaded[i]
            if note then
                --print(ms, loaded.s, loaded.e, loaded.n)
                note.p = CalculatePosition(note, ms)
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
                if (note.p < (trackstart - bufferlength)) then
                    --print(note.endnote and (loaded[note.endnote.n] ~= nil))
                    --if note.endnote and (loaded[note.endnote.n] ~= nil) then
                    if note.endnote and note.endnote.done ~= true then
                        --Still has endnote loaded
                        --Don't unload
                    else
                        --unload
                        --for k,v in pairs(loaded) do print(k, type(v) == 'table' and v.n)end
                        --loaded[note.n] = nil
                        --print('unload i'..i ..' s'.. loaded.s .. ' e' .. loaded.e .. ' n' .. loaded.n)
                        note.done = true
                        loaded[i] = nil
                        --loaded.n = loaded.n - 1
                        if loaded.n == 0 then
                            loaded.s = nextnote.n
                        elseif note.n == loaded.s then
                            if note.n == loaded.e then
                                loaded.n = 0
                            else
                                local i2 = loaded.s
                                repeat
                                    i2 = i2 + 1
                                    loaded.n = loaded.n - 1
                                until loaded[i2]
                                loaded.s = i2
                            end
                        end

                        --[[
                        loaded[note.n] = nil
                        loaded.s = note.n + 1
                        loaded.n = loaded.n - 1
                        --]]
                    end
                end

                if note.p < (tracklength + buffer) then
                    --Draw note on canvas

                    --Only for noteradius = 0.5
                    --Pixel.SetPixel(out, math.floor(note.p * noteradius * factor), 0, '1')

                    --Pixel.Circle(out, math.floor(note.p * noteradius), 0, noteradius, renderconfig[note.type])


                    --debug

                    --BEST DEBUG
                    --[[
                    local a = loaded[note.n - 1]
                    if a then
                        print(note.p - a.p, (note.p - a.p) / noteradius)
                    end
                    --]]


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

        -- [=[

        Ansi.SetCursor(1, 1)
        --[[
        --Set boundaries
        Pixel.SetPixel(out, firstpixel, 0, '1')
        Pixel.SetPixel(out, lastpixel, 0, '1')
        --]]
        print(out)
        framen = framen + 1
        local framerenders = os.clock() - raws
        framerenderstotal = framerenderstotal + framerenders
        --]=]



        --statistics
        --[[
        Statistic('S', s)
        Statistic('Ms', ms)
        Statistic('Loaded', loaded.n)
        --Statistic('FPS (MsDif)', 1000 / (ms - lastms))
        Statistic('Frames Rendered', framen)
        Statistic('Last Frame Render (s)', framerenders)
        Statistic('Last Frame Render (ms)', framerenders * 1000)
        Statistic('Frame Render Total (s)', framerenderstotal)
        Statistic('Frame Render Total (ms)', framerenderstotal * 1000)
        Statistic('Frame Render Total (%)', framerenderstotal / s * 100)
        Statistic('FPS (Frame)', framen / s)
        Statistic('nextloadms', nextnote.loadms)
        Statistic('nextms', nextnote.ms)
        Statistic('nextn', nextnote.n)
        RenderLog()
        --]]












    end









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



-- [[
file = './tja/donkama.tja'
--file = './tja/test.tja'
file = './tja/ekiben.tja'
--file = './tja/lag.tja'
--file = './tja/drumroll2.tja'
--file = './tja/branchtest.tja'
file = './tja/saitama.tja'
file = './tja/donkama.tja'
Taiko.PlaySong(Taiko.ParseTJA(io.open(file,'r'):read('*all')), 'Oni')


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