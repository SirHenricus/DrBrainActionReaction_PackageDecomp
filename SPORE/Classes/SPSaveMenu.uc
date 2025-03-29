//================================================================================
// SPSaveMenu.
//================================================================================
class SPSaveMenu expands SPGameListMenu;

function bool ProcessSelection ()
{
	local Menu ChildMenu;
	local int gameOffset;
	local int gameNum;
	local string Player;
	local string saveName;
	local string MapName;

	Player=SPPlayer(PlayerOwner).PlayerName;
	gameOffset=SPPlayer(PlayerOwner).CurPlayerIndex;
	gameNum=gameOffset * 10 + Selection - 1;
	MapName=Level.Title;
	if ( Level.Minute < 10 )
	{
		saveName=MapName $ " " $ string(Level.Hour) $ ":0" $ string(Level.Minute) $ " " $ string(Level.Month) $ "/" $ string(Level.Day);
	}
	else
	{
		saveName=MapName $ " " $ string(Level.Hour) $ ":" $ string(Level.Minute) $ " " $ string(Level.Month) $ "/" $ string(Level.Day);
	}
	if ( GameNames[gameNum] ~= UnusedSaveGameString )
	{
		GameNames[gameNum]=saveName;
		bExitAllMenus=True;
		PlayerOwner.ClientMessage(" ");
		PlayerOwner.bDelayedCommand=True;
		PlayerOwner.DelayedCommand="SaveGame " $ string(gameNum);
		SaveConfig();
	}
	else
	{
		ChildMenu=Spawn(Class'SPSaveConfirmMenu',Owner);
		SPSaveConfirmMenu(ChildMenu).OldName=GameNames[gameNum];
		SPSaveConfirmMenu(ChildMenu).NewName=saveName;
		SPSaveConfirmMenu(ChildMenu).GameNumber=gameNum;
		SubMenu(ChildMenu);
	}
	return True;
}