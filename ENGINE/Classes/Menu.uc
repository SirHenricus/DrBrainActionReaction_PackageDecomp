//================================================================================
// Menu.
//================================================================================
class Menu expands Actor
	native;

var Menu ParentMenu;
var int Selection;
var() int MenuLength;
var bool bConfigChanged;
var bool bExitAllMenus;
var PlayerPawn PlayerOwner;
var() localized string HelpMessage[24];
var() localized string MenuList[24];
var() localized string LeftString;
var() localized string RightString;
var() localized string CenterString;
var() localized string EnabledString;
var() localized string DisabledString;
var() localized string MenuTitle;
var() localized string YesString;
var() localized string NoString;

function bool ProcessSelection ();

function bool ProcessLeft ();

function bool ProcessRight ();

function bool ProcessYes ();

function bool ProcessNo ();

function SaveConfigs ();

function PlaySelectSound ();

function PlayModifySound ();

function PlayEnterSound ();

function ProcessMenuInput (coerce string InputString);

function ProcessMenuUpdate (coerce string InputString);

function ProcessMenuEscape ();

function ProcessMenuKey (int KeyNo, string KeyName);

function MenuTick (float DeltaTime);

function MenuInit ();

function DrawMenu (Canvas Canvas);

function ExitAllMenus ()
{
JL0000:
	if ( HUD(Owner).MainMenu != None )
	{
		HUD(Owner).MainMenu.ExitMenu();
		goto JL0000;
	}
}

function Menu ExitMenu ()
{
	HUD(Owner).MainMenu=ParentMenu;
	if ( bConfigChanged )
	{
		SaveConfigs();
	}
	if ( ParentMenu == None )
	{
		PlayerOwner.bShowMenu=False;
		PlayerOwner.Player.Console.GotoState('None');
		if ( Level.NetMode == 0 )
		{
			PlayerOwner.SetPause(False);
		}
	}
	Destroy();
}

function SetFontBrightness (Canvas Canvas, bool bBright)
{
	if ( bBright )
	{
		Canvas.DrawColor.R=255;
		Canvas.DrawColor.G=255;
		Canvas.DrawColor.B=255;
	}
	else
	{
		Canvas.DrawColor=Canvas.Default.DrawColor;
	}
}

function MenuProcessInput (byte KeyNum, byte ActionNum)
{
	if ( KeyNum == 27 )
	{
		PlayEnterSound();
		ExitMenu();
		return;
	}
	else
	{
		if ( KeyNum == 38 )
		{
			PlaySelectSound();
			Selection--;
			if ( Selection < 1 )
			{
				Selection=MenuLength;
			}
		}
		else
		{
			if ( KeyNum == 40 )
			{
				PlaySelectSound();
				Selection++;
				if ( Selection > MenuLength )
				{
					Selection=1;
				}
			}
			else
			{
				if ( KeyNum == 13 )
				{
					bConfigChanged=True;
					if ( ProcessSelection() )
					{
						PlayEnterSound();
					}
				}
				else
				{
					if ( KeyNum == 37 )
					{
						bConfigChanged=True;
						if ( ProcessLeft() )
						{
							PlayModifySound();
						}
					}
					else
					{
						if ( KeyNum == 39 )
						{
							bConfigChanged=True;
							if ( ProcessRight() )
							{
								PlayModifySound();
							}
						}
						else
						{
							if ( Chr(KeyNum) ~= Left(YesString,1) )
							{
								bConfigChanged=True;
								if ( ProcessYes() )
								{
									PlayModifySound();
								}
							}
							else
							{
								if ( Chr(KeyNum) ~= Left(NoString,1) )
								{
									bConfigChanged=True;
									if ( ProcessNo() )
									{
										PlayModifySound();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if ( bExitAllMenus )
	{
		ExitAllMenus();
	}
}

defaultproperties
{
    Selection=1
    HelpMessage(1)="This menu has not yet been implemented."
    LeftString="Left"
    RightString="Right"
    CenterString="Center"
    EnabledString="Enabled"
    DisabledString="Disabled"
    YesString="yes"
    NoString="no"
    bHidden=True
}