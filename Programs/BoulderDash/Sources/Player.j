Function JDPlayer()
{
	This.Lives = 5;
	This.Diamonds = 0;
	
	This.xPos = 1; // x and y position
	This.yPos = 1; // (1, 1) because (0, 0) is a wall
	
	This.S = New Sprite(gSurface, 0, 0, "Player0");
	
	// Functions
	This.SetPos = OBJ_JDPlayer_SetPos;
	This.SetDir = OBJ_JDPlayer_SetDir;
	This.SpriteUpdate = OBJ_JDPlayer_SpriteUpdate;
	This.Move = OBJ_JDPlayer_Move;
}

Function OBJ_JDPlayer_SetPos(x, y)
{
	This.xPos = x;
	This.yPos = y;
	
	This.S.Set(32*(x - Level.xPos), 32*(y - Level.yPos));
}

Function OBJ_JDPlayer_SetDir(d)
{
	This.S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Player" + d);
}

Function OBJ_JDPlayer_SpriteUpdate()
{
	This.S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos));
}

Function OBJ_JDPlayer_Move(dx, dy)
{
	targ = PointContent(xPos + dx, yPos + dy);
	
	If(targ == 0 || targ == 1 || targ == 7) // Air or earth or diamond
	{
		NudgeMinerals(xPos, yPos);
	
		xPos += dx;
		yPos += dy;
		SpriteUpdate();
		
		If(targ == 1)
			Level.Set(xPos, yPos, 0); // Air is dug in to earth
			
		If (targ == 7)
			CollectDiamond(xPos, yPos);
			
		// Scrolling
		If (xPos - Level.xPos <= 6) // near left edge
			Level.DoScroll(-1, 0);
		If (xPos - Level.xPos >= 13) // near right edge
			Level.DoScroll(1, 0);
		If (yPos - Level.yPos <= 4) // near top
			Level.DoScroll(0, -1);
		If (yPos - Level.yPos >= 10) // near bottom
			Level.DoScroll(0, 1);
	}
	Else If (targ == 6 && dy == 0) // Moving horizontally at a boulder, pushing it.
	{
		If (PointContent(xPos + 2*dx, yPos) == 0) // Can only push boulders in to air
		{
			mn = GetMineral(xPos + dx, yPos);
			mn.Move(xPos + 2*dx, yPos);
			
			NudgeMinerals(xPos, yPos);
			mn.RunPhysics = mn.Fall;
			
			// Don't forget to move the player as well
			xPos += dX;
			yPos += dy;
			SpriteUpdate();
			
			If (xPos - Level.xPos <= 6) // near left edge
				Level.DoScroll(-1, 0);
			If (xPos - Level.xPos >= 13) // near right edge
				Level.DoScroll(1, 0);
		}
	}
	Else If (targ == 5)
	{
		If (Diamonds >= DiamondLimit)
			Complete = TRUE;
	}
}