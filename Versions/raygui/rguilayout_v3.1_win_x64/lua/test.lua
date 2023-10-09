#!.\raylua_s.exe 

--TODO: Autoconvert .c autogen into lua
    local screenWidth = 1920;
    local screenHeight = 1080;

    rl.InitWindow(screenWidth, screenHeight, "layout_name");

    local WindowBox000Text = "SAMPLE TEXT"; 
    
    local anchor01 = rl.new('Vector2', 48, 48);   

    local WindowBox000Active = true;    
    
    local layoutRecs1 = rl.new('Rectangle', anchor01.x + 0, anchor01.y + 0, 1280, 720)

    rl.SetTargetFPS(60);
    
    while (not rl.WindowShouldClose()) do
    
    
        rl.BeginDrawing();

            rl.ClearBackground(rl.GetColor(rl.GuiGetStyle(rl.DEFAULT, rl.BACKGROUND_COLOR))); 

            if (WindowBox000Active) then
        
                WindowBox000Active = not rl.GuiWindowBox(layoutRecs1, WindowBox000Text);
            end-------------------------
----------------------------------------------------------------------------------

rl.EndDrawing()
        end
