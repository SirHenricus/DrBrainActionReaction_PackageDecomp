//================================================================================
// SPGameListMenu.
//================================================================================
class SPGameListMenu expands SPMenu;

event BeginPlay ()
{
	local int gameOffset;
	local int i;

	Super.BeginPlay();
	PlayerOwner=FindPlayerOwner();
	if ( PlayerOwner != None )
	{
		gameOffset=SPPlayer(PlayerOwner).CurPlayerIndex;
	}
	else
	{
		Log("SPGameListMenu::BeginPlay <ERROR> No owner was set to an SPPlayer! <ERROR>");
		return;
	}
	i=0;
JL0090:
	if ( i < 10 )
	{
		if ( GameNames[gameOffset * 10 + i] == "" )
		{
			GameNames[gameOffset * 10 + i]=UnusedSaveGameString;
		}
		i++;
		goto JL0090;
	}
	UpdateGameList();
}

function DrawMenu (Canvas Canvas)
{
	UpdateGameList();
	Super.DrawMenu(Canvas);
}

function UpdateGameList ()
{
	local int gameOffset;
	local int i;

	gameOffset=SPPlayer(PlayerOwner).CurPlayerIndex;
	i=1;
JL0020:
	if ( i <= 9 )
	{
		MenuList[i]=string(i) $ ". " $ GameNames[gameOffset * 10 + i - 1];
		i++;
		goto JL0020;
	}
}

defaultproperties
{
    MaxMenuString="LongLevelName 12:12 12/12"
    MenuLength=8
    MenuTitle="LIST OF GAMES"
}