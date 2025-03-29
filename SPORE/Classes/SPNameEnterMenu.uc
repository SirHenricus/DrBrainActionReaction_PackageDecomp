//================================================================================
// SPNameEnterMenu.
//================================================================================
class SPNameEnterMenu expands SPMenu;

var() localized string TryAgainString;
var() localized string NameTakenString;
var string TempName;
var int playerIndex;
var bool bShowCursor;
var float LastCursorTime;
var() float CursorDelay;

event BeginPlay ()
{
	Super.BeginPlay();
	TempName="";
	PlayerOwner=FindPlayerOwner();
	if ( PlayerOwner != None )
	{
		PlayerOwner.Player.Console.GotoState('MenuTyping');
	}
	return;
}

event MenuTick (float D)
{
	if (  !PlayerOwner.Player.Console.IsInState('MenuTyping') )
	{
		PlayerOwner.Player.Console.GotoState('MenuTyping');
	}
	if ( Level.TimeSeconds - LastCursorTime > CursorDelay )
	{
		bShowCursor= !bShowCursor;
		LastCursorTime=Level.TimeSeconds;
	}
}

function bool NameTaken (string Name)
{
	local int i;

	i=1;
JL0007:
	if ( i <= 10 )
	{
		if ( Name ~= SPSignInMenu(ParentMenu).MenuList[i] )
		{
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function bool ProcessSelection ()
{
	local int i;
	local SPTextFilter Filter;

	Filter=Spawn(Class'SPTextFilter');
	if (  !Filter.TextAllowed(TempName) )
	{
		PlaySound(Sound'dronewosh',3);
		TempName="";
		MenuTitle=TryAgainString;
		ClipX=-1;
		ClipY=-1;
		PlayerOwner.Player.Console.GotoState('MenuTyping');
	}
	else
	{
		if ( NameTaken(TempName) )
		{
			PlaySound(Sound'dronewosh',3);
			TempName="";
			MenuTitle=NameTakenString;
			ClipX=-1;
			ClipY=-1;
			PlayerOwner.Player.Console.GotoState('MenuTyping');
		}
		else
		{
			if ( TempName != "" )
			{
				SPSignInMenu(ParentMenu).SetPlayerName(playerIndex,TempName);
				ExitMenu();
			}
		}
	}
	Filter.Destroy();
	return True;
}

function ProcessMenuInput (coerce string InputString)
{
	ProcessSelection();
}

function ProcessMenuUpdate (coerce string InputString)
{
	InputString=Left(InputString,15);
	TempName=InputString;
}

function ProcessMenuEscape ()
{
	PlayerOwner.Player.Console.GotoState('Menuing');
	ExitMenu();
}

function DrawMenu (Canvas Canvas)
{
	if ( bShowCursor )
	{
		MenuList[1]=TempName $ "_";
	}
	else
	{
		MenuList[1]=TempName;
	}
	Super.DrawMenu(Canvas);
}

defaultproperties
{
    TryAgainString="That name is not allowed. Try again."
    NameTakenString="That name is taken. Try again."
    CursorDelay=0.70
    MaxMenuString="ANTHONY JOHN CUCCIA"
    MenuLength=1
    HelpMessage(1)="Type your name and hit Enter (or hit Esc to cancel)"
    MenuTitle="TYPE YOUR NAME HERE:"
}