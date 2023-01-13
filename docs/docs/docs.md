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
  - [Taiko.RenderScale](#taikorenderscale)
  - [Taiko.PlaySong](#taikoplaysong)
  - [Taiko.SongSelect](#taikosongselect)
  - [Taiko.Game](#taikogame)


## Overview

Play a song -> Read data from file -> Parse into an array of notes (Taiko.ParseTJA) -> Play those notes (Taiko.PlaySong)


## TJA Format

TJA format is a format made for taiko simulators.  
It basically contains: Metadata -> Data (notes) and Notation / Commands  
The amount of notes determine how much the measure is subdivided, and you can insert empty notes to allow for any sequence of notes. Commands allow for scroll speed changes, measure changes, bpm changes, and more.  
Find some examples in tja/


## Taiko.Data

A place where the data for parsing tja is.


## Taiko.ParseTJA

Parses tja format, line by line  
  
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




## Taiko.RenderScale

For testing purposes only.


## Taiko.PlaySong




## Taiko.SongSelect




## Taiko.Game