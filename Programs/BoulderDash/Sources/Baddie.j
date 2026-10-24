Function JDBaddie(x, y, type, dir, parent) // The amoeba need to tell its drones who their parent is
{
	This.xPos = x;
	This.yPos = y;
	This.type = type; // 0 = firefly, 1 = rat and 2 = amoeba
	This.dir = dir; // Direction
	If (type != 3)
		This.S = New Sprite(gSurface, 32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad" + type + dir);
	Else
		This.S = New Sprite(gSurface, 32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad2" + dir);
	S.SetLayer(1);
	
	
	If (type == 0)
		This.AI = OBJ_JDBaddie_FireflyThink;
	Else If (type == 1)
		This.AI = OBJ_JDBaddie_RatThink;
	Else If (type == 2)
	{
		This.AI = OBJ_JDBaddie_AmoebaThink;
		This.Mass = 1; // Set up the extra variables the amoeba needs
		This.idleMass = 0;
		This.turnsLeft = 4;
		This.collapse = FALSE;
	}
	Else If (type == 3) // Amoeba child
	{
		This.AI = OBJ_JDBaddie_AmoebaChildThink;
		This.turnsLeft = 4;
		This.parent = parent;
	}
		
	This.thinkTime = System.GetElapsedTime() + 250 + Random(1000);
	
	// Functions
	This.MoveToSquare = OBJ_JDBaddie_MoveToSquare;
}

Function OBJ_JDBaddie_FireflyThink()
{
	For (n = 5; n > 1; n--)
	{
		testDir = (dir + n) % 4;
		tPos = PointContent(xPos + DirToDx(testDir), yPos + DirToDy(testDir));
		If(tPos == 0)
		{
			dir = testDir;
			MoveToSquare(xPos + DirToDx(dir), yPos + DirToDy(dir));
			thinkTime = System.GetElapsedTime() + 90 + Random(20);
			Return TRUE; // Purpose found!
		}
		Else If (tPos == 8)
		{
			CreateExplosion(xPos, yPos, 0);
			Return TRUE;
		}
	}
	
	dir = (dir + 1) % 4;
	S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad" + type + dir);
	thinkTime = System.GetElapsedTime() + 500 + Random(20);
}

Function OBJ_JDBaddie_MoveToSquare(x, y)
{
	xPos = x;
	yPos = y;
	S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad" + type + dir);
}

Function OBJ_JDBaddie_AmoebaThink()
{
	tPos = PointContent(xPos + DirToDx(dir), yPos + DirToDy(dir));
	If (tPos == 0) // Air
	{
		Baddie[(BaddieNum++)] = New JDBaddie(xPos + DirToDx(dir), yPos + DirToDy(dir), 3, Random(4), This);
		Mass ++;
	}
	Else If (tPos == 9 || tPos == 10)
	{
		CreateExplosion(xPos, yPos + 1, 0);
		Return TRUE;
	}
	
	dir = (dir + 1) % 4; // Rotate clockwise
	S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad2" + dir); // Change the pic a bit to liven it up
	
	If (Mass > 1) // This checks if it's started expanding
		turnsLeft--;
		
	If (turnsLeft == 0)
	{
		AI = OBJ_JDBaddie_AmoebaThink_Hibernate;
		idleMass++;
	}
	
	thinkTime = System.GetElapsedTime() + 750 + Random(500);
}

Function OBJ_JDBaddie_AmoebaThink_Hibernate()
{
	If (idleMass == Mass || Mass >= 100) // It's dead
	{
		AI = OBJ_JDBaddie_AmoebaThink_Collapse;
		collapse = TRUE;
		thinkTime = System.GetElapsedTime() + 4000;
		Return TRUE;
	}
	
	dir = (dir + 1) % 4; // Continue rotating just to look lively
	S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad2" + dir);
	thinkTime = System.GetElapsedTime() + 1750 + Random(500); // Not much is happening
}

Function OBJ_JDBaddie_AmoebaChildThink()
{
	If (parent.collapse == TRUE)
	{
		AI = OBJ_JDBaddie_AmoebaThink_Collapse;
		thinkTime = parent.thinkTime + Random(200); // Don't wait tool long
		This.Mass = parent.Mass;
		Return TRUE; // Done
	}
	
	tPos = PointContent(xPos + DirToDx(dir), yPos + DirToDy(dir)); // Trying to expand, etc.
	If (tPos == 0)
	{
		Baddie[(BaddieNum++)] = New JDBaddie(xPos + DirToDx(dir), yPos + DirToDy(dir), 3, Random(4), parent);
		parent.Mass++;
	}
	Else If (tPos == 9 || tPos == 10)
	{
		CreateExplosion(xPos, yPos + 1, 0);
		Return TRUE;
	}
	
	dir = (dir + 1) % 4;
	turnsLeft--;
	
	If (turnsLeft == 0)
	{
		AI = OBJ_JDBaddie_AmoebaChildThink_Hibernate;
		parent.idleMass++;
	}
	
	thinkTime = System.GetElapsedTime() + 750 + Random(500);
}

Function OBJ_JDBaddie_AmoebaChildThink_Hibernate()
{
	If (parent.collapse == TRUE)
	{
		AI = OBJ_JDBaddie_AmoebaThink_Collapse;
		thinkTime = parent.thinkTime + Random(15000);
		This.Mass = parent.Mass;
		Return TRUE;
	}
	
	dir = (dir + 1) % 4;
	S.Set(32*(xPos - Level.xPos), 32*(yPos - Level.yPos), "Bad2" + dir);
	thinkTime = System.GetElapsedTime() + 1750 + Random(500);
}

Function OBJ_JDBaddie_AmoebaThink_Collapse()
{
	Delete S;
	
	If (Mass > 12 && Mass < 100)
		Mineral[(MineralNum++)] = New JDMineral(TRUE, xPos, yPos);
	Else
		Mineral[(MineralNum++)] = New JDMineral(FALSE, xPos, yPos);
		
	xPos = -2;
	yPos = -2;
	
	AI = Blank;
	thinkTime = Pow(10, 10); // Don't think again so set next think time very far in future (115 years to be precise)
}

Function OBJ_JDBaddie_RatThink()
{
	bestThreshold = -1; // All negative thresholds are really bad, so lets set the minimum to -1.
	bestDir = -1; // -1 is a dummy value representing 'no square' at the moment.
	For (n = 0; n < 4; n++)
	{
		dThreshold = 10; // Start off with ten points for this direction
		space = PointContent(xPos + DirToDx(n), yPos + DirToDy(n));
		If (space == 8)
		{
			CreateExplosion(xPos, yPos, 0);
			Return TRUE;
		}
		
		If (space != 0) // Not air
			dThreshold = -100; // So give it a really bad score !
			
		If (n % 2 == 0) // Vertical
			If (Sign(Player.yPos - yPos) == Sign(DirToDy(n)))
				dThreshold += Min(Abs(Player.yPos - yPos), 10); // Bonus for going towards player
		If (n % 2 == 1) // Horizontal
			If (Sign(Player.xPos - xPos) == Sign(DirToDx(n)))
				dThreshold += Min(Abs(Player.xPos - xPos), 10);
				
		If (n == dir)
			dThreshold += 1; // Add a bonus if you're continuing in the same path
			
		If (n == (dir + 2) % 4) // If it's turning aound
			dThreshold /= 2; // Get 50% knoked off
			
		If (dThreshold > bestThreshold) // Was it the best result so far ?
		{
			bestDir = n;
			bestThreshold = dThreshold;
		}
	}
	
	If (bestDir != -1) // If there's a decent square to move in to
	{
		dir = bestDir;
		MoveToSquare(xPos + DirToDx(dir), yPos + DirToDy(dir));
	}
	
	thinkTime = System.GetElapsedTime() + 75 + Random(75); // Think again.
}

