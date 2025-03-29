//================================================================================
// SPAdventureLinkMenu.
//================================================================================
class SPAdventureLinkMenu expands SPMenu;

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local string StartMap;

	if ( Selection == 1 )
	{
		goto JL00FB;
	}
	if ( Selection == 2 )
	{
		goto JL00FB;
	}
	if ( Selection == 3 )
	{
		goto JL00FB;
	}
	if ( Selection == 4 )
	{
		StartMap="flag.unr?Game=Spore.SPFlagGameInfo?Listen?Class=Spore.SPAlyia?Skin=";
		StartMap=StartMap $ "?Name=" $ SPPlayer(PlayerOwner).PlayerName $ "?Team=?Rate=20000";
		PlayerOwner.ClientTravel(StartMap,0,False);
	}
	else
	{
		if ( Selection == 5 )
		{
			ChildMenu=Spawn(Class'SPListenMenu',Owner);
		}
	}
JL00FB:
	SubMenu(ChildMenu);
	return True;
}

defaultproperties
{
    MenuLength=5
    HelpMessage(1)="Use the arrow keys to choose a map to play"
    HelpMessage(2)="Use the arrow keys to pick a character to play"
    HelpMessage(3)="Join the selected game"
    HelpMessage(4)="***Temp*** Start the flag capture network game"
    HelpMessage(5)="***Temp*** Join a game"
    MenuList(1)="CHOOSE MAP"
    MenuList(2)="CHOOSE CHARACTER"
    MenuList(3)="JOIN GAME"
    MenuList(4)="***Temp*** START GAME"
    MenuList(5)="***Temp*** JOIN GAME"
    MenuTitle="ADVENTURELINK"
}