//================================================================================
// SPMainMenu.
//================================================================================
class SPMainMenu expands SPMenu;

event BeginPlay ()
{
	local SPPlayer Player;

	Super.BeginPlay();
	Player=FindPlayerOwner();
	if ( Player == None )
	{
		return;
	}
	if ( Player.PlayerName == "" )
	{
		Active[2]=0;
		Active[3]=0;
		Active[4]=0;
		Active[6]=0;
		Active[7]=0;
	}
	else
	{
		if ( Player.GetLevelIndex() == -1 )
		{
			Active[7]=0;
			Active[3]=0;
		}
		if ( Player.GetLevelIndex() == 44 )
		{
			Active[7]=0;
		}
		if (  !HasSavedGames(Player.CurPlayerIndex) )
		{
			Active[4]=0;
		}
	}
}

function bool HasSavedGames (int playerIndex)
{
	local int i;
	local int startIndex;

	startIndex=10 * playerIndex;
	i=startIndex;
JL001A:
	if ( i < startIndex + 10 )
	{
		if ( (GameNames[i] ~= UnusedSaveGameString) || (GameNames[i] == "") )
		{
			goto JL005B;
		}
		return True;
JL005B:
		i++;
		goto JL001A;
	}
	return False;
}

function PlayerSignedIn ()
{
	local SPPlayer P;

	P=SPPlayer(PlayerOwner);
	if ( P == None )
	{
		Log(string(self) $ "::PlayerSignedIn <ERROR> Owner not an SPPlayer!!!");
		return;
	}
	Active[2]=1;
	Active[6]=1;
	if ( P.GetLevelIndex() != -1 )
	{
		Active[3]=1;
	}
	else
	{
		Active[3]=0;
	}
	if ( HasSavedGames(P.CurPlayerIndex) )
	{
		Active[4]=1;
	}
	else
	{
		Active[4]=0;
	}
	ClipX=-1;
	ClipY=-1;
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local int i;
	local SPPlayer Player;
	local string StartMap;

	if ( Active[Selection] == 0 )
	{
		return False;
	}
	Player=SPPlayer(PlayerOwner);
	if ( Player == None )
	{
		Log("Error! Using an SPMenu without a SPPlayer class!");
		return False;
	}
	if ( Selection == 1 )
	{
		ChildMenu=Spawn(Class'SPSignInMenu',Owner);
	}
	else
	{
		if ( Selection == 2 )
		{
			ChildMenu=Spawn(Class'SPStartGameMenu',Owner);
		}
		else
		{
			if ( Selection == 3 )
			{
				ChildMenu=Spawn(Class'SPSaveMenu',Owner);
			}
			else
			{
				if ( Selection == 4 )
				{
					ChildMenu=Spawn(Class'SPLoadMenu',Owner);
				}
				else
				{
					if ( Selection == 5 )
					{
						ChildMenu=Spawn(Class'SPSettingsMenu',Owner);
					}
					else
					{
						if ( Selection == 6 )
						{
							ChildMenu=Spawn(Class'SPMPCharMenu',Owner);
						}
						else
						{
							if ( Selection == 7 )
							{
								ChildMenu=Spawn(Class'SPGiveUpMenu',Owner);
							}
							else
							{
								if ( Selection == 8 )
								{
									ChildMenu=Spawn(Class'SPCreditsMenu',Owner);
								}
								else
								{
									if ( Selection == 9 )
									{
										bExitAllMenus=True;
										PlayerOwner.ConsoleCommand("CDTRACK 0");
										PlayerOwner.ClientMessage(" ");
										PlayerOwner.bDelayedCommand=True;
										PlayerOwner.DelayedCommand="AutoSaveAndQuit";
									}
									else
									{
										ExitMenu();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	SubMenu(ChildMenu);
	return True;
}

defaultproperties
{
    DisabledHelpMessage(2)="This is disabled until you sign in"
    DisabledHelpMessage(3)="This is disabled until you sign in"
    DisabledHelpMessage(4)="This is disabled until you sign in"
    DisabledHelpMessage(5)="This is disabled until you sign in"
    DisabledHelpMessage(6)="This is disabled until you sign in"
    MenuLength=9
    HelpMessage(1)="Select your name from (or add your name to) the player list"
    HelpMessage(2)="Start a new game"
    HelpMessage(3)="Save current game"
    HelpMessage(4)="Load a saved game"
    HelpMessage(5)="Change game settings"
    HelpMessage(6)="Join an internet game"
    HelpMessage(7)="Skip to the next level (you can replay this one later)"
    HelpMessage(8)="See who made this cool game!"
    HelpMessage(9)="Quit the game"
    MenuList(1)="SIGN IN"
    MenuList(2)="START GAME"
    MenuList(3)="SAVE"
    MenuList(4)="LOAD"
    MenuList(5)="SETTINGS"
    MenuList(6)="ADVENTURELINK"
    MenuList(7)="GIVE UP"
    MenuList(8)="CREDITS"
    MenuList(9)="QUIT"
    MenuTitle="MAIN MENU"
}