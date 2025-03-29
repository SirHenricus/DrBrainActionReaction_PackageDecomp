//================================================================================
// SPReplayMenu.
//================================================================================
class SPReplayMenu expands SPMenu;

var() localized string NoMapMessage;
var() localized string UnfinishedString;
var() int ListSize;
var int topOfList;
var string MapNames[60];
var int MapFinished[60];
var int NumMaps;

event BeginPlay ()
{
	local int i;
	local string played;
	local string finished;
	local SPPlayer P;

	P=FindPlayerOwner();
	if ( P == None )
	{
		Log("Error: Player is not an SPPlayer!");
		return;
	}
	NumMaps=0;
	i=0;
JL004C:
	if ( i < 60 )
	{
		played=P.GetPlayedLevelString(i);
		finished=P.GetFinishedLevelString(i);
		if ( Mid(played,P.CurPlayerIndex,1) ~= "X" )
		{
			MapNames[NumMaps]=P.GetLevelName(i);
			if ( Mid(finished,P.CurPlayerIndex,1) ~= "X" )
			{
				MapFinished[NumMaps]=1;
			}
			NumMaps++;
		}
		i++;
		goto JL004C;
	}
	AdjustMenuList();
	Super.BeginPlay();
}

function AdjustMenuList ()
{
	local int i;
	local int numItems;

	if ( NumMaps > 0 )
	{
		numItems=Min(ListSize,NumMaps);
		i=0;
JL0024:
		if ( i < numItems )
		{
			MenuList[i + 1]=MapNames[topOfList + i];
			if ( MapFinished[topOfList + i] == 0 )
			{
				MenuList[i + 1]=MenuList[i + 1] $ " " $ UnfinishedString;
			}
			i++;
			goto JL0024;
		}
		MenuLength=numItems;
	}
	else
	{
		MenuList[1]=NoMapMessage;
		MenuLength=1;
	}
}

function DrawScrollBar (Canvas C)
{
	local float visPercent;
	local float offsetPercent;
	local float vOffset;
	local float x1;
	local float x2;
	local float y1;
	local float y2;
	local float vDist;
	local float thumbSize;
	local float capWidth;
	local float capHeight;

	SetFontBrightness(C,True);
	C.Style=2;
	vDist=ListSize * ListSpacing;
	x1=ClipX - ListLeft - 1.50 * FontHeight + 0.05 * ClipX;
	x2=x1 + 0.05 * ClipX;
	y1=ListTop;
	y2=ListTop + vDist;
	if ( NumMaps > 0 )
	{
		visPercent=ListSize / NumMaps;
	}
	else
	{
		visPercent=1.00;
	}
	C.SetPos(x1,y1);
	C.DrawRect(Texture'ScrollM',x2 - x1,y2 - y1);
	capWidth=x2 - x1;
	capHeight=0.05 * ClipY;
	C.SetPos(x1,y1 - capHeight);
	C.DrawRect(Texture'ScrollT',capWidth,capHeight);
	C.SetPos(x1,y2);
	C.DrawRect(Texture'ScrollB',capWidth,capHeight);
	thumbSize=Clamp(visPercent * vDist,4,vDist);
	offsetPercent=topOfList / NumMaps;
	vOffset=Clamp(offsetPercent * vDist,0,vDist);
	x1 += 0.10 * capWidth;
	x2 -= 0.10 * capWidth;
	y1 += vOffset + 2;
	y2=Clamp(y1 + thumbSize,y1,ListTop + vDist - 2);
	C.SetPos(x1,y1);
	C.DrawRect(Texture'ScrollBar',x2 - x1,y2 - y1);
}

function bool ProcessSelection ()
{
	local SPPlayer P;
	local int i;
	local int MapNum;
	local string MapName;
	local bool bFoundMap;

	P=SPPlayer(PlayerOwner);
	if ( P == None )
	{
		Log("Error: SPNewGameMenu::ProcessSelection, Player is not an SPPlayer!");
		return True;
	}
	i=0;
JL006A:
	if ( i < 60 )
	{
		if ( MapNames[topOfList + Selection - 1] == P.GetLevelName(i) )
		{
			if ( MapNames[topOfList + Selection - 1] == "" )
			{
				goto JL0173;
			}
			MapNum=i + 1;
			if ( Level.bEnhancedContent )
			{
				MapName=HighMapNameBase;
			}
			else
			{
				MapName=LowMapNameBase;
			}
			if ( MapNum < 10 )
			{
				MapName=MapName $ "00" $ string(MapNum);
			}
			else
			{
				if ( MapNum < 100 )
				{
					MapName=MapName $ "0" $ string(MapNum);
				}
				else
				{
					MapName=MapName $ string(MapNum);
				}
			}
			bFoundMap=True;
		}
		else
		{
			i++;
			goto JL006A;
		}
	}
JL0173:
	if ( bFoundMap )
	{
		if ( SPConsole(PlayerOwner.Player.Console) != None )
		{
			SPConsole(PlayerOwner.Player.Console).NextLevel=P.GetLevelName(MapNum - 1);
		}
		P.ClientTravel(MapName $ "#?peer",0,False);
		return True;
	}
	else
	{
		ExitMenu();
	}
	return True;
}

function MenuProcessInput (byte KeyNum, byte ActionNum)
{
	if ( KeyNum == 38 )
	{
		PlaySelectSound();
		if ( Selection > 1 )
		{
			Selection--;
		}
		else
		{
			if ( topOfList > 0 )
			{
				topOfList--;
			}
		}
	}
	else
	{
		if ( KeyNum == 40 )
		{
			PlaySelectSound();
			if ( Selection < MenuLength )
			{
				Selection++;
			}
			else
			{
				if ( topOfList + Selection < NumMaps )
				{
					topOfList++;
				}
			}
		}
		else
		{
			Super.MenuProcessInput(KeyNum,ActionNum);
		}
	}
}

function DrawMenu (Canvas Canvas)
{
	local int i;

	MenuLength=ListSize;
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
	AdjustMenuList();
	Super.DrawMenu(Canvas);
	if ( NumMaps > 0 )
	{
		DrawScrollBar(Canvas);
	}
}

defaultproperties
{
    NoMapMessage="You have not played any maps yet"
    UnfinishedString="(Unfinished)"
    ListSize=6
    MarginPercentX=0.15
    MaxMenuString="42: Threading The Needle (Unfinished)"
    MenuTitle="CHOOSE A LEVEL"
}