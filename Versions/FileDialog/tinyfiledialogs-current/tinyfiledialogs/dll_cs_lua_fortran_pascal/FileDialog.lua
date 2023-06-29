--[[
    FileDialog.lua

    Wrapper for tinyfiledialogs
]]

local ffi = require('ffi')


--[[
    Use tinyfiledialogs64 for raylib
    Use tinyfiledialogs32 for luajit
]]
local FileDialogC = ffi.load('tinyfiledialogs64')

--https://stackoverflow.com/questions/53805913/how-to-define-c-functions-with-luajit
--REMEMBER TO DEFINE NEEDED FUNCTIONS (tinyfiledialogs.h)
ffi.cdef[[
char * tinyfd_openFileDialog(
	char const * aTitle, /* NULL or "" */
	char const * aDefaultPathAndFile, /* NULL or "" */
	int aNumOfFilterPatterns , /* 0 (2 in the following example) */
	char const * const * aFilterPatterns, /* NULL or char const * lFilterPatterns[2]={"*.png","*.jpg"}; */
	char const * aSingleFilterDescription, /* NULL or "image files" */
	int aAllowMultipleSelects ) ; /* 0 or 1 */
		/* in case of multiple files, the separator is | */
		/* returns NULL on cancel */

char * tinyfd_selectFolderDialog(
    char const * aTitle, /* NULL or "" */
    char const * aDefaultPath); /* NULL or "" */
        /* returns NULL on cancel */

char const * tinyfd_saveFileDialog(
    char const * aTitle , // NULL or ""
    char const * aDefaultPathAndFile , // NULL or ""
    int aNumOfFilterPatterns , // 0 (1 in the following example)
    char const * const * aFilterPatterns , // NULL or char const * lFilterPatterns[1]={"*.txt"};
    char const * aSingleFilterDescription ); // NULL or "text files"
        // returns NULL on cancel
]]








FileDialog = {}




function FileDialog.Open(title, defaultpath, filter, filterdescription, allowmultipleselects)
    --Defaults
    title = title or ''
    defaultpath = defaultpath or ''
    local filterlength = filter and #filter or 0
    local filterpattern = nil
    if filter then
        -- [[
        filterpattern = ffi.new('const char * [?]', filterlength)
        for i = 1, #filter do
            filterpattern[i - 1] = ffi.new('char [?]', #filter[i] + 1, filter[i])
        end
        --]]
    end
    local multipleselects = allowmultipleselects and 1 or 0

    local out = FileDialogC.tinyfd_openFileDialog(title, defaultpath, filterlength, filterpattern, filterdescription, multipleselects)
    if out == nil then
        --Cancel

        return nil
    else
        --Return

        return ffi.string(out)
    end
end


function FileDialog.OpenFolder(title, defaultpath)
    --Defaults
    title = title or ''
    defaultpath = defaultpath or ''

    
    local out = FileDialogC.tinyfd_selectFolderDialog(title, defaultpath)
    if out == nil then
        --Cancel

        return nil
    else
        --Return

        return ffi.string(out)
    end
end


function FileDialog.Save(title, defaultpath, filter, filterdescription)
    --Defaults
    title = title or ''
    defaultpath = defaultpath or ''
    local filterlength = filter and #filter or 0
    local filterpattern = nil
    if filter then
        -- [[
        filterpattern = ffi.new('const char * [?]', filterlength)
        for i = 1, #filter do
            filterpattern[i - 1] = ffi.new('char [?]', #filter[i] + 1, filter[i])
        end
        --]]
    end

    local out = FileDialogC.tinyfd_saveFileDialog(title, defaultpath, filterlength, filterpattern, filterdescription)
    if out == nil then
        --Cancel

        return nil
    else
        --Return

        return ffi.string(out)
    end
end







--Full handling
function FileDialog.LoadFile(...)
    local out = FileDialog.Open(...)
    if out then
        local f = io.open(out, 'rb')
        local str = f:read('*all')
        f:close()
        return str
    else
        return nil
    end
end

function FileDialog.SaveFile(...)
    local out = FileDialog.Save(...)
    if out then
        local f = io.open(out, 'wb+')
        f:write()
        f:close()
        return true
    else
        return nil
    end
end





print(FileDialog.LoadFile(nil, nil, {'*.txt', '*.lua'}, 'aaa'))
