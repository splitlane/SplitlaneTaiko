--[[
    https://github.com/sd-/luajit/blob/master/extlib/ffi/curses.lua
    https://gnuwin32.sourceforge.net/packages/pdcurses.htm

    https://sourceforge.net/projects/pdcurses/files/pdcurses/3.4/

    https://pdcurses.org/docs/MANUAL.html
--]]

local ffi = require( "ffi" )
local dll = ffi.load( 'pdcurses' )
local shl = bit.lshift

ffi.cdef[[
      typedef void* WINDOW;
      typedef unsigned chtype;
      int endwin();
      int beep();
      int echo(); int noecho();
      int nl();   int nonl();
      int raw();  int noraw();
      int cbreak(); int nocbreak();

      int COLS;   int LINES;
      WINDOW* initscr();
      WINDOW* stdscr;
      int waddch(WINDOW*,const chtype ch);
      int wgetch(WINDOW*);
      int wmove(WINDOW*,int,int);
      int wclear(WINDOW*);
      int wrefresh(WINDOW*);
      int wattrset(WINDOW*,int);
      int wclrtoeol(WINDOW*);
      int meta(WINDOW*w,bool);
      int intrflush(WINDOW*w,bool);
      int keypad(WINDOW*w,bool);
      void wtimeout(WINDOW*w,int);

      int nodelay(WINDOW*w, bool);
      
      // int mouse_on(); int mouse_off();
      // int mouse_set(int);
      // int PDC_return_key_modifers(bool);

]]
--int PDC_get_key_modifiers();

curses = {

    --stdscr
    move      = function(self,y,x) return dll.wmove(     self.window, y, x ) end,
    keypad    = function(self,a)   return dll.keypad(    self.window, a    ) end,
 
    nodelay = function(self,a) return dll.nodelay(self.window, a) end,
 
    meta      = function(self,a)   return dll.meta(      self.window, a    ) end,
    intrflush = function(self,a)   return dll.intrflush( self.window, a    ) end,
    addch     = function(self,c)   return dll.waddch(    self.window, c    ) end,
    getch     = function(self)     return dll.wgetch(    self.window       ) end,
    clear     = function(self)     return dll.wclear(    self.window       ) end,
    refresh   = function(self)     return dll.wrefresh(  self.window       ) end,
    attrset   = function(self,a)   return dll.wattrset(  self.window, a    ) end,
    clrtoeol  = function(self)     return dll.wclrtoeol( self.window       ) end,
    timeout   = function(self,a)          dll.wtimeout(  self.window, a    ) end,






    --curses

   beep         = dll.beep,
   endwin       = dll.endwin,
   --initscr      = function() stdscr.window = dll.initscr() end,
   initscr      = function() return dll.initscr() end,
   stdscr       = function() return stdscr end,
   cols         = function() return dll.COLS end,
   lines        = function() return dll.LINES - 10 end,
   echo         = function(on) if on then dll.echo() else dll.noecho() end end,
   nl           = function(on) if on then dll.nl()   else dll.nonl()   end end,
   raw          = function(on) if on then dll.raw()  else dll.noraw()  end end,
   
   cbreak = function(on) if on then dll.cbreak() else dll.nocbreak() end end,
   --mouse = function(on) if on then dll.mouse_on() else dll.mouse_off() end end,
   --mouse_set = function(set) dll.mouse_set(set) end,
   --PDC_return_key_modifers = function(bool) dll.PDC_return_key_modifers(bool) end,

   ERR = -(1),
   OK = 0,
   _SUBWIN = 0x01,
   _ENDLINE = 0x02,
   _FULLWIN = 0x04,
   _SCROLLWIN = 0x08,
   _ISPAD = 0x10,
   _HASMOVED = 0x20,
   _WRAPPED = 0x40,
   _NOCHANGE = -(1),
   _NEWINDEX = -(1),

   COLOR_BLACK = 0,
   COLOR_RED = 1,
   COLOR_GREEN = 2,
   COLOR_YELLOW = 3,
   COLOR_BLUE = 4,
   COLOR_MAGENTA = 5,
   COLOR_CYAN = 6,
   COLOR_WHITE = 7,

   A_NORMAL     = 0,
   A_ATTRIBUTES = 0xFFFFFF00,
   A_CHARTEXT   = shl( 1,  0 + 8) - 1,
   A_COLOR      = shl( shl( 1,  8 ) - 1, 8 ),
   A_STANDOUT   = shl( 1,  8 + 8 ),
   A_UNDERLINE  = shl( 1,  9 + 8 ),
   A_REVERSE    = shl( 1, 10 + 8 ),
   A_BLINK      = shl( 1, 11 + 8 ),
   A_DIM        = shl( 1, 12 + 8 ),
   A_BOLD       = shl( 1, 13 + 8 ),
   A_ALTCHARSET = shl( 1, 14 + 8 ),
   A_INVIS      = shl( 1, 15 + 8 ),
   A_PROTECT    = shl( 1, 16 + 8 ),
   A_HORIZONTAL = shl( 1, 17 + 8 ),
   A_LEFT       = shl( 1, 18 + 8 ),
   A_LOW        = shl( 1, 19 + 8 ),
   A_RIGHT      = shl( 1, 20 + 8 ),
   A_TOP        = shl( 1, 21 + 8 ),
   A_VERTICAL   = shl( 1, 22 + 8 ),

--[[
   KEY_CODE_YES = 256,
   KEY_MIN = 257,     
   KEY_BREAK = 257,   
   KEY_DOWN = 258,    
   KEY_UP = 259,      
   KEY_LEFT = 260,    
   KEY_RIGHT = 261,   
   KEY_HOME = 262,    
   KEY_BACKSPACE = 263,
   KEY_F0 = 264,      
   KEY_F1 = 265,
   KEY_F2 = 266,
   KEY_F3 = 267,
   KEY_F4 = 268,
   KEY_F5 = 269,
   KEY_F6 = 270,
   KEY_F7 = 271,
   KEY_F8 = 272,
   KEY_F9 = 273,
   KEY_F10 = 274,
   KEY_F11 = 275,
   KEY_F12 = 276,
   KEY_DL = 328,        
   KEY_IL = 329,        
   KEY_DC = 330,        
   KEY_IC = 331,            
   KEY_EIC = 332,           
   KEY_CLEAR = 333,         
   KEY_EOS = 334,           
   KEY_EOL = 335,           
   KEY_SF = 336,            
   KEY_SR = 337,            
   KEY_NPAGE = 338,         
   KEY_PPAGE = 339,         
   KEY_STAB = 340,          
   KEY_CTAB = 341,          
   KEY_CATAB = 342,         
   KEY_ENTER = 343,         
   KEY_SRESET = 344,        
   KEY_RESET = 345,         
   KEY_PRINT = 346,         
   KEY_LL = 347,            
   KEY_A1 = 348,            
   KEY_A3 = 349,            
   KEY_B2 = 350,            
   KEY_C1 = 351,            
   KEY_C3 = 352,            
   KEY_BTAB = 353,          
   KEY_BEG = 354,           
   KEY_CANCEL = 355,        
   KEY_CLOSE = 356,         
   KEY_COMMAND = 357,       
   KEY_COPY = 358,          
   KEY_CREATE = 359,        
   KEY_END = 360,           
   KEY_EXIT = 361,          
   KEY_FIND = 362,          
   KEY_HELP = 363,          
   KEY_MARK = 364,          
   KEY_MESSAGE = 365,       
   KEY_MOVE = 366,          
   KEY_NEXT = 367,          
   KEY_OPEN = 368,          
   KEY_OPTIONS = 369,       
   KEY_PREVIOUS = 370,      
   KEY_REDO = 371,          
   KEY_REFERENCE = 372,     
   KEY_REFRESH = 373,       
   KEY_REPLACE = 374,       
   KEY_RESTART = 375,       
   KEY_RESUME = 376,        
   KEY_SAVE = 377,          
   KEY_SBEG = 378,          
   KEY_SCANCEL = 379,       
   KEY_SCOMMAND = 380,      
   KEY_SCOPY = 381,         
   KEY_SCREATE = 382,       
   KEY_SDC = 383,           
   KEY_SDL = 384,           
   KEY_SELECT = 385,        
   KEY_SEND = 386,          
   KEY_SEOL = 387,          
   KEY_SEXIT = 388,         
   KEY_SFIND = 389,         
   KEY_SHELP = 390,         
   KEY_SHOME = 391,         
   KEY_SIC = 392,           
   KEY_SLEFT = 393,         
   KEY_SMESSAGE = 394,      
   KEY_SMOVE = 395,         
   KEY_SNEXT = 396,         
   KEY_SOPTIONS = 397,      
   KEY_SPREVIOUS = 398,     
   KEY_SPRINT = 399,        
   KEY_SREDO = 400,         
   KEY_SREPLACE = 401,      
   KEY_SRIGHT = 402,        
   KEY_SRSUME = 403,        
   KEY_SSAVE = 404,         
   KEY_SSUSPEND = 405,      
   KEY_SUNDO = 406,         
   KEY_SUSPEND = 407,       
   KEY_UNDO = 408,          
   KEY_MOUSE = 409,         
   KEY_RESIZE = 410,        
   KEY_MAX = 511,    
--]]       
}

--[[
curses.keyname = {}

for k, v in pairs(curses) do
    if string.sub(k, 1, 3) == 'KEY' then
        curses.keyname[v] = k
    end
end
--]]

curses.keyid = {
    KEY_CODE_YES = 0x100,  -- If get_wch() gives a key code 
    
    KEY_BREAK = 0x101,  -- Not on PC KBD 
    KEY_DOWN = 0x102,  -- Down arrow key 
    KEY_UP = 0x103,  -- Up arrow key 
    KEY_LEFT = 0x104,  -- Left arrow key 
    KEY_RIGHT = 0x105,  -- Right arrow key 
    KEY_HOME = 0x106,  -- home key 
    KEY_BACKSPACE = 0x107,  -- not on pc 
    KEY_F0 = 0x108,  -- function keys; 64 reserved 
    
    KEY_DL = 0x148,  -- delete line 
    KEY_IL = 0x149,  -- insert line 
    KEY_DC = 0x14a,  -- delete character 
    KEY_IC = 0x14b,  -- insert char or enter ins mode 
    KEY_EIC = 0x14c,  -- exit insert char mode 
    KEY_CLEAR = 0x14d,  -- clear screen 
    KEY_EOS = 0x14e,  -- clear to end of screen 
    KEY_EOL = 0x14f,  -- clear to end of line 
    KEY_SF = 0x150,  -- scroll 1 line forward 
    KEY_SR = 0x151,  -- scroll 1 line back (reverse) 
    KEY_NPAGE = 0x152,  -- next page 
    KEY_PPAGE = 0x153,  -- previous page 
    KEY_STAB = 0x154,  -- set tab 
    KEY_CTAB = 0x155,  -- clear tab 
    KEY_CATAB = 0x156,  -- clear all tabs 
    KEY_ENTER = 0x157,  -- enter or send (unreliable) 
    KEY_SRESET = 0x158,  -- soft/reset (partial/unreliable) 
    KEY_RESET = 0x159,  -- reset/hard reset (unreliable) 
    KEY_PRINT = 0x15a,  -- print/copy 
    KEY_LL = 0x15b,  -- home down/bottom (lower left) 
    KEY_ABORT = 0x15c,  -- abort/terminate key (any) 
    KEY_SHELP = 0x15d,  -- short help 
    KEY_LHELP = 0x15e,  -- long help 
    KEY_BTAB = 0x15f,  -- Back tab key 
    KEY_BEG = 0x160,  -- beg(inning) key 
    KEY_CANCEL = 0x161,  -- cancel key 
    KEY_CLOSE = 0x162,  -- close key 
    KEY_COMMAND = 0x163,  -- cmd (command) key 
    KEY_COPY = 0x164,  -- copy key 
    KEY_CREATE = 0x165,  -- create key 
    KEY_END = 0x166,  -- end key 
    KEY_EXIT = 0x167,  -- exit key 
    KEY_FIND = 0x168,  -- find key 
    KEY_HELP = 0x169,  -- help key 
    KEY_MARK = 0x16a,  -- mark key 
    KEY_MESSAGE = 0x16b,  -- message key 
    KEY_MOVE = 0x16c,  -- move key 
    KEY_NEXT = 0x16d,  -- next object key 
    KEY_OPEN = 0x16e,  -- open key 
    KEY_OPTIONS = 0x16f,  -- options key 
    KEY_PREVIOUS = 0x170,  -- previous object key 
    KEY_REDO = 0x171,  -- redo key 
    KEY_REFERENCE = 0x172,  -- ref(erence) key 
    KEY_REFRESH = 0x173,  -- refresh key 
    KEY_REPLACE = 0x174,  -- replace key 
    KEY_RESTART = 0x175,  -- restart key 
    KEY_RESUME = 0x176,  -- resume key 
    KEY_SAVE = 0x177,  -- save key 
    KEY_SBEG = 0x178,  -- shifted beginning key 
    KEY_SCANCEL = 0x179,  -- shifted cancel key 
    KEY_SCOMMAND = 0x17a,  -- shifted command key 
    KEY_SCOPY = 0x17b,  -- shifted copy key 
    KEY_SCREATE = 0x17c,  -- shifted create key 
    KEY_SDC = 0x17d,  -- shifted delete char key 
    KEY_SDL = 0x17e,  -- shifted delete line key 
    KEY_SELECT = 0x17f,  -- select key 
    KEY_SEND = 0x180,  -- shifted end key 
    KEY_SEOL = 0x181,  -- shifted clear line key 
    KEY_SEXIT = 0x182,  -- shifted exit key 
    KEY_SFIND = 0x183,  -- shifted find key 
    KEY_SHOME = 0x184,  -- shifted home key 
    KEY_SIC = 0x185,  -- shifted input key 
    
    KEY_SLEFT = 0x187,  -- shifted left arrow key 
    KEY_SMESSAGE = 0x188,  -- shifted message key 
    KEY_SMOVE = 0x189,  -- shifted move key 
    KEY_SNEXT = 0x18a,  -- shifted next key 
    KEY_SOPTIONS = 0x18b,  -- shifted options key 
    KEY_SPREVIOUS = 0x18c,  -- shifted prev key 
    KEY_SPRINT = 0x18d,  -- shifted print key 
    KEY_SREDO = 0x18e,  -- shifted redo key 
    KEY_SREPLACE = 0x18f,  -- shifted replace key 
    KEY_SRIGHT = 0x190,  -- shifted right arrow 
    KEY_SRSUME = 0x191,  -- shifted resume key 
    KEY_SSAVE = 0x192,  -- shifted save key 
    KEY_SSUSPEND = 0x193,  -- shifted suspend key 
    KEY_SUNDO = 0x194,  -- shifted undo key 
    KEY_SUSPEND = 0x195,  -- suspend key 
    KEY_UNDO = 0x196,  -- undo key 
    
    -- PDCurses-specific key definitions -- PC only 
    
    ALT_0 = 0x197,
    ALT_1 = 0x198,
    ALT_2 = 0x199,
    ALT_3 = 0x19a,
    ALT_4 = 0x19b,
    ALT_5 = 0x19c,
    ALT_6 = 0x19d,
    ALT_7 = 0x19e,
    ALT_8 = 0x19f,
    ALT_9 = 0x1a0,
    ALT_A = 0x1a1,
    ALT_B = 0x1a2,
    ALT_C = 0x1a3,
    ALT_D = 0x1a4,
    ALT_E = 0x1a5,
    ALT_F = 0x1a6,
    ALT_G = 0x1a7,
    ALT_H = 0x1a8,
    ALT_I = 0x1a9,
    ALT_J = 0x1aa,
    ALT_K = 0x1ab,
    ALT_L = 0x1ac,
    ALT_M = 0x1ad,
    ALT_N = 0x1ae,
    ALT_O = 0x1af,
    ALT_P = 0x1b0,
    ALT_Q = 0x1b1,
    ALT_R = 0x1b2,
    ALT_S = 0x1b3,
    ALT_T = 0x1b4,
    ALT_U = 0x1b5,
    ALT_V = 0x1b6,
    ALT_W = 0x1b7,
    ALT_X = 0x1b8,
    ALT_Y = 0x1b9,
    ALT_Z = 0x1ba,
    
    CTL_LEFT = 0x1bb,  -- Control-Left-Arrow 
    CTL_RIGHT = 0x1bc,
    CTL_PGUP = 0x1bd,
    CTL_PGDN = 0x1be,
    CTL_HOME = 0x1bf,
    CTL_END = 0x1c0,
    
    KEY_A1 = 0x1c1,  -- upper left on Virtual keypad 
    KEY_A2 = 0x1c2,  -- upper middle on Virt. keypad 
    KEY_A3 = 0x1c3,  -- upper right on Vir. keypad 
    KEY_B1 = 0x1c4,  -- middle left on Virt. keypad 
    KEY_B2 = 0x1c5,  -- center on Virt. keypad 
    KEY_B3 = 0x1c6,  -- middle right on Vir. keypad 
    KEY_C1 = 0x1c7,  -- lower left on Virt. keypad 
    KEY_C2 = 0x1c8,  -- lower middle on Virt. keypad 
    KEY_C3 = 0x1c9,  -- lower right on Vir. keypad 
    
    PADSLASH = 0x1ca,  -- slash on keypad 
    PADENTER = 0x1cb,  -- enter on keypad 
    CTL_PADENTER = 0x1cc,  -- ctl-enter on keypad 
    ALT_PADENTER = 0x1cd,  -- alt-enter on keypad 
    PADSTOP = 0x1ce,  -- stop on keypad 
    PADSTAR = 0x1cf,  -- star on keypad 
    PADMINUS = 0x1d0,  -- minus on keypad 
    PADPLUS = 0x1d1,  -- plus on keypad 
    CTL_PADSTOP = 0x1d2,  -- ctl-stop on keypad 
    CTL_PADCENTER = 0x1d3,  -- ctl-enter on keypad 
    CTL_PADPLUS = 0x1d4,  -- ctl-plus on keypad 
    CTL_PADMINUS = 0x1d5,  -- ctl-minus on keypad 
    CTL_PADSLASH = 0x1d6,  -- ctl-slash on keypad 
    CTL_PADSTAR = 0x1d7,  -- ctl-star on keypad 
    ALT_PADPLUS = 0x1d8,  -- alt-plus on keypad 
    ALT_PADMINUS = 0x1d9,  -- alt-minus on keypad 
    ALT_PADSLASH = 0x1da,  -- alt-slash on keypad 
    ALT_PADSTAR = 0x1db,  -- alt-star on keypad 
    ALT_PADSTOP = 0x1dc,  -- alt-stop on keypad 
    CTL_INS = 0x1dd,  -- ctl-insert 
    ALT_DEL = 0x1de,  -- alt-delete 
    ALT_INS = 0x1df,  -- alt-insert 
    CTL_UP = 0x1e0,  -- ctl-up arrow 
    CTL_DOWN = 0x1e1,  -- ctl-down arrow 
    CTL_TAB = 0x1e2,  -- ctl-tab 
    ALT_TAB = 0x1e3,
    ALT_MINUS = 0x1e4,
    ALT_EQUAL = 0x1e5,
    ALT_HOME = 0x1e6,
    ALT_PGUP = 0x1e7,
    ALT_PGDN = 0x1e8,
    ALT_END = 0x1e9,
    ALT_UP = 0x1ea,  -- alt-up arrow 
    ALT_DOWN = 0x1eb,  -- alt-down arrow 
    ALT_RIGHT = 0x1ec,  -- alt-right arrow 
    ALT_LEFT = 0x1ed,  -- alt-left arrow 
    ALT_ENTER = 0x1ee,  -- alt-enter 
    ALT_ESC = 0x1ef,  -- alt-escape 
    ALT_BQUOTE = 0x1f0,  -- alt-back quote 
    ALT_LBRACKET = 0x1f1,  -- alt-left bracket 
    ALT_RBRACKET = 0x1f2,  -- alt-right bracket 
    ALT_SEMICOLON = 0x1f3,  -- alt-semi-colon 
    ALT_FQUOTE = 0x1f4,  -- alt-forward quote 
    ALT_COMMA = 0x1f5,  -- alt-comma 
    ALT_STOP = 0x1f6,  -- alt-stop 
    ALT_FSLASH = 0x1f7,  -- alt-forward slash 
    ALT_BKSP = 0x1f8,  -- alt-backspace 
    CTL_BKSP = 0x1f9,  -- ctl-backspace 
    PAD0 = 0x1fa,  -- keypad 0 
    
    CTL_PAD0 = 0x1fb,  -- ctl-keypad 0 
    CTL_PAD1 = 0x1fc,
    CTL_PAD2 = 0x1fd,
    CTL_PAD3 = 0x1fe,
    CTL_PAD4 = 0x1ff,
    CTL_PAD5 = 0x200,
    CTL_PAD6 = 0x201,
    CTL_PAD7 = 0x202,
    CTL_PAD8 = 0x203,
    CTL_PAD9 = 0x204,
    
    ALT_PAD0 = 0x205,  -- alt-keypad 0 
    ALT_PAD1 = 0x206,
    ALT_PAD2 = 0x207,
    ALT_PAD3 = 0x208,
    ALT_PAD4 = 0x209,
    ALT_PAD5 = 0x20a,
    ALT_PAD6 = 0x20b,
    ALT_PAD7 = 0x20c,
    ALT_PAD8 = 0x20d,
    ALT_PAD9 = 0x20e,
    
    CTL_DEL = 0x20f,  -- clt-delete 
    ALT_BSLASH = 0x210,  -- alt-back slash 
    CTL_ENTER = 0x211,  -- ctl-enter 
    
    SHF_PADENTER = 0x212,  -- shift-enter on keypad 
    SHF_PADSLASH = 0x213,  -- shift-slash on keypad 
    SHF_PADSTAR = 0x214,  -- shift-star  on keypad 
    SHF_PADPLUS = 0x215,  -- shift-plus  on keypad 
    SHF_PADMINUS = 0x216,  -- shift-minus on keypad 
    SHF_UP = 0x217,  -- shift-up on keypad 
    SHF_DOWN = 0x218,  -- shift-down on keypad 
    SHF_IC = 0x219,  -- shift-insert on keypad 
    SHF_DC = 0x21a,  -- shift-delete on keypad 
    
    KEY_MOUSE = 0x21b,  -- "mouse" key 
    KEY_SHIFT_L = 0x21c,  -- Left-shift 
    KEY_SHIFT_R = 0x21d,  -- Right-shift 
    KEY_CONTROL_L = 0x21e,  -- Left-control 
    KEY_CONTROL_R = 0x21f,  -- Right-control 
    KEY_ALT_L = 0x220,  -- Left-alt 
    KEY_ALT_R = 0x221,  -- Right-alt 
    KEY_RESIZE = 0x222,  -- Window resize 
    KEY_SUP = 0x223,  -- Shifted up arrow 
    KEY_SDOWN = 0x224,  -- Shifted down arrow 
    
    --[[
    KEY_MIN = KEY_BREAK,      -- Minimum curses key value 
    KEY_MAX = KEY_SDOWN,      -- Maximum curses key 
    --]]

    KEY_MIN = 0x101,      -- Minimum curses key value 
    KEY_MAX = 0x224,      -- Maximum curses key 
    































    --extra 11/22/2022

    KEY_CODE_YES = 256,
    KEY_MIN = 257,     
    KEY_BREAK = 257,   
    KEY_DOWN = 258,    
    KEY_UP = 259,      
    KEY_LEFT = 260,    
    KEY_RIGHT = 261,   
    KEY_HOME = 262,    
    KEY_BACKSPACE = 263,
    KEY_F0 = 264,      
    KEY_F1 = 265,
    KEY_F2 = 266,
    KEY_F3 = 267,
    KEY_F4 = 268,
    KEY_F5 = 269,
    KEY_F6 = 270,
    KEY_F7 = 271,
    KEY_F8 = 272,
    KEY_F9 = 273,
    KEY_F10 = 274,
    KEY_F11 = 275,
    KEY_F12 = 276,
    KEY_DL = 328,        
    KEY_IL = 329,        
    KEY_DC = 330,        
    KEY_IC = 331,            
    KEY_EIC = 332,           
    KEY_CLEAR = 333,         
    KEY_EOS = 334,           
    KEY_EOL = 335,           
    KEY_SF = 336,            
    KEY_SR = 337,            
    KEY_NPAGE = 338,         
    KEY_PPAGE = 339,         
    KEY_STAB = 340,          
    KEY_CTAB = 341,          
    KEY_CATAB = 342,         
    KEY_ENTER = 343,         
    KEY_SRESET = 344,        
    KEY_RESET = 345,         
    KEY_PRINT = 346,         
    KEY_LL = 347,            
    KEY_A1 = 348,            
    KEY_A3 = 349,            
    KEY_B2 = 350,            
    KEY_C1 = 351,            
    KEY_C3 = 352,            
    KEY_BTAB = 353,          
    KEY_BEG = 354,           
    KEY_CANCEL = 355,        
    KEY_CLOSE = 356,         
    KEY_COMMAND = 357,       
    KEY_COPY = 358,          
    KEY_CREATE = 359,        
    KEY_END = 360,           
    KEY_EXIT = 361,          
    KEY_FIND = 362,          
    KEY_HELP = 363,          
    KEY_MARK = 364,          
    KEY_MESSAGE = 365,       
    KEY_MOVE = 366,          
    KEY_NEXT = 367,          
    KEY_OPEN = 368,          
    KEY_OPTIONS = 369,       
    KEY_PREVIOUS = 370,      
    KEY_REDO = 371,          
    KEY_REFERENCE = 372,     
    KEY_REFRESH = 373,       
    KEY_REPLACE = 374,       
    KEY_RESTART = 375,       
    KEY_RESUME = 376,        
    KEY_SAVE = 377,          
    KEY_SBEG = 378,          
    KEY_SCANCEL = 379,       
    KEY_SCOMMAND = 380,      
    KEY_SCOPY = 381,         
    KEY_SCREATE = 382,       
    KEY_SDC = 383,           
    KEY_SDL = 384,           
    KEY_SELECT = 385,        
    KEY_SEND = 386,          
    KEY_SEOL = 387,          
    KEY_SEXIT = 388,         
    KEY_SFIND = 389,         
    KEY_SHELP = 390,         
    KEY_SHOME = 391,         
    KEY_SIC = 392,           
    KEY_SLEFT = 393,         
    KEY_SMESSAGE = 394,      
    KEY_SMOVE = 395,         
    KEY_SNEXT = 396,         
    KEY_SOPTIONS = 397,      
    KEY_SPREVIOUS = 398,     
    KEY_SPRINT = 399,        
    KEY_SREDO = 400,         
    KEY_SREPLACE = 401,      
    KEY_SRIGHT = 402,        
    KEY_SRSUME = 403,        
    KEY_SSAVE = 404,         
    KEY_SSUSPEND = 405,      
    KEY_SUNDO = 406,         
    KEY_SUSPEND = 407,       
    KEY_UNDO = 408,          
    KEY_MOUSE = 409,         
    KEY_RESIZE = 410,        
    KEY_MAX = 511,  
}

curses.keyname = {}
for k, v in pairs(curses.keyid) do
    curses.keyname[v] = k
end








--extra 11/13/2022
--[[
    unicode support
    just init curses
    https://invisible-island.net/ncurses/man/ncurses.3x.html#h3-Initialization
]]

--extra 10/3/2022

function curses.getkeyname(code)
    --without keyname
    --[[
    local n = tonumber(code)
    return n and ((n >= 0 and n <= 255) and string.char(n) or tostring(code)) or code
    --]]

    --with keyname
    -- [[
    local n = tonumber(code)
    return curses.keyname[code] or (n and ((n >= 0 and n <= 255) and string.char(n) or code)) or code
    --With keyname + valid char only
    --breaks
    --]]
end









return curses