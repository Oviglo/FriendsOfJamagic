gWindow = New Window(640, 480, 64, 64, 0, 32, "JamaDASH !", Window.GAME);
gSurface = gWindow.GetSurface();
gSurface.SetAutoRefresh(OFF);

Level = New JDLevel();
//Level.EditorLoad("Level1.JDL");
Level.MakeNew();
Level.Draw();

gTool = New Window(672, 32, 64, 16, 0, 32, "Tiles", gWindow, Window.TOOL);
gTool.LoadImage("JDTile");

LMB = 0;
RMB = 0;
DiamondLimit = 0;
TimeLimit = 3000;

While(TRUE)
{
	xScr = 0;
	yScr = 0;
	If(IsKeyDown(Keyboard.LEFT))
		xScr--;
	If(IsKeyDown(Keyboard.RIGHT))
		xScr++;
	If(IsKeyDown(Keyboard.UP))
		yScr--;
	If(IsKeyDown(Keyboard.DOWN))
		yScr++;
	If(xScr || yScr)
		Level.DoScroll(xScr, yScr);
		
	If(IsKeyDown(Keyboard.LBUTTON))
	{
		If(gTool.GetXMouse() > 0 && gTool.GetXMouse() < 672 && gTool.GetYMouse() > 0 && gTool.GetYMouse() < 32)
			LMB = gTool.GetXMouse() / 32;
		Else
			Level.Set(Level.xPos + (gWindow.GetXMouse()/32), Level.yPos + (gWindow.GetYMouse()/32), LMB);
	}
	
    If(IsKeyDown(GetAscii("D")))
	{
		DiamondLimit = QuickInput("Diamond limit?", "Enter a number", DiamondLimit);
		DiamondLimit = DiamondLimit.GetInt(); // The above function returns a string
		DiamondLimit = Min(Max(DiamondLimit, 0), 1000);
    }

    If(IsKeyDown(GetAscii("T")))
    {
		TimeLimit = QuickInput("Time limit? (10ths of second)", "Enter a number", TimeLimit);
		TimeLimit = TimeLimit.GetInt(); // The above function returns a string
		TimeLimit = Min(Max(TimeLimit, 150), 3000);
    }
	
	If(IsKeyDown(GetAscii("S")))
	{
		fSelect = New Selector();
		success = fSelect.SaveFileDialog(gWindow, "Select save file...", "JamaDash Level|*.JDL||", 0, "Level.JDL", GetApplicationDirectory(), ".JDL");
		If(success)
			Level.Save(fSelect.GetOneFile());
		Delete fSelect;
	}
	
	Level.Draw();
	gSurface.Refresh();
	Wait(10);
}