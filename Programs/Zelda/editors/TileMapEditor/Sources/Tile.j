// Tile Object
// Allow to define a TileMap tile

function Tile()
{
	// Properties
	this.p_position = new Vector2(0, 0);
	this.p_sourcePosition = new Vector2(0, 0);
	
	// Getters / Setters
	this.getPosition = Tile_getPosition;
	this.setPosition = Tile_setPosition;
}

function Tile_getPosition()
{
	return this.p_position;
}

function Tile_setPosition(pos)
{
	if (!Program.IsObject(pos, "Vector2"))
		return this;
		
	this.p_position = pos;
	
	return this;
}