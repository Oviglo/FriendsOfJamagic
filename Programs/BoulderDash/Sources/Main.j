gWindow = New Window(1920, 1080, 64, 64, 0, 32, "JamaDASH!", Window.GAME);
SetDisplayInterface(Display.SOFTWARE_DIRECTDRAW);
//w = New World();
//c = New Camera(w);

gWindowSurface = gWindow.GetSurface();
gWindowSurface.SetAutoRefresh(OFF);
gSurface = New Surface(640, 480, 32);
gSurface.SetAutoRefresh(OFF);

DiamondLimit = 0;
TimeLimit = 3000;

Level = New JDLevel();
Player = New JDPlayer();
Baddie[0] = 0;
BaddieNum = 0;
Mineral[0] = 0;
MineralNum = 0;

Complete = FALSE;
Alive = TRUE;
Running = TRUE;
SpriteClear = FALSE;
LevelName[8] = "";
For(lev = 0; lev < 8; lev++)
	LevelName[lev] = "Mission" + (lev + 1);
CurrentLevel = 0;

While(Running)
{
	ClearObjects();
	If (LevelName[CurrentLevel] == "")
		EndScreen();
	Level.Load(LevelName[CurrentLevel] + ".JDL");
	Level.Draw();
	
	Complete = FALSE;
	Alive = TRUE;
	gTic = System.GetElapsedTime() + 50;

	While(!Complete && Alive)
	{
		gWindowSurface.Lock();
		If(gTic < System.GetElapsedTime())
		{
			gTic = System.GetElapsedTime() + 50;
			If(SpriteClear)
				DoSpriteClear();
			HandlePlayer();
			HandleMinerals();
		}
	
		HandleBaddies();
		
		// Blit gSurface on gWindowSurface
		gSurface.Refresh();
		gWindowSurface.Stretch(gSurface, 240, 0, gWindowSurface.GetPixelWidth() - 480, gWindowSurface.GetPixelHeight(), TRUE); 
		//gWindowSurface.Copy(gSurface);
		gWindowSurface.Refresh();
		gWindowSurface.Unlock();
	}
	
	If (!Alive)
		Player.Lives--;
	If (Complete)
		CurrentLevel++;
		
	EndTransition();
	
	If (Player.Lives < 0)
	{
		Player.Lives = 5;
		CurrentLevel = 0;
	}
}


Function HandlePlayer()
{
	If(Keyboard.IsKeyDown(Keyboard.RIGHT))
	{
		Player.Move(1, 0);
		Player.SetDir(1);
	}
	Else If(Keyboard.IsKeyDown(Keyboard.LEFT))
	{
		Player.Move(-1, 0);
		Player.SetDir(3);
	}
	Else If(Keyboard.IsKeyDown(Keyboard.DOWN))
	{
		Player.Move(0, 1);
		Player.SetDir(2);
	}
	Else If(Keyboard.IsKeyDown(Keyboard.UP))
	{
		Player.Move(0, -1);
		Player.SetDir(0);
	}
}

Function Blank() {}

Function HandleMinerals()
{
	For(n = 0; n < MineralNum; n++)
		Mineral[n].RunPhysics();
}

Function DoSpriteClear()
{
	s = gSurface.GetFirstSprite();
	While(s != 0)
	{
		b = s;
		s = gSurface.GetNextSprite(s);
		
		If(b.GetLayer() == 2)
			Delete b;
	}
	
	SpriteClear = FALSE;
}

Function HandleBaddies()
{
	For(n = 0; n < BaddieNum; n++)
		If(Baddie[n].thinkTime < System.GetElapsedTime())
			Baddie[n].AI();
}

Function ClearObjects() // Purges the objects from the global variables
{
	For(n = 0; n < BaddieNum; n++)
		If (IsObject(Baddie[n]))
			Delete Baddie[n];
		For(n = 0; n < MineralNum; n++)
			If (IsObject(Mineral[n]))
				Delete Mineral[n];
				
	Flush(); // And flushes them away
	BaddieNum = 0;
	MineralNum = 0;
}

Function EndTransition()
{
	If (complete) // Finished so do a nice transition
	{
		For(rot = 0; rot < 40; rot++)
		{
			gWindowSurface.Rotate(Pi/20, FALSE);
			gWindowSurface.Stretch(gWindowSurface, 20, 20, 512, 384, 0, 0, gWindowSurface.GetPixelWidth(), gWindowSurface.GetPixelHeight());
			gWindowSurface.Refresh();
			Wait(10);
		}
	}
	Else If (!Alive) // Died! So do a ominous transition (smudgy zoom)
	{
		gWindowSurface.SetDrawMode(Surface.BLENDING, 64);
		For(fade = 0; fade < 100; fade += 2)
		{
			gWindowSurface.Stretch(gWindowSurface, 0, 0, gWindowSurface.GetPixelWidth(), gWindowSurface.GetPixelHeight(), 16, 16, 608, 448);
			gWindowSurface.Refresh();
			Wait(10);
		}
		gWindowSurface.SetDrawMode(Surface.COPYALL);
		
		If (Player.Lives < 0)
		{
			For(fade = 255; fade >= 0; fade--)
			{
				gWindowSurface.SetBackgroundColor(GetRGB(fade, fade, fade));
				gWindowSurface.EraseRect();
				gWindowSurface.Refresh();
				Wait(10);
			}
		}
	}
}

Function EndScreen()
{
	ClearObjects();
	//gSurface.LoadImage("End");
	Delete Player.S;
	// Delete HUD;
	gSurface.Refresh();
	Wait(10000);
	Restart();
}