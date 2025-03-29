//================================================================================
// UBrowserMainClientWindow.
//================================================================================
class UBrowserMainClientWindow expands UWindowClientWindow;

const OpenBarHeight=30;
var UWindowPageControl PageControl;
var UBrowserOpenBar OpenBar;
var UWindowPageControlPage Favorites;
var localized string FavoritesName;
var() globalconfig string ServerListNames[20];
var() globalconfig string ServerListTags[20];
var() globalconfig string ListFactories0[20];
var() globalconfig string ListFactories1[20];
var() globalconfig string ListFactories2[20];
var() globalconfig string ListFactories3[20];
var() globalconfig string ListFactories4[20];
var() globalconfig string ListFactories5[20];
var() globalconfig string ListFactories6[20];
var() globalconfig string ListFactories7[20];
var() globalconfig string ListFactories8[20];
var() globalconfig string ListFactories9[20];
var() globalconfig string URLAppend[20];
var() globalconfig int AutoRefreshTime[20];
var UBrowserServerListWindow FactoryWindows[20];

function Created ()
{
	local int i;
	local int F;
	local UWindowPageControlPage P;
	local UBrowserServerListWindow W;

	PageControl=UWindowPageControl(CreateWindow(Class'UWindowPageControl',0.00,30.00,WinWidth,WinHeight - 30));
	Favorites=PageControl.AddPage(FavoritesName,Class'UBrowserFavoriteServers');
	i=0;
JL0055:
	if ( i < 20 )
	{
		if ( ServerListNames[i] == "" )
		{
			goto JL0223;
		}
		P=PageControl.AddPage(ServerListNames[i],Class'UBrowserServerListWindow');
		W=UBrowserServerListWindow(P.Page);
		W.ListFactories[0]=ListFactories0[i];
		W.ListFactories[1]=ListFactories1[i];
		W.ListFactories[2]=ListFactories2[i];
		W.ListFactories[3]=ListFactories3[i];
		W.ListFactories[4]=ListFactories4[i];
		W.ListFactories[5]=ListFactories5[i];
		W.ListFactories[6]=ListFactories6[i];
		W.ListFactories[7]=ListFactories7[i];
		W.ListFactories[8]=ListFactories8[i];
		W.ListFactories[9]=ListFactories9[i];
		W.URLAppend=URLAppend[i];
		W.AutoRefreshTime=AutoRefreshTime[i];
		FactoryWindows[i]=W;
		i++;
		goto JL0055;
	}
JL0223:
	i=0;
JL022A:
	if ( i < 20 )
	{
		if ( FactoryWindows[i] != None )
		{
			FactoryWindows[i].Refresh(False,True);
		}
		i++;
		goto JL022A;
	}
	OpenBar=UBrowserOpenBar(CreateWindow(Class'UBrowserOpenBar',0.00,0.00,WinWidth,30.00));
	Super.Created();
	SaveConfig();
}

function Resized ()
{
	local float Y;

	Y=0.00;
	if ( OpenBar.bWindowVisible )
	{
		OpenBar.SetSize(WinWidth,30.00);
		Y += 30;
	}
	PageControl.WinTop=Y;
	PageControl.SetSize(WinWidth,WinHeight - Y);
}

function Paint (Canvas C, float X, float Y)
{
	DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'BlackTexture');
}

function SaveConfigs ()
{
	SaveConfig();
}

defaultproperties
{
    FavoritesName="Favorites"
}