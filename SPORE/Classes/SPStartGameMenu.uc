//================================================================================
// SPStartGameMenu.
//================================================================================
class SPStartGameMenu expands SPMenu;

event BeginPlay ()
{
	local string Temp;
	local SPPlayer P;

	Super.BeginPlay();
	P=FindPlayerOwner();
	if ( P == None )
	{
		Log("Error: Player is not an SPPlayer!");
		return;
	}
	Temp=P.GetPlayedLevelString(0);
	if ( Mid(Temp,P.CurPlayerIndex,1) != "X" )
	{
		Active[3]=0;
	}
	if ( P.AutoSaveFlags[P.CurPlayerIndex] ~= "None" )
	{
		Active[2]=0;
	}
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local int gameOffset;
	local SPPlayer P;
	local string MapName;
	local int MapNum;
	local SPConsole Console;

	P=SPPlayer(PlayerOwner);
	if ( P == None )
	{
		Log("Error! Using an SPMenu without a SPPlayer class!");
		return False;
	}
	gameOffset=P.CurPlayerIndex * 10;
	Console=SPConsole(PlayerOwner.Player.Console);
	if ( Console == None )
	{
		Log(string(self) $ "::ProcessSelection <ERROR> Console is not an SPConsole!!!");
		return False;
	}
	if ( Selection == 1 )
	{
		ChildMenu=Spawn(Class'SPNewCharMenu',Owner);
	}
	else
	{
		if ( Selection == 2 )
		{
			if ( P.AutoSaveFlags[P.CurPlayerIndex] ~= "Full" )
			{
				Console.NextLevel=GameNames[gameOffset + 9];
				P.ClientTravel("?load=" $ string(gameOffset + 9),0,False);
			}
			else
			{
				if ( P.AutoSaveFlags[P.CurPlayerIndex] ~= "Shallow" )
				{
					if ( Level.bEnhancedContent )
					{
						MapName=HighMapNameBase;
					}
					else
					{
						MapName=LowMapNameBase;
					}
					MapNum=P.AutoSavedLevels[P.CurPlayerIndex];
					if ( MapNum < 10 )
					{
						MapName=MapName $ "00" $ string(MapNum);
					}
					else
					{
						if ( MapNum < 100 )
						{
							MapName=MapName $ "0" $ string(MapNum);
						}
						else
						{
							MapName=MapName $ string(MapNum);
						}
					}
					Console.NextLevel=P.GetLevelName(MapNum - 1);
					P.ClientTravel(MapName $ "#?peer",0,False);
				}
			}
		}
		else
		{
			if ( Selection == 3 )
			{
				ChildMenu=Spawn(Class'SPReplayMenu',Owner);
			}
		}
	}
	SubMenu(ChildMenu);
	return True;
}

defaultproperties
{
    MenuLength=3
    HelpMessage(1)="Start playing from the beginning"
    HelpMessage(2)="Start where you left off last time"
    HelpMessage(3)="Start playing at a level you've already played before"
    MenuList(1)="New Game"
    MenuList(2)="Continue Last Game"
    MenuList(3)="Replay a Previous Level"
    MenuTitle="Start Game Menu"
}