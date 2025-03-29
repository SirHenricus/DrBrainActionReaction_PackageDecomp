//================================================================================
// SPDoorIris.
//================================================================================
class SPDoorIris expands SPActor;

var(Sounds) Sound doorSound;
var() bool bInitiallyOpen;
var() bool bToggle;
var() bool bBumpOpen;
var() float StayOpenTime;
var bool bOpen;

event BeginPlay ()
{
	Super.BeginPlay();
	if ( bInitiallyOpen )
	{
		GotoState('Opening');
	}
}

event Bump (Actor Other)
{
	if ( bBumpOpen )
	{
		Activate();
	}
}

function Activate ()
{
	if ( bOpen )
	{
		GotoState('Closing');
	}
	else
	{
		GotoState('Opening');
	}
}

event Timer ()
{
	GotoState('Closing');
}

state Opening
{
	ignores  Activate;
	
Begin:
	bBlockActors=False;
	bBlockPlayers=False;
	bOpen=True;
	PlaySound(doorSound,3);
	PlayAnim('Open');
	FinishAnim();
	if (  !bToggle )
	{
		SetTimer(StayOpenTime,False);
	}
	GotoState('None');
}

state Closing
{
	ignores  Activate;
	
Begin:
	PlayAnim('Close');
	FinishAnim();
	bBlockActors=True;
	bBlockPlayers=True;
	bOpen=False;
	GotoState('None');
}

defaultproperties
{
    doorSound=Sound'Doors.dooropen'
    bToggle=True
    StayOpenTime=4.00
    DrawType=DT_Sprite
    Mesh=LodMesh'door3'
    DrawScale=8.00
    CollisionRadius=180.00
    CollisionHeight=250.00
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
}