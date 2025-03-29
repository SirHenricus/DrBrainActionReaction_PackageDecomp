//================================================================================
// SPMPCharMenu.
//================================================================================
class SPMPCharMenu expands SPCharacterMenu;

var config bool bLANMenuEnabled;

event BeginPlay ()
{
	Super.BeginPlay();
	if (  !bLANMenuEnabled )
	{
		MenuLength=1;
	}
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local string Map;

	if ( Selection == 1 )
	{
		ChildMenu=Spawn(Class'SPServerListMenu',Owner);
		SPServerListMenu(ChildMenu).PlayerClass=CharacterClass;
	}
	else
	{
		if ( Selection == 2 )
		{
			ChildMenu=Spawn(Class'SPListenMenu',Owner);
			SPListenMenu(ChildMenu).PlayerClass=CharacterClass;
		}
	}
	SubMenu(ChildMenu);
	return True;
}

defaultproperties
{
    Characters(5)="SPBrainPlayer"
    MenuLength=2
    HelpMessage(1)="Use the arrow keys to pick a character. Hit Enter to continue,  or Esc to cancel."
    HelpMessage(2)="TEMP - Use to connect to LAN games"
}