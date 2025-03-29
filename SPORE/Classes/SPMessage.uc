//================================================================================
// SPMessage.
//================================================================================
class SPMessage expands SPActor;

var() int MessageNumber;
var() bool bOnceOnly;
var bool bDone;

event Touch (Actor Other)
{
	local SPMessage M;

	if (  !bDone && (SPPlayer(Other) != None) )
	{
		Show();
	}
}

function Trigger (Actor Other, Pawn Instigator)
{
	if (  !bDone )
	{
		Show();
	}
}

function Show ()
{
	local SPMessage M;
	local SPPlayer P;

	foreach AllActors(Class'SPPlayer',P)
	{
		goto JL0014;
	}
	if ( P == None )
	{
		Log(string(self) $ "::Show <ERROR> Couldn't find SPPlayer!!!");
		return;
	}
	P.ShowMessage(MessageNumber);
	if ( bOnceOnly )
	{
		bDone=True;
		foreach AllActors(Class'SPMessage',M)
		{
			if ( M.MessageNumber == MessageNumber )
			{
				M.bDone=True;
			}
		}
	}
}

defaultproperties
{
    bHidden=True
    bCollideActors=True
}