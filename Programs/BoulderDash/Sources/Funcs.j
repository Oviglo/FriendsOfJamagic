Function QuickInput(question, caption, answer)
{
	answer = "" + answer;
	gMsg = New Window(gWindow, 228, 44, 64, 64, caption, Window.DIALOG, Window.TOOL);
	gMsgTxt = New StaticText(gMsg, question, 4, 4, 220, 16);
	gMsgTxt.SetBackColor(0xD4D0C8);
	gMsgAns = New Edit(gMsg, answer, 4, 24, 220, 16);
	While(!Keyboard.IsKeyDown(Keyboard.Return) && IsObject(gMsg));
	If(IsObject(gMsg))
	{
		answer = gMsgAns.GetText();
		Delete gMsg;
	}
	
	Return answer;
}