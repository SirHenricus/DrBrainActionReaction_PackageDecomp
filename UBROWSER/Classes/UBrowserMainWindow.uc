//================================================================================
// UBrowserMainWindow.
//================================================================================
class UBrowserMainWindow expands UWindowFramedWindow;

var UBrowserBannerBar BannerWindow;
var string StatusBarDefaultText;
var bool bStandaloneBrowser;
var localized string WindowTitleString;

function DefaultStatusBarText (string Text)
{
	StatusBarDefaultText=Text;
	StatusBarText=Text;
}

function BeginPlay ()
{
	Super.BeginPlay();
	WindowTitle="Unreal" @ WindowTitleString;
	ClientClass=Class'UBrowserMainClientWindow';
}

function Created ()
{
	bSizable=True;
	bStatusBar=True;
	Super.Created();
	MinWinWidth=300.00;
	MinWinHeight=160.00;
	SetSizePos();
}

function BeforePaint (Canvas C, float X, float Y)
{
	if ( StatusBarText == "" )
	{
		StatusBarText=StatusBarDefaultText;
	}
	Super.BeforePaint(C,X,Y);
}

function Close (optional bool bByParent)
{
	if ( bStandaloneBrowser )
	{
		Root.Console.CloseUWindow();
	}
	else
	{
		Super.Close(bByParent);
	}
}

function ResolutionChanged (float W, float H)
{
	SetSizePos();
	Super.ResolutionChanged(W,H);
}

function SetSizePos ()
{
	SetSize(Min(500,Root.WinWidth - 10),Root.WinHeight - 50);
	WinLeft=(Root.WinWidth - WinWidth) / 2;
	WinTop=(Root.WinHeight - WinHeight) / 2;
}

defaultproperties
{
    WindowTitleString="Server Browser"
}