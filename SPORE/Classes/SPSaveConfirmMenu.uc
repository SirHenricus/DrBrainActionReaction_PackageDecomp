//================================================================================
// SPSaveConfirmMenu.
//================================================================================
class SPSaveConfirmMenu expands SPMenu;

var string OldName;
var string NewName;
var int GameNumber;
var bool bSetup;

event BeginPlay ()
{
	Super.BeginPlay();
	Selection=6;
}

function Setup ()
{
	if ( (OldName != "") && (NewName != "") )
	{
		bSetup=True;
		MenuList[2]=OldName;
		MenuList[4]=NewName;
	}
	else
	{
		Log("SPSaveConfirmMenu::SetUp <Failed: Will try again>");
	}
}

function bool ProcessSelection ()
{
	if ( Selection == 6 )
	{
		ExitMenu();
	}
	else
	{
		if ( Selection == 7 )
		{
			GameNames[GameNumber]=NewName;
			bExitAllMenus=True;
			PlayerOwner.ClientMessage(" ");
			PlayerOwner.bDelayedCommand=True;
			PlayerOwner.DelayedCommand="SaveGame " $ string(GameNumber);
			SaveConfig();
			ExitMenu();
		}
	}
	return True;
}

function MenuProcessInput (byte KeyNum, byte ActionNum)
{
	if ( (KeyNum == 38) || (KeyNum == 40) )
	{
		PlaySelectSound();
		if ( Selection == 6 )
		{
			Selection=7;
		}
		else
		{
			Selection=6;
		}
	}
	else
	{
		Super.MenuProcessInput(KeyNum,ActionNum);
	}
}

function DrawMenu (Canvas Canvas)
{
	if (  !bSetup )
	{
		Setup();
	}
	Super.DrawMenu(Canvas);
}

defaultproperties
{
    MenuLength=7
    MenuList(1)="Replace"
    MenuList(3)="With"
    MenuList(6)="No"
    MenuList(7)="Yes"
    MenuTitle="Do You Really Want To:"
}