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

Split=function(a,b)local c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end
Trim=function(s)local a=s:gsub("^%s*(.-)%s*$", "%1")return a end
TrimLeft=function(s)local a=s:gsub("^%s*(.-)$", "%1")return a end
TrimRight=function(s)local a=s:gsub("^(.-)%s*$", "%1")return a end
StartsWith=function(a,b)return a:sub(1,#b)==b end
EndsWith=function(a,b)return a:sub(-#b,-1)==b end


function Error(msg)
    error(msg)
end

function ParseError(cmd, msg)
    Error(cmd .. ': ' .. msg)
end



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
]]
function ParseTJA(source)
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
        ms = 0,
        songstarted = false,
        timingpoint = nil,
        sign = 4/4,
        mpm = 0
        mspermeasure = 0,
        scroll = 1,
        measuredone = true
        currentmeasure = {}
        barline = true,
        gogo = false
    }

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
            if done == false then
                local match = {string.match(line, '#(%u-)%s(.*)')}
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
                            Parser.songstarted = true
                        end
                    elseif match[1] == 'END' then
                        if Parser.songstarted then
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
                        Parser.mpm = Parsed.Metadata.BPM * Parser.sign / 4
                        Parser.mspermeasure = 60000 * Parser.measure * 4 / Parsed.Metadata.BPM
                    elseif match[1] == 'BPMCHANGE' then
                        --[[
                            - Changes song's BPM, similar to BPM: command in metadata.
                            - Can be placed in the middle of a measure, therefore it is necessary to calculate milliseconds per measure value for each note.
                        ]]
                        Parsed.Metadata.BPM = tonumber(match[2]) or Parsed.Metadata.BPM --UNSAFE
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
                    elseif match[1] == 'BARLINEOFF' 
                        Parser.barline = false
                    elseif match[1] == 'BARLINEON' then
                        Parser.barline = true
                    elseif match[1] == 'BRANCHSTART' then
                    elseif match[1] == 'N' then
                    elseif match[1] == 'E' then
                    elseif match[1] == 'M' then
                    elseif match[1] == 'BRANCHEND' then
                    elseif match[1] == 'SECTION' then
                    elseif match[1] == 'LYRIC' then
                    elseif match[1] == 'LEVELHOLD' then
                    elseif match[1] == 'BMSCROLL' then
                    elseif match[1] == 'HBSCROLL' then
                    elseif match[1] == 'SENOTECHANGE' then
                    elseif match[1] == 'NEXTSONG' then
                    elseif match[1] == 'DIRECTION' then
                    elseif match[1] == 'SUDDEN' then
                    elseif match[1] == 'JPOSSCROLL' then
                    else

                    end



                    done = true
                end
            end


            
            if done == false then
                --Could not recognize command, probably just raw data
                --example: 11,
                --get raw data
                local data = {}
                for i = 1, #line do
                    local s = string.sub(line, i, i)
                    local n = tonumber(s) --UNSAFE
                    if n then
                        table.insert(Parser.currentmeasure,                 {
                            ms = 1000,
                            data = 'note',
                            type = n,
                            txt = nil,
                            gogo = Parser.gogo,
                            scroll = Parser.scroll * Parser.HEADSCROLL
                        })
                    end
                end

                if EndsWith(line, ',') then
                    --get first note and  make barline
                    if Parser.barline then
                        
                    end
                    --add notes
                    if #Parser.currentmeasure == 0 then
                        Parser.ms = Parser.ms + Parser.mspermeasure
                    else
                        --count notes
                        local notes = 0
                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]
                            if c.data == 'note' then
                                notes = notes + 1
                            end
                        end
                        --loop
                        local increment = Parser.mspermeasure / notes
                        for i = 1, #Parser.currentmeasure do
                            local c = Parser.currentmeasure[i]
                            if c[1] == 'DELAY' then
                                Parser.ms = Parser.ms + c[2]
                            else
                                --assume it is a note
                                table.insert(Parsed.Data, c)
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
end


require'ppp'(ParseTJA(io.open('test.tja','r'):read()))