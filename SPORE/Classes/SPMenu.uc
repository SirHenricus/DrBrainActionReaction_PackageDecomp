//================================================================================
// SPMenu.
//================================================================================
class SPMenu expands Menu
	native;

var() localized string DisabledHelpMessage[24];
var int Active[24];
var globalconfig string GameNames[100];
var() globalconfig string HighMapNameBase;
var() globalconfig string LowMapNameBase;
var Font CurFont;
var int FontHeight;
var int ClipX;
var int ClipY;
var int ListLeft;
var int ListTop;
var int ListSpacing;
var int HelpLeft;
var int HelpTop;
var int HelpHeight;
var int HelpWidth;
var int TitleLeft;
var int TitleTop;
var int ValueStartX;
var int MarginX;
var int MarginY;
var int HelpClipX;
var int HelpClipY;
var Font HelpFont;
var() float MarginPercentX;
var() float MarginPercentY;
var() float HelpWidthPercent;
var() float HelpHeightPercent;
var() localized string MenuValues[24];
var() localized string MaxMenuString;
var() localized string UnusedSaveGameString;
var() localized string NoServersString;

native final function CanvasClearZ (Canvas C);

event BeginPlay ()
{
	local int i;

	Super.BeginPlay();
	i=0;
JL000D:
	if ( i < 24 )
	{
		Active[i]=1;
		i++;
		goto JL000D;
	}
}

function DrawMenu (Canvas Canvas)
{
	local int StartX;
	local int StartY;
	local int Spacing;
	local int testCount;

	Canvas.Style=1;
	DrawBackGround(Canvas);
	if ( (Canvas.ClipX != ClipX) || (Canvas.ClipY != ClipY) )
	{
		if (  !Format(Canvas,Font'SPLargeFont') )
		{
			if (  !Format(Canvas,Font'SPMediumFont') )
			{
				if (  !Format(Canvas,Font'SPSmallFont') )
				{
					Log("SPMenu::DrawMenu <ERROR> Couldn't format menu! <ERROR>");
					return;
				}
			}
		}
	}
	if ( Active[Selection] == 0 )
	{
JL00DC:
		Selection++;
		if ( Selection > MenuLength )
		{
			Selection=1;
		}
		testCount++;
		if (! (Active[Selection] == 1) || (testCount > MenuLength) ) goto JL00DC;
	}
	DrawTitle(Canvas);
	DrawListCentered(Canvas);
	DrawValues(Canvas);
	DrawHelpPanel(Canvas);
}

function DrawBackGround (Canvas Canvas)
{
	local int X;
	local int Y;
	local int xSize;
	local int ySize;
	local float x2;
	local float y2;

	X=0.01 * Canvas.ClipX;
	Y=0.01 * Canvas.ClipY;
	xSize=Canvas.ClipX - 2 * X;
	ySize=Canvas.ClipY - 2 * Y;
	x2=X + xSize / 2;
	y2=Y + ySize / 2;
	Canvas.SetPos(X,Y);
	Canvas.DrawRect(Texture'LargeBack1',xSize / 2,ySize / 2);
	Canvas.SetPos(x2,Y);
	Canvas.DrawRect(Texture'LargeBack2',xSize / 2,ySize / 2);
	Canvas.SetPos(X,y2);
	Canvas.DrawRect(Texture'LargeBack3',xSize / 2,ySize / 2);
	Canvas.SetPos(x2,y2);
	Canvas.DrawRect(Texture'LargeBack4',xSize / 2,ySize / 2);
}

function DrawListCentered (Canvas Canvas)
{
	local int i;
	local int oldStyle;
	local int numDrawn;

	oldStyle=Canvas.Style;
	Canvas.Font=CurFont;
	i=0;
JL0030:
	if ( i < MenuLength )
	{
		if ( Active[i + 1] == 1 )
		{
			SetFontBrightness(Canvas,i == Selection - 1);
			Canvas.SetPos(ListLeft,ListTop + ListSpacing * numDrawn + (ListSpacing - FontHeight) / 2);
			if ( Active[i + 1] == 0 )
			{
				Canvas.Style=3;
			}
			Canvas.DrawText(MenuList[i + 1],False);
			Canvas.Style=oldStyle;
			numDrawn++;
		}
		i++;
		goto JL0030;
	}
	DrawSelectionIndicator(Canvas);
	Canvas.DrawColor=Canvas.Default.DrawColor;
}

function DrawSelectionIndicator (Canvas C)
{
	local int X;
	local int Y;
	local int oldStyle;
	local int i;
	local int Count;

	i=1;
JL0007:
	if ( i < Selection )
	{
		if ( Active[i] == 1 )
		{
			Count++;
		}
		i++;
		goto JL0007;
	}
	oldStyle=C.Style;
	C.Style=2;
	SetFontBrightness(C,True);
	X=ListLeft - 1.50 * FontHeight;
	Y=ListTop + ListSpacing * Count + (ListSpacing - FontHeight) / 2;
	C.SetPos(X,Y);
	C.DrawRect(Texture'MenuButton',FontHeight,FontHeight);
	C.Style=oldStyle;
}

function DrawValues (Canvas Canvas)
{
	local int i;
	local int oldStyle;
	local int numDrawn;

	oldStyle=Canvas.Style;
	Canvas.Font=CurFont;
	i=0;
JL0030:
	if ( i < MenuLength )
	{
		if ( Active[i + 1] == 1 )
		{
			SetFontBrightness(Canvas,i == Selection - 1);
			Canvas.SetPos(ValueStartX,ListTop + ListSpacing * numDrawn + (ListSpacing - FontHeight) / 2);
			if ( Active[i + 1] == 0 )
			{
				Canvas.Style=3;
			}
			Canvas.DrawText(MenuValues[i + 1],False);
			Canvas.Style=oldStyle;
			numDrawn++;
		}
		i++;
		goto JL0030;
	}
	Canvas.DrawColor=Canvas.Default.DrawColor;
}

function DrawHelpPanel (Canvas C)
{
	local float saveOriginX;
	local float SaveOriginY;
	local float saveClipX;
	local float saveClipY;
	local float xSize;
	local float ySize;
	local bool bFontFits;
	local int i;
	local float X;
	local float Y;
	local float W;
	local float H;

	if ( HelpMessage[Selection] == "" )
	{
		return;
	}
	saveOriginX=C.OrgX;
	SaveOriginY=C.OrgY;
	saveClipX=C.ClipX;
	saveClipY=C.ClipY;
	C.SetPos(HelpLeft,HelpTop);
	C.DrawRect(Texture'MenuBox',HelpWidth,HelpHeight);
	C.SetPos(0.00,0.00);
	X=HelpLeft;
	Y=HelpTop;
	W=HelpWidth;
	H=HelpHeight;
	X += 0.04 * HelpWidth;
	Y += 0.04 * HelpHeight;
	W -= 0.08 * HelpWidth;
	H -= 0.08 * HelpHeight;
	C.bCenter=True;
	C.SetOrigin(X,Y);
	C.SetClip(W,H);
	C.SetPos(0.00,0.00);
	C.Style=1;
	if ( (HelpClipX != saveClipX) || (HelpClipY != saveClipY) )
	{
		HelpClipX=saveClipX;
		HelpClipY=saveClipY;
		bFontFits=True;
		C.Font=Font'MBoxFontLarge';
		HelpFont=C.Font;
		i=0;
JL0216:
		if ( i < 24 )
		{
			C.StrLen(HelpMessage[i],xSize,ySize);
			if ( (xSize > HelpWidth) || (ySize > HelpHeight) )
			{
				bFontFits=False;
			}
			else
			{
				i++;
				goto JL0216;
			}
		}
		if (  !bFontFits )
		{
			bFontFits=True;
			C.Font=Font'SPMediumFont';
			HelpFont=C.Font;
			i=0;
JL02BC:
			if ( i < 24 )
			{
				C.StrLen(HelpMessage[i],xSize,ySize);
				if ( (xSize > HelpWidth) || (ySize > HelpHeight) )
				{
					bFontFits=False;
				}
				else
				{
					i++;
					goto JL02BC;
				}
			}
		}
		if (  !bFontFits )
		{
			bFontFits=True;
			C.Font=Font'SPSmallFont';
			HelpFont=C.Font;
			i=0;
JL0362:
			if ( i < 24 )
			{
				C.StrLen(HelpMessage[i],xSize,ySize);
				if ( (xSize > HelpWidth) || (ySize > HelpHeight) )
				{
					bFontFits=False;
				}
				else
				{
					i++;
					goto JL0362;
				}
			}
		}
		if (  !bFontFits )
		{
			Log(string(self) $ "::DrawHelpPanel <ERROR> Couldn't fit help!!!");
		}
	}
	C.Font=HelpFont;
	SetFontBrightness(C,True);
	if ( Selection < 20 )
	{
		if ( Active[Selection] == 1 )
		{
			C.DrawText(HelpMessage[Selection],False);
		}
		else
		{
			C.DrawText(DisabledHelpMessage[Selection],False);
		}
	}
	SetFontBrightness(C,False);
	C.SetOrigin(saveOriginX,SaveOriginY);
	C.SetClip(saveClipX,saveClipY);
}

function DrawTitle (Canvas Canvas)
{
	Canvas.Font=CurFont;
	Canvas.SetPos(TitleLeft,TitleTop);
	Canvas.DrawText(MenuTitle,False);
}

function PlayEnterSound ()
{
	if ( PlayerOwner != None )
	{
		PlayerOwner.PlaySound(Sound'enter',3);
	}
}

function PlaySelectSound ()
{
	if ( PlayerOwner != None )
	{
		PlayerOwner.PlaySound(Sound'toggle_t',3);
	}
}

function bool Format (Canvas C, Font F)
{
	local int i;
	local float xMax;
	local float yMax;
	local float xSize;
	local float ySize;
	local int StartX;
	local int StartY;
	local int listMinY;
	local int listMaxY;
	local int titleHeight;

	CurFont=F;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	C.Font=CurFont;
	MarginX=ClipX * MarginPercentX;
	MarginY=ClipY * MarginPercentY;
	HelpWidth=ClipX * HelpWidthPercent;
	HelpHeight=ClipY * HelpHeightPercent;
	C.StrLen("FontHeight Test",xSize,ySize);
	FontHeight=ySize;
	C.StrLen(MenuTitle,xSize,ySize);
	TitleTop=MarginY;
	TitleLeft=MarginX + (ClipX - xSize - 2 * MarginX) / 2;
	titleHeight=ySize;
	HelpTop=ClipY - MarginY - HelpHeight;
	HelpLeft=MarginX + (ClipX - HelpWidth - 2 * MarginX) / 2;
	listMinY=TitleTop + 1.50 * FontHeight;
	listMaxY=HelpTop - FontHeight / 2;
	xMax=0.00;
	i=0;
JL01B0:
	if ( i < MenuLength )
	{
		C.StrLen(MenuList[i + 1],xSize,ySize);
		if ( xSize > xMax )
		{
			xMax=xSize;
		}
		i++;
		goto JL01B0;
	}
	if ( MaxMenuString != "" )
	{
		C.StrLen(MaxMenuString,xSize,ySize);
		if ( xSize > xMax )
		{
			xMax=xSize;
		}
	}
	xMax += FontHeight * 1.50;
	ListSpacing=(listMaxY - listMinY) / MenuLength;
	ListLeft=MarginX + 1.50 * FontHeight + (ClipX - xMax - 2 * MarginX) / 2;
	ListTop=(listMaxY - listMinY - MenuLength * ListSpacing) / 2 + listMinY;
	ValueStartX=0.60 * ClipX;
	if ( ListSpacing < 1.20 * FontHeight )
	{
		return False;
	}
	if ( ListLeft - 1.50 * FontHeight < MarginX )
	{
		return False;
	}
	if ( ListTop < listMinY )
	{
		return False;
	}
	if ( TitleLeft < MarginX )
	{
		return False;
	}
	if ( titleHeight > FontHeight )
	{
		return False;
	}
	if ( False )
	{
		Log("Font:        " $ string(CurFont));
		Log("FontHeight:  " $ string(FontHeight));
		Log("TitleTop:    " $ string(TitleTop));
		Log("TitleLeft:   " $ string(TitleLeft));
		Log("ListMinY:    " $ string(listMinY));
		Log("ListMaxY:    " $ string(listMaxY));
		Log("ListLeft:    " $ string(ListLeft));
		Log("ListTop:     " $ string(ListTop));
		Log("ListSpacing: " $ string(ListSpacing));
		Log("HelpLeft:    " $ string(HelpLeft));
		Log("HelpTop:     " $ string(HelpTop));
		Log("");
	}
	return True;
}

function SubMenu (Menu Child)
{
	if ( Child != None )
	{
		HUD(Owner).MainMenu=Child;
		Child.ParentMenu=self;
		Child.PlayerOwner=PlayerOwner;
	}
}

function SPPlayer FindPlayerOwner ()
{
	local Actor tempOwner;

	tempOwner=Owner;
JL000B:
	if ( tempOwner != None )
	{
		if ( tempOwner.IsA('SPPlayer') )
		{
			goto JL0044;
		}
		tempOwner=tempOwner.Owner;
		goto JL000B;
	}
JL0044:
	return SPPlayer(tempOwner);
}

function MenuProcessInput (byte KeyNum, byte ActionNum)
{
	local int testCount;

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
			testCount=0;
JL003A:
			testCount++;
			Selection--;
			if ( Selection < 1 )
			{
				Selection=MenuLength;
			}
			if (! (Active[Selection] == 1) || (testCount > MenuLength) ) goto JL003A;
		}
		else
		{
			if ( KeyNum == 40 )
			{
				PlaySelectSound();
				testCount=0;
JL009E:
				Selection++;
				if ( Selection > MenuLength )
				{
					Selection=1;
				}
				if (! (Active[Selection] == 1) || (testCount > MenuLength) ) goto JL009E;
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
    HighMapNameBase="Level"
    LowMapNameBase="BLevel"
    MarginX=40
    MarginY=40
    MarginPercentX=0.08
    MarginPercentY=0.08
    HelpWidthPercent=0.70
    HelpHeightPercent=0.12
    UnusedSaveGameString="Not Used"
    NoServersString="No games are currently available"
    HelpMessage(1)=""
}