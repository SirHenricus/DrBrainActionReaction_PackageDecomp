//================================================================================
// SPServerListMenu.
//================================================================================
class SPServerListMenu expands SPMenu;

var Class<PlayerPawn> PlayerClass;
var SPServerList ServerList;
var SPGSpyFactory Factory;
var bool bMapsAvailable;
var string IpList[8];
var int bFullGame[8];
var() localized string GameFullString;
var() localized string GameNotFullString;

event BeginPlay ()
{
	local Class C;

	Super.BeginPlay();
	if ( PlayerOwner == None )
	{
		PlayerOwner=FindPlayerOwner();
	}
	C=Class<SPServerList>(DynamicLoadObject("Spore.SPServerList",Class'Class'));
	ServerList=SPServerList(new (None,C));
	ServerList.MenuOwner=self;
	ServerList.SetupSentinel();
	ServerList.Validate();
	C=Class<SPGSpyFactory>(DynamicLoadObject("Spore.SPGSpyFactory",Class'Class'));
	Factory=SPGSpyFactory(new (None,C));
	Factory.Owner=ServerList;
	Factory.Query();
}

function DrawMenu (Canvas Canvas)
{
	local int i;
	local UWindowList List;

	MenuLength=8;
	if ( (Canvas.ClipX != ClipX) || (Canvas.ClipY != ClipY) )
	{
		if (  !Format(Canvas,Font'SPLargeFont') )
		{
			if (  !Format(Canvas,Font'SPMediumFont') )
			{
				if (  !Format(Canvas,Font'SPSmallFont') )
				{
					Log("SPMenu::DrawMenu <ERROR> Couldn't format menu! <ERROR>");
					return;
				}
			}
		}
	}
	MenuLength=0;
	MenuLength=ServerList.Count();
	List=ServerList.Next;
JL00E7:
	if ( List != None )
	{
		i++;
		MenuList[i]=UBrowserServerList(List).HostName;
		MenuList[i]=MenuList[i] $ " " $ UBrowserServerList(List).MapName;
		MenuList[i]=MenuList[i] $ " " $ string(UBrowserServerList(List).NumPlayers) $ "/" $ string(UBrowserServerList(List).MaxPlayers);
		MenuList[i]=MenuList[i] $ " " $ string(UBrowserServerList(List).Ping);
		IpList[i]=UBrowserServerList(List).IP;
		if ( UBrowserServerList(List).NumPlayers >= UBrowserServerList(List).MaxPlayers )
		{
			HelpMessage[i]=GameFullString;
			bFullGame[i]=1;
		}
		else
		{
			HelpMessage[i]=GameNotFullString;
			bFullGame[i]=0;
		}
		List=List.Next;
		goto JL00E7;
	}
	if ( MenuLength == 0 )
	{
		MenuLength=1;
		MenuList[1]=NoServersString;
		bMapsAvailable=False;
	}
	else
	{
		bMapsAvailable=True;
	}
	ServerList.PingServers(True);
	Super.DrawMenu(Canvas);
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local string StartMap;

	if (  !bMapsAvailable || (bFullGame[Selection] == 1) )
	{
		return False;
	}
	StartMap=IpList[Selection] $ "?Class=" $ string(PlayerClass);
	StartMap=StartMap $ "?Name=" $ SPPlayer(PlayerOwner).PlayerName $ "?Team=?Rate=20000";
	ChildMenu=Spawn(Class'SPMPInstructionsMenu',Owner);
	SPMPInstructionsMenu(ChildMenu).Map=StartMap;
	SubMenu(ChildMenu);
	return True;
}

function QueryFinished (UBrowserServerListFactory Fact, bool bSuccess, optional string ErrorMsg)
{
}

function Menu ExitMenu ()
{
	Factory.Shutdown();
	Super.ExitMenu();
}

defaultproperties
{
    GameFullString="This game is FULL. You can not join this game until someone leaves."
    GameNotFullString="Hit Enter to join this game."
    MaxMenuString="Another Dr Brain: Action/Reaction Server Untitled 0/16 99999"
    MenuTitle="Server List"
}