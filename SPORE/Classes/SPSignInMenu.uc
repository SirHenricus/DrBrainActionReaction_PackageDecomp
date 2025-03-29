//================================================================================
// SPSignInMenu.
//================================================================================
class SPSignInMenu expands SPMenu;

var globalconfig string PlayerNames[10];
var() localized string ThisIsYouHelpMessage;
var string NormalHelpMessage;

event BeginPlay ()
{
	local int i;
	local string Player;

	Super.BeginPlay();
	PlayerOwner=FindPlayerOwner();
	if ( (PlayerOwner != None) && PlayerOwner.IsA('SPPlayer') )
	{
		Player=SPPlayer(PlayerOwner).PlayerName;
	}
	else
	{
		Log("SPSignInMenu::BeginPlay <ERROR> PlayerOwner is not an SPPlayer! <ERROR>");
	}
	i=0;
JL00A1:
	if ( i < 9 )
	{
		if ( (PlayerNames[i] == "") || (PlayerNames[i] ~= "---") )
		{
			Active[i + 1]=0;
		}
		i++;
		goto JL00A1;
	}
	CheckNumPlayers();
	i=0;
JL00FD:
	if ( i < 10 )
	{
		if ( PlayerNames[i] ~= Player )
		{
			Selection=i + 1;
		}
		else
		{
			i++;
			goto JL00FD;
		}
	}
	NormalHelpMessage=HelpMessage[1];
}

function AdjustHelpStrings ()
{
	local int i;

	if ( SPPlayer(PlayerOwner) == None )
	{
		Log(string(self) $ "::AdjustHelpStrings <ERROR> PlayerOwner is not an SPPlayer!!!");
		return;
	}
	i=1;
JL005E:
	if ( i < 9 )
	{
		if ( MenuList[i] ~= SPPlayer(PlayerOwner).PlayerName )
		{
			HelpMessage[i]=ThisIsYouHelpMessage;
		}
		else
		{
			HelpMessage[i]=NormalHelpMessage;
		}
		i++;
		goto JL005E;
	}
}

function UpdateNames ()
{
	local int i;

	i=0;
JL0007:
	if ( i <= 8 )
	{
		MenuList[i + 1]=PlayerNames[i];
		i++;
		goto JL0007;
	}
}

function CheckNumPlayers ()
{
	local int i;

	Active[10]=0;
	i=1;
JL0011:
	if ( i <= 9 )
	{
		if ( Active[i] == 0 )
		{
			Active[10]=1;
		}
		else
		{
			i++;
			goto JL0011;
		}
	}
}

function SetPlayerName (int Index, string Name)
{
	PlayerNames[Index]=Name;
	Active[Index + 1]=1;
	Selection=Index + 1;
	CheckNumPlayers();
	SaveConfig();
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local int i;

	if ( Selection == 10 )
	{
		ChildMenu=Spawn(Class'SPNameEnterMenu',Owner);
		i=0;
JL0026:
		if ( i < 9 )
		{
			if ( Active[i + 1] == 0 )
			{
				SPNameEnterMenu(ChildMenu).playerIndex=i;
			}
			else
			{
				i++;
				goto JL0026;
			}
		}
		SubMenu(ChildMenu);
		return True;
	}
	SPPlayer(PlayerOwner).PlayerName=PlayerNames[Selection - 1];
	SPPlayer(PlayerOwner).CurPlayerIndex=Selection - 1;
	SPPlayer(PlayerOwner).PlayerReplicationInfo.PlayerName=SPPlayer(PlayerOwner).PlayerName;
	SPPlayer(PlayerOwner).SaveConfig();
	if ( SPMainMenu(ParentMenu) != None )
	{
		SPMainMenu(ParentMenu).PlayerSignedIn();
	}
	ExitMenu();
	return True;
}

function MenuProcessInput (byte Key, byte Action)
{
	local int i;
	local int gameOffset;
	local SPPlayer P;
	local Menu ChildMenu;

	Super.MenuProcessInput(Key,Action);
	if ( Selection == 10 )
	{
		return;
	}
	P=SPPlayer(PlayerOwner);
	if ( P == None )
	{
		Log("SPSignInMenu::MenuProcessInput <Error>: Player is not an SPPlayer!");
		return;
	}
	if ( Key == 46 )
	{
		if ( Selection != P.CurPlayerIndex + 1 )
		{
			ChildMenu=Spawn(Class'SPDeleteConfirmMenu',Owner);
			SPDeleteConfirmMenu(ChildMenu).PlayerName=PlayerNames[Selection - 1];
			SPDeleteConfirmMenu(ChildMenu).PlayerNum=Selection - 1;
			SPDeleteConfirmMenu(ChildMenu).SIMenu=self;
			SubMenu(ChildMenu);
		}
	}
}

function DrawMenu (Canvas Canvas)
{
	UpdateNames();
	AdjustHelpStrings();
	Super.DrawMenu(Canvas);
}

defaultproperties
{
    ThisIsYouHelpMessage="You are signed in as this player, and can't delete it."
    MaxMenuString="ANTHONY JOHN CUCCIA"
    MenuLength=10
    HelpMessage(1)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(2)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(3)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(4)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(5)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(6)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(7)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(8)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(9)="Hit Enter to sign in as this player, or the Delete key to delete this player"
    HelpMessage(10)="Hit Enter to create a new player"
    MenuList(10)="Create New Player"
    MenuTitle="PLAYER LIST"
}