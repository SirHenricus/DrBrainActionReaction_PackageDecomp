//================================================================================
// UBrowserBannerAd.
//================================================================================
class UBrowserBannerAd expands UWindowWindow;

var string URL;

function Created ()
{
	URL="http://www.unreal.com";
	Cursor=Root.HandCursor;
}

function Paint (Canvas C, float X, float Y)
{
	DrawClippedTexture(C,0.00,0.00,Texture'BannerAd');
}

function Click (float X, float Y)
{
	Root.Console.Viewport.Actor.ConsoleCommand("start " $ URL);
}

function MouseLeave ()
{
	Super.MouseLeave();
	ToolTip("");
}

function MouseEnter ()
{
	MouseLeave();
	ToolTip(URL);
}