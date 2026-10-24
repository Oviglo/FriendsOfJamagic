// TileSetData Object
// Allow to define a source tile
function TileSetData(x, y)
{
	// Properties
	this.p_pos = new Vector2(x, y);
	
	// Methods
	this.getPosition = TileSetData_getPosition;
}

function TileSetData_getPosition()
{
	return this.p_pos;
}