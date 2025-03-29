//================================================================================
// UWindowConsoleClientWindow.
//================================================================================
class UWindowConsoleClientWindow expands UWindowClientWindow;

var UWindowConsoleTextAreaControl TextArea;

function Created ()
{
	TextArea=UWindowConsoleTextAreaControl(CreateWindow(Class'UWindowConsoleTextAreaControl',0.00,0.00,WinWidth,WinHeight));
	TextArea.SetScrollable(True);
}

function Paint (Canvas C, float X, float Y)
{
	DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'BlackTexture');
}

function Resized ()
{
	Super.Resized();
	TextArea.SetSize(WinWidth,WinHeight);
}

function BeforePaint (Canvas C, float X, float Y)
{
	TextArea.WinWidth=WinWidth;
	TextArea.WinHeight=WinHeight;
}