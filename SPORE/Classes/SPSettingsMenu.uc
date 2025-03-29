//================================================================================
// SPSettingsMenu.
//================================================================================
class SPSettingsMenu expands SPMenu;

function bool ProcessSelection ()
{
	local Menu ChildMenu;

	if ( Selection == 1 )
	{
		ChildMenu=Spawn(Class'SPControlsMenu',Owner);
	}
	else
	{
		if ( Selection == 2 )
		{
			ChildMenu=Spawn(Class'SPAVMenu',Owner);
		}
	}
	SubMenu(ChildMenu);
	return True;
}

defaultproperties
{
    MenuLength=2
    HelpMessage(1)="Set up the keyboard the way you want it"
    HelpMessage(2)="Change the way the game looks and sounds"
    MenuList(1)="CONTROLS"
    MenuList(2)="GRAPHICS AND SOUND"
    MenuTitle="CHANGE SETTINGS"
}