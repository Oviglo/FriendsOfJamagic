// 0 = Air
// 1 = Earth
// 2 = Titanium
// 3 = TNT
// 4 = Metamorhposis
// 5 = Exit
// 6 = Rock
// 7 = Diamond
// 8 = Player
// 9 = Firefly
// 10 = Rat
// 11 = Amoeba
Function JDLevel()
{
	This.Block[0, 0] = 0; // Initialize the block array
	This.BlockImg = New Surface("JDTile");
	This.xPos = 0;
	This.yPos = 0;
	
	// Functions
	This.MakeNew = OBJ_JDLevel_MakeNew;
	This.Set = OBJ_JDLevel_Set;
	This.DrawPos = OBJ_JDLevel_DrawPos;
	This.Draw = OBJ_JDLevel_Draw;
	This.DoScroll = OBJ_JDLevel_DoScroll;
	This.Save = OBJ_JDLevel_Save;
	This.EditorLoad = OBJ_JDLevel_EditorLoad;
	This.Load = OBJ_JDLevel_Load;
	This.DrawPart = OBJ_JDLevel_DrawPart;
}

Function OBJ_JDLevel_MakeNew()
{
	For(x = 0; x < 100; x++)
		For(y = 0; y < 75; y++)
		{
			If(x == 0 || x == 99 || y == 0 || y == 74) // Edge piece
				Block[x, y] = 2; // Titanium
			Else
				Block[x, y] = 1; // Earth
		}
}

Function OBJ_JDLevel_Set(x, y, t)
{
	If(x < 0 || x > 99 || y < 0 || y > 74) // Off the edge
		Return FALSE;
	If((x == 0 || x == 99 || y == 0 || y == 74) && (t != 2 && t != 5)) // an edge piece that isn't solid
		Return FALSE;
	Block[x, y] = t;
	
	gSurface.Copy(BlockImg, 32*(x - xPos), 32*(y - yPos), 32*t, 0, 32, 32);
}

Function OBJ_JDLevel_DrawPos(xP, yP)
{
	xP = Min(Max(xP, 0), 80);
	yP = Min(Max(yP, 0), 60);
	
	gSurface.Lock();
	
	For(x = 0; x < 20; x++)
		For(y = 0; y < 15; y++)
			gSurface.Copy(BlockImg, x*32, y*32, 32*Block[xP+x, yP+y], 0, 32, 32);
			
	gSurface.Unlock();
}

Function OBJ_JDLevel_Draw()
{
	DrawPos(xPos, yPos);
}

Function OBJ_JDLevel_DoScroll(dX, dY)
{
	dX += xPos;
	dY += yPos;
	
	dX = Min(Max(dX, 0), 80);
	dY = Min(Max(dY, 0), 60);
	
	gSurface.SCROLL(-32*(dX - xPos), -32*(dY - yPos));
	gSurface.ScrollSprites(-32*(dX - xPos), -32*(dY - yPos), 1);
	
	If ((dX - xPos)  > 0)
	{
		xPos = dX;
		yPos = dY;
		
		DrawPart(19 - (dX - xPos), 20, 0, 15);
	}
	Else If ((dX - xPos) < 0)
	{
		xPos = dX;
		yPos = dY;
		
		DrawPart(0, 1 - (dX - xPos), 0, 15);
	}
	Else If ((dY - yPos) > 0)
	{
		xPos = dX;
		yPos = dY;
		
		DrawPart(0, 20, 14 - (dY - yPos), 15);
	}
	Else If ((dY - yPos) < 0)
	{
		xPos = dX;
		yPos = dY;
		
		DrawPart(0, 20, 0, 1 - (dY - yPos));
	}
	Else
	{
		xPos = dX;
		yPos = dY;
	}
}

Function OBJ_JDLevel_Save(fName)
{
	bOut = New Binary();
	bOut.AllocateData(7504);
	wPos = 0;
	For(x = 0; x < 100; x++)
		For(y = 0; y < 75; y++)
			bOut.SetByte((wPos++), Block[x, y]);
			
	bOut.SetWord(7500, DiamondLimit);
	bOut.SetWord(7502, TimeLimit);
	
	bOut.SaveData(fName, TRUE, 0, 0, 7504);
	Delete bOut;
}

Function OBJ_JDLevel_EditorLoad(fName)
{
	bIn = New Binary();
	bIn.LoadData(fName, 0, 7504);
	
	rPos = 0;
	For(x = 0; x < 100; x++)
		For(y = 0; y < 75; y++)
			Block[x, y] = bIn.GetByte(rPos++);
			
	DiamondLimit = bIn.GetWord(7500);
	TimeLimit = bIn.GetWord(7502);
	
	Delete bIn;
}

Function OBJ_JDLevel_Load(fName)
{
	xPos = 0;
	yPos = 0;
	bIn = New Binary();
	bIn.LoadData(fName, 0, 7504);
	
	rPos = 0;
	For(x = 0; x < 100; x++)
		For(y = 0; y < 75; y++)
			Block[x, y] = bIn.GetByte(rPos++);
			
	DiamondLimit = bIn.GetWord(7500);
	TimeLimit = bIn.GetWord(7502);
	
	For(x = 1; x < 99; x++)
		For(y = 1; y < 74; y++)
		{
			Switch(Block[x, y])
			{
				Case(6):
					Mineral[(MineralNum++)] = New JDMineral(FALSE, x, y); // Boulder
					Break;
				Case(7):
					Mineral[(MineralNum++)] = New JDMineral(TRUE, x, y); // Diamond
					Break;
				Case(8):
					Player.SetPos(x, y);
					Player.SetDir(0);
					Break;
				Case(9):
					Player.SetPos(x, y);
					Player.SetDir(1);
					Break;
				Case(10):
					Player.SetPos(x, y);
					Player.SetDir(2);
					Break;
				Case(11):
					Player.SetPos(x, y);
					Player.SetDir(3);
					Break;
				Case(12):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 0, 0); // Firefly
					Break;
				Case(13):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 0, 1);
					Break;
				Case(14):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 0, 2);
					Break;
				Case(15):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 0, 3);
					Break;
				Case(16):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 1, 0); // Rat
					Break;
				Case(17):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 1, 1);
					Break;
				Case(18):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 1, 2);
					Break;
				Case(19):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 1, 3);
					Break;
				Case(20):
					Baddie[(BaddieNum++)] = New JDBaddie(x, y, 2, 0); // Amoeba has no direction
					Break;
			}
			
			If (Block[x, y] >= 6)
				Block[x, y] = 0;
		}
	
	Delete bIn;
	
	xPos = Min(Max(Player.xPos - 10, 0), 80);
	yPos = Min(Max(Player.yPos - 7, 0), 60);
	Player.SpriteUpdate();
	Player.Diamonds = 0; // Reset diamond collected count
	gSurface.ScrollSprites(-32*xPos, -32*yPos, 1);
}

Function OBJ_JDLevel_DrawPart(xa, xb, ya, yb)
{
	gSurface.Lock();
	
	For(x = xa; x < xb; x++)
		For(y = ya; y < yb; y++)
			gSurface.Copy(BlockImg, x*32, y*32, 32*Block[xPos + x, yPos + y], 0, 32, 32);
			
	gSurface.Unlock();
}
