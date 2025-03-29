//================================================================================
// SPTransporter.
//================================================================================
class SPTransporter expands SPActor;

var() Vector Offset;
var() float Delay;

function Trigger (Actor Other, Pawn EventInstigator)
{
	if ( Delay <= 0 )
	{
		Transport();
	}
	else
	{
		SetTimer(Delay,False);
	}
	Disable('Trigger');
}

event Timer ()
{
	Transport();
}

function Transport ()
{
	local SPPlayer tempPlayer;

	foreach AllActors(Class'SPPlayer',tempPlayer)
	{
		if (  !tempPlayer.SetLocation(tempPlayer.Location + Offset) )
		{
			Log("Couldn't transport!");
		}
	}
}

defaultproperties
{
    bHidden=True
}