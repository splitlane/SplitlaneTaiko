return {
{
    Name = 'help',
    Alias = {'h'},
    Description = 'Displays a list of commands, or inspects one.',
    Args = {
        {
            Name = 'Command',
            Type = 'command',
            Description = 'The command to inspect.',
            Optional = true
        }
    },
    Run = function(CommandName)
        if CommandName then
            local c = Command.GetCommand(CommandName)
            if c then
                local str = 'Command: ' .. c.Name .. '\n'
                if c.Alias then
                    str = str .. 'Aliases: '
                    for i = 1, #c.Alias do
                        str = str .. c.Alias[i] .. ', '
                    end
                    str = string.sub(str, 1, -3) .. '\n'
                end
                if c.Args then
                    for i = 1, #c.Args do
                        str = str .. '#1: ' .. c.Args[i].Name .. ' - ' .. c.Args[i].Description .. '\n'
                    end
                end
                Command.Output(str)
            else
                Command.Output('Invalid Command \'' .. CommandName .. '\'.\n')
            end
        else
            local str = ''
            for i = 1, #Data do
                str = str .. Data[i].Name .. ' // ' .. Data[i].Description .. '\n'
            end
            Command.Output(str)
        end
    end
},
{
    Name = 'version',
    Alias = {'v'},
    Description = 'Displays the current lua version',
    Args = {},
    Run = function()
        Command.Print(_VERSION)
    end
},
{
    Name = 'print',
    Alias = {'p', 'echo'},
    Description = 'Prints the argument.',
    Args = {
        {
            Name = 'String',
            Type = 'string',
            Description = 'The string to print',
            Optional = false
        }
    },
    Run = function(str)
        Command.Print(str)
    end
},
{
    Name = 'error',
    Alias = {},
    Description = 'Errors the argument.',
    Args = {
        {
            Name = 'String',
            Type = 'string',
            Description = 'The string to error',
            Optional = false
        }
    },
    Run = function(str)
        error(str)
    end
},
{
    Name = 'length',
    Alias = {'len'},
    Description = 'Returns the length of a string.',
    Args = {
        {
            Name = 'String',
            Type = 'string',
            Description = 'String',
            Optional = false
        }
    },
    Run = function(str)
        Command.Print('Length: ' .. #str)
    end
},
{
    Name = 'bind',
    Alias = {'b'},
    Description = 'Binds a string to a command.',
    Args = {
        {
            Name = 'String',
            Type = 'string',
            Description = 'The string to bind the command on.',
            Optional = false
        },
        {
            Name = 'Command',
            Type = 'command',
            Description = 'The command that will be binded.',
            Optional = false
        }
    },
    Run = function(str, CommandName)
        local c = Command.GetCommand(CommandName)
        if c then
            table.insert(c.Alias, str)
        else
            Command.Output('Invalid Command \'' .. CommandName .. '\'.\n')
        end
    end
},
{
    Name = 'unbind',
    Alias = {'ub'},
    Description = 'Unbinds a string to a command.',
    Args = {
        {
            Name = 'String',
            Type = 'string',
            Description = 'The string to bind the command on.',
            Optional = false
        },
        {
            Name = 'Command',
            Type = 'string',
            Description = 'The command that will be binded.',
            Optional = false
        }
    },
    Run = function(str, CommandName)
        local c = Command.GetCommand(CommandName)
        if c then
            for i = 1, #c.Alias do
                if c.Alias[i] == str then
                    c.Alias[i] = nil
                end
            end
        else
            Command.Output('Invalid Command \'' .. CommandName .. '\'.\n')
        end
    end
},
{
    Name = 'history',
    Alias = {},
    Description = 'Displays previous commands from history.',
    Args = {
        {
            Name = 'Line Number',
            Type = 'number',
            Description = 'The line number to display',
            Optional = true
        }
    },
    Run = function(line)
        if line then
            line = tonumber(line)
            Command.Print(Command.History[line > 0 and line or line < 0 and #Command.History + line])
        else
            for i = 1, #Command.History do
                Command.Print(Command.History[i])
            end
        end
    end
},
{
    Name = 'random',
    Alias = {'rand'},
    Description = 'Picks a random value between start and end.',
    Args = {
        {
            Name = 'Start',
            Type = 'number',
            Description = 'Start',
            Optional = false
        },
        {
            Name = 'End',
            Type = 'number',
            Description = 'End',
            Optional = false
        }
    },
    Run = function(s, e)
        Command.Print(math.random(s, e))
    end
},
{
    Name = 'brainfuck',
    Alias = {'bf'},
    Description = 'Executes brainfuck code.',
    Args = {
        {
            Name = 'Brainfuck',
            Type = 'string',
            Description = 'Code to execute.',
            Optional = false
        }
    },
    Run = function(code)
local function Brainfuck(b)return loadstring('d,a,b={},setmetatable({},{__index=function(t,k)return d[k]or 0 end,__newindex=function(t,k,v)if v>255 then d[k]=0 elseif v<0 then d[k]=255 else d[k]=v end end}),0;'..b:gsub('[^%+%-<>%.,%[%]]',''):gsub('.',{['+']='a[b]=a[b]+1;',['-']='a[b]=a[b]-1;',['>']='b=b+1;',['<']='b=b-1;',['[']='while(a[b]~=0)do ',[']']='end;',['.']='io.write(string.char(a[b]))',[',']='a[b]=io.read(1):byte()'})..'return a[b]')()end


Command.Print(Brainfuck(code))
    end
},
{
    Name = 'math',
    Alias = {'m'},
    Description = 'Executes a math expression.',
    Args = {
        {
            Name = 'Expression',
            Type = 'string',
            Description = 'Expression to execute.',
            Optional = false
        }
    },
    Run = function(expr)
------------------------------------------------------------------------
-- LuaXP is a simple expression evaluator for Lua, based on lexp.js, a
-- lightweight (math) expression evaluator for JavaScript by the same
-- author.
--
-- Author: Copyright (c) 2016,2018 Patrick Rigney <patrick@toggledbits.com>
-- License: MIT License
-- Github: https://github.com/toggledbits/luaxp
------------------------------------------------------------------------

local function Math(z)local qb={}qb._VERSION="1.0.1"qb._VNUMBER=10001;qb._DEBUG=false;qb.binops={{op='.',prec=-1},{op='*',prec=3},{op='/',prec=3},{op='%',prec=3},{op='+',prec=4},{op='-',prec=4},{op='<',prec=6},{op='..',prec=5},{op='<=',prec=6},{op='>',prec=6},{op='>=',prec=6},{op='==',prec=7},{op='<>',prec=7},{op='!=',prec=7},{op='~=',prec=7},{op='&',prec=8},{op='^',prec=9},{op='|',prec=10},{op='&&',prec=11},{op='and',prec=11},{op='||',prec=12},{op='or',prec=12},{op='=',prec=14}}local rb=99;local sb=require("string")local tb=require("math")local ub=_G;local vb='const'local wb='vref'local xb='fref'local yb='unop'local zb='binop'local Ab='null'local Bb={__type=Ab}setmetatable(Bb,{__tostring=function()return"null"end})local Cb={t="\t",r="\r",n="\n"}local Db={['false']=false,['true']=true,pi=tb.pi,PI=tb.pi,['null']=Bb,['NULL']=Bb,['nil']=Bb}local function Eb(Ec,Fc)if Fc==nil then Fc={}end;local Gc=ub.type(Ec)if Gc=="table"and Fc[Ec]==nil then Fc[Ec]=1;local Hc="{ "local Ic=true;for Jc,Kc in pairs(Ec)do if not Ic then Hc=Hc..", "end;Hc=Hc..Jc.."="..Eb(Kc,Fc)Ic=false end;Hc=Hc.." }"return Hc elseif Gc=="string"then return sb.format("%q",Ec)elseif Gc=="boolean"or Gc=="number"then return tostring(Ec)end;return sb.format("(%s)%s",Gc,tostring(Ec))end;local function Fb(Ec,...)if not qb._DEBUG then return end;local Fc=sb.gsub(Ec,"%%(%d+)",function(Gc)Gc=tonumber(Gc,10)if Gc<1 or Gc>#arg then return"nil"end;local Hc=arg[Gc]if ub.type(Hc)=="table"then return Eb(Hc)elseif ub.type(Hc)=="string"then return sb.format("%q",Hc)end;return tostring(Hc)end)if ub.type(qb._DEBUG)=="function"then qb._DEBUG(Fc)else Command.Print(Fc)end end;local Gb,Hb,Ib,Jb;local function Kb(Ec)if ub.type(Ec)~="table"then return Ec end;local Fc={}for Gc,Hc in pairs(Ec)do if ub.type(Hc)=="table"then Fc[Gc]=Kb(Hc)else Fc[Gc]=Hc end end;return Fc end;local function Lb(Ec,Fc)return ub.type(Ec)=="table"and Ec.__type~=nil and(Fc==nil or Ec.__type==Fc)end;local function Mb(Ec)return Lb(Ec,Ab)end;local function Nb(Ec,Fc)Fb("throwing comperror at %1: %2",Fc,Ec)return error({__source='luaxp',['type']='compile',location=Fc,message=Ec})end;local function Ob(Ec,Fc)Fb("throwing evalerror at %1: %2",Fc,Ec)return error({__source='luaxp',['type']='evaluation',location=Fc,message=Ec})end;local function Pb(Ec)local Fc,Gc=unpack(Ec or{})return tb.exp(Gc*tb.log(Fc))end;local function Qb(Ec)local Fc,Gc,Hc=unpack(Ec or{})if ub.type(Fc)~="table"then Ob("select() requires table/object arg 1")end;Gc=tostring(Gc)Hc=tostring(Hc)for Ic,Jc in pairs(Fc)do if tostring(Jc[Gc])==Hc then return Jc end end;return Bb end;local Rb={}local function Sb(Ec)if Ec==nil then error("nil month name")end;local Fc=sb.lower(tostring(Ec))if Fc:match("^%d+$")then local Hc=tonumber(Fc)or 0;if Hc>=1 and Hc<=12 then return Hc end end;if Rb[Fc]~=nil then Fb("mapLocaleMonth(%1) cached result=%2",Fc,Rb[Fc])return Rb[Fc]end;local Gc=os.date("*t")Gc.day=1;for k=1,12 do Gc.month=k;local Hc=os.time(Gc)local Ic=os.date("#%b#%B#",Hc):lower()if Ic:find("#"..Fc.."#")then Rb[Fc]=k;return k end end;return Ob("Cannot parse month name '"..Ec.."'")end;local Tb=0;local Ub=1;local Vb=2;local function Wb()local Ec=os.date("%x",os.time({year=2001,month=8,day=22,hour=0}))local Fc={Ec:match("(%d+)([/-])(%d+)[/-](%d+)")}if Fc[1]=="2001"then return Tb,Fc[2]elseif tonumber(Fc[1])==22 then return Ub,Fc[2]else return Vb,Fc[2]end end;local function Xb(Ec)if ub.type(Ec)=="number"then return Ec end;if Ec==nil or tostring(Ec):lower()=="now"then return os.time()end;Ec=tostring(Ec)local Fc=os.time()local Gc=os.date("*t",Fc)local Hc={year=Gc.year,month=Gc.month,day=Gc.day,hour=0,['min']=0,sec=0}local Ic=0;local Jc=nil;local Kc={Ec:match("^%s*(%d+)([/-])(%d+)(.*)")}if Kc[3]==nil then Fb("match 2")Kc={Ec:match("^%s*(%d+)([/-])(%a+)(.*)")}Jc=Ub end;if Kc[3]==nil then Fb("match 3")Kc={Ec:match("^%s*(%a+)([/-])(%d+)(.*)")}Jc=Vb end;if Kc[3]~=nil then Fb("Found p1=%1, p2=%2, sep=%3, rem=%4",Kc[1],Kc[2],Kc[3],Kc[4])local Oc=Kc[2]Ec=Kc[4]or""Fb("Scanning for 3rd part from: '%1'",Ec)Kc[4],Kc[5]=Ec:match("^%"..Oc.."(%d+)(.*)")if Kc[4]==nil then Kc[4]=Hc.year else Ec=Kc[5]or""end;Kc[5]=Ec;Kc[6]=Kc[6]or""Fb("p=%1,%2,%3,%4,%5",unpack(Kc))local Pc=tonumber(Kc[1])or 0;if Jc==nil and Pc>31 then Hc.year=Pc;Hc.month=Sb(Kc[3])Hc.day=Kc[4]elseif Jc==nil and Pc>12 then Hc.day=Pc;Hc.month=Sb(Kc[3])Hc.year=Kc[4]else if Jc==nil then Fb("Guessing MDY order")Jc=Wb()end;Fb("MDY order is %1",Jc)if Jc==0 then Hc.year=Kc[1]Hc.month=Sb(Kc[3])Hc.day=Kc[4]elseif Jc==1 then Hc.day=Kc[1]Hc.month=Sb(Kc[3])Hc.year=Kc[4]else Hc.month=Sb(Kc[1])Hc.day=Kc[3]Hc.year=Kc[4]end end;Hc.year=tonumber(Hc.year)if Hc.year<100 then Hc.year=Hc.year+2000 end;Fb("Parsed date year=%1, month=%2, day=%3",Hc.year,Hc.month,Hc.day)else Fb("No match to delimited")Kc={Ec:match("^%s*(%d%d%d%d)(%d%d)(%d%d)(.*)")}if Kc[3]~=nil then Hc.year=Kc[1]Hc.month=Kc[2]Hc.day=Kc[3]Ec=Kc[4]or""else Fb("check %%c format")Kc={Ec:match("^%s*%a+%s+(%a+)%s+(%d+)(.*)")}if Kc[2]==nil then Kc={Ec:match("^%s*(%a+)%s+(%d+)(.*)")}end;if Kc[2]~=nil then Fb("Matches %%c format, 1=%1,2=%2,3=%3",Kc[1],Kc[2],Kc[3])Hc.day=Kc[2]Hc.month=Sb(Kc[1])Ec=Kc[3]or""Kc={Ec:match("^%s*([%d:]+)%s+(%d%d%d%d)(.*)")}if Kc[1]~=nil then Hc.year=Kc[2]Ec=(Kc[1]or"").." ".. (Kc[3]or"")else Kc={Ec:match("^%s*(%d%d%d%d)(.*)")}if Kc[1]~=nil then Hc.year=Kc[1]Ec=Kc[2]or""end end else Fb("No luck with any known date format.")end end;Fb("Parsed date year=%1, month=%2, day=%3",Hc.year,Hc.month,Hc.day)end;Fb("Scanning for time from: '%1'",Ec)local Lc=false;Kc={Ec:match("^%s*T?(%d%d)(%d%d)(.*)")}if Kc[1]==nil then Kc={Ec:match("^%s*T?(%d+):(%d+)(.*)")}end;if Kc[1]~=nil then Hc.hour=Kc[1]Hc['min']=Kc[2]Ec=Kc[3]or""Kc={Ec:match("^:?(%d+)(.*)")}if Kc[1]~=nil then Hc.sec=Kc[1]Ec=Kc[2]or""end;Kc={Ec:match("^(%.%d+)(.*)")}if Kc[1]~=nil then Ec=Kc[2]or""end;Kc={Ec:match("^%s*([AaPp])[Mm]?(.*)")}if Kc[1]~=nil then Fb("AM/PM is %1",Kc[1])if Kc[1]:lower()=="p"then Hc.hour=Hc.hour+12 end;Ec=Kc[2]or""end;Fb("Parsed time is %1:%2:%3",Hc.hour,Hc['min'],Hc.sec)Kc={Ec:match("^([zZ])(.*)")}if Kc[1]~=nil then Ic=0;Lc=true;Ec=Kc[2]or""end;Kc={Ec:match("^([+-]%d%d)(.*)")}if Kc[1]~=nil then Lc=true;Ic=60 *tonumber(Kc[1])Ec=Kc[2]Kc={Ec:match("^:?(%d%d)(.*)")}if Kc[1]~=nil then if Ic<0 then Ic=Ic-tonumber(Kc[1])else Ic=Ic+tonumber(Kc[1])end;Ec=Kc[2]or""end end end;local Mc=0;Fb("Checking for offset from '%1'",Ec)Kc={Ec:match("%s*([+-])(%d+)(.*)")}if Kc[2]~=nil then Fb("Parsing offset from %1, first part is %2",Ec,Kc[2])local Oc=Kc[1]Mc=tonumber(Kc[2])if Mc==nil then Ob("Invalid delta spec: "..Ec)end;Ec=Kc[3]or""for k=1,3 do Fb("Parsing offset from %1",Ec)Kc={Ec:match("%:(%d+)(.*)")}if Kc[1]==nil then break end;if k==3 then Mc=Mc*24 else Mc=Mc*60 end;Mc=Mc+tonumber(Kc[1])Ec=Kc[2]or""end;if Oc=="-"then Mc=-Mc end;Fb("Final delta is %1",Mc)end;if Ec:match("([^%s])")then return Ob("Unparseable data: "..Ec)end;local Nc=os.time(Hc)if Lc then local Oc=os.date("*t",Nc)local Pc={year=1970,month=1,day=1,hour=0}Pc.isdst=Oc.isdst;local Qc=os.time(Pc)Nc=Nc-Qc;Nc=Nc- (Ic*60)end;Nc=Nc+Mc;return Nc end;local function Yb(Ec)local Fc=Xb(Ec[1])if Ec[2]~=nil then Fc=Fc+ (tonumber(Ec[2])or Ob("Invalid seconds (argument 2) to dateadd()"))end;if Ec[3]~=nil then Fc=Fc+60 * (tonumber(Ec[3])or Ob("Invalid minutes (argument 3) to dateadd()"))end;if Ec[4]~=nil then Fc=Fc+3600 * (tonumber(Ec[4])or Ob("Invalid hours (argument 4) to dateadd()"))end;if Ec[5]~=nil then Fc=Fc+86400 * (tonumber(Ec[5])or Ob("Invalid days (argument 5) to dateadd()"))end;if Ec[6]~=nil or Ec[7]~=nil then Fb("Applying delta months and years to %1",Fc)local Gc=os.date("*t",Fc)Gc.month=Gc.month+ (tonumber(Ec[6])or 0)Gc.year=Gc.year+ (tonumber(Ec[7])or 0)Fb("Normalizing month,year=%1,%2",Gc.month,Gc.year)while Gc.month<1 do Gc.month=Gc.month+12;Gc.year=Gc.year-1 end;while Gc.month>12 do Gc.month=Gc.month-12;Gc.year=Gc.year+1 end;Fc=os.time(Gc)end;return Fc end;local function Zb(Ec,Fc)return Xb(Ec)-Xb(Fc or os.time())end;local function ac(Ec,Fc,Gc,Hc,Ic,Jc)local Kc=os.date("*t")Kc.year=tonumber(Ec)or Kc.year;Kc.month=tonumber(Fc)or Kc.month;Kc.day=tonumber(Gc)or Kc.day;Kc.hour=tonumber(Hc)or Kc.hour;Kc.min=tonumber(Ic)or Kc.min;Kc.sec=tonumber(Jc)or Kc.sec;Kc.isdst=nil;Kc.yday=nil;Kc.wday=nil;return os.time(Kc)end;local function bc(Ec)if ub.type(Ec)~="string"then Ob("String required")end;return Ec:gsub("%s+$","")end;local function cc(Ec)if ub.type(Ec)~="string"then Ob("String required")end;return Ec:gsub("^%s+","")end;local function dc(Ec)if ub.type(Ec)~="string"then Ob("String required")end;return cc(bc(Ec))end;local function ec(Ec)local Fc=unpack(Ec or{})if ub.type(Fc)~="table"then Ob("Array/table required")end;local Gc={}for Hc in pairs(Fc)do if Hc~="__context"then table.insert(Gc,Hc)end end;return Gc end;local function fc(Ec)local Fc=0;for Gc in pairs(Ec)do Fc=Fc+1 end;return Fc end;local function gc(Ec)local Fc=tostring(Ec[1]or"")local Gc=Ec[2]or","local Hc={}if#Fc==0 then return Hc,0 end;local Ic=sb.gsub(Fc or"","([^"..Gc.."]*)"..Gc,function(Jc)table.insert(Hc,Jc)return""end)table.insert(Hc,Ic)return Hc,#Hc end;local function hc(Ec)local Fc=Ec[1]or{}if type(Fc)~="table"then Ob("Argument 1 to join() is not an array")end;local Gc=Ec[2]or","return table.concat(Fc,Gc)end;local function ic(Ec)local Fc=Bb;for Gc,Hc in ipairs(Ec)do local Ic=Hc;if type(Hc)=="table"then Ic=ic(Hc)end;if type(Ic)=="number"and(Fc==Bb or Ic<Fc)then Fc=Ic end end;return Fc end;local function jc(Ec)local Fc=Bb;for Gc,Hc in ipairs(Ec)do local Ic=Hc;if type(Hc)=="table"then Ic=jc(Hc)end;if type(Ic)=="number"and(Fc==Bb or Ic>Fc)then Fc=Ic end end;return Fc end;local kc="Non-numeric argument 1"local lc={['abs']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return(Fc<0)and-Fc or Fc end},['sgn']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return(Fc<0)and-1 or( (Fc==0)and 0 or 1)end},['floor']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.floor(Fc)end},['ceil']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.ceil(Fc)end},['round']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)local Gc=tonumber(Ec[2])or 0;return tb.floor(Fc* (10 ^Gc)+0.5)/ (10 ^Gc)end},['cos']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.cos(Fc)end},['sin']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.sin(Fc)end},['tan']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.tan(Fc)end},['asin']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.asin(Fc)end},['acos']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.acos(Fc)end},['atan']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.atan(Fc)end},['rad']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return Fc*tb.pi/180 end},['deg']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return Fc*180 /tb.pi end},['log']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.log(Fc)end},['exp']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.exp(Fc)end},['pow']={nargs=2,impl=Pb},['sqrt']={nargs=1,impl=function(Ec)local Fc=tonumber(Ec[1])or Ob(kc)return tb.sqrt(Fc)end},['min']={nargs=1,impl=ic},['max']={nargs=1,impl=jc},['randomseed']={nargs=0,impl=function(Ec)local Fc=Ec[1]or os.time()tb.randomseed(Fc)return Fc end},['random']={nargs=0,impl=function(Ec)return tb.random(unpack(Ec))end},['len']={nargs=1,impl=function(Ec)if Mb(Ec[1])then return 0 elseif type(Ec[1])=="table"then return fc(Ec[1])else return sb.len(tostring(Ec[1]))end end},['sub']={nargs=2,impl=function(Ec)local Fc=tostring(Ec[1])local Gc=Ec[2]local Hc=(Ec[3]or-1)return sb.sub(Fc,Gc,Hc)end},['find']={nargs=2,impl=function(Ec)local Fc=tostring(Ec[1])local Gc=tostring(Ec[2])local Hc=Ec[3]or 1;return(sb.find(Fc,Gc,Hc)or 0)end},['upper']={nargs=1,impl=function(Ec)return sb.upper(tostring(Ec[1]))end},['lower']={nargs=1,impl=function(Ec)return sb.lower(tostring(Ec[1]))end},['trim']={nargs=1,impl=function(Ec)return dc(tostring(Ec[1]))end},['ltrim']={nargs=1,impl=function(Ec)return cc(tostring(Ec[1]))end},['rtrim']={nargs=1,impl=function(Ec)return bc(tostring(Ec[1]))end},['tostring']={nargs=1,impl=function(Ec)if Mb(Ec[1])then return""else return tostring(Ec[1])end end},['tonumber']={nargs=1,impl=function(Ec)if ub.type(Ec[1])=="boolean"then if Ec[1]then return 1 else return 0 end end;return tonumber(Ec[1],Ec[2]or 10)or Ob('Argument could not be converted to number')end},['format']={nargs=1,impl=function(Ec)return sb.format(unpack(Ec))end},['split']={nargs=1,impl=gc},['join']={nargs=1,impl=hc},['time']={nargs=0,impl=function(Ec)return Xb(Ec[1])end},['timepart']={nargs=0,impl=function(Ec)return os.date(Ec[2]and"!*t"or"*t",Ec[1])end},['date']={nargs=0,impl=function(Ec)return ac(unpack(Ec))end},['strftime']={nargs=1,impl=function(Ec)return os.date(unpack(Ec))end},['dateadd']={nargs=2,impl=function(Ec)return Yb(Ec)end},['datediff']={nargs=1,impl=function(Ec)return Zb(Ec[1],Ec[2]or os.time())end},['choose']={nargs=2,impl=function(Ec)local Fc=Ec[1]if Fc<1 or Fc> (#Ec-2)then return Ec[2]else return Ec[Fc+2]end end},['select']={nargs=3,impl=Qb},['keys']={nargs=1,impl=ec},['iterate']={nargs=2,impl=true},['map']={nargs=2,impl=true},['if']={nargs=2,impl=true},['void']={nargs=0,impl=function(Ec)return Bb end},['list']={nargs=0,impl=function(Ec)local Fc=Kb(Ec)Fc.__context=nil;return Fc end},['first']={nargs=1,impl=function(Ec)local Fc=Ec[1]if ub.type(Fc)~="table"or#Fc==0 then return Bb else return Fc[1]end end},['last']={nargs=1,impl=function(Ec)local Fc=Ec[1]if ub.type(Fc)~="table"or#Fc==0 then return Bb else return Fc[#Fc]end end}}local mc,nc=pcall(require,"bit")if not(type(nc)=="table"and nc.band and nc.bor and nc.bnot and nc.bxor)then nc=nil end;if not nc then nc={}nc['nand']=function(Ec,Fc,Gc)Gc=Gc or 2 ^16;if Gc<2 then return 1 -Ec*Fc else return nc.nand((Ec-Ec%Gc)/Gc,(Fc-Fc%Gc)/Gc,tb.sqrt(Gc))*Gc+nc.nand(Ec%Gc,Fc%Gc,tb.sqrt(Gc))end end;nc["bnot"]=function(Ec,Fc)return nc.nand(nc.nand(0,0,Fc),Ec,Fc)end;nc["band"]=function(Ec,Fc,Gc)return nc.nand(nc["bnot"](0,Gc),nc.nand(Ec,Fc,Gc),Gc)end;nc["bor"]=function(Ec,Fc,Gc)return nc.nand(nc["bnot"](Ec,Gc),nc["bnot"](Fc,Gc),Gc)end;nc["bxor"]=function(Ec,Fc,Gc)return nc["band"](nc.nand(Ec,Fc,Gc),nc["bor"](Ec,Fc,Gc),Gc)end end;local function oc(Ec,Fc)Fb("skip_white from %1 in %2",Fc,Ec)local Gc,Hc=sb.find(Ec,"^%s+",Fc)if Hc then Fc=Hc+1 end;return Fc end;local function pc(Ec,Fc)Fb("scan_numeric from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)local Hc,Ic;local Jc=0;local Kc=0;Hc=sb.sub(Ec,Fc,Fc)if Hc=='0'and Fc<Gc then Fc=Fc+1;Hc=sb.sub(Ec,Fc,Fc)if Hc=='b'or Hc=='B'then Kc=2;Fc=Fc+1 elseif Hc=='x'or Hc=='X'then Kc=16;Fc=Fc+1 elseif Hc=='.'then Kc=10 else Kc=8 end end;if Kc<=0 then Kc=10 end;while(Fc<=Gc)do Hc=sb.sub(Ec,Fc,Fc)if Hc=='.'then break end;Ic=sb.find("0123456789ABCDEF",sb.upper(Hc),1,true)if Ic==nil or(Kc==10 and Ic==15)then break end;if Ic>Kc then Nb("Invalid digit for radix "..Kc,Fc)end;Jc=Kc*Jc+ (Ic-1)Fc=Fc+1 end;if Hc=='.'and Kc==10 then local Lc=0;Fc=Fc+1;while(Fc<=Gc)do Hc=sb.sub(Ec,Fc,Fc)Ic=sb.byte(Hc)-48;if Ic<0 or Ic>9 then break end;Lc=Lc+1;Jc=Jc+ (Ic*10 ^-Lc)Fc=Fc+1 end end;if(Hc=='e'or Hc=='E')and Kc==10 then local Lc=0;local Mc=nil;Fc=Fc+1;local Nc=Fc;while(Fc<=Gc)do Hc=sb.sub(Ec,Fc,Fc)if Mc==nil and Hc=="-"then Mc=true elseif Mc==nil and Hc=="+"then Mc=false else Ic=sb.byte(Hc)-48;if Ic<0 or Ic>9 then break end;Lc=Lc*10 +Ic;if Mc==nil then Mc=false end end;Fc=Fc+1 end;if Fc==Nc then Nb("Missing exponent",Fc)end;if Mc then Lc=-Lc end;Jc=Jc* (10 ^Lc)end;Fb("scan_numeric returning index=%1, val=%2",Fc,Jc)return Fc,{__type=vb,value=Jc}end;local function qc(Ec,Fc)Fb("scan_string from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)local Hc=""local Ic;local Jc=sb.sub(Ec,Fc,Fc)Fc=Fc+1;while Fc<=Gc do Ic=sb.sub(Ec,Fc,Fc)if Ic=='\\'and Fc<Gc then Fc=Fc+1;Ic=sb.sub(Ec,Fc,Fc)if Cb[Ic]then Ic=Cb[Ic]end elseif Ic==Jc then Fc=Fc+1;return Fc,{__type=vb,value=Hc}end;Hc=Hc..Ic;Fc=Fc+1 end;return Nb("Unterminated string",Fc)end;local function rc(Ec,Fc,Gc)Fb("scan_fref from %1 in %2",Fc,Ec)local Hc=sb.len(Ec)local Ic={}local Jc=1;local Kc;local Lc=""Fc=oc(Ec,Fc)+1;while(true)do if Fc>Hc then return Nb("Unexpected end of argument list",Fc)end;Kc=sb.sub(Ec,Fc,Fc)if Kc==')'then Fb("scan_fref: Found a closing paren while at level %1",Jc)Jc=Jc-1;if Jc==0 then Lc=dc(Lc)Fb("scan_fref: handling end of argument list with subexp=%1",Lc)if sb.len(Lc)>0 then table.insert(Ic,Gb(Lc))elseif#Ic>0 then Nb("Invalid subexpression",Fc)end;Fc=Fc+1;Fb("scan_fref returning, function is %1 with %2 args",Gc,#Ic,Eb(Ic))return Fc,{__type=xb,args=Ic,name=Gc,pos=Fc}else Lc=Lc..Kc;Fc=Fc+1 end elseif Kc=="'"or Kc=='"'then local Mc=Kc;Fc,Kc=qc(Ec,Fc)Lc=Lc..Mc..Kc.value..Mc elseif Kc==','and Jc==1 then Lc=dc(Lc)Fb("scan_fref: handling argument=%1",Lc)if sb.len(Lc)>0 then local Mc=Gb(Lc)if Mc==nil then return Nb("Subexpression failed to compile",Fc)end;table.insert(Ic,Mc)Fb("scan_fref: inserted argument %1 as %2",Lc,Mc)else Nb("Invalid subexpression",Fc)end;Fc=oc(Ec,Fc+1)Lc=""Fb("scan_fref: continuing argument scan in %1 from %2",Ec,Fc)else Lc=Lc..Kc;if Kc=='('then Jc=Jc+1 end;Fc=Fc+1 end end end;local function sc(Ec,Fc,Gc)Fb("scan_aref from %1 in %2",Fc,Ec)local Hc=sb.len(Ec)local Ic;local Jc=""local Kc=0;Fc=oc(Ec,Fc)+1;while(true)do if Fc>Hc then return Nb("Unexpected end of array subscript expression",Fc)end;Ic=sb.sub(Ec,Fc,Fc)if Ic==']'then if Kc==0 then Fb("scan_aref: Found a closing bracket, subexp=%1",Jc)local Lc=Gb(Jc)Fb("scan_aref returning, array is %1",Gc)return Fc+1,{__type=wb,name=Gc,index=Lc,pos=Fc}end;Kc=Kc-1 elseif Ic=="["then Kc=Kc+1 end;Jc=Jc..Ic;Fc=Fc+1 end end;local function tc(Ec,Fc)Fb("scan_vref from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)local Hc,Ic;local Jc=""while Fc<=Gc do Hc=sb.sub(Ec,Fc,Fc)if sb.find(Ec,"^%s*%(",Fc)then if Jc==""then Nb("Invalid operator",Fc)end;return rc(Ec,Fc,Jc)elseif sb.find(Ec,"^%s*%[",Fc)then return sc(Ec,Fc,Jc)end;Ic=sb.find("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_",sb.upper(Hc),1,true)if Ic==nil then break elseif Jc==""and Ic<=10 then return Nb("Invalid identifier",Fc)end;Jc=Jc..Hc;Fc=Fc+1 end;return Fc,{__type=wb,name=Jc,pos=Fc}end;local function uc(Ec,Fc)Fb("scan_expr from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)local Hc=""local Ic=0;Fc=Fc+1;while Fc<=Gc do local Jc=sb.sub(Ec,Fc,Fc)if Jc==')'then if Ic==0 then Fb("scan_expr parsing subexpression=%1",Hc)local Kc=Gb(Hc)if Kc==nil then return Nb("Subexpression failed to parse",Fc)end;return Fc+1,Kc end;Ic=Ic-1 elseif Jc=='('then Ic=Ic+1 end;Hc=Hc..Jc;Fc=Fc+1 end;return Fc,nil end;local function vc(Ec,Fc)Fb("scan_unop from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)if Fc>Gc then return Fc,nil end;local Hc=sb.sub(Ec,Fc,Fc)if Hc=='-'or Hc=='+'or Hc=='!'or Hc=='#'then Fc=Fc+1;local Ic,Jc=Jb(Ec,Fc)if Jc==nil then return Ic,Jc end;return Ic,{__type=yb,op=Hc,pos=Fc,operand=Jc}end;return Fc,nil end;local function wc(Ec,Fc)Fb("scan_binop from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)Fc=oc(Ec,Fc)if Fc>Gc then return Fc,nil end;local Hc=""local Ic=0;local Jc;while Fc<=Gc do local Kc=sb.sub(Ec,Fc,Fc)local Lc=Hc..Kc;local Mc=false;Ic=Ic+1;for Nc,Oc in ipairs(qb.binops)do if sb.sub(Oc.op,1,Ic)==Lc then Mc=true;Jc=Oc.prec;break end end;if not Mc then if Ic==1 then return Nb("Invalid operator",Fc)end;break end;Hc=Lc;Fc=Fc+1 end;Fb("scan_binop succeeds with op=%1",Hc)return Fc,{__type=zb,op=Hc,prec=Jc,pos=Fc}end;Jb=function(Ec,Fc)Fb("scan_token from %1 in %2",Fc,Ec)local Gc=sb.len(Ec)Fc=oc(Ec,Fc)if Fc>Gc then return Fc,nil end;local Hc=sb.sub(Ec,Fc,Fc)Fb("scan_token guessing from %1 at %2",Hc,Fc)if Hc=='"'or Hc=="'"then return qc(Ec,Fc)elseif Hc=='('then return uc(Ec,Fc)elseif sb.find("0123456789",Hc,1,true)~=nil then return pc(Ec,Fc)elseif Hc=="."then if Fc<Gc and sb.find("0123456789",sb.sub(Ec,Fc+1,Fc+1),1,true)~=nil then return pc(Ec,Fc)end end;local Ic,Jc;Ic,Jc=vc(Ec,Fc)if Jc~=nil then return Ic,Jc end;Ic,Jc=tc(Ec,Fc)if Jc~=nil then return Ic,Jc end;return Nb("Invalid token",Fc)end;local function xc(Ec,Fc,Gc,Hc)Fb("parse_rpn: parsing %1 from %2 prec %3 lhs %4",Fc,Gc,Hc,Ec)local Ic,Jc,Kc,Lc;Lc=Gc;Gc,Kc=wc(Fc,Gc)Fb("parse_rpn: outside lookahead is %1",Kc)while(Kc~=nil and Kc.prec<=Hc)do Ic=Kc;Fb("parse_rpn: mid at %1 handling ",Gc,Ic)Gc,Jc=Jb(Fc,Gc)Fb("parse_rpn: mid rexpr is %1",Jc)if Jc==nil then return Nb("Expected operand",Lc)end;Lc=Gc;Gc,Kc=wc(Fc,Gc)Fb("parse_rpn: mid lookahead is %1",Kc)while(Kc~=nil and Kc.prec<Ic.prec)do Gc,Jc=xc(Jc,Fc,Lc,Kc.prec)Fb("parse_rpn: inside rexpr is %1",Jc)Lc=Gc;Gc,Kc=wc(Fc,Gc)Fb("parse_rpn: inside lookahead is %1",Kc)end;Ic.lexpr=Ec;Ic.rexpr=Jc;Ec=Ic end;Fb("parse_rpn: returning index %1 lhs %2",Lc,Ec)return Lc,Ec end;Gb=function(Ec)local Fc=1;local Gc;Ec=Ec or""Ec=tostring(Ec)Fb("_comp: parse %1",Ec)Fc,Gc=Jb(Ec,Fc)Fc,Gc=xc(Gc,Ec,Fc,rb)return Gc end;local function yc(Ec,Fc,Gc,Hc)local Ic=ub.type(Ec)local Jc=true;if Gc~=nil then Jc=yc(Gc,Hc or Fc)end;if Jc then if ub.type(Fc)=="string"then Jc=(Ic==Fc)elseif ub.type(Fc)~="table"then error("invalid allow1")else Jc=false;for Kc,Lc in ipairs(Fc)do if Ic==Lc then Jc=true;break end end end end;return Jc end;local function zc(Ec,Fc)local Gc=ub.type(Ec)Fb("coerce: attempt (%1)%2 to %3",Gc,Ec,Fc)if Gc==Fc then return Ec end;if Fc=="boolean"then if Gc=="number"then return Ec~=0 elseif Gc=="string"then if sb.lower(Ec)=="true"or Ec=="yes"or Ec=="1"then return true elseif sb.lower(Ec)=="false"or Ec=="no"or Ec=="0"then return false else return#Ec~=0 end elseif Mb(Ec)then return false end elseif Fc=="string"then if Gc=="number"then return tostring(Ec)elseif Gc=="boolean"then return Ec and"true"or"false"elseif Mb(Ec)then return""end elseif Fc=="number"then if Gc=="boolean"then return Ec and 1 or 0 elseif Gc=="string"then local Hc=tonumber(Ec,10)if Hc~=nil then return Hc else Ob("Coersion from string to number failed ("..Ec..")")end end end;if Mb(Ec)then Ob("Can't coerce null to "..Fc)end;Ob("Can't coerce "..Gc.." to "..Fc)end;local function Ac(Ec)if Mb(Ec)then return false end;local Fc=tonumber(Ec,10)if Fc==nil then return false else return true,Fc end end;local function Bc(Ec,Fc)return( (Ec or{}).__options or{})[Fc]and true or false end;local function Cc(Ec)if#Ec==0 then return nil end;return table.remove(Ec)end;local function Dc(Ec,Fc)local Gc;local Hc=Cc(Ec)if Hc==nil then Ob("Missing expected operand")end;Fb("fetch() popped %1",Hc)if Lb(Hc,wb)then Fb("fetch: evaluating VREF %1 to its value",Hc.name)if(Hc.name or"")==""and Hc.index~=nil then Hc.name=Ib(Hc.index,Fc,Ec)Hc.index=nil end;if Db[Hc.name:lower()]~=nil then Fb("fetch: found reserved word %1 for VREF",Hc.name)Gc=Db[Hc.name:lower()]elseif(Fc.__lvars or{})[Hc.name]~=nil then Gc=Fc.__lvars[Hc.name]else Gc=Fc[Hc.name]end;if Gc==nil and(Fc.__functions or{}).__resolve~=nil then Fb("fetch: calling external resolver for %1",Hc.name)Gc=Fc.__functions.__resolve(Hc.name,Fc)end;if Gc==nil then Ob("Undefined variable: "..Hc.name,Hc.pos)end;if Hc.index~=nil then if ub.type(Gc)~="table"then Ob(Hc.name.." is not an array",Hc.pos)end;local Ic=Ib(Hc.index,Fc,Ec)Fb("fetch: applying subscript: %1[%2]",Hc.name,Ic)if Ic~=nil then Gc=Gc[Ic]if Gc==nil then if type(Ic)=="number"then if Bc(Fc,"subscriptmissnull")then Gc=Bb else Ob("Subscript "..Ic.." out of range for "..Hc.name,Hc.pos)end else Gc=Bb end end else Ob("Subscript evaluation failed",Hc.pos)end end;return Gc end;return Hc end;Ib=function(Ec,Fc,Gc)Hb(Ec,Fc,Gc)return Dc(Gc,Fc)end;Hb=function(Ec,Fc,Gc)if not Lb(Ec)then Fb("Invalid atom: %1",Ec)Ob("Invalid atom")end;Gc=Gc or{}local Hc=nil;local Ic=Ec;Fb("_run: next element is %1",Ic)if ub.type(Ic)=="number"or ub.type(Ic)=="string"then Fb("_run: direct value assignment for (%1)%2",ub.type(Ic),Ic)Hc=Ic elseif Lb(Ic,vb)then Fb("_run: handling const %1",Ic.value)Hc=Ic.value elseif Lb(Ic,zb)then Fb("_run: handling BINOP %1",Ic.op)local Jc;if Ic.op=='and'or Ic.op=='&&'or Ic.op=='or'or Ic.op=='||'then Jc=Ic.rexpr;Fb("_run: logical lookahead is %1",Jc)elseif Ic.op=='.'then Jc=Ic.rexpr;Fb("_run: subref lookahead is %1",Jc)else Jc=Ib(Ic.rexpr,Fc,Gc)end;local Kc;if Ic.op=='='then Kc=Ic.lexpr;Fb("_run: assignment lookahead is %1",Kc)if not Lb(Kc,wb)then Ob("Invalid assignment",Ic.pos)end else Kc=Ib(Ic.lexpr,Fc,Gc)end;Fb("_run: operands are %1, %2",Kc,Jc)if Ic.op=='.'then Fb("_run: descend to %1",Jc)if Mb(Kc)then if Bc(Fc,"nullderefnull")then Hc=Bb else Ob("Can't dereference through null",Ic.pos)end else if Lb(Kc)then Ob("Invalid type in reference")end;if not yc(Kc,"table")then Ob("Cannot subreference a "..ub.type(Kc),Ic.pos)end;if not Lb(Jc,wb)then Ob("Invalid subreference",Ic.pos)end;if(Jc.name or"")==""and Jc.index~=nil then Jc.name=Ib(Jc.index,Fc,Gc)Jc.index=nil end;Hc=Kc[Jc.name]if Jc.index~=nil then if Hc==nil then Ob("Can't index null",Jc.pos)end;local Lc=Ib(Jc.index,Fc,Gc)if Lc==nil then Ob("Subscript evaluation failed for "..Jc.name,Jc.pos)end;Hc=Hc[Lc]if Hc==nil then if Bc(Fc,"subscriptmissnull")then Hc=Bb else Ob("Subscript out of range: "..tostring(Jc.name).."["..Lc.."]",Jc.pos)end end end;if Hc==nil then Hc=Bb end end elseif Ic.op=='and'or Ic.op=='&&'then if Kc==nil or not zc(Kc,"boolean")then Fb("_run: shortcut and/&& op1 is false")Hc=Kc else Fb("_run: op1 for and/&& is true, evaluate op2=%1",Jc)Hc=Ib(Jc,Fc,Gc)end elseif Ic.op=='or'or Ic.op=='||'then if Kc==nil or not zc(Kc,"boolean")then Fb("_run: op1 for or/|| false, evaluate op2=%1",Jc)Hc=Ib(Jc,Fc,Gc)else Fb("_run: shortcut or/|| op1 is true")Hc=Kc end elseif Ic.op=='..'then Hc=zc(Kc,"string")..zc(Jc,"string")elseif Ic.op=='+'then local Lc=ub.type(Kc)=="number"or ub.type(Kc)=="boolean"or tonumber(Kc)~=nil;local Mc=ub.type(Jc)=="number"or ub.type(Jc)=="boolean"or tonumber(Jc)~=nil;if Lc and Mc then Hc=zc(Kc,"number")+zc(Jc,"number")else Hc=zc(Kc,"string")..zc(Jc,"string")end elseif Ic.op=='-'then Hc=zc(Kc,"number")-zc(Jc,"number")elseif Ic.op=='*'then Hc=zc(Kc,"number")*zc(Jc,"number")elseif Ic.op=='/'then Hc=zc(Kc,"number")/zc(Jc,"number")elseif Ic.op=='%'then Hc=zc(Kc,"number")%zc(Jc,"number")elseif Ic.op=='&'then if ub.type(Kc)~="number"or ub.type(Jc)~="number"then Hc=zc(Kc,"boolean")and zc(Jc,"boolean")else Hc=nc.band(zc(Kc,"number"),zc(Jc,"number"))end elseif Ic.op=='|'then if ub.type(Kc)~="number"or ub.type(Jc)~="number"then Hc=zc(Kc,"boolean")or zc(Jc,"boolean")else Hc=nc.bor(zc(Kc,"number"),zc(Jc,"number"))end elseif Ic.op=='^'then if ub.type(Kc)~="number"or ub.type(Jc)~="number"then Hc=zc(Kc,"boolean")~=zc(Jc,"boolean")else Hc=nc.bxor(zc(Kc,"number"),zc(Jc,"number"))end elseif Ic.op=='<'then if not yc(Kc,{"number","string"},Jc)then Ob("Invalid comparison ("..ub.type(Kc)..Ic.op..ub.type(Jc)..")",Ic.pos)end;Hc=Kc<Jc elseif Ic.op=='<='then if not yc(Kc,{"number","string"},Jc)then Ob("Invalid comparison ("..ub.type(Kc)..Ic.op..ub.type(Jc)..")",Ic.pos)end;Hc=Kc<=Jc elseif Ic.op=='>'then if not yc(Kc,{"number","string"},Jc)then Ob("Invalid comparison ("..ub.type(Kc)..Ic.op..ub.type(Jc)..")",Ic.pos)end;Hc=Kc>Jc elseif Ic.op=='>='then if not yc(Kc,{"number","string"},Jc)then Ob("Invalid comparison ("..ub.type(Kc)..Ic.op..ub.type(Jc)..")",Ic.pos)end;Hc=Kc>=Jc elseif Ic.op=='=='then if ub.type(Kc)=="boolean"or ub.type(Jc)=="boolean"then Hc=zc(Kc,"boolean")==zc(Jc,"boolean")elseif(ub.type(Kc)=="number"or ub.type(Jc)=="number")and Ac(Kc)and Ac(Jc)then Hc=zc(Kc,"number")==zc(Jc,"number")else Hc=zc(Kc,"string")==zc(Jc,"string")end elseif Ic.op=='<>'or Ic.op=='!='or Ic.op=='~='then if ub.type(Kc)=="boolean"or ub.type(Jc)=="boolean"then Hc=zc(Kc,"boolean")==zc(Jc,"boolean")elseif(ub.type(Kc)=="number"or ub.type(Jc)=="number")and Ac(Kc)and Ac(Jc)then Hc=zc(Kc,"number")~=zc(Jc,"number")else Hc=zc(Kc,"string")~=zc(Jc,"string")end elseif Ic.op=='='then Fb("_run: making assignment to %1",Kc)for Lc in pairs(Db)do if Lc==Kc.name:lower()then Ob("Can't assign to reserved word "..Lc,Ic.pos)end end;Fc.__lvars=Fc.__lvars or{}if Kc.index~=nil then if type(Fc.__lvars[Kc.name])~="table"then Ob("Target is not an array ("..Kc.name..")",Ic.pos)end;local Lc=Ib(Kc.index,Fc,Gc)Fb("_run: assignment to %1 with computed index %2",Kc.name,Lc)if Lc<1 or type(Lc)~="number"then Ob("Invalid index ("..tostring(Lc)..")",Ic.pos)end;Fc.__lvars[Kc.name][Lc]=Jc else Fc.__lvars[Kc.name]=Jc end;Hc=Jc else error("Bug: binop parsed but not implemented by evaluator, binop="..Ic.op,0)end elseif Lb(Ic,yb)then Fb("_run: handling unop, stack has %1",Gc)Hc=Ib(Ic.operand,Fc,Gc)if Hc==nil then Hc=Bb end;if Ic.op=='-'then Hc=-zc(Hc,"number")elseif Ic.op=='+'then elseif Ic.op=='!'then if ub.type(Hc)=="number"then Hc=nc.bnot(Hc)else Hc=not zc(Hc,"boolean")end elseif Ic.op=='#'then Fb("_run: # unop on %1",Hc)local Jc=ub.type(Hc)if Jc=="string"then Hc=#Hc elseif Jc=="table"then Hc=fc(Hc)elseif Mb(Hc)then Hc=0 else Hc=1 end else error("Bug: unop parsed but not implemented by evaluator, unop="..Ic.op,0)end elseif Lb(Ic,xb)then Fb("_run: Handling function %1 with %2 args passed",Ic.name,#Ic.args)if Ic.name=="if"then if#Ic.args<2 then Ob("if() requires two or three arguments",Ic.pos)end;local Jc=Ib(Ic.args[1],Fc,Gc)if Jc==nil or not zc(Jc,"boolean")then if#Ic.args>2 then Hc=Ib(Ic.args[3],Fc,Gc)else Hc=Bb end else Hc=Ib(Ic.args[2],Fc,Gc)end elseif Ic.name=="iterate"then if#Ic.args<2 then Ob("iterate() requires two or more arguments",Ic.pos)end;local Jc=Ib(Ic.args[1],Fc,Gc)Hc={}if Jc~=nil and not Mb(Jc)then if type(Jc)~="table"then Ob("iterate() argument 1 is not array",Ic.pos)end;local Kc='_'if#Ic.args>2 then Kc=Ib(Ic.args[3],Fc,Gc)end;local Lc=Lb(Ic.args[2],vb)and Gb(Ic.args[2].value,Fc)or Ic.args[2]Fc.__lvars=Fc.__lvars or{}for Mc,Nc in ipairs(Jc)do Fc.__lvars[Kc]=Nc;local Oc=Ib(Lc,Fc,Gc)if Oc~=nil and not Mb(Oc)then table.insert(Hc,Oc)end end end elseif Ic.name=="map"then if#Ic.args<1 then Ob("map() requires one or more arguments",Ic.pos)end;local Jc=Ib(Ic.args[1],Fc,Gc)Hc={}if Jc~=nil and not Mb(Jc)then if type(Jc)~="table"then Ob("map() argument 1 is not array",Ic.pos)end;local Kc='_'if#Ic.args>2 then Kc=Ib(Ic.args[3],Fc,Gc)end;local Lc;if#Ic.args>1 then Lc=Lb(Ic.args[2],vb)and Gb(Ic.args[2].value,Fc)or Ic.args[2]else Lc=Gb("__",Fc)end;Fc.__lvars=Fc.__lvars or{}for Mc,Nc in ipairs(Jc)do if not Mb(Nc)then Fc.__lvars[Kc]=Nc;Fc.__lvars['__']=Mc;local Oc=Ib(Lc,Fc,Gc)if Oc~=nil and not Mb(Oc)then Hc[tostring(Nc)]=Oc end end end end else local Jc,Kc;local Lc=#Ic.args;Kc={}for n=1,Lc do Hc=Ic.args[n]Fb("_run: evaluate function argument %1: %2",n,Hc)Jc=Ib(Hc,Fc,Gc)if Jc==nil then Jc=Bb end;Fb("_run: adding argument result %1",Jc)Kc[n]=Jc end;local Mc=nil;if lc[Ic.name]then Fb("_run: found native func %1",lc[Ic.name])Mc=lc[Ic.name].impl;if(Lc<lc[Ic.name].nargs)then Ob("Insufficient arguments to "..Ic.name.."(), need "..lc[Ic.name].nargs..", got "..Lc,Ic.pos)end end;if Mc==nil and Fc['__functions']then Mc=Fc['__functions'][Ic.name]Fb("_run: context __functions provides implementation")end;if Mc==nil then Fb("_run: context provides DEPRECATED-STYLE implementation")Mc=Fc[Ic.name]end;if Mc==nil then Ob("Unrecognized function: "..Ic.name,Ic.pos)end;if ub.type(Mc)~="function"then Ob("Reference is not a function: "..Ic.name,Ic.pos)end;local Nc;Fb("_run: calling %1 with args=%2",Ic.name,Kc)Kc.__context=Fc;Nc,Hc=pcall(Mc,Kc)Fb("_run: finished %1() call, status=%2, result=%3",Ic.name,Nc,Hc)if not Nc then if ub.type(Hc)=="table"and Hc.__source=="luaxp"then Hc.location=Ic.pos;error(Hc)end;error("Execution of function "..Ic.name.."() threw an error: "..tostring(Hc))end end elseif Lb(Ic,wb)then Fb("_run: handling vref, name=%1, push to stack for later eval",Ic.name)Hc=Kb(Ic)else error("Bug: invalid atom type in parse tree: "..tostring(Ic.__type),0)end;Fb("_run: pushing result to stack: %1",Hc)if Hc==0 then Hc=0 end;table.insert(Gc,Hc)Fb("_run: finished, stack has %1: %2",#Gc,Gc)return true end;function qb.compile(Ec)local Fc,Gc,Hc;Fc,Gc,Hc=pcall(Gb,Ec)if Fc then return{rpn=Gc,source=Ec}else return nil,Gc end end;function qb.run(Ec,Fc)Fc=Fc or{}if(Ec==nil or Ec.rpn==nil or ub.type(Ec.rpn)~="table")then return nil end;local Gc={}local Hc,Ic=pcall(Hb,Ec.rpn,Fc,Gc)if#Gc==0 or not Hc then return nil,Ic end;Hc,Ic=pcall(Dc,Gc,Fc)if not Hc then return nil,Ic end;return Ic end;function qb.evaluate(Ec,Fc)local Gc,Hc=qb.compile(Ec)if Gc==nil then return Gc,Hc end;return qb.run(Gc,Fc)end;qb.dump=Eb;qb.isNull=Mb;qb.coerce=zc;qb.NULL=Bb;qb.null=Bb;qb.evalerror=Ob;return qb.evaluate(z)end

Command.Print(tostring(Math(expr)))
    end
},
{
    Name = 'lua',
    Alias = {'luai', 'interactive', 'loadstring'},
    Description = 'Enters an interactive lua session.',
    Args = {
        {
            Name = 'Code',
            Type = 'string',
            Description = 'Code to execute.',
            Optional = true
        }
    },
    Run = function(str)
local function Lua(a)local a=a or{}local b=a.env;local c=a.exit;local d=a.args;local function e(f)if not c then return false end;for g=1,#c do if c[g]==string.lower(f)then return true end end;return false end;local function h(f)f=string.gsub(f,'\n(.*)stack traceback:.*','%1\nstack traceback:\n\tstdin:1: in main chunk\n\t[C]:?')return f end;local j="LUA_INIT"local k="lua"local l="> "local m=">> "local function n(o)return"'"..o.."'"end;local p="Lua 5.1.5"local q="Copyright (C) 1994-2008 Lua.org, PUC-Rio"local _G=_G;local assert=assert;local collectgarbage=collectgarbage;local loadfile=loadfile;local loadstring=loadstring;local pcall=pcall;local rawget=rawget;local select=select;local tostring=tostring;local type=type;local unpack=unpack;local xpcall=xpcall;local r=io.stderr;local s=io.stdout;local t=io.stdin;local u=string.format;local v=string.sub;local w=os.getenv;local x=os.exit;local y=k;local z=function()return true end;local A=function()end;local function B()Command.Output(u("usage: %s [options] [script [args]].\n".."Available options are:\n".."  -e stat  execute string "..n("stat").."\n".."  -l name  require library "..n("name").."\n".."  -i       enter interactive mode after executing "..n("script").."\n".."  -v       show version information\n".."  --       stop handling options\n".."  -        execute stdin and stop handling options\n",y))end;local function C(D,E)if D then Command.Output(u("%s: ",D))end;Command.Output(u("%s\n",E))end;local function F(G,E)if not G and E~=nil then E=(type(E)=='string'or type(E)=='number')and tostring(E)or"(error object is not a string)"C(y,h(E))end;return G end;local function H(...)return{n=select('#',...),...}end;local function I(J)local K=type(J)if K~="string"and K~="number"then return J end;local L=_G.debug;if type(L)~="table"then return J end;local M=L.traceback;if type(M)~="function"then return J end;return M(J,2)end;local function N(O,...)local K={...}local P=function()return O(unpack(K))end;A(true)local Q=H(xpcall(P,I))A(false)if not Q[1]then collectgarbage("collect")end;return unpack(Q,1,Q.n)end;local function R(S)local O,E=loadfile(S)if O then O,E=N(O)end;return F(O,E)end;local function T(U,S)local O,E=loadstring(U,S)if O then O,E=N(O)end;return F(O,E)end;local function V(S)return F(N(_G.require,S))end;local function W()C(nil,p.."  "..q)end;local function X(Y,Z)local _={}for g=1,#Y do _[g-Z]=Y[g]end;if _G.arg then local g=0;while _G.arg[g]do _[g-Z]=_G.arg[g]g=g-1 end end;return _ end;local a0={}local function a1(U)end;local function a2(a3)local a4=rawget(_G,a3 and"_PROMPT"or"_PROMPT2")local K=type(a4)if K=="string"or K=="number"then return tostring(a4)end;return a3 and l or m end;local function a5(E)if E then local a6=n("<eof>")if v(E,-#a6)==a6 then return true end end;return false end;local function a7(a3)local a8=a2(a3)Command.Output(a8)local a9=Command.Input()if e(a9)then return{}end;if not a9 then return end;if a3 and v(a9,1,1)=='='then return"return "..v(a9,2)else return a9 end end;local function aa()local a9=a7(true)if not a9 then return-1 end;local O,E;while true do if type(a9)=='table'or type(b2)=='table'then return{}end;O,E=loadstring(a9,"=stdin")if not a5(E)then break end;local b2=a7(false)if not b2 then return-1 end;a9=a9 .."\n"..b2 end;a1(a9)return O,E end;local function ab()local ac=y;y=nil;while true do local Q;local G,E=aa()if type(G)=='table'then break end;if G==-1 then break end;if G then Q=H(N(G))G,E=Q[1],Q[2]end;F(G,E)if G and Q.n>1 then G,E=pcall(Command.Print,unpack(Q,2,Q.n))if not G then C(y,u("error calling %s (%s)",n("print"),E))end end end;Command.Output("\n")y=ac end;local function ad(Y,Z)_G.arg=X(Y,Z)local ae=Y[Z]if ae=="-"and Y[Z-1]~="--"then ae=nil end;local G,E=loadfile(ae)if G then G,E=N(G,unpack(_G.arg))end;return F(G,E)end;local function af(Y,ag)local g=1;while g<=#Y do if v(Y[g],1,1)~='-'then return g end;local ah=v(Y[g],1,2)if ah=='--'then if#Y[g]>2 then return-1 end;return Y[g+1]and g+1 or 0 elseif ah=='-'then return g elseif ah=='-i'then if#Y[g]>2 then return-1 end;ag.i=true;ag.v=true elseif ah=='-v'then if#Y[g]>2 then return-1 end;ag.v=true elseif ah=='-e'then ag.e=true;if#Y[g]==2 then g=g+1;if Y[g]==nil then return-1 end end elseif ah=='-l'then if#Y[g]==2 then g=g+1;if Y[g]==nil then return-1 end end else return-1 end;g=g+1 end;return 0 end;local function ai(Y,Z)local g=1;while g<=Z do if Y[g]then assert(v(Y[g],1,1)=='-')local aj=v(Y[g],2,2)if aj=='e'then local ak=v(Y[g],3)if ak==''then g=g+1;ak=Y[g]end;assert(ak)if not T(ak,"=(command line)")then return false end elseif aj=='l'then local al=v(Y[g],3)if al==''then g=g+1;al=Y[g]end;assert(al)if not V(al)then return false end end;g=g+1 end end;return true end;local function am()local an=w(j)if an==nil then return elseif v(an,1,1)=='@'then R(v(an,2))else T(an,"="..j)end end;local ao=_G.import;if ao then z=ao.lua_stdin_is_tty or z;A=ao.setsignal or A;p=ao.LUA_RELEASE or p;q=ao.LUA_COPYRIGHT or q;_G.import=nil end;if _G.arg and _G.arg[0]and#_G.arg[0]>0 then y=_G.arg[0]end;local Y=d and{d}or{}am()local ap={i=false,v=false,e=false}local aq=af(Y,ap)if aq<0 then B()x(1)end;if ap.v then W()end;local G=ai(Y,aq>0 and aq-1 or#Y)if not G then x(1)end;if aq~=0 then G=ad(Y,aq)if not G then x(1)end else _G.arg=nil end;if ap.i then ab()elseif aq==0 and not ap.e and not ap.v then if z()then W()ab()else R(nil)end end end


if str then
    local f, err = loadstring(str)
    if f then
        local out = nil
        local sucess, err = pcall(function()
            out = f()
        end)
        if out then
            Command.Print(out)
        end
    else
        Command.Print(err)
    end
else
    Lua({exit = Exit})
end
end
}
}