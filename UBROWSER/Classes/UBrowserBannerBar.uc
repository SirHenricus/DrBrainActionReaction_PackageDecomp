//================================================================================
// UBrowserBannerBar.
//================================================================================
class UBrowserBannerBar expands UWindowWindow;

var UBrowserBannerAd BannerAdWindow;

function Paint (Canvas C, float X, float Y)
{
	C.Style=GetPlayerOwner().4;
	Tile(C,Texture'Background');
	C.Style=GetPlayerOwner().1;
}

function Created ()
{
	Super.Created();
	BannerAdWindow=UBrowserBannerAd(CreateWindow(Class'UBrowserBannerAd',0.00,2.00,256.00,64.00));
}

function BeforePaint (Canvas C, float X, float Y)
{
	BannerAdWindow.WinLeft=(WinWidth - 256) / 2;
}