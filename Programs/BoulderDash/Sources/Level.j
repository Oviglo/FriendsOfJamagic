// 0 = Air
// 1 = Earth
// 2 = Titanium
// 3 = TNT
// 4 = Metamorhposis
// 5 = Exit
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
	xPos += dX;
	yPos += dY;
	
	xPos = Min(Max(xPos, 0), 80);
	yPos = Min(Max(yPos, 0), 60);
	
	Draw();
}