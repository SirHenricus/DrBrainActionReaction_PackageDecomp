//================================================================================
// SPGiveUpMenu.
//================================================================================
class SPGiveUpMenu expands SPMenu;

function bool ProcessSelection ()
{
	local int i;
	local int gameOffset;
	local SPPlayer Player;

	Player=SPPlayer(PlayerOwner);
	if ( Player == None )
	{
		Log("Error! Using an SPMenu without a SPPlayer class!");
		return False;
	}
	if ( Selection == 1 )
	{
		ExitMenu();
	}
	else
	{
		if ( Selection == 2 )
		{
			Player.GiveUp();
		}
	}
	return True;
}

defaultproperties
{
    MenuLength=2
    MenuList(1)="No"
    MenuList(2)="Yes"
    MenuTitle="Really skip this level?"
}