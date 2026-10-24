// TileSet Object

function TileSet()
{
	// Private properties
	this.p_surface = New Surface();
	this.p_datas = 0;
	
	// Getters / setters
	this.getSurface = TileSet_getSurface;
	this.setSurface = TileSet_setSurface;
	
	// Methods
	this.createData = TileSet_createData;
}

function TileSet_createData(x, y)
{
	this.p_datas[Program.GetArrayDimensionSize(this.p_data, 0)] = new TileSetData(x, y);
}

function TileSet_getDataByPosition(pos)
{
	for (i = 0; i < Program.GetArrayDimensionSize(this.p_data, 0); i++) {
		var dataPos = this.p_data[i].getPosition();
		if (dataPos.isEqual(pos))
			return this.p_data[i];
	}
	
	return 0;
}

function TileSet_getSurface()
{
	return this.p_surface;
}

function TileSet_setSurface(surf)
{
	if (!Program.IsObject(surf, "Surface"))
		return this;
		
	if (Program.IsObject(this.p_surface, "Surface")) {
		delete this.p_surface;
	}
	
	this.p_surface = surf;
}