Function QuickInput(question, caption, answer)
{
	answer = "" + answer;
	gMsg = New Window(gWindow, 228, 44, 64, 64, caption, Window.DIALOG, Window.TOOL);
	gMsgTxt = New StaticText(gMsg, question, 4, 4, 220, 16);
	gMsgTxt.SetBackColor(0xD4D0C8);
	gMsgAns = New Edit(gMsg, answer, 4, 24, 220, 16);
	While(!Keyboard.IsKeyDown(Keyboard.Return) && IsObject(gMsg));
	If(IsObject(gMsg))
	{
		answer = gMsgAns.GetText();
		Delete gMsg;
	}
	
	Return answer;
}

Function PointContent(x, y)
{
	If(Level.Block[x, y] > 0) // Not air so can't be anything else
		Return Level.Block[x, y]; // se return that value, 0 to 5 of what it is
	For(n = 0; n < MineralNum; n++)
		If(Mineral[n].xPos == x && Mineral[n].yPos == y)
			Return Mineral[n].IsDiamond + 6; // Returns 6 for rock, 7 for a diamond
	If(Player.xPos == x && Player.yPos == y)
		Return 8; // 8 means player here
	For(n = 0; n < BaddieNum; n++)
		If(Baddie[n].xPos == x && Baddie[n].yPos == y)
			Return Baddie[n].type + 9; // 9 for fly, 10 for rat, 11 for amoeba
	Return 0; // It was air after all
}

Function NudgeMineral(x, y, SetFalling)
{
	For(n = 0; n < MineralNum; n++)
		If(Mineral[n].xPos == x && Mineral[n].yPos == y)
			Mineral[n].RunPhysics = Mineral[n].Sit;
}

Function NudgeMinerals(x, y)
{
	NudgeMineral(x - 1, y - 1);
	NudgeMineral(x, y - 1);
	NudgeMineral(x + 1, y - 1);
	NudgeMineral(x - 1, y);
	NudgeMineral(x + 1, y);
}

Function CollectDiamond(x, y)
{
	For(n = 0; n < MineralNum; n++)
		If(Mineral[n].xPos == x && Mineral[n].yPos == y)
		{
			Mineral[n].Collect(); // Finish off object
			Delete Mineral[n];
			If (n != MineralNum - 1)
			{
				Mineral[n] = Mineral[MineralNum - 1];
				Mineral[MineralNum - 1] = 0;
			}
			MineralNum--;
			Return TRUE;
		}
		
	Return FALSE;
}

Function GetMineral(x, y)
{
	For(n = 0; n < MineralNum; n++)
		If(Mineral[n].xPos == x && Mineral[n].yPos == y)
			Return Mineral[n];
	Return FALSE;
}

Function CreateExplosion(xc, yc, f) // xc = xcentre, yc = ycentre, f = fill with block type
{
	SpriteClear = TRUE;
	For (x = xc - 1; x <= xc +1; x++)
	{
		For (y = yc -1; y <= yc +1; y++)
		{
			ClearSquare(x, y); // Makes the square empty
			
			If (f <= 5)
				Level.Set(x, y, f);
			Else If (f == 6 || f == 7) // The next few lines come out the level loading function
			{
				Mineral[MineralNum] = New JDMineral(f - 6, x , y); // Remember false is and true is 1
				Mineral[MineralNum].RunPhysics = Mineral[MineralNum].Fall; // Tip if over
				MineralNum++;
			}
			Else If (f == 12)
				Baddie[(BaddieNum++)] = New JDBaddie(x, y, 0, Random(4)); // Firefly with random direction
			Else If (f == 16)
				Baddie[(BaddieNum++)] = New JDBaddie(x, y, 1, Random(4)); // Rat
			Else If (f == 20)
				Baddie[(BaddieNum++)] = New JDBaddie(x, y, 2, Random(4)); // Amoeba
				
			NudgeMinerals(x, y);
		}
	}
	
	ex = New Sprite(gWindow, 32*(xc - 1 - Level.xPos), 32*(yc - 1 - Level.yPos), "Explode");
	ex.SetLayer(2); // Layer 2 is different from all the other sprites so far
	ex.SetDrawEffect(Sprite.DEOR); // This will make if blend wall with the background
}

Function ClearSquare(x, y)
{
	If (Level.Block[x, y] > 0)
		Level.Set(x, y, 0); // Make it 0 type (air)
	Else // If it's air, maybe there's something in the air
	{
		For (n = 0; n < MineralNum; n++) // If a mineral is there, delete it
			If (Mineral[n].xPos == x && Mineral[n].yPos == y)
			{
				Delete Mineral[n].S;
				Delete Mineral[n];
				If (n != MineralNum - 1)
				{
					Mineral[n] = Mineral[MineralNum - 1];
					Mineral[MineralNum - 1] = 0;
				}
				MineralNum--;
				Return TRUE; // It was a mineral then
			}
			
		If(Player.xPos == x && Player.yPos == y) // Maybe the player is there ?
		{
			If(Player.xPos == x && Player.yPos == y)
				Alive = FALSE;
			
			Return TRUE;
		}
		
		For (n = 0; n < BaddieNum; n++) // Perhaps it is a baddie then
			If (Baddie[n].xPos == x && Baddie[n].yPos == y)
			{
				Delete Baddie[n].S;
				Delete Baddie[n];
				If (n != BaddieNum - 1)
				{
					Baddie[n] = Baddie[BaddieNum - 1];
					Baddie[BaddieNum - 1] = 0;
				}
				BaddieNum--;
			}
	}
}

Function DirToDx(dir)
{
	If (dir == 1)
		Return 1;
	If (dir == 3)
		Return -1;
	Return 0;
}

Function DirToDy(dir)
{
	If (dir == 0)
		Return -1;
	If (dir == 2)
		Return 1;
	Return 0;
}

Function Sign(s) // Returns the sign of a number
{
	If (s < 0)
		Return -1;
	If (s > 0)
		Return 1;
	Return 0;
}