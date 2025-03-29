//================================================================================
// SPListenMenu.
//================================================================================
class SPListenMenu expands SPMenu;

var string LastServer;
var ClientBeaconReceiver receiver;
var float ListenTimer;
var Class<PlayerPawn> PlayerClass;
var bool bMapsAvailable;

function PostBeginPlay ()
{
	local Class<ClientBeaconReceiver> C;

	Super.PostBeginPlay();
	C=Class<ClientBeaconReceiver>(DynamicLoadObject("IpDrv.ClientBeaconReceiver",Class'Class'));
	receiver=Spawn(C);
}

function Destroyed ()
{
	Super.Destroyed();
	if ( receiver != None )
	{
		receiver.Destroy();
	}
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local string StartMap;

	if (  !bMapsAvailable )
	{
		return False;
	}
	StartMap=receiver.GetBeaconAddress(Selection - 1) $ "?Class=" $ string(PlayerClass);
	StartMap=StartMap $ "?Name=" $ SPPlayer(PlayerOwner).PlayerName $ "?Team=?Rate=20000";
	ChildMenu=Spawn(Class'SPMPInstructionsMenu',Owner);
	SPMPInstructionsMenu(ChildMenu).Map=StartMap;
	SubMenu(ChildMenu);
	return True;
}

function DrawMenu (Canvas Canvas)
{
	local int i;

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
	i=0;
JL00C5:
	if ( i < 8 )
	{
		if ( (receiver.GetBeaconAddress(i) != "") && (receiver.GetBeaconText(i) != "") )
		{
			MenuLength++;
			MenuList[i + 1]=receiver.GetBeaconText(i);
		}
		i++;
		goto JL00C5;
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
	Super.DrawMenu(Canvas);
}

defaultproperties
{
    MaxMenuString="The longest name of an unreal server"
    MenuLength=8
    MenuTitle="AVAILABLE GAMES"
}