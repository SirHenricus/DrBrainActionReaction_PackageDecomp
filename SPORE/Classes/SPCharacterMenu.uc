//================================================================================
// SPCharacterMenu.
//================================================================================
class SPCharacterMenu expands SPMenu
	abstract;

const MyAnimRate= 2.0;
const Separation= 0.02;
const BigHeight= 0.2;
const SmallHeight= 0.07;
var() config string Characters[20];
var() localized string NameString;
var() localized string AgeString;
var() localized string NationalityString;
var() localized string SpecialtyString;
var() localized string QuirksString;
var Font DataFont;
var Class<SPPlayer> CharacterClass;
var int CurCharacter;
var bool bSetup;

function Setup ()
{
	local int i;
	local Class<SPPlayer> PlayerClass;

	bSetup=True;
	i=0;
JL000F:
	if ( i < 20 )
	{
		PlayerClass=Class<SPPlayer>(DynamicLoadObject("Spore." $ Characters[i],Class'Class'));
		if ( PlayerClass != None )
		{
			if ( PlayerClass == PlayerOwner.Class )
			{
				CurCharacter=i;
				CharacterClass=PlayerClass;
			}
			else
			{
				i++;
				goto JL000F;
			}
		}
	}
	if ( CharacterClass == None )
	{
		CharacterClass=Class<SPPlayer>(DynamicLoadObject("Spore." $ Characters[0],Class'Class'));
		CurCharacter=0;
	}
	if ( CharacterClass != None )
	{
		Mesh=CharacterClass.Default.Mesh;
		Skin=CharacterClass.Default.Skin;
		DrawScale=Default.DrawScale * CharacterClass.Default.DrawScale;
		MenuValues[1]=CharacterClass.Default.CharacterName;
	}
}

function bool ProcessLeft ()
{
	local string charString;

	if ( Selection == 1 )
	{
		CurCharacter--;
		if ( CurCharacter < 0 )
		{
			CurCharacter=20 - 1;
JL0028:
			if ( (Characters[CurCharacter] == "") && (CurCharacter > 0) )
			{
				CurCharacter--;
				goto JL0028;
			}
		}
		charString="Spore." $ Characters[CurCharacter];
		CharacterClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		Mesh=CharacterClass.Default.Mesh;
		Skin=CharacterClass.Default.Skin;
		DrawScale=Default.DrawScale * CharacterClass.Default.DrawScale;
		MenuValues[1]=CharacterClass.Default.CharacterName;
	}
}

function bool ProcessRight ()
{
	local string charString;

	if ( Selection == 1 )
	{
		CurCharacter++;
		if ( (CurCharacter >= 20) || (Characters[CurCharacter] == "") )
		{
			CurCharacter=0;
		}
		charString="Spore." $ Characters[CurCharacter];
		CharacterClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		Mesh=CharacterClass.Default.Mesh;
		Skin=CharacterClass.Default.Skin;
		DrawScale=Default.DrawScale * CharacterClass.Default.DrawScale;
		MenuValues[1]=CharacterClass.Default.CharacterName;
	}
}

function MenuTick (float DeltaTime)
{
	local Rotator NewRot;
	local float RemainingTime;

	NewRot=Rotation;
	NewRot.Yaw += RotationRate.Yaw * DeltaTime;
	SetRotation(NewRot);
	RemainingTime=DeltaTime * 0.50;
JL0044:
	if ( RemainingTime > 0 )
	{
		if ( AnimFrame < 0 )
		{
			AnimFrame += TweenRate * RemainingTime;
			if ( AnimFrame > 0 )
			{
				RemainingTime=AnimFrame / TweenRate;
			}
			else
			{
				RemainingTime=0.00;
			}
		}
		else
		{
			AnimFrame += 2.00 * RemainingTime;
			if ( AnimFrame > 1 )
			{
				RemainingTime=(AnimFrame - 1) / 2.00;
				AnimFrame=0.00;
			}
			else
			{
				RemainingTime=0.00;
			}
		}
		goto JL0044;
	}
}

function DrawText (string Text, int X, int Y, int W, int H, Canvas C)
{
	local float xMargin;
	local float yMargin;
	local float saveOriginX;
	local float SaveOriginY;
	local float saveClipX;
	local float saveClipY;

	saveOriginX=C.OrgX;
	SaveOriginY=C.OrgY;
	saveClipX=C.ClipX;
	saveClipY=C.ClipY;
	xMargin=0.02 * ClipX;
	yMargin=0.01 * ClipY;
	X += xMargin;
	W -= xMargin * 2;
	Y += yMargin;
	H -= yMargin * 2;
	C.SetOrigin(X,Y);
	C.SetClip(W,H);
	C.SetPos(0.00,0.00);
	C.Super.DrawText(Text);
	C.SetOrigin(saveOriginX,SaveOriginY);
	C.SetClip(saveClipX,saveClipY);
}

function bool TextFits (string Text, int W, int H, Canvas C)
{
	local float xSize;
	local float ySize;
	local float xMargin;
	local float yMargin;
	local float saveClipX;
	local float saveClipY;

	saveClipX=C.ClipX;
	saveClipY=C.ClipY;
	xMargin=0.02 * ClipX;
	yMargin=0.01 * ClipY;
	W -= xMargin * 2;
	H -= yMargin * 2;
	C.SetClip(W,H);
	C.SetPos(0.00,0.00);
	C.StrLen(Text,xSize,ySize);
	C.SetClip(saveClipX,saveClipY);
	if ( (xSize > W) || (ySize > H) )
	{
		Log(string(self) $ "::TextFits <NOTE> '" $ Text $ "' doesn't fit...");
		Log("xSize=" $ string(xSize) $ ", width=" $ string(W) $ ", ySize=" $ string(ySize) $ ", height=" $ string(H));
		return False;
	}
	return True;
}

function ChooseFont (Canvas C)
{
	if (  !TryFont(Font'MBoxFontLarge',C) )
	{
		if (  !TryFont(Font'SPMediumFont',C) )
		{
			if (  !TryFont(Font'SPSmallFont',C) )
			{
				Log(string(self) $ "::ChooseFont <ERROR> Couldn't find a small enough font!!!");
			}
		}
	}
}

function bool TryFont (Font F, Canvas C)
{
	local int X;
	local int Y;
	local float W;
	local float H;
	local float S;
	local int i;
	local string charString;
	local Class<SPPlayer> charClass;

	DataFont=F;
	C.Font=DataFont;
	X=0.40 * ClipX;
	Y=0.10 * ClipY;
	W=ClipX - MarginX - X;
	H=0.07 * ClipY;
	i=0;
JL007B:
	if ( i < 20 )
	{
		if ( Characters[i] ~= "" )
		{
			goto JL0105;
		}
		charString="Spore." $ Characters[i];
		charClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		if (  !TextFits(NameString $ charClass.Default.CharacterName,W,H,C) )
		{
			return False;
		}
JL0105:
		i++;
		goto JL007B;
	}
	i=0;
JL0116:
	if ( i < 20 )
	{
		if ( Characters[i] ~= "" )
		{
			goto JL01A0;
		}
		charString="Spore." $ Characters[i];
		charClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		if (  !TextFits(AgeString $ charClass.Default.Age,W,H,C) )
		{
			return False;
		}
JL01A0:
		i++;
		goto JL0116;
	}
	i=0;
JL01B1:
	if ( i < 20 )
	{
		if ( Characters[i] ~= "" )
		{
			goto JL023B;
		}
		charString="Spore." $ Characters[i];
		charClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		if (  !TextFits(NationalityString $ charClass.Default.Nationality,W,H,C) )
		{
			return False;
		}
JL023B:
		i++;
		goto JL01B1;
	}
	H=0.20 * ClipY;
	i=0;
JL025F:
	if ( i < 20 )
	{
		if ( Characters[i] ~= "" )
		{
			goto JL02E9;
		}
		charString="Spore." $ Characters[i];
		charClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		if (  !TextFits(SpecialtyString $ charClass.Default.Specialties,W,H,C) )
		{
			return False;
		}
JL02E9:
		i++;
		goto JL025F;
	}
	i=0;
JL02FA:
	if ( i < 20 )
	{
		if ( Characters[i] ~= "" )
		{
			goto JL0384;
		}
		charString="Spore." $ Characters[i];
		charClass=Class<SPPlayer>(DynamicLoadObject(charString,Class'Class'));
		if (  !TextFits(QuirksString $ charClass.Default.Quirks,W,H,C) )
		{
			return False;
		}
JL0384:
		i++;
		goto JL02FA;
	}
	return True;
}

function DrawInfo (Canvas C)
{
	local int X;
	local int Y;
	local float W;
	local float H;
	local float S;

	if ( CharacterClass == None )
	{
		Log(string(self) $ "::DrawInfo <ERROR> CharacterClass is NONE!!!");
		return;
	}
	if ( DataFont != None )
	{
		C.Font=DataFont;
	}
	else
	{
		Log(string(self) $ "::DrawInfo <ERROR> DataFont is None!!!!");
		return;
	}
	S=0.02 * ClipY;
	X=0.40 * ClipX;
	Y=0.10 * ClipY;
	W=ClipX - MarginX - X;
	H=0.07 * ClipY;
	C.SetPos(X,Y);
	C.DrawRect(Texture'MenuBox',W,H);
	C.SetPos(X,Y);
	DrawText(NameString $ CharacterClass.Default.CharacterName,X,Y,W,H,C);
	Y=Y + H + S;
	C.SetPos(X,Y);
	C.DrawRect(Texture'MenuBox',W,H);
	C.SetPos(X,Y);
	DrawText(AgeString $ CharacterClass.Default.Age,X,Y,W,H,C);
	Y=Y + H + S;
	C.SetPos(X,Y);
	C.DrawRect(Texture'MenuBox',W,H);
	C.SetPos(X,Y);
	DrawText(NationalityString $ CharacterClass.Default.Nationality,X,Y,W,H,C);
	Y=Y + H + S;
	H=0.20 * ClipY;
	C.SetPos(X,Y);
	C.DrawRect(Texture'MenuBox',W,H);
	C.SetPos(X,Y);
	DrawText(SpecialtyString $ CharacterClass.Default.Specialties,X,Y,W,H,C);
	Y=Y + H + S;
	C.SetPos(X,Y);
	C.DrawRect(Texture'MenuBox',W,H);
	C.SetPos(X,Y);
	DrawText(QuirksString $ CharacterClass.Default.Quirks,X,Y,W,H,C);
}

function DrawMenu (Canvas Canvas)
{
	local int i;
	local int StartX;
	local int StartY;
	local int Spacing;
	local Vector DrawOffset;
	local Vector DrawLoc;
	local Rotator NewRot;
	local Rotator DrawRot;

	if (  !bSetup )
	{
		Setup();
	}
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
		ChooseFont(Canvas);
	}
	DrawInfo(Canvas);
	DrawHelpPanel(Canvas);
	if ( PlayerOwner.ViewTarget == None )
	{
		PlayerOwner.ViewRotation.Pitch=0;
		PlayerOwner.ViewRotation.Roll=0;
		DrawRot=PlayerOwner.ViewRotation;
		DrawOffset=vect(10.00,-5.00,0.00) >> PlayerOwner.ViewRotation;
		DrawLoc=PlayerOwner.Location + PlayerOwner.EyeHeight * vect(0.00,0.00,1.00);
	}
	else
	{
		DrawLoc=PlayerOwner.ViewTarget.Location;
		DrawRot=PlayerOwner.ViewTarget.Rotation;
		if ( Pawn(PlayerOwner.ViewTarget) != None )
		{
			if ( (Level.NetMode == 0) && (PlayerOwner.ViewTarget.IsA('PlayerPawn') || PlayerOwner.ViewTarget.IsA('Bot')) )
			{
				DrawRot=Pawn(PlayerOwner.ViewTarget).ViewRotation;
			}
			DrawLoc.Z += Pawn(PlayerOwner.ViewTarget).EyeHeight;
		}
	}
	DrawOffset=vect(10.00,-5.00,0.00) >> DrawRot;
	SetLocation(DrawLoc + DrawOffset);
	NewRot=DrawRot;
	NewRot.Yaw=Rotation.Yaw;
	SetRotation(NewRot);
	Canvas.DrawActor(self,False);
	CanvasClearZ(Canvas);
	SetFontBrightness(Canvas,True);
	Canvas.DrawActor(self,False);
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
	local int leftMargin;

	CurFont=F;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	HelpWidth=ClipX * HelpWidthPercent;
	HelpHeight=ClipY * HelpHeightPercent;
	C.Font=CurFont;
	leftMargin=0.37 * ClipX;
	MarginX=ClipX * MarginPercentX;
	MarginY=ClipY * MarginPercentY;
	C.StrLen(MenuTitle,xSize,ySize);
	FontHeight=ySize;
	TitleTop=MarginY;
	TitleLeft=MarginX + (ClipX - xSize - 2 * MarginX) / 2;
	HelpTop=ClipY - MarginY - HelpHeight;
	HelpLeft=MarginX + (ClipX - HelpWidth - 2 * MarginX) / 2;
	listMinY=TitleTop + 1.50 * FontHeight;
	listMaxY=HelpTop - FontHeight / 2;
	xMax=0.00;
	i=0;
JL0191:
	if ( i < MenuLength )
	{
		C.StrLen(MenuList[i + 1],xSize,ySize);
		if ( xSize > xMax )
		{
			xMax=xSize;
		}
		i++;
		goto JL0191;
	}
	if ( MaxMenuString != "" )
	{
		C.StrLen(MaxMenuString,xSize,ySize);
		if ( xSize > xMax )
		{
			xMax=xSize;
		}
	}
	ListSpacing=(listMaxY - listMinY) / MenuLength;
	ListLeft=leftMargin + (ClipX - xMax - leftMargin + MarginX) / 2;
	ListTop=(listMaxY - listMinY - MenuLength * ListSpacing) / 2 + listMinY;
	ValueStartX=0.68 * ClipX;
	if ( ListSpacing < 1.20 * FontHeight )
	{
		return False;
	}
	if ( ListLeft < leftMargin )
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
	return True;
}

defaultproperties
{
    Characters(0)="SPAkira"
    Characters(1)="SPAlyia"
    Characters(2)="SPPioa"
    Characters(3)="SPAna"
    Characters(4)="SPSean"
    NameString="Name: "
    AgeString="Age: "
    NationalityString="Nationality: "
    SpecialtyString="Specialties: "
    QuirksString="Quirks: "
    MaxMenuString="Character:  BrainPlayer"
    MenuLength=1
    MenuTitle="Choose A Character"
    Physics=PHYS_Walking
    AnimSequence=run
    AnimRate=2.00
    DrawType=DT_Sprite
    DrawScale=0.08
    bUnlit=True
    bFixedRotationDir=True
    RotationRate=(Pitch=0,Yaw=15000,Roll=0)
    DesiredRotation=(Pitch=0,Yaw=30000,Roll=0)
}