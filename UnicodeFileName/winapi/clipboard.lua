--https://lua-l.lua.narkive.com/A3VQMEw6/luajit-ffi-snippet-to-print-the-clipboard-on-windows

-- pbpaste (Mac OS X) program for Windows
-- to run: luajit winclip.lua
-- it should print the clipboard (textual content)
local ffi = require( "ffi" )
local user32, kernel32 = ffi.load( "USER32" ), ffi.load( "KERNEL32" )

local windows = ffi.load("window")

ffi.cdef[[
enum { CF_TEXT = 1 };
int OpenClipboard(void*);
void* GetClipboardData(unsigned);
int CloseClipboard();
void* GlobalLock(void*);
int GlobalUnlock(void*);
size_t GlobalSize(void*);
]]

local ok1 = user32.OpenClipboard(nil)
local handle = user32.GetClipboardData( user32.CF_TEXT )
local size = kernel32.GlobalSize( handle )
local mem = kernel32.GlobalLock( handle )
local text = ffi.string( mem, size )
local ok2 = kernel32.GlobalUnlock( handle )
local ok3 = user32.CloseClipboard()

print(text)