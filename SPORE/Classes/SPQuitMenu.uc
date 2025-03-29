//================================================================================
// SPQuitMenu.
//================================================================================
class SPQuitMenu expands SPMenu;

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
	gameOffset=Player.CurPlayerIndex * 10;
	if ( Selection == 1 )
	{
		ExitMenu();
	}
	else
	{
		if ( Selection == 2 )
		{
			bExitAllMenus=True;
			PlayerOwner.ClientMessage(" ");
			PlayerOwner.bDelayedCommand=True;
			PlayerOwner.DelayedCommand="SaveAndQuit " $ string(gameOffset + 9);
			Player.PlayerName="";
			Player.SaveConfig();
		}
	}
	return True;
}

defaultproperties
{
    MenuLength=2
    HelpMessage(1)="Don't quit the game"
    HelpMessage(2)="Really quit the game"
    MenuList(1)="No"
    MenuList(2)="Yes"
    MenuTitle="Really Quit?"
}