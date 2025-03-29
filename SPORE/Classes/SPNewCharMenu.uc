//================================================================================
// SPNewCharMenu.
//================================================================================
class SPNewCharMenu expands SPCharacterMenu;

function bool ProcessSelection ()
{
	local string Map;

	if ( Selection == 1 )
	{
		bExitAllMenus=True;
		if ( Level.bEnhancedContent )
		{
			Map=HighMapNameBase $ "001" $ "?Class=" $ string(CharacterClass);
		}
		else
		{
			Map=LowMapNameBase $ "001" $ "?Class=" $ string(CharacterClass);
		}
		if ( SPConsole(PlayerOwner.Player.Console) != None )
		{
			SPConsole(PlayerOwner.Player.Console).NextLevel=GetFirstMapName();
		}
		PlayerOwner.ClientTravel(Map,0,False);
	}
}

function string GetFirstMapName ()
{
	local SPPlayer P;
	local int i;

	foreach AllActors(Class'SPPlayer',P)
	{
		goto JL0014;
	}
	if ( P == None )
	{
		Log(string(self) $ "::FindNextLevelName <ERROR> Couldn't find SPPlayer!!!");
		return "Unknown Map";
	}
	return P.LevelNames[0];
}

defaultproperties
{
    HelpMessage(1)="Use the arrow keys to pick a character. Hit Enter when ready, or Esc to cancel."
    MenuList(1)="Start New Game"
}