// Game Engine Object
Function GameEngine(win_width, win_height, win_title)
{
	// Create Main Window
	win_pos_x = (System.GetScreenWidth() / 2) - (win_width /2);
	win_pos_y = (System.GetScreenHeight() / 2) - (win_height /2);
	This.m_window = New Window(win_width, win_height, win_pos_x, win_pos_y, GetRGB(0,0,0), 32, win_title);
	
	This.m_scene = 0;
	
	// Implements methods
	This.Draw = GameEngine_draw;
}

Function GameEngine_draw()
{
	If (This.m_scene != 0) 
	{
		This.m_scene.Draw();
	}
}