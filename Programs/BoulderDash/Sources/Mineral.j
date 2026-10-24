Function JDMineral(dia, x, y)
{
	This.IsDiamond = dia; // True or False
	This.xPos = x;
	This.yPos = y;
	This.S = New Sprite(gSurface, 32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Mineral" + IsDiamond);
	S.SetLayer(1);
	
	// Functions
	This.Fall = OBJ_JDMineral_Fall;
	This.Sit = OBJ_JDMineral_Sit;
	This.Collect = OBJ_JDMineral_Collect;
	This.Move = OBJ_JDMineral_Move;
	
	This.RunPhysics = This.Sit;
}

Function OBJ_JDMineral_Fall()
{
	airspace = PointContent(xPos, yPos + 1);
	If(airspace == 0)
	{
		NudgeMinerals(xPos, yPos); // Incase any other minerals come to rest on a falling mineral
		yPos++;
		S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos));
	}
	Else If (airspace == 8 || airspace == 9 || airspace == 10)
	{
		If (airspace != 10)
			CreateExplosion(xPos, yPos + 1, 0);
		Else 
			CreateExplosion(xPos, yPos + 1, 7);
	}
	Else
		RunPhysics = Sit;

}

Function OBJ_JDMineral_Sit()
{
	seat = PointContent(xPos, yPos + 1);
	If (seat == 6 || seat == 7)
	{
		If (PointContent(xPos + 1, yPos) == 0 && PointContent(xPos + 1, yPos + 1) == 0)
		{
			NudgeMinerals(xPos, yPos);
			xPos++;
			yPos++;
			S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos));
			RunPhysics = Fall;
		}
		Else If (PointContent(xPos - 1, yPos) == 0 && PointContent(xPos - 1, yPos + 1) == 0)
		{
			NudgeMinerals(xPos, yPos);
			xPos--;
			yPos++;
			S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos));
			RunPhysics = Fall;
		}
		Else
			RunPhysics = Blank;
	}
	Else If (seat == 0)
	{
		NudgeMinerals(xPos, yPos);
		yPos++;
		S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos));
		RunPhysics = Fall;
	}
	Else If (seat == 4) // Sitting on a metamorphosis block
	{
		NudgeMinerals(xPos, yPos);
		If (PointContent(xPos, yPos + 2) == 0) // There is air underneath it
		{
			yPos += 2;
			IsDiamond = !IsDiamond;
			S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Mineral" + IsDiamond);
			RunPhysics = Fall;
		}
		Else // It is blocks, so absorb
		{
			Delete S; // get rid or the sprite
			xPos = -2; // Set it off the play area
			yPos = -2;
			RunPhysics = Blank; // Don't lit it think any more
		}
	}
	Else If (seat == 3)
		CreateExplosion(xPos, yPos, 0);
	Else If (!(seat == 8 || seat == 9 || seat == 10))
		RunPhysics = Blank;
}

Function OBJ_JDMineral_Collect()
{
	If (!IsDiamond)
		Return FALSE;
		
	Delete S; // get rid of the sprite
	xPos = -2; // Set it off the play area
	yPos = -2;
	
	Player.Diamonds++; // Add a diamond
}

Function OBJ_JDMineral_Move(x, y) // Move to x, y
{
	xPos = x;
	yPos = y;
	S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos));
	RunPhysics = Sit;
}