# Taiko

Popular taiko game simulator.


- [Taiko](#taiko)
  - [Before using (Credit: OpenTaiko)](#before-using-credit-opentaiko)
  - [License](#license)
  - [Posting Vidoes (Credit: OpenTaiko)](#posting-vidoes-credit-opentaiko)
  - [How to start](#how-to-start)
  - [How does this work](#how-does-this-work)
  - [WARNING: Code Quality](#warning-code-quality)
  - [Using this](#using-this)
  - [Efficiency](#efficiency)
  - [Benchmarks (ParseTJA)](#benchmarks-parsetja)
  - [TODO](#todo)
  - [Credits](#credits)

## Before using (Credit: OpenTaiko)

- It is **YOUR RESPONSIBILITY** to use this software. I will not take responsibilities for any problems you got from using this software.
- Currently this software does not have an "Official" skin. if there is any bugs with non-official skin, contact the skin creator first and then contact the author of this software. There will be no support for AC-like skins and forks of this software.
- Please research before asking people.

## License

All parts of this software written by me are licensed under the [MIT license](./LICENSE). The parts not written by me are licensed under their respective authors.

## Posting Vidoes (Credit: OpenTaiko)

- If you are using OpenTaiko on video sharing sites, live streaming services, websites, or blogs, please make sure you explicitly mention it is not Bandai Namco Entertainment official's software, and make sure it is not confused with other Taiko simulators.
- Also, if there is an tag feature on the website you are using, tagging it as "OpenTaiko", "TJAPlayer3-Develop-BSQ", or "TJAP3-BSQ" will avoid confusion with other simulators, and might raise video as similar content, so it is highly recommended.

The author of this software does not support breaking copyright laws, so please follow as per your country's copyright laws.

## How to start

TODO: Make Batch file so easy
Head over to the [latest version](Versions/Taikov31.lua) and set it as current directory (`cd PATH_TO_Versions`). Now, type  
`raylua_s.exe Taikov31.lua`  
and enjoy!

## How does this work

Simply put: This simulator uses raylib to implement the rendering and input. It parses .tja files, which are files that can store various / complicated charts.

## WARNING: Code Quality

The code for `Taiko.ParseTJA` is pretty clean and well documented, and it has descriptions of every tja command from taiko-web tja-format wiki.  
On the other hand, the code for `Taiko.PlaySong` is optimized and not documented at all. It is filled with commented out code and uses some dirty optimizations.

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