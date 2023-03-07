--Tested with lua 5.1.5
--Options
LuaMode = true --If this is true, it will generate valid lua code.
SerialSeperator = '~' --Seperator for serialization.
EndSeperator = '/' --Seperator for end.
Minify = true --Minify
PrintOutput = true --Prints the output, and returns it
MaxDepth = 10 --Max depth

printplusplus = function(input)
    local LuaFunction = {assert, collectgarbage, coroutine, coroutine.create, coroutine.resume, coroutine.running, coroutine.status, coroutine.wrap, coroutine.yield, debug, debug.debug, debug.getfenv, debug.gethook, debug.getinfo, debug.getlocal, debug.getmetatable, debug.getregistry, debug.getupvalue, debug.setfenv, debug.sethook, debug.setlocal, debug.setmetatable, debug.setupvalue, debug.traceback, dofile, error, gcinfo, getfenv, getmetatable, io, io.close, io.flush, io.input, io.lines, io.open, io.output, io.popen, io.read, io.stderr, io.stdin, io.stdout, io.tmpfile, io.type, io.write, ipairs, load, loadfile, loadstring, math, math.abs, math.acos, math.asin, math.atan, math.atan2, math.ceil, math.cos, math.cosh, math.deg, math.exp, math.floor, math.fmod, math.frexp, math.huge, math.ldexp, math.log, math.log10, math.max, math.min, math.mod, math.modf, math.pi, math.pow, math.rad, math.random, math.randomseed, math.sin, math.sinh, math.sqrt, math.tan, math.tanh, module, newproxy, next, os, os.clock, os.date, os.difftime, os.execute, os.exit, os.getenv, os.remove, os.rename, os.setlocale, os.time, os.tmpname, package, package.config, package.cpath, package.loaded, --[[loaded._G, loaded.coroutine, loaded.debug, loaded.io, loaded.math, loaded.os, loaded.package, loaded.string, loaded.table,]]string.byte, string.char, string.dump, string.find, string.format, string.gfind, string.gmatch, string.gsub, string.len, string.lower, string.match, string.rep, string.reverse, string.sub, string.upper, table.concat, table.foreach, table.foreachi, table.getn, table.insert, table.maxn, table.remove, table.setn, table.sort, package.loaders, --[[loaders.1, loaders.2, loaders.3, loaders.4,]] package.loadlib, package.path, package.preload, package.seeall, pairs, pcall, print, rawequal, rawget, rawset, require, select, setfenv, setmetatable, string, table, tonumber, tostring, type, unpack, xpcall}
    local LuaFunctionName = {'assert', 'collectgarbage', 'coroutine', 'coroutine.create', 'coroutine.resume', 'coroutine.running', 'coroutine.status', 'coroutine.wrap', 'coroutine.yield', 'debug', 'debug.debug', 'debug.getfenv', 'debug.gethook', 'debug.getinfo', 'debug.getlocal', 'debug.getmetatable', 'debug.getregistry', 'debug.getupvalue', 'debug.setfenv', 'debug.sethook', 'debug.setlocal', 'debug.setmetatable', 'debug.setupvalue', 'debug.traceback', 'dofile', 'error', 'gcinfo', 'getfenv', 'getmetatable', 'io', 'io.close', 'io.flush', 'io.input', 'io.lines', 'io.open', 'io.output', 'io.popen', 'io.read', 'io.stderr', 'io.stdin', 'io.stdout', 'io.tmpfile', 'io.type', 'io.write', 'ipairs', 'load', 'loadfile', 'loadstring', 'math', 'math.abs', 'math.acos', 'math.asin', 'math.atan', 'math.atan2', 'math.ceil', 'math.cos', 'math.cosh', 'math.deg', 'math.exp', 'math.floor', 'math.fmod', 'math.frexp', 'math.huge', 'math.ldexp', 'math.log', 'math.log10', 'math.max', 'math.min', 'math.mod', 'math.modf', 'math.pi', 'math.pow', 'math.rad', 'math.random', 'math.randomseed', 'math.sin', 'math.sinh', 'math.sqrt', 'math.tan', 'math.tanh', 'module', 'newproxy', 'next', 'os', 'os.clock', 'os.date', 'os.difftime', 'os.execute', 'os.exit', 'os.getenv', 'os.remove', 'os.rename', 'os.setlocale', 'os.time', 'os.tmpname', 'package', 'package.config', 'package.cpath', 'package.loaded', --[['loaded._G', 'loaded.coroutine', 'loaded.debug', 'loaded.io', 'loaded.math', 'loaded.os', 'loaded.package', 'loaded.string', 'loaded.table',]]'string.byte', 'string.char', 'string.dump', 'string.find', 'string.format', 'string.gfind', 'string.gmatch', 'string.gsub', 'string.len', 'string.lower', 'string.match', 'string.rep', 'string.reverse', 'string.sub', 'string.upper', 'table.concat', 'table.foreach', 'table.foreachi', 'table.getn', 'table.insert', 'table.maxn', 'table.remove', 'table.setn', 'table.sort', 'package.loaders', --[['loaders.1', 'loaders.2', 'loaders.3', 'loaders.4',]] 'package.loadlib', 'package.path', 'package.preload', 'package.seeall', 'pairs', 'pcall', 'print', 'rawequal', 'rawget', 'rawset', 'require', 'select', 'setfenv', 'setmetatable', 'string', 'table', 'tonumber', 'tostring', 'type', 'unpack', 'xpcall'}
	local function StringifyFunction(func)
		local oldfunc = func
		if type(func) == 'string' then
			local func,errormsg = loadstring(func)
			if func == nil then
				return oldfunc
			end
		end
        if pcall(function()string.dump(func)end) then
            if Minify then
                return'loadstring\''..(string.gsub(string.dump(func),'.',function(a)return'\\'..a:byte()end)or string.dump(func)..'\'')..'\''
            else
                return'loadstring(\''..(string.gsub(string.dump(func),'.',function(a)return'\\'..a:byte()end)or string.dump(func)..'\'')..'\')'
            end
        else
            for i = 1, #LuaFunction do
                if LuaFunction[i] == func then
                    return LuaFunctionName[i]
                end
            end
        end
	end
	local function StringifyMetatable(normaltable)
		local metatablecheck = getmetatable(normaltable)
		local metatableout = nil
		if metatablecheck ~= nil then
			local cutofftrue = nil
			metatableout = ''
			for k, v in pairs(metatablecheck) do
				cutofftrue = true
				if Minify then
					metatableout = metatableout .. k .. '=' .. StringifyFunction(v) .. ','
				else
					metatableout = metatableout .. k .. ' = ' .. StringifyFunction(v) .. ',\n'
				end
			end
			if cutofftrue == true then --check for edge cases
				local cutoff
				if Minify then
					cutoff = 1
				else
					cutoff = 2
				end
				metatableout = string.sub(metatableout, 1, #metatableout - cutoff)
				return metatableout --returning just the metatable
			else
				return nil
			end
		end
	end
	local function CountTable(tb)
		local c = 0
		for _ in pairs(tb) do c = c + 1 end
		return c
	end
	local function StringifyTable(tb, recurse, atIndent)
        recurse = recurse or 0
        --print(recurse)
        if recurse > MaxDepth then
            return 'RECURSIVE_TABLE'
        else
            recurse = recurse + 1
        end
		local mttemp = StringifyMetatable(tb)
		atIndent = atIndent or 0
        atIndent = recurse - 1
		local useNewlines = (CountTable(tb) > 1)
        if Minify then
            useNewlines = false
        end
		local baseIndent = string.rep('    ', atIndent+1)
		local out = "{"..(useNewlines and '\n' or '')
		if Minify then
			baseIndent = ''
			out = '{'
		end
		for k, v in pairs(tb) do
			--if type(v) ~= 'function' then
			out = out..(useNewlines and baseIndent or '')
			if type(k) == 'number' then
				--nothing to do??
			elseif type(k) == 'string' and k:match("^[A-Za-z_][A-Za-z0-9_]*$") then 
				out = out..k..(Minify and"="or" = ")
			elseif type(k) == 'string' then
				out = out..(Minify and"[\'"..k.."\']="or"[\'"..k.."\'] = ")
			else
				out = out..(Minify and"["..tostring(k).."]="or"["..tostring(k).."] = ")
			end
			local temp1,temp2 = SerializeMain(v, recurse, atIndent)
			out = out .. temp1
			if next(tb, k) then
				out = out..","
			end
			if not Minify then
				if useNewlines then
					out = out..'\n'
				else
					out = out..' '
				end
			end
			--end
		end
		out = out..(useNewlines and string.rep('    ', atIndent) or '').."}"
		if mttemp ~= nil then
			if Minify then
				out = 'setmetatable('..out..',{'..mttemp..'})'
			else
				out = 'setmetatable('..out..', {\n'..mttemp..'\n})'
			end
		end
		return out
	end
	function SerializeMain(input, recurse, atIndent)
		local finalout
		local printcode
		local s = SerialSeperator
		local e = EndSeperator
		if type(input) == 'number' or type(input) == 'boolean' or type(input) == 'nil' then
			finalout = (tostring(input))
			printcode = tostring(input)
		elseif type(input) == 'string' then
			finalout = ('\''..tostring(input)..'\'')
			printcode = (s..type(input)..s..tostring(input)..s..e..type(input)..s)
		elseif type(input) == 'table' then
            local temp = (StringifyTable(input, recurse, atIndent))
            if temp == 'RECURSIVE_TABLE' then
                return 'RECURSIVE_TABLE'
            else
                finalout = temp
                printcode = (s..type(input)..s..temp..s..e..type(input)..s)
            end
		elseif type(input) == 'function' then
			finalout = (StringifyFunction(input))
			printcode = (s..type(input)..s..StringifyFunction(input)..s..e..type(input)..s)
		elseif type(input) == 'userdata' or type(input) == 'thread' then --Work in progress
			finalout = (type(input))
			printcode = (s..type(input)..s..s..e..type(input)..s)
		end
		return finalout, printcode
	end
	local finalout, printcode = SerializeMain(input)
	if PrintOutput then
		print(LuaMode and finalout or printcode)
	else
		return LuaMode and finalout or printcode
	end
end

return printplusplus


--[[
    old ppp
--debug; modified to not loop hard and 3 level deepness



MaxDepth = 1



LuaMode=true;SerialSeperator='~'EndSeperator='/'Minify=false;PrintOutput=true;printplusplus=function(a)local b={assert,collectgarbage,coroutine,coroutine.create,coroutine.resume,coroutine.running,coroutine.status,coroutine.wrap,coroutine.yield,debug,debug.debug,debug.getfenv,debug.gethook,debug.getinfo,debug.getlocal,debug.getmetatable,debug.getregistry,debug.getupvalue,debug.setfenv,debug.sethook,debug.setlocal,debug.setmetatable,debug.setupvalue,debug.traceback,dofile,dump,error,gcinfo,getfenv,getmetatable,io,io.close,io.flush,io.input,io.lines,io.open,io.output,io.popen,io.read,io.stderr,io.stdin,io.stdout,io.tmpfile,io.type,io.write,ipairs,load,loadfile,loadstring,math,math.abs,math.acos,math.asin,math.atan,math.atan2,math.ceil,math.cos,math.cosh,math.deg,math.exp,math.floor,math.fmod,math.frexp,math.huge,math.ldexp,math.log,math.log10,math.max,math.min,math.mod,math.modf,math.pi,math.pow,math.rad,math.random,math.randomseed,math.sin,math.sinh,math.sqrt,math.tan,math.tanh,module,newproxy,next,os,os.clock,os.date,os.difftime,os.execute,os.exit,os.getenv,os.remove,os.rename,os.setlocale,os.time,os.tmpname,package,package.config,package.cpath,package.loaded,string.byte,string.char,string.dump,string.find,string.format,string.gfind,string.gmatch,string.gsub,string.len,string.lower,string.match,string.rep,string.reverse,string.sub,string.upper,table.concat,table.foreach,table.foreachi,table.getn,table.insert,table.maxn,table.remove,table.setn,table.sort,package.loaders,package.loadlib,package.path,package.preload,package.seeall,pairs,pcall,print,rawequal,rawget,rawset,require,select,setfenv,setmetatable,started,string,table,tonumber,tostring,type,unpack,xpcall}local c={'assert','collectgarbage','coroutine','coroutine.create','coroutine.resume','coroutine.running','coroutine.status','coroutine.wrap','coroutine.yield','debug','debug.debug','debug.getfenv','debug.gethook','debug.getinfo','debug.getlocal','debug.getmetatable','debug.getregistry','debug.getupvalue','debug.setfenv','debug.sethook','debug.setlocal','debug.setmetatable','debug.setupvalue','debug.traceback','dofile','dump','error','gcinfo','getfenv','getmetatable','io','io.close','io.flush','io.input','io.lines','io.open','io.output','io.popen','io.read','io.stderr','io.stdin','io.stdout','io.tmpfile','io.type','io.write','ipairs','load','loadfile','loadstring','math','math.abs','math.acos','math.asin','math.atan','math.atan2','math.ceil','math.cos','math.cosh','math.deg','math.exp','math.floor','math.fmod','math.frexp','math.huge','math.ldexp','math.log','math.log10','math.max','math.min','math.mod','math.modf','math.pi','math.pow','math.rad','math.random','math.randomseed','math.sin','math.sinh','math.sqrt','math.tan','math.tanh','module','newproxy','next','os','os.clock','os.date','os.difftime','os.execute','os.exit','os.getenv','os.remove','os.rename','os.setlocale','os.time','os.tmpname','package','package.config','package.cpath','package.loaded','string.byte','string.char','string.dump','string.find','string.format','string.gfind','string.gmatch','string.gsub','string.len','string.lower','string.match','string.rep','string.reverse','string.sub','string.upper','table.concat','table.foreach','table.foreachi','table.getn','table.insert','table.maxn','table.remove','table.setn','table.sort','package.loaders','package.loadlib','package.path','package.preload','package.seeall','pairs','pcall','print','rawequal','rawget','rawset','require','select','setfenv','setmetatable','started','string','table','tonumber','tostring','type','unpack','xpcall'}local function d(e)local f=e;if type(e)=='string'then local e,g=loadstring(e)if e==nil then return f end end;if pcall(function()string.dump(e)end)then if Minify then return'loadstring\''..(string.gsub(string.dump(e),'.',function(h)return'\\'..h:byte()end)or string.dump(e)..'\'')..'\''else return'loadstring(\''..(string.gsub(string.dump(e),'.',function(h)return'\\'..h:byte()end)or string.dump(e)..'\'')..'\')'end else for i=1,#b do if b[i]==e then return c[i]end end end end;local function j(k)local l=getmetatable(k)local m=nil;if l~=nil then local n=nil;m=''for o,p in pairs(l)do n=true;if Minify then m=m..o..'='..d(p)..','else m=m..o..' = '..d(p)..',\n'end end;if n==true then local q;if Minify then q=1 else q=2 end;m=string.sub(m,1,#m-q)return m else return nil end end end;local function r(s)local t=0;for u in pairs(s)do t=t+1 end;return t end;local function v(s,w)local x=j(s)w=(w or 0)+1;

print(w)
if w>MaxDepth then return'...'end    
    
local y=r(s)>1;local z=string.rep('    ',w)local A="{"..(y and'\n'or'')if Minify then z=''A='{'end;for o,p in pairs(s)do A=A..(y and z or'')if type(o)=='number'then elseif type(o)=='string'and o:match("^[A-Za-z_][A-Za-z0-9_]*$")then A=A..o..(Minify and"="or" = ")elseif type(o)=='string'then A=A..(Minify and"[\'"..o.."\']="or"[\'"..o.."\'] = ")else A=A..(Minify and"["..tostring(o).."]="or"["..tostring(o).."] = ")end;local B,C=SerializeMain(p)A=A..B;if next(s,o)then A=A..","end;if not Minify then if y then A=A..'\n'else A=A..' 'end end end;A=A..(y and string.rep('    ',w)or'').."}"if x~=nil then if Minify then A='setmetatable('..A..',{'..x..'})'else A='setmetatable('..A..', {\n'..x..'\n})'end end;return A end;function SerializeMain(a)local D;local E;local F=SerialSeperator;local G=EndSeperator;if type(a)=='number'or type(a)=='boolean'or type(a)=='nil'then D=tostring(a)E=tostring(a)elseif type(a)=='string'then D='\''..tostring(a)..'\''E=F..type(a)..F..tostring(a)..F..G..type(a)..F elseif type(a)=='table'then D=v(a,w)E=F..type(a)..F..v(a,w)..F..G..type(a)..F elseif type(a)=='function'then D=d(a)E=F..type(a)..F..d(a)..F..G..type(a)..F elseif type(a)=='userdata'or type(a)=='thread'then D=type(a)E=F..type(a)..F..F..G..type(a)..F end;return D,E end;local D,E=SerializeMain(a)if PrintOutput then print(LuaMode and D or E)else return LuaMode and D or E end end;ppp=printplusplus;return ppp
--]]