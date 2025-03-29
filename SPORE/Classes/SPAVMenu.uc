//================================================================================
// SPAVMenu.
//================================================================================
class SPAVMenu expands SPMenu;

var() localized string LowText;
var() localized string HighText;
var() Texture SliderRect;
var() Texture Slider;
var() Texture SliderCapLeft;
var() Texture SliderCapRight;
var float Brightness;
var string CurrentRes;
var string AvailableRes;
var string Resolutions[16];
var int resNum;
var int SoundVol;
var bool bLowTextureDetail;
var bool bLowSoundQuality;

function DrawMenu (Canvas C)
{
	Brightness=float(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness"));
	SoundVol=int(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
	if ( CurrentRes == "" )
	{
		GetAvailableRes();
	}
	else
	{
		if ( AvailableRes == "" )
		{
			GetAvailableRes();
		}
	}
	bLowTextureDetail=PlayerOwner.ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail") != "High";
	if ( bLowTextureDetail )
	{
		MenuValues[4]=LowText;
	}
	else
	{
		MenuValues[4]=HighText;
	}
	bLowSoundQuality=bool(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality"));
	if ( bLowSoundQuality )
	{
		MenuValues[6]=LowText;
	}
	else
	{
		MenuValues[6]=HighText;
	}
	Super.DrawMenu(C);
	DrawValueSlider(C,1,Brightness,0.00,1.00,0.10);
	DrawValueSlider(C,5,SoundVol,0.00,255.00,32.00);
}

function DrawValueSlider (Canvas C, int menuIndex, float Value, float Min, float Max, float stepSize)
{
	local float TotalWidth;
	local float totalHeight;
	local float top;
	local float bottom;
	local float Left;
	local float capWidth;
	local float capHeight;
	local float barWidth;
	local float barHeight;
	local float barLeft;
	local float barRight;
	local float barTop;
	local float barBottom;
	local float sliderLeft;
	local float sliderTop;
	local float SliderWidth;
	local float sliderHeight;

	TotalWidth=ClipX - MarginX - ValueStartX;
	totalHeight=FontHeight;
	top=ListTop + ListSpacing * (menuIndex - 1) + (ListSpacing - FontHeight) / 2;
	bottom=top + totalHeight;
	Left=ValueStartX;
	capWidth=TotalWidth / 10;
	capHeight=totalHeight;
	barWidth=TotalWidth - 2 * capWidth;
	barHeight=1.00 * capHeight;
	barLeft=ValueStartX + capWidth;
	barRight=barLeft + barWidth;
	barTop=top + (totalHeight - barHeight) / 2;
	barBottom=barTop + barHeight;
	SliderWidth=stepSize / (Max - Min + stepSize) * barWidth;
	sliderHeight=1.00 * capHeight;
	sliderLeft=barLeft + Value / (Max - Min) * barWidth - SliderWidth / 2;
	sliderTop=top + (totalHeight - sliderHeight) / 2;
	if ( menuIndex == Selection )
	{
		SetFontBrightness(C,True);
	}
	C.Style=2;
	C.SetPos(barLeft,barTop);
	C.DrawRect(SliderRect,barWidth,barHeight);
	C.SetPos(Left,top);
	C.DrawRect(SliderCapLeft,capWidth,capHeight);
	C.SetPos(Left + TotalWidth - capWidth,top);
	C.DrawRect(SliderCapRight,capWidth,capHeight);
	C.SetPos(sliderLeft,sliderTop);
	C.DrawRect(Slider,SliderWidth,sliderHeight);
	SetFontBrightness(C,False);
}

function bool ProcessLeft ()
{
	if ( Selection == 1 )
	{
		Brightness=FMax(0.20,Brightness - 0.10);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness " $ string(Brightness));
		PlayerOwner.ConsoleCommand("FLUSH");
		return True;
	}
	else
	{
		if ( Selection == 3 )
		{
			resNum--;
			if ( resNum < 0 )
			{
				resNum=16 - 1;
JL00B4:
				if ( Resolutions[resNum] == "" )
				{
					resNum--;
					goto JL00B4;
				}
			}
			MenuValues[3]=Resolutions[resNum];
			return True;
		}
		else
		{
			if ( Selection == 4 )
			{
				bLowTextureDetail= !bLowTextureDetail;
				if ( bLowTextureDetail )
				{
					PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium");
				}
				else
				{
					PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High");
				}
				return True;
			}
			else
			{
				if ( Selection == 5 )
				{
					SoundVol=Max(0,SoundVol - 32);
					PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume " $ string(SoundVol));
					PlayerOwner.PlaySound(Sound'enter',3);
					return True;
				}
				else
				{
					if ( Selection == 6 )
					{
						bLowSoundQuality= !bLowSoundQuality;
						PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ string(bLowSoundQuality));
						return True;
					}
				}
			}
		}
	}
	return False;
}

function bool ProcessRight ()
{
	if ( Selection == 1 )
	{
		Brightness=FMin(1.00,Brightness + 0.10);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness " $ string(Brightness));
		PlayerOwner.ConsoleCommand("FLUSH");
		return True;
	}
	else
	{
		if ( Selection == 3 )
		{
			resNum++;
			if ( (resNum >= 16) || (Resolutions[resNum] == "") )
			{
				resNum=0;
			}
			MenuValues[3]=Resolutions[resNum];
			return True;
		}
		else
		{
			if ( Selection == 4 )
			{
				bLowTextureDetail= !bLowTextureDetail;
				if ( bLowTextureDetail )
				{
					PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium");
				}
				else
				{
					PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High");
				}
				return True;
			}
			else
			{
				if ( Selection == 5 )
				{
					SoundVol=Min(255,SoundVol + 32);
					PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume " $ string(SoundVol));
					PlayerOwner.PlaySound(Sound'enter',3);
					return True;
				}
				else
				{
					if ( Selection == 6 )
					{
						bLowSoundQuality= !bLowSoundQuality;
						PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ string(bLowSoundQuality));
						return True;
					}
				}
			}
		}
	}
	return False;
}

function bool ProcessSelection ()
{
	if ( Selection == 2 )
	{
		PlayerOwner.ConsoleCommand("TOGGLEFULLSCREEN");
		CurrentRes=PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return True;
	}
	else
	{
		if ( Selection == 3 )
		{
			PlayerOwner.ConsoleCommand("SetRes " $ MenuValues[3]);
			CurrentRes=PlayerOwner.ConsoleCommand("GetCurrentRes");
			GetAvailableRes();
			return True;
		}
	}
	return True;
}

function GetAvailableRes ()
{
	local int P;
	local int i;
	local string ParseString;

	AvailableRes=PlayerOwner.ConsoleCommand("GetRes");
	resNum=0;
	ParseString=AvailableRes;
	P=InStr(ParseString," ");
JL003F:
	if ( (resNum < 16) && (P != -1) )
	{
		Resolutions[resNum]=Left(ParseString,P);
		ParseString=Right(ParseString,Len(ParseString) - P - 1);
		P=InStr(ParseString," ");
		resNum++;
		goto JL003F;
	}
	Resolutions[resNum]=ParseString;
	i=resNum + 1;
JL00CB:
	if ( i < 16 )
	{
		Resolutions[i]="";
		i++;
		goto JL00CB;
	}
	CurrentRes=PlayerOwner.ConsoleCommand("GetCurrentRes");
	MenuValues[3]=CurrentRes;
	i=0;
JL0128:
	if ( i < resNum + 1 )
	{
		if ( MenuValues[3] ~= Resolutions[i] )
		{
			resNum=i;
			return;
		}
		i++;
		goto JL0128;
	}
	resNum=0;
	MenuValues[3]=Resolutions[0];
}

defaultproperties
{
    LowText="Low"
    HighText="High"
    SliderRect=Texture'Menu.SliderM'
    Slider=Texture'Menu.SliderBar'
    SliderCapLeft=Texture'Menu.SliderL'
    SliderCapRight=Texture'Menu.SliderR'
    MaxMenuString="Select Resolution       1200 X 1200"
    MenuLength=6
    HelpMessage(1)="Use the arrow keys to change the brighness of the screen"
    HelpMessage(2)="Use the arrow keys to switch between full screen and playing in a window"
    HelpMessage(3)="Use the arrow keys to change the screen resolution"
    HelpMessage(4)="Use the arrow keys to change the detail level of the textures"
    HelpMessage(5)="Use the arrow keys to change the sound volume"
    HelpMessage(6)="Use the arrow keys to change the sound quality"
    MenuList(1)="Brightness"
    MenuList(2)="Full Screen Mode"
    MenuList(3)="Select Resolution"
    MenuList(4)="Texture Detail"
    MenuList(5)="Sound Volume"
    MenuList(6)="Sound Quality"
    MenuTitle="GRAPHICS AND SOUND"
}