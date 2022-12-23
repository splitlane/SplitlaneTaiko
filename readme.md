# Taiko

Popular taiko game simulator.


- [Taiko](#taiko)
  - [How to start](#how-to-start)
  - [How does this work](#how-does-this-work)
  - [Using this](#using-this)
  - [Efficiency](#efficiency)
  - [Benchmarks (ParseTJA)](#benchmarks-parsetja)
  - [TODO](#todo)
  - [Credits](#credits)

## How to start

Head over to the [latest version](Versions/Taikov31.lua) and set it as current directory (`cd PATH_TO_Versions`). Now, type  
`raylua_s.exe Taikov31.lua`  
and enjoy!

## How does this work

This simulator uses raylib to implement the rendering and input. It parses .tja files, which are files that can store various / complicated charts.

## Using this

If you want to parse tja files efficiently and get a table of metadata and notes, use `Taiko.ParseTJA`.  
If you want to play the parsed tja data, use `Taiko.PlaySong`.

## Efficiency

## Benchmarks (ParseTJA)

Using:  
```
Default raylib-luajit binding
CompactTJA to decompress files before the test
The ENTIRE ESE Project (Might be outdated)
```
Specs:
```
Processor	Intel(R) Core(TM) i7-6600U CPU @ 2.60GHz   2.81 GHz
Installed RAM	20.0 GB (19.9 GB usable)
System type	64-bit operating system, x64-based processor
```
Output:
```
1
Total Time (s):         21.893
Shortest Time (ms):     0    
Longest Time (ms):      72   
Total Time Parsing (ms):   18417
Average Time (ms):      8.3071718538566
Total Successes (n):    2217  
Total Errors (n):       238

2
Total Time (s):         21.976
Shortest Time (ms):     0    
Longest Time (ms):      75   
Total Time Parsing (ms):   18529
Average Time (ms):      8.3576905728462
Total Successes (n):    2217 
Total Errors (n):       238

3
Total Time (s):         20.253
Shortest Time (ms):     0
Longest Time (ms):      59   
Total Time Parsing (ms):   16816
Average Time (ms):      7.5850248082995
Total Successes (n):    2217 
Total Errors (n):       238
```

Code:
```lua
--[[
    ParseTJA Testing
    Make sure to change ParseTJA to return ms time
]]
local file = './CompactTJA/ESE/ESE.tjac' --ALL ESE

local t, header = Compact.Decompress(Compact.Read(file))

local errorn = 0
local successn = 0
local times = {}
local t1 = os.clock()
for i = 1, #t do
    print(i)
    local status, out = pcall(Taiko.ParseTJA, t[i]) --out will be ms for our test
    if status then
        times[#times + 1] = out
        successn = successn + 1
    else
        errorn = errorn + 1
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
```

## TODO


## Credits

[raylib-lua](https://github.com/TSnake41/raylib-lua)
    For their raylib binding
[OpenTaiko](https://github.com/0auBSQ/OpenTaiko)
    For their skin and code
[Taiko-Web](https://github.com/bui/taiko-web)
    For documentation and code, and getting me started