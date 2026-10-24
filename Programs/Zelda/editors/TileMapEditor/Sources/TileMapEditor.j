// Editor Object

Function TileMapEditor(obj_mainWindow)
{
	// Properties
	this.mainWindow = obj_mainWindow;
	this.mainSurface = this.mainWindow.GetSurface();
	
	this.newMapDialogWindow = New Window(200, 200,,,,,"New TileMap",,This.mainWindow, Window.HIDDEN, Window.FAKECHILD);
	this.newMapDialogBtnOK = 0;
	
	this.mainMenu = New Menu(This.mainWindow);
	this.tileMap = new TileMap();
	
	// Getters/Setters
	this.getMainMenu = TileMapEditor_getMainMenu;
	
	// Methods
	this.generateMenuBar = TileMapEditor_generateMenuBar;
	this.openNewMapDialog = TileMapEditor_openNewMapDialog;
	this.selectMenuItem = TileMapEditor_selectMenuItem;
	this.draw = TileMapEditor_draw;
	this.zoom = TileMapEditor_zoom;
	
	// Private Methods
	this.createNewMapDialog = TileMapEditor_createNewMapDialog;
	
	// Initialisation
	this.createNewMapDialog();
}

function TileMapEditor_getMainMenu()
{
	return this.mainMenu;
}

function TileMapEditor_generateMenuBar()
{
	// File Menu
	var obj_file = new Menu();
	obj_file.SetPrivateData("menu_file");
	this.mainMenu.InsertItem(obj_file, "File");
	obj_file.InsertItem("New");
}

function TileMapEditor_openNewMapDialog()
{
	this.newMapDialogWindow.Show();
}

function TileMapEditor_selectMenuItem(obj_menu, pos)
{
	switch(obj_menu.GetPrivateData()){
		case "menu_file":
			switch(pos) {
				case 0: // New
					this.openNewMapDialog();
					break;
			}
			break;
	}
}

function TileMapEditor_createNewMapDialog()
{
	var win = this.NewMapDialogWindow;
	var win_w = win.GetWidth();
	this.newMapDialogWindow.SetBackgroundColor(System.GetSysColor(System.SYSCOLOR_WINDOW));
	this.newMapDialogWindow.EraseRect();
	
	var mainGroupBox = new GroupBox(win, "Settings", 5, 5, win_w - 10, 100, GroupBox.BORDER);
	
	// Name Field
	var nameFieldLabel = new StaticText(win, "Name", 15, 25, win_w - 30, 20);
	var nameField = new Edit(win, "New Map", 15, 45, win_w - 30, 20, , Edit.BORDER);
}

function TileMapEditor_draw()
{
	if (this.tileMap == 0)
		return;
		
	var tileMapSurface = this.tileMap.draw();
	this.mainSurface.Copy(tileMapSurface);
}

function TileMapEditor_zoom(delta)
{
	var step = 0.2;
	if (delta < 0)
		step = -0.2;
		
	this.tileMap.setZoom(this.tileMap.getZoom() + step);
	this.draw();
}