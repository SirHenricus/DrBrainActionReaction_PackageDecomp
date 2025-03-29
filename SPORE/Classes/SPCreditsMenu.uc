//================================================================================
// SPCreditsMenu.
//================================================================================
class SPCreditsMenu expands SPMenu;

const ListLength= 5;
var() localized string Names[100];
var() float ScrollTime;
var int TopItem;
var float LastUpdateTime;
var bool bFadingIn;
var bool bFadingOut;
var Color StringColor;
var float FadePercent;

event BeginPlay ()
{
	Selection=7;
	AdjustMenuItems();
	Super.BeginPlay();
	FadeIn();
}

function DrawListCentered (Canvas C)
{
	local int i;
	local int oldStyle;
	local int numDrawn;
	local Color oldColor;

	oldColor=C.DrawColor;
	oldStyle=C.Style;
	C.DrawColor.R=C.DrawColor.R * FadePercent;
	C.DrawColor.G=C.DrawColor.G * FadePercent;
	C.DrawColor.B=C.DrawColor.B * FadePercent;
	C.Font=CurFont;
	i=0;
JL00D4:
	if ( i < 5 )
	{
		if ( Active[i + 1] == 1 )
		{
			SetFontBrightness(C,i == Selection - 1);
			C.SetPos(ListLeft,ListTop + ListSpacing * numDrawn + (ListSpacing - FontHeight) / 2);
			if ( Active[i + 1] == 0 )
			{
				C.Style=3;
			}
			if ( (CurFont == Font'SPLargeFont') && (i < 5) )
			{
				C.Font=Font'MBoxFontLarge';
			}
			C.DrawText(MenuList[i + 1],False);
			C.Font=CurFont;
			C.Style=oldStyle;
			numDrawn++;
		}
		i++;
		goto JL00D4;
	}
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	C.SetPos(ListLeft,ListTop + ListSpacing * 6 + (ListSpacing - FontHeight) / 2);
	C.DrawText(MenuList[7],False);
	C.DrawColor=oldColor;
	DrawSelectionIndicator(C);
}

function DrawBackGround (Canvas C)
{
	Super.DrawBackGround(C);
	C.SetPos(MarginX,ListTop);
	C.DrawRect(Texture'BlackBackground',ClipX - MarginX * 2,ListSpacing * 5);
}

function FadeIn ()
{
	bFadingIn=True;
	bFadingOut=False;
	FadePercent=0.00;
}

function FadeOut ()
{
	bFadingIn=False;
	bFadingOut=True;
	FadePercent=1.00;
}

function AdjustMenuItems ()
{
	local int i;

	i=1;
JL0007:
	if ( i <= 5 )
	{
		if ( i - 1 + TopItem < 100 )
		{
			MenuList[i]=Names[i - 1 + TopItem];
		}
		else
		{
			MenuList[i]="";
		}
		i++;
		goto JL0007;
	}
}

event MenuTick (float Delta)
{
	if ( bFadingIn )
	{
		FadePercent += 0.05;
		if ( FadePercent >= 1.00 )
		{
			bFadingIn=False;
			LastUpdateTime=Level.TimeSeconds;
		}
		return;
	}
	if ( bFadingOut )
	{
		FadePercent -= 0.05;
		if ( FadePercent <= 0.00 )
		{
			bFadingOut=False;
			TopItem += 5;
			if ( Names[TopItem] == "" )
			{
				TopItem=0;
			}
			AdjustMenuItems();
			FadeIn();
		}
		return;
	}
	if ( Level.TimeSeconds - LastUpdateTime > ScrollTime )
	{
		FadeOut();
	}
}

function bool ProcessSelection ()
{
	local Menu ChildMenu;

	if ( Selection == 7 )
	{
		ChildMenu=Spawn(Class'SPCreditsPlayerMenu',Owner);
		SubMenu(ChildMenu);
	}
	return True;
}

function MenuProcessInput (byte KeyNum, byte ActionNum)
{
	if ( (KeyNum == 38) || (KeyNum == 40) )
	{
		goto JL0031;
	}
	Super.MenuProcessInput(KeyNum,ActionNum);
JL0031:
}

function SetFontBrightness (Canvas C, bool bBright)
{
}

defaultproperties
{
    Names(0)="Albert Harris MacLeod Reinhardt - Producer"
    Names(1)="Ari Schindler - Executive Producer"
    Names(3)="Marcus Smith - Level Designer & Writer"
    Names(4)="Stephen S. Park - Level Designer"
    Names(5)="Thomas M. Fiola - Lead Programmer"
    Names(7)="Anthony Cuccia - Programmer"
    Names(8)="Geoff Menegay - Programmer"
    Names(10)="Christopher Williams - Lead Artist"
    Names(12)="Jeremy Kromberg - Artist"
    Names(13)="Lee Crim - Artist"
    Names(15)="Robert Wallace II - Animator"
    Names(17)="Character Designers:"
    Names(18)="Glenn Seidel"
    Names(19)="Robert Wallace II"
    Names(20)="Bo Bennike - Sound Effects"
    Names(22)="Sound Engineers & Dialogue Editors:"
    Names(23)="Bo Bennike"
    Names(24)="Dana Norwood"
    Names(25)="Music Written and Produced by:"
    Names(26)="Giorgio Bertuccelli"
    Names(27)="Michael Skloff"
    Names(28)="Horn arrangements: Michael Skloff"
    Names(29)="Keyboard Arrangements: Giorgio Bertuccelli"
    Names(30)="Character Voices by:"
    Names(31)="Carol Bach-Y-Rita"
    Names(32)="Grey Delisle"
    Names(33)="Michael Gough"
    Names(34)="Neil Ross"
    Names(35)="Dan Kim - Install Programmer "
    Names(36)="LeVon Karayan - Install Programmer"
    Names(37)="Leonard Amabile - Technical Support Lead"
    Names(38)="Cathy Johnson - Documentation Manager"
    Names(39)="Jeff Lorentzen - Localization Advisor"
    Names(40)="Stewart Weiss - Marketing Brand Manager"
    Names(41)="Marla Capra - Public Relations Manager"
    Names(43)="Irene Lane - Consumer Research Lead"
    Names(44)="Angie Wallace - Consumer Research"
    Names(45)="Naren Renz - Quality Assurance Lead Tester"
    Names(46)="Quality Assurance Analysis Testers:"
    Names(47)="Anson Yip"
    Names(48)="Eric Simpson"
    Names(49)="Glenn Maskell"
    Names(50)="Quality Assurance Analysis Testers:"
    Names(51)="Hilarion Leyretana"
    Names(52)="Jae Y. Kim"
    Names(53)="Jason Perry"
    Names(54)="Jennifer Davis"
    Names(55)="Quality Assurance Analysis Testers:"
    Names(56)="Michael Reynolds"
    Names(57)="Michael Thibeau"
    Names(58)="Richard Arnold"
    Names(59)="Scott Collins"
    Names(60)="Quality Assurance Analysis Testers:"
    Names(61)="William Pham"
    Names(62)="Bill Knight"
    Names(63)="Chang Yi"
    Names(64)="Eric Newman"
    Names(65)="Quality Assurance Analysis Testers:"
    Names(66)="Jacob Alifrangis"
    Names(70)="Kids Advisory Team:"
    Names(71)="Dylan James Carr"
    Names(72)="Jeff Wagner"
    Names(73)="Joshua T. Stepp"
    Names(74)="Justin B. Pincar"
    Names(75)="Kids Advisory Team:"
    Names(76)="Keith Heacock"
    Names(77)="Mark Ciubal"
    Names(78)="Michael Ebelhar"
    Names(79)="Ryan H. Mayer"
    Names(80)="Kids Advisory Team:"
    Names(81)="Scott Ruygrok"
    Names(82)="Zachary Stone"
    Names(85)="Articulation Animation by:"
    Names(86)="Natural Speech Technologies"
    Names(87)="Special Thanks to:"
    Names(88)="the users of Unprog and Unedit"
    Names(89)="Mark Rein & Tim Sweeney at Epic Games"
    Names(90)="Special Thanks to:"
    Names(91)="Andy Maris, Cathy Kinzer,"
    Names(92)="Joe Eisner, Vincent Fung,"
    Names(93)="and William Wong at Intel"
    ScrollTime=3.00
    MenuLength=7
    MenuList(7)="Play Credits Level"
}