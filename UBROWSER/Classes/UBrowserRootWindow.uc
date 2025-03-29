//================================================================================
// UBrowserRootWindow.
//================================================================================
class UBrowserRootWindow expands UWindowRootWindow;

var UBrowserMainWindow MainWindow;

function Created ()
{
	Super.Created();
	MainWindow=UBrowserMainWindow(CreateWindow(Class'UBrowserMainWindow',50.00,30.00,500.00,300.00));
	MainWindow.bStandaloneBrowser=True;
	MainWindow.WindowTitle="Unreal Browser";
	Resized();
}

function Resized ()
{
	Super.Resized();
	MainWindow.SetSize(Min(500,WinWidth - 10),WinHeight - 30);
	MainWindow.WinLeft=(WinWidth - MainWindow.WinWidth) / 2;
	MainWindow.WinTop=(WinHeight - MainWindow.WinHeight) / 2;
}

defaultproperties
{
    LookAndFeelClass="UWindow.UWindowWin95LookAndFeel"
}