//================================================================================
// SPLoadMenu.
//================================================================================
class SPLoadMenu expands SPGameListMenu;

function bool ProcessSelection ()
{
	local int gameOffset;
	local int gameNum;

	gameOffset=SPPlayer(PlayerOwner).CurPlayerIndex;
	gameNum=gameOffset * 10 + Selection - 1;
	if ( GameNames[gameNum] ~= UnusedSaveGameString )
	{
		Log("Can't load that game - it doesn't exist");
		return False;
	}
	if ( SPConsole(PlayerOwner.Player.Console) != None )
	{
		SPConsole(PlayerOwner.Player.Console).NextLevel=GameNames[gameNum];
	}
	PlayerOwner.ClientTravel("?load=" $ string(gameNum),0,False);
	return True;
}