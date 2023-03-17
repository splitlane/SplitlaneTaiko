# Taiko

- [Taiko](#taiko)
  - [Overview](#overview)
  - [TJA Format](#tja-format)
  - [Taiko.Data](#taikodata)
  - [Taiko.ParseTJA](#taikoparsetja)
  - [Taiko.SerializeTJA](#taikoserializetja)
  - [Taiko.Score](#taikoscore)
  - [Taiko.Analyze](#taikoanalyze)
  - [Taiko.GetDifficulty](#taikogetdifficulty)
  - [Taiko.ForAll](#taikoforall)
  - [Taiko.GetAllNotes](#taikogetallnotes)
  - [Taiko.ConnectNotes](#taikoconnectnotes)
  - [Taiko.ExtractBranch](#taikoextractbranch)
  - [Taiko.ConnectAll](#taikoconnectall)
  - [Taiko.CalculateSpeed](#taikocalculatespeed)
  - [Taiko.CalculateSpeedInterval](#taikocalculatespeedinterval)
  - [Taiko.RenderScale (DEPRACATED)](#taikorenderscale-depracated)
  - [Taiko.PlaySong](#taikoplaysong)
  - [Taiko.SongSelect](#taikosongselect)
  - [Taiko.Game](#taikogame)


## Overview

Play a song -> Read data from file -> Parse into an array of notes (Taiko.ParseTJA) -> Play those notes (Taiko.PlaySong)


## TJA Format

TJA format is a format made for taiko simulators.  
It basically contains: Metadata -> Data (notes) and Notation / Commands  
The amount of notes determine how much the measure is subdivided, and you can insert empty notes to allow for any sequence of notes. Commands allow for scroll speed changes, measure changes, bpm changes, and more.  
Find some examples in tja/.


## Taiko.Data

A place where the data for parsing tja is stored.


## Taiko.ParseTJA

Parses tja format, line by line  
  
How it works:  
1. For all lines:
   1. Remove comments (starting with //)
   2. If note data hasn't started:
      1. If it is a metadata:
         1. Parse metadata (line)
   3. If note data has started:
      1. If it is a command:
         1. Parse command with giant if statement
      2. If it is a note:
         1. Parse note
         2. If line ends with ,:
            1. Push current measure into data and make new measure
  
Returns:  
An array in no particular order, containing all difficulties found within the tja file. Each difficulty contains metadata, notes, lyrics, and flags.
  
```lua
{
    Flag = {
        FLAG = [boolean],
        PARSER_FORCE_OLD_NOTERADIUS = false,
        ...
    },
    Metadata = {
        METADATA = [boolean, number, nil, string],
        TITLE = 'Some Song',
        ...
    },
    Data = {
        {
            notedata = [boolean, number, nil, string],
            ms = 1000,
            ...
        },
        ...
    },
    Lyric = {
        {
            lyricdata = [boolean, number, nil, string],
            ms = 1000,
            ...
        },
        ...
    }
}
```


Errors:  
Be sure to use pcall to catch the errors.


## Taiko.SerializeTJA




## Taiko.Score




## Taiko.Analyze




## Taiko.GetDifficulty




## Taiko.ForAll




## Taiko.GetAllNotes




## Taiko.ConnectNotes




## Taiko.ExtractBranch




## Taiko.ConnectAll




## Taiko.CalculateSpeed

Use Taiko.CalculateSpeedInterval for more accuracy.


## Taiko.CalculateSpeedInterval




## Taiko.RenderScale (DEPRACATED)

For testing purposes only.


## Taiko.PlaySong

Plays a song, just pass in a Parsed Difficulty object (One of the difficulties). It is the main part of the game, and has been highly developed and tested.  
  
How it works:

1. Add extra data to notes / reset notes
2. Apply stopsong, jposscroll, bpmchange
3. Precalculate rotation, TODO
1. Game loop
   2. Calculate note positions and check for closest note
   3. If Auto:
      1. Hit if note is just past after target
   4. Sort notes by ms, and render the biggest ms
   5. Start rendering (biggest ms -> smallest ms)
      1. Draw note texture
      2. Draw senote texture
   6. Draw effects
   7. If Auto:
       1. Hit if drumroll or balloon
   8. Check for input
       1. If Hit:
           1. Calculate status for hit and apply effects
       2. If Pause or Command:
           1. If Command:
              1. Init command overlay
           2. Pause and Loop
              1. Draw still frame
              2. If Command:
                 1. Accept commands
                 2. Draw overlay
              3. If Unpause:
                 1. Break out of loop
              4. If Retry:
                 1. Return false to caller
              5. If Quit:
                  1. Return nil to caller
2. Return true to caller
  
Returns:  
false if retry  
nil if quit  
true, result if ended successfully



## Taiko.SongSelect




## Taiko.Game

This function should only be called once, when the game starts. It loads all of the textures (may take ~5 seconds).






