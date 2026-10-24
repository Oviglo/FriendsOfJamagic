//
// TileMap Editor
//
// Date: 04/2024
// Author: Loic Ovigne
//

var editorMode = IsEditorMode();
var oMainWindow = new Window(640, 480, Window.RESIZABLE);

var oTileMapEditor = new TileMapEditor(oMainWindow);
var oTileSetEditor = new TileSetEditor();
oTileMapEditor.generateMenuBar();
oMainMenu = oTileMapEditor.getMainMenu();
oMainMenu.OnSelectItem = onMainMenuItemSelected;
oMainWindow.OnMouseWheel = onMouseWheel;
oTileMapEditor.draw();

while(true) {
	
}

delete oTileMapEditor;
delete oMainWindow;

function onMainMenuItemSelected(obj_menu, pos, cmd)
{
	oTileMapEditor.selectMenuItem(obj_menu, pos);
}

function onMouseWheel(win, z)
{
	oTileMapEditor.zoom(z/100);
}
