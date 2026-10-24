// TileMap Object

Function TileMap()
{
	// Properties
	this.name = "New Name";
	this.tileSize = 16;
	this.width = 100;
	this.height = 100;
	this.backgroundColor = Program.GetRGB(49, 54, 62);
	this.gridColor = Program.GetRGB(118, 171, 174);
	this.showGrid = true;
	this.p_zoom = 1.0;
	this.p_tiles = 0;
	
	// Private properties
	this.p_surface = new Surface(this.width * this.tileSize, this.height * this.tileSize, 32);
	
	// Getters / Setters
	this.setZoom = TileMap_setZoom;
	this.getZoom = TileMap_getZoom;
	
	// Methods
	this.draw = TileMap_draw;
	this.drawGrid = TileMap_drawGrid;
}

function TileMap_draw()
{
	this.p_surface.SetBackgroundColor(this.backgroundColor);
	this.p_surface.EraseRect();
	
	var oSurface = new Surface();
	oSurface.Stretch(this.p_surface, 0, 0, this.p_surface.GetPixelWidth() * this.p_zoom, this.p_surface.GetPixelHeight() * this.p_zoom);
	this.drawGrid(oSurface);
	
	return oSurface;
}

function TileMap_drawGrid(surf)
{
	if (!this.showGrid)
		return;
		
	if (!Program.IsObject(surf, "Surface"))
		surf = this.p_surface;
	
	surf.SetPenColor(this.gridColor);
	for (i = 0; i < this.width; i++) {
		surf.Line(i * this.tileSize * this.p_zoom, 0, i * this.tileSize * this.p_zoom, this.height * this.tileSize * this.p_zoom);	
	}
	
	for (i = 0; i < this.height; i++) {
		surf.Line(0, i * this.tileSize * this.p_zoom, this.width * this.tileSize * this.p_zoom, i * this.tileSize * this.p_zoom);	
	}
}

function TileMap_setZoom(zoom)
{
	this.p_zoom = zoom;
	
	return this;
}

function TileMap_getZoom()
{
	return this.p_zoom;
}