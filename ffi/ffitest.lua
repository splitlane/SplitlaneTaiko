local ffi = require("ffi")
ffi.cdef[[
    int test (void* getch)
]]
ffi.C.test()