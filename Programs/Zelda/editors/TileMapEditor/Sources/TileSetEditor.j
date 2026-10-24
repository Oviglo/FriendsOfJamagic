// TileSet Editor Object
function TileSetEditor(mainWindow)
{
	// Private properties
	this.p_window = new Window(260, 400,,,,,"TileSet",, ,Window.TOOL, Window.FAKECHILD);
	this.p_window.SetBackColor(Program.GetRGB(200, 200, 200));
	this.p_window.EraseRect();
	this.p_tileSet = new TileSet();
	
	// Methods
	this.loadImage = TileSetEditor_loadImage;
}

function TileSetEditor_loadImage(path)
{
	if (!Program.IsString(path))
		return;
		
	var oSurface = new Surface(path);
	this.p_tileSet.setSurface(oSurface);
}