//================================================================================
// SPIntroHud.
//================================================================================
class SPIntroHud expands SPHud
	config(User);

var() localized string ESCMessage;
var() localized string EngineName;
var() localized string Copyright;
var() localized string Narration[10];
var int CurNarration;
var bool bCopyrightDone;
var bool bNarrationDone;
var float NarrationSpeed;

simulated event BeginPlay ()
{
	local PlayerPawn P;
	local int numNarrations;
	local int i;

	P=PlayerPawn(Owner);
	if ( P != None )
	{
		P.Player.Console.ClearMessages();
		P.ClientMessage(EngineName);
		P.ClientMessage(Copyright);
	}
	i=0;
JL006B:
	if ( i < 10 )
	{
		if ( Narration[i] != "" )
		{
			numNarrations++;
		}
		else
		{
			goto JL00A0;
		}
		i++;
		goto JL006B;
	}
JL00A0:
	NarrationSpeed=38.00 / numNarrations;
	SetTimer(6.50,False);
}

simulated event Timer ()
{
	if (  !bCopyrightDone )
	{
		bCopyrightDone=True;
		SetTimer(NarrationSpeed,True);
	}
	else
	{
		CurNarration++;
		if ( Narration[CurNarration] == "" )
		{
			bNarrationDone=True;
		}
	}
}

simulated function PostRender (Canvas Canvas)
{
	local PlayerPawn Player;

	HUDSetup(Canvas);
	Canvas.Style=1;
	Player=PlayerPawn(Owner);
	if ( Player != None )
	{
		if ( Player.bShowMenu )
		{
			if ( MainMenu == None )
			{
				CreateMenu();
			}
			if ( MainMenu != None )
			{
				MainMenu.DrawMenu(Canvas);
			}
			return;
		}
		else
		{
			if ( bCopyrightDone )
			{
				if ( bNarrationDone )
				{
					ShowESCMessage(Canvas);
				}
				else
				{
					ShowNarration(Canvas);
				}
			}
		}
		if ( Player.ProgressTimeOut > Level.TimeSeconds )
		{
			DisplayProgressMessage(Canvas);
		}
	}
}

function ShowESCMessage (Canvas C)
{
	ShowText(C,ESCMessage);
}

function ShowNarration (Canvas C)
{
	ShowText(C,Narration[CurNarration]);
}

function ShowText (Canvas C, string Text)
{
	local float xSize;
	local float ySize;

	C.bCenter=True;
	C.Font=Font'MBoxFontLarge';
	C.StrLen(Text,xSize,ySize);
	if ( ySize > C.ClipY / 4 )
	{
		C.Font=Font'SPMediumFont';
		C.StrLen(Text,xSize,ySize);
	}
	C.SetPos(0.00,C.ClipY - 2 * ySize);
	C.DrawText(Text);
	C.bCenter=False;
}

defaultproperties
{
    ESCMessage="Hit 'ESC' to Start"
    EngineName="Unreal Engine"
    Copyright="Licensed by Knowledge Adventure"
    Narration(0)="In the murky depths..."
    Narration(1)="A sinister plot unfolds..."
    Narration(2)="The fate of the world..."
    Narration(3)="Depends on one person..."
    Narration(4)="YOU!"
}