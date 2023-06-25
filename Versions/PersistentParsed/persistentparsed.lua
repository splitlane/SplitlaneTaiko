--[[
    persistentparsed.lua

    Be able to store parsed data in VERY efficient formats

    File extention: ppd


    Notes:
    Lazy af, it just uses metalua serialize and compresses using lualzw
]]


PersistentParsed = {}





















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
               table.insert (acc, "[" .. dump_or_ref_val(k) .. "]=" .. dump_or_ref_val(v))
            end
         end
         return "{"..table.concat(acc,",").."}"
      else
         error ("Can't serialize data of type "..t)
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

   if next (localdefs) then
      return "local _={}" ..
         table.concat (localdefs, "") .. 
         "return " .. toplevel
   else
      return "return " .. toplevel
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
































function PersistentParsed.Save(Parsed)
    return compress(serialize(Parsed))
end

function PersistentParsed.Load(str)
    return loadstring(decompress(str))()
end