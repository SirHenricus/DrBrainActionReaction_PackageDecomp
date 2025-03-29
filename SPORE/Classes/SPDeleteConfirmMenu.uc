//================================================================================
// SPDeleteConfirmMenu.
//================================================================================
class SPDeleteConfirmMenu expands SPMenu;

var() localized string WarningMessage;
var string PlayerName;
var int PlayerNum;
var SPSignInMenu SIMenu;
var bool bSetup;

event BeginPlay ()
{
	Super.BeginPlay();
	Selection=6;
}

function Setup ()
{
	if (  !bSetup )
	{
		if ( PlayerName != "" )
		{
			MenuList[6]=MenuList[6] $ " " $ PlayerName;
			MenuList[7]=MenuList[7] $ " " $ PlayerName;
			bSetup=True;
		}
	}
}

function bool ProcessSelection ()
{
	local SPPlayer P;
	local int i;

	P=SPPlayer(PlayerOwner);
	if ( Selection == 6 )
	{
		ExitMenu();
	}
	else
	{
		if ( Selection == 7 )
		{
			if ( SIMenu == None )
			{
				Log(string(self) $ "::ProcessSelection <ERROR> Sign-In Menu was not set properly!!!");
				return True;
			}
			if ( P == None )
			{
				Log(string(self) $ "::ProcessSelection <ERROR> PlayerOwner is not an SPPlayer!!!");
				return True;
			}
			SIMenu.Active[PlayerNum + 1]=0;
			SIMenu.Active[10]=1;
			SIMenu.PlayerNames[PlayerNum]="---";
			i=0;
JL0123:
			if ( i < 10 )
			{
				GameNames[PlayerNum * 10 + i]=UnusedSaveGameString;
				i++;
				goto JL0123;
			}
			i=0;
JL015C:
			if ( i < 60 )
			{
				P.MarkLevelUnplayed(i,PlayerNum);
				P.MarkLevelUnfinished(i,PlayerNum);
				i++;
				goto JL015C;
			}
			if ( P.CurPlayerIndex == SIMenu.Selection - 1 )
			{
				P.PlayerName=SIMenu.PlayerNames[0];
				P.PlayerReplicationInfo.PlayerName=P.PlayerName;
				P.CurPlayerIndex=0;
			}
			SIMenu.SaveConfig();
			P.SaveConfig();
			SaveConfig();
			ExitMenu();
		}
	}
	return True;
}

function MenuProcessInput (byte KeyNum, byte ActionNum)
{
	if ( (KeyNum == 38) || (KeyNum == 40) )
	{
		PlaySelectSound();
		if ( Selection == 6 )
		{
			Selection=7;
		}
		else
		{
			Selection=6;
		}
	}
	else
	{
		Super.MenuProcessInput(KeyNum,ActionNum);
	}
}

function DrawMenu (Canvas C)
{
	if (  !bSetup )
	{
		Setup();
	}
	Super.DrawMenu(C);
	DrawWarning(C);
}

function DrawWarning (Canvas C)
{
	local float X;
	local float Y;
	local float W;
	local float H;

	W=C.ClipX * 0.60;
	H=C.ClipY * 0.40;
	X=(C.ClipX - W) / 2;
	Y=C.ClipY * 0.20;
	DrawTextBox(WarningMessage,X,Y,W,H,C);
}

function DrawTextBox (string Text, float X, float Y, float W, float H, Canvas C)
{
	local float xSize;
	local float ySize;
	local int saveOrgX;
	local int saveOrgY;
	local int saveClipX;
	local int saveClipY;

	saveOrgX=C.OrgX;
	saveOrgY=C.OrgY;
	saveClipX=C.ClipX;
	saveClipY=C.ClipY;
	C.SetOrigin(X,Y);
	C.SetClip(W,H);
	C.bCenter=True;
	SetFontBrightness(C,True);
	C.Font=Font'SPLargeFont';
	C.StrLen(Text,xSize,ySize);
	if ( (xSize > W) || (ySize > H) )
	{
		C.Font=Font'SPMediumFont';
		C.StrLen(Text,xSize,ySize);
		if ( (xSize > W) || (ySize > H) )
		{
			C.Font=Font'SPSmallFont';
		}
	}
	C.SetPos(0.00,0.00);
	C.DrawText(Text,False);
	C.SetOrigin(saveOrgX,saveOrgY);
	C.SetClip(saveClipX,saveClipY);
	C.bCenter=False;
}

defaultproperties
{
    WarningMessage="Are you sure you want to delete this player and all saved games for this player?"
    MaxMenuString="Don't Delete AnthonyJohnCuccia"
    MenuLength=7
    MenuList(6)="Don't Delete"
    MenuList(7)="Delete"
}