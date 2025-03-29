//================================================================================
// UBrowserInfoClientWindow.
//================================================================================
class UBrowserInfoClientWindow expands UWindowClientWindow;

var UWindowVSplitter Splitter;

function Created ()
{
	Super.Created();
	Splitter=UWindowVSplitter(CreateWindow(Class'UWindowVSplitter',0.00,0.00,WinWidth,WinHeight));
	Splitter.TopClientWindow=UBrowserPlayerGrid(Splitter.CreateWindow(Class'UBrowserPlayerGrid',0.00,0.00,WinWidth,WinHeight));
	Splitter.BottomClientWindow=UBrowserRulesGrid(Splitter.CreateWindow(Class'UBrowserRulesGrid',0.00,0.00,WinWidth,WinHeight));
}

function Resized ()
{
	Splitter.SetSize(WinWidth,WinHeight);
}

function Paint (Canvas C, float X, float Y)
{
	DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'BlackTexture');
}