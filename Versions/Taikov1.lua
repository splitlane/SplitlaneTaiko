--[[
Taikov1.lua

Objectives:
O: Parse TJA
NEVER: Play frame
O: Play entire song







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

function ParseError(cmd, msg, data)
    Error(cmd .. ': ' .. msg .. (data and (', ' .. data) or ''))
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
            LIFE = 0, --taiko-web ignored
            GAME = 'Taiko', --taiko-web ignored
            HEADSCROLL = 1, --taiko-web ignored
            MOVIEOFFSET = 0, --taiko-web ignored
            COURSE = 'ONI',
            LEVEL = 0,
            SCOREINIT,
            SCOREDIFF
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
        barline = true,
        gogo = false
    }




    --Parser functions
    function Parser.createnote()
        return {
            ms = nil,
            data = nil, --'note'
            type = nil,
            txt = nil,
            gogo = Parser.gogo,
            --speed = (Parser.bpm) / 60 * (Parser.scroll * Parsed.Metadata.HEADSCROLL),
            scroll = (Parser.scroll * Parsed.Metadata.HEADSCROLL),
            mspermeasure = Parser.mspermeasure,
            bpm = Parser.bpm
            --measuredensity = nil
        }
    end



    --Start
    local lines = Split(source, '\n')
    for i = 1, #lines do
        local line = TrimLeft(lines[i])
        if StartsWith(line, '//') or line == '' then
            --Do nothing
        else
            local done = false

            
            --Metadata
            if Parser.songstarted == false and done == false then
                local match = {string.match(line, '(%u+):(.*)')}
                if match[1] then
                    Parsed.Metadata[Trim(match[1])] = Trim(match[2])
                    done = true
                end
            end

            --Command
            if (Parser.songstarted or StartsWith(line, '#START')) and done == false then
                local match = {string.match(line, '#(%u-)%s(.*)')}
                if not match[1] then
                    match = {string.match(line, '#(%u+)')}
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
                            local function CheckN(n, e)
                                local a = tonumber(n)
                                if a then
                                    return a
                                else
                                    ParseError(match[1], e, n)
                                end
                            end
                            local function Check(a, e, data)
                                if a then
                                    return a
                                else
                                    ParseError(match[1], e, data)
                                end
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
                            Parsed.Metadata.TITLE = Check(GetTranslated('TITLE'), 'Title is missing')
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
                            Parsed.Metadata.SUBTITLE = Check(GetTranslated('SUBTITLE'), 'Subtitle is missing')
                            --[[
                            BPM:
                                - Song's beats per minute.
                                - The following formula is used: BPM = MEASURE / SIGN * 4, where MEASURE is amount of measures per minute and SIGN is the time signature, eg. 4 / 4 if the current time signature is common.
                                - If omitted, BPM defaults to 120.
                            ]]

                            --[[
                            OFFSET:
                                - Floating point value for chart offset in seconds.
                                - Negative values will delay notes, positive will cause them to appear sooner.
                                - If the "offset" field is set in a taiko-web database, both values will be summed together.
                            ]]
                            Parsed.Metadata.OFFSET = CheckN(tonumber(Parsed.Metadata.OFFSET), 'Invalid offset') * 1000
                            --[[
                            DEMOSTART: (i)
                                - Offset of song preview during song selection in seconds.
                                - Default is 0, which also disables the generation of a "preview.mp3" file when hosted on taiko-web.
                                - When hosted on taiko-web, "preview" field in the database is used.
                            ]]
                            Parsed.Metadata.DEMOSTART = CheckN(tonumber(Parsed.Metadata.DEMOSTART), 'Invalid demostart') * 1000
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
                            Parsed.Metadata.SCOREMODE = CheckN(Parsed.Metadata.SCOREMODE, 'Invalid scoremode')
                            local a = Parsed.Metadata.SCOREMODE
                            Check(a == 0 or a == 1 or a == 2, 'Invalid scoremode', a)
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
                                Parsed.Metadata.COURSE = Check(Taiko.Data.CourseName[a], 'Invalid course id', a)
                            else
                                Parsed.Metadata.COURSE = Taiko.Data.CourseName[Check(Taiko.Data.CourseId[string.lower(Parsed.Metadata.COURSE)], 'Invalid course name', Parsed.Metadata.COURSE)]
                            end
                            --[[
                            LEVEL: (i)
                                - The difficulty integer between 1 and 10.
                                - Represents the amount of stars that appear on the song select next to the difficulty.
                                - Floating point numbers will be rounded down and numbers outside of the range will be clipped.
                                - When hosted on taiko-web, the value is taken from "easy", "normal", "hard", "oni", or "ura" subfield from the "courses" field.
                            ]]
                            Parsed.Metadata.LEVEL = ClipN(math.floor(Parsed.Metadata.LEVEL), 0, 10)


                            Parser.bpm = Parsed.Metadata.BPM
                            Parser.songstarted = true
                        end
                    elseif match[1] == 'END' then
                        if Parser.songstarted then
                            table.insert(Out, Parsed)
                            Parsed = {
                                Metadata = Table.Clone(Parsed.OriginalMetadata),
                                Data = {}
                            }
                            --reset parser?
                            Parser.songstarted = false
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
                        Parser.sign = tonumber(match[2]) or Parser.sign --UNSAFE
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
                        Parser.bpm = tonumber(match[2]) or Parser.bpm --UNSAFE
                    elseif match[1] == 'DELAY' then
                        --[[
                            - Floating point value in seconds that offsets the position of the following song notation.
                            - If value is negative, following song notation will overlap with the previous. - All notes should be placed in such way that notes after #DELAY do not appear earlier or at the same time as the notes before.
                            Can be placed in the middle of a measure.
                        ]]
                        --Parser.ms = Parser.ms + (1000 * (tonumber(match[2]) or 0)) --UNSAFE --QUESTIONABLE
                        table.insert(Parser.currentmeasure, {
                            match[1],
                            tostring(1000 * (tonumber(match[2]) or 0)) --UNSAFE
                        })
                    elseif match[1] == 'SCROLL' then
                        --[[
                            - Multiplies the default scrolling speed by this value
                            - Changes how the notes appear on the screen, values above 1 will make them scroll faster and below 1 scroll slower.
                            - Negative values will scroll notes from the left instead of the right. This behaviour is not supported in taiko-web.
                            - The value cannot be 0.
                            - Can be placed in the middle of a measure.
                        ]]
                        Parser.scroll = tonumber(match[2]) or Parser.scroll --UNSAFE
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
                    elseif match[1] == 'N' then
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
                    elseif match[1] == 'E' then
                    elseif match[1] == 'M' then
                    elseif match[1] == 'BRANCHEND' then
                        --[[
                            - Begins a normal song notation without branching.
                            - Retains the visual branch from previous #BRANCHSTART.
                        ]]
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
                end

                --Could not recognize command, probably just raw data
                --example: 11,
                --get raw data
                local data = {}

                for i = 1, #line do
                    local s = string.sub(line, i, i)
                    local n = tonumber(s) --UNSAFE
                    if n then
                        local note = Parser.createnote()
                        note.data = 'note'
                        note.type = n
                        table.insert(Parser.currentmeasure, note)
                    end
                end

                if EndsWith(line, ',') then
                    --[[
                    --Recalculate
                    Parser.mpm = Parser.bpm * Parser.sign / 4
                    Parser.mspermeasure = 60000 * Parser.sign * 4 / Parser.bpm
                    --]]


                    --add notes
                    if #Parser.currentmeasure == 0 then
                        Parser.ms = Parser.ms + Parser.mspermeasure
                        print('a')
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
                                if c.type ~= 0 then
                                    c.ms = Parser.ms
                                    --c.measuredensity = notes
                                    table.insert(Parsed.Data, c)
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



    print('Parsing Took: '.. (os.clock() - time) * 1000 .. 'ms')


    return Out
end

--TJA Utils

function Taiko.GetDifficulty(Parsed, Difficulty)
    for k, v in pairs(Parsed) do
        if v.Metadata.COURSE == Difficulty then
            return v
        end
    end
    Error('No difficulty found, ' .. Difficulty)
    return nil
end

function Taiko.FindMaxCombo()

end

function Taiko.FindMaxScore()

end

function Taiko.GetNextNote(Parsed, n)
    while true do
        if n == #Parsed.Data then
            return n
        end
        local a = Parsed.Data[n]
        if a.data == 'note' then
            return n
        end
        n = n + 1
    end
end

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

    --[[
    local noten = Taiko.GetNextNote(Parsed, noten)
    local noten2 = Taiko.GetNextNote(Parsed, noten + 1)
    local note, note2 = Parsed.Data[noten], Parsed.Data[noten2]
    local ms = math.abs(note2.ms - note.ms) --FIX
    local sign = note.bpm*note.mspermeasure/240000
    local speed = 240*noteradius*sign*note.scroll/(note.bpm*ms)
    --]]
    if note.data == 'note' then
        local speed = 9600*noteradius*note.scroll/(note.bpm*note.mspermeasure)
        return speed
    else
        return false
    end
end

function Taiko.CalculateSpeedAll(Parsed, noteradius)
    local t = {}
    for i = 1, #Parsed.Data do
        Parsed.Data[i].speed = Taiko.CalculateSpeed(Parsed.Data[i], noteradius)
        table.insert(t, Parsed.Data[i].speed)
    end
    require'ppp'(t)
    return Parsed
end










--TJA Simulators

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
    

    Parsed = Taiko.GetDifficulty(Parsed, Difficulty)
    require'ppp'(Parsed)


    require'ppp'(Taiko.CalculateSpeedAll(Parsed, 1))
    --print(Taiko.CalculateSpeed(Parsed, 1, 1))
    
    
    error()

    local buffer = 100 --Buffer in ms
    local endtime = 100 --Added to last note (ms)

    --Precalculate


    --Convert everything to seconds + fill up timet
    local timet = {}
    for k, v in pairs(Parsed.Data) do
        table.insert(timet, v.ms)
        v.ms = v.ms / 1000
    end

    --Calculate end time
    endtime = (math.max(unpack(timet)) + endtime) / 1000


    local function GetNextNote(n)
        while true do
            if n == #Parsed.Data then
                return Parsed.Data[n], -1, 0
            end
            local a = Parsed.Data[n]
            if a.data == 'note' then
                return a, a.ms, n
            end
            n = n + 1
        end
    end
    local nextnote, nextnotet, nextnoten = GetNextNote(1)

    --Main loop
    local startt = os.clock()
    while true do
        local t = os.clock() - startt
        if t > nextnotet then
            --Display ASAP
            --io.write(nextnote.type)
            print(nextnotet, t)

            --delay in seconds
            --print(os.clock() - t - startt)

            --Now bit of Downtime
            nextnote, nextnotet, nextnoten = GetNextNote(nextnoten + 1)
        end
        
        if t > endtime then
            break
        end
    end
end



-- [[
--Taiko.PlaySong(Taiko.ParseTJA(io.open('./tja/donkama.tja','r'):read('*all')), 'Oni')
Taiko.PlaySong(Taiko.ParseTJA(io.open('test.tja','r'):read('*all')), 'Oni')
--Taiko.PlaySong(Taiko.ParseTJA(io.open('./tja/ekiben.tja','r'):read('*all')), 'Oni')


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