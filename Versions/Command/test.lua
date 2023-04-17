#!..\raylua_s.exe 



rl.SetTargetFPS(60) --will be set to settings later
rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE)
--https://github.com/raysan5/raylib/wiki/Frequently-Asked-Questions#how-do-i-remove-the-log
--rl.SetTraceLogLevel(rl.LOG_NONE)
Config = {
    ScreenWidth = 1280,
    ScreenHeight = 720,
}

rl.InitWindow(Config.ScreenWidth, Config.ScreenHeight, 'Command Test')

require('commandv1')


--rl.SetExitKey(rl.KEY_NULL) --So you can't escape with ESC key used for pausing





Command.Init()